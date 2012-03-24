<?php
ini_set('display_errors',1);
error_reporting(E_ALL|E_STRICT);
//api root touchpoint
require_once("lib/RBRequest.class.php");
$query = $_GET['query'];
$request = new RBRequest();

switch ( $query ) 
{
	case "getUser":
		$username = $_POST["user"];
		$query    = $request->getUser($username);	
		echo $query;
		break;
	case "createUser":
		$username = $_POST["user"];
		$password = $_POST["password"];
		$query    = $request->createUser($username, $password);	
		echo $query;
		break;
	case "checkPassword":
		$username = $_POST["user"];
		$password = $_POST["password"];
		$query = $request->checkPassword( $username, $password);	
		echo $query;
		break;	
	case "uploadData":
		dataUpload();
		break;
	default:
		echo "give me something to do";
		break;
}

function dataUpload()
{
	$name = $_POST['name'];
	$uid = "null";//$_POST['uid']";
	$pid = $_POST['pid'];	
	$type = $_POST['type'];		
	$fileurl 	 = rawurlencode(basename( $_FILES['uploadedfile']['name']));
	$extension   = substr(strrchr(basename( $_FILES['uploadedfile']['name']), '.'), 1);
	$target_path = "uploads/";
	$target_path = $target_path . basename( $_FILES['uploadedfile']['name']); 
	if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) 
	{
		$sql = 'INSERT INTO rb_content (name, pid, uid) VALUES ("'.$_FILES['uploadedfile']['name'].'","'.$filesize.'","'.$extension.'","genre","'.$fileurl.'", "1")';
		$query = mysql_query($sql);
		echo 1;
	 } else{
	  echo 0;
	 }
}
?>