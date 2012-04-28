<?
//Request class handling api requests
require_once('../includes/mysql_connect.php');

class RBRequest
{

	public function __construct()
	{

	}

	public function createPrompt( $user, $book, $data, $bookpage)
	{
		$sql = "INSERT INTO rb_prompts (user, book, data, book_page) VALUES ('$user','$book','$data','$bookpage')";
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
	
	public function getAllUsers()
	{
		$sql      = 'SELECT user, create_date FROM rb_prompts GROUP BY user';
		$response = mysql_query($sql);
		$li = "<table>";
		$li .= "<tr><th>Student</th><th>Latest Activity</th></tr>";
		while ($row = mysql_fetch_assoc($response))
		{
			$li .= "<tr>";
			$li .= "<td><a href=\"users.php?user=".$row['user']."\">".$row['user']."</a></td><td>".date("F j, Y, g:i a", strtotime($row['create_date']))."</td>";
			$li .= "</tr>";	
		}
		$li .= "</table>";
		return $li;	
	}
	
	public function getAllBooksForUser($user)
	{
		$sql 	  = 'SELECT book, create_date FROM rb_prompts WHERE user="'.$user.'" GROUP BY book';
		$response = mysql_query($sql);
		$li = "<h1>List of all books read by ".$user."</h1>";
		$li .= "<table>";
		$li .= "<tr><th>Book</th><th>Latest Activity</th></tr>";
		while ($row = mysql_fetch_assoc($response))
		{
			$li .= "<tr>";
			$li .= "<td><a href=\"books.php?user=".$user."&book=".$row['book']."\">".$row['book']."</a></td><td>".date("F j, Y, g:i a", strtotime($row['create_date']))."</td>";
			$li .= "</tr>";	
		}
		$li .= "</table>";
		return $li;
	}

	public function getContentForStudent($user,$book)
	{
		$sql 	  = 'SELECT create_date, data, book_page FROM rb_prompts WHERE user="'.urldecode($user).'" AND book="'.urldecode($book).'"';
		$response = mysql_query($sql);
		$payload  = "<h1>".$user."</h1>";
		$payload .= "<h2>".$book."</h2>";
		while ($row = mysql_fetch_assoc($response))
		{	
			$payload .= "<div>";
			$payload .= "<p><b>PROMPT AND ANSWER: </b><br/><br/>".$row['data']."</p>";
			$payload .= "<div class=\"excerpt\"><b>CLICK TO SEE EXCERPT: </b><br/><br/> <p class=\"book-page\" style=\"display:none\">".$row['book_page']."</p></div>";
			$payload .= "</div>";			
		}
		return $payload;
	}
}

?>