<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="mainRight">


<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Student Learning Outcomes</h4>
<p>
<img class='rightImg' src='images/logo/star_200px.gif' />
<h5 class="blue instructional">Learning Outcomes Assessment and Analysis at Texas State Technical College</h5>
<cfoutput>#Application.Settings.CollegeShortName#</cfoutput> is vested in the pursuit of substantiating the learning experiences
of its students.  <br />Learning outcomes are tracked at both the program level and at the course level.</p>
<p>The links shown on the left will allow you to view the learning outcomes and associated curriculum maps.  If you need to enter
assessments into the system, or manage the learning outcome, please log in above using your account information.</p>
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
