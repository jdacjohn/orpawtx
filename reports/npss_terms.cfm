<cfinvoke
	component="script.smartStart" method="getTerms" location=#loc# returnvariable="terms">
</cfinvoke>

<cfoutput>
	<cfloop query="terms">
		<li><a href="./index.cfm?action=Reports_CoreInd_SS&loc=#loc#&term=#terms.term#">20#terms.term#</a></li>
  </cfloop>
</cfoutput>
