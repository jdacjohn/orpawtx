<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Test Page</title>
</head>

<body>
<h2>Day of Week As String Test</h2>

  <div >
	<cfset dayName = DayofWeekAsString(DayOfWeek(Now()))>
  <cfoutput>
  	#dayName#<br />
	</cfoutput>
	<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
  	Today is not a weekend.<br />
  </cfif>

 	</div>
	 
<br>




</body>

</body>
</html>
