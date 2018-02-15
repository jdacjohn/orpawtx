<cfinvoke
	component="script.links" method="getTopLeftNavLinks" returnvariable="nav_body" parent=6122>
</cfinvoke>
<cfoutput>
<!--- <cfdump var="#nav_body#"> --->
	<cfloop query="nav_body">
		<li><a href="./index.cfm?action=#nav_body.Action#">#nav_body.MenuName#</a></li>
  </cfloop>
</cfoutput>
