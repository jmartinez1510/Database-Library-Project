<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="index.css">
  <script>
  function showQuery(str) {
      if (str == "") {
          document.getElementById("content").innerHTML = "";
          return;
      } else { 
          if (window.XMLHttpRequest) {
              // code for IE7+, Firefox, Chrome, Opera, Safari
              xmlhttp = new XMLHttpRequest();
          } else {
              // code for IE6, IE5
              xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
          }
          xmlhttp.onreadystatechange = function() {
              if (this.readyState == 4 && this.status == 200) {
                  tablestr = "<table>";
                  if (str == "employee") {
                    tablestr += "<tr><th>ID</th><th>Last Name</th><th>First Name</th><th>SSN</th><th>Address</th><th>State</th><th>Phone</th><th>E-mail</th><th>Date of Birth</th><th>Payrate</th><th>Position</th><th>Library</th></tr>";
                  }
                  if (str == "print") {
                    tablestr += "<tr><th>ID</th><th>ISBN</th><th>Publisher</th><th>Issue Date</th><th>Copies</th><th>Author</th><th>Library</th><th>Title</th><th>Year</th><th>Genre</th></tr>";
                  }
                  if (str == "electronic") {
                    tablestr += "<tr><th>ID</th><th>Production</th><th>Visual</th><th>Copies</th><th>Library</th><th>Title</th><th>Year</th><th>Genre</th></tr>";
                  }
                  if (str == "studyrooms") {
                    tablestr += "<tr><th>ID</th><th>Capacity</th><th>Purpose</th><th>Location</th><th>Library</th></tr>";
                  }
                  if (str == "cardholder") {
                    tablestr += "<tr><th>ID</th><th>Last Name</th><th>First Name</th><th>Address</th><th>State</th><th>Phone</th><th>E-mail</th><th>Date of Birth</th><th>Fees</th><th>Library</th></tr>";
                  }
                  tablestr += this.responseText;
                  tablestr += "</table>";
                  // document.getElementById("content").innerHTML += this.responseText;
                  document.getElementById("content").innerHTML = tablestr;
              }
          };
          xmlhttp.open("GET","connect.php?t="+str+"&id=1",true);
          xmlhttp.send();
      }
  }
  function displayLib() {
    document.getElementById("content").innerHTML = "<center><h1>Bakersfield Public Library</h1><br>123 Stockdale Hwy<br>Bakersfield, CA 93309<br>661 &middot; 432 &middot; 1235</center>";
  }
  function displayHistory(cid){
    if (window.XMLHttpRequest) {
      // code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp = new XMLHttpRequest();
    } else {
        // code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          document.getElementById("history").innerHTML = this.responseText;
        }
    };
    xmlhttp.open("GET","connect.php?id=1&cid="+cid,true);
    xmlhttp.send();
  }
  function rentPrint() {
    if (window.XMLHttpRequest) {
      // code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp = new XMLHttpRequest();
    } else {
        // code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          rent = "<div class=\"form-group\"><label for=\"sel1\">Renter ID (select one):</label><select class=\"form-control\" id=\"renter\">";
          rent += this.responseText;
          rent += "</div><button type=\"button\" class=\"btn btn-info btn-lg\" onclick=\"rentTransaction()\" data-toggle=\"modal\" data-target=\"#rentModal\">Rent Print</button>";
          document.getElementById("content").innerHTML = rent;
        }
    };
    xmlhttp.open("GET","connect.php?id=1&rent=1",true);
    xmlhttp.send();
  } 
  function rentTransaction(){
    cardholder = document.getElementById("renter").value;
    print = document.getElementById("print").value;
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1;
    var yyyy = today.getFullYear();
    if(dd<10) {
        dd = '0'+dd
    } 
    if(mm<10) {
        mm = '0'+mm
    } 
    today = yyyy + '-' + mm + '-' + dd;
    var due = new Date();
    due.setDate(due.getDate() + 7); 
    ddd = due.getDate();
    dmm = due.getMonth()+1;
    dyyyy = due.getFullYear(); 
    if(ddd<10) {
        ddd = '0'+ddd
    } 
    if(dmm<10) {
        dmm = '0'+dmm
    } 
    due = dyyyy + '-' + dmm + '-' + ddd;
    setRent(today, due, cardholder, print);
  }
  function setRent(today,due,cardholder,print) {
    if (window.XMLHttpRequest) {
      // code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp = new XMLHttpRequest();
    } else {
        // code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          rentalreceipt = "<b>ID:</b> " + cardholder;
          rentalreceipt += this.responseText;
          document.getElementById("printrental").innerHTML = rentalreceipt;
        }
    };
    url = "connect.php?renttransaction=1&prstart=" + today + "&prend=" + due + "&cid=" + cardholder + "&pid=" + print;
    xmlhttp.open("GET",url,true);
    xmlhttp.send();
  }
  function payOverdue() {
    if (window.XMLHttpRequest) {
      // code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp = new XMLHttpRequest();
    } else {
        // code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          document.getElementById("content").innerHTML = this.responseText;
        }
    };
    xmlhttp.open("GET","connect.php?id=1&pay=1",true);
    xmlhttp.send();
  }
  function payModal(chid){
    recURL = 'receipt.php?id=1&chid=' + chid;
    $.ajax({
      url: recURL,
      dataType: 'json'
    }).done(
      function(data){
        var fname = data[0];
        var lname = data[1];
        var fees = data[2];
        payform = "<b>Name:</b> " + fname + " " + lname; 
        payform += "<br><b>Amount Due:</b> $" + fees;
        payform += "<br>";
        payform += "<b><div id=\"payname\">Payment Amount:</b> $<div class=\"form-group row\"><div class=\"col-xs-2\"><input class=\"form-control\" id=\"paid\" type=\"text\" onchange=\"paidMath(" + fees + "," + chid + ")\"></div></div>";
        document.getElementById("pay").innerHTML = payform;
        document.getElementById("newtotal").innerHTML = "";
        document.getElementById("receipt").innerHTML = "Pay Overdue Fees";
      });
  }
  function paidMath(oldtotal,chid)
  {
    var paymentamount = document.getElementById("paid").value;
    var newtotal = (oldtotal - paymentamount).toFixed(2);
    document.getElementById("newtotal").innerHTML = "<b>New Total:</b> $" + newtotal + "<div id=\"confirmpay\"><buton type=\"button\" class=\"btn btn-default\" onclick=\"addPayment(" + newtotal + "," + chid + "," + oldtotal + "," + paymentamount + ")\">Confirm Payment</button></div>"
  }
  function addPayment(newtotal,chid,oldtotal,paymentamount){
    if (window.XMLHttpRequest) {
      // code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp = new XMLHttpRequest();
    } else {
        // code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          document.getElementById("pay").innerHTML = this.responseText;
          document.getElementById("newtotal").innerHTML = "";
          document.getElementById("receipt").innerHTML = "Receipt";
        }
    };
    xmlhttp.open("GET","connect.php?id=1&addpay=1&cid=" + chid + "&newtotal=" + newtotal + "&oldtotal=" + oldtotal + "&paymenttotal=" +paymentamount,true);
    xmlhttp.send();
  }
  </script>
