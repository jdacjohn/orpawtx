<cfcomponent>
	
	<cffunction name="getTerms" access="public" returntype="query">
  	<cfquery name="getAvailTerms" datasource="#Application.Settings.IEIR_RO#">
	    select distinct(a.term) as bkTerm, b.cohort ytCohort from book_order_stu_locs a, year_terms b
  	  	where a.term = b.term order by b.cohort
    </cfquery>
    <cfreturn getAvailTerms> 
  </cffunction>
  
	<!--- Get a list of departments for the given numeric term --->
  <cffunction name='getDeptSummary' access='public' returntype='query'>
  	<cfargument name='bk_cohort' type='numeric' required='yes'>
    <cfargument name='seqNo' type='numeric' required='yes'>
    <cfset depts = ''>
    <cfquery name='depts' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(department) as dept,
      			 count(distinct(sec)) as sections,
             sum(students) as registered,
             sum(drops) as drops,
             count(distinct(stu_loc)) as locs
      	from book_order_stu_locs 
        where cohort = #bk_cohort# and seq = #seqNo# group by department order by department
    </cfquery>
    <cfreturn depts>
  </cffunction>
  
  <cffunction name="latestRunDate" access="public" returnType="struct">
  	<cfargument name='bk_cohort' type='numeric' required='yes'>
    <cfset lastRun = StructNew()>
    <cfset lastDate = ''>
    <cfset maxSeq = ''>
    <cfquery name='maxSeq' datasource='#Application.Settings.IEIR_RO#'>
    	select max(seq) as seq from book_order_stu_locs where cohort = #bk_cohort#
    </cfquery>
		<cfset lastRun.seq = maxSeq.seq>
    <cfquery name='lastDate' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(run_date) as run_date from book_order_stu_locs where cohort = #bk_cohort# and seq = #maxSeq.seq#
    </cfquery>
    <cfset lastRun.runDate = lastDate.run_date>
    <cfreturn lastRun>
  </cffunction>
  
	<cffunction name='getDeptDetail' access='public' returntype='query'>
  	<cfargument name='bk_cohort' type='numeric' required='yes'>
    <cfargument name='dept' type='string' required='yes'>
    <cfargument name='seqNo' type='numeric' required='yes'>
		<cfquery name='sections' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(sec) as secName, sum(students) as registered, sum(drops) as drops, count(distinct(stu_loc)) as locs
      	from book_order_stu_locs
        where cohort = #bk_cohort# and seq = #seqNo# and department = '#dept#'
        group by sec order by sec
    </cfquery>
    <cfreturn sections>
  </cffunction>

	<cffunction name='getSecDetail' access='public' returntype='query'>
  	<cfargument name='bk_cohort' type='numeric' required='yes'>
    <cfargument name='dept' type='string' required='yes'>
    <cfargument name='sectionName' type='string' required='yes'>
    <cfargument name='seqNo' type='numeric' required='yes'>
		<cfquery name='campusList' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(stu_campus) as campus, students as registered, drops
      	from book_order_stu_locs
        where cohort = #bk_cohort# and seq = #seqNo# and department = '#dept#' and sec = '#sectionName#'
        group by stu_campus order by stu_campus
    </cfquery>
    <cfreturn campusList>
  </cffunction>
      
</cfcomponent>