<cfinvoke
	component="script.rubrics" method="getRubricNames" returnvariable="all_rubrics">
</cfinvoke>

<cfoutput>
  <!--- <cfdump var="#nav_body#"> --->
  <cfloop query="all_rubrics">
    <a href="./index.cfm?action=RUB_Defs&rubric=#all_rubrics.r_id#">#all_rubrics.skill#</a><br />
  </cfloop>
</cfoutput>
