<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
<div class="rightContent">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcomes</h4>
	<h5 class="blueback">Learning Outcome Individual Assessment Result</h5>
  <cfinvoke component='script.los' method='getAssessment' loaid=#assessment# returnvariable="q_assessment"></cfinvoke>
	<cfinvoke component='script.students' method='getStudentMajor' student=#q_assessment.student# term='#q_assessment.term#' returnvariable=major></cfinvoke>
  <cfinvoke component='script.los' method='getOutcomeById' outcomeId=#q_assessment.loid# returnvariable='outcome'></cfinvoke>
  <cfinvoke component='script.los' method='getAssessmentRatings' loaid=#assessment# returnVariable="ratings"></cfinvoke>
	<cfoutput>
  <cfset scoreCount=0>
  <cfset scoreTotal=0>
  <cfloop query="ratings">
  	<cfset scoreCount += 1>
    <cfset scoreTotal += ratings.score>
  </cfloop>
  <p>&nbsp;<b>Student:</b> #q_assessment.student_fname# #q_assessment.student_lname#, #major#, 
  	<b>Outcome:</b> <span style="text-decoration:underline">#outcome.loName#</span>
  
  <table class="loSummaryTable" cellspacing="0" cellpadding="0">
    <tr>
    	<th colspan="6" style="border-bottom: 1px solid;">Overall Score</th>
      <th style="border-bottom: 1px solid;">#NumberFormat((scoreTotal / scoreCount),9.99)#</th>
    </tr>
  	<cfloop query="ratings">
    	<tr>
      	<cfinvoke component='script.los' method='getMeasurement' mid=#ratings.measureId# returnVariable='measurement'></cfinvoke>
        <td colspan="7" style="border-bottom: 1px solid;"><b>Activity</b>&nbsp;&nbsp;#measurement#</td>
      </tr>
      <tr>
        <th colspan="4" width="350">Result</th>
        <th width="50">Score</th>
        <th colspan="2" width="180">Comments</th>
      </tr>      
      <tr>
      	<cfinvoke component='script.los' method='getRating' rid=#ratings.ratingId# returnVariable='criteria'></cfinvoke>
        <td colspan="4" style="border-bottom: 1px solid;">#criteria#</td>
        <td style="border-bottom: 1px solid;">#ratings.score#</td>
        <td colspan="2" style="border-bottom: 1px solid;">#ratings.comments#</td>
      </tr>
    </cfloop>
	</table>  
	</p>  
  </cfoutput>

	<cfif Action eq 'App_Home_Sys_Down'>
		<cfoutput>
		<p><span style="color:##ff0000; text-decoration:underline;">The #Application.Settings.SiteOwner2# Website is currently down for routine maintenance.  Please try
		back later.  We apologize for the inconvenience.  Please contact <a href="mailto:#Application.Settings.SiteContactEmail#">#Application.Settings.SiteContactName#</a> via email
		with any questions, or call #Application.Settings.SiteContactPhone#.</span><br />Thank You.</p>
		</cfoutput>
	</cfif>
	</div>
  
  <div class="rightContent" >
  <h4 class="blue linkage">Links</h4>
  
  <p>
  <cfinclude template='body_links.cfm'>
  </p>
  </div>

</div>
<!--- MAIN RIGHT END --->


 <div id="loMainLeft">

<!--- PGM Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Program Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_pgm_links.cfm">
		</ul>
	</div>
</div>
<!--- PGM Outcomes NAV END --->

<!--- Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Learning Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_links.cfm">
		</ul>
	</div>
</div>
<!--- Outcomes NAV END --->

</div> <!--- Main Left End ---> 
<!-- MAIN BODY END -->
</div>
