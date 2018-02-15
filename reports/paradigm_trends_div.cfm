<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>New Paradigm Core Indicators</span></em></h5>
<p>The chart below indicates 3 core indicators for TSTC West Texas that are central to TSTC's New Paradigm.
By default, these figures indicate totals for all programs within all instructional divisions at all locations for 
TSTC West Texas for the most recent 5 fiscal years excluding the current academic year.  Figures for the current 
academic year will be available at the start of the upcoming academic year.  The dropdown list below can be used
to view this information for the desired instructional division.
</p>
<cfinvoke component='programs' method='getDivisions' returnvariable='qDivisions'></cfinvoke>
<cfif isdefined('divSelect') && divSelect neq ''>
	<cfset theDiv = divSelect>
<cfelse>
	<cfset theDiv = 'All Divisions'>
</cfif>
<cfoutput>
<table class="loCreateTable" cellspacing="0" cellpadding="0">
<cfform name="TrendVars" id="trendVars" enctype="multipart/form-data" action="./index.cfm?Action=Reports_CoreInd_Div" method="post" format="html">
  <tr>
  	<th width="150">Instructional Division</th>
  	<td>
    	<select name="divSelect" id="divSelect" onchange="submit();">
    	  <option value=''></option>
        <cfloop query='qDivisions'>
        	<option value='#qDivisions.division#' <cfif qDivisions.division eq theDiv>selected</cfif> >#qDivisions.division#</option>
        </cfloop>
      </select>
    </td>
   </tr>
</cfform>
</table>
</cfoutput>
<cfif isDefined('noDC')>
	<cfset noDCSel='on'>
<cfelse>
	<cfset noDCSel='off'>
</cfif>

<cfinvoke component='script.trends' method='unDupHCLast5Div' excludeDC='#noDCSel#' division='#theDiv#' returnVariable='aUndupHC'></cfinvoke>
<cfinvoke component='script.trends' method='completersLast5Div' excludeDC='#noDCSel#' division='#theDiv#' returnVariable='aCompleters'></cfinvoke>
<cfinvoke component='script.trends' method='placementsLast5Div' excludeDC='#noDCSel#' division='#theDiv#' returnVariable='aPlacements'></cfinvoke>
<cfset chartTitle = 'TSTC West Texas 5-Year Trend:  Enrollment, Completions, and *Placement\nInstructional Division: ' & theDiv>
<cfif theDiv neq 'All Divisions'>
	<cfinvoke component='script.trends' method='getDivMajors' division='#theDiv#' returnVariable='majors'></cfinvoke>
  <cfset chartTitle = chartTitle & '\nPrograms:'>
  <cfloop query='majors'>
  	<cfset chartTitle = chartTitle & ' ' & majors.major>
  </cfloop>
</cfif>
<cfchart format="png" title="#chartTitle#" showlegend="yes">
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
</cfchart>
<cfoutput>
<cfform name="filterDC" id="filterDC" action="./index.cfm?action=Reports_CoreInd_Div" method="post" format="html">
	<input type="hidden" name='divSelect' value='#theDiv#' />
  <input type="checkbox" name="noDC" <cfif noDCSel eq "on">checked</cfif> onClick="submit();" /> Filter Dual Credit Students
</cfform>
<cfform name="getPDF" id="getPDF" action="./index.cfm?action=Reports_CoreInd_DIV_PDF" method="post" format="html">
	<input type="hidden" name='divSelect' value='#theDiv#' />
  <input type="hidden" name='noDC2' value='#noDCSel#' />
  <input type="checkbox" name="genPDF" onClick="submit();" /> Get PDF Copy of Report
</cfform>
<p>Click on the check-box above to filter out dual credit high school students from these figures.</p>

<table class="retStatsTable">
	<tr>
  	<th>Ratios</th>
    <cfloop index="i" from="1" to="5">
    	<th>#aUndupHC[i].fy#</th>
    </cfloop>
  </tr>
  <tr>
  	<td>Completions to Enrollments</td>
    <cfloop index="i" from="1" to="5">
    	<td>#NumberFormat((aCompleters[i].awards / aUndupHC[i].undupHC),'9.99')#</td>
    </cfloop>
  </tr>
  <tr>
  	<td>*Placements to Completions</td>
    <cfloop index="i" from="1" to="5">
    	<td>#NumberFormat((aPlacements[i].placed / aCompleters[i].awards),'9.99')#</td>
    </cfloop>
  </tr>
</table>

<p>The ratios shown above indicate percentages of completion to enrollment on an annual basis, and the percentage of placements
to completions, also on an annual basis, for the past 5 fiscal years, and should indicate observable trends that may not
be readily discernable in the chart above.</p>
<p>* Placement figures indicate the number of completers who have gained employment in a field related to their academic program.</p>

<table class="retStatsTable">
	<tr>
  	<th>Figures</th>
    <cfloop index="i" from="1" to="5">
    	<th>#aUndupHC[i].fy#</th>
    </cfloop>
  </tr>
  <tr>
  	<td>Enrollments</td>
    <cfloop index="i" from="1" to="5">
    	<td>#aUndupHC[i].undupHC#</td>
    </cfloop>
  </tr>
  <tr>
  	<td>Completions</td>
    <cfloop index="i" from="1" to="5">
    	<td>#aCompleters[i].awards#</td>
    </cfloop>
  </tr>
  <tr>
  	<td>*Placements</td>
    <cfloop index="i" from="1" to="5">
    	<td>#aPlacements[i].placed#</td>
    </cfloop>
  </tr>
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
