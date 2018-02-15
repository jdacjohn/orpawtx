<cfcomponent>
	
	<!--- get the number of completed assessments for a group. --->
  <cffunction name='countAssessments' access="public" returnType="query">
  	<cfargument name='groupId' type='numeric' required='yes'>
    <cfset assessments=''>
    <cfquery name="assessments" datasource="#Application.Settings.IEIR_RO#">
    	select count(*) as count from loassessment where loa_group_id = #groupId#
    </cfquery>
    <cfreturn assessments>
  </cffunction>
  
	<!--- Get the number of mappings for a Learning Outcome. --->
	<cffunction name='countLOMappings' access='public' returntype='numeric'>
		<cfargument name='loid' type='numeric' required='yes'>
    <cfargument name='cmid' type='numeric' required='yes'>
		<cfset mappings=''>
    <cfquery name='mappings' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as mapCount from cmCourseSection where loid = #loid# and cmid = #cmid#
		</cfquery>    
		<cfreturn mappings.mapCount>
	</cffunction>

	<!--- Get the number of measurement activities for a Learning Outcome. --->
	<cffunction name='countMeasures' access='public' returntype='numeric'>
		<cfargument name='loid' type='numeric' required='yes'>
		<cfset measures=''>
    <cfquery name='measures' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as measureCount from lomeasurement where loid = #loid#
		</cfquery>
		<cfreturn measures.measureCount>
	</cffunction>

  <!--- Delete a learning outcome measurement activity from the system. --->
  <cffunction name='deleteLOM' access='public'>
  	<cfargument name='lomid' type='numeric' required='yes'>
    <cfargument name='loid' type='numeric' required='yes'>
    <cfset lom = ''>
    <cfquery name='lom' datasource='#Application.Settings.IEIR_RO#'>
    	select measureNum from lomeasurement where lomid = #lomid#
    </cfquery>
		<cfset qresult = ''>
    <cfquery result='qresult' datasource='#Application.Settings.IEIR#'>
    	delete from lomeasurement where lomid = #lomid#
		</cfquery>
    <!--- Now adjust the measurement numbers on the remaining measurement activities belonging to
					the measurement so subsequent adds will not duplicate an existing measurement number. --->
    <cfset res2 = ''>
    <cfquery result='res2' datasource='#Application.Settings.IEIR#'>
    	update lomeasurement set measureNum = (measureNum -1) where loid = #loid# and measureNum > #lom.measureNum#
    </cfquery>
  </cffunction>    

  <!--- Delete a learning outcome to course mapping from the system. --->
  <cffunction name='deleteMapping' access='public'>
  	<cfargument name='mapid' type='numeric' required='yes'>
		<cfset qresult = ''>
    <cfquery result='qresult' datasource='#Application.Settings.IEIR#'>
    	delete from cmcoursesection where mapid = #mapid#
		</cfquery>
  </cffunction>    

  <!--- Get an assignment group by its id --->
  <cffunction name='getAG' access='public' returyType='query'>
  	<cfargument name='agId' type='numeric' required='yes'>
    <cfset aGroup=''>
    <cfquery name='aGroup' datasource='#Application.Settings.IEIR_RO#'>
    	select loa_group_id, loid, prog_id, class, course_id, lo_level, term, instr_lname, instr_fname
      	from lo_assessment_group where loa_group_id = #agId#
    </cfquery>
    <cfreturn aGroup>
  </cffunction>    

  <!--- Get all terms for which Learning Outcome Assessment Groups exist for a program. --->
  <cffunction name='getAGTerms' access='public' returyType='query'>
  	<cfargument name='progId' type='numeric' required='yes'>
    <cfset terms=''>
    <cfquery name='terms' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(term) as agTerm from lo_assessment_group where prog_id = #progId#
    </cfquery>
    <cfreturn terms>
  </cffunction>    

  <!--- Get an assessment from the system. --->
  <cffunction name='getAssessment' access='public' returntype='query'>
  	<cfargument name='loaid' type='numeric' required='yes'>
    <cfset assessment=''>
    <cfquery name='assessment' datasource='#Application.Settings.IEIR_RO#'>
    	select loa_id, loa_group_id,term,loaDate,student,student_lname,student_fname,loaType,loid,add_op
      	from loassessment
        where loa_id = #loaid#
    </cfquery>
    <cfreturn assessment>
  </cffunction>
  
  <!--- Get the individual measurement ratings for an assessment --->
  <cffunction name='getAssessmentRatings' access='public' returnType='query'>
  	<cfargument name='loaid' type='numeric' required='yes'>
    <cfset ratings=''>
    <cfquery name='ratings' dataSource='#Application.Settings.IEIR_RO#'>
    	select lomid as measureId, lomrid as ratingId, loarScore as score, loarComments as comments
      	from loAssessmentRating
        where loaid = #loaid#
        order by lomid
    </cfquery>
    <cfreturn ratings>
  </cffunction>
	
  <!--- Get all LO assessment results for a term and program. --->
  <cffunction name='getAssignmentResults' access='public' returnType='query'>
  	<cfargument name='progId' type='numeric' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfset aGroups=''>
    <cfquery name='aGroups' datasource='#Application.Settings.IEIR_RO#'>
    	select loa_group_id, loid, class, lo_level, enrolled, group_exp, instr_lname, instr_fname, instr_email from lo_assessment_group 
      	where prog_id = #progId# and term = '#term#'
        order by loid, lo_level, class
    </cfquery>
    <cfreturn aGroups>
  </cffunction>    

  <!--- Get all LO assessment groups for a term and program. --->
  <cffunction name='getAssignments' access='public' returnType='query'>
  	<cfargument name='progId' type='numeric' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfset aGroups=''>
    <cfquery name='aGroups' datasource='#Application.Settings.IEIR_RO#'>
    	select loa_group_id, loid, class, lo_level, enrolled, group_exp from lo_assessment_group 
      	where prog_id = #progId# and term = '#term#'
        order by class, loid, lo_level
    </cfquery>
    <cfreturn aGroups>
  </cffunction>    

	<!--- Get the measurement ratings (criteria) for a measurement activity. --->
	<cffunction name='getCriteria' access='public' returntype='query'>
		<cfargument name='lomid' type='numeric' required='yes'>
		<cfset criteria=''>
    <cfquery name='criteria' datasource='#Application.Settings.IEIR_RO#'>
    	select lomrid, lomrscore, lomrDescription from lomeasurementrating where lomid = #lomid# order by lomrScore
		</cfquery>
		<cfreturn criteria>
	</cffunction>

	<!--- Get the assessment levels for a rubric, an outcome and a map. --->
	<cffunction name='getLevels' access='public' returntype='query'>
    <cfargument name='outcome' type='numeric' required='yes'>
    <cfargument name='rubric' type='string' required='yes'>
    <cfargument name='map' type='numeric' required='yes'>
		<cfset levels=''>
    <cfquery name='levels' datasource='#Application.Settings.IEIR_RO#'>
    	select losLevel as level, mapid from cmCourseSection where cmid = #map# and loid=#outcome# and secRubric='#rubric#' order by losLevel
		</cfquery>    
		<cfreturn levels>
	</cffunction>
  
	<!--- Get the measurement Ids for a learning outcome. --->
  <cffunction name='getLOMIds' access="public" returnType="query">
  	<cfargument name='outcomeId' type='numeric' required='yes'>
    <cfset ids=''>
    <cfquery name='ids' datasource='#Application.Settings.IEIR_RO#'>
    	select lomid from loMeasurement where loid = #outcomeId# order by measureNum
    </cfquery>
    <cfreturn ids>
  </cffunction>  
  
	<!--- Get the list of course sections for a curriculum map. --->
	<cffunction name='getMapSections' access='public' returntype='query'>
    <cfargument name='cmid' type='numeric' required='yes'>
		<cfset courseSections=''>
    <cfquery name='courseSections' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(secRubric) as rubric, capstone from cmCourseSection where cmid = #cmid# order by secRubric
		</cfquery>    
		<cfreturn courseSections>
	</cffunction>
  
	<!--- Get a measurement activity by it's id. --->
  <cffunction name='getMeasurement' access="public" returnType='string'>
  	<cfargument name='mid' type='numeric' required='yes'>
    <cfset measurement=''>
    <cfquery name='measurement' datasource='#APPLICATION.SETTINGS.IEIR_RO#'>
    	select lomDescription from lomeasurement where lomid = #mid#
    </cfquery>
    <cfreturn measurement.lomDescription>
  </cffunction>
  
  <!--- Get all Measurement Activity averages for an assessment assignment. --->
  <cffunction name='getMeasurementSummaries' access='public' returntype="query">
  	<cfargument name='groupId' type='numeric' required='yes'>
    <cfargument name='outcomeId' type="numeric" required="yes">
    <!--- Get the measures on the outcome for later use here. --->
		<cfset meaSummaries=0>
    <cfquery name='meaSummaries' datasource='#Application.Settings.IEIR_RO#'>
    	select lomid, measureNum, lomDescription, 0 as average from lomeasurement where loid = #outcomeId# order by measureNum
    </cfquery>
    <!--- Get the assessment info for this assessment group --->
    <cfset averages=''>
    <cfquery name='averages' datasource='#Application.Settings.IEIR_RO#'>
    	select loa_id, student_lname, student_fname, loaDate, 0 as points, 0 as average
      	from loassessment
      where loa_group_id = #groupId#
    </cfquery>
    <!--- Get the number of completed assessments for this outcome assignment to be used for averaging later. --->
    <cfset completed=''>
    <cfquery name='completed' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from loassessment where loa_group_id = #groupId#
    </cfquery>
    <!--- Calculate the measure averages for each measurement activity in the assessment --->
		<cfloop query='meaSummaries'>
    	<cfset totalScore=''>
     	<cfquery name='totalScore' datasource='#Application.Settings.IEIR_RO#'>
      	select sum(loarScore) as points from loassessmentrating 
        	where lomid = #meaSummaries.lomid#
          	and loaid in (select loa_id from loassessment where loa_group_id = #groupId#)
      </cfquery>
      <cfset meaSummaries.average = (totalScore.points/completed.count)>
    </cfloop>
    <cfreturn meaSummaries>
  </cffunction>    
    
	<!--- Get the measurement activities for a Learning Outcome. --->
	<cffunction name='getMeasures' access='public' returntype='query'>
		<cfargument name='loid' type='numeric' required='yes'>
		<cfset measures=''>
    <cfquery name='measures' datasource='#Application.Settings.IEIR_RO#'>
    	select lomid, measureNum, lomDescription from lomeasurement where loid = #loid# order by measureNum
		</cfquery>
		<cfreturn measures>
	</cffunction>

	<!--- Get a learning outcome. --->
	<cffunction name='getOutcomeById' access='public' returntype='query'>
		<cfargument name='outcomeId' type='numeric' required='yes'>
		<cfset outcome_q=''>
    <cfquery name='outcome_q' datasource='#Application.Settings.IEIR_RO#'>
    	select loid, loName, loDesc, loRevMonth, loRevYear, pid, loProgramName, lo_pdf, loShortName from learningOutcome where loid = #outcomeId#
		</cfquery>    
		<cfreturn outcome_q>
	</cffunction>

	<!--- Get all LO assessment results for a term and program. --->
  <cffunction name='getOutcomeResults' access='public' returntype="numeric">
  	<cfargument name='groupId' type='numeric' required='yes'>
    <cfargument name='outcomeId' type="numeric" required="yes">
    <!--- Get the number of measures on the outcome for later use here. --->
		<cfset measures=0>
    <cfquery name='measures' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from lomeasurement where loid = #outcomeId#
    </cfquery>
    <!--- Get the assessment ids for this assessment group --->
    <cfset assessments=''>
    <cfquery name='assessments' datasource='#Application.Settings.IEIR_RO#'>
    	select loa_id from loassessment where loa_group_id = #groupId#
    </cfquery>
    <!--- Calculate the scores for each assessment so an average rating can be calculated and returned. --->
    <cfset scores=StructNew()>
    <cfset scores.total=0>
    <cfset scores.count=0>
    <cfloop query='assessments'>
    	<cfset score=0>
      <cfquery name='score' datasource='#Application.Settings.IEIR_RO#'>
      	select sum(loarScore) as total from loassessmentrating where loaid = #assessments.loa_id#
      </cfquery>
      <cfset scores.total += (score.total / measures.count)>
      <cfset scores.count += 1>
    </cfloop>
    <cfreturn (scores.total/scores.count)>
  </cffunction>    
  
	<!--- Get the curriculum map for a program. --->
	<cffunction name='getProgCM' access='public' returntype='struct'>
		<cfargument name='p_id' type='numeric' required='yes'>
		<cfset progMap = StructNew()>
    <cfquery name='oldMap' datasource='#Application.Settings.IEIR_RO#'>
    	select cmid as progCMID, cm_pdf from curriculummap where pid = #p_id#
		</cfquery>
    <cfif oldMap.recordcount eq 0>
    	<!--- insert a new map into the system --->
      <cfset revMonth = month(NOW())>
      <cfset revYear = year(NOW())>
      <cfset newMap = ''>
      <cfquery result="newMap" datasource="#Application.Settings.IEIR#">
      	insert into curriculummap values(null,#revMonth#,#revYear#,#p_id#,'#Session.UserID#','#Dateformat(Now(),"yyyy-mm-dd")#',null,null,null,null)
     	</cfquery>
      <cfset plos=''>
      <cfquery name="plos" datasource='#Application.Settings.IEIR_RO#'>
      	select loid from learningoutcome where pid = #p_id# order by loid
      </cfquery>
      <cfloop query="plos">
      	<cfset loupdate=''>
        <cfquery result='loupdate' datasource='#Application.Settings.IEIR#'>
        	update learningoutcome set cmid = #newMap.GENERATED_KEY# where loid = #plos.loid#
        </cfquery>
      </cfloop>
      <cfset progMap.progCMID = newMap.GENERATED_KEY>
      <cfset progMap.cmPDF = ''>
    <cfelse>
			<cfset progMap.progCMID = oldMap.progCMID>
      <cfset progMap.cmPDF = oldMap.cm_pdf>
    </cfif>
    <cfreturn progMap>
	</cffunction>
	
	<!--- Get the CM Info for a program. --->
	<cffunction name='getProgCMInfo' access='public' returntype='query'>
		<cfargument name='map' type='numeric' required='yes'>
		<cfset progMap=''>
    <cfquery name='progMap' datasource='#Application.Settings.IEIR_RO#'>
    	select cmRevMonth, cmRevYear, comments from curriculummap where cmid = #map#
		</cfquery>    
		<cfreturn progMap>
	</cffunction>

	<!--- Get the learning outcomes for a program. --->
	<cffunction name='getProgLOs' access='public' returntype='query'>
		<cfargument name='p_id' type='numeric' required='yes'>
		<cfset outcomes=''>
    <cfquery name='outcomes' datasource='#Application.Settings.IEIR_RO#'>
    	select loid, loName, loShortName, loDesc, lo_pdf from learningOutcome where pid = #p_id# order by loName
		</cfquery>    
		<cfreturn outcomes>
	</cffunction>
  
  <!--- Get a rating critiera. --->
  <cffunction name='getRating' access='public' returnType='String'>
  	<cfargument name='rid' type='numeric' required='yes'>
    <cfset rating=''>
    <cfquery name='rating' datasource='#Application.Settings.IEIR_RO#'>
    	select lomrDescription from loMeasurementRating where lomrid = #rid#
    </cfquery>
    <cfreturn rating.lomrDescription>
  </cffunction>
    
	<!--- Get the score associated with a rating --->
  <cffunction name="getRatingScore" access="public" returnType="numeric">
  	<cfargument name='ratingId' type='numeric' required='yes'>
    <cfset rating=''>
    <cfquery name='rating' datasource='#Application.Settings.IEIR_RO#'>
    	select lomrScore from loMeasurementRating where lomrid = #ratingId#
    </cfquery>
    <cfreturn rating.lomrScore>
  </cffunction>
  
	<!--- get a student name --->
  <cffunction name='getStudentName' access="public" returnType="query">
  	<cfargument name='studentId' type='numeric' required='yes'>
  	<cfargument name='class' type='string' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfset repTerm = right(term,5)>
    <cfset course = left(class,9)>
    <cfset section = right(class,4)>
    <cfset studentName=''>
    <cfquery name="studentName" datasource="#Application.Settings.IEIR_RO#">
    	select scs_last_name as last, scs_first_name as first from stu_course_sections
      	where stc_person_id = #studentId# and stc_course_name = '#course#' and stc_section_no = '#section#' and scs_reporting_term = '#repTerm#'
    </cfquery>
    <cfreturn studentName>
  </cffunction>

	<!--- get the students for a group. --->
  <cffunction name='getStudents' access="public" returnType="query">
  	<cfargument name='class' type='string' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfargument name='loa_group_id' type='numeric' required='yes'>
    <cfset repTerm = right(term,5)>
    <cfset course = left(class,9)>
    <cfset section = right(class,4)>
    <cfset students=''>
    <cfquery name="students" datasource="#Application.Settings.IEIR_RO#">
    	select scs_first_name, scs_last_name, stc_person_id from stu_course_sections
      	where stc_course_name = '#course#' and stc_section_no = '#section#' and scs_reporting_term = '#repTerm#'
        	and scs_status = 'A' and stc_person_id not in
          	(select student from loAssessment where loa_group_id = #loa_group_id#)
        order by scs_last_name, scs_first_name
    </cfquery>
    <cfreturn students>
  </cffunction>
  
  <!--- Get all Student results for aan assessment assignment. --->
  <cffunction name='getStudentSummaries' access='public' returntype="query">
  	<cfargument name='groupId' type='numeric' required='yes'>
    <cfargument name='outcomeId' type="numeric" required="yes">
    <!--- Get the number of measures on the outcome for later use here. --->
		<cfset measures=0>
    <cfquery name='measures' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from lomeasurement where loid = #outcomeId#
    </cfquery>
    <!--- Get the assessment info for this assessment group --->
    <cfset stuSummaries=''>
    <cfquery name='stuSummaries' datasource='#Application.Settings.IEIR_RO#'>
    	select loa_id, student_lname, student_fname, loaDate, 0 as points, 0 as average
      	from loassessment
      where loa_group_id = #groupId#
    </cfquery>
		<cfloop query='stuSummaries'>
    	<cfset ratingInfo=''>
     	<cfquery name='ratingInfo' datasource='#Application.Settings.IEIR_RO#'>
      	select sum(loarScore) as points from loassessmentrating where loaid = #stuSummaries.loa_id#
      </cfquery>
      <cfset stuSummaries.points = ratingInfo.points>
      <cfset stuSummaries.average = (ratingInfo.points/measures.count)>
    </cfloop>
    <cfreturn stuSummaries>
  </cffunction>    
  
	<!--- calculate an assessment completion rate for a program for a term --->
  <cffunction name='getTermCompRate' access='public' returntype='struct'>
  	<cfargument name='prog_id' type='numeric' required='yes'>
    <cfargument name='term' type='string' required="yes">
    <cfset groupInfo=StructNew()>
    <cfset groupCount=''>
    <cfquery name='groupCount' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as numGroups from lo_assessment_group where prog_id = #prog_id# and term = '#term#'
    </cfquery>
    <cfset groupInfo.loas=groupCount.numGroups>
    <!--- Get the total number of assessments --->
    <cfset assessments=''>
    <cfquery name='assessments' datasource='#Application.Settings.IEIR_RO#'>	
      select sum(enrolled) as count from lo_assessment_group
      	where loa_group_id in 
        	(select loa_group_id from lo_assessment_group where prog_id = #prog_id# and term = '#term#')
    </cfquery>
    <cfset groupInfo.assessments=assessments.count>
    <!--- Get the number of completed assessments --->
    <cfset completed=''>
    <cfquery name='completed' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from loassessment where loa_group_id in
      	(select loa_group_id from lo_assessment_group where prog_id = #prog_id# and term = '#term#')
    </cfquery>
    <cfset groupInfo.done=completed.count>
    <cfset groupInfo.pct=NumberFormat((completed.count/assessments.count),'9.99')>
    <cfreturn groupInfo>
  </cffunction>
  
	<!--- Insert rating data for an assessment. --->
  <cffunction name='insertAssessmentRating' access='public'>
  	<cfargument name='ratingData' type='struct' required='yes'>
    <cfset result=''>
    <cfquery result='result' datasource='#Application.Settings.IEIR#'>
    	insert into loAssessmentRating
      	values(#ratingData.outcomeId#, #ratingData.measurementId#, #ratingData.ratingId#, #ratingData.score#, '#ratingData.comments#')
    </cfquery>
  </cffunction>

  <!--- Insert a new learning outcome into the system. --->
  <cffunction name='insertLO' access='public' returnType='struct'>
  	<cfargument name='loData' type='struct' required='yes'>
		<cfset newSLO = ''>
    <cfquery result='newSLO' datasource='#Application.Settings.IEIR#'>
    	insert into learningoutcome 
      	values(null,'#loData.loName#','#loData.loDescription#',#loData.revMonth#,#loData.revYear#,null,#loData.progId#,
        			'#loData.progName#','#loData.pdf#','#Session.UserID#','#Dateformat(Now(),"yyyy-mm-dd")#',null,null,'#loData.loShortName#')
		</cfquery>
    <cfreturn newSLO>
  </cffunction> 

  <!--- Insert a new learning outcome assessment Measure into the system. --->
  <cffunction name='insertLOM' access='public' returnType='numeric'>
  	<cfargument name='lomData' type='struct' required='yes'>
		<cfset newLOM = ''>
    <cfquery result='newLOM' datasource='#Application.Settings.IEIR#'>
    	insert into loMeasurement 
      	values(null,#lomData.loid#,#lomData.measureNo#,'#lomData.description#','#Session.UserID#','#Dateformat(Now(),"yyyy-mm-dd")#',null,null)
		</cfquery>
    <cfreturn newLOM.GENERATED_KEY>
  </cffunction>    

  <!--- Insert a new learning outcome assessment measure rating into the system. --->
  <cffunction name='insertLOMR' access='public' returnType='numeric'>
  	<cfargument name='lomrData' type='struct' required='yes'>
		<cfset newLOMR = ''>
    <cfquery result='newLOMR' datasource='#Application.Settings.IEIR#'>
    	insert into loMeasurementRating 
      	values(null,#lomrData.lomId#,#lomrData.score#,'#lomrData.criteria#','#Session.UserID#','#Dateformat(Now(),"yyyy-mm-dd")#',null,null)
		</cfquery>
    <cfreturn newLOMR.GENERATED_KEY>
  </cffunction>    

  <!--- Insert a new learning outcome to course mapping into the system. --->
  <cffunction name='insertMapping' access='public'>
  	<cfargument name='mapInfo' type='struct' required='yes'>
		<cfset newMap = ''>
    <cfquery result='newMap' datasource='#Application.Settings.IEIR#'>
    	insert into cmcoursesection 
      	values(null,'#mapInfo.rubric#','#mapInfo.level#',#mapInfo.cmid#, #mapInfo.loid#,#mapInfo.capstone#)
		</cfquery>
  </cffunction>    

  <!--- Insert a rubric. --->
  <cffunction name="insertRubric" access="public" returnType="numeric">
  	<cfargument name="assessmentData" type="struct" required="yes">
    <cfset insertResult = ''>
    <cfquery result="insertResult" dataSource="#Application.Settings.IEIR#">
    	insert into loAssessment
      	values(null, #assessmentData.groupId#, '#assessmentData.term#', '#assessmentData.loaDate#', #assessmentData.student#, '#assessmentData.studentLName#', '#assessmentData.studentFName#',
        			 '#assessmentData.loLevel#', #assessmentData.outcomeId#, '#Session.UserID#','#Dateformat(Now(),"yyyy-mm-dd")#',null,null)
    </cfquery>
  	<cfreturn insertResult.GENERATED_KEY>
  </cffunction>

  <!--- Update an entry in the curriculum map table --->
  <cffunction name='updateCMTop' access='public'>
  	<cfargument name='cmData' type='struct' required='yes'>
		<cfset updateCM = ''>
    <cfquery result='updateCM' datasource='#Application.Settings.IEIR#'>
			update curriculummap set cmRevMonth = #cmData.revMonth#, cmRevYear = #cmData.revYear#, comments = '#cmData.comments#',
      	change_op = '#Session.UserID#', change_date = '#DateFormat(Now(),"yyyy-mm-dd")#' where cmid = #cmData.cmid#
		</cfquery>
  </cffunction>    

  <!--- Upate an existing learning outcome. --->
  <cffunction name='updateLO' access='public' returnType='struct'>
  	<cfargument name='loData' type='struct' required='yes'>
		<cfset updateSLO = ''>
    <cfquery result='updateSLO' datasource='#Application.Settings.IEIR#'>
    	update learningoutcome
      	set loName = '#loData.loName#', loDesc = '#loData.loDescription#', loRevMonth = #loData.revMonth#,
        		loRevYear = #loData.revYear#, change_op = '#Session.UserID#', change_date = '#DateFormat(Now(),"yyyy-mm-dd")#',
            loShortName = '#loData.loShortName#'
        where loid = #loData.loid# 
		</cfquery>
		<cfif loData.pdf neq ''>
    	<cfquery result='updateFile' datasource='#Application.Settings.IEIR#'>
      	update learningoutcome
        	set lo_pdf = '#loData.pdf#'
          where loid = #loData.loid#
      </cfquery>
    </cfif>
    <cfreturn updateSLO>
  </cffunction> 
     
  <!--- Update a learning outcome assessment Measure. --->
  <cffunction name='updateLOM' access='public'>
  	<cfargument name='lomData' type='struct' required='yes'>
		<cfset qres = ''>
    <cfquery result='qres' datasource='#Application.Settings.IEIR#'>
    	update loMeasurement 
      	set lomDescription = '#lomData.description#',
        		change_op = '#Session.UserID#',
            change_date = '#DateFormat(Now(),"yyyy-mm-dd")#'
        where lomid = #lomData.lomid#
		</cfquery>
  </cffunction>    

  <!--- Update a learning outcome assessment measure rating. --->
  <cffunction name='updateLOMR' access='public'>
  	<cfargument name='lomrData' type='struct' required='yes'>
		<cfset qres = ''>
    <cfquery result='qres' datasource='#Application.Settings.IEIR#'>
    	update loMeasurementRating 
      	set lomrDescription = '#lomrData.criteria#',
        		change_op = '#Session.UserID#',
            change_date = '#DateFormat(Now(),"yyyy-mm-dd")#'
        where lomid = #lomrData.lomid# and lomrScore = #lomrData.score#
    </cfquery>
  </cffunction>
  
  <!--- Update the pdf file in the curriculum map table --->
  <cffunction name='updateProgCMFile' access='public'>
  	<cfargument name='mapData' type='struct' required='yes'>
		<cfset updateCM = ''>
    <cfquery result='updateCM' datasource='#Application.Settings.IEIR#'>
			update curriculummap set cm_pdf = '#mapData.pdf#', change_op = '#Session.UserID#', change_date = '#DateFormat(Now(),"yyyy-mm-dd")#' 
      	where cmid = #mapData.cmid#
		</cfquery>
    <cfreturn updateCM>
  </cffunction>    

</cfcomponent>