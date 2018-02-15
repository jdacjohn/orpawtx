<cfinvoke
	component="script.registration" method="getAvailableRetTerms" returnvariable="terms">
</cfinvoke>
<cfoutput>
<!--- <cfdump var="#nav_body#"> --->
	<cfloop query="terms">
		<li><a href="./index.cfm?action=QL_DRR&term=#terms.term#">#terms.term#</a></li>
  </cfloop>
</cfoutput>
