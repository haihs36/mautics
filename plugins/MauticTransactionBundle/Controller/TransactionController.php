<?php

namespace MauticPlugin\MauticTransactionBundle\Controller;

use Doctrine\DBAL\Exception\ForeignKeyConstraintViolationException;
use Doctrine\ORM\EntityNotFoundException;
use Mautic\CoreBundle\Controller\FormController;
use Mautic\CoreBundle\Factory\PageHelperFactoryInterface;
use Mautic\CoreBundle\Helper\InputHelper;
use Mautic\LeadBundle\Entity\Tag;
use Mautic\LeadBundle\Form\Type\CompanyMergeType;
use Mautic\LeadBundle\Model\CompanyModel;
use Mautic\LeadBundle\Model\TagModel;
use MauticPlugin\MauticTransactionBundle\Entity\Transaction;
use MauticPlugin\MauticTransactionBundle\Model\TransactionModel;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\Exception\AccessDeniedException;

class TransactionController extends FormController
{
	/*update*/
    /**
     * Generate's default list view.
     *
     * @param int $page
     *
     * @return JsonResponse|Response
     */
    public function indexAction($page = 1)
    {
        //set some permissions
        $permissions = $this->get('mautic.security')->isGranted(
            [
                'lead:leads:viewown',
                'lead:leads:viewother',
                'lead:leads:create',
                'lead:leads:editother',
                'lead:leads:editown',
                'lead:leads:deleteown',
                'lead:leads:deleteother',
            ],
            'RETURN_ARRAY'
        );

        if (!$permissions['lead:leads:viewother'] && !$permissions['lead:leads:viewown']) {
            return $this->accessDenied();
        }

        $this->setListFilters();

        /** @var PageHelperFactoryInterface $pageHelperFacotry */
        $pageHelperFacotry = $this->get('mautic.page.helper.factory');
        $pageHelper        = $pageHelperFacotry->make('mautic.transaction', $page);

        $limit      = $pageHelper->getLimit();
        $start      = $pageHelper->getStart();
        $search     = $this->request->get('search', $this->get('session')->get('mautic.transaction.filter', ''));
        $filter     = ['string' => $search, 'force' => []];
        $orderBy    = $this->get('session')->get('mautic.transaction.orderby', 't.name');
        $orderByDir = $this->get('session')->get('mautic.transaction.orderbydir', 'ASC');

      
        $transactions = $this->getModel('transaction')->getEntities(
            [
                'start'          => $start,
                'limit'          => $limit,
                'filter'         => $filter,
                'orderBy'        => $orderBy,
                'orderByDir'     => $orderByDir,
                'withTotalCount' => true,
            ]
        );

        $this->get('session')->set('mautic.transaction.filter', $search);

        $count     = $transactions['count'];
        $transactions = $transactions['results'];

        if ($count && $count < ($start + 1)) {
            $lastPage  = $pageHelper->countPage($count);
            $returnUrl = $this->generateUrl('mautic_transaction_index', ['page' => $lastPage]);
            $pageHelper->rememberPage($lastPage);

            return $this->postActionRedirect(
                [
                    'returnUrl'       => $returnUrl,
                    'viewParameters'  => ['page' => $lastPage],
                    'contentTemplate' => 'MauticTransactionBundle:Transaction:index',
                    'passthroughVars' => [
                        'activeLink'    => '#mautic_transaction_index',
                        'mauticContent' => 'transaction',
                    ],
                ]
            );
        }

        $pageHelper->rememberPage($page);

        $tmpl       = $this->request->isXmlHttpRequest() ? $this->request->get('tmpl', 'index') : 'index';

        return $this->delegateView(
            [
                'viewParameters' => [
                    'searchValue' => $search,
                    'items'       => $transactions,
                    'page'        => $page,
                    'limit'       => $limit,
                    'permissions' => $permissions,
                    'tmpl'        => $tmpl,
                    'totalItems'  => $count,
                ],
                'contentTemplate' => 'MauticTransactionBundle:Transaction:list.html.php',
                'passthroughVars' => [
                    'activeLink'    => '#mautic_transaction_index',
                    'mauticContent' => 'transaction',
                    'route'         => $this->generateUrl('mautic_transaction_index', ['page' => $page]),
                ],
            ]
        );
    }

