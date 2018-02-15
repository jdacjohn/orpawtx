<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Student Retention</span></em></h5>
<cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
<p>Student Retention Reports are calculated on new student cohorts.  The 'Calculator' link shown to the left allows
you to select these cohorts and display 1-year and semester-to-semester retention rates for any available cohorts.  These
reports can be broken down by campus location, or shown for TSTC West Texas wide cohorts.  Additional filters are available
in the display results which allow you to break out developmental, non-developmental and part-time students from the
reports as well.
</p>
</div>

<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p><cfinclude template="../body_links.cfm"></p>
</div>


</div>

<!-- MAIN RIGHT END -->


<div id="mainLeft">

<!-- CALC NAV -->
<div class="leftNavContainer" >

<h4 class="blue principles">Retention</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./ret_links.cfm"></ul>
	</div>
</div>
<!-- CALC NAV END -->

<!-- COMMUNICATION NAV -->
<div class="leftNavContainer" >

<h4 class="blue comm">IEIR Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./report_links.cfm"></ul>
	</div>
</div>
<!-- COMMUNICATION NAV END -->


<!-- <a href="http://mycampus.westtexas.tstc.edu/"><img src="images/logo/mycampus_logo.gif" alt="MyCampus" style="padding-left:5px; border: 0px;" /></a> -->



</div>
<!-- MAIN BODY END -->
</div>
