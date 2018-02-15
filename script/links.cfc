<cfcomponent>

	<cffunction name="getActionId" access="public" returntype='query'>
  	<cfargument name='actionStr' type='string' required='yes'>
    <cfset q_action=''>
    <cfquery name="q_action" datasource='#Application.Settings.ActionsDSN_RO#'>
    	select ActionId, Action from #Application.Settings.ActionsTablePfx#.Actions
      	where Action = '#actionStr#'
    </cfquery>
    <cfreturn q_action>
  </cffunction>
  
	<cffunction name='getParentLinks' access='public' returntype='query'>
		<cfset nav_main=''>
		<cfquery name='nav_main' datasource='#Application.Settings.ActionsDSN_RO#'>
			select ActionID, Action, MenuName from #Application.Settings.ActionsTablePfx#.Actions
				where Dependency = 0 and MenuItem = 'Y' order by ActionID
		</cfquery>    
		<cfreturn nav_main>
	</cffunction>
  
	<cffunction name='getBodyLinks' access='public' returntype='query'>
		<cfargument name='parent' type='numeric' required='yes'>
		<cfset nav_main=''>
    <cfquery name='nav_main' datasource='#Application.Settings.ActionsDSN_RO#'>
			select Action, MenuName, ActionID from #Application.Settings.ActionsTablePfx#.Actions
				where Dependency = #parent# and MenuItem = 'N' and CatID = #Application.Settings.BodyLinkCat#
		</cfquery>    
		<cfreturn nav_main>
	</cffunction>

	<cffunction name='getTopLeftNavLinks' access='public' returntype='query'>
		<cfargument name='parent' type='numeric' required='yes'>
		<cfset nav_main=''>
		<cfquery name='nav_main' datasource='#Application.Settings.ActionsDSN_RO#'>
			select Action, MenuName, ActionID from #Application.Settings.ActionsTablePfx#.Actions
				where Dependency = #parent# and MenuItem = 'N' and CatID = #Application.Settings.TopLeftCat# and MenuDisplayOrder = 1
        order by MenuName
		</cfquery>    
		<cfreturn nav_main>
	</cffunction>

	<cffunction name='getBottomLeftNavLinks' access='public' returntype='query'>
		<cfargument name='parent' type='numeric' required='yes'>
		<cfset nav_main=''>
		<cfquery name='nav_main' datasource='#Application.Settings.ActionsDSN_RO#'>
			select Action, MenuName, ActionID from #Application.Settings.ActionsTablePfx#.Actions
				where Dependency = #parent# and MenuItem = 'N' and CatID = #Application.Settings.BtmLeftCat# and MenuDisplayOrder = 1
		</cfquery>    
		<cfreturn nav_main>
	</cffunction>

	<cffunction name='getChildLinks' access='public' returntype='query'>
    <cfargument name='parent_id' type='numeric' required='yes'>
    <cfset nav_sub=''>
    <cfquery name='nav_sub' datasource='#Application.Settings.ActionsDSN_RO#'>
     	select ActionID, Action, MenuName from #Application.Settings.ActionsTablePfx#.Actions
       	where Dependency = #parent_id# and MenuItem = 'Y' and MenuDisplayOrder = 1 order by MenuName ASC
    </cfquery>
    <cfreturn nav_sub>
  </cffunction>
</cfcomponent>

