<cfcomponent>
	<!--- Insert a Rubric into the student_assessment table. --->
	<cffunction name='insertRubric' access='public' returntype='struct'>
		<cfargument name='studentId' type='numeric' required='yes'>
    <cfargument name='assessmentType' type='string' required='yes'>
    <cfargument name='assessmentDate' type='string' required='yes'>
    <cfargument name='comments' type='string' required='yes'>
    <cfset assessment=''>
    <cfset add_opr = Session.UserID>
    <cfset term_seq = ''>
    <cfset stu_cohort = ''>
    <!--- Get the cohort number for the term that the assessment was created --->
    <cfquery name='term_seq' datasource='#Application.Settings.IEIR_RO#'>
    	select cohort from year_terms 
      	where start_date <= '#assessmentDate#' and
              end_date >= '#assessmentDate#'
    </cfquery>
		<cfif term_seq.cohort eq ''>
			<cfset adj_assessmentDate = assessmentDate>
			<cfset adj_assessmentDate = ReplaceList(adj_assessmentDate,'/','-')>
    	<cfloop condition = "term_seq.cohort eq ''">
    		<cfset adj_assessmentDate = DateFormat(DateAdd("d",-1,adj_assessmentDate), "yyyy-mm-dd")>
				<!--- Try to get the cohort number for the term that the assessment was created --->
        <cfquery name='term_seq' datasource='#Application.Settings.IEIR_RO#'>
          select cohort from year_terms 
            where start_date <= '#adj_assessmentDate#' and
                  end_date >= '#adj_assessmentDate#'
        </cfquery>
      </cfloop>
    </cfif>
    
    <cfquery name='stu_cohort' datasource='#Application.Settings.IEIR_RO#'>
    	select cohort from student_ident
      	where student_id = #studentId#
    </cfquery>
    
    <cfset semester = term_seq.cohort - stu_cohort.cohort + 1>
    <cfquery result='assessment' datasource='#Application.Settings.IEIR#'>
    	insert into student_assessment values(null,#studentId#,'#assessmentType#','Rubric',DATE('#assessmentDate#'),#semester#,'#comments#','#add_opr#',NOW(),null,null)
		</cfquery>    
		<cfreturn assessment>
	</cffunction>
  
	<!--- Insert a rating associated with an assessment into the assessment_ratings table. --->
	<cffunction name='insertRating' access='public' returntype='struct'>
		<cfargument name='assessmentId' type='numeric' required='yes'>
    <cfargument name='rubricId' type='numeric' required='yes'>
    <cfargument name='compClassId' type='numeric' required='yes'>
    <cfargument name='compId' type='numeric' required='yes'>
    <cfargument name='rating' type='numeric' required='yes'>
		<cfset ratingInsertResult=''>
    <cfquery result='ratingInsertResult' datasource='#Application.Settings.IEIR#'>
    	insert into assessment_ratings values(#assessmentId#,#rubricId#,#compClassId#,#compId#,#rating#,null)
		</cfquery>    
		<cfreturn ratingInsertResult>
	</cffunction>

	<!--- Get all assessments of the given assessment area for the given student --->
  <cffunction name='getAssessments' access='public' returntype='query'>
  	<cfargument name='studentId' type='numeric' required='yes'>
    <cfargument name='assessmentArea' type='string' required='yes'>
    <cfset assessments=''>
    <cfquery name='assessments' datasource='#Application.Settings.IEIR_RO#'>
    	select sid, student, assessment_type, assessment_area, assessment_date, semester, comments
        from student_assessment
        where student = #studentId# and assessment_area = '#assessmentArea#'
        order by assessment_date
    </cfquery>
    <cfreturn assessments>
  </cffunction>

	<!--- Get the assessment information for the given assessment id --->
  <cffunction name='getAssessment' access='public' returntype='query'>
  	<cfargument name='sid' type='numeric' required='yes'>
    <cfset assessments=''>
    <cfquery name='assessment' datasource='#Application.Settings.IEIR_RO#'>
    	select sid, student, assessment_type, assessment_area, assessment_date, semester, comments
        from student_assessment
        where sid = #sid#
    </cfquery>
    <cfreturn assessment>
  </cffunction>
  
  <!--- Get the rubrics for the given assessment --->
  <cffunction name='getRubrics' access='public' returntype='query'>
  	<cfargument name='sid' type='numeric' required='yes'>
    <cfset rubrics=''>
    <cfquery name='rubrics' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(rubric_id)
      	from assessment_ratings
        where assessment_id = #sid#
        order by rubric_id
    </cfquery>
    <cfreturn rubrics>
  </cffunction>
  
  <!--- Get the comp class ids for the given assessment and rubric --->
  <cffunction name='getCompClasses' access='public' returntype='query'>
  	<cfargument name='sid' type='numeric' required='yes'>
    <cfargument name='rid' type='numeric' required='yes'>
    <cfset classes=''>
    <cfquery name='classes' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(comp_class_id)
      	from assessment_ratings
        where assessment_id = #sid# and rubric_id = #rid#
        order by comp_class_id
    </cfquery>
    <cfreturn classes>
  </cffunction>
  
  <!--- Get the competency ids for a given assessment, rubric, and comp class --->
  <cffunction name='getComps' access='public' returntype='query'>
  	<cfargument name='sid' type='numeric' required='yes'>
    <cfargument name='rid' type='numeric' required='yes'>
    <cfargument name='compClass' type='numeric' required='yes'>
    <cfset comps=''>
    <cfquery name='comps' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(competency_id)
      	from assessment_ratings
        where assessment_id = #sid# and rubric_id = #rid# and comp_class_id = #compClass#
        order by competency_id
    </cfquery>
    <cfreturn comps>
  </cffunction>
  
  <!--- Get the rating for a given assessment, rubric, comp class, and competency --->
  <cffunction name='getRating' access='public' returntype='query'>
  	<cfargument name='sid' type='numeric' required='yes'>
    <cfargument name='rid' type='numeric' required='yes'>
    <cfargument name='compClass' type='numeric' required='yes'>
    <cfargument name='comp' type='numeric' required='yes'>
    <cfset compRating=''>
    <cfquery name='compRating' datasource='#Application.Settings.IEIR_RO#'>
    	select rating
      	from assessment_ratings
        where assessment_id = #sid# and rubric_id = #rid# and comp_class_id = #compClass# and competency_id = #comp#
    </cfquery>
    <cfreturn compRating>
  </cffunction>
  
  	
  <!--- Get the ratings for the given assessment --->
  <cffunction name='getRatings' access='public' returntype='query'>
  	<cfargument name='sid' type='numeric' required='yes'>
    <cfset ratings=''>
    <cfquery name='ratings' datasource='#Application.Settings.IEIR_RO#'>
    	select rubric_id, comp_class_id, competency_id, rating, comments
      	from assessment_ratings
        where assessment_id = #sid#
        order by rubric_id, comp_class_id, competency_id
    </cfquery>
    <cfreturn ratings>
  </cffunction>
  
</cfcomponent>