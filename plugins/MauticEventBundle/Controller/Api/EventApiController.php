<?php

namespace MauticPlugin\MauticEventBundle\Controller\Api;

use Mautic\ApiBundle\Controller\CommonApiController;
use Mautic\LeadBundle\Controller\Api\CustomFieldsApiControllerTrait;
use Mautic\LeadBundle\Controller\LeadAccessTrait;
use MauticPlugin\MauticEventBundle\Entity\Event;
use MauticPlugin\MauticEventBundle\Helper\IdentifyEventHelper;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Event\FilterControllerEvent;

/**
 * Class EventApiController.
 */
class EventApiController extends CommonApiController
{
    use CustomFieldsApiControllerTrait;
    use LeadAccessTrait;

    public function initialize(FilterControllerEvent $event)
    {
        $this->model              = $this->getModel('lead.event');
        $this->entityClass        = Event::class;
        $this->entityNameOne      = 'event';
        $this->entityNameMulti    = 'events';
        $this->serializerGroups[] = 'eventDetails';
        $this->setCleaningRules('event');
        parent::initialize($event);
    }

    /**
     * If an existing event is matched, it'll be merged. Otherwise it'll be created.
     *
     * @return \Symfony\Component\HttpFoundation\Response
     */
    public function newEntityAction()
    {
        // Check for an email to see if the lead already exists
        $parameters = $this->request->request->all();

        if (empty($parameters['force'])) {
            list($event, $eventEntities) = IdentifyEventHelper::findEvent($parameters, $this->getModel('lead.event'));

            if (count($eventEntities)) {
                return $this->editEntityAction($event['id']);
            }
        }

        return parent::newEntityAction();
    }

    /**
     * {@inheritdoc}
     *
     * @param \Mautic\LeadBundle\Entity\Lead &$entity
     * @param                                $parameters
     * @param                                $form
     * @param string                         $action
     */
    protected function preSaveEntity(&$entity, $form, $parameters, $action = 'edit')
    {
        $this->setCustomFieldValues($entity, $form, $parameters);
    }

    /**
     * Adds a contact to a event.
     *
     * @param int $eventId Event ID
     * @param int $contactId Contact ID
     *
     * @return \Symfony\Component\HttpFoundation\Response
     *
     * @throws \Symfony\Component\HttpKernel\Exception\NotFoundHttpException
     */
    public function addContactAction($eventId, $contactId)
    {
        $event = $this->model->getEntity($eventId);
        $view    = $this->view(['success' => 1], Response::HTTP_OK);

        if (null === $event) {
            return $this->notFound();
        }

        $contact = $this->checkLeadAccess($contactId, 'edit');
        if ($contact instanceof Response) {
            return $contact;
        }

        $this->model->addLeadToEvent($event, $contact);

        return $this->handleView($view);
    }

    /**
     * Removes given contact from a event.
     *
     * @param int $eventId List ID
     * @param int $contactId Lead ID
     *
     * @return \Symfony\Component\HttpFoundation\Response
     *
     * @throws \Symfony\Component\HttpKernel\Exception\NotFoundHttpException
     */
    public function removeContactAction($eventId, $contactId)
    {
        $event = $this->model->getEntity($eventId);
        $view    = $this->view(['success' => 1], Response::HTTP_OK);

        if (null === $event) {
            return $this->notFound();
        }

        $contactModel = $this->getModel('lead');
        $contact      = $contactModel->getEntity($contactId);

        // Does the contact exist and the user has permission to edit
        if (null === $contact) {
            return $this->notFound();
        } elseif (!$this->security->hasEntityAccess('lead:leads:editown', 'lead:leads:editother', $contact->getPermissionUser())) {
            return $this->accessDenied();
        }

        $this->model->removeLeadFromEvent($event, $contact);

        return $this->handleView($view);
    }
}
