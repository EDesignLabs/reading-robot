<?php
//api root touchpoint
require_once("lib/RBRequest.class.php");
$request = new RBRequest();
$request->createUser("user", "password");
?>