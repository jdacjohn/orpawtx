<!--- 

COMPONENT:		CL_LOS.CFC
AUTHOR:				John D. Arnold (JDA)
DATE:					2/1/2011

DESCRIPTION:
This component is in many ways a duplicate of the LOS.CFC file, with the exception that this component
deals with course level learning outcomes rather than program level learning outcomes.   The methods that
have been validated and modified for this system are noted with the date of validation of the initials of the
person responsible for the validation.

Methods are arranged in alphabetical order. 

--->

<cfcomponent>
	
	<!--- CREATED:  07/27/2011:  JDA --->
  <!--- Copy outcomes from one program to another.  --->
  <cffunction name='copyOutcomes' access='public' returnType='numeric'>
  	<cfargument name='program' type='numeric' required='yes'>
    <cfargument name='outcomes' type='string' required='yes'>
    
		<!--- Convert the string of outcome ids to an array that can be looped through. --->
    <cfset outComeArray = ListToArray(outcomes)>
    
    <cfloop index="idx" from="1" to="#ArrayLen(outComeArray)#" step="1">
    	
			<!--- Get the old outcome. --->
      <cfset getOutcome=''>
      <cfquery name='getOutcome' datasource='#Application.Settings.IEIR_RO#'>
      	select loid, loname, loDesc, loRevMonth, loRevYear, lo_pdf, change_op, change_date, loShortName from cl_learningOutcome
        	where loid = #outComeArray[idx]#
      </cfquery>
      
      <cfdump var="#getOutcome#">

      
			<!--- Insert a copy --->
      <!--- Check the change date so it doesn't blow things up if it's null. --->
      <cfif getOutcome.change_date eq ''>
      	<cfset cdate = 'null'>
      <cfelse>
      	<cfset cdate = '"#DateFormat(getOutcome.change_date,'yyyy-mm-dd')#"'>
      </cfif>
      <cfset insertLO=''>
      <cfquery result='insertLO' datasource='#Application.Settings.IEIR#'>
      	insert into cl_learningOutcome
        	values(null, '#getOutcome.loname#', '#getOutcome.loDesc#', #getOutcome.loRevMonth#, #getOutcome.loRevYear#,
          			 '#getOutcome.lo_pdf#', '#Session.UserID#', '#Dateformat(Now(),"yyyy-mm-dd")#', 
                 '#getOutcome.change_op#', #cdate#, '#getOutcome.loShortName#')
      </cfquery>
      <cfset newOutcome = insertLO.GENERATED_KEY>
      
      <!--- Get all of the measurement activities of the old outcome and copy them to the new outcome. --->
      <cfset getMeasurements=''>
      <cfquery name='getMeasurements' datasource='#Application.Settings.IEIR_RO#'>
      	select lomid, measureNum, lomDescription, change_op, change_date from cl_loMeasurement where loid = #outComeArray[idx]#
      </cfquery>
      
      <!--- Loop through the measurements and insert a new copy tied to the new outcome. --->
      <cfloop query="getMeasurements">
      	
        <!--- Insert a copy --->
        <!--- Fix for null change dates --->
        <cfif getMeasurements.change_date eq ''>
        	<cfset mcdate = 'null'>
        <cfelse>
        	<cfset mcdate = '"#DateFormat(getMeasurements.change_date, 'yyyy-mm-dd')#"'>
        </cfif>
        <cfset insertMeasurement=''>
        <cfquery result="insertMeasurement" datasource="#Application.Settings.IEIR#">
        	insert into cl_loMeasurement values(null, #newOutcome#, #getMeasurements.measureNum#, '#getMeasurements.lomDescription#',
          																		'#Session.UserId#', '#DateFormat(Now(),"yyyy-mm-dd")#', '#getMeasurements.change_op#',
                                              #mcdate#)
        </cfquery>
        <cfset newLOMId = insertMeasurement.GENERATED_Key>
        
        <!--- Get all of the ratings associated with the measurement --->
        <cfset getRatings=''>
        <cfquery name='getRatings' datasource='#Application.Settings.IEIR_RO#'>
        	select lomrScore, lomrDescription, change_op, change_date from cl_loMeasurementRating
          	where lomid = #getMeasurements.lomid#
            order by lomrScore
        </cfquery>
        
        <!--- Loop through the ratins and insert a new copy tied to the new measurement --->
        <cfloop query="getRatings">
        
        	<!--- Insert a copy --->
          <!--- Fix for null change date --->
          <cfif getRatings.change_date eq ''>
          	<cfset rcdate = 'null'>
          <cfelse>
          	<cfset rcdate = '"#DateFormat(getRatings.change_date, 'yyyy-mm-dd')#"'>
          </cfif>
          <cfset insertRating=''>
          <cfquery result="insertRating" datasource="#Application.Settings.IEIR#">
          	insert into cl_loMeasurementRating
            	values(null, #newLOMId#, #getRatings.lomrScore#, '#getRatings.lomrDescription#', '#Session.UserId#',
              			 '#DateFormat(Now(),"yyyy-mm-dd")#', '#getRatings.change_op#', #rcdate#)
          </cfquery>
          
        </cfloop>  <!--- End getRatings Loop --->
        
      </cfloop> <!--- End getMeasurements Loop --->

			<!--- Insert a mapping of the program to the new outcome --->
      <cfset insertProgLO=''>
      <cfquery result="insertProgLO" datasource="#Application.Settings.IEIR#">
      	insert into cl_prog_lo values(#program#, #newOutcome#)
      </cfquery>
      
      <!--- Get mappings if any for the old outcome and transfer them to the new outcome.  --->
      <cfset getMappings=''>
      <cfquery name="getMappings" datasource="#Application.Settings.IEIR_RO#">
      	select secRubric, learningActivity, intent, active, add_op, add_date, change_op, change_date
        	from cl_cmCourseSection where loid = #outComeArray[idx]#
      </cfquery>
      
      <!--- Loop through the mappings and create new ones for the new outcome. --->
      <cfloop query="getMappings">
      	<!--- Fix for null change date --->
        <cfif getMappings.change_date eq ''>
        	<cfset mapCDate = 'null'>
        <cfelse>
        	<cfset mapCDate = '"#DateFormat(getMappings.change_date, 'yyyy-mm-dd')#"'>
        </cfif>
      	<cfset insertMapping=''>
        <cfquery result="insertMapping" datasource="#Application.Settings.IEIR#">
        	insert into cl_cmCourseSection
          	values(null,
            			 '#getMappings.secRubric#', #newOutcome#, '#getMappings.learningActivity#', '#getMappings.intent#',
                   '#getMappings.active#','#Session.UserId#', '#DateFormat(Now(),"yyyy-mm-dd")#',
                   '#getMappings.change_op#', #mapCDate#)
        </cfquery>
      </cfloop>
      
    </cfloop> <!--- End outComeArray Loop --->
    
    <cfreturn newOutcome>
    
  </cffunction>
  <!--- END copyOutcomes --->
      
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
    	select count(*) as measureCount from cl_lomeasurement where loid = #loid#
		</cfquery>
		<cfreturn measures.measureCount>
	</cffunction>

	<!--- CREATED:  6/16/2011: JDA --->
  <!--- Delete a learning outcome measurement activity from the system. --->
  <cffunction name='deleteCLOM' access='public'>
  	<cfargument name='lomid' type='numeric' required='yes'>
		<cfargument name='loid' type='numeric' required='yes'>
    <cfset lom = ''>
    <cfquery name='lom' datasource='#Application.Settings.IEIR_RO#'>
    	select measureNum from cl_lomeasurement where lomid = #lomid#
    </cfquery>
		<cfset qresult = ''>
    <cfquery result='qresult' datasource='#Application.Settings.IEIR#'>
    	delete from cl_lomeasurement where lomid = #lomid#
		</cfquery>
    <!--- Now adjust the measurement numbers on the remaining measurement activities belonging to
					the measurement so subsequent adds will not duplicate an existing measurement number. --->
    <cfset res2 = ''>
    <cfquery result='res2' datasource='#Application.Settings.IEIR#'>
    	update cl_lomeasurement set measureNum = (measureNum -1) where loid = #loid# and measureNum > #lom.measureNum#
    </cfquery>
  </cffunction>    

	<!--- UPDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/10/2011. JDA --->
  <!--- Delete a learning outcome to course mapping from the system. --->
  <cffunction name='deleteMapping' access='public'>
  	<cfargument name='linkId' type='numeric' required='yes'>
    <!--- We're not really going to delete, just deactivate. --->
		<cfset qresult = ''>
    <cfquery result='qresult' datasource='#Application.Settings.IEIR#'>
    	update cl_cmcoursesection 
      	set active = 'N', change_op = '#Session.UserID#', change_date = '#DateFormat(Now(),"yyyy-mm-dd")#'
        where mapid = #linkId#
		</cfquery>
  </cffunction>    

	<!--- VALIDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/11/2011. JDA --->
	<!--- Get a list of distinct classes contained in the CL_LearningOutcomes table. --->
  <cffunction name='getClasses' access="public" returntype="query">
  	<cfargument name='rubric' type='string' required='yes'>
  	<cfset classes=''>
    <cfquery name='classes' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(secRubric) as secRubric from cl_cmCourseSection where secRubric like '#rubric#%' order by secRubric
    </cfquery>
    <cfreturn classes>
  </cffunction>

	<!--- VALIDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/11/2011. JDA --->
	<!--- Get the measurement ratings (criteria) for a measurement activity. --->
	<cffunction name='getCriteria' access='public' returntype='query'>
		<cfargument name='lomid' type='numeric' required='yes'>
		<cfset criteria=''>
    <cfquery name='criteria' datasource='#Application.Settings.IEIR_RO#'>
    	select lomrid, lomrscore, lomrDescription from cl_lomeasurementrating where lomid = #lomid# order by lomrScore
		</cfquery>
		<cfreturn criteria>
	</cffunction>
	
	<!--- VALIDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/11/2011. JDA --->
  <!--- CHANGE DATE:  7/14/2011 - Modified to utilize the new table CL_PROGRAM.  JDA --->
	<!--- Get a list of distinct disciplines contained in the CL_LearningOutcomes table. --->
  <cffunction name='getDisciplines' access="public" returntype="query">
  	<cfset disciplines=''>
    <cfquery name='disciplines' datasource='#Application.Settings.IEIR_RO#'>
    	select pid, prog_name as prog from cl_program order by prog_name
    </cfquery>
    <cfreturn disciplines>
  </cffunction>

	<!--- UPDATED: 07/15/2011: JDA:  Changed to use the new Program/LO ER Table --->
	<!--- VALIDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/11/2011. JDA --->
	<!--- Get the learning outcomes associated with a discipline. --->
	<cffunction name='getDiscLOs' access='public' returntype='query'>
		<cfargument name='prog' type='numeric' required='yes'>
		<cfset outcomes=''>
    <cfquery name='outcomes' datasource='#Application.Settings.IEIR_RO#'>
			select loid, loName, loRevMonth, loRevYear, loDesc, lo_pdf
      	from cl_learningOutcome 
        where loid in (select loid from cl_prog_lo where prog_id = #prog#)
        order by loName
		</cfquery>    
		<cfreturn outcomes>
	</cffunction>
  
	<!--- CREATED: 07.27.2011: JDA. --->
  <!--- Get a program id for a given major, or if it does not exist, insert the major and return the new id. --->
  <cffunction name="getInsertMajor" access="public" returnType="numeric">
  	<cfargument name="major" type="string" required="yes">
    <cfset progQ=''>
    <cfquery name="progQ" datasource="#Application.Settings.IEIR_RO#">
    	select pid from cl_program where prog_name = '#major#'
    </cfquery>
    <cfset progId = 0>
    <cfif progQ.pid neq ''>
    	<cfset progId = progQ.pid>
    <cfelse>
    	<!--- insert the new major --->
      <cfset insertProg=''>
      <cfquery result="insertProg" datasource="#Application.Settings.IEIR#">
      	insert into cl_program values(null,'#major#')
      </cfquery>
      <cfset progId = insertProg.GENERATED_KEY>
    </cfif>
    <cfreturn progId>
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
  
	<!--- NEW METHOD FOR COURSE LEVEL OUTCOMES.  KEEP. JDA 2/10/2011 --->
	<!--- Get the list of courses linked to an outcome.--->
	<cffunction name='getLinkedCourseInfo' access='public' returntype='query'>
    <cfargument name='outcomeId' type='numeric' required='yes'>
		<cfset courses=''>
    <cfquery name='courses' datasource='#Application.Settings.IEIR_RO#'>
    	select mapId, secRubric, add_date, change_date, learningActivity, intent from cl_cmCourseSection where loid = #outcomeId#  and active = 'Y' order by secRubric
		</cfquery>    
		<cfreturn courses>
	</cffunction>
  
	<!--- VALIDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/11/2011. JDA --->
	<!--- Get the measurement activities for a Learning Outcome. --->
	<cffunction name='getMeasures' access='public' returntype='query'>
		<cfargument name='loid' type='numeric' required='yes'>
		<cfset measures=''>
    <cfquery name='measures' datasource='#Application.Settings.IEIR_RO#'>
    	select lomid, measureNum, lomDescription from cl_lomeasurement where loid = #loid# order by measureNum
		</cfquery>
		<cfreturn measures>
	</cffunction>

	<!--- VALIDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/11/2011. JDA --->
	<!--- Get a learning outcome. --->
	<cffunction name='getOutcomeById' access='public' returntype='query'>
		<cfargument name='outcomeId' type='numeric' required='yes'>
		<cfset outcome_q=''>
    <cfquery name='outcome_q' datasource='#Application.Settings.IEIR_RO#'>
    	select loid, loName, loDesc, loRevMonth, loRevYear, lo_pdf, loShortName, '' as lo_rubric from cl_learningOutcome where loid = #outcomeId#
		</cfquery>
    <!--- Get the program name --->
    <cfset pQ=''>
    <cfquery name="pQ" datasource="#Application.Settings.IEIR_RO#">
    	select prog_name from cl_program
      	where pid = (select prog_id from cl_prog_lo where loid = #outcome_q.loid#)
    </cfquery>
    <cfset outcome_q.lo_rubric = pQ.prog_name>    
		<cfreturn outcome_q>
	</cffunction>

	<!--- VALIDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/14/2011. JDA --->
	<!--- Get All outcomes for a given class. --->
	<cffunction name='getOutcomesForClass' access='public' returnType='query'>
  	<cfargument name='class' type='string' required='yes'>
    <cfset outcomes = ''>
    <cfquery name='outcomes' datasource='#Application.Settings.IEIR_RO#'>
    	select loid, loName, loDesc, loRevMonth, loRevYear, lo_pdf, loShortName 
      	from cl_learningOutcome where loid in
        	(select distinct(loid) from cl_cmCourseSection where secRubric = '#class#')
        order by loShortName
		</cfquery>    
		<cfreturn outcomes>
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
	
	<!--- VALIDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/11/2011. JDA --->
	<!--- Get a list of distinct disciplines contained in the CL_LearningOutcomes table. --->
  <cffunction name='getRubrics' access="public" returntype="query">
  	<cfset rubrics=''>
    <cfquery name='rubrics' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(substring(secRubric,1,4)) as rubric from cl_cmCourseSection order by rubric
    </cfquery>
    <cfreturn rubrics>
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

	<!--- Modified 7/15/2011:  JDA:  Now uses the new Program-LO ER Table. --->
	<!--- CREATED FOR THE COURSE LEVEL LEARNING OUTCOMES: 2/9/2011: JDA --->
  <!--- Insert a new learning outcome into the system. --->
  <cffunction name='insertCLO' access='public' returnType='struct'>
  	<cfargument name='loData' type='struct' required='yes'>
    <!--- First make sure the SLO doesn't already exist in the system. --->
    <cfset qSLO=''>
    <cfquery name="qSLO" datasource="#Application.Settings.IEIR_RO#">
    	select count(*) as found from cl_learningoutcome where loName = '#loData.loName#'
    </cfquery>
    <cfif qSLO.found gt 0>
    	<cfset newSLO = StructNew()>
      <cfset newSLO.GENERATED_KEY=0>
    <cfelse>
    	<!--- 1. Check to see if the program exists or if it's a new listing. --->
      <cfset progId = 0>
      <cfset progQ = ''>
      <cfquery name="progQ" datasource="#Application.Settings.IEIR_RO#">
      	select pid from cl_program where prog_name = '#loData.rubric#'
      </cfquery>
      <cfif progQ.pid neq ''>
      	<cfset progId = progQ.pid>
      <cfelse>
      	<!--- Program listing is new and will be inserted. --->
        <cfset newProg = ''>
        <cfquery result='newProg' datasource='#Application.Settings.IEIR#'>
        	insert into cl_program values(null,'#loData.rubric#')
        </cfquery>
        <cfset progId = newProg.GENERATED_KEY>
      </cfif>
      <!--- Now insert the Learning Outcome --->      
			<cfset newSLO = ''>
	  	<cfquery result='newSLO' datasource='#Application.Settings.IEIR#'>
  	  	insert into cl_learningoutcome 
    	  	values(null,'#loData.loName#','#loData.loDescription#',#loData.revMonth#,#loData.revYear#,
      	  			'#loData.pdf#','#Session.UserID#','#Dateformat(Now(),"yyyy-mm-dd")#',null,null,'#loData.loShortName#')
			</cfquery>
			<!--- Now insert the Program-Learning Outcome association --->
      <cfset newPLO=''>
      <cfquery result="newPLO" datasource="#Application.Settings.IEIR#">
      	insert into cl_prog_lo values(#progId#, #newSLO.GENERATED_KEY#)
      </cfquery>
    </cfif>
    <cfreturn newSLO>
  </cffunction> 

	<!--- CREATED FOR COURSE LEVEL OUTCOMES: 2/9/2011: JDA --->  
  <!--- Insert a new learning outcome assessment Measure into the system. --->
  <cffunction name='insertLOM' access='public' returnType='numeric'>
  	<cfargument name='lomData' type='struct' required='yes'>
		<cfset newLOM = ''>
    <cfquery result='newLOM' datasource='#Application.Settings.IEIR#'>
    	insert into cl_loMeasurement 
      	values(null,#lomData.loid#,#lomData.measureNo#,'#lomData.description#','#Session.UserID#','#Dateformat(Now(),"yyyy-mm-dd")#',null,null)
		</cfquery>
    <cfreturn newLOM.GENERATED_KEY>
  </cffunction>    

	<!--- CREATED FOR COURSE LEVEL OUTCOMES:  2/9/2011 --->
  <!--- Insert a new learning outcome assessment measure rating into the system. --->
  <cffunction name='insertLOMR' access='public' returnType='numeric'>
  	<cfargument name='lomrData' type='struct' required='yes'>
		<cfset newLOMR = ''>
    <cfquery result='newLOMR' datasource='#Application.Settings.IEIR#'>
    	insert into cl_loMeasurementRating 
      	values(null,#lomrData.lomId#,#lomrData.score#,'#lomrData.criteria#','#Session.UserID#','#Dateformat(Now(),"yyyy-mm-dd")#',null,null)
		</cfquery>
    <cfreturn newLOMR.GENERATED_KEY>
  </cffunction>    

	<!--- UPDATED FOR COURSE LEVEL OUTCOMES. KEEP. 2/10/2011. JDA --->
  <!--- Insert a new learning outcome to course mapping into the system. --->
  <cffunction name='insertMapping' access='public'>
  	<cfargument name='mapInfo' type='struct' required='yes'>
    <!--- Check to see if the link already exists but is inactive. --->
    <cfset getLink=''>
    <cfquery name='getLink' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from cl_cmCourseSection where secRubric = '#mapInfo.rubric#' and loid = #mapInfo.outcome#
    </cfquery>
    <cfif getLink.count gt 0>
    	<!--- Activate the existing link. --->
      <cfset updateLink=''>
      <cfquery result='updateLink' datasource='#Application.Settings.IEIR#'>
      	update cl_cmCourseSection
        	set active = 'Y', learningActivity = '#mapInfo.activity#', intent = '#mapInfo.intent#', change_op = '#Session.UserID#', change_date = '#Dateformat(Now(),"yyyy-mm-dd")#'
          where secRubric = '#mapInfo.rubric#' and loid = #mapInfo.outcome#
      </cfquery>
    <cfelse>
    	<!--- Insert a new link to the system. --->
			<cfset newLink = ''>
    	<cfquery result='newLink' datasource='#Application.Settings.IEIR#'>
    		insert into cl_cmCourseSection 
      		values(null,'#mapInfo.rubric#',#mapInfo.outcome#,'#mapInfo.activity#', '#mapInfo.intent#','Y','#Session.UserID#','#DateFormat(Now(),"yyyy-mm-dd")#',null,null)
			</cfquery>
    </cfif>
  </cffunction>    

  <!--- Upate an existing learning outcome. --->
  <cffunction name='updateCLO' access='public' returnType='struct'>
  	<cfargument name='loData' type='struct' required='yes'>
		<cfset updateCLO = ''>
    <cfquery result='updateCLO' datasource='#Application.Settings.IEIR#'>
    	update cl_learningoutcome
      	set loName = '#loData.loName#', loDesc = '#loData.loDescription#', loRevMonth = #loData.revMonth#,
        		loRevYear = #loData.revYear#, change_op = '#Session.UserID#', change_date = '#DateFormat(Now(),"yyyy-mm-dd")#',
            loShortName = '#loData.loShortName#'
        where loid = #loData.loid# 
		</cfquery>
		<cfif loData.pdf neq ''>
    	<cfquery result='updateFile' datasource='#Application.Settings.IEIR#'>
      	update cl_learningoutcome
        	set lo_pdf = '#loData.pdf#'
          where loid = #loData.loid#
      </cfquery>
    </cfif>
    <cfreturn updateCLO>
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

  <!--- Update a learning outcome assessment Measure. --->
  <cffunction name='updateCLOM' access='public'>
  	<cfargument name='lomData' type='struct' required='yes'>
		<cfset qres = ''>
    <cfquery result='qres' datasource='#Application.Settings.IEIR#'>
    	update cl_loMeasurement 
      	set lomDescription = '#lomData.description#',
        		change_op = '#Session.UserID#',
            change_date = '#DateFormat(Now(),"yyyy-mm-dd")#'
        where lomid = #lomData.lomid#
		</cfquery>
  </cffunction>    

  <!--- Update a learning outcome assessment measure rating. --->
  <cffunction name='updateCLOMR' access='public'>
  	<cfargument name='lomrData' type='struct' required='yes'>
		<cfset qres = ''>
    <cfquery result='qres' datasource='#Application.Settings.IEIR#'>
    	update cl_loMeasurementRating 
      	set lomrDescription = '#lomrData.criteria#',
        		change_op = '#Session.UserID#',
            change_date = '#DateFormat(Now(),"yyyy-mm-dd")#'
        where lomid = #lomrData.lomid# and lomrScore = #lomrData.score#
    </cfquery>
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

	<!--- get the number of completed assessments for a group. --->
  <cffunction name='countAssessments' access="public" returnType="query">
  	<cfargument name='groupId' type='numeric' required='yes'>
    <cfset assessments=''>
    <cfquery name="assessments" datasource="#Application.Settings.IEIR_RO#">
    	select count(*) as count from loassessment where loa_group_id = #groupId#
    </cfquery>
    <cfreturn assessments>
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
        	and stc_person_id not in
          	(select student from loAssessment where loa_group_id = #loa_group_id#)
        order by scs_last_name, scs_first_name
    </cfquery>
    <cfreturn students>
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

	<!--- Get the measurement Ids for a learning outcome. --->
  <cffunction name='getLOMIds' access="public" returnType="query">
  	<cfargument name='outcomeId' type='numeric' required='yes'>
    <cfset ids=''>
    <cfquery name='ids' datasource='#Application.Settings.IEIR_RO#'>
    	select lomid from loMeasurement where loid = #outcomeId# order by measureNum
    </cfquery>
    <cfreturn ids>
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

	<!--- Insert rating data for an assessment. --->
  <cffunction name='insertAssessmentRating' access='public'>
  	<cfargument name='ratingData' type='struct' required='yes'>
    <cfset result=''>
    <cfquery result='result' datasource='#Application.Settings.IEIR#'>
    	insert into loAssessmentRating
      	values(#ratingData.outcomeId#, #ratingData.measurementId#, #ratingData.ratingId#, #ratingData.score#, '#ratingData.comments#')
    </cfquery>
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
    
</cfcomponent>