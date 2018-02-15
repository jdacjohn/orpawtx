<!--- Check to see if the session has timed out --->
 Use for Debug!!!!
<CFOUTPUT>
	Session.UserID = #Session.UserID#
</CFOUTPUT> 
<!--- First Check --->
<CFIF NOT IsDefined("Session.UserID") AND ListFirst(Action, "_") NEQ "Login">
	<CFSET Temp = #QueryAddRow(Errors)#>
	<CFSET Temp = #QuerySetCell(Errors,"FieldName","SessionTimeout")#>
	<CFSET Temp = #QuerySetCell(Errors,"Message","It appears that your session has timed out. You will need to re-login.")#>
	<CFSET Action = "Login">
</CFIF>
<!--- Second Check --->
<CFIF IsDefined("Session.UserID") AND Session.UserID EQ "" AND Action NEQ "Login_Validate" AND Action NEQ "Login">
	<CFSET Temp = #QueryAddRow(Errors)#>
	<CFSET Temp = #QuerySetCell(Errors,"FieldName","SessionTimeout")#>
	<CFSET Temp = #QuerySetCell(Errors,"Message","It appears that your session has timed out. You will need to re-login.")#>
	<CFSET Action = "Login">
</CFIF>

<!--- Cache all actions available for the tool  CACHEDWITHIN="#CreateTimeSpan(1,0,0,0)#"--->
<CFIF NOT IsDefined("Application.AllActions") OR Mode EQ "Dev">
	<CFQUERY NAME="GetActions" DATASOURCE="#Application.Settings.ActionsDSN#">
		SELECT *
		FROM #Application.Settings.Actions.Table.Pfx#.Actions
		ORDER BY Action
	</CFQUERY>
	<CFLOCK SCOPE="Application" TIMEOUT="#CreateTimeSpan(0,0,0,10)#">
		<CFSET Application.AllActions=GetActions>
	</CFLOCK>
</CFIF>

<CFIF ListFirst(Action, "_") NEQ "Login">
	<!--- Check to make sure user has access to this action --->
	<CFIF ListFind("*,+",Session.ActionAccess) EQ 0>
		<!--- Look up the action and get it's action ID --->
		<CFQUERY DBTYPE="Query" NAME="Check">
			SELECT *
			FROM Application.AllActions
			WHERE [Action]='#Action#'
		</CFQUERY>

		<CFIF ListFind(Session.ActionAccess,Check.ActionID) EQ 0 AND ListFind(Session.ActionAccess,Check.Dependency) EQ 0>
			<!--- <CFOUTPUT>ActionID = #Check.ActionID#<br>ActionAccess = #Session.ActionAccess#<br></CFOUTPUT> --->
			<CF_FUL_MESSAGE TYPE="Failure" TITLE="You are not authorized to access this application!" MESSAGE="It appears that you have attempted to access an application for which you are not authorized.  This breach has been logged and will be reported to the webmaster.">
			<CFABORT>
		</CFIF>
	</CFIF>
</CFIF>
