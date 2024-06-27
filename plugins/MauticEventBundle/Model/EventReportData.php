<?php

namespace MauticPlugin\MauticEventBundle\Model;

use Mautic\FormBundle\Entity\Field;
use Mautic\FormBundle\Model\FieldModel;
use Mautic\ReportBundle\Event\ReportGeneratorEvent;
use Symfony\Component\Translation\TranslatorInterface;

class EventReportData
{
    /**
     * @var FieldModel
     */
    private $fieldModel;

    /**
     * @var TranslatorInterface
     */
    private $translator;

    /**
     * EventReportData constructor.
     */
    public function __construct(FieldModel $fieldModel, TranslatorInterface $translator)
    {
        $this->fieldModel = $fieldModel;
        $this->translator = $translator;
    }

    /**
     * @return array
     */
    public function getEventData()
    {
        $eventColumns = $this->getEventColumns();
        $eventFields  = $this->fieldModel->getEntities([
            'filter' => [
                'force' => [
                    [
                        'column' => 'f.object',
                        'expr'   => 'like',
                        'value'  => 'event',
                    ],
                ],
            ],
        ]);

        return array_merge($eventColumns, $this->getFieldColumns($eventFields, 'comp.'));
    }

    /**
     * @return bool
     */
    public function eventHasEventColumns(ReportGeneratorEvent $event)
    {
        $eventColumns = $this->getEventData();
        foreach ($eventColumns as $key => $column) {
            if ($event->hasColumn($key)) {
                return true;
            }
        }

        return false;
    }

    /**
     * @return array
     */
    private function getEventColumns()
    {
        return [
            'comp.id' => [
                'alias' => 'comp_id',
                'label' => 'mautic.lead.report.event.event_id',
                'type'  => 'int',
                'link'  => 'mautic_event_action',
            ],
            'events_lead.is_primary' => [
                'label' => 'mautic.lead.report.event.is_primary',
                'type'  => 'bool',
            ],
            'events_lead.date_added' => [
                'label' => 'mautic.lead.report.event.date_added',
                'type'  => 'datetime',
            ],
        ];
    }

    /**
     * @param Field[] $fields
     * @param string  $prefix
     *
     * @return array
     */
    private function getFieldColumns($fields, $prefix)
    {
        $columns = [];
        foreach ($fields as $f) {
            switch ($f->getType()) {
                case 'boolean':
                    $type = 'bool';
                    break;
                case 'date':
                    $type = 'date';
                    break;
                case 'datetime':
                    $type = 'datetime';
                    break;
                case 'time':
                    $type = 'time';
                    break;
                case 'url':
                    $type = 'url';
                    break;
                case 'email':
                    $type = 'email';
                    break;
                case 'number':
                    $type = 'float';
                    break;
                default:
                    $type = 'string';
                    break;
            }
            $columns[$prefix.$f->getAlias()] = [
                'label' => $this->translator->trans('mautic.report.field.event.label', ['%field%' => $f->getLabel()]),
                'type'  => $type,
            ];
        }

        return $columns;
    }
}
