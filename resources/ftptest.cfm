<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>ORPA FTP ActiveSocket Test Page</title>
</head>

<body>
<h2>FTP to _HOLD_ Test<br>in ColdFusion</h2>

  <div >
  	<table>
		<!--- Open the session --->
    <cfinvoke component='script.act_socket' method='openFTP' returnVariable='result'></cfinvoke>
    	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>

    
    </table>

 	</div>
	 
<br>

<a href="http://www.activexperts.com">This sample is using ActiveXperts Software</a>.


</body>

</body>
</html>
