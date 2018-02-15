<cfinvoke
	component="script.smartStart" method="getLocs" returnvariable="locs">
</cfinvoke>

<cfoutput>
	<cfloop query="locs">
		<li><a href="./index.cfm?action=Reports_CoreInd_SS&loc=#locs.loc#">#locs.locName#</a></li>
  </cfloop>
</cfoutput>
