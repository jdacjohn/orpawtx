<cfinvoke component="script.cl_los" method="getRubrics" returnvariable="rubrics"></cfinvoke>
<cfinvoke component="script.links" method="getActionId" actionStr='#Action#' returnvariable="actionQ"></cfinvoke>
	<cfif NOT IsDefined("Session.ActionAccess")>
  	<cfset Session.ActionAccess = ''>
  </cfif>
	<!--- Insert logic here to handle the case of superusers with Session.ActionAccess = '*' --->
  <cfif ListFind("*,+",Session.ActionAccess) neq 0>
  	<cfset AvailableActions = Session.ActionAccess>
		<cfset super = 1>
  <cfelse>
  	<cfset AvailableActions = Session.ActionAccess & Application.Settings.OpenActions>
    <cfset super = 0>
  </cfif>

<cfoutput>
	<cfloop query="rubrics">
		<!--- Restricted user case --->
   	<cfif super eq 0>
			<cfif listfind(AvailableActions,actionQ.ActionID) neq 0>
				<li><a href="./index.cfm?action=#Action#&rubric=#rubrics.rubric#">#rubrics.rubric#</a></li>
      </cfif>
    </cfif>
    <cfif super eq 1>
			<li><a href="./index.cfm?action=#Action#&rubric=#rubrics.rubric#">#rubrics.rubric#</a></li>
		</cfif>    
  </cfloop>
</cfoutput>
