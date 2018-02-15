<cfinvoke
	component="script.links" method="getBodyLinks" returnvariable="nav_body" parent=100>
</cfinvoke>
<cfif NOT IsDefined("Session.ActionAccess")>
	<cfset Session.ActionAccess = ''>
</cfif>
<!--- Insert logic here to handle the case of superusers with Session.ActionAccess = '*' --->
<cfif ListFind("*,+",Session.ActionAccess) neq 0>
	<cfset AvailableActions = Session.ActionAccess>
	<cfset super = 1>
<cfelse>
	<cfset AvailableActions = Session.ActionAccess & "," & Application.Settings.OpenActions>
  <cfset super = 0>
</cfif>

<cfoutput>
<!--- <cfdump var="#nav_body#"> --->
<!--- <cfdump var="#AvailableActions#"> --->
	<cfloop query="nav_body">
		<!--- Restricted user case --->
   	<cfif super eq 0>
			<cfif listfind(AvailableActions,nav_body.ActionID) neq 0>
				<a href="./index.cfm?Action=#nav_body.Action#">#nav_body.MenuName#</a> &bull;
      </cfif>
    </cfif>
    <cfif super eq 1>
			<a href="./index.cfm?Action=#nav_body.Action#">#nav_body.MenuName#</a> &bull;
		</cfif>    
  </cfloop>
</cfoutput>
