<cfcomponent>
	
	<!--- Get all of the Rubrics from the database.  Just the skill and id.  This is used for building a list. --->
	<cffunction name='getRubricNames' access='public' returntype='query'>
		<cfset rubrics=''>
    <cfquery name='rubrics' datasource='#Application.Settings.IEIR_RO#'>
    	select skill,r_id from rubric
      	order by skill 
		</cfquery>    
		<cfreturn rubrics>
	</cffunction>
	
	<!--- Get all of the Rubrics ids from the database. --->
	<cffunction name='getRubricIds' access='public' returntype='query'>
		<cfset rids=''>
    <cfquery name='rids' datasource='#Application.Settings.IEIR_RO#'>
    	select r_id,skill from rubric
      	order by r_id 
		</cfquery>    
		<cfreturn rids>
	</cffunction>

	<!--- Get the rubric that matches the id contained in 'rid'. --->
	<cffunction name='getRubric' access='public' returntype='query'>
		<cfargument name='rid' type='numeric' required='yes'>
		<cfset rubric_info=''>
    <cfquery name='rubric_info' datasource='#Application.Settings.IEIR_RO#'>
    	select skill,display_name, definition from rubric where r_id = #rid#
		</cfquery>    
		<cfreturn rubric_info>
	</cffunction>
	
	<!--- Get the name for the rubric that matches the id contained in 'rid'. --->
	<cffunction name='getRubricName' access='public' returntype='query'>
		<cfargument name='r_id' type='numeric' required='yes'>
		<cfset rubric=''>
    <cfquery name='rubric' datasource='#Application.Settings.IEIR_RO#'>
    	select skill from rubric where r_id = #r_id#
		</cfquery>    
		<cfreturn rubric>
	</cffunction>

	<!--- Get the competency classes for the rubric that matches the id contained in 'rid'. --->
	<cffunction name='getCompClasses' access='public' returntype='query'>
		<cfargument name='rid' type='numeric' required='yes'>
		<cfset comp_classes=''>
    <cfquery name='comp_classes' datasource='#Application.Settings.IEIR_RO#'>
    	select name,description,c_id from competency_class where r_id = #rid#
		</cfquery>    
		<cfreturn comp_classes>
	</cffunction>

	<!--- Get the competency classes for the rubric that matches the id contained in 'rid'. --->
	<cffunction name='getProgramRubrics' access='public' returntype='query'>
		<cfargument name='p_id' type='numeric' required='yes'>
		<cfset rubrics=''>
    <cfquery name='rubrics' datasource='#Application.Settings.IEIR_RO#'>
    	select r_id,skill,display_name,definition from rubric
      	where r_id in (select rubric_id from program_rubrics where p_id = #p_id#)
		</cfquery>    
		<cfreturn rubrics>
	</cffunction>
  
	<!--- Get a competency class name and definition. --->
	<cffunction name='getCompClass' access='public' returntype='query'>
		<cfargument name='cc_id' type='numeric' required='yes'>
		<cfset compClass=''>
    <cfquery name='compClass' datasource='#Application.Settings.IEIR_RO#'>
    	select name,description from competency_class where c_id = #cc_id#
		</cfquery>    
		<cfreturn compClass>
	</cffunction>

	<!--- Get the competencies for a competency class --->  
	<cffunction name='getCompetencies' access='public' returntype='query'>
  	<cfargument name='cc_id' type='numeric' required='yes'>
    <cfset competencies=''>
    <cfquery name='competencies' datasource='#Application.Settings.IEIR_RO#'>
    	select cmp_id,name from competency where c_id = #cc_id#
    </cfquery>
    <cfreturn competencies>
  </cffunction>
  
  <!--- Get a competency name --->
  <cffunction name='getCompetency' access='public' returntype='query'>
  	<cfargument name='compId' type='numeric' required='yes'>
    <cfset comp=''>
    <cfquery name='comp' datasource='#Application.Settings.IEIR_RO#'>
    	select name from competency where cmp_id = #compId#
    </cfquery>
    <cfreturn comp>
  </cffunction>

	<!--- Get the competency ratings for a competency --->  
	<cffunction name='getCompetencyRatings' access='public' returntype='query'>
  	<cfargument name='cmp_id' type='numeric' required='yes'>
    <cfset ratings=''>
    <cfquery name='ratings' datasource='#Application.Settings.IEIR_RO#'>
    	select level,description from competency_rating where cmp_id = #cmp_id# order by level ASC
    </cfquery>
    <cfreturn ratings>
  </cffunction>
  
</cfcomponent>