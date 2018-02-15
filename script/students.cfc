<cfcomponent>
	
	<!--- Search for Students matching fname, lname, and or idno. --->
	<cffunction name='findStudents' access='public' returntype='query'>
		<cfargument name='lname' type='string' required='yes'>
    <cfargument name='fname' type='string' required='yes'>
    <cfargument name='idno' type='numeric' required='yes'>
		<cfset students=''>
   <!--- <cfoutput>#idno#</cfoutput> --->
    <cfif idno eq 0>
    	<cfquery name='students' datasource='#Application.Settings.IEIR_RO#'>
    		select last_name, first_name, student_id, program, location, start_term
      		from student_ident
        	where last_name like '#lname#%' and first_name like '#fname#%'
        	order by last_name, first_name ASC
			</cfquery>    
    <cfelse>
    	<cfquery name='students' datasource='#Application.Settings.IEIR_RO#'>
    		select last_name, first_name, student_id, program, location, start_term
      		from student_ident
        	where student_id = #idno#
        	order by last_name, first_name ASC
			</cfquery>    
		</cfif>
		<cfreturn students>
	</cffunction>

	<!--- get the Student matching idno. --->
	<cffunction name='getStudent' access='public' returntype='query'>
    <cfargument name='idno' type='numeric' required='yes'>
		<cfset student_info=''>
    	<cfquery name='student_info' datasource='#Application.Settings.IEIR_RO#'>
    		select last_name, first_name, student_id, program, location, start_term
      		from student_ident
        	where student_id = #idno#
			</cfquery>    
		<cfreturn student_info>
	</cffunction>
  
  <!--- Get the active major for a student in a given term --->
  <cffunction name='getStudentMajor' access='public' returntype='string'>
  	<cfargument name='student' type='numeric' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfset qMajor=''>
    <cfquery name='qMajor' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(active_major) as active_major, '' as majorName from student_terms
      	where id_no = #student# and rpt_term_full = '#term#' and flex_entry = 0
    </cfquery>
    <cfset majorDesc=''>
    <cfquery name='majorDesc' datasource='#Application.Settings.IEIR_RO#'>
    	select name from program where rubric = '#qMajor.active_major#'
    </cfquery>
    <cfreturn majorDesc.name>
  </cffunction>
  
</cfcomponent>