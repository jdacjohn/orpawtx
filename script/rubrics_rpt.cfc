<cfcomponent>
	
	<!--- Get the number of rubrics currently in the system --->
	<cffunction name='getRubricCount' access='public' returntype='query'>
		<cfset rubricCount=''>
    <cfquery name='rubricCount' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from student_assessment where assessment_area = 'Rubric' 
		</cfquery>    
		<cfreturn rubricCount>
	</cffunction>

	<!--- Get the number of baseline rubrics currently in the system --->
	<cffunction name='getBaselineCount' access='public' returntype='query'>
		<cfset baselineCount=''>
    <cfquery name='baselineCount' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from student_assessment where assessment_area = 'Rubric' and assessment_type = 'Baseline' 
		</cfquery>    
		<cfreturn baselineCount>
	</cffunction>

	<!--- Get the number of capstone rubrics currently in the system --->
	<cffunction name='getCapstoneCount' access='public' returntype='query'>
		<cfset capstoneCount=''>
    <cfquery name='capstoneCount' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from student_assessment where assessment_area = 'Rubric' and assessment_type = 'Capstone' 
		</cfquery>    
		<cfreturn capstoneCount>
	</cffunction>

	<!--- Get the number of students with both a baseline and a capstone --->
	<cffunction name='getMeasureableCount' access='public' returntype='query'>
		<cfset studentCount=''>
    <cfquery name='studentCount' datasource='#Application.Settings.IEIR_RO#'>
			select count(*) as count from student_assessment
				where assessment_area = 'Rubric' 
					and assessment_type = 'Baseline'
					and student in
						(select student from vw_rubrics_completers_1)
		</cfquery>    
		<cfreturn studentCount>
	</cffunction>

	<!--- Get all Start Terms with students having both baseline and capstone rubrics --->
  <cffunction name='getMeasureableCohorts' access='public' returntype='array'>
  	<cfset cohorts=''>
    <cfquery name='cohorts' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(cohort) as cohort, start_term, count(student_id) as students from student_ident
					where cohort >= #Application.Settings.RubricStartTerm# and
						student_id in (select * from vw_rubrics_completers_0)
					and
						student_id in (select * from vw_rubrics_completers_1)
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

	<!--- Get the cohort size, # of grads and # of QEP reportable for a given cohort and student type --->
  <!--- Student Type can be either Cert or AAS --->
  <cffunction name='getQEPCounts' access='public' returntype='struct'>
    <cfargument name='cohortNo' type='numeric' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfargument name='degreeType' type='string' required='yes'>
  	<cfset qepReportable=''>
    <!--- Get the number of qep reportable in the starting cohort of the specified type --->
    <cfquery name='qepReportable' datasource='#Application.Settings.IEIR_RO#'>
			select count(student_id) as students from student_ident
					where cohort = #cohortNo# and
          			student_id in 
                	(select distinct(id_no) from student_terms 
                  	where rpt_term = substr('#term#',3) and active_prog like '%#degreeType#%') and
								student_id in (select * from vw_rubrics_completers_0) and
								student_id in (select * from vw_rubrics_completers_1)
		</cfquery>
    <!--- Get the size of the cohort for the given degree Type --->
    <cfset cohortSize=''>
    <cfquery name='cohortSize' datasource='#Application.Settings.IEIR_RO#'>
    	select count(student_id) as students from student_ident
				where cohort = #cohortNo# and
							student_id in
								(select distinct(id_no) from student_terms where rpt_term = substr('#term#',3) and active_prog like '%#degreeType#%')
		</cfquery>
    <!--- Get the number of those degree seekers who have graduated --->
		<cfset grads=''>
    <cfquery name='grads' datasource='#Application.Settings.IEIR_RO#'>
    	select count(student_id) as gradStudents from stu_awards where student_id in
      	(select student_id from student_ident where cohort = #cohortNo# and
        	student_id in (select distinct(id_no) from student_terms where rpt_term = substr('#term#',3) and
          									active_prog like '%#degreeType#%'))
    </cfquery>
    <cfset cohortInfo = StructNew()>
    <cfset cohortInfo.degree = '#degreeType#'>
		<cfif qepReportable.RecordCount>
    	<cfset cohortInfo.qepReportable = qepReportable.students>
    <cfelse>
    	<cfset cohortInfo.qepReportable = 0>
    </cfif>
    <cfif cohortSize.RecordCount>
    	<cfset cohortInfo.cohortSize = cohortSize.students>
    <cfelse>
    	<cfset cohortInfo.students = 0>
    </cfif>
    <cfif grads.RecordCount>
    	<cfset cohortInfo.grads = grads.gradStudents>
    <cfelse>
    	<cfset cohortInfo.grads = 0>
    </cfif>
    <cfreturn cohortInfo>
  </cffunction>

	<!--- Get the cohort size, # of grads and # of QEP baselines for a given cohort and student type --->
  <!--- Student Type can be either Cert or AAS --->
  <cffunction name='getQEPBaselineCounts' access='public' returntype='struct'>
    <cfargument name='cohortNo' type='numeric' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfargument name='degreeType' type='string' required='yes'>
  	<cfset qepBaselines=''>
    <!--- Get the number of qep baselines in the starting cohort of the specified type --->
    <cfquery name='qepBaselines' datasource='#Application.Settings.IEIR_RO#'>
			select count(student_id) as students from student_ident
					where cohort = #cohortNo# and
          			student_id in 
                	(select distinct(id_no) from student_terms 
                  	where rpt_term = substr('#term#',3) and active_prog like '%#degreeType#%') and
								student_id in (select * from vw_rubrics_completers_0)
		</cfquery>
    <!--- Get the size of the cohort for the given degree Type --->
    <cfset cohortSize=''>
    <cfquery name='cohortSize' datasource='#Application.Settings.IEIR_RO#'>
    	select count(student_id) as students from student_ident
				where cohort = #cohortNo# and
							student_id in
								(select distinct(id_no) from student_terms where rpt_term = substr('#term#',3) and active_prog like '%#degreeType#%')
		</cfquery>
    <cfset baselineInfo = StructNew()>
    <cfset baselineInfo.degree = '#degreeType#'>
		<cfif qepBaselines.RecordCount>
    	<cfset baselineInfo.qepBaselines = qepBaselines.students>
    <cfelse>
    	<cfset baselineInfo.qepBaselines = 0>
    </cfif>
    <cfif cohortSize.RecordCount>
    	<cfset baselineInfo.cohortSize = cohortSize.students>
    <cfelse>
    	<cfset baselineInfo.students = 0>
    </cfif>
    <cfif baselineInfo.cohortSize gt 0>
    	<cfset baselineInfo.ratio = DecimalFormat(qepBaselines.students / cohortSize.students)>
    <cfelse>
    	<cfset baselineInfo.ratio = DecimalFormat(0)>
    </cfif>
    <cfreturn baselineInfo>
  </cffunction>

	<!--- Get the cohort size, # of grads and # of QEP baselines for a given cohort and student type --->
  <!--- Student Type can be either Cert or AAS --->
  <cffunction name='getQEPCapstoneCounts' access='public' returntype='struct'>
    <cfargument name='cohortNo' type='numeric' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfargument name='degreeType' type='string' required='yes'>
  	<cfset qepCapstones=''>
    <!--- Get the number of qep baselines in the starting cohort of the specified type --->
    <cfquery name='qepCapstones' datasource='#Application.Settings.IEIR_RO#'>
			select count(student_id) as students from student_ident
					where cohort = #cohortNo# and
          			student_id in 
                	(select distinct(id_no) from student_terms 
                  	where rpt_term = substr('#term#',3) and active_prog like '%#degreeType#%') and
								student_id in (select * from vw_rubrics_completers_1)
		</cfquery>
    <!--- Get the size of the cohort for the given degree Type --->
    <cfset cohortSize=''>
    <cfquery name='cohortSize' datasource='#Application.Settings.IEIR_RO#'>
    	select count(student_id) as students from student_ident
				where cohort = #cohortNo# and
							student_id in
								(select distinct(id_no) from student_terms where rpt_term = substr('#term#',3) and active_prog like '%#degreeType#%')
		</cfquery>
    <cfset capstoneInfo = StructNew()>
    <cfset capstoneInfo.degree = '#degreeType#'>
		<cfif qepCapstones.RecordCount>
    	<cfset capstoneInfo.qepCapstones = qepCapstones.students>
    <cfelse>
    	<cfset capstoneInfo.qepCapstones = 0>
    </cfif>
    <cfif cohortSize.RecordCount>
    	<cfset capstoneInfo.cohortSize = cohortSize.students>
    <cfelse>
    	<cfset capstoneInfo.students = 0>
    </cfif>
    <cfif capstoneInfo.cohortSize gt 0>
    	<cfset capstoneInfo.ratio = DecimalFormat(qepCapstones.students / cohortSize.students)>
    <cfelse>
    	<cfset capstoneInfo.ratio = DecimalFormat(0)>
    </cfif>
    <cfreturn capstoneInfo>
  </cffunction>

	<!--- Get all Start Terms with students having a baseline Rubric in the system --->
  <cffunction name='getBaselineCohorts' access='public' returntype='array'>
  	<cfset cohorts=''>
    <cfquery name='cohorts' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(cohort), start_term, count(student_id) as baselines from student_ident
					where cohort >= #Application.Settings.RubricStartTerm# and
						student_id in (select student from vw_rubrics_completers_0)
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

	<!--- Get all Start Terms with students having a capston Rubric in the system --->
  <cffunction name='getCapstoneCohorts' access='public' returntype='array'>
  	<cfset cohorts=''>
    <cfquery name='cohorts' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(cohort), start_term, count(student_id) as capstones from student_ident
					where cohort >= #Application.Settings.RubricStartTerm# and
						student_id in (select student from vw_rubrics_completers_1)
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
  <cffunction name='getRubricTermGrads' access='public' returntype='array'>
  	<cfset rubGrads=''>
    <cfquery name='rubGrads' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(a.term), count(a.student_id) as students, b.cohort from stu_awards a, year_terms b
      	where concat('20',a.term) in (select term from vw_grad_terms_rubric) and
          concat('20',a.term) = b.term
        group by a.term
        order by b.cohort
		</cfquery>
    <cfset gradInfo = ArrayNew(1)>
    <cfif rubGrads.RecordCount>
      <cfset arrayPos = 1>
    	<cfloop query='rubGrads'>
      	<cfset tempGrads = StructNew()>
        <cfset tempGrads.term = rubGrads.term>
        <cfset tempGrads.students = rubGrads.students>
        <cfquery name='gradCapstones' datasource='#Application.Settings.IEIR_RO#'>
        	select count(*) as capstones from student_assessment 
          	where assessment_area = 'Rubric' and assessment_type = 'Capstone'
            and student in (select student_id from stu_awards where term = '#rubGrads.term#')
        </cfquery>
        <cfset tempGrads.capstones = gradCapstones.capstones>
        <cfset tempGrads.ratio = DecimalFormat((gradCapstones.capstones / rubGrads.students))>
        <cfset gradInfo[arrayPos] = tempGrads>
        <cfset arrayPos += 1>
       </cfloop>
      </cfif>
    <cfreturn gradInfo>
  </cffunction>
  
	<!--- Get the cohorts for which we have both baseline and capstone rubrics --->
  <cffunction name='getQEPReportableCohorts' access='public' returntype='query'>
  	<cfset cohorts=''>
    <cfquery name='cohorts' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(a.cohort), b.term from student_ident a, year_terms b
      	where a.cohort >= #Application.Settings.RubricStartTerm# and
        			a.student_id in (select * from vw_rubrics_completers_0) and
              a.student_id in (select * from vw_rubrics_completers_1) and
              a.cohort = b.cohort
        order by a.cohort
		</cfquery>
    <cfreturn cohorts>
  </cffunction>
  
	<!--- Get the cohorts for which we have baseline rubrics --->
  <cffunction name='getQEPBaselineCohorts' access='public' returntype='query'>
  	<cfset baselineCohorts=''>
    <cfquery name='baselineCohorts' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(a.cohort), b.term from student_ident a, year_terms b
      	where a.cohort >= #Application.Settings.RubricStartTerm# and
        			a.student_id in (select * from vw_rubrics_completers_0) and
              a.cohort = b.cohort
        order by a.cohort
		</cfquery>
    <cfreturn baselineCohorts>
  </cffunction>

	<!--- Get the cohorts for which we have Capstone rubrics --->
  <cffunction name='getQEPCapstoneCohorts' access='public' returntype='query'>
  	<cfset capstoneCohorts=''>
    <cfquery name='capstoneCohorts' datasource='#Application.Settings.IEIR_RO#'>
			select distinct(a.cohort), b.term from student_ident a, year_terms b
      	where a.cohort >= #Application.Settings.RubricStartTerm# and
        			a.student_id in (select * from vw_rubrics_completers_1) and
              a.cohort = b.cohort
        order by a.cohort
		</cfquery>
    <cfreturn capstoneCohorts>
  </cffunction>
  
  <!--- Populate the Rubrics Results Table for the given assessment type. --->
  <cffunction name='popBaselineRubricResults' access='public' returnType='numeric'>
    <cfset q_result = 0>
    <cfset getsids=''>
    <cfquery result='clearit' datasource='#Application.Settings.IEIR#'>
    	update rubric_results set pre_n = 0, pre_total = 0
    </cfquery>
    <cfquery name='getsids' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(sid) as sid from student_assessment where assessment_area = 'Rubric' and assessment_type = 'Baseline'
    </cfquery>
    <cfloop query='getsids'>
    	<cfset getRubrics=''>
      <cfquery name='getRubrics' datasource='#Application.Settings.IEIR_RO#'>
      	select distinct(rubric_id) as rid from assessment_ratings where assessment_id = #getsids.sid#
      </cfquery>
      <cfset getMeasures=''>
      <cfquery name='getMeasures' datasource='#Application.Settings.IEIR_RO#'>
      	select measures from rubric_results where rubric = #getRubrics.rid#
      </cfquery>
      <cfloop query='getRubrics'>
      	<cfset getRatingSum=''>
      	<cfquery name='getRatingSum' datasource='#Application.Settings.IEIR_RO#'>
        	select sum(rating) as score from assessment_ratings where assessment_id = #getsids.sid# and rubric_id = #getRubrics.rid#
        </cfquery>
      	<cfquery result='updateMeasuresResult' datasource='#Application.Settings.IEIR#'>
        	update rubric_results
          	set pre_n = pre_n +1, pre_total = pre_total + #(getRatingSum.score / getMeasures.measures)#
           	where rubric = #getRubrics.rid#
        </cfquery>
      </cfloop>
    </cfloop>
    <cfreturn q_result>
  </cffunction>
        		
  <!--- Populate the Rubrics Results Table for the given assessment type. --->
  <cffunction name='popIntermediateRubricResults' access='public' returnType='numeric'>
    <cfset q_result = 0>
    <cfset getsids=''>
    <cfquery result='clearit' datasource='#Application.Settings.IEIR#'>
    	update rubric_results set int_n = 0, int_total = 0
    </cfquery>
    <cfquery name='getsids' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(sid) as sid from student_assessment where assessment_area = 'Rubric' and assessment_type = 'Intermediate'
    </cfquery>
    <cfloop query='getsids'>
    	<cfset getRubrics=''>
      <cfquery name='getRubrics' datasource='#Application.Settings.IEIR_RO#'>
      	select distinct(rubric_id) as rid from assessment_ratings where assessment_id = #getsids.sid#
      </cfquery>
      <cfset getMeasures=''>
      <cfquery name='getMeasures' datasource='#Application.Settings.IEIR_RO#'>
      	select measures from rubric_results where rubric = #getRubrics.rid#
      </cfquery>
      <cfloop query='getRubrics'>
      	<cfset getRatingSum=''>
      	<cfquery name='getRatingSum' datasource='#Application.Settings.IEIR_RO#'>
        	select sum(rating) as score from assessment_ratings where assessment_id = #getsids.sid# and rubric_id = #getRubrics.rid#
        </cfquery>
      	<cfquery result='updateMeasuresResult' datasource='#Application.Settings.IEIR#'>
        	update rubric_results
          	set int_n = int_n +1, int_total = int_total + #(getRatingSum.score / getMeasures.measures)#
           	where rubric = #getRubrics.rid#
        </cfquery>
      </cfloop>
    </cfloop>
    <cfreturn q_result>
  </cffunction>
        		
  <!--- Populate the Rubrics Results Table for the given assessment type. --->
  <cffunction name='popCapstoneRubricResults' access='public' returnType='numeric'>
    <cfset q_result = 0>
    <cfset getsids=''>
    <cfquery result='clearit' datasource='#Application.Settings.IEIR#'>
    	update rubric_results set post_n = 0, post_total = 0
    </cfquery>
    <cfquery name='getsids' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(sid) as sid from student_assessment where assessment_area = 'Rubric' and assessment_type = 'Capstone'
    </cfquery>
    <cfloop query='getsids'>
    	<cfset getRubrics=''>
      <cfquery name='getRubrics' datasource='#Application.Settings.IEIR_RO#'>
      	select distinct(rubric_id) as rid from assessment_ratings where assessment_id = #getsids.sid#
      </cfquery>
      <cfset getMeasures=''>
      <cfquery name='getMeasures' datasource='#Application.Settings.IEIR_RO#'>
      	select measures from rubric_results where rubric = #getRubrics.rid#
      </cfquery>
      <cfloop query='getRubrics'>
      	<cfset getRatingSum=''>
      	<cfquery name='getRatingSum' datasource='#Application.Settings.IEIR_RO#'>
        	select sum(rating) as score from assessment_ratings where assessment_id = #getsids.sid# and rubric_id = #getRubrics.rid#
        </cfquery>
      	<cfquery result='updateMeasuresResult' datasource='#Application.Settings.IEIR#'>
        	update rubric_results
          	set post_n = post_n +1, post_total = post_total + #(getRatingSum.score / getMeasures.measures)#
           	where rubric = #getRubrics.rid#
        </cfquery>
      </cfloop>
    </cfloop>
    <cfreturn q_result>
  </cffunction>
        		
</cfcomponent>