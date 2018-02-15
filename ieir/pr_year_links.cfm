<cfinvoke
	component="script.pr_sets" method="getAYs" returnvariable="ays">
</cfinvoke>

<cfoutput>
<!--- <cfdump var="#nav_body#"> --->
<!--- <cfdump var="#AvailableActions#"> --->
	<cfloop query="ays">
			<li><a href="./index.cfm?action=IEIR_PR_ViewLtd&acadYear=#ays.ay#">#ays.ay#</a></li>
  </cfloop>
</cfoutput>
