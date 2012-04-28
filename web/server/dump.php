<?php
//ini_set('display_errors',1);
//error_reporting(E_ALL|E_STRICT);
//api root touchpoint
require_once("lib/RBRequest.class.php");

$request = new RBRequest();
$query    = $request->getPrompts();	
var_dump(json_decode($query, true));


$sql = 'SELECT username FROM rb_users';
$response = mysql_query($sql);
echo "\n";
echo "\n";
while ($row = mysql_fetch_assoc($response))
{
	echo "user: " . $row['username'];
	echo "\n";
}
