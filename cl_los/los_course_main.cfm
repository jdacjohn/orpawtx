<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="mainRight">


<div class="rightContent" >
<h4 class="blue instructional"><cfoutput>#Application.Settings.CLCollege#</cfoutput> Student Learning Outcomes</h4>
<p>
<img class='rightImg' src='images/logo/star_200px.gif' />
Learning outcomes are identified and implemented at the course level, center on acquisition and 
application of knowledge, and also deal with retention of that knowledge over time. A learning outcome defines what 
faculty wants students to learn, describes how students can demonstrate their learning, and clarifies the types of 
assessment used to measure whether students will demonstrate proficiency long after the acquisition and initial 
application of the knowledge.  Learning outcomes for each course at <cfoutput>#Application.Settings.CLCollegeShortName#</cfoutput> 
were determined by focusing on the knowledge and skills employers expect an employee to possess.</p>
<p>The links shown on the left will allow you to browse learning outcomes associated with courses taught at
<cfoutput>#Application.Settings.CLCollegeShortName#</cfoutput>.  If you need to enter
assessments into the system, or manage these learning outcomes, please log in above using your account information.</p>
<p>Please contact <a href="mailto:john.arnold@sweetwater.tstc.edu">John Arnold</a> in the Office of Research,
Planning & Analysis at <span style="text-decoration:underline">325.235.7408</span> with any questions or suggestions.
</p>

<cfif Action eq 'App_Home_Sys_Down'>
<p><span style="color:#ff0000; text-decoration:underline;">The ORPA Website is currently down for routine maintenance.  Please try
back later.  We apologize for the inconvenience.  Please contact <a href="mailto:john.arnold@tstc.edu">John Arnold</a> via email
with any questions, or call 325.235.7408.</span><br />Thank You.</p>
</cfif>
</div>


<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p>
<img class='rightImg' src='images/logo/ieir_logo_200px.gif' />
<cfinclude template='body_links.cfm'>
</p>
</div>


</div>

<!--- MAIN RIGHT END --->


<div id="mainLeft">

<!--- Course Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Course Learning Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_cl_links.cfm">
		</ul>
	</div>
</div>
<!--- Course Outcomes NAV END --->

<!--- Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Learning Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="../los/los_links.cfm">
		</ul>
	</div>
</div>
<!--- Outcomes NAV END --->

</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
