<cfcomponent>

	<cffunction name='getTerms' access='public' returntype='query'>
		<cfargument name='active' type='String' required='yes'>
    <cfargument name='semester' type='String' required='yes'>
		<cfset terms=''>
    <cfquery name='terms' datasource='#Application.Settings.IEIR_RO#'>
    	select cohort,term from year_terms where active='#active#'and term like '%#semester#' and
      	cohort < (select max(cohort) from year_terms where active='#active#' and term like '%#semester#')
        order by cohort ASC
		</cfquery>    
		<cfreturn terms>
	</cffunction>
  
	<cffunction name='getAllTerms' access='public' returntype='query'>
		<cfargument name='active' type='String' required='yes'>
		<cfset terms=''>
    <cfquery name='terms' datasource='#Application.Settings.IEIR_RO#'>
    	select cohort,term from year_terms 
      	where active='#active#' and
      		cohort < (select max(cohort) from year_terms where active='#active#')
        	order by cohort ASC
		</cfquery>    
		<cfreturn terms>
	</cffunction>
  
  <cffunction name='getRetention' access='public' returntype='array'>
  	<cfargument name='terms' type='string' required='yes'>
    <cfargument name='term_inc' type='numeric' required='yes'>
    <cfargument name='part_time' type='numeric' required='yes'>
    <cfparam name='byloc' default=''>
    <!--- Convert the list of cohorts to an array to be processed one at a time --->
		<cfset termsItr = ListToArray(#terms#,",")>
		<!--- Set up the comparison operator depending on if we want part-time students or not --->
    <cfif part_time eq 1>
    	<cfset load_opr = "<">
    <cfelse>
    	<cfset load_opr = ">=">
    </cfif>
    <!--- Set up some local variables --->
    <cfset rsets = ArrayNew(1)>
    <cfset awardMonths=[12,4,8]>
    <!--- Start CFLOOP TERMS --->
    <cfset rsetCount=0>
    <cfloop index="ndx" from="1" to="#ArrayLen(termsItr)#" step="1">
			<!--- Get the start term and academic year of the cohort.  The academic year is used to find completers. --->
      <cfquery name="startTermQ" datasource="#Application.Settings.IEIR_RO#">
      	select term,acad_year,semester from year_terms where cohort=#termsItr[ndx]#
      </cfquery>
      <!--- <cfoutput>Academic Year = #startTermQ.acad_year#<br /></cfoutput> --->
      <!--- Get the end term of the cohort --->
      <cfquery name="endTermQ" datasource="#Application.Settings.IEIR_RO#">
      	select term from year_terms where cohort=(#termsItr[ndx]# + #term_inc#)
      </cfquery>
			<cfset term = termsItr[ndx]>
    	<!--- Begin CFIF BYLOC --->
      <cfif byloc eq "on">
      	<!--- Load the loc codes from the db --->
        <cfquery name="locCodesQ" datasource="#Application.Settings.IEIR_RO#">
        	select lc_id,campus from locations  where lc_id in (400,460,470,480) order by campus
        </cfquery>
        <!--- I think we can do this with a struct and use the var names below as keys.  Keep it in mind --->
        <cfset totalStart = 0>
        <cfset totalEnd = 0>
        <cfset totalCompleters = 0>
        <!--- BEGIN LOOP LOCS --->
        <cfloop query="locCodesQ">
		      <cfset rsetCount += 1>
        	<!--- Get the size of the beginning cohort for each location --->
          <cfquery name="cohortStartCountQ" datasource="#Application.Settings.IEIR_RO#">
          	select count(*) as count from student_ident 
            	where cohort = #term# and intent in (1,2,3,6) and stu_load #load_opr# 12 and location = #locCodesQ.lc_id#
          </cfquery>
          <cfset totalStart += cohortStartCountQ.count>
					<!--- Get the size of the class retained in the retention assessment term --->
          <cfquery name="cohortEndCountQ" datasource="#Application.Settings.IEIR_RO#">
          	select count(student) as count from stu_term_outcomes 
            	where student in 
              	(select student_id from student_ident where cohort=#term# and intent in (1,2,3,6) and stu_load #load_opr# 12 and 
                	location = #locCodesQ.lc_id#) and 
              	term = '#endTermQ.term#'
          </cfquery>
          <cfset totalEnd += cohortEndCountQ.count>
					<!--- Get the numbers of completers to add into the mix --->
          <cfif term_inc gt 1>  <!--- Find the completers over the course of the whole year --->
          	<cfquery name="cohortCompletersQ" datasource="#Application.Settings.IEIR_RO#">
            	select count(student_id) as count from student_ident
              	where cohort=#term# and intent in (1,2,3,6) and stu_load #load_opr# 12 and location = #locCodesQ.lc_id# and
                  ssn in (select distinct(ssn) from stu_awards where acad_year = #startTermQ.acad_year#)
            </cfquery>
          <cfelse>
          	<cfquery name="cohortCompletersQ" datasource="#Application.Settings.IEIR_RO#">
            	select count(student_id) as count from student_ident
              	where cohort = #term# and intent in (1,2,3,6) and stu_load #load_opr# 12 and location = #locCodesQ.lc_id# and
                  ssn in (select distinct(ssn) from stu_awards where acad_year = #startTermQ.acad_year# and award_month = #awardMonths[startTermQ.semester]#)
            </cfquery>
          </cfif>
          <!--- <cfoutput>Cohort Completers = #cohortCompletersQ.count#<br /></cfoutput> --->
          <cfset totalCompleters += cohortCompletersQ.count>
					<!--- Put all the results in a struct that can be used later and then store the struct in the return array --->
					<cfset rset = StructNew()>
          <cfset rset.startTerm = startTermQ.term>
          <cfset rset.endTerm= endTermQ.term>
          <cfset rset.startClassSize = cohortStartCountQ.count>
          <cfset rset.endClassSize = cohortEndCountQ.count>
          <cfset rset.completers = cohortCompletersQ.count>
          <cfset rset.retained = ((rset.endClassSize + rset.completers) / rset.startClassSize) * 100>
          <cfset rset.location = locCodesQ.campus>
          <cfset rsets[rsetCount] = rset>
        </cfloop> <!--- query="locCodesQ" --->
				<!--- Now create an rset for the "totals" row --->
        <cfset rset = StructNew()>
        <cfset rset.startTerm = startTermQ.term>
        <cfset rset.endTerm = endTermQ.term>
        <cfset rset.startClassSize =  totalStart>
        <cfset rset.endClassSize = totalEnd>
        <cfset rset.completers = totalCompleters>
        <cfset rset.retained = ((totalEnd + totalCompleters) / totalStart) * 100>
        <cfset rset.location = "TSTC West Texas Totals">
        <cfset rsetCount += 1>
        <cfset rsets[rsetCount] = rset>
      <cfelse> <!--- Data not requested by loc - get one set of figures for all West Texas Combined --->
        <!--- Get the cohort start size --->
        <cfquery name="cohortStartCountQ" datasource="#Application.Settings.IEIR_RO#">
        	select count(*) as count from student_ident where cohort=#term# and intent in (1,2,3,6) and stu_load #load_opr# 12
        </cfquery>
				<!--- get the cohort end size --->
        <cfquery name="cohortEndCountQ" datasource="#Application.Settings.IEIR_RO#">
        	select count(student) as count from stu_term_outcomes where student in
          	(select student_id from student_ident where cohort=#term# and intent in (1,2,3,6) and stu_load #load_opr# 12) and
            term =  '#endTermQ.term#'
         </cfquery>
				<!--- get the completers --->
        <cfif term_inc gt 1>  <!--- Find the completers over the course of the whole year --->
        	<cfquery name="cohortCompletersQ" datasource="#Application.Settings.IEIR_RO#">
          	select count(student_id) as count from student_ident
            	where cohort=#term# and intent in (1,2,3,6) and stu_load #load_opr# 12 and
                ssn in (select distinct(ssn) from stu_awards where acad_year = #startTermQ.acad_year#)
          </cfquery>
        <cfelse>
        	<cfquery name="cohortCompletersQ" datasource="#Application.Settings.IEIR_RO#">
          	select count(student_id) as count from student_ident
            	where cohort = #term# and intent in (1,2,3,6) and stu_load #load_opr# 12 and
                ssn in (select distinct(ssn) from stu_awards where acad_year = #startTermQ.acad_year# and award_month = #awardMonths[startTermQ.semester]#)
          </cfquery>
        </cfif>
        <cfset rset=StructNew()>
        <cfset rsetCount += 1>
        <cfset rset.startTerm = startTermQ.term>
        <cfset rset.endTerm = endTermQ.term>
        <cfset rset.startClassSize = cohortStartCountQ.count>
        <cfset rset.endClassSize = cohortEndCountQ.count>
        <cfset rset.completers = cohortCompletersQ.count>
        <cfset rset.retained = ((rset.endClassSize + rset.completers) / rset.startClassSize) * 100>
        <cfset rset.location = "">
        <cfset rsets[rsetCount] = rset>
      </cfif> <!--- byloc eq "on" --->
    </cfloop> <!---  index="ndx" from="1" to="#ArrayLen(termsItr)#" step="1" --->
		<!--- End CFLOOP Terms --->
		<cfreturn rsets>
	</cffunction>
  
  <!--- Return retention sets for the selected terms for Developmental Students --->
  <cffunction name='getRetentionDev' access='public' returntype='array'>
  	<cfargument name='terms' type='string' required='yes'>
    <cfargument name='term_inc' type='numeric' required='yes'>
    <cfargument name='dev_students' type='numeric' required='yes'>
    <cfparam name='byloc' default=''>
    <!--- Convert the list of cohorts to an array to be processed one at a time --->
		<cfset termsItr = ListToArray(#terms#,",")>
		<!--- Set up the comparison operator depending on if we want dev or non-dev students --->
    <cfif dev_students eq 1>
    	<cfset dev_flag = "Y">
    <cfelse>
    	<cfset dev_flag = "N">
    </cfif>
    <!--- Set up some local variables --->
    <cfset rsets = ArrayNew(1)>
    <cfset awardMonths=[12,4,8]>
    <!--- Start CFLOOP TERMS --->
    <cfset rsetCount=0>
    <!--- Main Loop for each term --->
    <cfloop index="ndx" from="1" to="#ArrayLen(termsItr)#" step="1">
			<!--- Get the start term and academic year of the cohort.  The academic year
						is used to find completers. --->
      <cfquery name="startTermQ" datasource="#Application.Settings.IEIR_RO#">
      	select term,acad_year,semester from year_terms where cohort=#termsItr[ndx]#
      </cfquery>
      <!--- Get the end term of the cohort --->
      <cfquery name="endTermQ" datasource="#Application.Settings.IEIR_RO#">
      	select term from year_terms where cohort=(#termsItr[ndx]# + #term_inc#)
      </cfquery>
			<cfset term = termsItr[ndx]>
    	<!--- Begin CFIF BYLOC --->
      <cfif byloc eq "on">
      	<!--- Load the loc codes from the db --->
        <cfquery name="locCodesQ" datasource="#Application.Settings.IEIR_RO#">
        	select lc_id,campus from locations order by campus
        </cfquery>
        <!--- I think we can do this with a struct and use the var names below as keys.  Keep it in mind --->
        <cfset totalStart = 0>
        <cfset totalEnd = 0>
        <cfset totalCompleters = 0>
				<cfloop query="locCodesQ">
        	<cfset rsetCount += 1>
          <!--- Get the size of the beginning cohort for each location --->
          <cfquery name="cohortStartQ" datasource="#Application.Settings.IEIR_RO#">
          	select count(*) as count from student_ident where cohort=#term# and intent in (1,2,3,6) and stu_load >= 12 and location = #locCodesQ.lc_id# and
            	student_id in (select student from stu_term_outcomes where term = '#startTermQ.term#' and dev_student = '#dev_flag#')
          </cfquery>
          <cfset totalStart += cohortStartQ.count>
          <!--- Get the size of the cohort in the measurement term --->
          <cfquery name="cohortEndQ" datasource="#Application.Settings.IEIR_RO#">
          	select count(student) as count from stu_term_outcomes where student in
            	(select student_id from student_ident where cohort = #term# and intent in (1,2,3,6) and stu_load >= 12 and location = #locCodesQ.lc_id# and
              	student_id in (select student from stu_term_outcomes where term = '#startTermQ.term#' and dev_student = '#dev_flag#')) and term = '#endTermQ.term#'
          </cfquery>
          <cfset totalEnd += cohortEndQ.count>
					<!--- Get the completers to offset our losses --->
          <cfif term_inc gt 1>
          	<cfquery name="completers" datasource="#Application.Settings.IEIR_RO#">
            	select count(student_id) as count from student_ident where cohort = #term# and intent in (1,2,3,6) and stu_load >= 12 and location = #locCodesQ.lc_id# and
              	student_id in (select student from stu_term_outcomes where term = '#startTermQ.term#' and dev_student = '#dev_flag#') and
                ssn in (select distinct(ssn) from stu_awards where cal_year = #startTermQ.acad_year#)
            </cfquery>
          <cfelse>
          	<cfquery name="completers" datasource="#Application.Settings.IEIR_RO#">
            	select count(student_id) as count from student_ident where cohort = #term# and intent in (1,2,3,6) and stu_load >= 12 and location = #locCodesQ.lc_id# and
              	student_id in (select student from stu_term_outcomes where term = '#startTermQ.term#' and dev_student = '#dev_flag#') and
                ssn in (select distinct(ssn) from stu_awards where cal_year = #startTermQ.acad_year# and award_month = #awardMonths[startTermQ.semester]#)
            </cfquery>
          </cfif>
          <cfset totalCompleters += completers.count>
          <!--- Debug statements --->	
					<!--- Put all the results in a struct that can be used later and then store the struct in the return array --->
					<cfset rset = StructNew()>
          <cfset rset.startTerm = startTermQ.term>
          <cfset rset.endTerm= endTermQ.term>
          <cfset rset.startClassSize = cohortStartQ.count>
          <cfset rset.endClassSize = cohortEndQ.count>
          <cfset rset.completers = completers.count>
          <cfset rset.retained = ((rset.endClassSize + rset.completers) / rset.startClassSize) * 100>
          <cfset rset.location = locCodesQ.campus>
          <cfset rsets[rsetCount] = rset>
        </cfloop>  <!--- End byLoc loop ---> 
				<!--- Now create an rset for the "totals" row --->
        <cfset rset = StructNew()>
        <cfset rset.startTerm = startTermQ.term>
        <cfset rset.endTerm = endTermQ.term>
        <cfset rset.startClassSize =  totalStart>
        <cfset rset.endClassSize = totalEnd>
        <cfset rset.completers = totalCompleters>
        <cfset rset.retained = ((totalEnd + totalCompleters) / totalStart) * 100>
        <cfset rset.location = "TSTC West Texas Totals">
        <cfset rsetCount += 1>
        <cfset rsets[rsetCount] = rset>
      <cfelse> <!--- We don't care about location, just do all west tex combined --->
				<!--- Get the number of students who started the cohort --->
      	<cfquery name="startCount" datasource="#Application.Settings.IEIR_RO#">
        	select count(*) as count from student_ident where cohort = #term# and intent in (1,2,3,6) and stu_load >= 12 and
          	student_id in (select student from stu_term_outcomes where term = '#startTermQ.term#' and dev_student = '#dev_flag#')
        </cfquery>
        <!--- Get the number of those who remain after term_inc semesters --->
        <cfquery name="endCount" datasource="#Application.Settings.IEIR_RO#">
        	select count(student) as count from stu_term_outcomes where student in
          	(select student_id from student_ident where cohort = #term# and intent in (1,2,3,6) and stu_load >= 12 and
            	student_id in (select student from stu_term_outcomes where term = '#startTermQ.term#' and dev_student = '#dev_flag#')) and term = '#endTermQ.term#'
        </cfquery>
        <!--- Get the completers --->
       	<cfif term_inc gt 1>
	        <cfquery name="completers" datasource="#Application.Settings.IEIR_RO#">
        		select count(student_id) as count from student_ident where cohort = #term# and intent in (1,2,3,6) and stu_load >= 12 and
            	student_id in (select student from stu_term_outcomes where term = '#startTermQ.term#' and dev_student = '#dev_flag#') and
              ssn in (select distinct(ssn) from stu_awards where cal_year = #startTermQ.acad_year#)
          </cfquery>
        <cfelse>
        	<cfquery name="completers" datasource="#Application.Settings.IEIR_RO#">
          	select count(student_id) as count from student_ident where cohort=#term# and intent in (1,2,3,6) and stu_load >= 12 and
          		ssn in (select distinct(ssn) from stu_awards where cal_year = #startTermQ.acad_year# and award_month = #awardMonths[startTermQ.semester]#) and
              student_id in (select student from stu_term_outcomes where term = '#startTermQ.term#' and dev_student = '#dev_flag#')
          		
          </cfquery>
        </cfif>
        <cfset rset=StructNew()>
        <cfset rsetCount += 1>
        <cfset rset.startTerm = startTermQ.term>
        <cfset rset.endTerm = endTermQ.term>
        <cfset rset.startClassSize = startCount.count>
        <cfset rset.endClassSize = endCount.count>
        <cfset rset.completers = completers.count>
        <cfset rset.retained = ((rset.endClassSize + rset.completers) / rset.startClassSize) * 100>
        <cfset rset.location = "">
        <cfset rsets[rsetCount] = rset>
			</cfif>
		</cfloop> <!--- End Main Loop for each term --->
    <cfreturn rsets>
  </cffunction>
  
</cfcomponent>