<?php

namespace MauticPlugin\MauticTransactionBundle\Controller;

use Doctrine\DBAL\Exception\ForeignKeyConstraintViolationException;
use Doctrine\ORM\EntityNotFoundException;
use Mautic\CoreBundle\Controller\FormController;
use Mautic\LeadBundle\Entity\Tag;
use Mautic\LeadBundle\Model\TagModel;
use MauticPlugin\MauticTransactionBundle\Entity\Transaction;
use MauticPlugin\MauticTransactionBundle\Model\TransactionModel;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\Exception\AccessDeniedException;

class TransactionController extends FormController
{
    /**
     * Generate's default list view.
     *
     * @param int $page
     *
     * @return JsonResponse|Response
     */
    public function indexAction($page = 1)
    {
        /** @var TransactionModel $model */
        // Use overwritten transaction model so overwritten repository can be fetched,
        // we need it to define table alias so we can define sort order.
        $model   = $this->getModel('transaction');
        $session = $this->get('session');

        //set some permissions
        $permissions = $this->get('mautic.security')->isGranted([
            'transaction:transaction:view',
            'transaction:transaction:edit',
            'transaction:transaction:create',
            'transaction:transaction:delete',
        ], 'RETURN_ARRAY');

        if (!$permissions['transaction:transaction:view']) {
            return $this->accessDenied();
        }

        $this->setListFilters();

        //set limits
        $limit = $session->get('mautic.transactions.limit', $this->coreParametersHelper->get('default_pagelimit'));
        $start = (1 === $page) ? 0 : (($page - 1) * $limit);
        if ($start < 0) {
            $start = 0;
        }

        $search = $this->request->get('search', $session->get('mautic.transactions.filter', ''));
        $session->set('mautic.transactions.filter', $search);

        //do some default filtering
        $orderBy    = $session->get('mautic.transactions.orderby', 't.name');
        $orderByDir = $session->get('mautic.transactions.orderbydir', 'ASC');

        if (!empty($search)) {
            $filter = [
                'where' => [
                    [
                        'expr' => 'like',
                        'col'  => 't.name',
                        'val'  => '%'.$search.'%',
                    ],
                ],
            ];
        } else {
            $filter = '';
        }

        $tmpl = $this->request->isXmlHttpRequest() ? $this->request->get('tmpl', 'index') : 'index';

        $items = $model->getEntities(
            [
                'start'      => $start,
                'limit'      => $limit,
                'filter'     => $filter,
                'orderBy'    => $orderBy,
                'orderByDir' => $orderByDir,
            ]);


        $count = count($items);

        if ($count && $count < ($start + 1)) {
            //the number of entities are now less then the current page so redirect to the last page
            if (1 === $count) {
                $lastPage = 1;
            } else {
                $lastPage = (ceil($count / $limit)) ?: 1;
            }
            $session->set('mautic.transactions.page', $lastPage);
            $returnUrl = $this->generateUrl('mautic_transaction_index', ['page' => $lastPage]);

            return $this->postActionRedirect([
                'returnUrl'      => $returnUrl,
                'viewParameters' => [
                    'page' => $lastPage,
                    'tmpl' => $tmpl,
                ],
                'contentTemplate' => 'MauticTransactionBundle:Transaction:index',
                'passthroughVars' => [
                    'activeLink'    => '#mautic_transaction_index',
                    'mauticContent' => 'transaction',
                ],
            ]);
        }

        //set what page currently on so that we can return here after form submission/cancellation
        $session->set('mautic.transactions.page', $page);

        $transactionIds    = array_keys($items->getIterator()->getArrayCopy());
        $transactionCount = (!empty($transactionIds)) ? $model->getRepository()->countByLeads($transactionIds) : [];

        $parameters = [
            'items'       => $items,
            'transactionCount'   => $transactionCount,
            'page'        => $page,
            'limit'       => $limit,
            'permissions' => $permissions,
            'security'    => $this->get('mautic.security'),
            'tmpl'        => $tmpl,
            'currentUser' => $this->user,
            'searchValue' => $search,
        ];

        return $this->delegateView([
            'viewParameters'  => $parameters,
            'contentTemplate' => 'MauticTransactionBundle:Transaction:list.html.php',
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'route'         => $this->generateUrl('mautic_transaction_index', ['page' => $page]),
                'mauticContent' => 'transactions',
            ],
        ]);
    }

    /**
     * Generate's new form and processes post data.
     *
     * @return JsonResponse|RedirectResponse|Response
     */
    public function newAction()
    {
        if (!$this->get('mautic.security')->isGranted('transaction:transaction:create')) {
            return $this->accessDenied();
        }

        //retrieve the entity
        $transaction   = new Transaction();
        $model = $this->getModel('transaction');
        //set the page we came from
        $page = $this->get('session')->get('mautic.transaction.page', 1);
        //set the return URL for post actions
        $returnUrl = $this->generateUrl('mautic_transaction_index', ['page' => $page]);
        $action    = $this->generateUrl('mautic_transaction_action', ['objectAction' => 'new']);

        //get the user form factory
        $form = $model->createForm($transaction, $this->get('form.factory'), $action);

        // Check for a submitted form and process it
        if ('POST' == $this->request->getMethod()) {
            $valid = false;
            if (!$cancelled = $this->isFormCancelled($form)) {
                if ($valid = $this->isFormValid($form)) {
                    //form is valid so process the data
                    $found = $model->getRepository()->countOccurrences($tag->getTag());
                    if (0 !== $found) {
                        $valid = false;
                        $this->addFlash('mautic.core.notice.updated', [
                            '%name%'      => $tag->getTag(),
                            '%menu_link%' => 'mautic_transaction_index',
                            '%url%'       => $this->generateUrl('mautic_transaction_action', [
                                'objectAction' => 'edit',
                                'objectId'     => $tag->getId(),
                            ]),
                        ]);
                    } else {
                        $model->saveEntity($tag);

                        $this->addFlash('mautic.core.notice.created', [
                            '%name%'      => $tag->getTag(),
                            '%menu_link%' => 'mautic_transaction_index',
                            '%url%'       => $this->generateUrl('mautic_transaction_action', [
                                'objectAction' => 'edit',
                                'objectId'     => $tag->getId(),
                            ]),
                        ]);
                    }
                }
            }

            if ($cancelled || ($valid && $form->get('buttons')->get('save')->isClicked())) {
                return $this->postActionRedirect([
                    'returnUrl'       => $returnUrl,
                    'viewParameters'  => ['page' => $page],
                    'contentTemplate' => 'MauticTransactionBundle:Transaction:index',
                    'passthroughVars' => [
                        'activeLink'    => '#mautic_transaction_index',
                        'mauticContent' => 'transaction',
                    ],
                ]);
            } elseif ($valid && !$cancelled) {
                return $this->editAction($tag->getId(), true);
            }
        }

        return $this->delegateView([
            'viewParameters' => [
                'form'   => $form->createView(),
                'entity' => $tag,
            ],
            'contentTemplate' => 'MauticTransactionBundle:Transaction:form.html.php',
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'route'         => $this->generateUrl('mautic_transaction_action', ['objectAction' => 'new']),
                'mauticContent' => 'transaction',
            ],
        ]);
    }

    /**
     * Generate's edit form and processes post data.
     *
     * @param int  $objectId
     * @param bool $ignorePost
     *
     * @return Response
     */
    public function editAction($objectId, $ignorePost = false)
    {
        if (!$this->get('mautic.security')->isGranted('transaction:transaction:edit')) {
            return $this->accessDenied();
        }

        $postActionVars = $this->getPostActionVars($objectId);

        try {
            $tag = $this->getTag($objectId);

            return $this->createTagModifyResponse(
                $tag,
                $postActionVars,
                $this->generateUrl('mautic_transaction_action', ['objectAction' => 'edit', 'objectId' => $objectId]),
                $ignorePost
            );
        } catch (AccessDeniedException $exception) {
            return $this->accessDenied();
        } catch (EntityNotFoundException $exception) {
            return $this->postActionRedirect(
                array_merge($postActionVars, [
                    'flashes' => [
                        [
                            'type'    => 'error',
                            'msg'     => 'mautic.transaction.tag.error.notfound',
                            'msgVars' => ['%id%' => $objectId],
                        ],
                    ],
                ])
            );
        }
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
     * Loads a specific form into the detailed panel.
     *
     * @param $objectId
     *
     * @return \Symfony\Component\HttpFoundation\JsonResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function viewAction($objectId)
    {
        /** @var \Mautic\LeadBundle\Model\TagModel $model */
        $model    = $this->getModel('lead.tag');
        $security = $this->get('mautic.security');

        /** @var Tag $tag */
        $tag = $model->getEntity($objectId);

        //set the page we came from
        $page = $this->get('session')->get('mautic.transaction.page', 1);
        if (null === $tag) {
            //set the return URL
            $returnUrl = $this->generateUrl('mautic_transaction_index', ['page' => $page]);

            return $this->postActionRedirect([
                'returnUrl'       => $returnUrl,
                'viewParameters'  => ['page' => $page],
                'contentTemplate' => 'MauticTransactionBundle:Transaction:index',
                'passthroughVars' => [
                    'activeLink'    => '#mautic_transaction_index',
                    'mauticContent' => 'transaction',
                ],
                'flashes' => [
                    [
                        'type'    => 'error',
                        'msg'     => 'mautic.transaction.tag.error.notfound',
                        'msgVars' => ['%id%' => $objectId],
                    ],
                ],
            ]);
        } elseif (!$this->get('mautic.security')->isGranted('transaction:transaction:view')) {
            return $this->accessDenied();
        }

        return $this->delegateView([
            'returnUrl'      => $this->generateUrl('mautic_transaction_action', ['objectAction' => 'view', 'objectId' => $tag->getId()]),
            'viewParameters' => [
                'tag' => $tag,
            ],
            'contentTemplate' => 'MauticTransactionBundle:Transaction:details.html.php',
            'passthroughVars' => [
                'activeLink'    => '#mautic_transaction_index',
                'mauticContent' => 'transaction',
            ],
        ]);
    }

    /**
     * Deletes a tags.
     *
     * @param $objectId
     *
     * @return JsonResponse|RedirectResponse
     */
    public function deleteAction($objectId)
    {
        /** @var TagModel $model */
        $model     = $this->getModel('lead.tag');
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
            /** @var TagModel $model */
            $model         = $this->getModel('lead.tag');
            $overrideModel = $this->getModel('transaction.tag');
            $tag           = $model->getEntity($objectId);

            if (null === $tag) {
                $flashes[] = [
                    'type'    => 'error',
                    'msg'     => 'mautic.transaction.error.notfound',
                    'msgVars' => ['%id%' => $objectId],
                ];
            } elseif (!$this->get('mautic.security')->isGranted('transaction:transaction:delete')) {
                return $this->accessDenied();
            }

            if ($overrideModel->getRepository()->countByLeads([$objectId])[$objectId] > 0) {
                $flashes[] = [
                    'type'    => 'error',
                    'msg'     => 'mautic.transaction.error.cannotbedeleted',
                ];

                return $this->postActionRedirect(
                    array_merge($postActionVars, [
                        'flashes' => $flashes,
                    ])
                );
            }

            $model->deleteEntity($tag);

            $flashes[] = [
                'type'    => 'notice',
                'msg'     => 'mautic.core.notice.deleted',
                'msgVars' => [
                    '%name%' => $tag->getTag(),
                    '%id%'   => $objectId,
                ],
            ];
        }

        return $this->postActionRedirect(
            array_merge($postActionVars, [
                'flashes' => $flashes,
            ])
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
}
