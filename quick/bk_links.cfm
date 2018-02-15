<cfoutput>
	<cfinvoke component="script.bkstore" method="getTerms" returnvariable="getAvailTerms"></cfinvoke>
  <cfloop query="getAvailTerms">
		<li><a href="./index.cfm?action=QL_BKS&bk_cohort=#getAvailTerms.ytCohort#">#getAvailTerms.bkTerm#</a></li>
  </cfloop>
</cfoutput>
