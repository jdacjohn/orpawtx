<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="mainRight">


<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<p>
<img class='rightImg' src='images/logo/star_200px.gif' />
The purpose of the Office of Research, Planning &amp; Analysis is to support the mission of Texas State Technical 
College West Texas by providing accurate and timely research information to promote effective decision making for the 
college. The Research, Planning, and Analysis Office provides leadership in institutional planning. In addition, the 
office provides the coordination and support for assessment of effectiveness of college planning and subsequent 
strategies to achieve the college's mission based goals including efforts to provide an environment for positive 
student outcomes.</p>

<p><strong>News!</strong> Due to recent enhancements in the Enrollment Monitor which have expanded the amount of information
available in the report, the Enrollment Monitor will no longer be accessible without a login.  If you do not have a login account
on this website, please contact John Arnold, TSTC West Texas, via email to have an account created.<br /> Thank you.</p>

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

<!-- MAIN RIGHT END -->


<div id="mainLeft">

<div class="snapshotContent" >
<!-- <img src="images/TSTC_logo_small.png" alt="" style="text-align: center" /> -->


<h4 class="blue"><cfoutput>#Application.Settings.EmTermTitle#</cfoutput></h4>
<h5 class="blue">Enrollment Summary</h4>
<div class="navVertContainerRed">
	<table width="200">
    <cfinvoke component='script.em' method='em_summary' returnVariable='em_lines'></cfinvoke>
    <cfset totalNew = 0>
    <cfset totalNewProj = 0>
    <cfset totalRetProj = 0>
    <cfset sumTotals = 0>
    <cfset totalPending = 0>
    <cfloop query="em_lines">
    <cfquery name="getLoc" datasource="ieir_assessment">
    	select campus from locations where lc_id = #em_lines.loc#
    </cfquery>
    <cfset total = em_lines.proj_new + em_lines.proj_ret>
    <cfoutput>
    <tr><th colspan="5" align="left"><span style="text-decoration:underline">#getLoc.campus#</span></th></tr>
    <tr><th>New</th><th colspan="4" align="left">Projected</th></tr>
		<tr>
			<th>Apps</th>
			<td>New</td>
			<td>Ret.</td>
			<td>Total</td>
			<td>Pending</td>
		</tr>
		<tr>
			<td>#em_lines.new_apps#</td>
			<td>#em_lines.proj_new#</td>
			<td>#em_lines.proj_ret#</td>
			<td>#total#</td>
			<td>#em_lines.pending#</td>
		</tr>
    </cfoutput>
    <cfset totalNew += em_lines.new_apps>
    <cfset totalNewProj += em_lines.proj_new>
    <cfset totalRetProj += em_lines.proj_ret>
    <cfset sumTotals += total>
    <cfset totalPending += em_lines.pending>
    
		</cfloop>
<!---    <tr><th colspan="5" align="left">Totals</th></tr>
    <cfoutput>
		<tr>
      <td>#totalNew#</td>
      <td>#totalNewProj#</td>
      <td>#totalRetProj#</td>
      <td>#sumTotals#</td>
			<td>#totalPending#</td>
		</tr>
    </cfoutput> --->
	</table>
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
