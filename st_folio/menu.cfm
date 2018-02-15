<div id="mainOrpaHeader">
<img src="../images/logo/logo.png" /> 

	<div id="topLoginOrpa">
	<form name="l_form" action='./index.cfm?action=Login' method='POST'>
	Username:
	<input type='text' class='textarea' />
	Password:
	<input type='password' class='textarea' />

	<input type='submit' value='Login' class='loginHeaderSubmit' name='Send' alt='Submit' />
	</form>
	</div>

	<cfinvoke
		component="script.links" method="getParentLinks" returnvariable="nav_main">
	</cfinvoke>
	<div id="navHorzContainerOrpa">
		<cfoutput>
			<!--- <cfdump var="#nav_main#"> --->
			<ul id="nav">
			<cfloop query="nav_main">
      	<li><a href="./index.cfm?action=#nav_main.Action#">#nav_main.MenuName#</a>
        <cfquery name="nav_sub" datasource="ieir_webro">
        	select ActionID, Action, MenuName from #Application.Settings.Actions.Table.Pfx#.Actions
          	where Dependency = #nav_main.ActionID# and MenuItem = 'Y' order by ActionID
        </cfquery>
        <!--- <cfdump var="#nav_sub#"> --->
        <cfif nav_sub.RecordCount>
					<ul>
          <cfloop query="nav_sub">
          	<li class="navSub"><a href="./index.cfm?action=#nav_sub.Action#">#nav_sub.MenuName#</a></li>
          </cfloop>
          <!--- <li class="navSubBottom"><a href="##"></a></li> --->
          </ul>
        </li>
        </cfif>
      </cfloop>
		</cfoutput> 
    </ul>
	</div>

</div>
   
<div class="clearFix"></div>
