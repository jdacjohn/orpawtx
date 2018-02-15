<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Returning Student Registration Progress</title>
</head>

<body>
<h2>Returning Student Registration Progress</h2>

  <div >

    <!--- Run the Reg Report --->
    <cfset dateToday = DateFormat(Now(),"mm/dd/yy")>
		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
    	<cfinvoke component='script.registration' method='runRetRegProgFigs'></cfinvoke>        
		</cfif>
 	</div>
</body>

</html>
