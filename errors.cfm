<!--- This is the errors template --->

<cfswitch expression="#Action#">
<!---	<cfcase value="Login">
  	<cfinclude template="login.cfm">
  </cfcase> --->
	
	<!--- Retention Calculations --->
	<cfcase value="RTC_Inst_Display">
		<cfinclude template="./reports/errors/ret_inst_calc_error.cfm">
	</cfcase>
  
  <cfcase value='RUB_Submit_Entry'>
		<cfif not isdefined("student")>
			<CFSET Temp = #QueryAddRow(Errors)#>
      <CFSET Temp = #QuerySetCell(Errors,"FieldName","<span style='text-decoration:underline'>No Student Selected</span>")#>
      <CFSET Temp = #QuerySetCell(Errors,"Message","You must make a selection from the displayed list of students. Click the back button and try the operation again.")#>
			<CFSET Action = "Login">
    </cfif>	
  </cfcase>
  
</cfswitch>

