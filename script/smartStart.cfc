<!--- This component contains methods for accessing and tracking smart-start information. --->
<cfcomponent>
	
	<!--- Get the tracking data for a term and a location. --->
  <cffunction name="getTrackData" access="public" returnType="struct">
  	<cfargument name="term" type="string" required="yes">
    <cfargument name="location" type="numeric" required="yes">
    <cfset initResults = StructNew()>
    <!--- Get the total number of students enrolled for the given term. --->
    <cfset course=''>
    <cfquery name='course' datasource='#Application.Settings.IEIR_RO#'>
    	select course from smart_start where term = '#term#' and loc = #location#
    </cfquery>
    <cfset enrolled = ''>
    <cfquery name="enrolled" datasource="#Application.Settings.IEIR_RO#">
    	select count(distinct(stc_person_id)) as starters from stu_course_sections
      	where scs_reporting_term = '#term#'
        	and scs_location = #location#
        	and stc_course_name = '#course.course#'
    </cfquery>
    <cfset initResults.started = enrolled.starters>
    <!--- Get the number of students who passed --->
    <cfset passed=''>
    <cfquery name="passed" datasource="#Application.Settings.IEIR_RO#">
    	select count(distinct(stc_person_id)) as num from stu_course_sections
      	where scs_reporting_term = '#term#'
        	and scs_location = #location#
        	and stc_course_name = '#course.course#'
          and stc_verified_grade in ('S','P')
    </cfquery>
    <cfset initResults.passed = passed.num>
    <!--- Get the number of students who are still in progress. --->
    <cfset inProg=''>
    <cfquery name="inProg" datasource="#Application.Settings.IEIR_RO#">
    	select count(distinct(stc_person_id)) as num from stu_course_sections
      	where scs_reporting_term = '#term#'
        	and scs_location = #location#
        	and stc_course_name = '#course.course#'
          and stc_verified_grade = ''
    </cfquery>
    <cfset initResults.inProg = inProg.num>
    <!--- Get the number of students who failed. --->
    <cfset failed=''>
    <cfquery name="failed" datasource="#Application.Settings.IEIR_RO#">
    	select count(distinct(stc_person_id)) as num from stu_course_sections
      	where scs_reporting_term = '#term#'
        	and scs_location = #location#
        	and stc_course_name = '#course.course#'
          and stc_verified_grade in ('U','F')
    </cfquery>
    <cfset initResults.failed = failed.num>
    <!--- Get the number of students who withdrew. --->
    <cfset wd=''>
    <cfquery name="wd" datasource="#Application.Settings.IEIR_RO#">
    	select count(distinct(stc_person_id)) as num from stu_course_sections
      	where scs_reporting_term = '#term#'
        	and scs_location = #location#
        	and stc_course_name = '#course.course#'
          and stc_verified_grade = 'W'
    </cfquery>
    <cfset initResults.wd = wd.num>
    <cfset initResults.course = course.course>
    
    <!--- Get the number of students who actually enrolled after they completed Smart Start. --->
    <!--- First we have to figure out WHAT the next semester is... Start by getting the cohort number
		      for the known term. Start by jacking with the year_terms table. --->
    <cfset yt1=''>
    <cfquery name='yt1' datasource="#Application.Settings.IEIR_RO#">
    	select cohort from year_terms where term = concat('20','#term#')
    </cfquery>
    <!--- Get the first actual enrollment term AFTER completion of the the smart start term. --->
    <cfset firstTermInCollege=''>
    <cfquery name="firstTermInCollege" datasource="#Application.Settings.IEIR_RO#">
    	select substring(term,3) as term from year_terms where cohort = #yt1.cohort + 1#
    </cfquery>
    <!--- Ok. Now we can count the number of these students that actually registered, but first we have do 
		determine if the 001 for this term has been certified and imported yet. If so, we can use the student_terms
		table. If not, we'll have to rely on the last registration report for the term. --->
    <!--- Start out by running a query against student_terms.  We already have a query for the ids we are interested in -
		namely those students who PASSED the Smart Start --->
		<cfset progressed=0>
		<cfset collegeStarters=''>
    <cfquery name="collegeStarters" datasource="#Application.Settings.IEIR_RO#">
    	select count(distinct(id_no)) as progressed from student_terms
      	where rpt_term = "#firstTermInCollege.term#"
        	and flex_entry = 0
          and id_no in (    
        		select stc_person_id from stu_course_sections
      				where scs_reporting_term = '#term#'
        			and scs_location = #location#
        			and stc_course_name = '#course.course#'
          		and stc_verified_grade in ('S',''))
    </cfquery>
    <!--- if this came back as 0, check the daily_reg table for the term.  If THAT comes back 0, either we haven't
		started registration for the term or else we totally failed and 0 is the answer... --->
    <cfif collegeStarters.progressed gt 0>
    	<cfset progressed = collegeStarters.progressed>
    <cfelse>
    	<!--- Dig thru the reg data - this will only reflect students who are still there by the 19th class day. --->
      <cfset lastRegSet=''>
      <cfquery name='lastRegSet' datasource="#Application.Settings.IEIR_RO#">
      	select max(seq) as seq from daily_reg where term = '#firstTermInCollege.term#'
      </cfquery>
      <cfif lastRegSet.seq eq ''>  <!--- haven't started reg for this term yet --->
      	<cfset progressed = 0>
      <cfelse>
				<cfset collegeRegd=''>
        <cfquery name='collegeRegd' datasource="#Application.Settings.IEIR_RO#">
          select count(distinct(student_id)) as count from daily_reg
            where term = '#firstTermInCollege.term#'
              and seq = #lastRegSet.seq#
              and student_id in (
                  select stc_person_id from stu_course_sections
                    where scs_reporting_term = '#term#'
				        			and scs_location = #location#
                      and stc_course_name = '#course.course#'
                      and stc_verified_grade in ('S',''))
        </cfquery>
				<cfset progressed = collegeRegd.count>
      </cfif>
    </cfif>
    <cfset initResults.registered = progressed>
    <cfset initResults.term1 = #firstTermInCollege.term#>
    
    <!--- out of those students who passed and registered, count those who withdrew during the first term. --->
    <cfset stillHere1=0>
    <cfset wd1=''>
    <cfquery name="wd1" datasource="#Application.Settings.IEIR_RO#">
    	select count(*) as wds from em_temp_wd_info
				where term = '#firstTermInCollege.term#'
					and convert((substring(atid,1,7)),signed) in (
						select stc_person_id from stu_course_sections
							where scs_reporting_Term = '#term#'
	        			and scs_location = #location#
								and stc_course_name = '#course.course#')
		</cfquery>
    <cfset initResults.stillHere1 = progressed - wd1.wds>

    <!--- Get the number of students who actually enrolled after they completed Smart Start. --->
    <!--- First we have to figure out WHAT the next + 1 semester is... Start by getting the cohort number
		      for the known term. Start by jacking with the year_terms table. --->
    <!--- Get the first actual enrollment term AFTER completion of the the smart start term. --->
    <cfset secTermInCollege=''>
    <cfquery name="secTermInCollege" datasource="#Application.Settings.IEIR_RO#">
    	select substring(term,3) as term from year_terms where cohort = #yt1.cohort + 2#
    </cfquery>
    <cfset initResults.term2 = #secTermInCollege.term#>
    <!--- Ok. Now we can count the number of these students that actually registered, but first we have do 
		determine if the 001 for this term has been certified and imported yet. If so, we can use the student_terms
		table. If not, we'll have to rely on the last registration report for the term. --->
    <!--- Start out by running a query against student_terms.  We already have a query for the ids we are interested in -
		namely those students who PASSED the Smart Start --->
		<cfset progressed2=0>
		<cfset collegeStarters2=''>
    <cfquery name="collegeStarters2" datasource="#Application.Settings.IEIR_RO#">
    	select count(distinct(id_no)) as progressed from student_terms
      	where rpt_term = "#secTermInCollege.term#"
        	and flex_entry = 0
          and id_no in (    
        		select stc_person_id from stu_course_sections
      				where scs_reporting_term = '#term#'
        			and scs_location = #location#
        			and stc_course_name = '#course.course#'
          		and stc_verified_grade = 'S')
    </cfquery>
    <!--- if this came back as 0, check the daily_reg table for the term.  If THAT comes back 0, either we haven't
		started registration for the term or else we totally failed and 0 is the answer... --->
    <cfif collegeStarters2.progressed gt 0>
    	<cfset progressed2 = collegeStarters2.progressed>
    <cfelse>
    	<!--- Dig thru the reg data - this will only reflect students who are still there by the 19th class day. --->
      <cfset lastRegSet2=''>
      <cfquery name='lastRegSet2' datasource="#Application.Settings.IEIR_RO#">
      	select max(seq) as seq from daily_reg where term = '#secTermInCollege.term#'
      </cfquery>
      <cfif lastRegSet2.seq eq ''>  <!--- haven't started reg for this term yet --->
      	<cfset progressed2 = 0>
      <cfelse>
				<cfset collegeRegd2=''>
        <cfquery name='collegeRegd2' datasource="#Application.Settings.IEIR_RO#">
          select count(distinct(student_id)) as count from daily_reg
            where term = '#secTermInCollege.term#'
              and seq = #lastRegSet2.seq#
              and student_id in (
                  select stc_person_id from stu_course_sections
                    where scs_reporting_term = '#term#'
				        			and scs_location = #location#
                      and stc_course_name = '#course.course#'
                      and stc_verified_grade = 'S')
        </cfquery>
				<cfset progressed2 = collegeRegd2.count>
      </cfif>
    </cfif>
    <cfset initResults.registered2 = progressed2>
    
    <!--- Get the number of students who actually enrolled after they completed Smart Start. --->
    <!--- First we have to figure out WHAT the next + 2 semester is... Start by getting the cohort number
		      for the known term. Start by jacking with the year_terms table. --->
    <!--- Get the first actual enrollment term AFTER completion of the the smart start term. --->
    <cfset thirdTermInCollege=''>
    <cfquery name="thirdTermInCollege" datasource="#Application.Settings.IEIR_RO#">
    	select substring(term,3) as term from year_terms where cohort = #yt1.cohort + 3#
    </cfquery>
    <cfset initResults.term3 = #thirdTermInCollege.term#>
    <!--- Ok. Now we can count the number of these students that actually registered, but first we have do 
		determine if the 001 for this term has been certified and imported yet. If so, we can use the student_terms
		table. If not, we'll have to rely on the last registration report for the term. --->
    <!--- Start out by running a query against student_terms.  We already have a query for the ids we are interested in -
		namely those students who PASSED the Smart Start --->
		<cfset progressed3=0>
		<cfset collegeStarters3=''>
    <cfquery name="collegeStarters3" datasource="#Application.Settings.IEIR_RO#">
    	select count(distinct(id_no)) as progressed from student_terms
      	where rpt_term = "#thirdTermInCollege.term#"
        	and flex_entry = 0
          and id_no in (    
        		select stc_person_id from stu_course_sections
      				where scs_reporting_term = '#term#'
        			and scs_location = #location#
        			and stc_course_name = '#course.course#'
          		and stc_verified_grade = 'S')
    </cfquery>
    <!--- if this came back as 0, check the daily_reg table for the term.  If THAT comes back 0, either we haven't
		started registration for the term or else we totally failed and 0 is the answer... --->
    <cfif collegeStarters3.progressed gt 0>
    	<cfset progressed3 = collegeStarters3.progressed>
    <cfelse>
    	<!--- Dig thru the reg data - this will only reflect students who are still there by the 19th class day. --->
      <cfset lastRegSet3=''>
      <cfquery name='lastRegSet3' datasource="#Application.Settings.IEIR_RO#">
      	select max(seq) as seq from daily_reg where term = '#thirdTermInCollege.term#'
      </cfquery>
      <cfif lastRegSet3.seq eq ''>  <!--- haven't started reg for this term yet --->
      	<cfset progressed3 = 0>
      <cfelse>
				<cfset collegeRegd3=''>
        <cfquery name='collegeRegd3' datasource="#Application.Settings.IEIR_RO#">
          select count(distinct(student_id)) as count from daily_reg
            where term = '#thirdTermInCollege.term#'
              and seq = #lastRegSet3.seq#
              and student_id in (
                  select stc_person_id from stu_course_sections
                    where scs_reporting_term = '#term#'
				        			and scs_location = #location#
                      and stc_course_name = '#course.course#'
                      and stc_verified_grade = 'S')
        </cfquery>
				<cfset progressed3 = collegeRegd3.count>
      </cfif>
    </cfif>
    <cfset initResults.registered3 = progressed3>
		
    <!--- Now let's  get the number of the students that started here and have completed. --->

    <cfset completers=0>
    <cfset grads=''>
    <cfquery name='grads' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as done from stu_awards
      	where term in ('#firstTermInCollege.term#','#secTermInCollege.term#','#thirdTermInCollege.term#')
        	and student_id in (
                  select stc_person_id from stu_course_sections
                    where scs_reporting_term = '#term#'
				        			and scs_location = #location#
                      and stc_course_name = '#course.course#'
                      and stc_verified_grade = 'S')
		</cfquery>
    <cfset initResults.grads = grads.done>
    <cfreturn initResults>
  </cffunction>
  
	<!--- Get a campus name --->
  <cffunction name="getCampus" access="public" returntype="string">
  	<cfargument name="location" type="numeric" required="yes">
		<cfset campus=''>
    <cfquery name="campus" datasource="#Application.Settings.IEIR_RO#">
    	select campus from locations where lc_id = #location#
    </cfquery>
		<cfreturn campus.campus>
	</cffunction>

	<!--- Get all locations and their names we've taught the smart-start program. --->
  <cffunction name="getLocs" access="public" returntype="query">
		<cfset locs=''>
    <cfquery name="locs" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(a.loc) as loc,  b.campus as locName from smart_start a, locations b
      	where a.loc = b.lc_id order by locName
    </cfquery>
		<cfreturn locs>
	</cffunction>


	<!--- Get all terms we've taught the smart-start program. --->
  <cffunction name="getTerms" access="public" returntype="query">
  	<cfargument name="location" type="numeric" required="yes">
		<cfset terms=''>
    <cfquery name="terms" datasource="#Application.Settings.IEIR_RO#">
    	select term from smart_start where loc = #location# order by seq
    </cfquery>
		<cfreturn terms>
	</cffunction>

</cfcomponent>