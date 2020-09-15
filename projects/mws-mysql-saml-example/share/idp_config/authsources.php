<?php

$config = array(

    'admin' => array(
        'core:AdminPassword',
    ),

    'example-userpass' => array(
        'exampleauth:UserPass',
        'user1:user1pass' => array(
            'uid' => array('1'),
            'eduPersonAffiliation' => array('group1'),
            'email' => 'user1@example.com',
        ),
        'user2:user2pass' => array(
            'uid' => array('2'),
            'eduPersonAffiliation' => array('group2'),
            'email' => 'user2@example.com',
        ),
        'myhael76:myhael76' => array(
            'uid' => array('2'),
            'eduPersonAffiliation' => array('SamlSinkRole'),
            'email' => 'myhael76@acme.com',
        ),
        'Administrator:manage' => array(
            'uid' => array('2'),
            'eduPersonAffiliation' => array('My webMethods Administrators'),
            'email' => 'admin@acme.com',
        ),
        'sysadmin:manage' => array(
            'uid' => array('2'),
            'eduPersonAffiliation' => array('My webMethods Administrators'),
            'email' => 'sysadmin@acme.com',
        ),
    ),

    'https://mws:8787' => array(
        'saml:SP',
        'entityID' => 'https://mws:8787',
        'idp' => 'http://localhost:8080/simplesaml/saml2/idp/metadata.php',
    ),

);