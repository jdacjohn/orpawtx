<cfinvoke
	component="script.retention" method="getAllTerms" returnvariable="all_terms" active='Y'></cfinvoke>
<cfparam name="semselects" default="">

<cfoutput>
  <!--- <cfdump var="#nav_body#"> --->
  <cfloop query="all_terms">
    <option value="#all_terms.cohort#" <cfif ListFind(semselects,all_terms.cohort) NEQ 0>selected</cfif>>#all_terms.term#</option>
  </cfloop>
</cfoutput>
