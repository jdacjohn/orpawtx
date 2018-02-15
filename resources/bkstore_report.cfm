<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Bookstore Student Loc Report Script</title>
</head>

<body>
<h2>Bookstore Student Location Report Script - Telnet</h2>

  <div >

		<!--- Open the session --->
		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
	    <cfinvoke component='script.act_socket' method='openTelnet' returnVariable='sockContainer'></cfinvoke>
  	  <cfinvoke component='script.act_socket' 
      	method='runBookStoreStuLocs' 
        returnVariable='sockContainer' 
        openSocket="#sockContainer#" 
        term="#Application.Settings.BkStoreNextTerm#"></cfinvoke>
			<!--- Close the session --->
    	<cfinvoke component='script.act_socket' method='closeSocket' openSocket="#sockContainer#"></cfinvoke>
    </cfif>

 	</div>
<h2>FTP Bookstore File from _HOLD_</h2>

  <div >
  	<table>
		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
			<!--- Open the session --->
  		<cfinvoke component='script.act_socket' method='downloadBookstoreData' returnVariable='result'></cfinvoke>
    	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>
    </cfif>
    </table>
 	</div>

 <h2>Load Bookstore Data to IEIR_ASSESSMENT DATABASE</h2>
		<cfif (DayofWeekAsString(DayofWeek(Now())) neq 'Saturday') and (DayofWeekAsString(DayofWeek(Now())) neq 'Sunday')>
			Loading updated Section Enrollment information for <cfoutput>#Application.Settings.BkStoreNextTerm#</cfoutput><br />
  	  <cfif result eq "0">
    		<cfinvoke component='script.act_socket' method='loadBkStoreData' bk_term='#Application.Settings.BkStoreNextTerm#'></cfinvoke>
    	<cfelse>
    		No records found for submitted term.
    	</cfif>
    </cfif>
		
    
</body>

</html>
