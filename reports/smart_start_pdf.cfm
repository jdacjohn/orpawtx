<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<cfdocument format="pdf" backgroundvisible="yes" mimetype="text/xml" >
	<link href="./css/orpa.css" rel="stylesheet" type="text/css" />
	<link href="./css/los.css" rel="stylesheet" type="text/css" />
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<cfoutput>
<cfif isDefined('loc')>
	<cfinvoke component="script.smartStart" method="getCampus" location=#loc# returnVariable="remCampName"></cfinvoke>
  <cfset campus = remCampName>
<cfelse>
	<cfset campus=''>
</cfif>

<cfif !isdefined('term')>
	<cfif campus eq ''>
    <p style="color:##000000;text-align:left;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:12px;">
    Welcome to the Smart Start Tracking page of the TSTC West Texas IE/IR Website.  This page provides key performance
    indicators for this exciting new program.  The links to the left indicate the campuses where TSTC is conducting the 
    Smart Start program.  To begin, simply select one of these campuses shown to the left.  <b>Note:</b> Currently, 
    Abilene is the only campus to offer the Smart Start program.  As more of TSTC West Texas' locations bring this new 
    program online, this page will allow you to view the success rates of the students in the Smart Start program by 
    campus location.
  	</p>
  <cfelse>
    <p style="color:##000000;text-align:left;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:12px;">
    Welcome to the Smart Start Tracking page of the TSTC West Texas IE/IR Website.  This page provides key performance
    indicators for this exciting new program.  The links to the left indicate all terms that TSTC West Texas has conducted
    the Smart Start program in #campus#.  To begin, simply select one of these semesters shown to the left.  <b>Note:</b> Currently, 
    Abilene is the only campus to offer the Smart Start program.  As more of TSTC West Texas' locations bring this new 
    program online, this page will allow you to view the success rates of the students in the Smart Start program by 
    campus location.
  	</p>
  </cfif>
<cfelse>
  <cfinvoke component='script.smartStart' method='getTrackData' term="#term#" location=#loc# returnVariable="ssTrack"></cfinvoke>
	<h5 class="rubricHeading">TSTC West Texas #campus# Campus Smart Start Results for #term#:  #ssTrack.course#</h5>
	<!--- First lets get the inital results of the Smart Start Semester. --->
  <p style="color:##000000;text-align:left;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:12px;">
	The graph below provides a visual indicaton of success-tracking indicators for Smart Start students who began the program
  at the selected location and semester.  The first five bars in the graph indicate the performance results of these students
  during their Smart Start term.  The remaining bars provide performance tracking indicators in their first three terms as
  undergraduate college students.  First-term information is provided to indicate how many of these students actually enrolled
  in the college as well as how many withdrew from the college during their first term. The second and third terms indicate
  retention trends of these students over time.  Finally, the number of students from the beginning class who successfully 
  graduated is indicated.  Below the table you can view detailed numerical statistics for each of these categories, followed
  by explanatory footnotes. <br />&nbsp;<br />
  <span style="text-decoration:underline"><b>Smart Start Class: #campus#, 20#term# - #ssTrack.course#</b></span><br />&nbsp;<br />
  
  <cfchart format="jpg" 
           showlegend="no"
           chartwidth="550"
           chartheight="300"
           show3D="yes" fontsize="8">
    <cfchartseries type="HorizontalBar" 
    	colorlist="##00ff00,##0098FF,##ff0000,##cecbce,##0EB5FF,##FFFF00,##FF8000,##FF00FF,##ECFF00,##1DFFEE"
      dataLabelStyle="value"
      >
      <cfchartdata item="New" value="#ssTrack.started#">
      <cfchartdata item="Pass" value="#ssTrack.passed#">
      <cfchartdata item="Fail" value="#ssTrack.failed#">
      <cfchartdata item="I/P" value="#ssTrack.inProg#">
      <cfchartdata item="W/D" value="#ssTrack.wd#">
      <cfchartdata item="#ssTrack.term1#" value="#ssTrack.registered#">
      <cfchartdata item="#ssTrack.term1# Ret." value="#ssTrack.stillHere1#">
      <cfchartdata item="#ssTrack.term2#" value="#ssTrack.registered2#">
      <cfchartdata item="#ssTrack.term3#" value="#ssTrack.registered3#">
      <cfchartdata item="Grad" value="#ssTrack.grads#">
    </cfchartseries>
  </cfchart>

