<cfinvoke
	component="script.links" method="getTopLeftNavLinks" returnvariable="nav_body" parent=711002003>
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
				<li><a href="./index.cfm?action=#nav_body.Action#">#nav_body.MenuName#</a></li>
      </cfif>
    </cfif>
    <cfif super eq 1>
			<li><a href="./index.cfm?action=#nav_body.Action#">#nav_body.MenuName#</a></li>
		</cfif>    
  </cfloop>
</cfoutput>
