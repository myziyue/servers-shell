<?php
//作为接口传输的时候认证的密钥
$valid_token = 'tokenstr';
//调用接口被允许的ip地址
$valid_ip = array('127.0.0.1');
$client_token = $_GET['token'];
$client_ip = $_SERVER['REMOTE_ADDR'];
file_put_contents("deploy-git-".date("Y-m-d").".log", 'Request on ['.date("Y-m-d H:i:s").'] from ['.$client_ip.']'.PHP_EOL, FILE_APPEND);
if ($client_token !== $valid_token)
{
    echo "error 10001";
    file_put_contents("deploy-git-".date("Y-m-d").".log", "Invalid token [{$client_token}]\n\r", FILE_APPEND);
    exit(0);
}
if ( ! in_array($client_ip, $valid_ip))
{
    echo "error 10002";
    fwrite($fs, "Invalid ip [{$client_ip}]".PHP_EOL);
    file_put_contents("deploy-git-".date("Y-m-d").".log", "Invalid ip [{$client_ip}]\n\r", FILE_APPEND);
    exit(0);
}
$json = file_get_contents('php://input');
$data = json_decode($json, true);
file_put_contents("deploy-git-".date("Y-m-d").".log", "Data: ".print_r($data, true)."\n\r", FILE_APPEND);
file_put_contents("deploy-git-".date("Y-m-d").".log", "=======================================================================\n\r", FILE_APPEND);
//这里也可以执行自定义的脚本文件update.sh，脚本内容可以自己定义。
exec("/bin/sh /mnt/shell/deploy/deploy.sh");
//exec("cd  /path/project;/usr/bin/git pull");
