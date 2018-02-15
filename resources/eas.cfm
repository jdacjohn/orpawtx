<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EAS Script</title>
</head>

<body>
<h2>EAS - Telnet</h2>

  <div >

		<!--- Open the session --->
    <cfinvoke component='script.act_socket' method='openTelnet' returnVariable='sockContainer'></cfinvoke>
    <!--- Run the Reg Report --->
    <cfinvoke component='script.act_socket' method='runEAS' returnVariable='sockContainer' openSocket="#sockContainer#"></cfinvoke>
		<!--- Close the session --->
    <cfinvoke component='script.act_socket' method='closeSocket' openSocket="#sockContainer#"></cfinvoke>

 	</div>
<h2>FTP to _HOLD_</h2>

  <div >
  	<table>
		<!--- Open the session --->
		<cfinvoke component='script.act_socket' method='downloadEASData' returnVariable='result'></cfinvoke>
    	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>
    </table>
 	</div>

<h2>Load EAS Data to EAS_Stucourseinfo DATABASE</h2>
    <cfinvoke component='script.act_socket' method='loadEASData'></cfinvoke>

</body>

</html>
