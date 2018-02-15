<cfcomponent>
	
	<!--- Get the number of TER Scores currently in the system --->
	<cffunction name='getTERCount' access='public' returntype='query'>
		<cfset terCount=''>
    <cfquery name='terCount' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from student_assessment where assessment_area = 'TER' 
		</cfquery>    
		<cfreturn terCount>
	</cffunction>

	<!--- Get the number of baseline TERs currently in the system --->
	<cffunction name='getBaselineCount' access='public' returntype='query'>
		<cfset baselineCount=''>
    <cfquery name='baselineCount' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from student_assessment where assessment_area = 'TER' and assessment_type = 'Baseline' 
		</cfquery>    
		<cfreturn baselineCount>
	</cffunction>

	<!--- Get the number of capstone TERs currently in the system --->
	<cffunction name='getCapstoneCount' access='public' returntype='query'>
		<cfset capstoneCount=''>
    <cfquery name='capstoneCount' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from student_assessment where assessment_area = 'TER' and assessment_type = 'Capstone' 
		</cfquery>    
		<cfreturn capstoneCount>
	</cffunction>

	<!--- Get the number of students with both a baseline and a capstone --->
	<cffunction name='getMeasureableCount' access='public' returntype='query'>
		<cfset studentCount=''>
    <cfquery name='studentCount' datasource='#Application.Settings.IEIR_RO#'>
			select count(*) as count from student_assessment
				where assessment_area = 'TER' 
					and assessment_type = 'Baseline'
					and student in
						(select student from vw_ter_completers_1)
		</cfquery>    
		<cfreturn studentCount>
	</cffunction>

	<!--- Get all Start Terms with students having both baseline and capstone TER Scores --->
  <cffunction name='getMeasureableCohorts' access='public' returntype='array'>
  	<cfset cohorts=''>
    <cfquery name='cohorts' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(cohort), start_term, count(student_id) as students from student_ident
					where cohort >= #Application.Settings.TERStartTerm# and
						student_id in (select * from vw_ter_completers_0)
					and
						student_id in (select * from vw_ter_completers_1)
					group by cohort
		</cfquery>
    <cfset cohortInfo = ArrayNew(1)>
    <cfif cohorts.RecordCount>
      <cfset arrayPos = 1>
    	<cfloop query='cohorts'>
      	<cfset tempCohort = StructNew()>
        <cfset tempCohort.cohort = cohorts.start_term>
        <cfset tempCohort.students = cohorts.students>
        <cfquery name='cohortSize' datasource='#Application.Settings.IEIR_RO#'>
        	select count(*) as cohortSize from student_ident where cohort = #cohorts.cohort#
        </cfquery>
        <cfset tempCohort.cohortSize = cohortSize.cohortSize>
        <cfquery name='grads' datasource='#Application.Settings.IEIR_RO#'>
        	select count(student_id) as gradStudents from stu_awards where student_id in
          	(select student_id from student_ident where cohort = #cohorts.cohort#)
        </cfquery>
        <cfset tempCohort.grads = grads.gradStudents>
        <cfset cohortInfo[arrayPos] = tempCohort>
        <cfset arrayPos += 1>
       </cfloop>
      </cfif>
    <cfreturn cohortInfo>
  </cffunction>

	<!--- Get all Start Terms with students having a baseline TER Score --->
  <cffunction name='getBaselineCohorts' access='public' returntype='array'>
  	<cfset cohorts=''>
    <cfquery name='cohorts' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(cohort), start_term, count(student_id) as baselines from student_ident
					where cohort >= #Application.Settings.TERStartTerm# and
						student_id in (select student from vw_ter_completers_0)
					group by cohort
		</cfquery>
    <cfset baselineInfo = ArrayNew(1)>
    <cfif cohorts.RecordCount>
      <cfset arrayPos = 1>
      <cfset totStudents = 0>
      <cfset totBaselines = 0>
    	<cfloop query='cohorts'>
      	<cfset tempCohort = StructNew()>
        <cfset tempCohort.cohort = cohorts.start_term>
        <cfset tempCohort.baselines = cohorts.baselines>
        <cfquery name='cohortSize' datasource='#Application.Settings.IEIR_RO#'>
        	select count(*) as cohortSize from student_ident where cohort = #cohorts.cohort#
        </cfquery>
        <cfset tempCohort.cohortSize = cohortSize.cohortSize>
        <cfset tempCohort.ratio = DecimalFormat((cohorts.baselines / cohortSize.cohortSize))>
        <cfset baselineInfo[arrayPos] = tempCohort>
        <cfset totStudents = totStudents + cohortSize.cohortSize>
        <cfset totBaselines = totBaselines + cohorts.baselines>
        <cfset arrayPos += 1>
       </cfloop>
       <cfset totCohort = StructNew()>
       <cfset totCohort.cohort = 'Totals'>
       <cfset totCohort.baselines = totBaselines>
       <cfset totCohort.cohortSize = totStudents>
       <cfset totCohort.ratio = DecimalFormat((totBaselines / totStudents))>
       <cfset baselineInfo[arrayPos] = totCohort>
      </cfif>
    <cfreturn baselineInfo>
  </cffunction>

	<!--- Get all Start Terms with students having a capstone TER Score --->
  <cffunction name='getCapstoneCohorts' access='public' returntype='array'>
  	<cfset cohorts=''>
    <cfquery name='cohorts' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(cohort), start_term, count(student_id) as capstones from student_ident
					where cohort >= #Application.Settings.TERStartTerm# and
						student_id in (select student from vw_ter_completers_1)
					group by cohort
		</cfquery>
    <cfset capstoneInfo = ArrayNew(1)>
    <cfif cohorts.RecordCount>
      <cfset arrayPos = 1>
      <cfset totStudents = 0>
      <cfset totCapstones = 0>
    	<cfloop query='cohorts'>
      	<cfset tempCohort = StructNew()>
        <cfset tempCohort.cohort = cohorts.start_term>
        <cfset tempCohort.capstones = cohorts.capstones>
        <cfquery name='cohortSize' datasource='#Application.Settings.IEIR_RO#'>
        	select count(*) as cohortSize from student_ident where cohort = #cohorts.cohort#
        </cfquery>
        <cfset tempCohort.cohortSize = cohortSize.cohortSize>
        <cfset tempCohort.ratio = DecimalFormat((cohorts.capstones / cohortSize.cohortSize))>
        <cfset capstoneInfo[arrayPos] = tempCohort>
        <cfset totStudents = totStudents + cohortSize.cohortSize>
        <cfset totCapstones = totCapstones + cohorts.capstones>
        <cfset arrayPos += 1>
       </cfloop>
       <cfset totCohort = StructNew()>
       <cfset totCohort.cohort = 'Totals'>
       <cfset totCohort.capstones = totCapstones>
       <cfset totCohort.cohortSize = totStudents>
       <cfset totCohort.ratio = DecimalFormat((totCapstones / totStudents))>
       <cfset capstoneInfo[arrayPos] = totCohort>
      </cfif>
    <cfreturn capstoneInfo>
  </cffunction>
  
	<!--- Get the number of graduates and the terms for each term since we began administering the capstone TER --->
  <!--- For each of these sets, pull the number of grads with a capstone TER and return that too. --->
  <cffunction name='getTerTermGrads' access='public' returntype='array'>
  	<cfset terGrads=''>
    <cfquery name='terGrads' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(a.term), count(a.student_id) as students, b.cohort from stu_awards a, year_terms b
      	where concat('20',a.term) in (select term from vw_grad_terms_ter) and
          concat('20',a.term) = b.term
        group by a.term
        order by b.cohort
		</cfquery>
    <cfset gradInfo = ArrayNew(1)>
    <cfif terGrads.RecordCount>
      <cfset arrayPos = 1>
    	<cfloop query='terGrads'>
      	<cfset tempGrads = StructNew()>
        <cfset tempGrads.term = terGrads.term>
        <cfset tempGrads.students = terGrads.students>
        <cfset tempGrads.cohort = terGrads.cohort>
        <cfquery name='gradCapstones' datasource='#Application.Settings.IEIR_RO#'>
        	select count(*) as capstones from student_assessment 
          	where assessment_area = 'TER' and assessment_type = 'Capstone'
            and student in (select student_id from stu_awards where term = '#terGrads.term#')
        </cfquery>
        <cfset tempGrads.capstones = gradCapstones.capstones>
        <cfset tempGrads.ratio = DecimalFormat((gradCapstones.capstones / terGrads.students))>
        <cfset gradInfo[arrayPos] = tempGrads>
        <cfset arrayPos += 1>
       </cfloop>
      </cfif>
    <cfreturn gradInfo>
  </cffunction>
        		
</cfcomponent>