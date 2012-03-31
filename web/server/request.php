<?php
//ini_set('display_errors',1);
//error_reporting(E_ALL|E_STRICT);
//api root touchpoint
require_once("lib/RBRequest.class.php");
$query = $_GET['query'];
$request = new RBRequest();

switch ( $query ) 
{
	case "createPrompt":
		$username = $_POST["user"];		
		$pid	  = $_POST["pid"];		
		$data 	  = $_POST["data"];				
		$query    = $request->createPrompt($username, $pid, $data);	
		echo $query;
		break;
	case "getUserPrompts":
		$username = $_POST["user"];
		$query    = $request->getUserPrompts($username);	
		echo $query;
		break;
	case "getPrompts":
		$query    = $request->getPrompts();	
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
	$name = date("dMYHis").uniqid($name);	 //do we need to pass in a file extension?	
	$uid = "null";
	$pid = "null";
	if ( $_POST['type'] ) 
		$type = $_POST['type'];		
	else  
		$type = "default";		
	$fileurl 	 = rawurlencode(basename( $_FILES['uploadedfile']['name']));
	$extension   = substr(strrchr(basename( $_FILES['uploadedfile']['name']), '.'), 1);
	$target_path = "uploads/";
	$target_path = $target_path . basename( $_FILES['uploadedfile']['name']); 
	if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) 
	{
		$sql = 'INSERT INTO rb_content (name, pid, datatype) VALUES ("'.$_FILES['uploadedfile']['name'].'","pid","'.$type.'")';
		$query = mysql_query($sql);
		echo "http://aphes.com/dtc/uploads/".$fileurl;
	 } else{
	  echo 0;
	 }
}
?>