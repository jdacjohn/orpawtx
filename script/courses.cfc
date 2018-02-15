<!--- This component provides methods for analyzing course-related information. --->
<cfcomponent>

	<!--- Get all courses taught in a given academic year that match a mnemonic search term. --->
  <cffunction name="findCoursesForTerms" access="public" returntype="query">
  	<cfargument name='mnemonic' type="string" required="yes">
    <cfargument name="terms" type="string" required="yes">
    <cfargument name="exclude" type="string" required="yes">
    <cfset coursesFound=''>
    <cfif exclude eq '()'>
    	<cfset exclude = '("BasketWeaving")'>
    </cfif>
    <cfquery name='coursesFound' datasource="#Application.Settings.IEIR_RO#">
    	select distinct(course_name) as class from course_outcomes
      	where course_name like '#mnemonic#%'
        	and term in #terms# and course_name not in #exclude#
        order by course_name
    </cfquery>
    <cfreturn coursesFound>
  </cffunction>
  
  <!--- Get the College Name --->
  <cffunction name="getCollege" access="public" returntype="string">
  	<cfargument name='location' type='numeric' required='yes'>
    <cfset college=''>
    <cfquery name='college' datasource='#Application.Settings.IEIR_RO#'>
    	select campus from locations where lc_id = #location#
    </cfquery>
    <cfreturn college.campus>
  </cffunction>

  <!--- Get the Colleges --->
  <cffunction name="getColleges" access="public" returntype="query">
    <cfset colleges=''>
    <cfquery name='colleges' datasource='#Application.Settings.IEIR_RO#'>
    	select lc_id, campus from locations where active = 'Y' and lc_id < 6 order by campus
    </cfquery>
    <cfreturn colleges>
  </cffunction>

	<!--- Get course drop and fail rates for a course in a given term. --->
	<cffunction name="getCourseDropFailRates" access="public" returntype="struct">
		<cfargument name="term" type="string" required="yes">
    <cfargument name="course" type="string" required="yes">
    <cfargument name="loc" type="numeric" required="yes">
    <cfset theCourse=StructNew()>
    <cfset qCourse=''>
    <cfquery name='qCourse' datasource='#Application.Settings.IEIR_RO#'>
      select distinct(course_name) as course,
       course_title,
        course_length,
        sum(enrolled) as students,
        sum(withdrew) as dropped,
        sum(withdrew) / sum(enrolled) as dropRate,
        sum(failed) as fails,
        sum(failed) / (sum(enrolled) - sum(withdrew)) as failRate,
        (sum(enrolled) - sum(withdrew) - sum(failed))/sum(enrolled) as successRate
      from course_outcomes        
      	where term = '#term#' and course_name = '#course#' and location = #loc#
        group by course_name
    </cfquery>
    <cfif qCourse.RecordCount gt 0>
			<cfset theCourse.course = qCourse.course>
      <cfset theCourse.course_title = qCourse.course_title>
      <cfset theCourse.course_length = qCourse.course_length>
      <cfset theCourse.students = qCourse.students>
      <cfset theCourse.dropped = qCourse.dropped>
      <cfset theCourse.dropRate = qCourse.dropRate>
      <cfset theCourse.fails = qCourse.fails>
      <cfset theCourse.failRate = qCourse.failRate>
      <cfset theCourse.successRate = qCourse.successRate>
    <cfelse>
			<cfset theCourse.course = '-'>
      <cfset theCourse.course_title = 'Class Not Found for Term'>
      <cfset theCourse.course_length = '-'>
      <cfset theCourse.students = '-'>
      <cfset theCourse.dropped = '-'>
      <cfset theCourse.dropRate = '-'>
      <cfset theCourse.fails = '-'>
      <cfset theCourse.failRate = '-'>
      <cfset theCourse.successRate = '-'>
		</cfif>
		<cfreturn theCourse>
	</cffunction>

	<!--- Get the grade distributions for sections taught of a course in a term. --->
  <cffunction name="getGradeDistributions" access="public" returnType="array">
		<cfargument name="term" type="string" required="yes">
    <cfargument name="course" type="string" required="yes">
    <cfargument name="loc" type="numeric" required="yes">
		<cfset sections=ArrayNew(1)>
    <cfset qSections=''>
    <cfset count=0>
    <cfquery name="qSections" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(stc_section_no) as secNo from stu_course_sections
      	where stc_course_name = '#course#'
        	and scs_reporting_term = '#term#'
          and substring(stc_section_no,1,1) = #loc#
        order by stc_section_no
    </cfquery>
    <cfloop query="qSections">
    	<cfset section=StructNew()>
      <cfset section.secNo = qSections.secNo>
      <cfset instructor=''>
      <cfquery name="instructor" datasource="#Application.Settings.IEIR_RO#">
      	select instructor_name, instructor_fname from lo_course
        	where term = '#term#'
          	and class = '#course & '-' & qSections.secNo#'
      </cfquery>
      <cfset section.iName = instructor.instructor_name>
      <cfset section.iFName = instructor.instructor_fname>
      <cfset section.grades=0>
      <!--- get the A's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#term#'
            and stc_verified_grade = 'A'
      </cfquery>
      <cfset section.As = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the B's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#term#'
            and stc_verified_grade = 'B'
      </cfquery>
      <cfset section.Bs = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the C's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#term#'
            and stc_verified_grade = 'C'
      </cfquery>
      <cfset section.Cs = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the D's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#term#'
            and stc_verified_grade = 'D'
      </cfquery>
      <cfset section.Ds = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the F's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#term#'
            and stc_verified_grade = 'F'
      </cfquery>
      <cfset section.Fs = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the S's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#term#'
            and stc_verified_grade = 'S'
      </cfquery>
      <cfset section.Ss = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the U's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#term#'
            and stc_verified_grade = 'U'
      </cfquery>
      <cfset section.Us = qGrades.count>
      <cfset section.grades += qGrades.count>
			<!--- Add the current section to the array of sections. --->
      <cfset count += 1>
      <cfset sections[count] = section>
    </cfloop> 
    <cfreturn sections>
	</cffunction>	 	

	<!--- Get course drop and fail rates for a course in a given term. --->
	<cffunction name="getMultipleCourseDropFailRates" access="public" returntype="struct">
		<cfargument name="terms" type="string" required="yes">
    <cfargument name="course" type="string" required="yes">
    <cfargument name="loc" type="numeric" required="yes">
    <cfset theCourse=StructNew()>
		<cfset termsInClause = '(' & terms & ')'>
    <cfset qCourse=''>
    <cfquery name='qCourse' datasource='#Application.Settings.IEIR_RO#'>
      select distinct(course_name) as course,
       course_title,
        course_length,
        sum(enrolled) as students,
        sum(withdrew) as dropped,
        sum(withdrew) / sum(enrolled) as dropRate,
        sum(failed) as fails,
        sum(failed) / (sum(enrolled) - sum(withdrew)) as failRate,
        (sum(enrolled) - sum(withdrew) - sum(failed))/sum(enrolled) as successRate
      from course_outcomes        
      	where term in #termsInClause# and course_name = '#course#' and location = #loc#
        group by course_name
    </cfquery>
    <cfif qCourse.RecordCount gt 0>
			<cfset theCourse.course = qCourse.course>
      <cfset theCourse.course_title = qCourse.course_title>
      <cfset theCourse.course_length = qCourse.course_length>
      <cfset theCourse.students = qCourse.students>
      <cfset theCourse.dropped = qCourse.dropped>
      <cfset theCourse.dropRate = qCourse.dropRate>
      <cfset theCourse.fails = qCourse.fails>
      <cfset theCourse.failRate = qCourse.failRate>
      <cfset theCourse.successRate = qCourse.successRate>
    <cfelse>
			<cfset theCourse.course = '-'>
      <cfset theCourse.course_title = 'Class Not Found for Term'>
      <cfset theCourse.course_length = '-'>
      <cfset theCourse.students = '-'>
      <cfset theCourse.dropped = '-'>
      <cfset theCourse.dropRate = '-'>
      <cfset theCourse.fails = '-'>
      <cfset theCourse.failRate = '-'>
      <cfset theCourse.successRate = '-'>
		</cfif>
		<cfreturn theCourse>
	</cffunction>

	<!--- Get the grade distributions for sections taught of a course in a term. --->
  <cffunction name="getMultipleGradeDistributions" access="public" returnType="array">
		<cfargument name="terms" type="string" required="yes">
    <cfargument name="course" type="string" required="yes">
    <cfargument name="loc" type="numeric" required="yes">
		<cfset sections=ArrayNew(1)>
		<cfset termsInClause = '(' & terms & ')'>
    <cfset qSections=''>
    <cfset count=0>
    <cfquery name="qSections" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(stc_section_no) as secNo, scs_reporting_term  from stu_course_sections
      	where stc_course_name = '#course#'
        	and scs_reporting_term in #termsInClause#
          and substring(stc_section_no,1,1) = #loc#
        order by stc_section_no
    </cfquery>
    <cfloop query="qSections">
    	<cfset section=StructNew()>
      <cfset section.secNo = qSections.secNo>
      <cfset section.term = qSections.scs_reporting_term>
      <cfset instructor=''>
      <cfquery name="instructor" datasource="#Application.Settings.IEIR_RO#">
      	select instructor_name, substring(instructor_fname,1,1) as finit from lo_course
        	where term = '#qSections.scs_reporting_term#'
          	and class = '#course & '-' & qSections.secNo#'
      </cfquery>
      <cfset section.iName = instructor.instructor_name>
      <cfset section.iFInit = instructor.finit>
      <cfset section.grades=0>
      <!--- get the A's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#qSections.scs_reporting_term#'
            and stc_verified_grade = 'A'
      </cfquery>
      <cfset section.As = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the B's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#qSections.scs_reporting_term#'
            and stc_verified_grade = 'B'
      </cfquery>
      <cfset section.Bs = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the C's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#qSections.scs_reporting_term#'
            and stc_verified_grade = 'C'
      </cfquery>
      <cfset section.Cs = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the D's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#qSections.scs_reporting_term#'
            and stc_verified_grade = 'D'
      </cfquery>
      <cfset section.Ds = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the F's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#qSections.scs_reporting_term#'
            and stc_verified_grade = 'F'
      </cfquery>
      <cfset section.Fs = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the S's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#qSections.scs_reporting_term#'
            and stc_verified_grade = 'S'
      </cfquery>
      <cfset section.Ss = qGrades.count>
      <cfset section.grades += qGrades.count>
      <!--- get the U's - (Can believe I'm going to have to call these one at a time. ---> 	
      <cfset qGrades=''>
      <cfquery name="qGrades" datasource="#Application.Settings.IEIR_RO#">
      	select count(*) as count from stu_course_sections
        	where stc_course_name = '#course#'
          	and stc_section_no = '#qSections.secNo#'
            and scs_reporting_term = '#qSections.scs_reporting_term#'
            and stc_verified_grade = 'U'
      </cfquery>
      <cfset section.Us = qGrades.count>
      <cfset section.grades += qGrades.count>
			<!--- Add the current section to the array of sections. --->
      <cfset count += 1>
      <cfset sections[count] = section>
    </cfloop> 
    <cfreturn sections>
	</cffunction>	 	

	<!--- Get Program drop and fail rates for an academic year.  Default order is success rate. --->
	<cffunction name="getProgramDropFailRates" access="public" returntype="query">
		<cfargument name="terms" type="string" required="yes">
    <cfargument name="classes" type="string" required="yes">
    <cfargument name="location" type='numeric' required='yes'>
    <cfset courses=''>
		<cfset termsInClause = '(' & terms & ')'>
    <cfquery name='courses' datasource='#Application.Settings.IEIR_RO#'>
      select distinct(course_name) as course,
       course_title,
        course_length,
        sum(enrolled) as students,
        sum(withdrew) as dropped,
        sum(withdrew) / sum(enrolled) as dropRate,
        sum(failed) as fails,
        sum(failed) / (sum(enrolled) - sum(withdrew)) as failRate,
        (sum(enrolled) - sum(withdrew) - sum(failed))/sum(enrolled) as successRate
      from course_outcomes        
      	where term in #termsInClause#
        	and course_name in #classes#
          and location=#location#
        group by course_name
        order by successRate DESC
    </cfquery>
		<cfreturn courses>
	</cffunction>

	<!--- Get course drop and fail rates for a term.  Default order is course name. --->
	<cffunction name="getTermDropFailRates" access="public" returntype="query">
		<cfargument name="term" type="string" required="yes">
    <cfargument name="location" type="numeric" required="yes">
    <cfargument name="sortClause1" type="string" required="no">
    <cfargument name="sortClause2" type="string" required="no">
    <cfset courses=''>
    <cfset sortOrder='course_name'>

    <cfif sortClause2 neq ''>
    	<cfset sortOrder = sortClause2 & ',' & sortOrder>
    </cfif>

    <cfif sortClause1 neq ''>
    	<cfset sortOrder = sortClause1 & ',' & sortOrder>
    </cfif>
    
    <cfquery name='courses' datasource='#Application.Settings.IEIR_RO#'>
      select distinct(course_name) as course,
       course_title,
        course_length,
        sum(enrolled) as students,
        sum(withdrew) as dropped,
        sum(withdrew) / sum(enrolled) as dropRate,
        sum(failed) as fails,
        sum(failed) / (sum(enrolled) - sum(withdrew)) as failRate,
        (sum(enrolled) - sum(withdrew) - sum(failed))/sum(enrolled) as successRate
      from course_outcomes        
      	where term = '#term#'
        and location = #location#
        group by course_name
        order by #sortOrder#
    </cfquery>
		<cfreturn courses>
	</cffunction>
  
</cfcomponent>