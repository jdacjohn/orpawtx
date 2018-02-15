<cfinvoke
	component="script.retention" method="getTerms" returnvariable="fa_terms" active='Y' semester='FA'></cfinvoke>
<cfparam name="fallselects" default="">
<cfoutput>
  <!--- <cfdump var="#nav_body#"> --->
  <cfloop query="fa_terms">
    <option value="#fa_terms.cohort#" <cfif ListFind(fallselects,fa_terms.cohort) NEQ 0>selected</cfif>>#fa_terms.term#</option>
  </cfloop>
</cfoutput>
