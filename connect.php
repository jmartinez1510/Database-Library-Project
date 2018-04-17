<?php
	// Query
	$t = $_GET['t'];
  $id = $_GET['id'];
  $cid = $_GET['cid'];
  $rent = $_GET['rent'];
  $pay = $_GET['pay'];
  $addpay = $_GET['addpay'];
  $newtotal = $_GET['newtotal'];
  $oldtotal = $_GET['oldtotal'];
  $paytotal = $_GET['paymenttotal'];
  $prstart = $_GET['prstart'];
  $prend = $_GET['prend'];
  $pid = $_GET['pid'];
  $renttransaction = $_GET['renttransaction'];


  // Connecting, selecting database
  $db_connection = pg_connect("host=localhost dbname=jmartinez3 user=jmartinez3 password=ztirq4Nild")
    or die('Could not connect to database' . pg_last_error());

  // Compile list of prints for rent  
  if($rent == 1){
    $query = "SELECT chID, fname, lname FROM cardholder WHERE lid='".$id."' ORDER BY chID;";
    $result = pg_query($query) or die('Query failed' . pg_last_error());
    while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
      $cardholder = array();
      foreach ($line as $col) {
        $cardholder[] = $col;
      }
      echo "<option value=\"" . $cardholder[0] . "\">";
      echo $cardholder[0] . " - ";
      echo $cardholder[1] . " " . $cardholder[2];
      echo "</option>";
    }
    pg_free_result($result);
    echo "</select><br><label for=\"sel1\">Print (select one):</label><select class=\"form-control\" id=\"print\">";
    $query = "SELECT printID, title, author FROM print WHERE lid='".$id."' AND pnumcopy > 0 ORDER BY title;";
    $result = pg_query($query) or die('Query failed' . pg_last_error());
    while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
      $print = array();
      foreach ($line as $col) {
        $print[] = $col;
      }
      echo "<option value=\"" . $print[0] . "\">";
      echo $print[1] . " - " . $print[2];
      echo "</option>";
    }
    echo "</select>";
    pg_free_result($result);
  }

  // Rent a print
  elseif($renttransaction == 1){
    // $start = date('Y-m-d', strtotime($prstart));
    // $end = date('Y-m-d', strtotime($prend));
    // $start = strval($prstart);
    // $end = strval($prend);
    $insert = "INSERT INTO rentprint (prstart, prend, chID, printID) VALUES ('".$prstart."','".$prend."',".$cid.",".$pid.")";
    $result = pg_query($insert) or die('Query failed' . pg_last_error());
    if (!$result) {
      echo "Error updating record: " . $db_connection->error;
      exit;
    } else {
      $query = "SELECT fname, lname FROM cardholder WHERE chID=".$cid;
      pg_free_result($result);
      $result = pg_query($query) or die('Query failed' . pg_last_error());
      while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
        $cardholder = array();
        foreach ($line as $col) {
          $cardholder[] = $col;
        }
        echo "<br><b>Name:</b> ". $cardholder[0] . " " . $cardholder[1];
      }
      $query = "SELECT title, author FROM print WHERE printID=".$pid;
      pg_free_result($result);
      $result = pg_query($query) or die('Query failed' . pg_last_error());
      while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
        $print = array();
        foreach ($line as $col) {
          $print[] = $col;
        }
        echo "<br><b>Print ID:</b> ". $pid;
        echo "<br><b>Title:</b> ".$print[0];
        echo "<br><b>Author:</b> ".$print[1];
      }
      echo "<br><b>Date: </b>". $prstart;
      echo "<br>Due by <b><div style=\"color:red\">" .$prend ."</div></b>";
      pg_free_result($result);
    }
  }

  // Late Fee Payments
  elseif($pay == 1){
    $query = "SELECT chID, fname, lname, latefees FROM cardholder WHERE latefees > 0 AND lid='".$id."';";
    $result = pg_query($query) or die('Query failed' . pg_last_error());
    echo "<table><tr><th>ID</th><th>First</th><th>Last</th><th>Overdue Fees</th></tr>\n";
    while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
      echo "\t<tr data-toggle=\"modal\" data-target=\"#payment\" onclick=\"payModal(";
      $x = 0;
      foreach ($line as $col) {
        if($x == 0){
          echo $col;
          echo ")\">\n\t\t<td>";
          echo $col;
          echo "</td>\n";
          $x++;
        }
        else{
          echo "\t\t<td>";
          echo $col;
          echo "</td>\n";
        }    
      }
      echo "\t</tr>\n";
    }
    echo"</table>\n";
    pg_free_result($result);
  }

  // Change fee total after payment
  elseif($addpay == 1){
    $update = "UPDATE cardholder SET latefees=" .$newtotal. " WHERE chID=".$cid;
    // if ($db_connection->query($update) === TRUE) {
    //   echo "Record updated successfully";
    // } else {
    //   echo "Error updating record: " . $db_connection->error;
    // }
    $result = pg_query($db_connection, $update);
    if (!$result) {
      echo "Error updating record: " . $db_connection->error;
      exit;
    } else {
      echo "<div style=\"color:red\">Record updated successfully</div><br>";
      $query = "SELECT chID, fname, lname, latefees FROM cardholder WHERE chID=". $cid;
      $result = pg_query($query) or die('Query failed' . pg_last_error());
      $cardholder = array();
      while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
        foreach ($line as $col) {
          $cardholder[] = $col;
        }
      }
      echo "<b>ID:</b> ". $cardholder[0];
      echo "<br><b>Name:</b> " . $cardholder[1] . " " . $cardholder[2];
      echo "<br><b>Late Fee:</b> $" . $oldtotal;
      echo "<br><b>Payment Amount:</b> $" . $paytotal;
      echo "<br>_____________________________________";
      echo "<br><b>New Total:</b> $" . $cardholder[3];
    }
    pg_free_result($result);

  }

  // Order History
  elseif(is_null($t)){
    $query = "SELECT print.title, print.author, rentprint.prstart, rentprint.prend FROM print, cardholder, rentprint WHERE cardholder.chID =".$cid. " AND rentprint.chID = cardholder.chID AND rentprint.printID = print.printID AND cardholder.lID=".$id.";";
    $result = pg_query($query) or die('Query failed' . pg_last_error());
    echo "<table><tr><th>Title</th><th>Author</th><th>Rental Date</th><th>Due Date</th></tr>\n";
    while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
      echo "\t<tr>\n";
      foreach ($line as $col) {
        echo "\t\t<td>";
        echo $col;
        echo "</td>\n";     
      }
      echo "\t</tr>\n";
    }
    echo"</table>\n";
    pg_free_result($result);
  }

  // Database tables
  elseif(is_null($cid)){
    // echo "<table>\n";
    // Performing query
    $query = "SELECT * FROM ".$t." WHERE lid='".$id."'";
    $result = pg_query($query) or die('Query failed' . pg_last_error());
    while($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
      // if cardholder
      if($t == "cardholder") {
        echo "\t<tr data-toggle=\"modal\" data-target=\"#orderHistory\" onclick=displayHistory(";
        $x = 0;
        foreach ($line as $col) {
          if($x == 0){
            echo $col;
            echo ")>";
            $x++;
          } 
          echo "\t\t<td>$col</td>\n";     
        }
        // echo "\t\t<td><a href=\"#\">$col</a></td>\n";
        
      } else {
        echo "\t<tr>\n";      
        // echo "\t<tr onclick=\"input\" data-toggle=\"modal\" target=\"#myModal\">\n";
        foreach ($line as $col) {
          // echo "\t\t<td><a href=\"#\">$col</a></td>\n";
          echo "\t\t<td>$col</td>\n";
        }
      }

      echo "\t</tr>\n";
    }
    echo"</table>\n";

    pg_free_result($result);
  }

  pg_close($db_connection);
  ?>