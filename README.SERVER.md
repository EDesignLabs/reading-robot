###Setup
Fill in the database constants in **includes/config.php** with your server's matching credentials. 
<pre>
define("DBSERVER", "localhost");
define("DBNAME", "aphescom_dtc");
define("DBUSER", "aphescom_justin");
define("DBPASS", "aphescom_justin");
</pre>

###Endpoints
*Note: Currently, all requests parameters use POST.*
####Check Password
<pre>
Params:
	user -> username
	password -> password
http://aphes.com/dtc/request.php?query=checkPassword
</pre>

####Get User
<pre>
Params:
	user -> username
http://aphes.com/dtc/request.php?query=getUser
</pre>

####Create Prompt
<pre>
Params: 
	user -> username
	book -> book/article name
	data -> prompt data in JSON format
	bookpage -> page number
http://aphes.com/dtc/request.php?query=createPrompt
</pre>

####Get Prompts for User
<pre>
Params: 
	user -> username
http://aphes.com/dtc/request.php?query=getUserPrompts
</pre>

####Get All Prompts
<pre>
Params: none 
http://aphes.com/dtc/request.php?query=getPrompts
</pre>

####Create User
<pre>
Params: 
	user -> username
	password -> password
http://aphes.com/dtc/request.php?query=createUser
</pre>


####Get All Users
<pre>
Params: none
http://aphes.com/dtc/request.php?query=getAllUsers
</pre>


####Upload recording
<pre>
Params: 
	pid  -> post id 
	type -> type of file
	FILE -> uploaded file
http://aphes.com/dtc/request.php?query=uploadData
</pre>

		

