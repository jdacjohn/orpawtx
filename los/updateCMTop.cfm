<cfoutput>
<cftry>
<!--- Validate the user input --->
<cfparam name="revMo" type="integer">
<cfparam name="revYear" type="integer">
<cfset cmTopInfo = StructNew()>
<cfset cmTopInfo.comments = cmComments>
<cfset cmTopInfo.revMonth = revMo>
<cfset cmTopInfo.revYear = revYear>
<cfset cmTopInfo.cmid = cmid>
<!--- Apply the changes --->
<cfinvoke component='script.los' method='updateCmTop' cmData=#cmTopInfo#></cfinvoke>
<br />
<cflocation url="./index.cfm?action=LOS_EditCM&prog=#prog#" />
<cfcatch>
<cfset msg = 'You have attempted to enter an invalid revision month or year.'>
<cfset link = './index.cfm?action=LOS_EditCM&prog=#prog#'>
<cfinvoke component='script.error' method='saveError' msg='#msg#' link='#link#'></cfinvoke>
<cflocation url="./index.cfm?action=ERROR_WEB" />
</cfcatch>
</cftry>
</cfoutput>
