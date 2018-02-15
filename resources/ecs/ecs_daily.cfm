<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>ECS Lead List Script</title>
</head>

<body>
<cfoutput>

<h2>Generating Education Career Specialist Lead List(s)...</h2>
  <div >
		<!--- Figure out what dates to get the leads for. Will use a begin date and an end date. --->
    <!--- Don't run the process on Saturdays or Sundays. --->
    <cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
			<cfset dateToday = DateFormat(Now(),"mm/dd/yyyy")>
      Today's Date:  #dateToday#<br />
      Previous Day's Date:  #DateFormat((dateToday - 1), "mm/dd/yyyy")#<br />
      3 Days Ago:  #DateFormat((dateToday - 3), "mm/dd/yyyy")#<br />
      <cfif DayofWeekAsString(DayofWeek(Now())) neq 'Monday'>
				<cfset endDate = DateFormat(Now(),"mm/dd/yyyy")>
        <cfset startDate = DateFormat((endDate - 1), 'mm/dd/yyyy')>
        End Date:  #endDate#<br />
        Start Date:  #startDate#<br />
      <cfelse>
				<cfset endDate = DateFormat(Now(),"mm/dd/yyyy")>
        <cfset startDate = DateFormat((endDate - 3), 'mm/dd/yyyy')>
        End Date:  #endDate#<br />
        Start Date:  #startDate#<br />
      </cfif>
      <cfinvoke component='script.ecs_notify' method='buildTodaysLists'
      	sendmail=1 
      	start='#startDate#' 
        end='#endDate#' 
        returnvariable='result'></cfinvoke>
    </cfif>
 	</div>
</cfoutput>    
</body>

</html>
