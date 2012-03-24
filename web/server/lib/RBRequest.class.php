<?
//Request class handling api requests
require_once('includes/mysql_connect.php');

class RBRequest
{

	public function __construct()
	{

	}

	public function getEntriesForUser( $user )
	{
		$sql      = 'SELECT entries FROM users WHERE user="'.$user.'"';
		$response = mysql_query($sql);

	}

	public function getUser ( $user ) 
	{
		if (strlen($user) == 0 || !$user) return 0;
		$sql      = 'SELECT * FROM rb_users WHERE username="'.$user.'"';
		$response = mysql_query($sql);		
		if ( mysql_num_rows($response) > 0 ) 
			return 1; 
		else 
			return 0;
	}
	
	public function checkPassword( $user, $password)
	{
		if (strlen($user) == 0 || !$user || strlen($password) == 0 || !$password) return 0;
		$sql      = 'SELECT password FROM rb_users WHERE username="'.$user.'"';
		$response = mysql_query($sql);		
		$pass = mysql_fetch_assoc($response);
		if ( $pass['password'] == $password)
			return 1;
		else 
			return 0;
	}

	public function createUser( $user , $password )
	{
		//TODO: only allow for uniuq "user" entries
		if (strlen($user) == 0 || !$user || strlen($password) == 0 || !$password) return 0;
		$hash = md5($user);
		$sql = "INSERT INTO rb_users (username, password, uid) VALUES ('$user','$password','$hash')";
		$response = mysql_query($sql);
		if ( $response )  
			return 1;
		else 
			return 0;

	}

}

?>