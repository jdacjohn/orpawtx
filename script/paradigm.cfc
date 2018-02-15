<!--- This component contains methods for extracting student enrollment, persistence, and
      Completion data for programs by locations for multiple periods of academic years. --->
      
<cfcomponent>

  <!--- Get the last 5 year's worth of unduplicated headcount for the entire college. --->
  <cffunction name="getParadigmForLocAndProg" access="public" returntype="struct">
  	<cfargument name='location' type='string' required='yes'>
    <cfargument name='program' type='string' required='yes'>
    <cfif location eq '460'>
    	<cfset campus='Abilene'>
    </cfif>
    <cfif location eq '480'>
    	<cfset campus='Breckenridge'>
    </cfif>
    <cfif location eq '470'>
    	<cfset campus='Brownwood'>
    </cfif>
    <cfif location eq '400'>
    	<cfset campus=''>
    </cfif>
    <cfif location eq '4'>
    	<cfset campus='%'>
    </cfif>
    <cfset parData=StructNew()>
    <cfset parData.tsi=ArrayNew(1)>
    <cfset parData.nontsi=Arraynew(1)>
    <cfset parData.tsi[1] = 0>
    <cfset parData.nontsi[1] = 0>
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>

		<!--- Get the TSI and non-TSI new enrollments for the program for the last 5 years --->
    <cfloop query='yearsAndTerms'> <!--- Loop over each year --->
    	
			<cfset tsiEnrolled=''>			
			<cfset nontsiEnrolled=''>
      <cfset termArray=ListToArray(yearsAndTerms.terms,',')>      

      <cfloop index="ndx" from="1" to="3" step="1"> <!--- loop over the terms in the current year. --->
      	
				<!--- Get the number of new TSI met students in the program for the term. --->
        <cfquery name='tsiEnrolled' datasource='#Application.Settings.IEIR_RO#'>
        	select count(distinct(id_no)) as students from student_terms 
        		where rpt_term = #termArray[ndx]#
          		and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and acad_disadv = 0
      	</cfquery>
        <!--- Add the number of new students to the 5-year total. --->
        <cfset parData.tsi[1] += tsiEnrolled.students>
        
        <!--- Get the number of NEW nonTSI met students in the program for the term. --->
      	<cfquery name='nontsiEnrolled' datasource='#Application.Settings.IEIR_RO#'>
        	select count(distinct(id_no)) as students from student_terms 
        		where rpt_term = #termArray[ndx]#
          		and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and acad_disadv = 1
      	</cfquery>
        <!--- Add the number of nonTSI new students to the 5-year total. --->
       	<cfset parData.nontsi[1] += nontsiEnrolled.students>
      
      </cfloop>  <!--- End looping over term. --->
      
    </cfloop>  <!--- End looping over the year. --->
    
    
    <!--- Pull the Retention Figures --->
    <cfset parData.tsi[2] = 0>			<!--- Returners after 2 terms. --->
    <cfset parData.nontsi[2] = 0>
    <cfset parData.tsi[3] = 0>			<!--- Returners after 3 terms. --->
    <cfset parData.nontsi[3] = 0>
    <cfset parData.tsi[4] = 0>			<!--- Returners after 4 terms. --->
    <cfset parData.nontsi[4] = 0>
    <cfset parData.tsi[5] = 0>			<!--- Graduates. --->
    <cfset parData.nontsi[5] = 0>
    
    <!--- Set up an in-clause to be used for selecting number of awards for the major. --->
    <cfinvoke component='script.programs' method='getActivePrograms' major='#program#' returnvariable='aProgs'></cfinvoke>
    <cfset activePrograms='('>
    <cfloop query='aProgs'>
   		<cfset activePrograms = activePrograms & '"' & #aProgs.program# & '",'>
    </cfloop>
    <!--- <cfdump var=#tsiStudents#><br />  --->
    <!--- remove the last offending comma. --->
    <cfif len(activePrograms) gt 1>
			<cfset activePrograms = Left(activePrograms,len(activePrograms) - 1)>
    </cfif>
    <!--- now Close up the inclause --->
    <cfset activePrograms = activePrograms & ')'>
    <cfif activePrograms eq '()'>
     	<cfset activePrograms='("4ZZ.UND.NEVER")'>
    </cfif>
    
    <cfloop query="yearsAndTerms">  <!--- Loop over each academic year in the 5-year period. --->
    	
			<cfset tsiRet1=''>
    	<cfset nontsiRet1=''>
    	<cfset tsiRet2=''>
    	<cfset nontsiRet2=''>
    	<cfset tsiRet3=''>
    	<cfset nontsiRet3=''>
    	
			<cfset termArray=ListToArray(yearsAndTerms.terms,',')>
      
    	<cfloop index="ndx" from="1" to="3" step="1">  <!--- Loop over the terms in each academic year. --->

	      <!--- build an IN clause value that can be used in the following select statements. --->
      	<cfset tsiStudents = '('>
      	<cfset tsiStudentIds=''>
        <cfquery name='tsiStudentIds' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(id_no) as student from student_terms
          	where rpt_term = #termArray[ndx]#
            	and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and acad_disadv = 0
        </cfquery>
        <cfloop query='tsiStudentIds'>
        	<cfset tsiStudents = tsiStudents & #tsiStudentIds.student# & ','>
      	</cfloop>
        <!--- <cfdump var=#tsiStudents#><br />  --->
      	<!--- remove the last offending comma. --->
      	<cfif len(tsiStudents) gt 1>
					<cfset tsiStudents = Left(tsiStudents,len(tsiStudents) - 1)>
        </cfif>
      	<!--- now Close up the inclause --->
      	<cfset tsiStudents = tsiStudents & ')'>
        <cfif tsiStudents eq '()'>
        	<cfset tsiStudents='(9999999)'>
        </cfif>

	      <!--- build an IN clause value that can be used in the following select statements. --->
      	<cfset nontsiStudents = '('>
      	<cfset nontsiStudentIds=''>
        <cfquery name='nontsiStudentIds' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(id_no) as student from student_terms
          	where rpt_term = #termArray[ndx]#
            	and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and acad_disadv = 1
        </cfquery>
        <cfloop query='nontsiStudentIds'>
        	<cfset nontsiStudents = nontsiStudents & #nontsiStudentIds.student# & ','>
      	</cfloop>
      	<!--- remove the last offending comma. --->
        <cfif len(nontsiStudents) gt 1>
      		<cfset nontsiStudents = Left(nontsiStudents,len(nontsiStudents) - 1)>
        </cfif>
      	<!--- now Close up the inclause --->
      	<cfset nontsiStudents = nontsiStudents & ')'>
        <cfif nontsiStudents eq '()'>
        	<cfset nontsiStudents='(9999999)'>
        </cfif>

    		<cfset getTermSeq=''>
      	<!--- Get the sequence number of the term so we can get +1, +2, +3 --->
      	<cfquery name="termSeq" datasource="#Application.Settings.IEIR_RO#">
      		select seq from term_seq where term = #termArray[ndx]#
      	</cfquery>
      	<!--- Get Get Term + 1 --->
      	<cfset termPlus1=''>
      	<cfquery name="termPlus1" datasource="#Application.Settings.IEIR_RO#">
      		select term from term_seq where seq = (#termSeq.seq# + 1)
      	</cfquery>
      	<!--- Get TSI returners after one term --->
      	<cfquery name="tsiRet1" datasource="#Application.Settings.IEIR_RO#">
      		select count(distinct(id_no)) as students from student_terms
        		where rpt_term = '#termPlus1.term#'
          		and flex_entry = 0
            	and active_major = '#program#'
            	and id_no in #tsiStudents#
       	</cfquery>
       	<cfset parData.tsi[2] += tsiRet1.students>
        <!--- Add any 'non returners that may have graduated in the first term. --->
        <cfset tsigrad1=''>
        <cfquery name='tsigrad1' datasource='#Application.Settings.IEIR_RO#'>
        	select count(distinct(student_id)) as grads from stu_awards
          	where term = #termArray[ndx]#
            	and program in #activePrograms#
            	and student_id in #tsiStudents#
       	</cfquery>
        <cfset parData.tsi[2] += tsigrad1.grads>
      	<!--- Get non-TSI returners after 1 term --->
      	<cfquery name="nontsiRet1" datasource="#Application.Settings.IEIR_RO#">
      		select count(distinct(id_no)) as students from student_terms
        		where rpt_term = '#termPlus1.term#'
          		and flex_entry = 0
            	and active_major = '#program#'
            	and id_no in #nontsiStudents#
       	</cfquery>
       	<cfset parData.nontsi[2] += nontsiRet1.students>
        <!--- Add any 'non returners that may have graduated. --->
        <cfset nontsigrad1=''>
        <cfquery name='nontsigrad1' datasource='#Application.Settings.IEIR_RO#'>
        	select count(distinct(student_id)) as grads from stu_awards
          	where term = #termArray[ndx]#
            	and program in #activePrograms#
            	and student_id in #nontsiStudents#
       	</cfquery>
        <cfset parData.nontsi[2] += nontsigrad1.grads>
      	
				<!--- Get Get Term + 2 --->
      	<cfset termPlus2=''>
      	<cfquery name="termPlus2" datasource="#Application.Settings.IEIR_RO#">
      		select term from term_seq where seq = (#termSeq.seq# + 2)
      	</cfquery>
      	<!--- Get TSI returners after 2 terms --->
      	<cfquery name="tsiRet2" datasource="#Application.Settings.IEIR_RO#">
      		select count(distinct(id_no)) as students from student_terms
        		where rpt_term = '#termPlus2.term#'
          		and flex_entry = 0
            	and active_major = '#program#'
            	and id_no in #tsiStudents#
       	</cfquery>
       	<cfset parData.tsi[3] += tsiRet2.students>
        <!--- Add any 'non returners that may have graduated in the first or second term. --->
        <cfset tsigrad2=''>
        <cfquery name='tsigrad2' datasource='#Application.Settings.IEIR_RO#'>
        	select count(distinct(student_id)) as grads from stu_awards
          	where (term = #termArray[ndx]# or term = '#termPlus1.term#')
            	and program in #activePrograms#
            	and student_id in #tsiStudents#
       	</cfquery>
        <cfset parData.tsi[3] += tsigrad2.grads>
      	<!--- Get non-TSI returners after 2 terms --->
      	<cfquery name="nontsiRet2" datasource="#Application.Settings.IEIR_RO#">
      		select count(distinct(id_no)) as students from student_terms
        		where rpt_term = '#termPlus2.term#'
          		and flex_entry = 0
            	and active_major = '#program#'
            	and id_no in #nontsiStudents#
       	</cfquery>
       	<cfset parData.nontsi[3] += nontsiRet2.students>
        <!--- Add any 'non returners that may have graduated. --->
        <cfset nontsigrad2=''>
        <cfquery name='nontsigrad2' datasource='#Application.Settings.IEIR_RO#'>
        	select count(distinct(student_id)) as grads from stu_awards
          	where (term = #termArray[ndx]# or term = '#termPlus1.term#')
            	and program in #activePrograms#
            	and student_id in #nontsiStudents#
       	</cfquery>
        <cfset parData.nontsi[3] += nontsigrad2.grads>
      	<!--- Get Get Term + 3 --->
      	<cfset termPlus3=''>
      	<cfquery name="termPlus3" datasource="#Application.Settings.IEIR_RO#">
      		select term from term_seq where seq = (#termSeq.seq# + 3)
      	</cfquery>
      	<!--- Get TSI returners after 3 terms --->
      	<cfquery name="tsiRet3" datasource="#Application.Settings.IEIR_RO#">
      		select count(distinct(id_no)) as students from student_terms
        		where rpt_term = '#termPlus3.term#'
          		and flex_entry = 0
            	and active_major = '#program#'
            	and id_no in #tsiStudents#
       	</cfquery>
       	<cfset parData.tsi[4] += tsiRet3.students>
        <!--- Add any 'non returners that may have graduated. --->
        <cfset tsigrad3=''>
        <cfquery name='tsigrad3' datasource='#Application.Settings.IEIR_RO#'>
        	select count(distinct(student_id)) as grads from stu_awards
          	where (term = '#termPlus1.term#' or term = '#termPlus2.term#' or term = #termArray[ndx]#)
            	and program in #activePrograms#
            	and student_id in #tsiStudents#
       	</cfquery>
        <cfset parData.tsi[4] += tsigrad3.grads>
      	<!--- Get non-TSI returners after 3 terms --->
      	<cfquery name="nontsiRet3" datasource="#Application.Settings.IEIR_RO#">
      		select count(distinct(id_no)) as students from student_terms
        		where rpt_term = '#termPlus3.term#'
          		and flex_entry = 0
            	and active_major = '#program#'
            	and id_no in #nontsiStudents#
       	</cfquery>
       	<cfset parData.nontsi[4] += nontsiRet3.students>
        <!--- Add any 'non returners that may have graduated. --->
        <cfset nontsigrad3=''>
        <cfquery name='nontsigrad3' datasource='#Application.Settings.IEIR_RO#'>
        	select count(distinct(student_id)) as grads from stu_awards
          	where (term = '#termPlus1.term#' or term = '#termPlus2.term#' or term = #termArray[ndx]#)
            	and program in #activePrograms#
            	and student_id in #nontsiStudents#
       	</cfquery>
        <cfset parData.nontsi[4] += nontsigrad3.grads>
				<!--- Sum up the students who started in termArray[ndx] and have graduated. --->
      	<!--- Get TSI Grads --->
      	<cfset tsiGrads=''>
      	<cfquery name='tsiGrads' datasource='#Application.Settings.IEIR_RO#'>
      		select count(*) as grads from stu_awards
        		where program in #activePrograms#
          		and student_id in #tsiStudents#
      	</cfquery>
      	<cfset parData.tsi[5] += tsiGrads.grads>
      	<!--- Get non-TSI Grads --->
      	<cfset nontsiGrads=''>
      	<cfquery name='nontsiGrads' datasource='#Application.Settings.IEIR_RO#'>
      		select count(*) as grads from stu_awards
        		where program in #activePrograms#
          		and student_id in #nontsiStudents#
       	</cfquery>
        <cfset parData.nontsi[5] += nontsiGrads.grads>
      </cfloop>
    
    </cfloop>
		<cfreturn parData>
	</cffunction>

	<!--- Get the breakdown of a programs last 5-year's worth of new students by zip code --->
  <cffunction name='getZipBreakdowns' access='public' returntype='struct'>
  	<cfargument name='location' type='string' required='yes'>
    <cfargument name='program' type='string' required='yes'>
    <cfif location eq '460'>
    	<cfset campus='Abilene'>
    </cfif>
    <cfif location eq '480'>
    	<cfset campus='Breckenridge'>
    </cfif>
    <cfif location eq '470'>
    	<cfset campus='Brownwood'>
    </cfif>
    <cfif location eq '400'>
    	<cfset campus=''>
    </cfif>
    <cfif location eq '4'>
    	<cfset campus='%'>
    </cfif>

		<cfset zipBreaks=StructNew()>
    <cfset zipBreaks.tsi=StructNew()>
    <cfset zipBreaks.nonTSI=StructNew()>
    <cfset zipBreaks.tsi.students=0>
    <cfset zipBreaks.nonTSI.students=0>
    
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>

		<!--- Get the TSI and non-TSI new enrollments for the program for the last 5 years --->
    <!--- Before we can do anything, we have to build some massive in-clauses to use against the orpa_st_address
		      table. --->
    <cfset tsiIds='('>
    <cfset nonTSIIds='('>
    
    <cfloop query='yearsAndTerms'> <!--- Loop over each year --->
    	
      <cfset termArray=ListToArray(yearsAndTerms.terms,',')>      

      <cfloop index="ndx" from="1" to="3" step="1"> <!--- loop over the terms in the current year. --->
      	
				<cfset tsiEnrolled=''>			
				<cfset nontsiEnrolled=''>
				
				<!--- Get the number of new TSI met students in the program for the term. --->
        <cfquery name='tsiEnrolled' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(id_no) as student from student_terms 
        		where rpt_term = #termArray[ndx]#
          		and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and acad_disadv = 0
      	</cfquery>
        <!--- Add the number of new students to the 5-year total. --->
        <cfset zipBreaks.tsi.students += tsiEnrolled.RecordCount>
        
        <!--- Get the number of NEW nonTSI met students in the program for the term. --->
      	<cfquery name='nontsiEnrolled' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(id_no) as student from student_terms 
        		where rpt_term = #termArray[ndx]#
          		and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and acad_disadv = 1
      	</cfquery>
        <!--- Add the number of nonTSI new students to the 5-year total. --->
       	<cfset zipBreaks.nonTSI.students += nontsiEnrolled.RecordCount>
        
        <!--- Build the id list for the current term --->
        <cfloop query='tsiEnrolled'>
        	<cfset tsiIds = tsiIds & tsiEnrolled.student & ','>
        </cfloop>
        <cfloop query='nontsiEnrolled'>
        	<cfset nonTSIIds = nonTSIIds & nontsiEnrolled.student & ','>
        </cfloop>
      
      </cfloop>  <!--- End looping over term. --->
      
    </cfloop>  <!--- End looping over the year. --->
    
    <!--- perform final touches on the id strings --->
    <!--- Remove ending commas --->
    <cfif len(tsiIds) gt 1>
			<cfset tsiIds = Left(tsiIds,Len(tsiIds) - 1)>
    </cfif>
    <cfif len(nonTSIIds) gt 1>
    	<cfset nonTSIIds = Left(nonTSIIds,Len(nonTSIIds) - 1)>
    </cfif>
    <!--- Add closing parentheses --->
    <cfset tsiIds = tsiIds & ')'>
    <cfset nonTSIids = nonTSIIds & ')'>
		<!--- Fix empty in-clauses with a bogus student id --->
    <cfif tsiIds eq '()'>
     	<cfset tsiIds='(9999999)'>
    </cfif>
    <cfif nonTSIids eq '()'>
     	<cfset nonTSIids='(9999999)'>
    </cfif>
        
<!---    <cfdump var="#tsiIds#">
    <cfdump var="#nonTSIIds#"> --->
    
    <!--- Now group these ids by zip code.  --->
    <cfset tsiZips=''>
    <cfquery name='tsiZips' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as students, zip from orpa_st_address
      	where studentId in #tsiIds#
        group by zip
        order by students DESC
        limit 10
    </cfquery>
    <cfset zipBreaks.tsi.breakouts = tsiZips>
    <cfset nonTSIZips=''>
    <cfquery name='nonTSIZips' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as students, zip from orpa_st_address
      	where studentId in #nonTSIIds#
        group by zip
        order by students DESC
        limit 10
    </cfquery>
    <cfset zipBreaks.nontsi.breakouts = nonTSIZips>

    <cfreturn zipBreaks>
  
  </cffunction>

	<!--- Get the demographics of a programs last 5-year's worth of new students within a zip code --->
  <cffunction name='getZipDemos' access='public' returntype='struct'>
  	<cfargument name='location' type='string' required='yes'>
    <cfargument name='program' type='string' required='yes'>
    <cfargument name='zip' type='string' required='yes'>
    <cfif location eq '460'>
    	<cfset campus='Abilene'>
    </cfif>
    <cfif location eq '480'>
    	<cfset campus='Breckenridge'>
    </cfif>
    <cfif location eq '470'>
    	<cfset campus='Brownwood'>
    </cfif>
    <cfif location eq '400'>
    	<cfset campus=''>
    </cfif>
    <cfif location eq '4'>
    	<cfset campus='%'>
    </cfif>

		<!--- Build the structures that will hold our final demographics information --->
		<cfset zipBreaks=StructNew()>
    <cfset zipBreaks.tsi=StructNew()>
    <cfset zipBreaks.tsi.males=StructNew()>
    	<cfset zipBreaks.tsi.males.students=0>
      <cfset zipBreaks.tsi.males.ages=StructNew()>
      	<cfset zipBreaks.tsi.males.ages.under18=StructNew()>
        	<cfset zipBreaks.tsi.males.ages.under18.students=0>
          <cfset zipBreaks.tsi.males.ages.under18.econDisadv=0>
          <cfset zipBreaks.tsi.males.ages.under18.econOK=0>
      	<cfset zipBreaks.tsi.males.ages.eighteenTo20=StructNew()>
        	<cfset zipBreaks.tsi.males.ages.eighteenTo20.students=0>
          <cfset zipBreaks.tsi.males.ages.eighteenTo20.econDisadv=0>
          <cfset zipBreaks.tsi.males.ages.eighteenTo20.econOK=0>
      	<cfset zipBreaks.tsi.males.ages.twentyOneTo24=StructNew()>
        	<cfset zipBreaks.tsi.males.ages.twentyOneTo24.students=0>
          <cfset zipBreaks.tsi.males.ages.twentyOneTo24.econDisadv=0>
          <cfset zipBreaks.tsi.males.ages.twentyOneTo24.econOK=0>
      	<cfset zipBreaks.tsi.males.ages.twentyFiveTo29=StructNew()>
        	<cfset zipBreaks.tsi.males.ages.twentyFiveTo29.students=0>
          <cfset zipBreaks.tsi.males.ages.twentyFiveTo29.econDisadv=0>
          <cfset zipBreaks.tsi.males.ages.twentyFiveTo29.econOK=0>
      	<cfset zipBreaks.tsi.males.ages.thirtyTo39=StructNew()>
        	<cfset zipBreaks.tsi.males.ages.thirtyTo39.students=0>
          <cfset zipBreaks.tsi.males.ages.thirtyTo39.econDisadv=0>
          <cfset zipBreaks.tsi.males.ages.thirtyTo39.econOK=0>
      	<cfset zipBreaks.tsi.males.ages.fortyPlus=StructNew()>
        	<cfset zipBreaks.tsi.males.ages.fortyPlus.students=0>
          <cfset zipBreaks.tsi.males.ages.fortyPlus.econDisadv=0>
          <cfset zipBreaks.tsi.males.ages.fortyPlus.econOK=0>
    <cfset zipBreaks.tsi.females=StructNew()>
    	<cfset zipBreaks.tsi.females.students=0>
      <cfset zipBreaks.tsi.females.ages=StructNew()>
      	<cfset zipBreaks.tsi.females.ages.under18=StructNew()>
        	<cfset zipBreaks.tsi.females.ages.under18.students=0>
          <cfset zipBreaks.tsi.females.ages.under18.econDisadv=0>
          <cfset zipBreaks.tsi.females.ages.under18.econOK=0>
      	<cfset zipBreaks.tsi.females.ages.eighteenTo20=StructNew()>
        	<cfset zipBreaks.tsi.females.ages.eighteenTo20.students=0>
          <cfset zipBreaks.tsi.females.ages.eighteenTo20.econDisadv=0>
          <cfset zipBreaks.tsi.females.ages.eighteenTo20.econOK=0>
      	<cfset zipBreaks.tsi.females.ages.twentyOneTo24=StructNew()>
        	<cfset zipBreaks.tsi.females.ages.twentyOneTo24.students=0>
          <cfset zipBreaks.tsi.females.ages.twentyOneTo24.econDisadv=0>
          <cfset zipBreaks.tsi.females.ages.twentyOneTo24.econOK=0>
      	<cfset zipBreaks.tsi.females.ages.twentyFiveTo29=StructNew()>
        	<cfset zipBreaks.tsi.females.ages.twentyFiveTo29.students=0>
          <cfset zipBreaks.tsi.females.ages.twentyFiveTo29.econDisadv=0>
          <cfset zipBreaks.tsi.females.ages.twentyFiveTo29.econOK=0>
      	<cfset zipBreaks.tsi.females.ages.thirtyTo39=StructNew()>
        	<cfset zipBreaks.tsi.females.ages.thirtyTo39.students=0>
          <cfset zipBreaks.tsi.females.ages.thirtyTo39.econDisadv=0>
          <cfset zipBreaks.tsi.females.ages.thirtyTo39.econOK=0>
      	<cfset zipBreaks.tsi.females.ages.fortyPlus=StructNew()>
        	<cfset zipBreaks.tsi.females.ages.fortyPlus.students=0>
          <cfset zipBreaks.tsi.females.ages.fortyPlus.econDisadv=0>
          <cfset zipBreaks.tsi.females.ages.fortyPlus.econOK=0>
    
    <cfset zipBreaks.nonTSI=StructNew()>
    <cfset zipBreaks.nonTSI.males=StructNew()>
    	<cfset zipBreaks.nonTSI.males.students=0>
      <cfset zipBreaks.nonTSI.males.ages=StructNew()>
      	<cfset zipBreaks.nonTSI.males.ages.under18=StructNew()>
        	<cfset zipBreaks.nonTSI.males.ages.under18.students=0>
          <cfset zipBreaks.nonTSI.males.ages.under18.econDisadv=0>
          <cfset zipBreaks.nonTSI.males.ages.under18.econOK=0>
      	<cfset zipBreaks.nonTSI.males.ages.eighteenTo20=StructNew()>
        	<cfset zipBreaks.nonTSI.males.ages.eighteenTo20.students=0>
          <cfset zipBreaks.nonTSI.males.ages.eighteenTo20.econDisadv=0>
          <cfset zipBreaks.nonTSI.males.ages.eighteenTo20.econOK=0>
      	<cfset zipBreaks.nonTSI.males.ages.twentyOneTo24=StructNew()>
        	<cfset zipBreaks.nonTSI.males.ages.twentyOneTo24.students=0>
          <cfset zipBreaks.nonTSI.males.ages.twentyOneTo24.econDisadv=0>
          <cfset zipBreaks.nonTSI.males.ages.twentyOneTo24.econOK=0>
      	<cfset zipBreaks.nonTSI.males.ages.twentyFiveTo29=StructNew()>
        	<cfset zipBreaks.nonTSI.males.ages.twentyFiveTo29.students=0>
          <cfset zipBreaks.nonTSI.males.ages.twentyFiveTo29.econDisadv=0>
          <cfset zipBreaks.nonTSI.males.ages.twentyFiveTo29.econOK=0>
      	<cfset zipBreaks.nonTSI.males.ages.thirtyTo39=StructNew()>
        	<cfset zipBreaks.nonTSI.males.ages.thirtyTo39.students=0>
          <cfset zipBreaks.nonTSI.males.ages.thirtyTo39.econDisadv=0>
          <cfset zipBreaks.nonTSI.males.ages.thirtyTo39.econOK=0>
      	<cfset zipBreaks.nonTSI.males.ages.fortyPlus=StructNew()>
        	<cfset zipBreaks.nonTSI.males.ages.fortyPlus.students=0>
          <cfset zipBreaks.nonTSI.males.ages.fortyPlus.econDisadv=0>
          <cfset zipBreaks.nonTSI.males.ages.fortyPlus.econOK=0>
    <cfset zipBreaks.nonTSI.females=StructNew()>
    	<cfset zipBreaks.nonTSI.females.students=0>
      <cfset zipBreaks.nonTSI.females.ages=StructNew()>
      	<cfset zipBreaks.nonTSI.females.ages.under18=StructNew()>
        	<cfset zipBreaks.nonTSI.females.ages.under18.students=0>
          <cfset zipBreaks.nonTSI.females.ages.under18.econDisadv=0>
          <cfset zipBreaks.nonTSI.females.ages.under18.econOK=0>
      	<cfset zipBreaks.nonTSI.females.ages.eighteenTo20=StructNew()>
        	<cfset zipBreaks.nonTSI.females.ages.eighteenTo20.students=0>
          <cfset zipBreaks.nonTSI.females.ages.eighteenTo20.econDisadv=0>
          <cfset zipBreaks.nonTSI.females.ages.eighteenTo20.econOK=0>
      	<cfset zipBreaks.nonTSI.females.ages.twentyOneTo24=StructNew()>
        	<cfset zipBreaks.nonTSI.females.ages.twentyOneTo24.students=0>
          <cfset zipBreaks.nonTSI.females.ages.twentyOneTo24.econDisadv=0>
          <cfset zipBreaks.nonTSI.females.ages.twentyOneTo24.econOK=0>
      	<cfset zipBreaks.nonTSI.females.ages.twentyFiveTo29=StructNew()>
        	<cfset zipBreaks.nonTSI.females.ages.twentyFiveTo29.students=0>
          <cfset zipBreaks.nonTSI.females.ages.twentyFiveTo29.econDisadv=0>
          <cfset zipBreaks.nonTSI.females.ages.twentyFiveTo29.econOK=0>
      	<cfset zipBreaks.nonTSI.females.ages.thirtyTo39=StructNew()>
        	<cfset zipBreaks.nonTSI.females.ages.thirtyTo39.students=0>
          <cfset zipBreaks.nonTSI.females.ages.thirtyTo39.econDisadv=0>
          <cfset zipBreaks.nonTSI.females.ages.thirtyTo39.econOK=0>
      	<cfset zipBreaks.nonTSI.females.ages.fortyPlus=StructNew()>
        	<cfset zipBreaks.nonTSI.females.ages.fortyPlus.students=0>
          <cfset zipBreaks.nonTSI.females.ages.fortyPlus.econDisadv=0>
          <cfset zipBreaks.nonTSI.females.ages.fortyPlus.econOK=0>
    
		<cfinvoke method='getLast5YearsAndTerms' returnVariable='yearsAndTerms'></cfinvoke>

		<!--- Get the TSI and non-TSI new enrollments for the program for the last 5 years --->
    <!--- Before we can do anything, we have to build some massive in-clauses to use against the orpa_st_address
		      table. --->
    <cfset tsiIds='('>
    <cfset nonTSIIds='('>
    
    <cfloop query='yearsAndTerms'> <!--- Loop over each year --->
    	
      <cfset termArray=ListToArray(yearsAndTerms.terms,',')>      

      <cfloop index="ndx" from="1" to="3" step="1"> <!--- loop over the terms in the current year. --->
      	
				<cfset tsiEnrolled=''>			
				<cfset nontsiEnrolled=''>
				
				<!--- Get the list of new TSI met students in the program for the term. --->
        <cfquery name='tsiEnrolled' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(id_no) as student from student_terms 
        		where rpt_term = #termArray[ndx]#
          		and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and acad_disadv = 0
              and id_no in (select studentId from orpa_st_address where zip = '#zip#')
      	</cfquery>
        
        <!--- Get the list of NEW nonTSI met students in the program for the term. --->
      	<cfquery name='nontsiEnrolled' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(id_no) as student from student_terms 
        		where rpt_term = #termArray[ndx]#
          		and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and acad_disadv = 1
              and id_no in (select studentId from orpa_st_address where zip = '#zip#')
      	</cfquery>
        
        <!--- Build the id list for the current term --->
        <cfloop query='tsiEnrolled'>
        	<cfset tsiIds = tsiIds & tsiEnrolled.student & ','>
        </cfloop>
        <cfloop query='nontsiEnrolled'>
        	<cfset nonTSIIds = nonTSIIds & nontsiEnrolled.student & ','>
        </cfloop>
      
      </cfloop>  <!--- End looping over term. --->
      
    </cfloop>  <!--- End looping over the year. --->
    
    <!--- perform final touches on the id strings --->
    <!--- Remove ending commas --->
    <cfif len(tsiIds) gt 1>
			<cfset tsiIds = Left(tsiIds,Len(tsiIds) - 1)>
    </cfif>
    <cfif len(nonTSIIds) gt 1>
    	<cfset nonTSIIds = Left(nonTSIIds,Len(nonTSIIds) - 1)>
    </cfif>
    <!--- Add closing parentheses --->
    <cfset tsiIds = tsiIds & ')'>
    <cfset nonTSIids = nonTSIIds & ')'>
		<!--- Fix empty in-clauses with a bogus student id --->
    <cfif tsiIds eq '()'>
     	<cfset tsiIds='(9999999)'>
    </cfif>
    <cfif nonTSIids eq '()'>
     	<cfset nonTSIids='(9999999)'>
    </cfif>
        
<!---    <cfdump var="#tsiIds#">
    <cfdump var="#nonTSIIds#"> --->
    
		<!--- We have to loop again because we want to be looking at the students as of when they began college. --->
    <cfloop query='yearsAndTerms'> <!--- Loop over each year --->
    	
      <cfset termArray=ListToArray(yearsAndTerms.terms,',')>      

      <cfloop index="ndx" from="1" to="3" step="1"> <!--- loop over the terms in the current year. --->

    		<!--- Now Pull the Demographic Data one group at a time  --->
				<!--- Take care of the TSI Student group first. --->
    		<!--- Get Male student counts --->
    		<cfset tsiMales=''>
    		<cfquery name='tsiMales' datasource='#Application.Settings.IEIR_RO#'>
    			select count(distinct(id_no)) as students from student_terms
          	where rpt_term = #termArray[ndx]#
            	and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and gender = 'M'
              and id_no in #tsiIds#
    		</cfquery>
    		<cfset zipBreaks.tsi.males.students += tsiMales.students>
 				
        <!--- Don't bother breaking out by age if the number of students in the group is 0. --->
        <cfif tsiMales.students gt 0>
					<!--- Get non-Econ disadvantanged male students age <= 18 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=0
            maxAge=17
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.under18.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age < 18 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=0
            maxAge=17
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.under18.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.males.ages.under18.students += (males1 + males2)>
  
          <!--- Get non-Econ disadvantanged male students age >= 18 and <= 20 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=18
            maxAge=20
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.eighteenTo20.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 18 and <= 20 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=18
            maxAge=20
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.eighteenTo20.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.males.ages.eighteenTo20.students += (males1 + males2)>
          
          <!--- Get non-Econ disadvantanged male students age >= 21 and <= 24 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=21
            maxAge=24
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.twentyOneTo24.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 21 and <= 24--->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=21
            maxAge=24
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.twentyOneTo24.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.males.ages.twentyOneTo24.students += (males1 + males2)>
          
          <!--- Get non-Econ disadvantanged male students age >= 25 and <= 29 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=25
            maxAge=29
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.twentyFiveTo29.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 25 and <= 29 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=25
            maxAge=29
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.twentyFiveTo29.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.males.ages.twentyFiveTo29.students += (males1 + males2)>
          
            <!--- Get non-Econ disadvantanged male students age >= 30 and <= 39 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=30
            maxAge=39
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.thirtyTo39.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 30 and <= 39 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=30
            maxAge=39
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.thirtyTo39.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.males.ages.thirtyTo39.students += (males1 + males2)>
          
          <!--- Get non-Econ disadvantanged male students age >= 40  --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=40
            maxAge=200
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.fortyPlus.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 40 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=40
            maxAge=200
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.tsi.males.ages.fortyPlus.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.males.ages.fortyPlus.students += (males1 + males2)>
        </cfif>
       
          
        <!--- Get Female student counts --->
    		<cfset tsiFemales=''>
    		<cfquery name='tsiFemales' datasource='#Application.Settings.IEIR_RO#'>
    			select count(distinct(id_no)) as students from student_terms
          	where rpt_term = #termArray[ndx]#
            	and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and gender = 'F'
              and id_no in #tsiIds#
    		</cfquery>        
    		<cfset zipBreaks.tsi.females.students += tsiFemales.students>
				<!--- Don't bother with age break-outs if the total students in the group is 0. --->
        <cfif tsiFemales.students gt 0>
					<!--- Get non-Econ disadvantanged female students age <= 18 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=0
            maxAge=17
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.under18.econOk += ageGroupFemale.students>
          <cfset females1 = ageGroupFemale.students>
          <!--- Get Econ disadvantanged female students age < 18 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=0
            maxAge=17
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.under18.econDisadv += ageGroupFemale.students>
          <cfset females2 = ageGroupFemale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.females.ages.under18.students += (females1 + females2)>
  
          <!--- Get non-Econ disadvantanged female students age >= 18 and <= 20 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=18
            maxAge=20
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.eighteenTo20.econOk += ageGroupFemale.students>
          <cfset females1 = ageGroupFemale.students>
          <!--- Get Econ disadvantanged female students age >= 18 and <= 20 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=18
            maxAge=20
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.eighteenTo20.econDisadv += ageGroupFemale.students>
          <cfset females2 = ageGroupFemale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.females.ages.eighteenTo20.students += (females1 + females2)>
          
          <!--- Get non-Econ disadvantanged female students age >= 21 and <= 24 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=21
            maxAge=24
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.twentyOneTo24.econOk += ageGroupFemale.students>
          <cfset females1 = ageGroupFemale.students>
          <!--- Get Econ disadvantanged female students age >= 21 and <= 24--->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=21
            maxAge=24
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.twentyOneTo24.econDisadv += ageGroupFemale.students>
          <cfset females2 = ageGroupFemale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.females.ages.twentyOneTo24.students += (females1 + females2)>
          
          <!--- Get non-Econ disadvantanged female students age >= 25 and <= 29 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=25
            maxAge=29
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.twentyFiveTo29.econOk += ageGroupFemale.students>
          <cfset females1 = ageGroupFemale.students>
          <!--- Get Econ disadvantanged female students age >= 25 and <= 29 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=25
            maxAge=29
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.twentyFiveTo29.econDisadv += ageGroupFemale.students>
          <cfset females2 = ageGroupFemale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.females.ages.twentyFiveTo29.students += (females1 + females2)>
          
            <!--- Get non-Econ disadvantanged female students age >= 30 and <= 39 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=30
            maxAge=39
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.thirtyTo39.econOk += ageGroupFemale.students>
          <cfset females1 = ageGroupFemale.students>
          <!--- Get Econ disadvantanged female students age >= 30 and <= 39 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=30
            maxAge=39
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.thirtyTo39.econDisadv += ageGroupFemale.students>
          <cfset females2 = ageGroupFemale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.females.ages.thirtyTo39.students += (females1 + females2)>
          
          <!--- Get non-Econ disadvantanged female students age >= 40  --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=40
            maxAge=200
            econDisadv=0
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.fortyPlus.econOk += ageGroupFemale.students>
          <cfset females1 = ageGroupFemale.students>
          <!--- Get Econ disadvantanged female students age >= 40 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=40
            maxAge=200
            econDisadv=2
            idList='#tsiIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.tsi.females.ages.fortyPlus.econDisadv += ageGroupFemale.students>
          <cfset females2 = ageGroupFemale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.tsi.females.ages.fortyPlus.students += (females1 + females2)>
        </cfif>
        
				<!--- Now Take care of the non-TSI Students. --->
    		<!--- Get Male student counts --->
    		<cfset nontsiMales=''>
    		<cfquery name='nontsiMales' datasource='#Application.Settings.IEIR_RO#'>
    			select count(distinct(id_no)) as students from student_terms
          	where rpt_term = #termArray[ndx]#
            	and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and gender = 'M'
              and id_no in #nonTSIIds#
    		</cfquery>
    		<cfset zipBreaks.nonTSI.males.students += nontsiMales.students>
        
        <!--- Don't bother with age breakouts if the number of mail non-tsi students for this group is 0. --->
        <cfif nontsiMales.students gt 0>
					<!--- Get non-Econ disadvantanged male students age <= 18 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=0
            maxAge=17
            econDisadv=0
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.under18.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age < 18 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=0
            maxAge=17
            econDisadv=2
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.under18.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.nonTSI.males.ages.under18.students += (males1 + males2)>
  
          <!--- Get non-Econ disadvantanged male students age >= 18 and <= 20 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=18
            maxAge=20
            econDisadv=0
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.eighteenTo20.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 18 and <= 20 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=18
            maxAge=20
            econDisadv=2
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.eighteenTo20.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.nonTSI.males.ages.eighteenTo20.students += (males1 + males2)>
          
          <!--- Get non-Econ disadvantanged male students age >= 21 and <= 24 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=21
            maxAge=24
            econDisadv=0
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.twentyOneTo24.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 21 and <= 24--->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=21
            maxAge=24
            econDisadv=2
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.twentyOneTo24.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.nonTSI.males.ages.twentyOneTo24.students += (males1 + males2)>
          
          <!--- Get non-Econ disadvantanged male students age >= 25 and <= 29 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=25
            maxAge=29
            econDisadv=0
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.twentyFiveTo29.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 25 and <= 29 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=25
            maxAge=29
            econDisadv=2
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.twentyFiveTo29.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.nonTSI.males.ages.twentyFiveTo29.students += (males1 + males2)>
          
            <!--- Get non-Econ disadvantanged male students age >= 30 and <= 39 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=30
            maxAge=39
            econDisadv=0
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.thirtyTo39.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 30 and <= 39 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=30
            maxAge=39
            econDisadv=2
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.thirtyTo39.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.nonTSI.males.ages.thirtyTo39.students += (males1 + males2)>
          
          <!--- Get non-Econ disadvantanged male students age >= 40  --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=40
            maxAge=200
            econDisadv=0
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.fortyPlus.econOk += ageGroupMale.students>
          <cfset males1 = ageGroupMale.students>
          <!--- Get Econ disadvantanged male students age >= 40 --->
          <cfset ageGroupMale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='M'
            minAge=40
            maxAge=200
            econDisadv=2
            idList='#nonTSIIds#'
            returnvariable='ageGroupMale'></cfinvoke>
          <cfset zipBreaks.nonTSI.males.ages.fortyPlus.econDisadv += ageGroupMale.students>
          <cfset males2 = ageGroupMale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.nonTSI.males.ages.fortyPlus.students += (males1 + males2)>
        </cfif>

        <!--- Get Female student counts --->
    		<cfset nontsiFemales=''>
    		<cfquery name='nontsiFemales' datasource='#Application.Settings.IEIR_RO#'>
    			select count(distinct(id_no)) as students from student_terms
          	where rpt_term = #termArray[ndx]#
            	and sta_start_term = #termArray[ndx]#
              and flex_entry = 0
              and active_major = '#program#'
              and rem_camp_name = '#campus#'
              and gender = 'F'
              and id_no in #nonTSIIds#
    		</cfquery>
  			<cfset zipBreaks.nonTSI.females.students += nontsiFemales.students>

					<!--- Don't even do the age breakdowns if no records were found for this term and student group --->
				<cfif nontsiFemales.students gt 0>
 					<!--- Get non-Econ disadvantanged female students age <= 18 --->
        	<cfset ageGroupFemale=''>
        	<cfinvoke method='econAgeCount'
        		startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
          	gender='F'
          	minAge=0
          	maxAge=17
          	econDisadv=0
          	idList='#nonTSIIds#'
          	returnvariable='ageGroupFemale'></cfinvoke>
       		<cfset zipBreaks.nonTSI.females.ages.under18.econOk += ageGroupFemale.students>
         	<cfset females1 = ageGroupFemale.students>
 					<!--- Get Econ disadvantanged female students age < 18 --->
        	<cfset ageGroupFemale=''>
        	<cfinvoke method='econAgeCount'
        		startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
          	gender='F'
          	minAge=0
          	maxAge=17
          	econDisadv=2
          	idList='#nonTSIIds#'
          	returnvariable='ageGroupFemale'></cfinvoke>
       		<cfset zipBreaks.nonTSI.females.ages.under18.econDisadv += ageGroupFemale.students>
         	<cfset females2 = ageGroupFemale.students>
        	<!--- Set the total for this ageGroup --->
        	<cfset zipBreaks.nonTSI.females.ages.under18.students += (females1 + females2)>

 					<!--- Get non-Econ disadvantanged female students age >= 18 and <= 20 --->
        	<cfset ageGroupFemale=''>
        	<cfinvoke method='econAgeCount'
        		startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
          	gender='F'
          	minAge=18
          	maxAge=20
          	econDisadv=0
          	idList='#nonTSIIds#'
          	returnvariable='ageGroupFemale'></cfinvoke>
      		<cfset zipBreaks.nonTSI.females.ages.eighteenTo20.econOk += ageGroupFemale.students>
        	<cfset females1 = ageGroupFemale.students>
 					<!--- Get Econ disadvantanged female students age >= 18 and <= 20 --->
        	<cfset ageGroupFemale=''>
        	<cfinvoke method='econAgeCount'
        		startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
          	gender='F'
          	minAge=18
          	maxAge=20
          	econDisadv=2
          	idList='#nonTSIIds#'
          	returnvariable='ageGroupFemale'></cfinvoke>
      		<cfset zipBreaks.nonTSI.females.ages.eighteenTo20.econDisadv += ageGroupFemale.students>
        	<cfset females2 = ageGroupFemale.students>
        	<!--- Set the total for this ageGroup --->
        	<cfset zipBreaks.nonTSI.females.ages.eighteenTo20.students += (females1 + females2)>
        
 					<!--- Get non-Econ disadvantanged female students age >= 21 and <= 24 --->
        	<cfset ageGroupFemale=''>
        	<cfinvoke method='econAgeCount'
        		startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
          	gender='F'
          	minAge=21
          	maxAge=24
          	econDisadv=0
          	idList='#nonTSIIds#'
          	returnvariable='ageGroupFemale'></cfinvoke>
      		<cfset zipBreaks.nonTSI.females.ages.twentyOneTo24.econOk += ageGroupFemale.students>
        	<cfset females1 = ageGroupFemale.students>
 					<!--- Get Econ disadvantanged female students age >= 21 and <= 24--->
        	<cfset ageGroupFemale=''>
        	<cfinvoke method='econAgeCount'
        		startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
          	gender='F'
          	minAge=21
          	maxAge=24
          	econDisadv=2
          	idList='#nonTSIIds#'
          	returnvariable='ageGroupFemale'></cfinvoke>
      		<cfset zipBreaks.nonTSI.females.ages.twentyOneTo24.econDisadv += ageGroupFemale.students>
        	<cfset females2 = ageGroupFemale.students>
        	<!--- Set the total for this ageGroup --->
        	<cfset zipBreaks.nonTSI.females.ages.twentyOneTo24.students += (females1 + females2)>
        
 					<!--- Get non-Econ disadvantanged female students age >= 25 and <= 29 --->
        	<cfset ageGroupFemale=''>
        	<cfinvoke method='econAgeCount'
        		startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
          	gender='F'
          	minAge=25
          	maxAge=29
          	econDisadv=0
          	idList='#nonTSIIds#'
          	returnvariable='ageGroupFemale'></cfinvoke>
      		<cfset zipBreaks.nonTSI.females.ages.twentyFiveTo29.econOk += ageGroupFemale.students>
        	<cfset females1 = ageGroupFemale.students>
 					<!--- Get Econ disadvantanged female students age >= 25 and <= 29 --->
        	<cfset ageGroupFemale=''>
        	<cfinvoke method='econAgeCount'
        		startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
          	gender='F'
          	minAge=25
          	maxAge=29
          	econDisadv=2
          	idList='#nonTSIIds#'
          	returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.nonTSI.females.ages.twentyFiveTo29.econDisadv += ageGroupFemale.students>
          <cfset females2 = ageGroupFemale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.nonTSI.females.ages.twentyFiveTo29.students += (females1 + females2)>
          
            <!--- Get non-Econ disadvantanged female students age >= 30 and <= 39 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=30
            maxAge=39
            econDisadv=0
            idList='#nonTSIIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.nonTSI.females.ages.thirtyTo39.econOk += ageGroupFemale.students>
          <cfset females1 = ageGroupFemale.students>
          <!--- Get Econ disadvantanged female students age >= 30 and <= 39 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=30
            maxAge=39
            econDisadv=2
            idList='#nonTSIIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.nonTSI.females.ages.thirtyTo39.econDisadv += ageGroupFemale.students>
          <cfset females2 = ageGroupFemale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.nonTSI.females.ages.thirtyTo39.students += (females1 + females2)>
          
          <!--- Get non-Econ disadvantanged female students age >= 40  --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=40
            maxAge=200
            econDisadv=0
            idList='#nonTSIIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.nonTSI.females.ages.fortyPlus.econOk += ageGroupFemale.students>
          <cfset females1 = ageGroupFemale.students>
          <!--- Get Econ disadvantanged female students age >= 40 --->
          <cfset ageGroupFemale=''>
          <cfinvoke method='econAgeCount'
            startTerm='#termArray[ndx]#'
            program='#program#'
            campus='#campus#'
            gender='F'
            minAge=40
            maxAge=200
            econDisadv=2
            idList='#nonTSIIds#'
            returnvariable='ageGroupFemale'></cfinvoke>
          <cfset zipBreaks.nonTSI.females.ages.fortyPlus.econDisadv += ageGroupFemale.students>
          <cfset females2 = ageGroupFemale.students>
          <!--- Set the total for this ageGroup --->
          <cfset zipBreaks.nonTSI.females.ages.fortyPlus.students += (females1 + females2)>
        </cfif>

			</cfloop>  <!--- End of the Terms Loops --->

		</cfloop>  <!--- End of the Year Loops --->
    
    <cfreturn zipBreaks>
  
  </cffunction>
  
<!--- INTERNAL METHODS --->

 	<!--- Get a the number of students within an age group for a program at a location, of a given gender for a given
	      Start Term who's id is in a previously determined set of ids (eg - a list of ids from a given zip code) --->
  <cffunction name="econAgeCount" access="private" returntype="query">
  	<cfargument name='startTerm' type='string' required='yes'>
    <cfargument name='program' type='string' required='yes'>
    <cfargument name='campus' type='string' required='yes'>
    <cfargument name='gender' type='string' required='yes'>
    <cfargument name='minAge' type='numeric' required='yes'>
    <cfargument name='maxAge' type='numeric' required='yes'>
    <cfargument name='econDisadv' type='numeric' required='yes'>
    <cfargument name='idList' type='string' required='yes'>
    <cfset ageCount=''>
    <cfquery name='ageCount' datasource='#Application.Settings.IEIR_RO#'>
    	select count(distinct(id_no)) as students from student_terms
      	where rpt_term = #startTerm#
        	and sta_start_term = #startTerm#
          and active_major = '#program#'
          and rem_camp_name = '#campus#'
          and gender = '#gender#'
          and age >= #minAge#
          and age <= #maxAge#
          and econ_disadv = #econDisadv#
          and id_no in #idList#
    </cfquery>
    <cfreturn ageCount>
  </cffunction>
        
	<!--- Return a query with information about the last 5 full academic years. --->
  <cffunction name="getLast5YearsAndTerms" access="public" returntype="query">
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