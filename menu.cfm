<div id="mainOrpaHeader">
<cfoutput>
<a href="http://www.westtexas.tstc.edu"><img src="#Application.Settings.ImageBase#/logo/TSTC_4.png" border="0"/></a> 
</cfoutput>
	<div id="topLoginOrpa">
	<form name="l_form" action='./index.cfm?action=Login_Validate' method='POST'>
	Username: <input type='text' name='uname' class='textarea' />
	Password: <input type='password' name='pword' class='textarea' />
	<input type='submit' value='Login' class='loginHeaderSubmit' name='Send' alt='Submit' />
	</form>
  <cfif isDefined("Session.UserID") and Session.UserID neq ''><cfoutput><br />Welcome, #Session.Name#</cfoutput> [ <a href="./index.cfm?Action=App_Logout">Logout</a> ]</cfif>
	</div>
	<cfif NOT IsDefined("Session.ActionAccess")>
  	<cfset Session.ActionAccess = ''>
  </cfif>
	<!--- Insert logic here to handle the case of superusers with Session.ActionAccess = '*' --->
  <cfif ListFind("*,+",Session.ActionAccess) neq 0>
  	<cfset AvailableActions = Session.ActionAccess>
		<cfset super = 1>
  <cfelse>
  	<cfif Session.ActionAccess neq ''>
  		<cfset AvailableActions = Session.ActionAccess & "," & Application.Settings.OpenActions>
    <cfelse>
    	<cfset AvailableActions = Application.Settings.OpenActions>
    </cfif>
    <cfset super = 0>
  </cfif>
  <!---<cfoutput>#AvailableActions#</cfoutput>--->
	<cfinvoke
		component="script.links" method="getParentLinks" returnvariable="nav_main">
	</cfinvoke>
	<div id="navHorzContainerOrpa">
		<cfoutput>
			<!--- <cfdump var="#nav_main#"> --->
			<ul id="nav">
			<cfloop query="nav_main">
				<!--- Restricted user case --->
      	<cfif super eq 0>
					<cfif listfind(AvailableActions,nav_main.ActionID) neq 0>
          <li><a href="./index.cfm?action=#nav_main.Action#">#nav_main.MenuName#</a>
          <cfquery name="nav_sub" datasource="ieir_webro">
            select ActionID, Action, MenuName from #Application.Settings.ActionsTablePfx#.Actions
              where Dependency = #nav_main.ActionID# and MenuItem = 'Y' and MenuDisplayOrder = 1 order by ActionID
          </cfquery>
          <!--- <cfdump var="#nav_sub#"> --->
          <cfif nav_sub.RecordCount>
            <ul>
            <cfloop query="nav_sub">
							<cfif listfind(AvailableActions,nav_sub.ActionID) neq 0>
              	<li><a href="./index.cfm?action=#nav_sub.Action#">#nav_sub.MenuName#</a></li>
              </cfif>
            </cfloop>
            <!--- <li class="navSubBottom"><a href="##"></a></li> --->
            </ul>
          </cfif>
        </li>
        </cfif>
      </cfif>
      <!--- Super/Admin user case --->
      	<cfif super eq 1>
          <li><a href="./index.cfm?action=#nav_main.Action#">#nav_main.MenuName#</a>
          <cfquery name="nav_sub" datasource="ieir_webro">
            select ActionID, Action, MenuName from #Application.Settings.ActionsTablePfx#.Actions
              where Dependency = #nav_main.ActionID# and MenuItem = 'Y' and MenuDisplayOrder = 1 order by ActionID
          </cfquery>
          <!--- <cfdump var="#nav_sub#"> --->
          <cfif nav_sub.RecordCount>
            <ul>
            <cfloop query="nav_sub">
              <li><a href="./index.cfm?action=#nav_sub.Action#">#nav_sub.MenuName#</a></li>
            </cfloop>
            <!--- <li class="navSubBottom"><a href="##"></a></li> --->
            </ul>
          </cfif>
        </li>
      </cfif>
      </cfloop>
		</cfoutput> 
    </ul>
	</div>

</div>
   
<div class="clearFix"></div>
