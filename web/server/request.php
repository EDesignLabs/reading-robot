<?php
//ini_set('display_errors',1);
//error_reporting(E_ALL|E_STRICT);
//api root touchpoint
require_once("lib/RBRequest.class.php");

if (isset( $_GET['query'] ) )$query = $_GET['query'];
else $query = "";
$request = new RBRequest();

switch ( $query ) 
{
	case "createPrompt":
		$username = $_POST["user"];		
		$book	  = $_POST["book"];		
		$data 	  = $_POST["data"];		
		$bookpage = $_POST["bookpage"];						
		$query    = $request->createPrompt($username, $book, $data, $bookpage);	
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
	case "getAllUsers":
		$query = $request->getAllUsers();
		echo $query;
		break;
	case "getAllUsers":
		$query = $request->getAllBooks();
		echo $query;
		break;		
	case "uploadData":
		dataUpload();
		break;
	default:
	//	echo "give me something to do";
		break;
}

function dataUpload()
{
	$name = date("dMYHis").uniqid($name);	 //do we need to pass in a file extension?	
	$uid = "null";
	if ( $_POST['pid'] ) 
		$pid = $_POST['pid'];		
	else  
		$pid = "default";
		
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
		$sql = 'INSERT INTO rb_content (name, pid, datatype) VALUES ("'.$_FILES['uploadedfile']['name'].'","'.$pid.'","'.$type.'")';
		$query = mysql_query($sql);
		echo "http://aphes.com/dtc/uploads/".$fileurl;
	 } else{
	  echo 0;
	 }
}
?>