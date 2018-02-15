<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SLO Notifications Scripting</title>
</head>

<body>
<h2>SLO Automatic E-Mail Notification</h2>

  <div >

	<!--- Open the session --->
  <cfinvoke component='script.slo_notify' method='notifySLO' sendmail=0></cfinvoke>
	<cfoutput>
  	<cfset deadline = DateFormat('2010-03-03' - 14,'mm/dd/yyyy')>
    #deadline#
  </cfoutput>
 	</div>
	 
<br>


</body>

</body>
</html>
