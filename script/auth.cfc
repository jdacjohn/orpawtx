<cfcomponent>
	
	<!--- Get the Programs for a location. --->
	<cffunction name='authuser' access='public' returntype='query'>
		<cfargument name='u_name' type='string' required='yes'>
    <cfargument name='p_word' type='string' required='yes'>
		<cfset valid_user=''>
    <cfquery name='valid_user' datasource='#Application.Settings.ActionsDSN_RO#'>
    	select ID,CollID,Name,Dept,Location,EmailAddress,UserName,ActionAccess,TotalLogins from users 
      	where UserName = '#u_name#' and Password = '#p_word#'
		</cfquery>    
		<cfreturn valid_user>
	</cffunction>
  
	<!--- Update date last login date and time --->
  <cffunction name='stamp_user' access='public'>
  	<cfargument name='sid' type='numeric' required='yes'>
    <cfargument name='logins' type='numeric' required='yes'>
    <cfquery name='upd' datasource='#Application.Settings.ActionsDSN#'>
    	update users set LastLoginDate = NOW(), TotalLogins = (#logins# + 1)
      	where ID = #sid#
    </cfquery>
  </cffunction>
  
</cfcomponent>