    /**
     * Generate's new form and processes post data.
     *
     * @return JsonResponse|RedirectResponse|Response
     */
    public function newAction($entity = null)
    {
        $model = $this->getModel('transaction');

        if (!($entity instanceof Transaction)) {
            /** @var Transaction $entity */
            $entity = $model->getEntity();
        }

        if (!$this->get('mautic.security')->isGranted('lead:leads:create')) {
            return $this->accessDenied();
        }

        //set the page we came from
        $page         = $this->get('session')->get('mautic.transaction.page', 1);
        $method       = $this->request->getMethod();
        $action       = $this->generateUrl('mautic_transaction_action', ['objectAction' => 'new']);
        $transaction      = $this->request->request->get('transaction', []);
        $updateSelect = InputHelper::clean(
            'POST' === $method
                ? ($transaction['updateSelect'] ?? false)
                : $this->request->get('updateSelect', false)
        );

        $fields = $this->getModel('lead.field')->getPublishedFieldArrays('transaction');
        $form   = $model->createForm($entity, $this->get('form.factory'), $action, ['fields' => $fields, 'update_select' => $updateSelect]);

        $viewParameters = ['page' => $page];
        $returnUrl      = $this->generateUrl('mautic_transaction_index', $viewParameters);
        $template       = 'MauticTransactionBundle:Transaction:index';

        ///Check for a submitted form and process it
        if ('POST' == $this->request->getMethod()) {
            $valid = false;
            if (!$cancelled = $this->isFormCancelled($form)) {
                if ($valid = $this->isFormValid($form)) {
                    //form is valid so process the data
                    //get custom field values
                    $data = $this->request->request->get('transaction');
                    //pull the data from the form in order to apply the form's formatting
                    foreach ($form as $f) {
                        $data[$f->getName()] = $f->getData();
                    }
                    $model->setFieldValues($entity, $data, true);
                    //form is valid so process the data
                    $model->saveEntity($entity);

                    $this->addFlash(
                        'mautic.core.notice.created',
                        [
                            '%name%'      => $entity->getName(),
                            '%menu_link%' => 'mautic_transaction_index',
                            '%url%'       => $this->generateUrl(
                                'mautic_transaction_action',
                                [
                                    'objectAction' => 'edit',
                                    'objectId'     => $entity->getId(),
                                ]
                            ),
                        ]
                    );

                    if ($form->get('buttons')->get('save')->isClicked()) {
                        $returnUrl = $this->generateUrl('mautic_transaction_index', $viewParameters);
                        $template  = 'MauticTransactionBundle:Transaction:index';
                    } else {
                        //return edit view so that all the session stuff is loaded
                        return $this->editAction($entity->getId(), true);
                    }
                }
            }

            $passthrough = [
                'activeLink'    => '#mautic_transaction_index',
                'mauticContent' => 'transaction',
            ];

            // Check to see if this is a popup
            if (!empty($form['updateSelect'])) {
                $template    = false;
                $passthrough = array_merge(
                    $passthrough,
                    [
                        'updateSelect' => $form['updateSelect']->getData(),
                        'id'           => $entity->getId(),
                        'name'         => $entity->getName(),
                    ]
                );
            }

            if ($cancelled || ($valid && $form->get('buttons')->get('save')->isClicked())) {
                return $this->postActionRedirect(
                    [
                        'returnUrl'       => $returnUrl,
                        'viewParameters'  => $viewParameters,
                        'contentTemplate' => $template,
                        'passthroughVars' => $passthrough,
                    ]
                );
            }
        }

        $fields = $model->organizeFieldsByGroup($fields);
        $groups = array_keys($fields);
        sort($groups);
        $template = 'MauticTransactionBundle:Transaction:form_'.($this->request->get('modal', false) ? 'embedded' : 'standalone').'.html.php';

        return $this->delegateView(
            [
                'viewParameters' => [
                    'tmpl'   => $this->request->isXmlHttpRequest() ? $this->request->get('tmpl', 'index') : 'index',
                    'entity' => $entity,
                    'form'   => $form->createView(),
                    'fields' => $fields,
                    'groups' => $groups,
                ],
                'contentTemplate' => $template,
                'passthroughVars' => [
                    'activeLink'    => '#mautic_transaction_index',
                    'mauticContent' => 'transaction',
                    'updateSelect'  => ('POST' == $this->request->getMethod()) ? $updateSelect : null,
                    'route'         => $this->generateUrl(
                        'mautic_transaction_action',
                        [
                            'objectAction' => (!empty($valid) ? 'edit' : 'new'), //valid means a new form was applied
                            'objectId'     => $entity->getId(),
                        ]
                    ),
                ],
            ]
        );
    }

