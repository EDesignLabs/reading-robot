<?php

require_once("config.php");

$link = mysql_connect(
  DBSERVER,
  DBUSER,
  DBPASS
);
mysql_select_db(DBNAME,$link);

?>