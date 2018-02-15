<!--- This Component contains the functions used to produce the online registration report. --->
<!--- Author:  John Arnold
			Created: 02/06/09
			Modified:  
			
			Public Functions:
				
				regSummary			- Pulls summary registration data for the current semester and day
						arguments:	regTerm		<String>	required		term for the requested summary
						
						returns:		regSum		<Struct>							contains the summary registration data
				
				regDetail				- Pulls detailed registration data for display on the reg page
						arguments:	regSequence		<numeric>	required	the sequence id of the requested reg report
												regTerm				<string>	required	the Term of the requested reg report
						returns:		regData		<array>
			
--->

<cfcomponent>
	
	<!--- Return a query containing all terms with available reg reports. --->
  <cffunction name="getAvailableTerms" access="public" returntype="query">
  	<cfset availTerms = ''>
  	<cfquery name="availTerms" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(term) from daily_reg order by term
    </cfquery>
    <cfreturn availTerms>
  </cffunction>
  
	<!--- Return a query containing all terms with available retention reports. --->
  <cffunction name="getAvailableRetTerms" access="public" returntype="query">
  	<cfset availTerms = ''>
  	<cfquery name="availTerms" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(term) from ret_stats order by term
    </cfquery>
    <cfreturn availTerms>
  </cffunction>
  
	<!--- Return a query containing all terms with available em reports. --->
  <cffunction name="getEMTerms" access="public" returntype="query">
  	<cfset availTerms = ''>
  	<cfquery name="availTerms" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(cohort) as cohort from em_monitor order by cohort
    </cfquery>
    <cfreturn availTerms>
  </cffunction>

	<!--- Return an array containing all the report descriptions. --->
  <cffunction name="getReportTitles" access="public" returntype="array">
  	<cfset reportTitlesQ = ''>
    <cfset reportTitles = ArrayNew(1)>
    <cfset rtNdx = 1>
    <cfquery name="rptTitlesQ" datasource="#Application.Settings.IEIR_RO#">
    	select seq, reg_desc from daily_reg_key order by seq
    </cfquery>
    <cfloop query="rptTitlesQ">
    	<cfset reportTitles[rtNdx] = rptTitlesQ.reg_desc>
      <cfset rtNdx += 1>
    </cfloop>
    <cfreturn reportTitles>
  </cffunction>
	
  <!--- Pull Registration Retention Statistics by major and location and return them in an array. --->
  <cffunction name="getRetStats" access="public" returntype="Array">
  	<cfargument name="varTerm" type="String" required="no">
    <cfargument name="varSequence" type="numeric" required="no">
    <cfif isdefined('varTerm')>
    	<cfset selTerm = varTerm>
    <cfelse>
    	<cfset selTerm = #Application.Settings.RetTerm#>
    </cfif>
    <cfif isdefined('varSequence')>
    	<cfset selSequence = varSequence>
    <cfelse>
      <cfquery name='maxSeq' datasource="#Application.Settings.IEIR_RO#">
        select max(seq) as seqNo from ret_stats where term = '#selTerm#'
      </cfquery>
      <cfif maxSeq.seqNo eq ''>
      	<cfset selSequence = 0>
      <cfelse>
      	<cfset selSequence = maxSeq.seqNo>
      </cfif>
    </cfif>
		<cfset retStats = ArrayNew(1)>
    <cfset retStatsPos = 1>
    <cfquery name="retStatMajors" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(major) as major, sum(prev_reg) as prev_reg, sum(grads) as grads, sum(wds) as wds, sum(readmits) as readmits, 
      			 sum(returners) as returners, sum(ret_in_prev) as ret_in_prev
        from ret_stats where term = '#selTerm#' and seq = #selSequence#
        group by major
    </cfquery>
    <cfloop query="retStatMajors">
    	<cfset majorData = StructNew()>
      <cfset majorData.major = retStatMajors.major>
      <cfset majorData.prev = retStatMajors.prev_reg>
      <cfset majorData.grads = retStatMajors.grads>
      <cfset majorData.wds = retStatMajors.wds>
      <cfset majorData.readmits = retStatMajors.readmits>
      <cfset majorData.returners = retStatMajors.returners>
      <cfset majorData.ret_in_prev = retStatMajors.ret_in_prev>
      <!--- Get the loc details --->
      <cfquery name="retStatLocMajors" datasource="#Application.Settings.IEIR_RO#">
    		select a.loc as loc , a.prev_reg as prev_reg, a.grads as grads, a.wds as wds, a.readmits as readmits, 
      			 a.returners as returners, a.ret_in_prev as ret_in_prev, b.campus as campus
        	from ret_stats a, locations b
         	where term = '#selTerm#' and seq = #selSequence# and major = '#retStatMajors.major#'
          	and b.lc_id = a.loc
          order by campus
      </cfquery>
      <cfset locData = ArrayNew(1)>
      <cfset locDataPos = 1>
      <cfloop query="retStatLocMajors">
      	<cfset locMajorData = StructNew()>
        <cfset locMajorData.loc = retStatLocMajors.loc>
        <cfset locMajorData.campus = retStatLocMajors.campus>
				<cfset locMajorData.prev = retStatLocMajors.prev_reg>
        <cfset locMajorData.grads = retStatLocMajors.grads>
        <cfset locMajorData.wds = retStatLocMajors.wds>
        <cfset locMajorData.readmits = retStatLocMajors.readmits>
        <cfset locMajorData.returners = retStatLocMajors.returners>
        <cfset locMajorData.ret_in_prev = retStatLocMajors.ret_in_prev>
        <cfquery name="getOutstanding" datasource="#Application.Settings.IEIR_RO#">
        	select student as student_id, lname, fname from reg_outs
          	where term = '#selTerm#' and seq = #selSequence# and loc = #retStatLocMajors.loc# and major = '#majorData.major#'
            order by lname, fname
        </cfquery>
        <cfset students = ArrayNew(1)>
        <cfset studentsPos = 1>
        <cfloop query="getOutstanding">
        	<cfset student = StructNew()>
          <cfset student.id = getOutstanding.student_id>
          <cfset student.lname = getOutstanding.lname>
          <cfset student.fname = getOutstanding.fname>
					<cfset students[studentsPos] = student>
          <cfset studentsPos += 1>
        </cfloop>
        <cfset locMajorData.chasem = students>
        <cfset locData[locDataPos] = locMajorData>
        <cfset locDataPos += 1>
      </cfloop>
      <cfset majorData.locSpec = locData>
      <cfset retStats[retStatsPos] = majorData>
      <cfset retStatsPos += 1>
    </cfloop>
		<cfreturn retStats>
  </cffunction> <!--- end function getRetStats() --->
  
	<!--- Get a list of students for reg reporting purposes. --->
	<cffunction name="getStudentList" access="public" returnType="query">
  	<cfargument name="major" type="string" required="yes">
    <cfargument name="location" type="numeric" required="yes">
    <cfquery name="getSeq" datasource="#Application.Settings.IEIR_RO#">
    	select max(seq) as seq from ret_stats where term = '#Application.Settings.RetTerm#'
    </cfquery>
    <cfquery name="getOutstanding" datasource="#Application.Settings.IEIR_RO#">
    	select student as student_id, lname, fname from reg_outs
       	where term = '#Application.Settings.RetTerm#' and seq = #getSeq.seq# and loc = #location# and major = '#major#'
        order by lname, fname
    </cfquery>
		<cfreturn getOutstanding>
  </cffunction>
      
	<!--- Return the reg report detail data for the most current report for the default (current) term. --->
	<cffunction name="regDetail" access="public" returntype="array">
  	<cfargument name='regSequence' type='numeric' required='yes'>
    <cfargument name='regTerm' type='string' required='yes'>
    <!--- Get the list of programs --->
  	<cfquery name='getPrograms' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(rpt_major) as program, count(student_id) as totalCount from daily_reg 
      	where term = '#regTerm#' and seq = #regSequence#
        group by program
        order by program
    </cfquery>
    <cfset regData = ArrayNew(1)>
    <cfset arrayPos = 1>
    <!--- Loop thru the programs to get the reg details. --->
    <cfif getPrograms.RecordCount>
    	<!--- get new, returning, and totals for each program.  Also get the by location figures. --->
      <cfset totalNew = 0>
      <cfset totalRet = 0>
      <cfset sumTotal = 0>
      <cfloop query='getPrograms'>
      	<cfquery name='getNew' datasource='#Application.Settings.IEIR_RO#'>
        	select count(*) as newCount from daily_reg
          	where rpt_major = '#getPrograms.program#'
            	and seq = #regSequence# and term = '#regTerm#'
              and reg_type = 'N'
        </cfquery>
        <cfset progData = StructNew()>
        <cfset progData.program = getPrograms.program>
        <cfset progData.new = getNew.newCount>
        <cfset progData.ret = (getPrograms.totalCount - getNew.newCount)>
        <cfset progData.total = getPrograms.totalCount>
        <!--- Get location specifics --->
        <cfquery name='getLocDetail' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(a.home_loc) as location, b.campus_name as campus from daily_reg a, remote_campus b
          	where term = '#regTerm#'
            	and seq = #regSequence#
              and rpt_major = '#progData.program#'
              and a.home_loc = b.campus_code
            order by campus
        </cfquery>
        <cfset locData = ArrayNew(1)>
        <cfset locDataPos = 1>
        <cfloop query='getLocDetail'>
        	<cfset locStruct = StructNew()>
          <!--- Get prog/loc total --->
          <cfquery name='locTotal' datasource='#Application.Settings.IEIR_RO#'>
          	select count(*) as total from daily_reg
            	where term = '#regTerm#'
              	and seq = #regSequence#
                and rpt_major = '#progData.program#'
                and home_loc = #getLocDetail.location#
          </cfquery>
          <!--- Get prog/loc new --->
          <cfquery name='locNew' datasource='#Application.Settings.IEIR_RO#'>
          	select count(*) as new from daily_reg
            	where term = '#regTerm#'
              	and seq = #regSequence#
                and rpt_major = '#progData.program#'
                and home_loc = #getLocDetail.location#
                and reg_type = 'N'
          </cfquery>
          <cfset locStruct.location = getLocDetail.campus>
          <cfset locStruct.new = locNew.new>
          <cfset locStruct.ret = (locTotal.total - locNew.new)>
          <cfset locStruct.total = locTotal.total>
          <cfset locData[locDataPos] = locStruct>
          <cfset locDataPos += 1>
        </cfloop>
        <cfset progData.locSpec = locData>
        <cfset regData[arrayPos] = progData>
        <cfset totalNew += progData.new>
        <cfset totalRet += progData.ret>
        <cfset sumTotal += progData.total>
        <cfset arrayPos += 1>
      </cfloop> <!--- End programData Loop --->
      <cfset totalData = StructNew()>
      <cfset totalData.program = 'Totals'>
      <cfset totalData.new = totalNew>
      <cfset totalData.ret = totalRet>
      <cfset totalData.total = sumTotal>
      <cfset regData[arrayPos] = totalData>
    </cfif>
    <cfreturn regData>
  </cffunction>

	<!--- Return the set of report dates for the given term --->
  <cffunction name="regPeriod" access="public" returntype="array">
  	<cfargument name="regTerm" type="string" required="yes">
		<cfset reportQuery = ''>
    <cfset reportDates = ArrayNew(1)>
    <cfset dateCount = 1>
    <cfquery name="reportQuery" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(rpt_date) as rptDate, seq as regSequence, term as regTerm from daily_reg where term = '#regTerm#' order by rpt_date
    </cfquery>
    <cfloop query="reportQuery">
    	<cfset dateSet = StructNew()>
      <cfset dateSet.rptDate = reportQuery.rptDate>
      <cfset dateSet.sequence = reportQuery.regSequence>
      <cfset dateSet.term = reportQuery.regTerm>
    	<cfset reportDates[dateCount] = dateSet>
      <cfset dateCount += 1>
    </cfloop>
    <cfreturn reportDates>
	</cffunction>
  
	<!--- Return the reg report summary data for the most current report for the default (current) term --->
	<cffunction name="regSummary" access="public" returntype="struct">
		<cfargument name="regTerm" type="string" required="yes">
    <cfargument name="regSeq" type="numeric" required="no">
		<cfset regSum = StructNew()>
    <cfif isdefined("regSeq")>
    	<cfset regSequence = regSeq>
    <cfelse>
    	<cfquery name='getSeq' datasource='#Application.Settings.IEIR_RO#'>
    		select max(seq) as regSequence from daily_reg where term = '#regTerm#'
    	</cfquery>
      <cfset regSequence = getSeq.regSequence>
    </cfif>
    <cfquery name='getRptDate' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(rpt_date) as rptDate from daily_reg where seq = #regSequence# and term = '#regTerm#'
    </cfquery>
    <cfquery name='getTitle' datasource='#Application.Settings.IEIR_RO#'>
    	select reg_desc from daily_reg_key where seq = #regSequence#
    </cfquery>
    <cfset regSum.title = getTitle.reg_desc>
    <cfset regSum.rptDate = getRptDate.rptDate>
    <cfquery name='getNew' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as new from daily_reg where seq = #regSequence# and term = '#regTerm#' and reg_type = 'N'
    </cfquery>
    <cfset regSum.new = getNew.new>
    <cfquery name='getRet' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as ret from daily_reg where seq = #regSequence# and term = '#regTerm#' and reg_type = 'R'
    </cfquery>
    <cfset regSum.ret = getRet.ret>
    <cfset regSum.total = regSum.new + regSum.ret>
    <!--- Get the prev year's total --->
    <cfset fullterm = '20' & regTerm>
    <cfquery name='getCohort' datasource='#Application.Settings.IEIR_RO#'>
    	select cohort from year_terms where term = '#fullterm#'
    </cfquery>
    <cfquery name='lastYear' datasource='#Application.Settings.IEIR_RO#'>
    	select substring(term,3,5) as lastTerm from year_terms where cohort = #getCohort.cohort# - 3
    </cfquery>
    <cfset regSum.compTerm = lastYear.lastTerm>
    <!--- Get last year total --->
    <cfquery name='lastYearTot' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as comp from daily_reg where term = '#lastYear.lastTerm#' and seq = #regSequence#
    </cfquery>
    <cfif lastYearTot.comp eq 0>
    	<cfquery name='lastYearMaxSeq' datasource='#Application.Settings.IEIR_RO#'>
      	select max(seq) as seq from daily_reg where term = '#lastYear.lastTerm#'
      </cfquery>
      <cfif lastYearMaxSeq.seq eq ''>
      	<cfset regSum.comp = 0>
      <cfelse>
      	<cfquery name='lastYearLastRpt' datasource='#Application.Settings.IEIR_RO#'>
      		select count(*) as comp from daily_reg where term = '#lastYear.lastTerm#' and seq = #lastYearMaxSeq.seq#
      	</cfquery>
      	<cfset regSum.comp = lastYearLastRpt.comp>
      </cfif>
    <cfelse>
    	<cfset regSum.comp = lastYearTot.comp>
    </cfif>
    <cfset regSum.seq = #regSequence#>
    <cfquery name='getLocDetail' datasource='#Application.Settings.IEIR_RO#'>
      select distinct(a.home_loc) as location, count(a.student_id) as total, b.campus_name as campus from daily_reg a, remote_campus b
        where term = '#regTerm#'
          and seq = #regSequence#
          and a.home_loc = b.campus_code
        group by location
        order by campus
    </cfquery>
    <cfset locData = ArrayNew(1)>
    <cfset locDataPos = 1>
    <cfloop query='getLocDetail'>
      <cfset locTotals = StructNew()>
      <!--- Get prog/loc new --->
      <cfquery name='locNew' datasource='#Application.Settings.IEIR_RO#'>
        select count(*) as new from daily_reg
          where term = '#regTerm#'
            and seq = #regSequence#
            and home_loc = #getLocDetail.location#
            and reg_type = 'N'
      </cfquery>
      <cfset locTotals.location = getLocDetail.campus>
      <cfset locTotals.new = locNew.new>
      <cfset locTotals.ret = (getLocDetail.total - locNew.new)>
      <cfset locTotals.total = getLocDetail.total>
      <cfset locData[locDataPos] = locTotals>
      <cfset locDataPos += 1>
    </cfloop>
    <cfset regSum.locTotals = locData>

		<cfreturn regSum>
    
	</cffunction> <!--- End regSummary --->
  
  <!--- Calculate the latest current student upcoming term registration figures. --->
  <cffunction name='runRetRegProgFigs' access='public'>

  	<!--- Get the sequence number of the latest reg report for the current term. --->
 		<cfquery name='getPrevMax' datasource='#Application.Settings.IEIR_RO#'>
    	select max(seq) as lastRun from daily_reg where term = '#Application.Settings.RetPrevTerm#'
		</cfquery>
		
		<!--- Get the the number of students registered, applied for graduation, and withdrawn for the
					CURRENT TERM. --->
    <cfquery name='getCurrentFigs' datasource='#Application.Settings.IEIR_RO#'>
  		select 
				rpt_major as major, 
				home_loc as home_loc, 
				count(student_id) as current_reg, 
				0 as grads, 
				0 as wds,
				count(student_id) as should_return
			from daily_reg
			where 
				seq = #getPrevMax.lastRun#
				and term = '#Application.Settings.RetPrevTerm#'
			group by rpt_major, home_loc
			order by rpt_major, home_loc
    </cfquery>
    
		<cfset retLines = ArrayNew(1)>
		<cfset arrayCount = 0>
    
    <!--- Get the latest sequence number of the registration report for the UPCOMING TERM. --->
		<cfquery name='getRegSeq' datasource='#Application.Settings.IEIR_RO#'>
			select max(seq) as sequence from daily_reg where term = '#Application.Settings.RetTerm#'
		</cfquery>
		<!--- If the sequence has come back as nil (''), the reg report for the UPCOMING TERM has not yet
					started to run, so set a var = 0 for use later. Otherwise, set it the latest sequence. --->
		<cfset retTermSeqMax = 0>
		<cfif getRegSeq.sequence neq ''>
    	<cfset retTermSeqMax = getRegSeq.sequence>
    </cfif>

		
    <!--- Set up the current registration figures by program, by location. --->
    <cfloop query='getCurrentFigs'>
    	<cfset retStruct = StructNew()>
    	<cfset retStruct.major = getCurrentFigs.major>
      <cfset retStruct.loc = getCurrentFigs.home_loc>
      <cfset retStruct.term = Application.Settings.RetTerm>
      <cfset retStruct.seq = retTermSeqMax>
      <!--- Number of students registered as of the last reg report in the program at the location during the
						CURRENT TERM. --->
      <cfset retStruct.prev_reg = getCurrentFigs.current_reg>
      
      <!--- Number of students in the CURRENT TERM who have applied to graduate at the end of the CURRENT TERM. --->
			<cfquery name='getGradsHere' datasource='#Application.Settings.IEIR_RO#'>
      	select count(distinct(student_id)) as theReal from daily_reg
        	where term = '#Application.Settings.RetPrevTerm#'
          	and seq = #getPrevMax.lastRun#
            and rpt_major = '#getCurrentFigs.major#'
            and home_loc = #getCurrentFigs.home_loc#
            and student_id in
            	(select substr(atid,1,7) from em_temp_grad_info)
      </cfquery>
			<cfset retStruct.grads = getGradsHere.theReal>


      <!--- Number of students who were registered on the 19th class day in the CURRENT TERM who have withdrawn from the school. --->
			<cfquery name='getWDsHere' datasource='#Application.Settings.IEIR_RO#'>
      	select count(distinct(student_id)) as theReal from daily_reg
        	where term = '#Application.Settings.RetPrevTerm#'
          	and seq = #getPrevMax.lastRun#
            and rpt_major = '#getCurrentFigs.major#'
            and home_loc = #getCurrentFigs.home_loc#
            and student_id in
            	(select substr(atid,1,7) from em_temp_wd_info)
      </cfquery>
      <cfset retStruct.wds = getWDsHere.theReal>
      
      <!--- Get the number of re-admitted students known to-date so they're not confused with current returners
						in case they actually register. --->
      <cfquery name='getReadmits' datasource='#Application.Settings.IEIR_RO#'>
      	select readmits from em_corrections
        	where cohort = #Application.Settings.RetTermCohort#
          	and loc = #getCurrentFigs.home_loc#
            and major = '#getCurrentFigs.major#'
      </cfquery>
      
			<cfset retStruct.readmits = getReadmits.readmits>
      
      <!--- Count the total number of returning students (including previous students) who are registered
						for the UPCOMING TERM. --->
      <cfquery name='getAllReturners' datasource='#Application.Settings.IEIR_RO#'>
      	select count(student_id) as allReturners 
        	from daily_reg
        	where term = '#Application.Settings.RetTerm#'
          	and seq = #retTermSeqMax#
            and home_loc = #getCurrentFigs.home_loc#
            and rpt_major = '#getCurrentFigs.major#'
            and reg_type = 'R'
      </cfquery>
      
      <!--- This is the number reported under the TOTAL RETURNERS column in the report. --->
			<cfset retStruct.returners = getAllReturners.allReturners>
      
			<!--- Get the number of students registered in the CURRENT TERM who have also registered
						for the UPCOMING TERM. --->
      <cfquery name='getCalcReturners' datasource='#Application.Settings.IEIR_RO#'>
      	select count(student_id) as calcReturners 
        	from daily_reg
        	where term = '#Application.Settings.RetTerm#'
          	and seq = #retTermSeqMax#
            and home_loc = #getCurrentFigs.home_loc#
            and rpt_major = '#getCurrentFigs.major#'
            and reg_type = 'R'
            and student_id in
      				(select student_id from daily_reg
        				where term = '#Application.Settings.RetPrevTerm#'
          				and seq = #getPrevMax.lastRun#
            			and home_loc = #getCurrentFigs.home_loc#
            			and rpt_major = '#getCurrentFigs.major#')
      </cfquery>
      
      <!--- This is the figure reported under the CURRENT RETURNERS column in the report. --->
      <cfset retStruct.ret_in_prev = getCalcReturners.calcReturners>
      
      <cfset arrayCount += 1>
      <cfset retLines[arrayCount] = retStruct>
      
    </cfloop> <!--- End Loop getCurrentFigs. --->
    
    <cfset dateToday = DateFormat(Now(),"yyyy/mm/dd")>
    
		<!---  Before we do the inserts, check to see if retTermSeqMax = 0.  If it does, this means that the daily reg report
          has not yet started running and there may already be entries for this sequence.  In that case, delete these
          records before inserting new ones for this retention term and the seqence. --->
    <cfif retTermSeqMax eq 0>
      <cfquery result="del0Recs" datasource='#Application.Settings.IEIR#'>
        delete from ret_stats where term = '#Application.Settings.RetTerm#' and seq = 0
      </cfquery>
      <cfquery result='delOutstanding' datasource='#Application.Settings.IEIR#'>
      	delete from reg_outs where term = '#Application.Settings.RetTerm#' and seq = 0
      </cfquery>
    </cfif>
      
    <!--- Insert the new values into the ret_stats table. --->
    <cfloop index="ndx" from="1" to="#ArrayLen(retLines)#" step="1">
    
    	<cfquery name="insertRetLine" datasource='#Application.Settings.IEIR#'>
      	insert into ret_stats
        	values('#retLines[ndx].major#',
          			 #retLines[ndx].loc#,
                 '#retLines[ndx].term#',
                 #retLines[ndx].seq#,
                 #retLines[ndx].prev_reg#,
          			 #retLines[ndx].grads#, 
                 #retLines[ndx].wds#,
                 #retLines[ndx].readmits#,
                 #retLines[ndx].returners#,
                 #retLines[ndx].ret_in_prev#,
                 '#dateToday#')
      </cfquery>
      
      <cfquery name="outstandingReg" datasource='#Application.Settings.IEIR_RO#'>
				select student_id, lname, fname 
        	from daily_reg
					where term = '#Application.Settings.RetPrevTerm#'
						and seq = #getPrevMax.lastRun#
						and home_loc = #retLines[ndx].loc#
						and rpt_major = '#retLines[ndx].major#'
						and student_id not in <!--- Student hasn't withdrawn during the current term --->
							(select substr(atid,1,7) from em_temp_wd_info
								where term = '#Application.Settings.RetPrevTerm#'
									and loc = #retLines[ndx].loc#)
            and student_id not in <!--- Student isn't graduating in the current term --->
            	(select substr(atid,1,7) from em_temp_grad_info
              	where term = '#Application.Settings.RetPrevTerm#'
                	and loc = #retLines[ndx].loc#)
						and student_id not in <!--- Student hasn't already registered for UPCOMING term. --->
							(select student_id from daily_reg
								where term = '#Application.Settings.RetTerm#'
								and seq = #retTermSeqMax#
								and home_loc = #retLines[ndx].loc#
								and rpt_major = '#retLines[ndx].major#');
      </cfquery>
      
      <cfloop query="outstandingReg">
      	<cfquery name="insertOutstanding" datasource="#Application.Settings.IEIR#">
        	insert into reg_outs
          	values('#Application.Settings.RetTerm#',
                   #retTermSeqMax#,
                   #retLines[ndx].loc#,
                   '#retLines[ndx].major#',
            			 #outstandingReg.student_id#,
                   '#outstandingReg.lname#',
                   '#outstandingReg.fname#')
        </cfquery>
      </cfloop>	
    </cfloop>
  </cffunction> <!--- end function runRetFigs() --->
  
  <cffunction name="ret_summary" access="public" returntype="query">
  	<cfargument name="varTerm" type="String" required="no">
    <cfargument name="varSequence" type="numeric" required="no">
		<cfset ret_lines = ''>
    <cfset lineItems = StructNew()>
    <cfif isdefined('varTerm')>
    	<cfset selTerm = varTerm>
    <cfelse>
    	<cfset selTerm = #Application.Settings.RegTerm#>
    </cfif>
    <cfif isdefined('varSequence')>
    	<cfset selSequence = varSequence>
    <cfelse>
      <cfquery name='maxSeq' datasource="#Application.Settings.IEIR_RO#">
        select max(seq) as seqNo from ret_stats where term = '#selTerm#'
      </cfquery>
      <cfif maxSeq.seqNo eq ''>
      	<cfset selSequence = 0>
      <cfelse>
      	<cfset selSequence = maxSeq.seqNo>
      </cfif>
    </cfif>
    <cfquery name="ret_lines" datasource="#Application.Settings.IEIR_RO#">
    	select sum(prev_reg) as prev_reg, 
      			 sum(grads) as grads, 
             sum(wds) as wds, 
             sum(readmits) as readmits, 
             sum(returners) as returners, 
             sum(ret_in_prev) as ret_in_prev, 
             loc from ret_stats
      	where term = '#selTerm#' and seq = #selSequence#
        group by loc
    </cfquery>
    
		<cfreturn ret_lines>
  </cffunction>

	<!--- Return the set of report dates for the given term --->
  <cffunction name="retStatPeriod" access="public" returntype="array">
  	<cfargument name="retStatTerm" type="string" required="yes">
		<cfset reportQuery = ''>
    <cfset reportDates = ArrayNew(1)>
    <cfset dateCount = 1>
    <cfquery name="reportQuery" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(run_date) as runDate, seq as regSequence from ret_stats where term = '#retStatTerm#' order by run_date
    </cfquery>
    <cfloop query="reportQuery">
    	<cfset dateSet = StructNew()>
      <cfset dateSet.rptDate = reportQuery.runDate>
      <cfset dateSet.sequence = reportQuery.regSequence>
      <cfset dateSet.term = retStatTerm>
    	<cfset reportDates[dateCount] = dateSet>
      <cfset dateCount += 1>
    </cfloop>
    <cfreturn reportDates>
	</cffunction>

	<!--- Get Smart Start Registrations to add to it's own section in the reg report. --->
  <cffunction name='getSmartStart' access="public" returnType="array">
  	<cfargument name="regTerm" type="string" required="yes">
    <!--- start by getting the locations and classes taught for smart start during the given term. --->
    <cfset ssLocs=''>
    <cfquery name='ssLocs' datasource='#Application.Settings.IEIR_RO#'>
    	select a.loc as locNumber, a.course as courseName, b.campus as campus from smart_start a, locations b
      	where a.term = '#regTerm#'
        	and a.loc = b.lc_id
        order by b.campus
    </cfquery>
    <cfset smartStarters = ArrayNew(1)>
    <cfset ssPos = 1>
    <cfloop query='ssLocs'>
    	<cfset ssEnrollments = StructNew()>
      <cfset regs=''>
      <cfquery name='regs' datasource='#Application.Settings.IEIR_RO#'>
      	select count(distinct(stc_person_id)) as enrolled from stu_course_sections
        	where scs_reporting_term = '#regTerm#'
          	and scs_location = #ssLocs.locNumber#
            and stc_course_name = '#ssLocs.courseName#'
      </cfquery>
      <cfset ssEnrollments.campus = ssLocs.campus>
      <cfset ssEnrollments.enrolled = regs.enrolled>
      <cfset smartStarters[ssPos] = ssEnrollments>
      <cfset ssPos += 1>
    </cfloop>
    <cfreturn smartStarters>
  </cffunction> <!--- End getSmartStart() --->
      
</cfcomponent>