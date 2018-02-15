<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Apps to Enrolled Resource File</title>
</head>

<body>
<cfoutput>

<h2>Applications to Enrollments Summary Builder</h2>
  <div >
	<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
			<cfinvoke component='script.stu_appreg' 
      					method='buildDailySummary' 
                appRegCohort=#Application.Settings.AppRegCohort#
                appRegTerm="#Application.Settings.AppRegTerm#"></cfinvoke>
  </cfif>
 	</div>
</cfoutput>
</body>
</html>
