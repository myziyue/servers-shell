<?php
/**
 * Created by PhpStorm.
 *
 * @author Bi Zhiming <evan2884@gmail.com>
 * @created 2017/3/29  上午9:54
 * @since 1.0
 */
include_once 'index.php';

// dao path
defined('Model_PATH') or define('Model_PATH', __DIR__ . DIRECTORY_SEPARATOR . 'model' . DIRECTORY_SEPARATOR);
// phpunit path
defined('PHPUNIT_PATH') or define('PHPUNIT_PATH', __DIR__ . DIRECTORY_SEPARATOR . 'tests' . DIRECTORY_SEPARATOR);
defined('PHPUNIT_Model_PATH') or define('PHPUNIT_Model_PATH',
    PHPUNIT_PATH . DIRECTORY_SEPARATOR . 'unit' . DIRECTORY_SEPARATOR . 'model' . DIRECTORY_SEPARATOR);
defined('PHPUNIT_FIXTURES_PATH') or define('PHPUNIT_FIXTURES_PATH',
    PHPUNIT_PATH . DIRECTORY_SEPARATOR . 'fixture' . DIRECTORY_SEPARATOR);
defined('PHPUNIT_DATA_PATH') or define('PHPUNIT_DATA_PATH',
    PHPUNIT_PATH . DIRECTORY_SEPARATOR . 'data' . DIRECTORY_SEPARATOR);
defined('PHPUNIT_DEMO_FILE') or define('PHPUNIT_DEMO_FILE', __DIR__ . DIRECTORY_SEPARATOR . 'DemoModelTest.php');

// database
defined('DB_HOST') or define('DB_HOST', '121.43.190.15');
defined('DB_PORT') or define('DB_PORT', 3306);
defined('DB_NAME') or define('DB_NAME', 'bcw_basic_online_0918');
defined('DB_NAME_DEST') or define('DB_NAME_DEST', 'bcw_basic_test');
defined('DB_USER') or define('DB_USER', 'root');
defined('DB_PASS') or define('DB_PASS', 'bcw@123');
defined('DB_CHARSET') or define('DB_CHARSET', 'utf-8');

$dbInstrance = new \PDO('mysql:host=' . DB_HOST . ':' . DB_PORT . ';dbname=' . DB_NAME, DB_USER, DB_PASS);
$dbInstrance->exec('SET character_set_connection=' . DB_CHARSET . ', character_set_results=' . DB_CHARSET . ', character_set_client=binary');

$dbInstranceDest = new \PDO('mysql:host=' . DB_HOST . ':' . DB_PORT . ';dbname=' . DB_NAME_DEST, DB_USER, DB_PASS);
$dbInstranceDest->exec('SET character_set_connection=' . DB_CHARSET . ', character_set_results=' . DB_CHARSET . ', character_set_client=binary');

if ($handle = opendir(Model_PATH)) {
    echo "Generate PHPUnit Test Directory: \n";

    /* 这是正确地遍历目录方法 */
    while (false !== ($dir = readdir($handle))) {
        if (!in_array($dir, ['.', '..']) && is_dir(Model_PATH . DIRECTORY_SEPARATOR . $dir)) {
            $PHPUnitPath = PHPUNIT_Model_PATH . $dir;
            if (!file_exists($PHPUnitPath)) {
                mkdir($PHPUnitPath);
                echo "Generate Directory : $PHPUnitPath \n";
            }

            if ($handleSon = opendir(Model_PATH . DIRECTORY_SEPARATOR . $dir)) {
                while (false !== ($file = readdir($handleSon))) {
                    $fileName = str_replace('.php', 'Test.php', $file);
                    $daoFile = Model_PATH . DIRECTORY_SEPARATOR . $dir . DIRECTORY_SEPARATOR . $file;
                    $PHPUnitTestFile = $PHPUnitPath . DIRECTORY_SEPARATOR . $fileName;
                    if (!file_exists($PHPUnitTestFile)) {
                        $tblName = getFixtures($daoFile);
                        $daoFunctions = getModelClassFunctions($dir, $file);
                        generateFile($tblName, $PHPUnitTestFile, $dir, $daoFunctions);
                        generateFixturesAndData($tblName, $dbInstrance, $dbInstranceDest);
                        echo "Generate PHPUnit Test File : $PHPUnitTestFile \n";
                    }
                }

                closedir($handleSon);
            }
        }
    }
    closedir($handle);
}


function generateFile($tblName, $file, $dir, $functions)
{
    copy(PHPUNIT_DEMO_FILE, $file);
    $fileInfo = file_get_contents($file);
    $fileName = pathinfo($file, PATHINFO_FILENAME);
    $fileInfo = str_replace('DemoModelTest', $fileName, $fileInfo);
    $fileInfo = str_replace('DemoDir', $dir, $fileInfo);
    $fileInfo = str_replace('Demo', str_replace('ModelTest', '', $fileName), $fileInfo);
    $fileInfo = str_replace('basic_demo', $tblName, $fileInfo);
    //
    $funStr = '';
    if($functions) {
        foreach($functions as $fun) {
            $funStr .= "
    /**
     * @dataProvider additionProvider
     */
     public function test". ucfirst($fun) . "(" . lcfirst('$' . str_replace('Test', '', lcfirst($fileName))) . ") {
     }
     ";
        }
    }
    $fileInfo = str_replace('<<<testFunctionList>>>', $funStr, $fileInfo);
    file_put_contents($file, $fileInfo);
}

function getFixtures($daoFile)
{
    preg_match_all("/TABLE_INFO(\s)=(\s)'.*'/", file_get_contents($daoFile), $tblName);
    if (isset($tblName[0][0])) {
        preg_match_all("/'.*'/", $tblName[0][0], $tblName);
        return str_replace("'", '', $tblName[0][0]);
    }
    return '';
}

function generateFixturesAndData($tblName, $dbInstrance, $dbInstranceDest)
{
    if (!$tblName) {
        return '';
    }
    $sql = 'SHOW FULL COLUMNS FROM ' . $tblName;
    $result = [];
    foreach ($dbInstrance->query($sql, \PDO::FETCH_ASSOC) as $row) {
        $result[] = $row['Field'];
    }
    $fieldStr = '';
    foreach ($result as $field) {
        $fieldStr .= "      '" . $field . "' => '',\n";
    }
    $tblInfo = "
<?php
return [
    [\n" . $fieldStr . "   ]
];
";
    if (!file_exists(PHPUNIT_FIXTURES_PATH . $tblName . '.php')) {
        file_put_contents(PHPUNIT_FIXTURES_PATH . $tblName . '.php', $tblInfo);
        $sqlDest = 'CREATE TABLE ' . $tblName . ' SELECT  * FROM ' . DB_NAME . '.' . $tblName . " LIMIT 30";
        $dbInstranceDest->exec($sqlDest);
    }

    if (!file_exists(PHPUNIT_DATA_PATH . $tblName . '.sql')) {
        file_put_contents(PHPUNIT_DATA_PATH . $tblName . '.sql', '');
    }
}

function getModelClassFunctions($dir, $file)
{
    $parentFunctions = [
        "__construct",
    ];
    $classFuns = get_class_methods('\\model\\' . $dir . '\\' . pathinfo($file, PATHINFO_FILENAME));
    if(is_array($classFuns)){
        return array_diff($classFuns, $parentFunctions);
    }
    return '';
}
