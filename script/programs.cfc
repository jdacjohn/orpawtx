<cfcomponent>

	<!--- Add course associations for a major. --->
  <cffunction name='addCoursesForMajor' access='public' returntype='numeric'>
  	<cfargument name='major' type='string' required='yes'>
    <cfargument name='courses' type='string' required='yes'>
    <cfargument name='location' type='numeric' required='yes'>
    <!--- split the courses into an array of courses. --->
    <cfset courseArray = ListToArray(courses,',')>
		<cfloop index='ndx' from="1" to="#ArrayLen(courseArray)#" step="1">
    	<!--- Check to make sure the course doesn't already exist and is only inactive. --->
			<cfset findCourse=''>
      <cfquery name='findCourse' datasource='#Application.Settings.IEIR_RO#'>
      	select course from prog_courses where major = '#major#' and course = '#courseArray[ndx]#' and location=#location#
      </cfquery>
      <cfif findCourse.RecordCount gt 0>
      	<!--- Update the course. --->
        <cfset updateC=''>
        <cfquery result='updateC' datasource='#Application.Settings.IEIR#'>
        	update prog_courses set active = 'Y', change_op = '#Session.UserID#', change_date = NOW()
          	where major = '#major#' and course = '#courseArray[ndx]#' and location=#location#
        </cfquery>
      <cfelse>
      	<!--- Insert a new course. --->
        <cfset insertC=''>
        <cfquery result='insertC' datasource='#Application.Settings.IEIR#'>
        	insert into prog_courses values ('#major#','#courseArray[ndx]#','Y','#Session.UserID#', NOW(), null, null,#location#)
        </cfquery>
      </cfif>
    </cfloop>
    <cfreturn 0>
	</cffunction>
  
	<!--- Delete course associations for a major --->
  <cffunction name='deleteCoursesForMajor' access='public' returntype='numeric'>
  	<cfargument name='major' type='string' required='yes'>
    <cfargument name='courses' type='string' required='yes'>
    <cfargument name='location' type='numeric' required='yes'>
    <!--- split the courses up into an array of courses. --->
    <cfset courseArray = ListToArray(courses,',')>
		<cfloop index='ndx' from="1" to="#ArrayLen(courseArray)#" step="1">
    	<cfset delCourse=''>
      <cfquery name='delCourse' datasource='#Application.Settings.IEIR#'>
      	update prog_courses
        	set active = 'N', change_op = '#Session.UserID#', change_date = NOW()
        where major = '#major#' and course = '#courseArray[ndx]#' and location=#location#
      </cfquery>
    </cfloop>
    <cfreturn 0>
  </cffunction>

	<!--- Get the courses associated with a program, if any. --->
  <cffunction name="getCourses" access="public" returntype="query">
  	<cfargument name='prog' type="string" required="yes">
    <cfargument name='location' type='numeric' required='yes'>
    <cfset courses=''>
    <cfquery name='courses' datasource='#Application.Settings.IEIR_RO#'>
    	select course from prog_courses where major = '#prog#' and active = 'Y' and location=#location# order by course
    </cfquery>
    <cfreturn courses>
  </cffunction>
  	
	<!--- Get the Programs for a location. --->
	<cffunction name='getLocProgs' access='public' returntype='query'>
		<cfargument name='l_id' type='numeric' required='yes'>
		<cfset programs=''>
    <cfquery name='programs' datasource='#Application.Settings.IEIR_RO#'>
    	select p_id, program from programs where location = #l_id# order by program ASC
		</cfquery>    
		<cfreturn programs>
	</cffunction>
  
  <!--- Get the program Campus --->
  <cffunction name='getProgCampus' access='public' returntype='query'>
  	<cfargument name='p_id' type='numeric' required='yes'>
    <cfset program=''>
    <cfquery name='program' datasource='#Application.Settings.IEIR_RO#'>
    	select campus from locations where lc_id = (select location from programs where p_id = #p_id#)
    </cfquery>
    <cfreturn program>
   </cffunction>

  <!--- Get the program Name --->
  <cffunction name='getProgName' access='public' returntype='query'>
  	<cfargument name='p_id' type='numeric' required='yes'>
    <cfset progName=''>
    <cfquery name='progName' datasource='#Application.Settings.IEIR_RO#'>
    	select program from programs where p_id = #p_id#
    </cfquery>
    <cfreturn progName>
   </cffunction>
   
	<!--- Get a list of instructional divisions --->
  <cffunction name='getDivisions' access='public' returntype="query">
  	<cfset divisions=''>
    <cfquery name='divisions' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(division) as division from progs_majors where division is not null order by division
    </cfquery>
   	<cfreturn divisions>
  </cffunction>
  
  <!--- Get a list of majors within a division --->
  <cffunction name='getDivMajors' access='public' returntype="query">
  	<cfargument name='division' type='string' required="yes">
    <cfset majors=''>
    <cfquery name='majors' datasource="#Application.Settings.IEIR_RO#">
    	select distinct(major) as major from progs_majors where active = 1 and slodef = 1 and division = '#division#'
      	order by major
    </cfquery>
    <cfreturn majors>
  </cffunction>
  
	<!--- Get all active majors --->
  <cffunction name='getActiveMajors' access='public' returntype='query'>
  	<cfset activeMajors=''>
    <cfquery name='activeMajors' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(major) as major from progs_majors where slodef = 1 order by major
    </cfquery>
    <cfreturn activeMajors>
	</cffunction>
   
	<!--- Get all programs --->
  <cffunction name='getPrograms' access='public' returntype='query'>
  	<cfset programs=''>
    <cfquery name='programs' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(major) as program from progs_majors where active = 1 order by major
    </cfquery>
    <cfreturn programs>
	</cffunction>

  <!--- Get the program Name from its rubric --->
  <cffunction name='getProgFullName' access='public' returntype='query'>
  	<cfargument name='rubric' type='string' required='yes'>
    <cfset progQuery=''>
    <cfquery name='progQuery' datasource='#Application.Settings.IEIR_RO#'>
    	select name as progName, p_id from program where rubric = '#rubric#'
    </cfquery>
    <cfreturn progQuery>
   </cffunction>

  <!--- Get the program Name from its id --->
  <cffunction name='getProgFullNameById' access='public' returntype='query'>
  	<cfargument name='progId' type='numeric' required='yes'>
    <cfset progQuery=''>
    <cfquery name='progQuery' datasource='#Application.Settings.IEIR_RO#'>
    	select name as progName from program where p_id = #progId#
    </cfquery>
    <cfreturn progQuery>
   </cffunction>

  <!--- Get the program information (name and major) from its id --->
  <cffunction name='getProgInfoById' access='public' returntype='query'>
  	<cfargument name='progId' type='numeric' required='yes'>
    <cfset progQuery=''>
    <cfquery name='progQuery' datasource='#Application.Settings.IEIR_RO#'>
    	select name as progName, rubric from program where p_id = #progId#
    </cfquery>
    <cfreturn progQuery>
   </cffunction>

  <!--- Get all active programs for a major. --->
  <cffunction name='getActivePrograms' access='public' returntype="query">
   	<cfargument name='major' type='string' required='yes'>
    <cfset aprogQuery=''>
    <cfquery name='aprogQuery' datasource='#Application.Settings.IEIR_RO#'>
    	select program from progs_majors where major = '#major#'
    </cfquery>
    <cfreturn aprogQuery>
  </cffunction>

</cfcomponent>