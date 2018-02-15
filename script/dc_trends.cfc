<cfcomponent>

	<cffunction name="buildDCConverts" access="public" returntype="query">
		<!--- clear any existing information out of the DC Summary Table --->
		<cfset clearSum = ''>
    <cfquery result='clearSum' datasource='#Application.Settings.IEIR#'>
    	delete from dc_start_sum_info
    </cfquery>
		<!--- clear any existing information out of converted_dc_student Table --->
		<cfset clearDCConverts = ''>
    <cfquery result='clearDCConverts' datasource='#Application.Settings.IEIR#'>
    	delete from converted_dc_student
    </cfquery>
    <!--- rePop the table with the latest info --->
    <cfset popSum = ''>
    <cfquery result='popSum' datasource='#Application.Settings.IEIR#'>
    	insert into dc_start_sum_info
      	(select count(distinct(id_no)), start_term_full, active_prog from student_terms
        	where active_prog like '%.DC%'
          group by start_term_full, active_prog)
     	</cfquery>
      <!--- select all the summary information into a query to loop thru --->
     	<cfset sumQ = ''>
     	<cfquery name='sumQ' datasource='#Application.Settings.IEIR_RO#'>
     		select dc_count, start_term, active_prog from dc_start_sum_info order by start_term, active_prog
     	</cfquery>
     	<cfloop query='sumQ'>
     		<!--- Get the list of ids for the start_term and the active_program --->
				<cfset idQ=''>
        <cfquery name='idQ' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(id_no) as student from student_terms
          	where start_term_full = '#sumQ.start_term#'
            	and active_prog = '#sumQ.active_prog#'
        </cfquery>
        <!--- loop thru the ids --->
        <cfloop query='idQ'>
        	<!--- clear anything already in the dc_student_history table --->
          <cfset clearHistory=''>
          <cfquery result='clearHistory' datasource='#Application.Settings.IEIR#'>
          	delete from dc_student_history
          </cfquery>
          <!--- Add all term recs for the student to the history table --->
          <cfset popHistory=''>
          <cfquery result='popHistory' datasource='#Application.Settings.IEIR#'>
          	insert into dc_student_history
            	(select #idQ.student#, rpt_term_full, null, active_prog, active_major, piems_id_no, county, county_name
               from student_terms where id_no = #idQ.student# order by sem_sort)
          </cfquery>
          <cfset updateCohorts=''>
          <cfquery result='updateCohorts' datasource='#Application.Settings.IEIR#'>
          	update dc_student_history
            	set cohort = (select cohort from year_terms where term = rpt_term)
          </cfquery>
          <!--- ADDITIONAL PROCESSING HERE TO ID CONVERTED STUDENTS AND INSERT TO A NEW TABLE --->
          <!--- Get the max(cohort) for DC activity --->
          <cfset lastDCTerm=''>
          <cfquery name='lastDCTerm' datasource='#Application.Settings.IEIR_RO#'>
          	select max(cohort) as cohort from dc_student_history where active_prog like '%.DC%'
          </cfquery>
          <cfif lastDCTerm.cohort eq ''>
          	<cfdump var='#idQ.student#'><cfdump var='#sumQ.start_term#'><cfdump var='#sumQ.active_prog#'><cfflush>
          </cfif>
          <!--- Get the min(cohort) AFTER the last DC Activity --->
          <cfset firstNonDCTerm=''>
          <cfquery name='firstNonDCTerm' datasource='#Application.Settings.IEIR_RO#'>
          	select min(cohort) as cohort from dc_student_history where cohort > #lastDCTerm.cohort#
          </cfquery>
          <!--- if a result came back for activity at the college AFTER the last DC term, create a record
					      and insert the results to the converted_dc_student table. --->
          <cfif firstNonDCTerm.cohort neq ''>
          	<!--- Get the first and last name of the student at their first term --->
            <cfset namesQ=''>
            <cfquery name='namesQ' datasource='#Application.Settings.IEIR_RO#'>
            	select first_name, last_name, rem_camp_name from student_terms
              	where id_no = #idQ.student# and start_term_full = '#sumQ.start_term#'
            </cfquery>
            <cfset firstNonDCCampus=''>
            <cfquery name='firstNonDCCampus' datasource='#Application.Settings.IEIR_RO#'>
            	select rem_camp_name from student_terms
              	where id_no = #idQ.student# and rpt_term_full = (select term from year_terms where cohort = #firstNonDCTerm.cohort#)
            </cfquery>
            <!--- Get the high school code and county info for the students last dc term --->
            <cfset lastDCTermInfo=''>
            <cfquery name='lastDCTermInfo' datasource='#Application.Settings.IEIR_RO#'>
            	select active_prog, active_major, high_school_code, county, county_name from dc_student_history where cohort = #lastDCTerm.cohort#
            </cfquery>
            <!--- get the term, program, and major from the dc_hist_table for the first non-dc-term --->
            <cfset firstNonDCTermInfo=''>
            <cfquery name='firstNonDCTermInfo' datasource='#Application.Settings.IEIR_RO#'>
            	select rpt_term, active_prog, active_major from dc_student_history where cohort = #firstNonDCTerm.cohort#
            </cfquery>
            <!--- insert an entry into dc_converted_student --->
            <cfset insertConvert=''>
            <cfquery result='insertConvert' datasource='#Application.Settings.IEIR#'>
            	insert into converted_dc_student values
              	(#idQ.student#,'#namesQ.first_name#','#namesQ.last_name#',
                	null,
                 #lastDCTermInfo.county#,'#lastDCTermInfo.county_name#','#sumQ.start_term#','#namesQ.rem_camp_name#','#lastDCTermInfo.active_prog#',
                 '#lastDCTermInfo.active_major#','#firstNonDCTermInfo.rpt_term#','#firstNonDCCampus.rem_camp_name#','#firstNonDCTermInfo.active_prog#',
                 '#firstNonDCTermInfo.active_major#')
            </cfquery>
          <cfelse>
            <cfset namesQ=''>
            <cfquery name='namesQ' datasource='#Application.Settings.IEIR_RO#'>
            	select first_name, last_name, rem_camp_name from student_terms
              	where id_no = #idQ.student# and start_term_full = '#sumQ.start_term#'
            </cfquery>
            <!--- Get the high school code and county info for the students last dc term --->
            <cfset lastDCTermInfo=''>
            <cfquery name='lastDCTermInfo' datasource='#Application.Settings.IEIR_RO#'>
            	select active_prog, active_major, high_school_code, county, county_name from dc_student_history where cohort = #lastDCTerm.cohort#
            </cfquery>
            <!--- insert an entry into dc_converted_student --->
            <cfset insertConvert=''>
            <cfquery result='insertConvert' datasource='#Application.Settings.IEIR#'>
            	insert into converted_dc_student values
              	(#idQ.student#,'#namesQ.first_name#','#namesQ.last_name#',
                	null,
                 #lastDCTermInfo.county#,'#lastDCTermInfo.county_name#','#sumQ.start_term#','#namesQ.rem_camp_name#','#lastDCTermInfo.active_prog#',
                 '#lastDCTermInfo.active_major#',null,null,null,null)
            </cfquery>
          </cfif>	
        </cfloop> <!--- End the ID Loop --->
      </cfloop> <!--- End the summary info loop --->
      <cfquery result='updateDCHome' datasource='#Application.Settings.IEIR#'>
      	update converted_dc_student set dc_home_loc = 'Sweetwater' where dc_home_loc = ''
      </cfquery>
      <cfquery result='updateRegHome' datasource='#Application.Settings.IEIR#'>
      	update converted_dc_student set reg_home_loc = 'Sweetwater' where reg_home_loc = ''
      </cfquery>
      <cfquery result='updateHS' datasource='#Application.Settings.IEIR#'>
      	update converted_dc_student set high_school = (select hs_name from stu_hs_trans where student_id = student)
      </cfquery>
      <!--- return all converted students --->
      <cfset converts=''>
      <cfquery name='converts' datasource='#Application.Settings.IEIR_RO#'>
        select student, fname, lname, high_school, county, county_name, init_dc_term, dc_home_loc, init_dc_prog, init_dc_major,
        			 init_reg_term, reg_home_loc, init_reg_prog, init_reg_major
        from converted_dc_student
        order by init_dc_term, init_dc_prog, student
      </cfquery>
    <cfreturn converts>
	</cffunction>
  
</cfcomponent>