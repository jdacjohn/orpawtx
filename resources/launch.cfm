<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="mainRight">


<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<p>
<img class='rightImg' src='../images/logo/star_200px.gif' />
&nbsp;<br />Hi Diedra,<br />
Please click on the links below to run our reports - one at a time so we don't exceed the max number of logins to Colleague.<br />
Thank You!<br />
<a href="http://orpa.westtexas.tstc.edu/resources/bkstore_report.cfm" target="_blank">1. Bookstore Report</a><br />
<a href="http://orpa.westtexas.tstc.edu/resources/dailyReg.cfm" target="_blank">2. Enrollment Monitor</a><br />
<a href="http://orpa.westtexas.tstc.edu/resources/eas.cfm" target="_blank">3. Early Alert System</a><br />
<a href="http://orpa.westtexas.tstc.edu/resources/rsr_progress.cfm" target="_blank">4. Returning Student Registration Progress</a><br />
<a href="http://orpa.westtexas.tstc.edu/resources/em_report.cfm" target="_blank">5. Applications Monitor</a><br />
<a href="http://orpa.westtexas.tstc.edu/resources/apps2reg.cfm" target="_blank">6. Applications-to-Registrations Report</a><br />
<a href="http://orpa.westtexas.tstc.edu/resources/cs_daily.cfm" target="_blank">7. Daily Course-Sections Refresh</a><br />
<a href="http://orpa.westtexas.tstc.edu/resources/scs_daily.cfm" target="_blank">8. Daily Student-Course-Sections Refresh</a><br />
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
<img class='rightImg' src='../images/logo/ieir_logo_200px.gif' />
<cfinclude template='../body_links.cfm'>
</p>
</div>


</div>

<!-- MAIN RIGHT END -->


<div id="mainLeft">

<div class="snapshotContent" >
<!-- <img src="images/TSTC_logo_small.png" alt="" style="text-align: center" /> -->


<h4 class="blue"><cfoutput>#Application.Settings.EmTermTitle#</cfoutput></h4>
<h5 class="blue">Enrollment Summary</h4>
<div class="navVertContainerRed">
	<span><cfoutput>#DateFormat(Now(),"mm/dd/yyyy")#</cfoutput></span>
</div> <!-- navVertContainerRed -->

</div> <!-- snapshotContent -->

<!-- PRINCIPLES NAV -->

<!-- <div class="leftNavContainer" >

<h4 class="blue principles">Principles</h4>
	<div class="navVertContainer">
		<ul>
			<li><a href="principles/vision.html">Vision</a></li>
			<li><a href="principles/strategic.html">Strategic Imperatives</a></li>
			<li><a href="principles/performance.html">Performance Measures</a></li>
			<li><a href="principles/resources.html">Resources</a></li>
		</ul>
	</div>
</div> -->


<!-- PRINCIPLES NAV END -->

<!-- COMMUNICATION NAV -->
<!-- <div class="leftNavContainer" >

<h4 class="blue comm">Communication</h4>
	<div class="navVertContainer">
		<ul>
			<li><a href="http://tstcblog.westtexas.tstc.edu/">President's Blog</a></li>
			<li><a href="https://my.tstc.edu/forum/index.php">Discussion Forums</a></li>
			<li><a href="http://tstcblog.westtexas.tstc.edu/">Innovation</a></li>
			<li><a href="http://tstcblog.westtexas.tstc.edu/">Collaboration</a></li>
			<li><a href="http://tstcblog.westtexas.tstc.edu/">Todays Meetings</a></li>
			<li><a href="http://tstcblog.westtexas.tstc.edu/">Project Manager</a></li>
		</ul>
	</div>
</div> -->
<!-- COMMUNICATION NAV END -->


<!-- <a href="http://mycampus.westtexas.tstc.edu/"><img src="images/logo/mycampus_logo.gif" alt="MyCampus" style="padding-left:5px; border: 0px;" /></a> -->



</div>
<!-- MAIN BODY END -->
</div>
