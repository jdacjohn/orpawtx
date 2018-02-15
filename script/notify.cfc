<!---  This was developed for the EOC Survey System.  has NOTHING to do with ORPA and don't know
WHY it's here.  (Kinda) Just keep it in here for now. --->
<cfcomponent>
	<cffunction name="notifyOpenSurveys" access="public" returntype="string">
		<cfset myResult="foo">
		<!--- <cfset todayDate=DateFormat(Now(), "mm/dd/yyyy")> --->
		<cfset todayDate="10/1/2008">
    <cfset getSections=''>
		<cfquery name="getSections" datasource="EOC">
    	select class, course_title, instructor_name, instructor_fname, instructor_id, LastDayToDrop, course_id
      	from course
        where LastDayToDrop < '#todayDate#' and notified = 0
    </cfquery>
    <cfloop query="getSections">
    	<cfset emailTo='john.arnold@sweetwater.tstc.edu'>
      <cfinvoke method="getEmailAddress" instructorId="#getSections.instructor_id#" returnVariable="emailTo"></cfinvoke>
			<cfinvoke method="buildMessage"
      		class="#getSections.class#"
          title="#getSections.course_title#"
          lname="#getSections.instructor_name#"
          fname="#getSections.instructor_fname#"
          dropDate="#getSections.LastDayToDrop#"
        	returnvariable="emailBody"></cfinvoke>
      <cfmail to="john.arnold@sweetwater.tstc.edu" from="EOC_Survey_System@sweetwater.tstc.edu" subject="EOC Survey Now Open for #getSections.class#" type="html">
       #emailBody#
      </cfmail>
	    <cfquery result='crsupdate' datasource='EOC'>
    		update course set notified = 1 where course_id = #getSections.course_id#
			</cfquery>    
    </cfloop>
		<cfreturn myResult>
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
  
  <cffunction name="buildMessage" access="private" returnType="string">
  	<cfargument name="class" type="string" required="yes">
    <cfargument name="title" type="string" required="yes">
    <cfargument name="lname" type="string" required="yes">
    <cfargument name="fname" type="string" required="yes">
    <cfargument name="dropDate" type="string" required="yes">
    <cfsavecontent variable="emailBody">
      <cfoutput>
        Good Morning,<br />&nbsp;<br />
        End-of-Course Surveys are now open for the course section listed below. The EOC System has identified you as an instructor
        of record for this section.  Please advise your students that they may access the End-of-Course survey by opening the
        following link in their browser:<br />&nbsp;<br />
        <a href="http://www2.westtexas.tstc.edu/sharedapps/eoc_survey/">http://www2.westtexas.tstc.edu/sharedapps/eoc_survey/</a><br />&nbsp;<br />
        <b>Section Information:</b><br />&nbsp;<br />
        <p>
        <table width="400" border="0" cellspacing="0" cellpadding="0" align="left">
          <tr>
            <td width="150" align="left">Course Section:</td>
            <td width="250" align="left">#class#</td>
          </tr>
          <tr>
            <td width="150" align="left">Course Title:</td>
            <td width="250" align="left">#title#</td>
          </tr>
          <tr>
            <td width="150" align="left">Instructor:</td>
            <td width="250" align="left">#lname#, #fname#</td>
          </tr>
          <tr>
            <td width="150" align="left">Last Day to Drop:</td>
            <td width="250" align="left">#DateFormat(dropDate,"mm-dd-yyyy")#</td>
          </tr>
          <tr>
            <td width="400" colspan="2" align="left">
              <br />&nbsp;<br />
              If you are not an instructor associated with the above-listed section, please notify <a href="mailto:lulu.morales@sweetwater.tstc.edu">Lulu.Morales@tstc.edu</a>.
              <br />&nbsp;<br />Thank You!<br />The EOC Survey Team.
            </td>
          </tr>
        </table></p>
      </cfoutput>
    </cfsavecontent>
		<cfreturn emailBody>    
  </cffunction>

</cfcomponent>