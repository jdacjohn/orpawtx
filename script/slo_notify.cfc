<cfcomponent>
	<cffunction name="notifySLO" access="public">
  	<cfargument name="sendmail" type="numeric" required="yes">
    <cfset getCMSections=''>
		<!--- Iterate thru all course to learning outcome mappings. --->
    <cfquery name="getCMSections" datasource="#Application.Settings.IEIR_RO#">
    	select mapid, secRubric, losLevel, cmid, loid, capstone
      	from cmCourseSection
				order by mapid
    </cfquery>
    <!--- Get the program id from the curriculum map --->
    <cfloop query="getCMSections">
			<cfset q_cm = ''>
      <cfquery name='q_cm' datasource='#Application.Settings.IEIR_RO#'>
        select pid from curriculumMap where cmid = #getCMSections.cmid#
      </cfquery>
			<cfset sections = ''>
      <cfoutput>#getCMSections.secRubric#<br /></cfoutput>
    	<!--- Find all sections being taught from student registration data contained in the stu_course_sections table. 
			      Disregard Dual-Credit High School Sections (FOR NOW). --->
      <cfquery name="sections" datasource="#Application.Settings.IEIR_RO#">
    		select distinct(stc_section_no) as sec from stu_course_sections
        	where scs_reporting_term = '#Application.Settings.LOCollTerm#'
            and stc_course_name = '#getCMSections.secRubric#'
            and stc_section_no not like '%H_';
      </cfquery>
      <!--- Iterate through the sections that were found in order to identify instructors and send emails. --->
      <cfloop query="sections">  	
				<!--- Get the section information from the EAS Database. --->
        <cfset sectionInfo=''>
        <cfset thisClass = getCMSections.secRubric & '-' & sections.sec>
        <cfoutput>#thisClass#<br /></cfoutput>
        <cfquery name='sectionInfo' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(course_id) as course_id, class, course_title, instructor_name, instructor_fname, instructor_id, StartDate, EndDate
          	from lo_course
            where class = '#thisClass#' and term = '#Application.Settings.LOCollTerm#'
        </cfquery>
        <cfoutput>Instructor ID = #sectionInfo.instructor_id#<br /></cfoutput>
        <!--- Get the number of students enrolled in the section according to the book order course section enrollment info. --->
        <cfset enrolled = ''>
        <cfquery name="enrolled" datasource="#Application.Settings.IEIR_RO#">
        	select count(*) as students from stu_course_sections
          	where stc_course_name = '#getCMSections.secRubric#' and stc_section_no = '#sections.sec#' 
            	and scs_reporting_term = '#Application.Settings.LOCollTerm#' and scs_status = 'A'
        </cfquery>
				<cfset emailTo=''>
        <cfinvoke method="getEmailAddress" instructorId="#sectionInfo.instructor_id#" returnVariable="emailTo"></cfinvoke>
        <!--- If the email was not found for the instructor, set the To address to that of the site owner/administrator so
				      that person can follow up on the notification email that's being sent. --->
				<cfif emailTo eq ''>
        	<cfset emailTo = '#Application.Settings.SiteContactEmail#'>
        </cfif>
        <cfinvoke method="getSupervisorInfo" instructorId="#sectionInfo.instructor_id#" returnVariable="superInfo"></cfinvoke>
        <!--- If the Supervisor was not found, set the supervisor email to the email address of the site admin so it can
				      be followed up on. --->
				<cfif superInfo.Email eq ''>
        	<cfset superInfo.Email = '#Application.Settings.SiteContactEmail#'>
        </cfif>
        <cfinvoke method="buildMessage"
            class="#sectionInfo.class#"
            title="#sectionInfo.course_title#"
            lname="#sectionInfo.instructor_name#"
            fname="#sectionInfo.instructor_fname#"
            mapid=#getCMSections.mapid#
            level="#getCMSections.losLevel#"
            outcomeId=#getCMSections.loid#
            capstone=#getCMSections.capstone#
            cmid=#getCMSections.cmid#
            endDate="#sectionInfo.EndDate#"
            startDate="#sectionInfo.StartDate#"
            returnvariable="bodyInfo"></cfinvoke>
          <cfquery name="q_outcome" datasource="#Application.Settings.IEIR_RO#">
            select lo_pdf from learningOutcome where loid = #getCMSections.loid#
          </cfquery>
				<cfif sendmail eq 1>
        	<cfif q_outcome.lo_pdf neq ''>
            <cfmail 
  <!---            to="john.arnold@sweetwater.tstc.edu" --->
              to="#emailTo#" 
              from="John.Arnold@sweetwater.tstc.edu" 
              subject="Learning Outcomes Assessments DUE this Term for  #sectionInfo.class#" 
              type="html"
              mimeattach="#Application.Settings.SLOUploadDir & q_outcome.lo_pdf#"
              cc="#superInfo.Email#"
             >
             #bodyInfo.emailBody#
            </cfmail>
          <cfelse>
            <cfmail 
  <!---            to="john.arnold@sweetwater.tstc.edu" --->
              to="#emailTo#" 
              from="John.Arnold@sweetwater.tstc.edu" 
              subject="Learning Outcomes Assessments DUE this Term for  #sectionInfo.class#" 
              type="html"
              cc="#superInfo.Email#"
             >
             #bodyInfo.emailBody#
            </cfmail>
          </cfif>
        </cfif>
        <!--- Create a new LO Assessment Group for Tracking Purposes --->
        <cfset lag=''>
        <cfquery result="lag" datasource="#Application.Settings.IEIR#">
        	insert into lo_assessment_group
          	values(null, #getCMSections.mapid#, '#sectionInfo.class#', #sectionInfo.course_id#, #q_cm.pid#, #getCMSections.loid#, '#getCMSections.loslevel#', #sectionInfo.instructor_id#,
            	'#sectionInfo.instructor_name#', '#sectionInfo.instructor_fname#', '#emailTo#', #superInfo.CollID#, '#superInfo.LastName#', '#superInfo.FirstName#', '#superInfo.Email#', #enrolled.students#,
              '#dateformat(sectionInfo.startDate,'yyyy-mm-dd')#', '#dateformat(sectionInfo.endDate,'yyyy-mm-dd')#', '#bodyInfo.deadline#', '#Application.Settings.LOTerm#')
        </cfquery> 
      </cfloop> <!--- End of sections loop. --->
    </cfloop>  <!--- End of mappings loop. --->
	</cffunction>
  
	<cffunction name="getEmailAddress" access="private" returnType="string">
  	<cfargument name="instructorId" type="string" required="yes">
    <cfset instructor=''>
    <cfquery name="instructor" datasource="tstc1">
    	select Email from Employees where CollId = #instructorId#
    </cfquery>
    <cfoutput>Instructor #instructorId# Email:  #instructor.Email#<br /></cfoutput>
    <cfreturn instructor.Email> 
  </cffunction>
  
	<!--- This function gets an employee supervisor Colleague ID, Email Address, First Name and Last Name.  The
	      reason we go thru the mess of creating and returning a struct rather than the query is for handling
				the cases where the supervisor id is not found in the positions table.  The calling method depends
				on a struct being returned, so in the case where the supervisor id cannot be found, an initialized
				empty struct is returned in order to keep the calling method from breaking. --->
  <cffunction name="getSupervisorInfo" access="private" returnType="struct">
  	<cfargument name="instructorId" type="string" required="yes">
    <cfset superId=''>
    <cfquery name="superId" datasource="tstc1">
    	select posSupervisorCollID from Positions where posCollId = #instructorId#
    </cfquery>
    <cfset superInfo= StructNew()>
    <cfset superInfo.CollId = 0>
    <cfset superInfo.Email = ''>
    <cfset superInfo.FirstName = ''>
    <cfset superInfo.LastName = ''>
    <cfif superId.posSupervisorCollID neq ''>
    	<cfquery name='superYada' datasource='tstc1'>
    		select CollId, Email, FirstName, LastName from Employees where CollId = #superId.posSupervisorCollID#
    	</cfquery>
		  <cfoutput>Supervisor ID: #superId.posSupervisorCollID#  Email:  #superYada.Email#<br /></cfoutput>
      <cfset superInfo.CollId = superYada.CollId>
      <cfset superInfo.Email = superYada.Email>
      <cfset superInfo.FirstName = superYada.FirstName>
      <cfset superInfo.LastName = superYada.LastName>
		</cfif>
    <cfreturn superInfo> 
  </cffunction>

  <cffunction name="buildMessage" access="private" returnType="struct">
  	<cfargument name="class" type="string" required="yes">
    <cfargument name="title" type="string" required="yes">
    <cfargument name="lname" type="string" required="yes">
    <cfargument name="fname" type="string" required="yes">
    <cfargument name="mapid" type="numeric" required="yes">
    <cfargument name="level" type="string" required="yes">
    <cfargument name="outcomeId" type="numeric" required="yes">
    <cfargument name="capstone" type="numeric" required="yes">
    <cfargument name="cmid" type="numeric" required="yes">
    <cfargument name="endDate" type="string" required="yes">
    <cfargument name="startDate" type="string" required="yes">
    <cfset q_outcome=''>
    <cfquery name="q_outcome" datasource="#Application.Settings.IEIR_RO#">
    	select loName, loProgramName, lo_pdf, loRevMonth, loRevYear from learningOutcome where loid = #outcomeId#
    </cfquery>
    <cfset q_cmMap = ''>
    <cfquery name="q_cmMap" datasource="#Application.Settings.IEIR_RO#">
    	select cmRevMonth, cmRevYear, pid from curriculumMap where cmid = #cmid#
    </cfquery>
    <cfsavecontent variable="emailBody">
      <cfoutput>
        Good Morning,<br />&nbsp;<br />
        Information contained in the #Application.Settings.CollegeShortName# Student Learning Outcomes System indicates that you are teaching 
        <span style="text-decoration:underline">#class#, #title#</span>,
        during the #Application.Settings.LOTerm# semester.  According to the Learning Outcomes Curriculum Map submitted to
        the #Application.Settings.SiteOwner2# and last updated in #q_cmMap.cmRevMonth#/#q_cmMap.cmRevYear#, this class
        has been identified as one of the <b>#q_outcome.loProgramName#</b> courses in which assessment of program level student learning outcomes will
        be conducted.<br />&nbsp;<br />
        The information shown below provides the specific details about the assessments that are required to be conducted during
        the semester for the students enrolled in the class, and provides helpful links for accessing the learning outcomes rubrics
        for viewing and printing copies to be used in your assessments.  The PDF Version of the learning outcome rubric is also provided
        as an attachment to this email.
        <br />&nbsp;<br />
        <cfif level eq 'I'>
        	<cfset deadline = DateFormat('#startDate#' + 14,'mm/dd/yyyy')>
        	<b>This is an Introductory-level Assessment.  All learning outcome assessment results must be completed and submitted by
          the end of the 2nd week of the class, <span style="text-decoration:underline">#deadline#</span>.</b><br />&nbsp;<br />
        </cfif>
        <cfif level eq 'D'>
        	<cfset deadline = DateFormat('#endDate#' - 14,'mm/dd/yyyy')>
        	<b>This is a Developing-level Assessment.  The last day of class is #DateFormat('#endDate#','mm/dd/yyyy')#.
          All assessment results for this learning outcome must be completed and submitted no later than two weeks prior to the
          last day of class, or <span style="text-decoration:underline">#deadline#</span>.</b><br />&nbsp;<br />
        </cfif>
        <cfif level eq 'M'>
        	<b>This is a Mastery-level Assessment<cfif capstone eq 1> occuring in a capstone course</cfif>. 
          All assessment results for this learning outcome must be completed and submitted by the last day of class,
          <span style="text-decoration:underline">#DateFormat(endDate,'mm/dd/yyyy')#</span>.</b><br />&nbsp;<br />
        </cfif>
        If you are not an instructor associated with the class shown below, or if you have been copied on the email as the instructor's
        supervisor in error, please notify <a href="#Application.Settings.SiteContactEmail#">#Application.Settings.SiteContactName#</a>
        in the #Application.Settings.SiteOwner2#.<br />&nbsp;<br />
        
        Thank You!<br />&nbsp;<br />
        
        <span style="text-decoration:underline"><b>Instructions for Entering Assessments</b></span><br />
        In order to enter Learning Outcome Assessments into the system, go to <a href="http://orpa.westtexas.tstc.edu">The Institutional Effectiveness Website.</a><br />&nbsp;<br />
        You will need to be logged in to the system to enter assesssments.  Enter your username and password in the login section located at the upper right corner of the screen.
        If you have forgotten your user id and/or password, or do not have one for this system please contact
        <a href="#Application.Settings.SiteContactEmail#">#Application.Settings.SiteContactName#</a><br />&nbsp;<br />
				Once you are logged into the system, move your mouse over the quick links menu at the top of the window and select 
        'Learning Outcomes' from the drop-down menu that appears.  In the new page that opens, click on Program Outcomes and then
        Enter Assessments.  Select your program from the list of majors that appears to the left of the screen and you will be taken
        to the Assessment Entry home page for that program.  In the bottom right portion of the screen, you will see a list of the assessment groups
        for the current term.  Locate your class in this list and click on it.  This will open an on-line rubric form for the outcome
        that is being assessed.<br />&nbsp;<br />
        All students enrolled in the course are shown in a drop-down menu at the top of the screen.  Select the student you are assessing
        from this list, and click on the Calendar icon to enter the date of the assessment.  Simply provide a rating for each of the
        measurement activities associated with the outcome and provide any comments you would like to provide.  When you are finished, click
        on either 'Submit' or 'Add Another' at the end of the on-line form.  Clicking on Submit will return you to the Assessment home page
        for the program.  Clicking on Add Another will save the current assessment and allow you to immediately enter another assessment
        for a different student.  If you have ANY questions, please do not hesitate to contact me.<br />&nbsp;<br />
        
        <b>Course Information:</b><br />
        <table width="600" border="0" cellspacing="0" cellpadding="0" align="left">
          <tr>
            <td width="150" align="left">Program:</td>
            <td width="450" align="left">#q_outcome.loProgramName#</td>
          </tr>
          <tr>
            <td width="150" align="left">Learning Outcome:</td>
            <td width="450" align="left">#q_outcome.loName#</td>
          </tr>
          <tr>
            <td width="150" align="left">Assessment Level:</td>
            <td width="450" align="left"><cfif level eq 'I'>Introductory<cfelseif level eq 'D'>Developing<cfelse>Mastery</cfif></td>
          </tr>
          <tr>
            <td width="150" align="left">Rubric:</td>
            <td width="450" align="left"><a href="http://orpa.westtexas.tstc.edu/los/files/#q_outcome.lo_pdf#">#q_outcome.loName#</a></td>
          </tr>
          <tr>
            <td width="150" align="left">Class:</td>
            <td width="450" align="left">#class#</td>
          </tr>
          <tr>
            <td width="150" align="left">Course Title:</td>
            <td width="450" align="left">#title#</td>
          </tr>
          <tr>
            <td width="150" align="left">Instructor:</td>
            <td width="450" align="left">#lname#, #fname#</td>
          </tr>
        </table>
				<br />&nbsp;<br />

      </cfoutput>
    </cfsavecontent>
    <cfset bodyInfo = StructNew()>
    <cfset bodyInfo.emailBody = emailBody>
    <cfif level eq 'I'>
    	<cfset bodyInfo.deadline = DateFormat('#startDate#' + 14,'yyyy-mm-dd')>
    </cfif>
    <cfif level eq 'D'>
    	<cfset bodyInfo.deadline = DateFormat('#endDate#' - 14, 'yyyy-mm-dd')>
    </cfif>
    <cfif level eq 'M'>
    	<cfset bodyInfo.deadline = DateFormat('#endDate#','yyyy-mm-dd')>
    </cfif>
		<cfreturn bodyInfo>    
  </cffunction>

</cfcomponent>