<html>
<head>
	<title>TSTC West Texas Institutional Effectiveness & Information Research</title>
<cfoutput>
<link href="#Application.Settings.BaseURL#/css/style.css" rel="stylesheet" type="text/css" />
<link href='#Application.Settings.BaseURL#/css/orpa.css' rel='stylesheet' type='text/css' />
<script type="text/javascript" language="javascript" src='#Application.Settings.BaseURL#/script/orpa.js'></script>
</cfoutput>
	<!--- Add refresh check here --->
	<!--- Why do I want a refresh check here?  Commented out per evaluation.  jarnold 08.15.2007 --->
	<!--- <CFIF ListFind("AppPendingView,DeleteApp,MailManager,FollowUpQView",Action) NEQ 0>
		<!--- This code will refresh the page to what ever interval you want --->
		<CFOUTPUT>
			<META HTTP-EQUIV=REFRESH CONTENT="60;URL=#cgi.script_name#<cfif cgi.query_string neq "">?#cgi.query_string#</cfif>">
		</CFOUTPUT>
		<!--- End of refresh screen code --->
	</CFIF> --->
  
  <script type="text/javascript"><!--//--><![CDATA[//><!--
		sfHover = function() {
			var sfEls = document.getElementById("nav").getElementsByTagName("LI");
			for (var i=0; i<sfEls.length; i++) {
				sfEls[i].onmouseover=function() {
					this.className+=" sfhover";
				}
				sfEls[i].onmouseout=function() {
					this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
				}
			}
		} // end function
		
		if (window.attachEvent) window.attachEvent("onload", sfHover);

		//--><!]]></script>

</head>

<body>
<div id="mainContainer">

<!--- Debug nav info --->
<cfoutput>
Action value in ./staff/index.cfm = #Action# <br />
</cfoutput>

<!--- <CFTRY>  --->

<!--- Turn off the system here by un-commenting the code below --->
<!--- <CFSET Action = "LogOut"> --->

<!--- Set up Errors recordset --->
<CFSET Errors = #QueryNew('Message,FieldName,FieldValue')#>

<!--- Set up the security template --->
<!--- Not needed at this level --->
<!---<CFINCLUDE TEMPLATE="security.cfm">  --->

<!--- Set up error handling template --->
<CFINCLUDE TEMPLATE="errors.cfm">

<!--- Set up Data template --->
<CFINCLUDE TEMPLATE="Data.cfm">

<!--- Include the menu templates here --->
<CFIF ListFirst(Action, "_") NEQ "Login" AND MenuDisplay EQ "Y">
	<cfinclude template="../menu.cfm">
</CFIF>

<CFSWITCH EXPRESSION="#Action#">
	<CFCASE VALUE="LogOut">
		<CFLOCK TIMEOUT="#CreateTimeSpan(0,0,0,10)#" SCOPE="Session">
			<CFSET Session.ActionAccess="">
			<CFSET Session.UserID = "">
			<CFSET Session.Name = "">
			<CFSET Session.MenuOrder="">
			<CFSET Session.Dept = "">
			<CFSET Session.DefaultPage = "">
			<CFSET Session.Location = "">
			<CFSET Session.ClientRecordLocked = "">
		</CFLOCK>
		<CFLOCATION URL="index.cfm">
	</CFCASE>
  
  <!--- IEIR Resource Pages --->
  <cfcase value='IEIR_Home'>
   	<cfinclude template='./main.cfm'>
  </cfcase>
  <cfcase value='IEIR_SntncBrws'>
   	<cfinclude template='./sntncs.cfm'>
  </cfcase>
  
	<!--- Default Case - Pass control back to webroot and take it from there --->
  <cfdefaultcase>
  	<cflocation url="../index.cfm?action=#Action#">
  </cfdefaultcase> 
  
</CFSWITCH>
<!--- <CFCATCH>
	<CFMAIL
		TO="john.arnold@sweetwater.tstc.edu"
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
	<CF_FUL_Message Title="System Error" Type="FAILURE" Message="There has been a system error. This error has been reported to the webmaster so that it can be fixed. Sorry for the inconvienence." Abort="Yes">
</CFCATCH>
</CFTRY> --->
<!--- Add the footer include here --->
<CFINCLUDE TEMPLATE="footer.cfm">
</body>
</html>

