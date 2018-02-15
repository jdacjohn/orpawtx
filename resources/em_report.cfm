<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Enrollment Monitor Report Script</title>
</head>

<body>
<h2>Enrollment Monitor Report Script - Telnet</h2>

  <div >

		<!--- Open the session --->
	<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
	    <cfinvoke component='script.act_socket' method='openTelnet' returnVariable='sockContainer'></cfinvoke>
	    <cfinvoke component='script.act_socket' 
				method='runWithdrawals' 
				returnVariable='sockContainer' 
				openSocket="#sockContainer#"
				term="#Application.Settings.CurrentColTerm#"></cfinvoke>
	    <cfinvoke component='script.act_socket' 
				method='runGrads' 
				returnVariable='sockContainer' 
				openSocket="#sockContainer#"
				term="#Application.Settings.CurrentColTerm#"></cfinvoke>
  	  <cfinvoke component='script.act_socket' 
				method='runEMApps' 
				returnVariable='sockContainer' 
				openSocket="#sockContainer#"
				term="#Application.Settings.EmTerm#"></cfinvoke>
			<!--- Close the session --->
    	<cfinvoke component='script.act_socket' method='closeSocket' openSocket="#sockContainer#"></cfinvoke>
		</cfif>
 	</div>
<h2>FTP EM Files to _HOLD_</h2>

  <div >
  	<table>
		<!--- Open the session --->
		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
			<cfinvoke component='script.act_socket' method='downloadWDData' returnVariable='result'></cfinvoke>
    	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>
			<cfinvoke component='script.act_socket' method='downloadGradData' returnVariable='result'></cfinvoke>
    	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>
			<cfinvoke component='script.act_socket' method='downloadAppData' returnVariable='result'></cfinvoke>
    	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>
    </cfif>
    </table>
 	</div>

<h2>Load WD Data to IEIR_ASSESSMENT DATABASE</h2>
		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
			Loading updated Withdraw information for <cfoutput>#Application.Settings.CurrentTerm#</cfoutput><br />
  	  <cfinvoke component='script.act_socket' 
      	method='loadWDData'
        colTerm='#Application.Settings.CurrentColTerm#'
        fullTerm='#Application.Settings.CurrentTerm#'></cfinvoke>
			Loading updated Graduate information for <cfoutput>#Application.Settings.CurrentTerm#</cfoutput><br />
  	  <cfinvoke component='script.act_socket' 
      	method='loadGradData'
        term='#Application.Settings.CurrentTerm#'></cfinvoke>
    	Loading Application data for <cfoutput>#Application.Settings.EmTerm#</cfoutput><br />
    	<cfinvoke component='script.act_socket' 
      	method='loadAppData' 
        em_term="#Application.Settings.EmTerm#"
        em_cohort=#Application.Settings.EmTermCohort#></cfinvoke>
    </cfif>

</body>

</html>
