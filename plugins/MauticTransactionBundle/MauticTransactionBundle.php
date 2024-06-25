<?php
	
	namespace MauticPlugin\MauticTransactionBundle;
	
	use Mautic\PluginBundle\Bundle\PluginBundleBase;
    use Symfony\Component\DependencyInjection\ContainerBuilder;

    class MauticTransactionBundle extends PluginBundleBase
	{
        public function build(ContainerBuilder $container)
        {
            parent::build($container);
        }

        public function getEntityPath()
        {
            return 'Entity';
        }
	}