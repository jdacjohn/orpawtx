<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Dual Credit Conversions</span></em></h5>
<p>The information below indicates former high school dual enrollment students who have continued their
education at TSTC upon graduating high school.
</p>
<cfinvoke component='script.dc_trends' method='buildDCConverts' returnVariable='converts'></cfinvoke>
<!--- <cfchart format="flash" title="TSTC West Texas 5-Year Trend:  Enrollment, Completions, and *Placement" showlegend="yes">
	<cfchartseries type="Line" seriescolor="##0033FF" serieslabel="Unduplicated Headcount" itemcolumn="fy" valuecolumn="undupHC">
	<cfloop index="i" from="1" to="5">
  	<cfchartdata item="#aUndupHC[i].fy#" value="#aUndupHC[i].undupHC#" />
  </cfloop>
	</cfchartseries>
	<cfchartseries type="Line" seriescolor="##FF0000" serieslabel="Completions" itemcolumn="fy" valuecolumn="awards">
	<cfloop index="i" from="1" to="5">
  	<cfchartdata item="#aCompleters[i].fy#" value="#aCompleters[i].awards#" />
  </cfloop>
	</cfchartseries>
	<cfchartseries type="Line" seriescolor="##00FF00" serieslabel="Placements" itemcolumn="fy" valuecolumn="placed">
	<cfloop index="i" from="1" to="5">
  	<cfchartdata item="#aPlacements[i].fy#" value="#aPlacements[i].placed#" />
  </cfloop>
	</cfchartseries>
</cfchart> --->

<!--- <cfform name="filterDC" id="filterDC" action="./index.cfm?action=Reports_CoreInd" method="post" format="html">
	<input type="checkbox" name="noDC" <cfif noDCSel eq "on">checked</cfif> onClick="submit();" /> Filter Dual Credit Students
</cfform>
<cfform name="getPDF" id="getPDF" action="./index.cfm?action=Reports_CoreInd_PDF" method="post" format="html">
  <input type="hidden" name='noDC2' value='#noDCSel#' />
  <input type="checkbox" name="genPDF" onClick="submit();" /> Get PDF Copy of Report
</cfform> --->
<!--- <p>Click on the check-box above to filter out dual credit high school students from these figures.</p> --->
<cfoutput>
<table class="retStatsTable">
	<tr>
  	<th>Student</th>
		<th>Last Name</th>
    <th>First Name</th>
    <th>HS PIEMS</th>
    <th>County</th>
    <th>County Name</th>
    <th>DC Start</th>
    <th>DC Campus</th>
    <th>DC Program</th>
    <th>DC Major</th>
    <th>NON-DC Start</th>
    <th>NON-DC Campus</th>
    <th>NON-DC Program</th>
    <th>NON-DC Major</th>
  </tr>
  <cfloop query='converts'>
  <tr>
  	<td>#converts.student#</td>
  	<td>#converts.lname#</td>
  	<td>#converts.fname#</td>
  	<td>#converts.high_school#</td>
  	<td>#converts.county#</td>
  	<td>#converts.county_name#</td>
  	<td>#converts.init_dc_term#</td>
    <td>#converts.dc_home_loc#</td>
  	<td>#converts.init_dc_prog#</td>
  	<td>#converts.init_dc_major#</td>
  	<td>#converts.init_reg_term#</td>
    <td>#converts.reg_home_loc#</td>
  	<td>#converts.init_reg_prog#</td>
  	<td>#converts.init_reg_major#</td>
  </tr>
  </cfloop>
</table>


</cfoutput>

</div>

<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p><cfinclude template="../body_links.cfm"></p>
</div>
</div>
<!-- MAIN RIGHT END -->

<div id="mainLeft">
<!-- Indicators NAV -->
<div class="leftNavContainer" >

<h4 class="blue principles">Core Indicators</h4>
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
