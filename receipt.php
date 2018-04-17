<?php
	$id = $_GET['id'];
	$chid = $_GET['chid'];

	$db_connection = pg_connect("host=localhost dbname=jmartinez3 user=jmartinez3 password=ztirq4Nild")
    or die('Could not connect to database' . pg_last_error());

    $query = "SELECT fname, lname, latefees FROM cardholder WHERE chID='".$chid."' AND lid=".$id.";";
    $result = pg_query($query) or die('Query failed' . pg_last_error());
    $cardholder = array();
    while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
    	foreach ($line as $col) {
    		$cardholder[] = $col;
      	}
      	echo json_encode($cardholder);
	}
    
    pg_free_result($result);
	pg_close($db_connection);
?>