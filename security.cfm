<!--- Check to see if the session has timed out --->
<!--- First Check See if the user is logged in at all--->
<CFIF NOT IsDefined("Session.UserID") AND ListFirst(Action, "_") NEQ "Login">
	<CFSET Temp = #QueryAddRow(Errors)#>
	<CFSET Temp = #QuerySetCell(Errors,"FieldName","Login Required")#>
	<CFSET Temp = #QuerySetCell(Errors,"Message","You must login to access this section of the website.")#>
  <cfset Session.Request = Action>
	<cfset Action = "Login">
</CFIF>
<!--- Second Check --->
<CFIF IsDefined("Session.UserID") AND Session.UserID EQ "" AND Action NEQ "Login_Validate" AND Action NEQ "Login">
	<CFSET Temp = #QueryAddRow(Errors)#>
	<CFSET Temp = #QuerySetCell(Errors,"FieldName","SessionTimeout")#>
	<CFSET Temp = #QuerySetCell(Errors,"Message","It appears that your session has timed out. You will need to re-login.")#>
  <cfset Session.Request = Action>
	<CFSET Action = "Login">
</CFIF>

<!--- Cache all actions available for the tool  CACHEDWITHIN="#CreateTimeSpan(1,0,0,0)#"--->
<CFIF NOT IsDefined("Application.AllActions") OR Mode EQ "Dev">
	<CFQUERY NAME="GetActions" DATASOURCE="#Application.Settings.ActionsDSN#">
		SELECT *
		FROM Actions
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
		<CFQUERY NAME="Check" datasource='ieir_webro'>
			SELECT *
			FROM actions
			WHERE Action='#Action#'
		</CFQUERY>

		<CFIF ListFind(Session.ActionAccess,Check.ActionID) EQ 0 AND ListFind(Session.ActionAccess,Check.Dependency) EQ 0>
			<!--- <CFOUTPUT>ActionID = #Check.ActionID#<br>ActionAccess = #Session.ActionAccess#<br></CFOUTPUT> --->
			<CF_FUL_MESSAGE TYPE="Failure" TITLE="You are not authorized to access this application!" MESSAGE="It appears that you have attempted to access an application for which you are not authorized.  This breach has been logged and will be reported to the webmaster.">
			<cfif Mode neq 'DEV'>
      <CFMAIL
        TO="john.arnold@tstc.edu"
        FROM="noreply@sweetwater.tstc.edu"
        SUBJECT="ORPA_Web Error"
        TYPE="HTML"
      >
        <font face="Arial" size="2">
        <b>UserID:</b> <CFIF IsDefined('Session.UserID')>#Session.UserID#</CFIF><br>
        <b>Name:</b> <CFIF IsDefined('Session.Name')>#Session.Name#</CFIF><br>
        <b>ActionAccess:</b> <CFIF IsDefined('Session.ActionAccess')>#Session.ActionAccess#</CFIF><br>
        <b>Dept:</b> <CFIF IsDefined('Session.Dept')>#Session.Dept#</CFIF><hr>
        <b>Action:</b> #Action#<br>
        <b>Query String:</b>  #CGI.query_string#<br>
        <b>HTTP_REFERER:</b> #CGI.HTTP_REFERER#<br>
        <b>Path:</b> #CGI.Path_Translated#<br>
        <b>Browser:</b>  #CGI.http_user_agent#<br>
        <b>Date/Time:</b> #DateFormat(now(),'mm/dd/yyyy')# #TimeFormat(now(),'h:mm tt')#<br>
        <hr>
        <b>Message:</b><font color="red">#cfcatch.message#</font><br>
        <hr>
        <b>Detail:</b><font color="red">#cfcatch.detail#</font><br>
        <hr>
        <u><b>TagContext:</b></u><br>
        <CFLOOP INDEX="idx" FROM="1" TO="#ArrayLen(cfcatch.tagcontext)#">
          <CFSET sCurrent = cfcatch.tagcontext[idx]>
          #idx# #sCurrent["ID"]# (#sCurrent["LINE"]#,#sCurrent["COLUMN"]#) #sCurrent["TEMPLATE"]#<br>
        </CFLOOP>
        <CFIF IsDefined('Error') AND IsStruct(Error)>
          <b>Exception:</b> #Error.TYPE#<br>
          <b>Template:</b> #Error.Template#<br>
          #Error.Diagnostics#<br>
          #Error.generatedContent#<br>
        </CFIF>
        <CFIF IsDefined("Form.FieldNames")>
          <br><u><b>FormFields:</b></u><br>
          <CFLOOP List="#Form.FieldNames#" INDEX="IDX">
            <b>#IDX#:</b> #EVALUATE(IDX)#<br>
          </CFLOOP>
        </CFIF>
        </font>
      </CFMAIL>
      </cfif>
			<CFABORT>
		</CFIF>
	</CFIF>
</CFIF>
