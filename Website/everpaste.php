<?php
	$db_user = "";
	$db_pass = "";
	
    $data = $_POST['data'];
    $inserted = $_POST['inserted'];

    $link = mysql_connect('localhost', $db_user, $db_pass);
    mysql_select_db('everpaste', $link);

    /* lets make sure we don't have it already */
    $query = sprintf("SELECT * FROM pastes WHERE content='%s'",
         mysql_real_escape_string($data));

    $result = mysql_query($query);
    if ( mysql_num_rows($result) == 0){
        $query = sprintf("INSERT INTO pastes VALUES('','%s','%s')",
            mysql_real_escape_string($inserted),
            mysql_real_escape_string($data));

        $result = mysql_query($query);
        if (!$result) {
            $message  = 'Invalid query: ' . mysql_error() . "\n";
        }
        else{
            $message = $data;
        }
    }

    mysql_close($link);

    print $message;
?>