<?php

namespace MauticPlugin\MauticTagManagerBundle\Tests\Unit\Integration;

use MauticPlugin\MauticTagManagerBundle\Integration\TransactionIntegration;
use PHPUnit\Framework\Assert;
use PHPUnit\Framework\TestCase;

class TagManagerIntegrationTest extends TestCase
{
    /**
     * @var TransactionIntegration
     */
    private $tagManagerIntegration;

    protected function setUp(): void
    {
        parent::setUp();

        $this->tagManagerIntegration = new class() extends TransactionIntegration {
            public function __construct()
            {
            }
        };
    }

    public function testGetNameReturnsName(): void
    {
        $name = $this->tagManagerIntegration->getName();
        Assert::assertSame(TransactionIntegration::PLUGIN_NAME, $name);
    }

    public function testGetDisplayNameReturnsName(): void
    {
        $displayName = $this->tagManagerIntegration->getDisplayName();
        Assert::assertIsString($displayName);
        Assert::assertNotEmpty($displayName);
    }

    public function testGetAuthenticationTypeReturnsNonEmptyValue(): void
    {
        $authenticationType = $this->tagManagerIntegration->getAuthenticationType();
        Assert::assertIsString($authenticationType);
        Assert::assertNotEmpty($authenticationType);
    }
}
