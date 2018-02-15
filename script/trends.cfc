<cfcomponent>
	
	<!--- Enrollment related methods --->
  
  <!--- Get the last 5 year's worth of unduplicated headcount for the entire college. --->
  <cffunction name="unDupHCLast5All" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
		<cfset getEnrollments="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfset aUndupHC= ArrayNew(1)>
    <cfset arrayNdx=1>
    <cfloop query='yearsAndTerms'>
    	<cfset fyUndupHC=''>
      <cfif excludeDC eq 'off'>
        <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
          select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
        </cfquery>
      <cfelse>
        <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
          select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
          	and active_prog not like '%.DC%'
        </cfquery>
			</cfif>      
      <cfset thisYear=StructNew()>
      <cfset thisYear.fy=yearsAndTerms.fy>
      <cfset thisYear.undupHC=fyUndupHC.students>
      <cfset aUndupHC[arrayNdx]=thisYear>
      <cfset arrayNdx += 1>
    </cfloop>    	
		<cfreturn aUndupHC>
	</cffunction>
  
  <!--- Get the last 5 years worth of unduplicated headcount for a specified instructional division, OR return
	      these counts for all divisions (including undeclared major enrollments) by default if the user has not
				specified an instructional division. --->
	<cffunction name="unDupHCLast5Div" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    <cfargument name='division' type='string' required='yes'>
		<cfset getEnrollments="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfif division neq 'All Divisions'>
      <cfinvoke method='getDivMajors' division='#division#' returnVariable='majors'></cfinvoke>
      <!--- build an IN clause value that can be used in the select statement --->
      <cfset inclause = '('>
      <cfloop query='majors'>
        <cfset inclause = inclause & '"' & '#majors.major#' & '",'>
      </cfloop>
      <!--- remove the last offending comma. --->
      <cfset inclause = Left(inclause,len(inclause) - 1)>
      <!--- now Close up the inclause --->
      <cfset inclause = inclause & ')'>
      <cfset aUndupHC= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyUndupHC=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
              and active_major in #inclause#
          </cfquery>
        <cfelse>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
              and active_major in #inclause# and active_prog not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.undupHC=fyUndupHC.students>
        <cfset aUndupHC[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop> 
    <cfelse>   	
      <cfset aUndupHC= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyUndupHC=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
          </cfquery>
        <cfelse>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
              and active_prog not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.undupHC=fyUndupHC.students>
        <cfset aUndupHC[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>
    </cfif> 
		<cfreturn aUndupHC>
	</cffunction>
  
  <!--- Get the last 5 years worth of unduplicated headcount for a specified instructional program, OR return
	      these counts for all programs (including undeclared major enrollments) by default if the user has not
				specified an instructional program. --->
	<cffunction name="unDupHCLast5Prog" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    <cfargument name='program' type='string' required='yes'>
		<cfset getEnrollments="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfif program neq 'All Programs'>
      <cfset aUndupHC= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyUndupHC=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
              and active_major = '#program#'
          </cfquery>
        <cfelse>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
              and active_major = '#program#' and active_prog not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.undupHC=fyUndupHC.students>
        <cfset aUndupHC[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop> 
    <cfelse>   	
      <cfset aUndupHC= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyUndupHC=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
          </cfquery>
        <cfelse>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
              and active_prog not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.undupHC=fyUndupHC.students>
        <cfset aUndupHC[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>
    </cfif> 
		<cfreturn aUndupHC>
	</cffunction>
  
  <!--- Get the last 5 years worth of unduplicated headcount for a specified instructional location, OR return
	      these counts for all locations (including undeclared major enrollments) by default if the user has not
				specified an instructional location. --->
	<cffunction name="unDupHCLast5Loc" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    <cfargument name='location' type='numeric' required='yes'>
		<cfset getEnrollments="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfif location neq 5>
      <cfset aUndupHC= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyUndupHC=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
              and remote_campus = #location#
          </cfquery>
        <cfelse>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
              and remote_campus = #location# and active_prog not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.undupHC=fyUndupHC.students>
        <cfset aUndupHC[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop> 
    <cfelse>   	
      <cfset aUndupHC= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyUndupHC=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
          </cfquery>
        <cfelse>
          <cfquery name='fyUndupHC' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(id_no)) as students from student_terms where rpt_term in (#yearsAndTerms.terms#)
              and active_prog not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.undupHC=fyUndupHC.students>
        <cfset aUndupHC[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>
    </cfif> 
		<cfreturn aUndupHC>
	</cffunction>
  
	<!--- Completion related methods. --->
  
  <!--- Return the last 5 years worth of completions for a specified instructional division, OR return ALL
	      completions for the last 5 years if no instructional division has been selected by the user. DEFAULT. --->
  <cffunction name="completersLast5Div" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    <cfargument name='division' type='string' required='yes'>
		<cfset getCompleters="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfif division neq 'All Divisions'>
      <cfinvoke method='getDivMajors' division='#division#' returnVariable='majors'></cfinvoke>
      <!--- build an IN clause value that can be used in the select statement --->
      <cfset inclause = '('>
      <cfloop query='majors'>
        <cfset inclause = inclause & '"' & '#majors.major#' & '",'>
      </cfloop>
      <!--- remove the last offending comma. --->
      <cfset inclause = Left(inclause,len(inclause) - 1)>
      <!--- now Close up the inclause --->
      <cfset inclause = inclause & ')'>
      <!--- Now run a query to get all programs belonging to these majors --->
      <cfinvoke method='getProgramsForMajors' majors='#inclause#' returnVariable='programs'></cfinvoke>
      <!--- build an in clause for the programs --->
      <cfset inPrograms = '('>
      <cfloop query='programs'>
      	<cfset inPrograms = inPrograms & '"' & '#programs.program#' & '",'>
      </cfloop>
      <!--- Remove the last offending comma. --->
      <cfset inPrograms = Left(inPrograms,len(inPrograms) - 1)>
      <!--- Close up the inPrograms clause --->
      <cfset inPrograms = inPrograms & ')'>
			<cfset aCompleters= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyCompleters=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
            	and program in #inPrograms#
          </cfquery>
        <cfelse>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
              and program in #inPrograms# and program not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.awards=fyCompleters.awards>
        <cfset aCompleters[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>    	
		<cfelse>
			<cfset aCompleters= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyCompleters=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
          </cfquery>
        <cfelse>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
              and program not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.awards=fyCompleters.awards>
        <cfset aCompleters[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>
    </cfif>    	
		<cfreturn aCompleters>
	</cffunction>

  <!--- Return the last 5 years worth of completions for a specified instructional program, OR return ALL
	      completions for the last 5 years if no instructional program has been selected by the user. DEFAULT. --->
  <cffunction name="completersLast5Prog" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    <cfargument name='program' type='string' required='yes'>
		<cfset getCompleters="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfif program neq 'All Programs'>
      <!--- Now run a query to get all programs belonging to these majors --->
      <cfinvoke method='getProgramsForMajor' major='#program#' returnVariable='programs'></cfinvoke>
      <!--- build an in clause for the programs --->
      <cfset inPrograms = '('>
      <cfloop query='programs'>
      	<cfset inPrograms = inPrograms & '"' & '#programs.program#' & '",'>
      </cfloop>
      <!--- Remove the last offending comma. --->
      <cfset inPrograms = Left(inPrograms,len(inPrograms) - 1)>
      <!--- Close up the inPrograms clause --->
      <cfset inPrograms = inPrograms & ')'>
			<cfset aCompleters= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyCompleters=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
            	and program in #inPrograms#
          </cfquery>
        <cfelse>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
              and program in #inPrograms# and program not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.awards=fyCompleters.awards>
        <cfset aCompleters[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>    	
		<cfelse>
			<cfset aCompleters= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyCompleters=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
          </cfquery>
        <cfelse>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
              and program not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.awards=fyCompleters.awards>
        <cfset aCompleters[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>
    </cfif>    	
		<cfreturn aCompleters>
	</cffunction>

  <!--- Return the last 5 years worth of completions for a specified instructional location, OR return ALL
	      completions for the last 5 years if no instructional location has been selected by the user. DEFAULT. --->
  <cffunction name="completersLast5Loc" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    <cfargument name='location' type='numeric' required='yes'>
		<cfset getCompleters="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfif location neq 5>
			<!--- Map the location to one recognized by the student awards table --->
      <cfset loc=0>
      <cfswitch expression=#location#>
      	<cfcase value = 0>
        	<cfset loc = 400>
        </cfcase>
      	<cfcase value = 1>
        	<cfset loc = 460>
        </cfcase>
      	<cfcase value = 2>
        	<cfset loc = 480>
        </cfcase>
      	<cfcase value = 3>
        	<cfset loc = 470>
        </cfcase>
      </cfswitch>
			<cfset aCompleters= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyCompleters=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
            	and remote_campus = #loc#
          </cfquery>
        <cfelse>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
              and remote_campus = #loc# and program not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.awards=fyCompleters.awards>
        <cfset aCompleters[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>    	
		<cfelse>
			<cfset aCompleters= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyCompleters=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
          </cfquery>
        <cfelse>
          <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
            select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
              and program not like '%.DC%'
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.awards=fyCompleters.awards>
        <cfset aCompleters[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>
    </cfif>    	
		<cfreturn aCompleters>
	</cffunction>

	<!--- Return the number of completers for the entire college over the last 5 years. --->
	<cffunction name="completersLast5All" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
		<cfset getCompleters="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfset aCompleters= ArrayNew(1)>
    <cfset arrayNdx=1>
    <cfloop query='yearsAndTerms'>
    	<cfset fyCompleters=''>
      <cfif excludeDC eq 'off'>
        <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
          select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
        </cfquery>
      <cfelse>
        <cfquery name='fyCompleters' datasource='#Application.Settings.IEIR_RO#'>
          select count(*) as awards from stu_awards where acad_year = #yearsAndTerms.acad_year#
          	and program not like '%.DC%'
        </cfquery>
			</cfif>      
      <cfset thisYear=StructNew()>
      <cfset thisYear.fy=yearsAndTerms.fy>
      <cfset thisYear.awards=fyCompleters.awards>
      <cfset aCompleters[arrayNdx]=thisYear>
      <cfset arrayNdx += 1>
    </cfloop>    	
		<cfreturn aCompleters>
	</cffunction>
  
	<!--- Placement Functions --->
	
  <!--- Return the last 5 years worth of completions for a specified instructional location, OR return ALL
	      completions for the last 5 years if no instructional location has been selected by the user. DEFAULT. --->
  <cffunction name="placementsLast5Loc" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    <cfargument name='location' type='numeric' required='yes'>
		<cfset getPlacements="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfif location neq 5>
			<!--- Map the location to one recognized by the student awards table --->
      <cfset loc=0>
      <cfswitch expression=#location#>
      	<cfcase value = 0>
        	<cfset loc = 400>
        </cfcase>
      	<cfcase value = 1>
        	<cfset loc = 460>
        </cfcase>
      	<cfcase value = 2>
        	<cfset loc = 480>
        </cfcase>
      	<cfcase value = 3>
        	<cfset loc = 470>
        </cfcase>
      </cfswitch>
			<cfset aPlacements= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyPlacements=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in
              	(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year#
            			and remote_campus = #loc#)
          </cfquery>
        <cfelse>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in
              	(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year#
            			and remote_campus = #loc# and program not like '%.DC%')
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.placed=fyPlacements.placed>
        <cfset aPlacements[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>    	
		<cfelse>
			<cfset aPlacements= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyPlacements=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in
              	(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year#)
          </cfquery>
        <cfelse>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in
              	(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year# and program not like '%.DC%')
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.placed=fyPlacements.placed>
        <cfset aPlacements[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>
    </cfif>    	
		<cfreturn aPlacements>
	</cffunction>

  <!--- Return the last 5 years worth of placements for a specified instructional program, OR return ALL
	      placements for the last 5 years if no instructional program has been selected by the user. DEFAULT. --->
  <cffunction name="placementsLast5Prog" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    <cfargument name='program' type='string' required='yes'>
		<cfset getPlacements="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfif program neq 'All Programs'>
      <!--- Now run a query to get all programs belonging to these majors --->
      <cfinvoke method='getProgramsForMajor' major='#program#' returnVariable='programs'></cfinvoke>
      <!--- build an in clause for the programs --->
      <cfset inPrograms = '('>
      <cfloop query='programs'>
      	<cfset inPrograms = inPrograms & '"' & '#programs.program#' & '",'>
      </cfloop>
      <!--- Remove the last offending comma. --->
      <cfset inPrograms = Left(inPrograms,len(inPrograms) - 1)>
      <!--- Close up the inPrograms clause --->
      <cfset inPrograms = inPrograms & ')'>
			<cfset aPlacements= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyPlacements=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in
            		(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year#
            				and program in #inPrograms#)
          </cfquery>
        <cfelse>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in
            		(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year#
            				and program in #inPrograms# and program not like '%.DC%')
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.placed=fyPlacements.placed>
        <cfset aPlacements[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>    	
		<cfelse>
			<cfset aPlacements= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyPlacements=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in
              	(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year#)
          </cfquery>
        <cfelse>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in
              	(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year# and program not like '%.DC%')
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.placed=fyPlacements.placed>
        <cfset aPlacements[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>
    </cfif>    	
		<cfreturn aPlacements>
	</cffunction>

  <!--- Return the last 5 years worth of placements for a specified instructional division, OR return ALL
	      placements for the last 5 years if no instructional division has been selected by the user. DEFAULT. --->
  <cffunction name="placementsLast5Div" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    <cfargument name='division' type='string' required='yes'>
		<cfset getPlacements="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfif division neq 'All Divisions'>
      <cfinvoke method='getDivMajors' division='#division#' returnVariable='majors'></cfinvoke>
      <!--- build an IN clause value that can be used in the select statement --->
      <cfset inclause = '('>
      <cfloop query='majors'>
        <cfset inclause = inclause & '"' & '#majors.major#' & '",'>
      </cfloop>
      <!--- remove the last offending comma. --->
      <cfset inclause = Left(inclause,len(inclause) - 1)>
      <!--- now Close up the inclause --->
      <cfset inclause = inclause & ')'>
      <!--- Now run a query to get all programs belonging to these majors --->
      <cfinvoke method='getProgramsForMajors' majors='#inclause#' returnVariable='programs'></cfinvoke>
      <!--- build an in clause for the programs --->
      <cfset inPrograms = '('>
      <cfloop query='programs'>
      	<cfset inPrograms = inPrograms & '"' & '#programs.program#' & '",'>
      </cfloop>
      <!--- Remove the last offending comma. --->
      <cfset inPrograms = Left(inPrograms,len(inPrograms) - 1)>
      <!--- Close up the inPrograms clause --->
      <cfset inPrograms = inPrograms & ')'>
			<cfset aPlacements= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyPlacements=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in 
              	(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year# and program in #inPrograms#)
          </cfquery>
        <cfelse>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in 
            		(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year#
              			and program in #inPrograms# and program not like '%.DC%')
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.placed=fyPlacements.placed>
        <cfset aPlacements[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>    	
		<cfelse>
			<cfset aPlacements= ArrayNew(1)>
      <cfset arrayNdx=1>
      <cfloop query='yearsAndTerms'>
        <cfset fyPlacements=''>
        <cfif excludeDC eq 'off'>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in 
            		(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year#)
          </cfquery>
        <cfelse>
          <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
            select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
            	and student_id in 
            		(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year# and program not like '%.DC%')
          </cfquery>
        </cfif>      
        <cfset thisYear=StructNew()>
        <cfset thisYear.fy=yearsAndTerms.fy>
        <cfset thisYear.placed=fyPlacements.placed>
        <cfset aPlacements[arrayNdx]=thisYear>
        <cfset arrayNdx += 1>
      </cfloop>
    </cfif>    	
		<cfreturn aPlacements>
	</cffunction>

	<!--- Return the number of placed completers for the entire college over the last 5 years. --->
	<cffunction name="placementsLast5All" access="public" returntype="array">
  	<cfargument name='excludeDC' type='string' required='yes'>
    
		<cfset getPlacements="">
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>
    <cfset aPlacements= ArrayNew(1)>
    <cfset arrayNdx=1>
    <cfloop query='yearsAndTerms'>
    	<cfset fyPlacements=''>
      <cfif excludeDC eq 'off'>
        <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
          select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
          	and student_id in
            	(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year#)
        </cfquery>
      <cfelse>
        <cfquery name='fyPlacements' datasource='#Application.Settings.IEIR_RO#'>
          select count(distinct(student_id)) as placed from student_placement where emp_status != 'U' and job_related = 'Y'
          	and student_id in
          		(select student_id from stu_awards where acad_year = #yearsAndTerms.acad_year# and program not like '%.DC%')
        </cfquery>
			</cfif>      
      <cfset thisYear=StructNew()>
      <cfset thisYear.fy=yearsAndTerms.fy>
      <cfset thisYear.placed=fyPlacements.placed>
      <cfset aPlacements[arrayNdx]=thisYear>
      <cfset arrayNdx += 1>
    </cfloop>    	
		<cfreturn aPlacements>
	</cffunction>

  <!--- Support Functions --->

  <!--- Get a list of programs within a list of majors --->
  <cffunction name='getProgramsForMajor' access='public' returntype="query">
  	<cfargument name='major' type='string' required="yes">
    <cfset programs=''>
    <cfquery name='programs' datasource="#Application.Settings.IEIR_RO#">
      select distinct(program) as program from progs_majors where major = '#major#'
        order by program
    </cfquery>
    <cfreturn programs>
  </cffunction>

  <!--- Get a list of programs within a list of majors --->
  <cffunction name='getProgramsForMajors' access='public' returntype="query">
  	<cfargument name='majors' type='string' required="yes">
    <cfset programs=''>
    <cfquery name='programs' datasource="#Application.Settings.IEIR_RO#">
      select distinct(program) as program from progs_majors where major in #majors#
        order by program
    </cfquery>
    <cfreturn programs>
  </cffunction>

  <!--- Get a list of majors within a division --->
  <cffunction name='getDivMajors' access='public' returntype="query">
  	<cfargument name='division' type='string' required="yes">
    <cfset majors=''>
    <cfquery name='majors' datasource="#Application.Settings.IEIR_RO#">
      select distinct(major) as major from progs_majors where division = '#division#'
        order by major
    </cfquery>
    <cfreturn majors>
  </cffunction>

	<!--- Return a query with information about the last 5 full academic years. --->
  <cffunction name="getLast5YearsAndTerms" access="private" returntype="query">
  	<cfset yearsAndTerms=''>
    <cfquery name='getLast' datasource='#Application.Settings.IEIR_RO#'>
    	select seq from fiscal_years where latest = 'Y'
    </cfquery>
    <cfquery name='yearsAndTerms' datasource='#Application.Settings.IEIR_RO#'>
    	select seq, fy, acad_year, terms from fiscal_years where seq <= #getLast.seq# and seq >= #getLast.seq - 4#
    </cfquery>
    <cfreturn yearsAndTerms>
  </cffunction>
  
</cfcomponent>