</p>

  <table class="cloSummaryTable">
    <tr>
      <th colspan="6" style="text-align:left">Details for Smart Start Class: #campus#, #term#, #ssTrack.course#</th>
    </tr>
    <tr>
			<th>Students Started</th>
			<th>#ssTrack.started#</th>
      <th>&nbsp;</th>
    </tr>
    <tr>
			<th>Students Passed</th>
			<th>#ssTrack.passed#</th>
      <th>#NumberFormat((ssTrack.passed/ssTrack.started) * 100,99.99)#%</th>
    </tr>
    <tr>
			<th>Students Failed</th>
			<th>#ssTrack.failed#</th>
      <th>#NumberFormat((ssTrack.failed/ssTrack.started) * 100,99.99)#%</th>
    </tr>
    <tr>
			<th>Students In Progress <sup>1</sup></th>
			<th>#ssTrack.inProg#</th>
      <th>#NumberFormat((ssTrack.inProg/ssTrack.started) * 100,99.99)#%</th>
    </tr>
    <tr>
			<th>Students W/D</th>
			<th>#ssTrack.wd#</th>
      <th>#NumberFormat((ssTrack.wd/ssTrack.started) * 100,99.99)#%</th>
    </tr>
    <tr>
			<th>Students Registered in #ssTrack.term1#</th>
			<th>#ssTrack.registered#</th>
      <th>#NumberFormat((ssTrack.registered/ssTrack.started) * 100,99.99)#%</th>
    </tr>
    <tr>
			<th>Retention in #ssTrack.term1# <sup>2</sup></th>
			<th>#ssTrack.stillHere1#</th>
      <th>#NumberFormat((ssTrack.stillHere1/ssTrack.started) * 100,99.99)#%</th>
    </tr>
    <tr>
			<th>Students Registered in #ssTrack.term2# <sup>3</sup></th>
			<th>#ssTrack.registered2#</th>
      <th>#NumberFormat((ssTrack.registered2/ssTrack.started) * 100,99.99)#%</th>
    </tr>
    <tr>
			<th>Students Registered in #ssTrack.term3# <sup>3</sup></th>
			<th>#ssTrack.registered3#</th>
      <th>#NumberFormat((ssTrack.registered3/ssTrack.started) * 100,99.99)#%</th>
    </tr>
    <tr>
			<th>Graduates <sup>4</sup></th>
			<th>#ssTrack.grads#</th>
      <th>#NumberFormat((ssTrack.grads/ssTrack.started) * 100,99.99)#%</th>
    </tr>
  </table>
  <p style="color:##5e5e5e;text-align:left;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:10px;">
  <span style="text-decoration:underline"><b>Footnotes</b></span><br />&nbsp;<br />
  	<sup>1</sup> In Progress (I/P) indicates students who did not have a verified grade at end of term. <br />&nbsp;<br />
    <sup>2</sup> This figure represents the number of students who remain(ed) enrolled in their first semester of college
    after completing the Smart Start program.  It does not reflect de-registered students.  As enrollment data becomes
    certified and available, deregistration figures will be reflected in the number of students enrolled in their first semester. 
    Until that time, enrollment data is derived from the TSTC West Texas IE/IR Registration Report Data Set.<br />&nbsp;<br />
    <sup>3</sup> Data may not be available or complete for upcoming terms.<br />&nbsp;<br />
    <sup>4</sup> Graduation data is currently tracked thru 3 semesters to calculate 100% completion rates for certificate programs
    through 3 semesters, or one academic year.</p>
  
    <p style="color:##000000;text-align:left;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:12px;">
  Please contact John Arnold in the Office of Research, Planning & Analysis at <i>325.235.7408</i> with any questions or suggestions.
  </p>
  
  
</cfif>
</cfoutput>
</cfdocument>
</div>

<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p><cfinclude template="../body_links.cfm"></p>
</div>
</div>
<!-- MAIN RIGHT END -->

<div id="mainLeft">
<!-- Smart Start Terms Nav. -->
<div class="leftNavContainer" >

<cfif isDefined('loc')>
<h4 class="blue principles">Smart Start Terms</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./npss_terms.cfm"></ul>
	</div>
</div>
<cfelse>
<h4 class="blue principles">Smart Start Locations</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./npss_locs.cfm"></ul>
	</div>
</div>
</cfif>
<!-- Smart Start Terms NAV END -->

<!-- Indicators NAV -->
<div class="leftNavContainer" >

<h4 class="blue principles">New Paradigm</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./ci_links.cfm"></ul>
	</div>
</div>
<!-- INDICATORS NAV END -->

<!-- COMMUNICATION NAV -->
<div class="leftNavContainer" >

<h4 class="blue comm">IEIR Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./report_links.cfm"></ul>
	</div>
</div>
<!-- COMMUNICATION NAV END -->

</div>
<!-- MAIN BODY END -->
</div>
