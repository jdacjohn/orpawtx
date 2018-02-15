<cfcomponent>
	
  <cffunction name="em_summary" access="public" returntype="query">
  	<cfargument name="varCohort" type="numeric" required="no">
    <cfargument name="varSequence" type="numeric" required="no">
		<cfset em_lines = ''>
    <cfset lineItems = StructNew()>
    <cfif isdefined('varCohort')>
    	<cfset selCohort = varCohort>
    <cfelse>
    	<cfset selCohort = #Application.Settings.EmTermCohort#>
    </cfif>
    <cfif isdefined('varSequence')>
    	<cfset selSequence = varSequence>
    <cfelse>
      <cfquery name='maxSeq' datasource="#Application.Settings.IEIR_RO#">
        select max(seq) as seqNo from em_monitor where cohort = #selCohort#
      </cfquery>
      <cfset selSequence = maxSeq.seqNo>
    </cfif>
    <cfquery name="em_lines" datasource="#Application.Settings.IEIR_RO#">
    	select sum(new_apps) as new_apps, sum(pending_apps) as pending, sum(proj_new) as proj_new, sum(proj_ret) as proj_ret, loc from em_monitor
      	where cohort = #selCohort# and seq = #selSequence#
        group by loc
    </cfquery>
    
		<cfreturn em_lines>
	</cffunction>
  
	<!--- Get the division level records --->
  <cffunction name="em_divisions" access="public" returntype="array">
  	<cfargument name="varCohort" type="numeric" required="yes">
    <cfargument name="varSequence" type="numeric" required="no">
    <cfif isdefined('varCohort')>
    	<cfset selCohort = varCohort>
    <cfelse>
    	<cfset selCohort = #Application.Settings.EmTermCohort#>
    </cfif>
    <cfif isdefined('varSequence')>
    	<cfset selSequence = varSequence>
    <cfelse>
      <cfquery name='maxSeq' datasource="#Application.Settings.IEIR_RO#">
        select max(seq) as seqNo from em_monitor where cohort = #selCohort#
      </cfquery>
      <cfset selSequence = maxSeq.seqNo>
    </cfif>
    <cfset getTerm = ''>
    <cfquery name='getTerm' datasource='#Application.Settings.IEIR_RO#'>
    	select substring(term,3) as theTerm from year_terms where cohort = #selCohort#
    </cfquery>
    <!--- Get a list of divisions from the em_program_targets table --->
    <cfset divs = ''>
    <cfquery name='divs' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(division) as division, sum(new_students) as target_new, sum(returners) as target_returners 
      	from em_program_targets where term = '#getTerm.theTerm#' 
        group by division 
        order by division
    </cfquery>
  	<cfset divData = ArrayNew(1)>
    <cfset divDataPos = 1>
    <!--- Get summary level information for the divisions --->
    <cfloop query='divs'>
    	<cfset divInfo=StructNew()>
      <cfset divInfo.name=divs.division>
      <cfset divInfo.target_new=divs.target_new>
      <cfset divInfo.target_returners=divs.target_returners>
      <cfset divInfo.target_total = divs.target_new + divs.target_returners>
      <cfquery name="divAppData" datasource="#Application.Settings.IEIR_RO#">
        select sum(new_apps) as newApps, sum(proj_new) as projectedNew, sum(proj_ret) as projectedReturning,
                sum(pending_apps) as pendingApps, (sum(proj_new) + sum(proj_ret)) as projectedTotal
        from em_monitor 
         	where cohort = #selCohort# and seq = #selSequence# and major in 
          	(select distinct(major) from em_program_targets where division = '#divs.division#' and term = '#getTerm.theTerm#')
      </cfquery>
			<cfset divInfo.new = divAppData.newApps>
      <cfset divInfo.projected_new = divAppData.projectedNew>
      <cfset divInfo.projected_returning = divAppData.projectedReturning>
      <cfset divInfo.pending = divAppData.pendingApps>
      <cfset divInfo.projected_total = divAppData.projectedTotal>
      <cfset divData[divDataPos] = divInfo>
			<cfset divDataPos += 1>    
    </cfloop>
    <!--- Now get the existing enrollment info for unassigned majors. --->
    <cfset nonDivInfo = StructNew()>
    <cfset nonDivInfo.name = 'Unassigned'>
    <cfset nonDivInfo.target_new = 0>
    <cfset nonDivInfo.target_returners = 0>
    <cfset nonDivInfo.target_total = 0>
    <cfset nonDivAppData = ''>
    <cfquery name="nonDivAppData" datasource="#Application.Settings.IEIR_RO#">
        select sum(new_apps) as newApps, sum(proj_new) as projectedNew, sum(proj_ret) as projectedReturning,
                sum(pending_apps) as pendingApps, (sum(proj_new) + sum(proj_ret)) as projectedTotal
        from em_monitor 
         	where cohort = #selCohort# and seq = #selSequence# and major not in 
          	(select distinct(major) from em_program_targets where term = '#getTerm.theTerm#')
    </cfquery>
		<cfset nonDivInfo.new = nonDivAppData.newApps>
    <cfset nonDivInfo.projected_new = nonDivAppData.projectedNew>
    <cfset nonDivInfo.projected_returning = nonDivAppData.projectedReturning>
    <cfset nonDivInfo.pending = nonDivAppData.pendingApps>
    <cfset nonDivInfo.projected_total = nonDivAppData.projectedTotal>
    <cfset divData[divDataPos] = nonDivInfo>    
    <cfreturn divData>
  </cffunction> 
   
	<!--- Get all the detail records for the enrollment monitor for the majors in a division. --->
  <cffunction name="em_detail" access="public" returntype="array">
  	<cfargument name="varCohort" type="numeric" required="yes">
    <cfargument name="varSequence" type="numeric" required="no">
    <cfargument name="varDiv" type="string" required="yes">
    <cfif isdefined('varCohort')>
    	<cfset selCohort = varCohort>
    <cfelse>
    	<cfset selCohort = #Application.Settings.EmTermCohort#>
    </cfif>
    <cfif isdefined('varSequence')>
    	<cfset selSequence = varSequence>
    <cfelse>
      <cfquery name='maxSeq' datasource="#Application.Settings.IEIR_RO#">
        select max(seq) as seqNo from em_monitor where cohort = #selCohort#
      </cfquery>
      <cfset selSequence = maxSeq.seqNo>
    </cfif>
    <cfset getTerm = ''>
    <cfquery name='getTerm' datasource='#Application.Settings.IEIR_RO#'>
    	select substring(term,3) as theTerm from year_terms where cohort = #selCohort#
    </cfquery>
  	<cfset emData = ArrayNew(1)>
    <cfset emDataPos = 1>
    <cfif varDiv neq 'Unassigned'>
      <cfquery name="emMajors" datasource="#Application.Settings.IEIR_RO#">
        select distinct(major) as major, sum(new_apps) as newApps, sum(proj_new) as projectedNew, sum(proj_ret) as projectedReturning,
                sum(pending_apps) as pendingApps, (sum(proj_new) + sum(proj_ret)) as projectedTotal
        from em_monitor 
          where cohort = #selCohort# and seq = #selSequence#
            and major in (select major from em_program_targets where term = '#getTerm.theTerm#' and division = '#varDiv#')
          group by major
          order by major
      </cfquery>
    <cfelse>
      <cfquery name="emMajors" datasource="#Application.Settings.IEIR_RO#">
        select distinct(major) as major, sum(new_apps) as newApps, sum(proj_new) as projectedNew, sum(proj_ret) as projectedReturning,
                sum(pending_apps) as pendingApps, (sum(proj_new) + sum(proj_ret)) as projectedTotal
        from em_monitor 
          where cohort = #selCohort# and seq = #selSequence#
            and major not in (select major from em_program_targets where term = '#getTerm.theTerm#')
          group by major
          order by major
      </cfquery>
		</cfif>
    <cfloop query="emMajors">
    	<cfset majorTargets = ''>
      <cfquery name="majorTargets" datasource="#Application.Settings.IEIR_RO#">
      	select new_students, returners from em_program_targets where term = '#getTerm.theTerm#' and major = '#emMajors.major#'
      </cfquery>
    	<cfset majorData = StructNew()>
      <cfset majorData.major = emMajors.major>
      <cfset majorData.newApps = emMajors.newApps>
      <cfset majorData.projectedNew = emMajors.projectedNew>
      <cfif varDiv neq 'Unassigned'>
				<cfset majorData.target_new = majorTargets.new_students>
      <cfelse>
      	<cfset majorData.target_new = 0>
      </cfif>
      <cfset majorData.projectedReturning = emMajors.projectedReturning>
      <cfif varDiv neq 'Unassigned'>
				<cfset majorData.target_returners = majorTargets.returners>
      <cfelse>
      	<cfset majorData.target_returners = 0>
      </cfif>
      <cfset majorData.pendingApps = emMajors.pendingApps>
      <cfset majorData.projectedTotal = emMajors.projectedTotal>
      <cfif varDiv neq 'Unassigned'>
      	<cfset majorData.target_total = majorTargets.new_students + majorTargets.returners>
      <cfelse>
      	<cfset majorData.target_total = 0>
      </cfif>
      <!--- Get the loc details --->
      <cfquery name="emLocMajors" datasource="#Application.Settings.IEIR_RO#">
      	select  a.loc as loc, a.new_apps as newApps, a.pending_apps as pending, a.proj_new as projectedNew, a.proj_ret as projectedReturning,
        				(a.proj_new + a.proj_ret) as projectedTotal, b.campus as campus
          from em_monitor a, locations b
          where cohort = #selCohort# and seq = #selSequence# and major = '#emMajors.major#'
          	and b.lc_id = a.loc
          order by campus
      </cfquery>
      <cfset locData = ArrayNew(1)>
      <cfset locDataPos = 1>
      <cfloop query="emLocMajors">
      	<cfset locMajorData = StructNew()>
        <cfset locMajorData.loc = emLocMajors.loc>
        <cfset locMajorData.campus = emLocMajors.campus>
        <cfset locMajorData.newApps = emLocMajors.newApps>
        <cfset locMajorData.projectedNew = emLocMajors.projectedNew>
        <cfset locMajorData.projectedReturning = emLocMajors.projectedReturning>
        <cfset locMajorData.pendingApps = emLocMajors.pending>
        <cfset locMajorData.projectedTotal = emLocMajors.projectedTotal>
        <cfset locMajorPending = ''>
        <cfquery name='locMajorPending' datasource='#Application.Settings.IEIR_RO#'>
        	select applicant, last_name, first_name, app_status, phone
          	from em_temp_app_info
            where rpt_term = '#getTerm.theTerm#' and loc = #emLocMajors.loc# and major = '#emMajors.major#' and app_status in ('PD', 'AP')
            order by last_name, first_name
        </cfquery>
        <cfset locMajorData.pendingList = locMajorPending>
        <cfset locMajorNew = ''>
        <cfset latestReg = ''>
        <cfquery name='latestReg' datasource='#Application.Settings.IEIR_RO#'>
        	select max(seq) as sequence from daily_reg where term = '#getTerm.theTerm#'
        </cfquery>
        <cfif latestReg.sequence eq ''>
        	<cfset seqNo = 0>
        <cfelse>
        	<cfset seqNo = latestReg.sequence>
        </cfif>
        <cfquery name='locMajorNew' datasource='#Application.Settings.IEIR_RO#'>
        	select applicant, last_name, first_name, app_status, phone
          	from em_temp_app_info
            where rpt_term = '#getTerm.theTerm#' and loc = #emLocMajors.loc# and major = '#emMajors.major#' and app_status not in ('PD', 'WA', 'AP')
            	and applicant not in (select student_id from daily_reg where term = '#getTerm.theTerm#'
              												and seq = #seqNo#)
            order by last_name, first_name
        </cfquery>
        <cfset locMajorData.newList = locMajornew>
        <cfset locData[locDataPos] = locMajorData>
        <cfset locDataPos += 1>
      </cfloop>
      <cfset majorData.locSpec = locData>
      <cfset emData[emDataPos] = majorData>
      <cfset emDataPos += 1>
    </cfloop>
    <cfreturn emData>
  </cffunction>
  
	<!--- Return the set of report dates for the given term --->
  <cffunction name="emPeriod" access="public" returntype="array">
  	<cfargument name="emTermCohort" type="numeric" required="yes">
		<cfset reportQuery = ''>
    <cfset reportDates = ArrayNew(1)>
    <cfset dateCount = 1>
    <cfquery name="reportQuery" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(run_date) as runDate, seq as regSequence from em_monitor where cohort = #emTermCohort# order by run_date
    </cfquery>
		<cfquery name="getTerm" datasource="#Application.Settings.IEIR_RO#">
    	select term from year_terms where cohort = #emTermCohort#
    </cfquery>
    <cfloop query="reportQuery">
    	<cfset dateSet = StructNew()>
      <cfset dateSet.rptDate = reportQuery.runDate>
      <cfset dateSet.sequence = reportQuery.regSequence>
      <cfset dateSet.term = getTerm.term>
    	<cfset reportDates[dateCount] = dateSet>
      <cfset dateCount += 1>
    </cfloop>
    <cfreturn reportDates>
	</cffunction>

	<!--- Get a list of pending students for a program and a location --->
  <cffunction name='getPendingList' access='public' returnType='query'>
  	<cfargument name="location" type='numeric' required='yes'>
    <cfargument name='major' type='string' required='yes'>
    <cfset pendingList = ''>
    <cfquery name='pendingList' datasource='#Application.Settings.IEIR_RO#'>
      select applicant, last_name, first_name, app_status, phone
        from em_temp_app_info
        where rpt_term = '#Application.Settings.EmTerm#' and loc = #location# and major = '#major#' and app_status in ('PD', 'AP')
        order by last_name, first_name
    </cfquery>
    <cfreturn pendingList>
  </cffunction>

	<!--- Get a list of new student apps for a program and a location.  These students are eligible to register but
	      Have not yet registered. --->
  <cffunction name='getNewList' access='public' returnType='query'>
  	<cfargument name="location" type='numeric' required='yes'>
    <cfargument name='major' type='string' required='yes'>
    <!--- Get the latest sequence for the current registration report --->
    <cfset latestReg = ''>
    <cfquery name='latestReg' datasource='#Application.Settings.IEIR_RO#'>
    	select max(seq) as sequence from daily_reg where term = '#Application.Settings.RegTerm#'
    </cfquery>
    <cfset newList = ''>
    <cfquery name='newList' datasource='#Application.Settings.IEIR_RO#'>
      select applicant, last_name, first_name, app_status, phone
        from em_temp_app_info
        where  rpt_term = '#Application.Settings.EmTerm#' and loc = #location# and major = '#major#' and app_status in ('AC', 'EL')
        	and applicant not in (select student_id from daily_reg where term = '#Application.Settings.RegTerm#'
          												and seq = #latestReg.sequence#)
        order by last_name, first_name
    </cfquery>
    <cfreturn newList>
  </cffunction>

	<!--- Get a list of pending students for a location --->
  <cffunction name='getPendingForLoc' access='public' returnType='array'>
  	<cfargument name="location" type='numeric' required='yes'>
    <cfset majors = ''>
    <cfquery name='majors' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(major) as major from em_temp_app_info where loc = #location# and app_status in ('PD', 'AP') order by major
    </cfquery>
    <cfset allMajors = ArrayNew(1)>
    <cfset arrayPos=1>
    <cfloop query='majors'>
    	<cfset majorDetail = StructNew()>
			<cfset majorDetail.major = majors.major>
      <cfset pendingList = ''>
      <cfquery name='pendingList' datasource='#Application.Settings.IEIR_RO#'>
        select applicant, last_name, first_name, app_status, phone
          from em_temp_app_info
          where rpt_term = '#Application.Settings.EmTerm#' and loc = #location# and major = '#majors.major#' and app_status in ('PD', 'AP')
          order by last_name, first_name
      </cfquery>
      <cfset majorDetail.pendingList = pendingList>
      <cfset allMajors[arrayPos] = majorDetail>
			<cfset arrayPos += 1>
    </cfloop>
    <cfreturn allMajors>
  </cffunction>

	<!--- Get a list of new student apps for a location --->
  <cffunction name='getNewAppsForLoc' access='public' returnType='array'>
  	<cfargument name="location" type='numeric' required='yes'>
    <!--- Get the latest sequence for the current registration report --->
    <cfset latestReg = ''>
    <cfquery name='latestReg' datasource='#Application.Settings.IEIR_RO#'>
    	select max(seq) as sequence from daily_reg where term = '#Application.Settings.RegTerm#'
    </cfquery>
    <cfset majors = ''>
    <cfquery name='majors' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(major) as major from em_temp_app_info where loc = #location# and app_status in ('AC', 'EL') order by major
    </cfquery>
    <cfset allMajors = ArrayNew(1)>
    <cfset arrayPos=1>
    <cfloop query='majors'>
    	<cfset majorDetail = StructNew()>
			<cfset majorDetail.major = majors.major>
      <cfset newAppList = ''>
      <cfquery name='newAppList' datasource='#Application.Settings.IEIR_RO#'>
        select applicant, last_name, first_name, app_status, phone
          from em_temp_app_info
          where rpt_term = '#Application.Settings.EmTerm#' and loc = #location# and major = '#majors.major#' and app_status in ('AC', 'EL')
          	and applicant not in (select student_id from daily_reg where term = '#Application.Settings.RegTerm#'
            												and seq = #latestReg.sequence#)
          order by last_name, first_name
      </cfquery>
      <cfif newApplist.recordcount gt 0>
      	<cfset majorDetail.newAppList = newAppList>
      	<cfset allMajors[arrayPos] = majorDetail>
				<cfset arrayPos += 1>
      </cfif>
    </cfloop>
    <cfreturn allMajors>
  </cffunction>

</cfcomponent>