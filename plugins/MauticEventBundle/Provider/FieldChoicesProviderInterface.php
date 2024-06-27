<?php

declare(strict_types=1);

namespace MauticPlugin\MauticEventBundle\Provider;

use Mautic\LeadBundle\Exception\ChoicesNotFoundException;

interface FieldChoicesProviderInterface
{
    /**
     * @throws ChoicesNotFoundException
     *
     * @return mixed[]
     */
    public function getChoicesForField(string $fieldType, string $fieldAlias, string $search = ''): array;
}