</head>
<body onload="displayLib()">
  <header>
      <img src="header2.png" alt="lib">
  </header>
  <nav class="navbar">
    <ul class="nav navbar-nav navbar-center">
      <li class="active"><a href="index.php">Bakersfield</a></li>
      <li><a href="fullerton.php">Fullerton</a></li>
      <li><a href="sacramento.php">Sacramento</a></li>
    </ul>
  </nav>
  <div class="container-fluid">
  <div class="row">
    <div class="col-sm-2">
        <ul>
          <li><a onclick="displayLib()">Home</a></li>
          <li><a onclick="showQuery('employee')">Employee</a></li>
          <li><a onclick="showQuery('print')">Prints</a></li>
          <li><a onclick="showQuery('electronic')">Electronics</a></li>
          <li><a onclick="showQuery('studyrooms')">Study Rooms</a></li>
          <li><a onclick="showQuery('cardholder')">Cardholder</a></li>
          <br><br><br>
          <li><button type="button" class="btn btn-info btn-lg" onclick="rentPrint()" style="width:100px;">Rent</button></li>
          <li><button type="button" class="btn btn-info btn-lg" onclick="payOverdue()" style="width:100px;">Pay</button></li>
        </ul>
    </div>
    <div class="col-sm-10">
      <p id="content"></p>
    </div></div>
  <!-- Modal -->
<div id="orderHistory" class="modal fade" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Rental History</h4>
      </div>
      <div class="modal-body">
        <div id="history"><p></p></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<div id="payment" class="modal fade" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 id="receipt" class="modal-title">Pay Overdue Fees</h4>
      </div>
      <div class="modal-body">
        <div id="pay"></div>
        <br><div id="newtotal" style="color:red;"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="payOverdue()">Close</button>
      </div>
    </div>
  </div>
</div>
<div id="rentModal" class="modal fade" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Rental Receipt</h4>
      </div>
      <div class="modal-body">
        <div id="printrental"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</div>
  <footer>Copyright &copy; CaliforniaPublicLibraryService</footer>
</body>
</html>
