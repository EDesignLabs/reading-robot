<?
//Request class handling api requests
require_once('includes/mysql_connect.php');

class RBRequest
{

	public function __construct()
	{

	}

	public function createPrompt( $user, $pid, $data)
	{
		$sql = "INSERT INTO rb_prompts (user, pid, data) VALUES ('$user','$pid','$data')";
		$response = mysql_query($sql);
		if ( $response )
			return 1;
		else 
			return 0;
	}
	
	public function getUserPrompts( $user)
	{
		$sql = 'SELECT user, pid, data FROM rb_prompts WHERE user="'.$user.'"';
		$response = mysql_query($sql);
		$json_data = array();
		$aPrompt   = array();
		while ($row = mysql_fetch_assoc($response))
		{
		  	$json_element = array(
			"user"=> $row[user] ,
			"pid"=> $row[pid],
			"data"=> $row[data]
		 	);
			array_push($aPrompt,$json_element);
		}
		$json_data[$user] = $aPrompt;

		$json_output = json_encode($json_data);
		return $json_output;

	}
	
	public function getPrompts()
	{
		$sql = 'SELECT user, pid, data FROM rb_prompts';
		$response = mysql_query($sql);
		$json_data = array();
		$aPrompt   = array();
		while ($row = mysql_fetch_assoc($response))
		{
		  	$json_element = array(
			"user"=> $row[user] ,
			"pid"=> $row[pid],
			"data"=> $row[data]
		 	);
			array_push($aPrompt,$json_element);
		}
		$json_data["prompts"] = $aPrompt;

		$json_output = json_encode($json_data);
		return $json_output;
		
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
			return "error";
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