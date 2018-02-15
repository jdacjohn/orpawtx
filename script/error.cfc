<!--- ColdFusion object for storing and retrieving errors. --->
<cfcomponent>
	
	<!--- save an error to the database --->
	<cffunction name='saveError' access='public'>
    <cfargument name='msg' type='string' required='yes'>
    <cfargument name='link' type='string' required='yes'>
		<cfset sessid = 'ORPAWEB_' & '#CFID#' & '_' & '#CFToken#'>
    <cfset qInsert=''>
    <cfquery result='qInsert' datasource='#Application.Settings.ActionsDSN#'>
    	insert into site_errors values('#sessid#','#msg#','#link#',NOW())
		</cfquery>    
	</cffunction>
    
	<!--- Get the most current error associated with the session. --->
  <cffunction name='getCurrent' access='public' returntype='query'>
		<cfset sessid = 'ORPAWEB_' & '#CFID#' & '_' & '#CFToken#'>
  	<cfset qLatest=''>
    <cfquery name='qLatest' datasource='#Application.Settings.ActionsDSN_RO#'>
    	select max(errorWhen) as eWhen from site_errors where sessionId = '#sessid#'
    </cfquery>
    <cfset qError=''>
    <cfquery name='qError' datasource='#Application.Settings.ActionsDSN_RO#'>
    	select errorMsg, redirect from site_errors where sessionId = '#sessid#' and errorWhen = '#qLatest.eWhen#'
    </cfquery>
    <cfreturn qError>
  </cffunction>
  
</cfcomponent>