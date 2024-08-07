<?php

namespace Mautic\LeadBundle\Tests\Functional\Controller;

use Mautic\CoreBundle\Test\MauticMysqlTestCase;
use Mautic\UserBundle\Entity\Role;
use Mautic\UserBundle\Entity\User;
use Symfony\Component\HttpFoundation\Request;

class LeadControllerTest extends MauticMysqlTestCase
{
    public const USERNAME = 'jhony';

    public function testAccessContactQuickAddWithPermission(): void
    {
        $this->setAdminUser();
        $this->client->request(Request::METHOD_GET, '/s/contacts/quickAdd');
        $this->assertResponseStatusCodeSame(200, (string) $this->client->getResponse()->getStatusCode());
    }

    private function setAdminUser(): void
    {
        $this->loginUser('admin');
        $this->client->setServerParameter('PHP_AUTH_USER', 'admin');
        $this->client->setServerParameter('PHP_AUTH_PW', 'mautic');
    }

    public function testAccessContactQuickAddWithNoPermission(): void
    {
        $this->createAndLoginUser();
        $this->client->request(Request::METHOD_GET, '/s/contacts/quickAdd');
        $this->assertResponseStatusCodeSame(403, (string) $this->client->getResponse()->getStatusCode());
    }

    public function testAccessContactBatchOwnersNoPermission(): void
    {
        $this->createAndLoginUser();
        $this->client->request(Request::METHOD_GET, '/s/contacts/batchOwners');
        $this->assertResponseStatusCodeSame(403, (string) $this->client->getResponse()->getStatusCode());
    }

    public function testAccessContactBatchOwnersPermission(): void
    {
        $this->setAdminUser();
        $this->client->request(Request::METHOD_GET, '/s/contacts/batchOwners');
        $this->assertResponseStatusCodeSame(200, (string) $this->client->getResponse()->getStatusCode());
    }

    private function createAndLoginUser(): User
    {
        // Create non-admin role
        $role = $this->createRole();
        // Create non-admin user
        $user = $this->createUser($role);

        $this->em->flush();
        $this->em->detach($role);

        $this->loginUser(self::USERNAME);
        $this->client->setServerParameter('PHP_AUTH_USER', self::USERNAME);
        $this->client->setServerParameter('PHP_AUTH_PW', 'mautic');

        return $user;
    }

    private function createRole(bool $isAdmin = false): Role
    {
        $role = new Role();
        $role->setName('Role');
        $role->setIsAdmin($isAdmin);

        $this->em->persist($role);

        return $role;
    }

    private function createUser(Role $role): User
    {
        $user = new User();
        $user->setFirstName('Jhony');
        $user->setLastName('Doe');
        $user->setUsername(self::USERNAME);
        $user->setEmail('john.doe@email.com');
        $encoder = self::$container->get('security.encoder_factory')->getEncoder($user);
        $user->setPassword($encoder->encodePassword('mautic', null));
        $user->setRole($role);

        $this->em->persist($user);

        return $user;
    }
}
