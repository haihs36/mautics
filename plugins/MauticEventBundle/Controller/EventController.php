<?php

namespace MauticPlugin\MauticEventBundle\Controller;

use Mautic\CoreBundle\Controller\FormController;
use Mautic\CoreBundle\Factory\PageHelperFactoryInterface;
use Mautic\CoreBundle\Helper\InputHelper;
use Mautic\LeadBundle\Controller\LeadDetailsTrait;
use MauticPlugin\MauticEventBundle\Entity\Event;
use MauticPlugin\MauticEventBundle\Form\Type\EventMergeType;
use MauticPlugin\MauticEventBundle\Model\EventModel;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;

class EventController extends FormController
{
    use LeadDetailsTrait;

    /**
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
        $pageHelper        = $pageHelperFacotry->make('mautic.event', $page);

        $limit      = $pageHelper->getLimit();
        $start      = $pageHelper->getStart();
        $search     = $this->request->get('search', $this->get('session')->get('mautic.event.filter', ''));
        $filter     = ['string' => $search, 'force' => []];
        $orderBy    = $this->get('session')->get('mautic.event.orderby', 'e.eventname');
        $orderByDir = $this->get('session')->get('mautic.event.orderbydir', 'ASC');

        $events = $this->getModel('lead.event')->getEntities(
            [
                'start'          => $start,
                'limit'          => $limit,
                'filter'         => $filter,
                'orderBy'        => $orderBy,
                'orderByDir'     => $orderByDir,
                'withTotalCount' => true,
            ]
        );

        $this->get('session')->set('mautic.event.filter', $search);

        $count     = $events['count'];
        $events = $events['results'];

        if ($count && $count < ($start + 1)) {
            $lastPage  = $pageHelper->countPage($count);
            $returnUrl = $this->generateUrl('mautic_event_index', ['page' => $lastPage]);
            $pageHelper->rememberPage($lastPage);

            return $this->postActionRedirect(
                [
                    'returnUrl'       => $returnUrl,
                    'viewParameters'  => ['page' => $lastPage],
                    'contentTemplate' => 'MauticEventBundle:Event:index',
                    'passthroughVars' => [
                        'activeLink'    => '#mautic_event_index',
                        'mauticContent' => 'event',
                    ],
                ]
            );
        }

        $pageHelper->rememberPage($page);

        $tmpl       = $this->request->isXmlHttpRequest() ? $this->request->get('tmpl', 'index') : 'index';
        $model      = $this->getModel('lead.event');
        $eventIds = array_keys($events);
        $leadCounts = (!empty($eventIds)) ? $model->getRepository()->getLeadCount($eventIds) : [];


        return $this->delegateView(
            [
                'viewParameters' => [
                    'searchValue' => $search,
                    'leadCounts'  => $leadCounts,
                    'items'       => $events,
                    'page'        => $page,
                    'limit'       => $limit,
                    'permissions' => $permissions,
                    'tmpl'        => $tmpl,
                    'totalItems'  => $count,
                ],
                'contentTemplate' => 'MauticEventBundle:Event:list.html.php',
                'passthroughVars' => [
                    'activeLink'    => '#mautic_event_index',
                    'mauticContent' => 'event',
                    'route'         => $this->generateUrl('mautic_event_index', ['page' => $page]),
                ],
            ]
        );
    }

    /**
     * Refresh contacts list in event view with new parameters like order or page.
     *
     * @param int $objectId event id
     * @param int $page
     *
     * @return JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse|Response
     */
    public function contactsListAction($objectId, $page = 1)
    {
        if (empty($objectId)) {
            return $this->accessDenied();
        }

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

        /** @var EventModel $model */
        $model  = $this->getModel('lead.event');

        /** @var \Mautic\LeadBundle\Entity\Event $event */
        $event = $model->getEntity($objectId);

        $eventsRepo  = $model->getEventLeadRepository();
        $contacts       = $eventsRepo->getEventLeads($objectId);

        $leadIds = array_column($contacts, 'lead_id');

        $data = $this->getEventContacts($objectId, $page, $leadIds);

        return $this->delegateView(
            [
                'viewParameters' => [
                    'event'     => $event,
                    'page'        => $data['page'],
                    'contacts'    => $data['items'],
                    'totalItems'  => $data['count'],
                    'limit'       => $data['limit'],
                    'permissions' => $permissions,
                    'security'    => $this->get('mautic.security'),
                ],
                'contentTemplate' => 'MauticEventBundle:Event:list_rows_contacts.html.php',
            ]
        );
    }

