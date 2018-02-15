<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Daily Reg Report Script</title>
</head>

<body>
<h2>Daily Reg Report Script - Telnet</h2>

  <div >

    <!--- Run the Reg Report --->
    <cfset dateToday = DateFormat(Now(),"mm/dd/yy")>
		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
			<!--- Open the session --->
      <cfinvoke component='script.act_socket' method='openTelnet' returnVariable='sockContainer'></cfinvoke>
    	<cfinvoke component='script.act_socket' 
      	method='runRegReport' 
        returnVariable='sockContainer' 
        regDate="#dateToday#" 
        openSocket="#sockContainer#"
        term="#Application.Settings.RegTerm#"></cfinvoke>
			<!--- Close the session --->
    	<cfinvoke component='script.act_socket' method='closeSocket' openSocket="#sockContainer#"></cfinvoke>
		</cfif>
 	</div>
<h2>FTP to _HOLD_</h2>

  <div >
  	<table>
		<!--- Open the session --->
		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
	    <cfinvoke component='script.act_socket' method='downloadRegData' returnVariable='result'></cfinvoke>
  	  	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>
    </cfif>
    </table>
 	</div>

<h2>Load Reg Data to IEIR_ASSESSMENT DATABASE</h2>
    <cfset dateToday = DateFormat(Now(),"yyyy/mm/dd")>
		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
	    <cfinvoke component='script.act_socket' 
      	method='loadRegData' 
        rptDate="#dateToday#"
        term="#Application.Settings.RegTerm#"></cfinvoke>
		</cfif>
</body>

</html>
