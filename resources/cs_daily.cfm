<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>LO Course Sections Script</title>
</head>

<body>
<h2>LO Course Sections Daily Load Script - Telnet</h2>

  <div >

		<!--- Open the session --->
<!---		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')> --->
	    <cfinvoke component='script.act_socket' method='openTelnet' returnVariable='sockContainer'></cfinvoke>
  	  <cfinvoke component='script.act_socket' 
      	method='runCS' 
        returnVariable='sockContainer' 
        openSocket="#sockContainer#"></cfinvoke>
			<!--- Close the session --->
    	<cfinvoke component='script.act_socket' method='closeSocket' openSocket="#sockContainer#"></cfinvoke>
<!---		</cfif> --->
 	</div>
<h2>FTP SCS File from _HOLD_</h2>

  <div >
  	<table>
<!---		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')> --->
			<!--- Open the session --->
  		<cfinvoke component='script.act_socket' method='downloadCSData' returnVariable='result'></cfinvoke>
    	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>
<!---    </cfif> --->
    </table>
 	</div>

 <h2>Load LO CS Data to IEIR_ASSESSMENT DATABASE</h2>
<!---		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')> --->
			Loading updated Course Section information for <cfoutput>#Application.Settings.LOTerm#</cfoutput><br />
  	  <cfif result eq 0>
    		<cfinvoke component='script.act_socket' method='loadCSData'></cfinvoke>
    	<cfelse>
    		No records found for submitted term.
    	</cfif>
<!---    </cfif> --->
		
    
</body>

</html>
