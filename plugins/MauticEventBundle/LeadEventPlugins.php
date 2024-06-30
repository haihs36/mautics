<?php

namespace MauticPlugin\MauticEventBundle;

/**
 * Class LeadEventPlugins
 * Events available for LeadBundle.
 */
final class LeadEventPlugins
{

    const TIMELINE_ON_GENERATE = 'mautic.lead_timeline_on_generate';
    const EVENT_BUILD_SEARCH_COMMANDS = 'mautic.event_build_search_commands';
    /**
     * The mautic.lead_event_change event is dispatched if a lead's company changes.
     *
     * The event listener receives a
     * Mautic\LeadBundle\Event\LeadChangeCompanyEvent instance.
     *
     * @var string
     */
    const LEAD_EVENT_PLUGIN_CHANGE = 'mautic.lead_event_change';
   
   
    /**
     * The mautic.event_build_search_commands event is dispatched when the search commands are built.
     *
     * The event listener receives a
     * Mautic\LeadBundle\Event\CompanyBuildSearchEvent instance.
     *
     * @var string
     */
    const EVENT_PLUGIN_BUILD_SEARCH_COMMANDS = 'mautic.event_build_search_commands';


    /**
     * The mautic.event_pre_save event is thrown right before a form is persisted.
     *
     * The event listener receives a Mautic\LeadBundle\Event\CompanyEvent instance.
     *
     * @var string
     */
    const EVENT_PLUGIN_PRE_SAVE = 'mautic.event_pre_save';

    /**
     * The mautic.event_post_save event is thrown right after a form is persisted.
     *
     * The event listener receives a Mautic\LeadBundle\Event\CompanyEvent instance.
     *
     * @var string
     */
    const EVENT_PLUGIN_POST_SAVE = 'mautic.event_post_save';

    /**
     * The mautic.event_pre_delete event is thrown before a form is deleted.
     *
     * The event listener receives a Mautic\LeadBundle\Event\CompanyEvent instance.
     *
     * @var string
     */
    const EVENT_PLUGIN_PRE_DELETE = 'mautic.event_pre_delete';

    /**
     * The mautic.event_post_delete event is thrown after a form is deleted.
     *
     * The event listener receives a Mautic\LeadBundle\Event\CompanyEvent instance.
     *
     * @var string
     */
    const EVENT_PLUGIN_POST_DELETE = 'mautic.event_post_delete';


//    const IMPORT_ON_PROCESS = 'mautic.lead_import_on_process';
//    const IMPORT_PRE_SAVE = 'mautic.lead_import_pre_save';
//    const IMPORT_POST_SAVE = 'mautic.lead_import_post_save';
//    const IMPORT_PRE_DELETE = 'mautic.lead_import_pre_delete';
//    const IMPORT_POST_DELETE = 'mautic.lead_import_post_delete';
//    const IMPORT_BATCH_PROCESSED = 'mautic.lead_import_batch_processed';

}
