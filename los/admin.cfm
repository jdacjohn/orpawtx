<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcomes Administration</h4>
	<cfif isdefined("major")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.programs' method='getProgFullNameById' progId=#p_id# returnvariable="progQuery"></cfinvoke>
		<cfinvoke component='script.los' method='getProgLOs' p_id=#p_id# returnvariable='outcomes'></cfinvoke>
		<!--- Learning Outcomes Section --->
		<h5 class="blueback">#progQuery.progName# Program Learning Outcomes <b>(#outcomes.recordcount#)</b>&nbsp;&nbsp;&nbsp;<a href="./index.cfm?action=LOS_NewSLO&prog=#p_id#">Add New?</a>&nbsp;&nbsp;&nbsp;</h5>

		<cfif outcomes.recordcount eq 0>
			No Learning Outcomes were found for this program.  Would you like to <a href="./index.cfm?action=LOS_NewSLO&prog=#p_id#">Create a new Learning Outcome</a>?
		<cfelse>
			<table class="loSummaryTable" cellspacing="0" cellpadding="0">
			<cfloop query="outcomes">
  		<cfinvoke component='script.los' method='countMeasures' loid=#outcomes.loid# returnvariable='measureCount'></cfinvoke>
  			<tr>
    			<td width="150"><b><a title="#outcomes.loDesc#">#outcomes.loShortName#</a></b></td>
      		<td width="50" align="center"><cfif outcomes.lo_pdf neq ''><a href="./los/files/#outcomes.lo_pdf#" target="_blank" title="Get PDF File"><img #Application.Settings.PDFImg# /></a></cfif></td>
      		<td width="100"><cfif measureCount eq 0><span style="color:##FF0000">Measures</span><cfelse>Measures</cfif> (#measureCount#)</td>
      		<td width="40"><cfif measureCount gt 0><a href="./index.cfm?action=LOS_ViewMeasures&loid=#outcomes.loid#&prog=#major#" title="View Measures"><img #Application.Settings.ViewImg# /></a></cfif></td>
      		<td width="30" align="left"><a href="./index.cfm?action=LOS_AddMeasure&loid=#outcomes.loid#&current=#measureCount#&prog=#major#" title="Add New Measure"><img #Application.Settings.AddImg# /></a></td>
      		<td width="220">&nbsp;&nbsp;<a href="./index.cfm?action=LOS_EditSLO&loid=#outcomes.loid#&prog=#major#" title="Edit Outcome"><img #Application.Settings.EditImg# /></a></td>
    		</tr>
  		</cfloop>
  		</table>
		</cfif>
    &nbsp;<br />
    <h5 class="blueback"><a href="./index.cfm?action=LOS_EditCM&prog=#p_id#">Curriculum Map</a></h5>
    <cfinvoke component='script.los' method='getAGTerms' progId=#p_id# returnVariable="groups"></cfinvoke>
    <h5 class="blueback">Term Assessments
    <cfloop query="groups">&nbsp;<a href="./index.cfm?action=LOS_Admin&major=#major#&p_id=#p_id#&term=#groups.agTerm#">#groups.agTerm#</a>&nbsp;</cfloop>
    <a href="./index.cfm?action=LOS_Admin&major=#major#&p_id=#p_id#&showall=1">Show All</a>
    </h5>
    <cfif isDefined('showall')>
      <cfloop query='groups'>
        <h5 class="blueback">#groups.agTerm#</h5>
        <cfinvoke component='script.los' method='getAssignments' progId=#p_id# term='#groups.agTerm#' returnVariable="aGroups"></cfinvoke>
        <table class="loSummaryTable" cellspacing="0" cellpadding="0">
          <tr>
            <th>Class</th>
            <th>Outcome</th>
            <th>Level</th>
            <th>Students</th>
            <th>Completed</th>
            <th>Pct Complete</th>
            <th>Due Date</th>
          </tr>
          <cfloop query='aGroups'>
          <cfinvoke component='script.los' method='getOutcomeById' outcomeId=#aGroups.loid# returnVariable='q_lo'></cfinvoke>
          <cfinvoke component='script.los' method='countAssessments' groupId=#aGroups.loa_group_id# returnVariable='assessments'></cfinvoke>
          <cfset pctComplete = (assessments.count / aGroups.enrolled) * 100>
          <tr>
            <td>#aGroups.class#</td>
            <td>#q_lo.loShortName#</td>
            <td>#aGroups.lo_level#</td>
            <td>#aGroups.enrolled#</td>
            <td>#assessments.count#</td>
            <td>#NumberFormat(pctComplete,'99.99')#</td>
            <td>#DateFormat(aGroups.group_exp,'mm-dd-yyyy')#</td>
          </tr>
          </cfloop>
          </table>
      </cfloop>
    <cfelse>
    	<cfif isDefined('term')>
      	<cfset agTerm = #term#>
      <cfelse>
      	<cfset agTerm = Application.Settings.LOTerm>
      </cfif>
      <h5 class="blueback">#agTerm#</h5>
      <cfinvoke component='script.los' method='getAssignments' progId=#p_id# term='#agTerm#' returnVariable="aGroups"></cfinvoke>
      <table class="loSummaryTable" cellspacing="0" cellpadding="0">
        <tr>
          <th>Class</th>
          <th>Outcome</th>
          <th>Level</th>
          <th>Students</th>
          <th>Completed</th>
          <th>Pct Complete</th>
          <th>Due Date</th>
        </tr>
        <cfloop query='aGroups'>
        <cfinvoke component='script.los' method='getOutcomeById' outcomeId=#aGroups.loid# returnVariable='q_lo'></cfinvoke>
        <cfinvoke component='script.los' method='countAssessments' groupId=#aGroups.loa_group_id# returnVariable='assessments'></cfinvoke>
        <cfif aGroups.enrolled gt 0>
					<cfset pctComplete = (assessments.count / aGroups.enrolled) * 100>
        <cfelse>
        	<cfset pctComplete = 100>
        </cfif>
        <tr>
          <td>#aGroups.class#</td>
          <td>#q_lo.loShortName#</td>
          <td>#aGroups.lo_level#</td>
          <td>#aGroups.enrolled#</td>
          <td>#assessments.count#</td>
          <td>#NumberFormat(pctComplete,'99.99')#</td>
          <td>#DateFormat(aGroups.group_exp,'mm-dd-yyyy')#</td>
        </tr>
        </cfloop>
      </table>
		</cfif>
		</cfoutput>
		</div>
	<cfelse>
		<div class="rightContent">  
			<p>Select a program from the list on the left to begin.</p>
    </div>
	</cfif>

	<cfif Action eq 'App_Home_Sys_Down'>
		<cfoutput>
		<p><span style="color:##ff0000; text-decoration:underline;">The #Application.Settings.SiteOwner2# Website is currently down for routine maintenance.  Please try
		back later.  We apologize for the inconvenience.  Please contact <a href="mailto:#Application.Settings.SiteContactEmail#">#Application.Settings.SiteContactName#</a> via email
		with any questions, or call #Application.Settings.SiteContactPhone#.</span><br />Thank You.</p>
		</cfoutput>
	</cfif>

</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">

<!--- Program NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Majors</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_majors_links.cfm">
		</ul>
	</div>
</div>
<!--- Program NAV END --->

<!--- PGM Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Program Learning Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_pgm_links.cfm">
		</ul>
	</div>
</div>
<!--- Outcomes PGM NAV END --->

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
