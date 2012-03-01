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
    
    public function createUser( $user , $password )
    {
		//TODO: only allow for uniuq "user" entries
        $sql = "INSERT INTO rb_users (username, password) VALUES ('$user','$password')";
        $response = mysql_query($sql);
		echo $sql;
        if ( $response )  
			return "success";
		else 
			return "fail";
           
    }
    
}

?>