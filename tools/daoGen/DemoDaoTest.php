<?php

class DemoDaoTest extends FixtureTestCase
{
    public $tblName = 'basic_demo';
    public $fixtures = [
        'basic_demo'
    ];

    public static $dao = null;

    public function setUp()
    {
        parent::setUp();

        if(self::$dao == null) {
            self::$dao = \src\DAOFactory::createDAO('DemoDir', 'Demo');
        }
    }

    public function additionProvider()
    {
        $fixtures = $this->getFixture($this->tblName);
        $data = [];
        foreach ($fixtures as $fixture) {
            $data[] = [$fixture];
        }
        return $data;
    }

<<<testFunctionList>>>
}