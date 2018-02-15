<cfcomponent>
	<cffunction name='getVocList' access='public' returntype='query'>
		<cfset cvocs=''>
		<cfquery name='cvocs' datasource='#Application.Settings.CollDSN#'>
			select vid,voc_name,voc_cat from user_vocs order by voc_name
		</cfquery>    
		<cfreturn cvocs>
	</cffunction>

	<cffunction name='getVocDetails' access='public' returntype='query'>
		<cfargument name='vocid' type='numeric' required='yes'>
  	<cfset vocDetails=''>
    <cfquery name='vocDetails' datasource='#Application.Settings.CollDSN#'>
    	select vseq,voc_item from voc_items where vid = #vocid# order by vseq
    </cfquery>
    <cfreturn vocDetails>
  </cffunction>
    
</cfcomponent>