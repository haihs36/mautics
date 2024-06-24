<?php

namespace MauticPlugin\MauticExtendedFieldBundle;

use Mautic\PluginBundle\Bundle\PluginBundleBase;
use MauticPlugin\MauticExtendedFieldBundle\DependencyInjection\Compiler\OverrideCompanyModelPass;
use MauticPlugin\MauticExtendedFieldBundle\DependencyInjection\Compiler\OverrideFieldModelPass;
use MauticPlugin\MauticExtendedFieldBundle\DependencyInjection\Compiler\OverrideListModelPass;
use MauticPlugin\MauticExtendedFieldBundle\DependencyInjection\Compiler\OverrideTableSchemaColumnsCachePass;
use Symfony\Component\DependencyInjection\ContainerBuilder;


class MauticExtendedFieldBundle extends PluginBundleBase
{
    /**
     * @param ContainerBuilder $container
     */
    public function build(ContainerBuilder $container)
    {
        $container->addCompilerPass(new OverrideFieldModelPass());
        $container->addCompilerPass(new OverrideListModelPass());
        $container->addCompilerPass(new OverrideTableSchemaColumnsCachePass());
        $container->addCompilerPass(new OverrideCompanyModelPass());

        parent::build($container);
    }
}
