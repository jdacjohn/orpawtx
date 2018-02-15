<cfinvoke component="script.programs" method="getActiveMajors" returnvariable="activeMajors"></cfinvoke>
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
	<cfloop query="activeMajors">
  	<cfinvoke
    	component="script.programs" method="getProgFullName" returnvariable="progQuery" rubric='#activeMajors.major#'>
    </cfinvoke>
		<!--- Restricted user case --->
   	<cfif super eq 0>
			<cfif listfind(AvailableActions,actionQ.ActionID) neq 0>
				<li><a href="./index.cfm?action=#Action#&major=#activeMajors.major#&p_id=#progQuery.p_id#" title="#progQuery.progName#">#activeMajors.major#</a></li>
      </cfif>
    </cfif>
    <cfif super eq 1>
			<li><a href="./index.cfm?action=#Action#&major=#activeMajors.major#&p_id=#progQuery.p_id#" title="#progQuery.progName#">#activeMajors.major#</a></li>
		</cfif>    
  </cfloop>
</cfoutput>
