<cfinvoke
	component="script.auth" method="authuser" returnvariable="valid_user" u_name="#uname#" p_word="#pword#">
</cfinvoke>
<!--- Authentication was successfull --->
<cfif valid_user.CollID neq ''>
	<cfif valid_user.TotalLogins eq ''>
  	<cfset valid_user.TotalLogins = 0>
  </cfif>
	<cfinvoke
  	component="script.auth" method="stamp_user" sid=#valid_user.ID# logins=#valid_user.TotalLogins#>
  </cfinvoke>
	<cfset success = 1>
 	<cflock timeout='#CreateTimeSpan(0,0,0,10)#' scope="Session">
		<cfset Session.ActionAccess = valid_user.ActionAccess>
    <cfset Session.UserID = #valid_user.UserName#>
    <cfset Session.Name = valid_user.Name>
    <cfset Session.MenuOrder = "">
    <cfset Session.Dept = valid_user.Dept>
    <cfset Session.DefaultPage = "">
    <cfset Session.Location = valid_user.Location>
    <cfset Session.ClientRecordLocked = "">
    <cfset Session.CollID = valid_user.CollID>
    <cfset Session.EmailAddress = valid_user.EmailAddress>
  </cflock>
<cfelse>
	<cfset success = 0>
</cfif>

<div id="mainBody">

<!--- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<p>
<img class='rightImg' src='images/logo/star_200px.gif' />
<cfoutput>
<cfif success eq 1>
  <cfif isdefined("Session.Request")>
	  <cflocation url="./index.cfm?Action=#Session.Request#">
  <cfelse>
  	<cflocation url="./index.cfm">
  </cfif>
<cfelse>
	An error occurred during the login process.  Please check your username and password and try again.
</cfif>
</cfoutput>
</p>
</div>


<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p>
<img class='rightImg' src='images/logo/ieir_logo_200px.gif' />
<cfinclude template='body_links.cfm'>
</p>
</div>


</div>

<!-- MAIN RIGHT END -->


<div id="mainLeft">

<div class="snapshotContent" >
<img src="images/TSTC_logo_small.png" alt="" style="text-align: center" />

<!--- <h4 class="blue">&nbsp;</h4> --->
</div> <!-- snapshotContent -->


</div>
<!-- MAIN BODY END -->
</div>
