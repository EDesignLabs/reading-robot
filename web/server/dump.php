<?php
//ini_set('display_errors',1);
//error_reporting(E_ALL|E_STRICT);
//api root touchpoint
require_once("lib/RBRequest.class.php");

$request = new RBRequest();
$query    = $request->getPrompts();	
echo $query;
