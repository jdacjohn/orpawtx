<cfinvoke
	component="script.stu_appreg" method="getARTerms" returnvariable="terms">
</cfinvoke>
<cfoutput>
<!--- <cfdump var="#nav_body#"> --->
	<cfloop query="terms">
  	<cfquery name='termName' datasource='ieir_assessment'>
    	select term from year_terms where cohort = #terms.cohort#
    </cfquery>
		<li><a href="./index.cfm?action=QL_AppReg&term=#termName.term#">#termName.term#</a></li>
  </cfloop>
</cfoutput>