    /**
     * Generates new form and processes post data.
     *
     * @param \Mautic\LeadBundle\Entity\Event $entity
     *
     * @return JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse|Response
     */
    public function newAction($entity = null)
    {
        $model = $this->getModel('lead.event');

        if (!($entity instanceof Event)) {
            /** @var \Mautic\LeadBundle\Entity\Event $entity */
            $entity = $model->getEntity();
        }

        if (!$this->get('mautic.security')->isGranted('lead:leads:create')) {
            return $this->accessDenied();
        }

        //set the page we came from
        $page         = $this->get('session')->get('mautic.event.page', 1);
        $method       = $this->request->getMethod();
        $action       = $this->generateUrl('mautic_event_action', ['objectAction' => 'new']);
        $event      = $this->request->request->get('event', []);
        $updateSelect = InputHelper::clean(
            'POST' === $method
                ? ($event['updateSelect'] ?? false)
                : $this->request->get('updateSelect', false)
        );

        $fields = $this->getModel('lead.field')->getPublishedFieldArrays('event');
        $form   = $model->createForm($entity, $this->get('form.factory'), $action, ['fields' => $fields, 'update_select' => $updateSelect]);

        $viewParameters = ['page' => $page];
        $returnUrl      = $this->generateUrl('mautic_event_index', $viewParameters);
        $template       = 'MauticEventBundle:Event:index';

        ///Check for a submitted form and process it
        if ('POST' == $this->request->getMethod()) {
            $valid = false;
            if (!$cancelled = $this->isFormCancelled($form)) {
                if ($valid = $this->isFormValid($form)) {
                    //form is valid so process the data
                    //get custom field values
                    $data = $this->request->request->get('event');
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
                            '%menu_link%' => 'mautic_event_index',
                            '%url%'       => $this->generateUrl(
                                'mautic_event_action',
                                [
                                    'objectAction' => 'edit',
                                    'objectId'     => $entity->getId(),
                                ]
                            ),
                        ]
                    );

                    if ($form->get('buttons')->get('save')->isClicked()) {
                        $returnUrl = $this->generateUrl('mautic_event_index', $viewParameters);
                        $template  = 'MauticEventBundle:Event:index';
                    } else {
                        //return edit view so that all the session stuff is loaded
                        return $this->editAction($entity->getId(), true);
                    }
                }
            }

