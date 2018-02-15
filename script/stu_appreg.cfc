<!--- 
		COMPONENT:		STU_APPREG_MONITOR.CFC
		
		DESCRIPTION:	This component contains methods which combine both enrollment monitor and registration report data
									to facilitate the build of a report that will combine the two.  The primary function of this component
									is to build a daily summary of this combined data and insert into the apps_to_enrolled database table
									for enhanced performance of the report generation.  Other methods within this component serve the 
									generation of the report that is built on the ORPA website.
		
		CREATE DATE:	8/8/2011
		
		AUTHOR:				John Arnold
		
		CHANGE HISTORY:
		======================================================================================================================
		

--->
		
<cfcomponent>
	
	<!--- Get all the detail records for the apps to reg report for the majors in a division. --->
  <cffunction name="ar_detail" access="public" returntype="array">
  	<cfargument name="varCohort" type="numeric" required="yes">
    <cfargument name="varSequence" type="numeric" required="no">
    <cfargument name="varDiv" type="string" required="yes">
    <cfif isdefined('varSequence')>
    	<cfset selSequence = varSequence>
    <cfelse>
      <cfquery name='maxSeq' datasource="#Application.Settings.IEIR_RO#">
        select max(sequence) as seqNo from apps_to_enrolled where cohort = #varCohort#
      </cfquery>
      <cfset selSequence = maxSeq.seqNo>
    </cfif>
    <cfset getTerm = ''>
    <cfquery name='getTerm' datasource='#Application.Settings.IEIR_RO#'>
    	select substring(term,3) as theTerm from year_terms where cohort = #varCohort#
    </cfquery>
  	<cfset arData = ArrayNew(1)>
    <cfset arDataPos = 1>
    <cfif varDiv neq 'Unassigned'>
      <cfquery name="arMajors" datasource="#Application.Settings.IEIR_RO#">
        select distinct(major) as major, sum(app_applied) as applied, sum(app_accepted) as accepted, 
        			 sum(app_eligible) as eligible, sum(em_proj_new) as pNew, sum(em_proj_ret) as pRet,
               sum(enrolled) as enrolled, sum(enrolled_new) as enrolledNew
        from apps_to_enrolled
          where cohort = #varCohort# and sequence = #selSequence#
            and major in (select major from em_program_targets where term = '#getTerm.theTerm#' and division = '#varDiv#')
          group by major
          order by major
      </cfquery>
    <cfelse>
      <cfquery name="arMajors" datasource="#Application.Settings.IEIR_RO#">
        select distinct(major) as major, sum(app_applied) as applied, sum(app_accepted) as accepted, 
        			 sum(app_eligible) as eligible, sum(em_proj_new) as pNew, sum(em_proj_ret) as pRet,
               sum(enrolled) as enrolled, sum(enrolled_new) as enrolledNew
        from apps_to_enrolled
          where cohort = #varCohort# and sequence = #selSequence#
            and major not in (select major from em_program_targets where term = '#getTerm.theTerm#')
          group by major
          order by major
      </cfquery>
		</cfif>
    <cfloop query="arMajors">
    	<cfset majorData = StructNew()>
      <cfset majorData.major = arMajors.major>
      <cfset majorData.applied = arMajors.applied>
      <cfset majorData.accepted = arMajors.accepted>
      <cfset majorData.eligible = arMajors.eligible>
      <cfset majorData.pNew = arMajors.pNew>
      <cfset majorData.pRet = arMajors.pRet>
      <cfset majorData.pRet = arMajors.pRet>
      <cfset majorData.enrolled = arMajors.enrolled>
      <cfset majorData.enrolledNew = arMajors.enrolledNew>
      <!--- Get the loc details --->
      <cfquery name="arLocMajors" datasource="#Application.Settings.IEIR_RO#">
      	select  a.loc as loc, a.app_applied as applied, a.app_accepted as accepted, a.app_eligible as eligible, 
        				a.em_proj_new as pNew, a.em_proj_ret as pRet, a.enrolled as enrolled,  a.enrolled_new as enrolledNew, b.campus as campus
          from apps_to_enrolled a, locations b
          where cohort = #varCohort# and sequence = #selSequence# and major = '#arMajors.major#'
          	and b.lc_id = a.loc
          order by campus
      </cfquery>
      <cfset locData = ArrayNew(1)>
      <cfset locDataPos = 1>
      <cfloop query="arLocMajors">
      	<cfset locMajorData = StructNew()>
        <cfset locMajorData.loc = arLocMajors.loc>
        <cfset locMajorData.campus = arLocMajors.campus>
        <cfset locMajorData.applied = arLocMajors.applied>
				<cfset locMajorData.accepted = arLocMajors.accepted>
        <cfset locMajorData.eligible = arLocMajors.eligible>
        <cfset locMajorData.pNew = arLocMajors.pNew>
        <cfset locMajorData.pRet = arLocMajors.pRet>
        <cfset locMajorData.enrolled = arLocMajors.enrolled>
        <cfset locMajorData.enrolledNew = arLocMajors.enrolledNew>
        <cfset locMajorPending = ''>
        <cfquery name='locMajorPending' datasource='#Application.Settings.IEIR_RO#'>
        	select applicant, last_name, first_name, app_status, phone
          	from em_temp_app_info
            where rpt_term = '#getTerm.theTerm#' and loc = #arLocMajors.loc# and major = '#arMajors.major#' and app_status in ('PD', 'AP')
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
            where rpt_term = '#getTerm.theTerm#' and loc = #arLocMajors.loc# and major = '#arMajors.major#' and app_status = 'EL'
            	and applicant not in (select student_id from daily_reg where term = '#getTerm.theTerm#'
              												and seq = #seqNo#)
            order by last_name, first_name
        </cfquery>
        <cfset locMajorData.newList = locMajorNew>
        <cfset locData[locDataPos] = locMajorData>
        <cfset locDataPos += 1>
      </cfloop>
      <cfset majorData.locSpec = locData>
      <cfset arData[arDataPos] = majorData>
      <cfset arDataPos += 1>
    </cfloop>
    <cfreturn arData>
  </cffunction>
  
	<!--- Return the set of report dates for the given term --->
  <cffunction name="arPeriod" access="public" returntype="array">
  	<cfargument name="arCohort" type="numeric" required="yes">
		<cfset reportQuery = ''>
    <cfset reportDates = ArrayNew(1)>
    <cfset dateCount = 1>
    <cfquery name="reportQuery" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(run_date) as runDate, sequence as repSequence from apps_to_enrolled where cohort = #arCohort# order by run_date
    </cfquery>
		<cfquery name="getTerm" datasource="#Application.Settings.IEIR_RO#">
    	select term from year_terms where cohort = #arCohort#
    </cfquery>
    <cfloop query="reportQuery">
    	<cfset dateSet = StructNew()>
      <cfset dateSet.rptDate = reportQuery.runDate>
      <cfset dateSet.sequence = reportQuery.repSequence>
      <cfset dateSet.term = getTerm.term>
    	<cfset reportDates[dateCount] = dateSet>
      <cfset dateCount += 1>
    </cfloop>
    <cfreturn reportDates>
	</cffunction>

  <!--- Populate the apps_to_enrolled table with today's summary rows. --->
	<cffunction name="buildDailySummary" access="public" returntype="numeric">

		<cfargument name="appRegCohort" type="numeric" required="yes">
    <cfargument name="appRegTerm" type="string" required="yes">
    
		<cfset dateToday = DateFormat(Now(),"yyyy-mm-dd")>
    
    <!--- Get the sequence numbers for the latest enrollment monitors and reg reports --->
    <cfset sequences=''>
    <cfquery name="sequences" datasource="#Application.Settings.IEIR_RO#">
    	select max(a.seq) as emSeq, max(b.seq) as drSeq from em_monitor a, daily_reg b
      	where a.cohort = #appRegCohort# and b.term = '#appRegTerm#'
    </cfquery>
    <cfif sequences.emSeq eq ''>
    	<cfset sequences.emSeq = 0>
    </cfif>
    <cfif sequences.drSeq eq ''>
    	<cfset sequences.drSeq = 0>
    </cfif>
    
    <!--- Set up the sequence number for the new apps_to_enrolled report summary being built. --->
    <cfset maxSeq=''>
    <cfquery name='maxSeq' datasource='#Application.Settings.IEIR_RO#'>
    	select max(sequence) as seq from apps_to_enrolled where cohort = #appRegCohort#
    </cfquery>
    <cfif maxSeq.seq eq ''>
    	<cfset appSeq = 1>
    <cfelse>
    	<cfset appSeq = maxSeq.seq + 1>
    </cfif>
    
		<!---  Get all majors and locations and create the initial rows for the tables --->
    <cfset locsMajors = ''>
    <cfquery name='locsMajors' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(active_major) as appMajor, loc from em_projections
      	where cohort = #appRegCohort#
        order by loc, appMajor
    </cfquery> 
     
<!---    <cfquery name='locsMajors' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(rpt_major) as appMajor, home_loc as loc from daily_reg
      	where term = '#appRegTerm#'
        	and seq = #sequences.drSeq#
        order by loc, appMajor
    </cfquery> --->

    <!--- Now loop through these results and create the initial table rows for the summary --->
    <cfoutput>
    <cfset thisCount=1>
    <cfloop query='locsMajors'>
      <!--- First Get the App Info from the em_temp_app_info_table --->
      <cfset appInfoAccepted=''>
      <cfquery name='appInfoAccepted' datasource='#Application.Settings.IEIR_RO#'>
      	select count(applicant) as apps from em_temp_app_info
        	where rpt_term = '#appRegTerm#'
          	and loc = #locsMajors.loc#
            and major = '#locsMajors.appMajor#'
          	and app_status in ('AC','EL')
     	</cfquery>
      <cfset appInfoEligible=''>
      <cfquery name='appInfoEligible' datasource='#Application.Settings.IEIR_RO#'>
      	select count(applicant) as apps from em_temp_app_info
        	where rpt_term = '#appRegTerm#'
          	and loc = #locsMajors.loc#
            and major = '#locsMajors.appMajor#'
          	and app_status = 'EL'
     	</cfquery>
      <cfset appInfoAppliedOrPending=''>
      <cfquery name='appInfoAppliedOrPending' datasource='#Application.Settings.IEIR_RO#'>
      	select count(applicant) as apps from em_temp_app_info
        	where rpt_term = '#appRegTerm#'
          	and loc = #locsMajors.loc#
            and major = '#locsMajors.appMajor#'
          	and app_status in ('AP','PD')
     	</cfquery>
      <cfset totalApps = ''>
      <cfquery name='totalApps' datasource='#Application.Settings.IEIR_RO#'>
      	select count(applicant) as apps from em_temp_app_info
        	where rpt_term = '#appRegTerm#'
          	and loc = #locsMajors.loc#
            and major = '#locsMajors.appMajor#'
            and app_status in ('AP','PD','AC','EL')
			</cfquery>      
    
    	<!--- Now get projected New and Returning from the Enrollment Monitor --->
      <cfset em_projections=''>
      <cfquery name='em_projections' datasource='#Application.Settings.IEIR_RO#'>
      	select proj_new as new, proj_ret as returning from em_monitor
        	where cohort = #appRegCohort#
          	and seq = #sequences.emSeq#
            and loc = #locsMajors.loc#
            and major = '#locsMajors.appMajor#'
      </cfquery>
      <!--- Handle cases for bogus majors --->
      <cfif em_projections.new eq ''>
      	<cfset projNew = 0>
      <cfelse>
      	<cfset projNew = em_projections.new>
      </cfif>
      <cfif em_projections.returning eq ''>
      	<cfset projRet = 0>
      <cfelse>
      	<cfset projRet = em_projections.returning>
      </cfif>
      <cfset projEnrolled = projNew + projRet>
      
      <!--- Get the number of students actually registered. --->
      <cfset registered=''>
      <cfquery name='registered' datasource='#Application.Settings.IEIR_RO#'>
      	select count(distinct(student_id)) as students from daily_reg
        	where term = '#appRegTerm#'
          	and seq = #sequences.drSeq#
            and rpt_major = '#locsMajors.appMajor#'
            and home_loc = #locsMajors.loc#
      </cfquery>
       
      <!--- Get the number of new students actually registered. --->
      <cfset registeredNew=''>
      <cfquery name='registeredNew' datasource='#Application.Settings.IEIR_RO#'>
      	select count(distinct(student_id)) as students from daily_reg
        	where term = '#appRegTerm#'
          	and seq = #sequences.drSeq#
            and rpt_major = '#locsMajors.appMajor#'
            and home_loc = #locsMajors.loc#
            and reg_type = 'N'
      </cfquery>
       
      <!--- Inset the summary record into the apps_to_enrolled table --->
      <cfset newSumRec=''>
      <cfquery result='newSumRec' datasource='#Application.Settings.IEIR#'>
      	insert into apps_to_enrolled
        	values(	#appRegCohort#,
          				#appSeq#,
                  '#appRegTerm#',
                  '#dateToday#',
                  #locsMajors.loc#,
                  '#locsMajors.appMajor#',
                  #appInfoAccepted.apps#,
                  #appInfoEligible.apps#,
                  #appInfoAppliedOrPending.apps#,
                  #totalApps.apps#,
                  #projRet#,
                  #projNew#,
                  #registered.students#,
                  #registeredNew.students#)
      </cfquery>
       
    </cfloop>
    </cfoutput>
    
    <cfreturn 0>    
	</cffunction>
  
	<!--- Return a query containing all terms with available app2reg reports. --->
  <cffunction name="getARTerms" access="public" returntype="query">
  	<cfset availTerms = ''>
  	<cfquery name="availTerms" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(cohort) as cohort from apps_to_enrolled order by cohort
    </cfquery>
    <cfreturn availTerms>
  </cffunction>

	<!--- Get a campus name for a location number. --->
  <cffunction name='getCampus' access='public' returntype="string">
  	<cfargument name='location' type='numeric' required="yes">
    <cfset cQ=''>
    <cfquery name="cQ" datasource="#Application.Settings.IEIR_RO#">
    	select campus from locations where lc_id = #location#
    </cfquery>
    <cfreturn cQ.campus>
  </cffunction>

  <!--- Get a cohort number from the year_terms table for a given term --->
	<cffunction name="getCohort" access="public" returntype="numeric">
  	<cfargument name="term" type="string" required="yes">
    <cfif Len(term) eq 5>
    	<cfset fullTerm = '20' & term>
    <cfelse>
    	<cfset fullTerm = term>
    </cfif>
    <cfset theQ=''>
    <cfquery name='theQ' datasource='#Application.Settings.IEIR_RO#'>
    	select cohort from year_terms where term = '#fullTerm#'
    </cfquery>
    <cfreturn theQ.cohort>
  </cffunction>
  
	<!--- Get the division level records --->
  <CFFUNCTION name="getDivisions" access="public" returntype="array">
  	<cfargument name="varCohort" type="numeric" required="yes">
    <cfargument name="varSequence" type="numeric" required="no">
    <cfif isdefined('varSequence')>
    	<cfset selSequence = varSequence>
    <cfelse>
      <cfquery name='maxSeq' datasource="#Application.Settings.IEIR_RO#">
        select max(sequence) as seqNo from apps_to_enrolled where cohort = #varCohort#
      </cfquery>
      <cfset selSequence = maxSeq.seqNo>
    </cfif>
    <cfset getTerm = ''>
    <cfquery name='getTerm' datasource='#Application.Settings.IEIR_RO#'>
    	select substring(term,3) as theTerm from year_terms where cohort = #varCohort#
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
        select sum(app_applied) as applied, sum(app_accepted) as accepted, sum(app_eligible) as eligible,
                sum(em_proj_new) as pNew, sum(em_proj_ret) as pRet, sum(enrolled) as enrolled, sum(enrolled_new) as enrolledNew
        from apps_to_enrolled 
         	where cohort = #varCohort# and sequence = #selSequence# and major in 
          	(select distinct(major) from em_program_targets where division = '#divs.division#' and term = '#getTerm.theTerm#')
      </cfquery>
			<cfset divInfo.applied = divAppData.applied>
			<cfset divInfo.accepted = divAppData.accepted>
			<cfset divInfo.eligible = divAppData.eligible>
			<cfset divInfo.pNew = divAppData.pNew>
			<cfset divInfo.pRet = divAppData.pRet>
			<cfset divInfo.enrolled = divAppData.enrolled>
      <cfset divInfo.enrolledNew = divAppData.enrolledNew>
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
      select sum(app_applied) as applied, sum(app_accepted) as accepted, sum(app_eligible) as eligible,
              sum(em_proj_new) as pNew, sum(em_proj_ret) as pRet, sum(enrolled) as enrolled, sum(enrolled_new) as enrolledNew
      from apps_to_enrolled 
        where cohort = #varCohort# and sequence = #selSequence# and major not in 
          (select distinct(major) from em_program_targets where term = '#getTerm.theTerm#')
    </cfquery>
			<cfset nonDivInfo.applied = nonDivAppData.applied>
			<cfset nonDivInfo.accepted = nonDivAppData.accepted>
			<cfset nonDivInfo.eligible = nonDivAppData.eligible>
			<cfset nonDivInfo.pNew = nonDivAppData.pNew>
			<cfset nonDivInfo.pRet = nonDivAppData.pRet>
			<cfset nonDivInfo.enrolled = nonDivAppData.enrolled>
      <cfset nonDivInfo.enrolledNew = nonDivAppData.enrolledNew>
    <cfset divData[divDataPos] = nonDivInfo>    
    <cfreturn divData>
  </cffunction> 
   
  <!--- Get the Run-date of a particular report --->
  <cffunction name='getRunDate' access='public' returntype='string'>
  	<cfargument name='appRegCohort' type='numeric' required="yes">
    <cfargument name='repSeq' type='numeric' required='yes'>
    <cfset dateQ=''>
    <cfquery name='dateQ' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(run_date) as run_date from apps_to_enrolled where cohort=#appRegCohort# and sequence=#repSeq#
  	</cfquery>
    <cfreturn DateFormat(dateQ.run_date,'mm-dd-YYYY')>
  </cffunction>
  	
  <!--- Fetch summary level information grouped by college locations. --->
  <cffunction name="summaryCombined" access="public" returntype="query">
  	<cfargument name="varCohort" type="numeric" required="yes">
    <cfargument name="varSequence" type="numeric" required="no">
		<cfset sumlines = ''>
    <cfset lineItems = StructNew()>
    <cfif isdefined('varSequence')>
    	<cfset selSequence = varSequence>
    <cfelse>
      <cfquery name='maxSeq' datasource="#Application.Settings.IEIR_RO#">
        select max(sequence) as seqNo from apps_to_enrolled where cohort = #varCohort#
      </cfquery>
      <cfset selSequence = maxSeq.seqNo>
    </cfif>
    <cfquery name="sumlines" datasource="#Application.Settings.IEIR_RO#">
    	select sum(app_applied) as applied, sum(app_accepted) as accepted, sum(app_eligible) as eligible, 
      			 sum(em_proj_new) as pNew, sum(em_proj_ret) as pRet, sum(enrolled) as enrolled, sum(enrolled_new) as enrolledNew, loc
        from apps_to_enrolled
      	where cohort = #varCohort# and sequence = #selSequence#
        group by loc
    </cfquery>    
		<cfreturn sumlines>
	</cffunction>
  
</cfcomponent>