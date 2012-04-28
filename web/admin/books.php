<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	 <title>Students</title>
	<link rel="stylesheet" type="text/css" href="css/style.css"/>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
	<script type="text/javascript">
	$(document).ready(function() {
		$(".excerpt").click(function(obj) {
			$(this).children(".book-page").show();
		});
	});
	</script>
</head>
<body>
	<?	
		//ini_set('display_errors',1);
		//error_reporting(E_ALL|E_STRICT);
		require_once("../request.php");
		$request = new RBRequest();
		echo $request->getContentForStudent($_GET['user'],$_GET['book']);
	?>
</body>
</html>