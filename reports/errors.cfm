<!--- This is the errors template --->

<CFSWITCH EXPRESSION="#Action#">
	<CFCASE VALUE="Login_Validate">
		<CFINCLUDE TEMPLATE="Login_Input_Error.cfm">
	</CFCASE>
</CFSWITCH>

