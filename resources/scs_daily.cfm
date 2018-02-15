<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Student Course Sections Script</title>
</head>

<body>
<cfoutput>

<h2>Student Course Sections Daily Load Script - Telnet #Application.Settings.LOCollTerm#</h2>
  <div >
		<!--- Run these processes for the current term. --->
		<!--- Open the session --->
	    <cfinvoke component='script.act_socket' method='openTelnet' returnVariable='sockContainer'></cfinvoke>
  	  <cfinvoke component='script.act_socket' 
      	method='runSCS' 
        returnVariable='sockContainer' 
        openSocket="#sockContainer#" 
        term="#Application.Settings.LOCollTerm#"
        loc=#Application.Settings.CollegeLoc#></cfinvoke>
			<!--- Close the session --->
    	<cfinvoke component='script.act_socket' method='closeSocket' openSocket="#sockContainer#"></cfinvoke>
 	</div>
<h2>FTP SCS File from _HOLD_ #Application.Settings.LOCollTerm#</h2>

  <div >
  	<table>
			<!--- Open the session --->
  		<cfinvoke component='script.act_socket' method='downloadSCS' returnVariable='result'></cfinvoke>
    	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>
    </table>
 	</div>

<h2>Load SCS Data to IEIR_ASSESSMENT DATABASE for #Application.Settings.LOCollTerm#</h2>
  <div >
			Loading updated Section Enrollment information for <cfoutput>#Application.Settings.LOTerm#</cfoutput><br />
  	  <cfif result eq "0">
    		<cfinvoke component='script.act_socket' method='loadSCS' scs_term='#Application.Settings.LOCollTerm#' loc=#Application.Settings.CollegeLoc#></cfinvoke>
    	<cfelse>
    		No records found for submitted term.
    	</cfif>
	</div>		
    
<!--- Now do this for the upcoming term so we can track upcoming smart-start students. --->
<h2>Student Course Sections Daily Load Script - Telnet #Application.Settings.LOCollNextTerm#</h2>
  <div >
		<!--- Run these processes for the current term. --->
		<!--- Open the session --->
	    <cfinvoke component='script.act_socket' method='openTelnet' returnVariable='sockContainer'></cfinvoke>
  	  <cfinvoke component='script.act_socket' 
      	method='runSCS' 
        returnVariable='sockContainer' 
        openSocket="#sockContainer#" 
        term="#Application.Settings.LOCollNextTerm#"
        loc=#Application.Settings.CollegeLoc#></cfinvoke>
			<!--- Close the session --->
    	<cfinvoke component='script.act_socket' method='closeSocket' openSocket="#sockContainer#"></cfinvoke>
 	</div>
<h2>FTP SCS File from _HOLD_ #Application.Settings.LOCollNextTerm#</h2>

  <div >
  	<table>
			<!--- Open the session --->
  		<cfinvoke component='script.act_socket' method='downloadSCS' returnVariable='result'></cfinvoke>
    	<tr><td><b>Result: </b><cfoutput>#result#</cfoutput></td></tr>
    </table>
 	</div>

<h2>Load SCS Data to IEIR_ASSESSMENT DATABASE for #Application.Settings.LOCollNextTerm#</h2>
  <div >
			Loading updated Section Enrollment information for <cfoutput>#Application.Settings.LOCollNextTerm#</cfoutput><br />
  	  <cfif result eq "0">
    		<cfinvoke component='script.act_socket' method='loadSCS' scs_term='#Application.Settings.LOCollNextTerm#' loc=#Application.Settings.CollegeLoc#></cfinvoke>
    	<cfelse>
    		No records found for submitted term.
    	</cfif>
	</div>		
</cfoutput>    
</body>

</html>