    /**
     * Generates edit form and processes post data.
     *
     * @param int  $objectId
     * @param bool $ignorePost
     *
     * @return JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse|Response
     */
    public function editAction($objectId, $ignorePost = false)
    {
        $model  = $this->getModel('transaction');
        $entity = $model->getEntity($objectId);

        //set the page we came from
        $page = $this->get('session')->get('mautic.transaction.page', 1);

        $viewParameters = ['page' => $page];

        //set the return URL
        $returnUrl = $this->generateUrl('mautic_transaction_index', ['page' => $page]);

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'viewParameters'  => $viewParameters,
            'contentTemplate' => 'MauticTransactionBundle:Transaction:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'mauticContent' => 'transaction',
            ],
        ];

        //form not found
        if (null === $entity) {
            return $this->postActionRedirect(
                array_merge(
                    $postActionVars,
                    [
                        'flashes' => [
                            [
                                'type'    => 'error',
                                'msg'     => 'mautic.transaction.error.notfound',
                                'msgVars' => ['%id%' => $objectId],
                            ],
                        ],
                    ]
                )
            );
        } elseif (!$this->get('mautic.security')->hasEntityAccess(
            'lead:leads:editown',
            'lead:leads:editother',
            $entity->getOwner())) {
            return $this->accessDenied();
        } elseif ($model->isLocked($entity)) {
            //deny access if the entity is locked
            return $this->isLocked($postActionVars, $entity, 'transaction');
        }

        $action       = $this->generateUrl('mautic_transaction_action', ['objectAction' => 'edit', 'objectId' => $objectId]);
        $method       = $this->request->getMethod();
        $transaction      = $this->request->request->get('transaction', []);
        $updateSelect = 'POST' === $method
            ? ($transaction['updateSelect'] ?? false)
            : $this->request->get('updateSelect', false);

        $fields = $this->getModel('lead.field')->getPublishedFieldArrays('transaction');
        $form   = $model->createForm(
            $entity,
            $this->get('form.factory'),
            $action,
            ['fields' => $fields, 'update_select' => $updateSelect]
        );

        ///Check for a submitted form and process it
        if (!$ignorePost && 'POST' === $method) {
            $valid = false;

            if (!$cancelled = $this->isFormCancelled($form)) {
                if ($valid = $this->isFormValid($form)) {
                    $data = $this->request->request->get('transaction');
                    //pull the data from the form in order to apply the form's formatting
                    foreach ($form as $f) {
                        $data[$f->getName()] = $f->getData();
                    }

                    $model->setFieldValues($entity, $data, true);

                    //form is valid so process the data
                    $model->saveEntity($entity, $form->get('buttons')->get('save')->isClicked());

                    $this->addFlash(
                        'mautic.core.notice.updated',
                        [
                            '%name%'      => $entity->getName(),
                            '%menu_link%' => 'mautic_transaction_index',
                            '%url%'       => $this->generateUrl(
                                'mautic_transaction_action',
                                [
                                    'objectAction' => 'view',
                                    'objectId'     => $entity->getId(),
                                ]
                            ),
                        ]
                    );

                    if ($form->get('buttons')->get('save')->isClicked()) {
                        $returnUrl = $this->generateUrl('mautic_transaction_index', $viewParameters);
                        $template  = 'MauticTransactionBundle:Transaction:index';
                    }
                }
            } else {
                //unlock the entity
                $model->unlockEntity($entity);

                $returnUrl = $this->generateUrl('mautic_transaction_index', $viewParameters);
                $template  = 'MauticTransactionBundle:Transaction:index';
            }

            $passthrough = [
                'activeLink'    => '#mautic_transaction_index',
                'mauticContent' => 'transaction',
            ];

            // Check to see if this is a popup
            if (!empty($form['updateSelect'])) {
                $template    = false;
                $passthrough = array_merge(
                    $passthrough,
                    [
                        'updateSelect' => $form['updateSelect']->getData(),
                        'id'           => $entity->getId(),
                        'name'         => $entity->getName(),
                    ]
                );
            }

            if ($cancelled || ($valid && $form->get('buttons')->get('save')->isClicked())) {
                return $this->postActionRedirect(
                    [
                        'returnUrl'       => $returnUrl,
                        'viewParameters'  => $viewParameters,
                        'contentTemplate' => $template,
                        'passthroughVars' => $passthrough,
                    ]
                );
            } elseif ($valid) {
                // Refetch and recreate the form in order to populate data manipulated in the entity itself
                $transaction = $model->getEntity($objectId);
                $form    = $model->createForm($transaction, $this->get('form.factory'), $action, ['fields' => $fields, 'update_select' => $updateSelect]);
            }
        } else {
            //lock the entity
            $model->lockEntity($entity);
        }

        $fields = $model->organizeFieldsByGroup($fields);
        $groups = array_keys($fields);
        sort($groups);
        $template = 'MauticTransactionBundle:Transaction:form_'.($this->request->get('modal', false) ? 'embedded' : 'standalone').'.html.php';

        return $this->delegateView(
            [
                'viewParameters' => [
                    'tmpl'   => $this->request->isXmlHttpRequest() ? $this->request->get('tmpl', 'index') : 'index',
                    'entity' => $entity,
                    'form'   => $form->createView(),
                    'fields' => $fields,
                    'groups' => $groups,
                ],
                'contentTemplate' => $template,
                'passthroughVars' => [
                    'activeLink'    => '#mautic_transaction_index',
                    'mauticContent' => 'transaction',
                    'updateSelect'  => InputHelper::clean($this->request->query->get('updateSelect')),
                    'route'         => $this->generateUrl(
                        'mautic_transaction_action',
                        [
                            'objectAction' => 'edit',
                            'objectId'     => $entity->getId(),
                        ]
                    ),
                ],
            ]
        );
    }

    /**
     * Create modifying response for tags - edit.
     *
     * @param string $action
     * @param bool   $ignorePost
     *
     * @return Response
     */
    private function createTagModifyResponse(Tag $tag, array $postActionVars, $action, $ignorePost)
    {
        /** @var TagModel $tagModel */
        $tagModel = $this->getModel('transaction.tag');

        /** @var FormInterface $form */
        $form = $tagModel->createForm($tag, $this->get('form.factory'), $action);

        ///Check for a submitted form and process it
        if (!$ignorePost && 'POST' == $this->request->getMethod()) {
            if (!$cancelled = $this->isFormCancelled($form)) {
                if ($this->isFormValid($form)) {
                    // We are editing existing tag.in the database.
                    $valid        = true;
                    $existingTags = $tagModel->getRepository()->getTagsByName([$tag->getTag()]);
                    foreach ($existingTags as $e) {
                        if ($e->getId() != $tag->getId()) {
                            $valid = false;
                            break;
                        }
                    }

                    if (!$valid) {
                        $this->addFlash('mautic.core.notice.updated', [
                            '%name%'      => $tag->getTag(),
                            '%menu_link%' => 'mautic_transaction_index',
                            '%url%'       => $this->generateUrl('mautic_transaction_action', [
                                'objectAction' => 'edit',
                                'objectId'     => $tag->getId(),
                            ]),
                        ]);
                    } else {
                        //form is valid so process the data
                        $tagModel->saveEntity($tag, $form->get('buttons')->get('save')->isClicked());

                        $this->addFlash('mautic.core.notice.updated', [
                            '%name%'      => $tag->getTag(),
                            '%menu_link%' => 'mautic_transaction_index',
                            '%url%'       => $this->generateUrl('mautic_transaction_action', [
                                'objectAction' => 'edit',
                                'objectId'     => $tag->getId(),
                            ]),
                        ]);
                    }

                    if ($form->get('buttons')->get('apply')->isClicked()) {
                        $contentTemplate                     = 'MauticTransactionBundle:Transaction:form.html.php';
                        $postActionVars['contentTemplate']   = $contentTemplate;
                        $postActionVars['forwardController'] = false;
                        $postActionVars['returnUrl']         = $this->generateUrl('mautic_transaction_action', [
                            'objectAction' => 'edit',
                            'objectId'     => $tag->getId(),
                        ]);

                        // Re-create the form once more with the fresh tag and action.
                        // The alias was empty on redirect after cloning.
                        $editAction = $this->generateUrl('mautic_transaction_action', ['objectAction' => 'edit', 'objectId' => $tag->getId()]);
                        $form       = $tagModel->createForm($tag, $this->get('form.factory'), $editAction);

                        $postActionVars['viewParameters'] = [
                            'objectAction' => 'edit',
                            'entity'       => $tag,
                            'objectId'     => $tag->getId(),
                            'form'         => $this->setFormTheme($form, $contentTemplate, 'MauticTransactionBundle:FormTheme\Filter'),
                        ];

                        return $this->postActionRedirect($postActionVars);
                    } else {
                        return $this->viewAction($tag->getId());
                    }
                }
            }

            if ($cancelled) {
                return $this->postActionRedirect($postActionVars);
            }
        }

        return $this->delegateView([
            'viewParameters' => [
                'form'       => $form->createView(),
                'entity'     => $tag,
                'currentTag' => $tag->getId(),
            ],
            'contentTemplate' => 'MauticTransactionBundle:Transaction:form.html.php',
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'route'         => $action,
                'mauticContent' => 'transaction',
            ],
        ]);
    }

    /**
     * Return tag if exists and user has access.
     *
     * @param int $tagId
     *
     * @return Tag
     *
     * @throws EntityNotFoundException
     * @throws AccessDeniedException
     */
    private function getTag($tagId)
    {
        /** @var Tag $tag */
        $tag = $this->getModel('lead.tag')->getEntity($tagId);

        // Check if exists
        if (!$tag instanceof Tag) {
            throw new EntityNotFoundException(sprintf('Tag with id %d not found.', $tagId));
        }

        return $tag;
    }

    /**
     * Get variables for POST action.
     *
     * @param null $objectId
     *
     * @return array
     */
    private function getPostActionVars($objectId = null)
    {
        //set the return URL
        if ($objectId) {
            $returnUrl       = $this->generateUrl('mautic_transaction_action', ['objectAction' => 'view', 'objectId'=> $objectId]);
            $viewParameters  = ['objectAction' => 'view', 'objectId'=> $objectId];
            $contentTemplate = 'MauticTransactionBundle:Transaction:view';
        } else {
            //set the page we came from
            $page            = $this->get('session')->get('mautic.transaction.page', 1);
            $returnUrl       = $this->generateUrl('mautic_transaction_index', ['page' => $page]);
            $viewParameters  = ['page' => $page];
            $contentTemplate = 'MauticTransactionBundle:Transaction:index';
        }

        return [
            'returnUrl'       => $returnUrl,
            'viewParameters'  => $viewParameters,
            'contentTemplate' => $contentTemplate,
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'mauticContent' => 'transaction',
            ],
        ];
    }

    /**
     * Loads a specific transaction into the detailed panel.
     *
     * @param $objectId
     *
     * @return \Symfony\Component\HttpFoundation\JsonResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function viewAction($objectId)
    {
        /** @var Transaction $model */
        $model  = $this->getModel('transaction');

        // When we change company data these changes get cached
        // so we need to clear the entity manager
        $model->getRepository()->clear();

        /** @var Transaction $transaction */
        $transaction = $model->getEntity($objectId);

        //set some permissions
        $permissions = $this->get('mautic.security')->isGranted(
            [
                'lead:leads:viewown',
                'lead:leads:viewother',
                'lead:leads:create',
                'lead:leads:editown',
                'lead:leads:editother',
                'lead:leads:deleteown',
                'lead:leads:deleteother',
            ],
            'RETURN_ARRAY'
        );

        //set the return URL
        $returnUrl = $this->generateUrl('mautic_transaction_index');

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'contentTemplate' => 'MauticTransactionBundle:Transaction:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'mauticContent' => 'transaction',
            ],
        ];

        if (null === $transaction) {
            return $this->postActionRedirect(
                array_merge(
                    $postActionVars,
                    [
                        'flashes' => [
                            [
                                'type'    => 'error',
                                'msg'     => 'mautic.transaction.error.notfound',
                                'msgVars' => ['%id%' => $objectId],
                            ],
                        ],
                    ]
                )
            );
        }

        if (!$this->get('mautic.security')->hasEntityAccess(
            'lead:leads:viewown',
            'lead:leads:viewother',
            $transaction->getPermissionUser()
        )
        ) {
            return $this->accessDenied();
        }

        $fields         = $transaction->getFields();
        $companiesRepo  = $model->getTransactionLeadRepository();
        $contacts       = $companiesRepo->getTransactionLeads($objectId);

        $leadIds = array_column($contacts, 'lead_id');

        $engagementData = is_array($contacts) ? $this->getTransactionEngagementsForGraph($contacts) : [];

        $contacts = $this->getTransactionContacts($objectId, null, $leadIds);

        return $this->delegateView(
            [
                'viewParameters' => [
                    'transaction'           => $transaction,
                    'fields'            => $fields,
                    'items'             => $contacts['items'],
                    'permissions'       => $permissions,
                    'engagementData'    => $engagementData,
                    'security'          => $this->get('mautic.security'),
                    'page'              => $contacts['page'],
                    'totalItems'        => $contacts['count'],
                    'limit'             => $contacts['limit'],
                ],
                'contentTemplate' => 'MauticLeadBundle:Transaction:transaction.html.php',
            ]
        );
    }


    /**
     * Deletes the entity.
     *
     * @param int $objectId
     *
     * @return JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteAction($objectId)
    {
        $page      = $this->get('session')->get('mautic.transaction.page', 1);
        $returnUrl = $this->generateUrl('mautic_transaction_index', ['page' => $page]);
        $flashes   = [];

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'viewParameters'  => ['page' => $page],
            'contentTemplate' => 'MauticTransactionBundle:Transaction:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'mauticContent' => 'transaction',
            ],
        ];

        if ('POST' == $this->request->getMethod()) {
            $model  = $this->getModel('transaction');
            $entity = $model->getEntity($objectId);

            if (null === $entity) {
                $flashes[] = [
                    'type'    => 'error',
                    'msg'     => 'mautic.transaction.error.notfound',
                    'msgVars' => ['%id%' => $objectId],
                ];
            } elseif (!$this->get('mautic.security')->isGranted('lead:leads:deleteother')) {
                return $this->accessDenied();
            } elseif ($model->isLocked($entity)) {
                return $this->isLocked($postActionVars, $entity, 'transaction');
            }

            $model->deleteEntity($entity);

            $flashes[] = [
                'type'    => 'notice',
                'msg'     => 'mautic.core.notice.deleted',
                'msgVars' => [
                    '%name%' => $entity->getName(),
                    '%id%'   => $objectId,
                ],
            ];
        } //else don't do anything

        return $this->postActionRedirect(
            array_merge(
                $postActionVars,
                [
                    'flashes' => $flashes,
                ]
            )
        );
    }

    /**
     * Deletes a group of entities.
     *
     * @return JsonResponse|RedirectResponse
     */
    public function batchDeleteAction()
    {
        $page      = $this->get('session')->get('mautic.transaction.page', 1);
        $returnUrl = $this->generateUrl('mautic_transaction_index', ['page' => $page]);
        $flashes   = [];

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'viewParameters'  => ['page' => $page],
            'contentTemplate' => 'MauticTransactionBundle:Transaction:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'mauticContent' => 'transaction',
            ],
        ];

        if ('POST' == $this->request->getMethod()) {
            /** @var ListModel $model */
            $model           = $this->getModel('lead.tag');
            $ids             = json_decode($this->request->query->get('ids', '{}'));
            $deleteIds       = [];

            // Loop over the IDs to perform access checks pre-delete
            foreach ($ids as $objectId) {
                $entity = $model->getEntity($objectId);

                if (null === $entity) {
                    $flashes[] = [
                        'type'    => 'error',
                        'msg'     => 'mautic.transaction.error.notfound',
                        'msgVars' => ['%id%' => $objectId],
                    ];
                } elseif (!$this->get('mautic.security')->isGranted('transaction:transaction:delete')) {
                    $flashes[] = $this->accessDenied(true);
                } else {
                    $deleteIds[] = $objectId;
                }
            }

            // Delete everything we are able to
            if (!empty($deleteIds)) {
                try {
                    $entities = $model->deleteEntities($deleteIds);
                } catch (ForeignKeyConstraintViolationException $exception) {
                    $flashes[] = [
                        'type'    => 'notice',
                        'msg'     => 'mautic.transaction.error.cannotbedeleted',
                    ];

                    return $this->postActionRedirect(
                        array_merge($postActionVars, [
                            'flashes' => $flashes,
                        ])
                    );
                }

                $flashes[] = [
                    'type'    => 'notice',
                    'msg'     => 'mautic.transaction.notice.batch_deleted',
                    'msgVars' => [
                        '%count%' => count($entities),
                    ],
                ];
            }
        } //else don't do anything

        return $this->postActionRedirect(
            array_merge($postActionVars, [
                'flashes' => $flashes,
            ])
        );
    }

    /**
     * Clone an entity.
     *
     * @param int $objectId
     *
     * @return array|JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse|Response
     */
    public function cloneAction($objectId)
    {
        $model  = $this->getModel('transaction');
        $entity = $model->getEntity($objectId);

        if (null != $entity) {
            if (!$this->get('mautic.security')->isGranted('lead:leads:create')) {
                return $this->accessDenied();
            }

            $entity = clone $entity;
        }

        return $this->newAction($entity);
    }

    /**
     * Company Merge function.
     *
     * @param $objectId
     *
     * @return array|JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function mergeAction($objectId)
    {
        //set some permissions
        $permissions = $this->get('mautic.security')->isGranted(
            [
                'lead:leads:viewown',
                'lead:leads:viewother',
                'lead:leads:create',
                'lead:leads:editother',
                'lead:leads:deleteother',
            ],
            'RETURN_ARRAY'
        );

        if (!$permissions['lead:leads:viewown'] && !$permissions['lead:leads:viewother']) {
            return $this->accessDenied();
        }

        /** @var Transaction $model */
        $model            = $this->getModel('transaction');
        $secondaryTransaction = $model->getEntity($objectId);
        $page             = $this->get('session')->get('mautic.lead.page', 1);

        //set the return URL
        $returnUrl = $this->generateUrl('mautic_transaction_index', ['page' => $page]);

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'viewParameters'  => ['page' => $page],
            'contentTemplate' => 'MauticTransactionBundle:Transaction:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'mauticContent' => 'transaction',
            ],
        ];

        if (null === $secondaryTransaction) {
            return $this->postActionRedirect(
                array_merge(
                    $postActionVars,
                    [
                        'flashes' => [
                            [
                                'type'    => 'error',
                                'msg'     => 'mautic.lead.transaction.error.notfound',
                                'msgVars' => ['%id%' => $objectId],
                            ],
                        ],
                    ]
                )
            );
        }

        $action = $this->generateUrl('mautic_transaction_action', ['objectAction' => 'merge', 'objectId' => $secondaryTransaction->getId()]);

        $form = $this->get('form.factory')->create(
            TransactionMergeType::class,
            [],
            [
                'action'      => $action,
                'main_entity' => $secondaryTransaction->getId(),
            ]
        );

        if ('POST' == $this->request->getMethod()) {
            $valid = true;
            if (!$this->isFormCancelled($form)) {
                if ($valid = $this->isFormValid($form)) {
                    $data           = $form->getData();
                    $primaryMergeId = $data['transaction_to_merge'];
                    $primaryTransaction = $model->getEntity($primaryMergeId);

                    if (null === $primaryTransaction) {
                        return $this->postActionRedirect(
                            array_merge(
                                $postActionVars,
                                [
                                    'flashes' => [
                                        [
                                            'type'    => 'error',
                                            'msg'     => 'mautic.lead.transaction.error.notfound',
                                            'msgVars' => ['%id%' => $primaryTransaction->getId()],
                                        ],
                                    ],
                                ]
                            )
                        );
                    } elseif (!$permissions['lead:leads:editother']) {
                        return $this->accessDenied();
                    } elseif ($model->isLocked($secondaryTransaction)) {
                        //deny access if the entity is locked
                        return $this->isLocked($postActionVars, $primaryTransaction, 'transaction');
                    } elseif ($model->isLocked($primaryTransaction)) {
                        //deny access if the entity is locked
                        return $this->isLocked($postActionVars, $primaryTransaction, 'transaction');
                    }

                    //Both leads are good so now we merge them
                    $mainTransaction = $model->transactionMerge($primaryTransaction, $secondaryTransaction, false);
                }

                if ($valid) {
                    $viewParameters = [
                        'objectId'     => $primaryTransaction->getId(),
                        'objectAction' => 'edit',
                    ];
                }
            } else {
                $viewParameters = [
                    'objectId'     => $secondaryTransaction->getId(),
                    'objectAction' => 'edit',
                ];
            }

            return $this->postActionRedirect(
                [
                    'returnUrl'       => $this->generateUrl('mautic_transaction_action', $viewParameters),
                    'viewParameters'  => $viewParameters,
                    'contentTemplate' => 'MauticTransactionBundle:Transaction:edit',
                    'passthroughVars' => [
                        'closeModal' => 1,
                    ],
                ]
            );
        }

        $tmpl = $this->request->get('tmpl', 'index');

        return $this->delegateView(
            [
                'viewParameters' => [
                    'tmpl'         => $tmpl,
                    'action'       => $action,
                    'form'         => $form->createView(),
                    'currentRoute' => $this->generateUrl(
                        'mautic_transaction_action',
                        [
                            'objectAction' => 'merge',
                            'objectId'     => $secondaryTransaction->getId(),
                        ]
                    ),
                ],
                'contentTemplate' => 'MauticTransactionBundle:Transaction:merge.html.php',
                'passthroughVars' => [
                    'route'  => false,
                    'target' => ('update' == $tmpl) ? '.transaction-merge-options' : null,
                ],
            ]
        );
    }

    /**
     * Export transaction's data.
     *
     * @param $transactionId
     *
     * @return array|JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\StreamedResponse
     */
    public function transactionExportAction($transactionId)
    {
        //set some permissions
        $permissions = $this->get('mautic.security')->isGranted(
            [
                'lead:leads:viewown',
                'lead:leads:viewother',
            ],
            'RETURN_ARRAY'
        );

        if (!$permissions['lead:leads:viewown'] && !$permissions['lead:leads:viewother']) {
            return $this->accessDenied();
        }

        /** @var Transaction $transactionModel */
        $transactionModel  = $this->getModel('transaction');
        $transaction       = $transactionModel->getEntity($transactionId);
        $dataType      = $this->request->get('filetype', 'csv');

        if (empty($transaction)) {
            return $this->notFound();
        }

        $transactionFields = $transaction->getProfileFields();
        $export        = [];
        foreach ($transactionFields as $alias=>$transactionField) {
            $export[] = [
                'alias' => $alias,
                'value' => $transactionField,
            ];
        }

        return $this->exportResultsAs($export, $dataType, 'transaction_data_'.($transactionFields['transactionemail'] ?: $transactionFields['id']));
    }
}
