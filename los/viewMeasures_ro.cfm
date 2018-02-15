<div id="mainBody">

<!-- MAIN RIGHT --->
<div id="loMainRight">

<div class="rightContent" >
<cfoutput>
<h4 class="blue instructional">#Application.Settings.CollegeShortName# Student Learning Outcomes</h4>
<cfif isdefined("loid")>
<cfinvoke component='script.los' method='getOutcomeById' outcomeId=#loid# returnvariable="outcome_q"></cfinvoke>
<cfinvoke component='script.los' method='getMeasures' loid=#loid# returnVariable='measures'></cfinvoke>
<cfset critlabels = ArrayNew(1)>
<cfset critlabels[1] = 'Beginning'>
<cfset critlabels[2] = 'Developing'>
<cfset critlabels[3] = 'Competent'>
<cfset critlabels[4] = 'Accomplished'>

<!--- Required Information Section --->
<h5 class="blueback"><a href="./index.cfm?action=LOS_Browse&major=#prog#&p_id=#outcome_q.pid#" title="Return to #prog#">#prog#</a> - Student Learning Outcome:  #outcome_q.loName# - Assessment Measures</h5>
<p>
<table class="loCreateTable" cellspacing="0" cellpadding="0">
  <tr>
  	<td width="150">Program Name</td>
    <td width="430">#outcome_q.loProgramName#</td>
	</tr>
  <tr>
  	<td width="150">SLO Name</td>
    <td width="430">#outcome_q.loName#</td>
	</tr>
  <tr>
  	<td width="150" valign="top">Description</td>
    <td width="430">#outcome_q.loDesc#</td>
	</tr>
  <tr>
  	<td width="150">Rev Month</td>
    <td width="430">#outcome_q.loRevMonth#</td>
	</tr>
  <tr>
  	<td width="150">Rev Year</td>
    <td width="430">#outcome_q.loRevYear#</td>
	</tr>
  <cfloop query='measures'>
  <tr>
    <td colspan="2"><h5 class="blueback">Assessment Measure Information: Activity #measures.measureNum#</h5></td>
  </tr>
  <tr>
  	<td width="150" valign="top">Activity</td>
    <td width="430">#measures.lomDescription#</td>
	</tr>
  <cfinvoke component='script.los' method='getCriteria' lomid=#measures.lomid# returnVariable='criteria'></cfinvoke>
  <tr>
    <td colspan="2"><h5 class="blueback">Measurement Criteria: Activity #measures.measureNum#</h5></td>
  </tr>
  <cfloop query='criteria'>
  <tr>
  	<td width="150" valign="top">#critlabels[criteria.lomrScore]#</td>
    <td width="430">#criteria.lomrDescription#</td>
	</tr>
  <tr>
    <td colspan="2" align="right"><hr width="100%" /></td>
  </tr>
	</cfloop>
	</cfloop>

</table>
  
</p>
<cfelse>
<p>
<!--- Select a program from the list on the left to begin. --->
</p>
</cfif>
</cfoutput>

<cfif Action eq 'App_Home_Sys_Down'>
<cfoutput>
<p><span style="color:##ff0000; text-decoration:underline;">The #Application.Settings.SiteOwner2# Website is currently down for routine maintenance.  Please try
back later.  We apologize for the inconvenience.  Please contact <a href="mailto:#Application.Settings.SiteContactEmail#">#Application.Settings.SiteContactName#</a> via email
with any questions, or call #Application.Settings.SiteContactPhone#.</span><br />Thank You.</p>
</cfoutput>
</cfif>
</div>


</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">

<!--- Program NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Program Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_pgm_links.cfm">
		</ul>
	</div>

</div>
<!--- Program NAV END --->

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