            $passthrough = [
                'activeLink'    => '#mautic_event_index',
                'mauticContent' => 'event',
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
        $template = 'MauticEventBundle:Event:form_'.($this->request->get('modal', false) ? 'embedded' : 'standalone').'.html.php';

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
                    'activeLink'    => '#mautic_event_index',
                    'mauticContent' => 'event',
                    'updateSelect'  => ('POST' == $this->request->getMethod()) ? $updateSelect : null,
                    'route'         => $this->generateUrl(
                        'mautic_event_action',
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
        $model  = $this->getModel('lead.event');
        $entity = $model->getEntity($objectId);

        //set the page we came from
        $page = $this->get('session')->get('mautic.event.page', 1);

        $viewParameters = ['page' => $page];

        //set the return URL
        $returnUrl = $this->generateUrl('mautic_event_index', ['page' => $page]);

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'viewParameters'  => $viewParameters,
            'contentTemplate' => 'MauticEventBundle:Event:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_event_index',
                'mauticContent' => 'event',
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
                                'msg'     => 'mautic.event.error.notfound',
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
            return $this->isLocked($postActionVars, $entity, 'lead.event');
        }

        $action       = $this->generateUrl('mautic_event_action', ['objectAction' => 'edit', 'objectId' => $objectId]);
        $method       = $this->request->getMethod();
        $event      = $this->request->request->get('event', []);
        $updateSelect = 'POST' === $method
            ? ($event['updateSelect'] ?? false)
            : $this->request->get('updateSelect', false);

        $fields = $this->getModel('lead.field')->getPublishedFieldArrays('event');
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
                    $data = $this->request->request->get('event');
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
                            '%menu_link%' => 'mautic_event_index',
                            '%url%'       => $this->generateUrl(
                                'mautic_event_action',
                                [
                                    'objectAction' => 'view',
                                    'objectId'     => $entity->getId(),
                                ]
                            ),
                        ]
                    );

                    if ($form->get('buttons')->get('save')->isClicked()) {
                        $returnUrl = $this->generateUrl('mautic_event_index', $viewParameters);
                        $template  = 'MauticEventBundle:Event:index';
                    }
                }
            } else {
                //unlock the entity
                $model->unlockEntity($entity);

                $returnUrl = $this->generateUrl('mautic_event_index', $viewParameters);
                $template  = 'MauticEventBundle:Event:index';
            }

            $passthrough = [
                'activeLink'    => '#mautic_event_index',
                'mauticContent' => 'event',
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
                $event = $model->getEntity($objectId);
                $form    = $model->createForm($event, $this->get('form.factory'), $action, ['fields' => $fields, 'update_select' => $updateSelect]);
            }
        } else {
            //lock the entity
            $model->lockEntity($entity);
        }

        $fields = $model->organizeFieldsByGroup($fields);
        $groups = array_keys($fields);
        sort($groups);
        $template = 'MauticEventBundle:Event:form_'.($this->request->get('modal', false) ? 'embedded' : 'standalone').'.html.php';

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
                    'activeLink'    => '#mautic_event_index',
                    'mauticContent' => 'event',
                    'updateSelect'  => InputHelper::clean($this->request->query->get('updateSelect')),
                    'route'         => $this->generateUrl(
                        'mautic_event_action',
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
     * Loads a specific event into the detailed panel.
     *
     * @param $objectId
     *
     * @return \Symfony\Component\HttpFoundation\JsonResponse|\Symfony\Component\HttpFoundation\Response
     */
    public function viewAction($objectId)
    {
        /** @var EventModel $model */
        $model  = $this->getModel('lead.event');

        // When we change event data these changes get cached
        // so we need to clear the entity manager
        $model->getRepository()->clear();

        /** @var \Mautic\LeadBundle\Entity\Event $event */
        $event = $model->getEntity($objectId);

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
        $returnUrl = $this->generateUrl('mautic_event_index');

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'contentTemplate' => 'MauticEventBundle:Event:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_event_index',
                'mauticContent' => 'event',
            ],
        ];

        if (null === $event) {
            return $this->postActionRedirect(
                array_merge(
                    $postActionVars,
                    [
                        'flashes' => [
                            [
                                'type'    => 'error',
                                'msg'     => 'mautic.event.error.notfound',
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
            $event->getPermissionUser()
        )
        ) {
            return $this->accessDenied();
        }

        $fields         = $event->getFields();
        $eventsRepo  = $model->getEventLeadRepository();
        $contacts       = $eventsRepo->getEventLeads($objectId);

        $leadIds = array_column($contacts, 'lead_id');

        $engagementData = is_array($contacts) ? $this->getEventEngagementsForGraph($contacts) : [];

        $contacts = $this->getEventContacts($objectId, null, $leadIds);

        return $this->delegateView(
            [
                'viewParameters' => [
                    'event'           => $event,
                    'fields'            => $fields,
                    'items'             => $contacts['items'],
                    'permissions'       => $permissions,
                    'engagementData'    => $engagementData,
                    'security'          => $this->get('mautic.security'),
                    'page'              => $contacts['page'],
                    'totalItems'        => $contacts['count'],
                    'limit'             => $contacts['limit'],
                ],
                'contentTemplate' => 'MauticEventBundle:Event:event.html.php',
            ]
        );
    }

    /**
     * Get event's contacts for event view.
     *
     * @param int        $eventId
     * @param int        $page
     * @param array<int> $leadIds   filter to get only event's contacts
     *
     * @return array
     */
    public function getEventContacts($eventId, $page = 0, $leadIds = [])
    {
        $this->setListFilters();

        /** @var \Mautic\LeadBundle\Model\LeadModel $model */
        $model   = $this->getModel('lead');
        $session = $this->get('session');
        //set limits
        $limit = $session->get('mautic.event.'.$eventId.'.contacts.limit', $this->get('mautic.helper.core_parameters')->get('default_pagelimit'));
        $start = (1 === $page) ? 0 : (($page - 1) * $limit);
        if ($start < 0) {
            $start = 0;
        }

        //do some default sorting
        $orderBy    = $session->get('mautic.event.'.$eventId.'.contacts.orderby', 'l.last_active');
        $orderByDir = $session->get('mautic.event.'.$eventId.'.contacts.orderbydir', 'DESC');

        // filter by event contacts
        $filter = [
          'force' => [
            ['column' => 'l.id', 'expr' => 'in', 'value' => $leadIds],
          ],
        ];

        $results = $model->getEntities([
            'start'          => $start,
            'limit'          => $limit,
            'filter'         => $filter,
            'orderBy'        => $orderBy,
            'orderByDir'     => $orderByDir,
            'withTotalCount' => true,
        ]);

        $count = $results['count'];
        unset($results['count']);

        $leads = $results['results'];
        unset($results);

        return [
            'items' => $leads,
            'page'  => $page,
            'count' => $count,
            'limit' => $limit,
        ];
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
        $model  = $this->getModel('lead.event');
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
     * Deletes the entity.
     *
     * @param int $objectId
     *
     * @return JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function deleteAction($objectId)
    {
        $page      = $this->get('session')->get('mautic.event.page', 1);
        $returnUrl = $this->generateUrl('mautic_event_index', ['page' => $page]);
        $flashes   = [];

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'viewParameters'  => ['page' => $page],
            'contentTemplate' => 'MauticEventBundle:Event:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_event_index',
                'mauticContent' => 'event',
            ],
        ];

        if ('POST' == $this->request->getMethod()) {
            $model  = $this->getModel('lead.event');
            $entity = $model->getEntity($objectId);

            if (null === $entity) {
                $flashes[] = [
                    'type'    => 'error',
                    'msg'     => 'mautic.event.error.notfound',
                    'msgVars' => ['%id%' => $objectId],
                ];
            } elseif (!$this->get('mautic.security')->isGranted('lead:leads:deleteother')) {
                return $this->accessDenied();
            } elseif ($model->isLocked($entity)) {
                return $this->isLocked($postActionVars, $entity, 'lead.event');
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
     * @return \Symfony\Component\HttpFoundation\JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse
     */
    public function batchDeleteAction()
    {
        $page      = $this->get('session')->get('mautic.event.page', 1);
        $returnUrl = $this->generateUrl('mautic_event_index', ['page' => $page]);
        $flashes   = [];

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'viewParameters'  => ['page' => $page],
            'contentTemplate' => 'MauticEventBundle:Event:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_event_index',
                'mauticContent' => 'event',
            ],
        ];

        if ('POST' == $this->request->getMethod()) {
            $model     = $this->getModel('lead.event');
            $ids       = json_decode($this->request->query->get('ids', '{}'));
            $deleteIds = [];

            // Loop over the IDs to perform access checks pre-delete
            foreach ($ids as $objectId) {
                $entity = $model->getEntity($objectId);

                if (null === $entity) {
                    $flashes[] = [
                        'type'    => 'error',
                        'msg'     => 'mautic.event.error.notfound',
                        'msgVars' => ['%id%' => $objectId],
                    ];
                } elseif (!$this->get('mautic.security')->isGranted('lead:leads:deleteother')) {
                    $flashes[] = $this->accessDenied(true);
                } elseif ($model->isLocked($entity)) {
                    $flashes[] = $this->isLocked($postActionVars, $entity, 'lead.event', true);
                } else {
                    $deleteIds[] = $objectId;
                }
            }

            // Delete everything we are able to
            if (!empty($deleteIds)) {
                $entities = $model->deleteEntities($deleteIds);
                $deleted  = count($entities);
                $this->addFlash(
                    'mautic.event.notice.batch_deleted',
                    [
                        '%count%'     => $deleted,
                    ]
                );
            }
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
     * Event Merge function.
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

        /** @var EventModel $model */
        $model            = $this->getModel('lead.event');
        $secondaryEvent = $model->getEntity($objectId);
        $page             = $this->get('session')->get('mautic.lead.page', 1);

        //set the return URL
        $returnUrl = $this->generateUrl('mautic_event_index', ['page' => $page]);

        $postActionVars = [
            'returnUrl'       => $returnUrl,
            'viewParameters'  => ['page' => $page],
            'contentTemplate' => 'MauticEventBundle:Event:index',
            'passthroughVars' => [
                'activeLink'    => '#mautic_event_index',
                'mauticContent' => 'event',
            ],
        ];

        if (null === $secondaryEvent) {
            return $this->postActionRedirect(
                array_merge(
                    $postActionVars,
                    [
                        'flashes' => [
                            [
                                'type'    => 'error',
                                'msg'     => 'mautic.lead.event.error.notfound',
                                'msgVars' => ['%id%' => $objectId],
                            ],
                        ],
                    ]
                )
            );
        }

        $action = $this->generateUrl('mautic_event_action', ['objectAction' => 'merge', 'objectId' => $secondaryEvent->getId()]);

        $form = $this->get('form.factory')->create(
            EventMergeType::class,
            [],
            [
                'action'      => $action,
                'main_entity' => $secondaryEvent->getId(),
            ]
        );

        if ('POST' == $this->request->getMethod()) {
            $valid = true;
            if (!$this->isFormCancelled($form)) {
                if ($valid = $this->isFormValid($form)) {
                    $data           = $form->getData();
                    $primaryMergeId = $data['event_to_merge'];
                    $primaryEvent = $model->getEntity($primaryMergeId);

                    if (null === $primaryEvent) {
                        return $this->postActionRedirect(
                            array_merge(
                                $postActionVars,
                                [
                                    'flashes' => [
                                        [
                                            'type'    => 'error',
                                            'msg'     => 'mautic.lead.event.error.notfound',
                                            'msgVars' => ['%id%' => $primaryEvent->getId()],
                                        ],
                                    ],
                                ]
                            )
                        );
                    } elseif (!$permissions['lead:leads:editother']) {
                        return $this->accessDenied();
                    } elseif ($model->isLocked($secondaryEvent)) {
                        //deny access if the entity is locked
                        return $this->isLocked($postActionVars, $primaryEvent, 'lead.event');
                    } elseif ($model->isLocked($primaryEvent)) {
                        //deny access if the entity is locked
                        return $this->isLocked($postActionVars, $primaryEvent, 'lead.event');
                    }

                    //Both leads are good so now we merge them
                    $mainEvent = $model->eventMerge($primaryEvent, $secondaryEvent, false);
                }

                if ($valid) {
                    $viewParameters = [
                        'objectId'     => $primaryEvent->getId(),
                        'objectAction' => 'edit',
                    ];
                }
            } else {
                $viewParameters = [
                    'objectId'     => $secondaryEvent->getId(),
                    'objectAction' => 'edit',
                ];
            }

            return $this->postActionRedirect(
                [
                    'returnUrl'       => $this->generateUrl('mautic_event_action', $viewParameters),
                    'viewParameters'  => $viewParameters,
                    'contentTemplate' => 'MauticEventBundle:Event:edit',
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
                        'mautic_event_action',
                        [
                            'objectAction' => 'merge',
                            'objectId'     => $secondaryEvent->getId(),
                        ]
                    ),
                ],
                'contentTemplate' => 'MauticEventBundle:Event:merge.html.php',
                'passthroughVars' => [
                    'route'  => false,
                    'target' => ('update' == $tmpl) ? '.event-merge-options' : null,
                ],
            ]
        );
    }

    /**
     * Export event's data.
     *
     * @param $eventId
     *
     * @return array|JsonResponse|\Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\StreamedResponse
     */
    public function eventExportAction($eventId)
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

        /** @var eventModel $eventModel */
        $eventModel  = $this->getModel('lead.event');
        $event       = $eventModel->getEntity($eventId);
        $dataType      = $this->request->get('filetype', 'csv');

        if (empty($event)) {
            return $this->notFound();
        }

        $eventFields = $event->getProfileFields();
        $export        = [];
        foreach ($eventFields as $alias=>$eventField) {
            $export[] = [
                'alias' => $alias,
                'value' => $eventField,
            ];
        }

        return $this->exportResultsAs($export, $dataType, 'event_data_'.($eventFields['eventemail'] ?: $eventFields['id']));
    }
}
