<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcomes Home</h4>
	<cfif isdefined("major")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.programs' method='getProgFullNameById' progId=#p_id# returnvariable="progQuery"></cfinvoke>
		<cfinvoke component='script.los' method='getProgLOs' p_id=#p_id# returnvariable='outcomes'></cfinvoke>
		<!--- Learning Outcomes Section --->
		<h5 class="blueback">#progQuery.progName# Program Learning Outcomes <b>(#outcomes.recordcount#)</b></h5>

		<cfif outcomes.recordcount eq 0>
			No Learning Outcomes were found for this program. If this information is in error, please contact: <br />&nbsp;<br />
      #Application.Settings.SiteContactName#<br />
      #Application.Settings.SiteOwner1#<br />
      #Application.Settings.SiteContactPhone#<br />
      #Application.Settings.SiteContactEmail#<br />
		<cfelse>
			<table class="loSummaryTable" cellspacing="0" cellpadding="0">
			<cfloop query="outcomes">
  		<cfinvoke component='script.los' method='countMeasures' loid=#outcomes.loid# returnvariable='measureCount'></cfinvoke>
  			<tr>
    			<td width="150"><b><a title="#outcomes.loDesc#">#outcomes.loShortName#</a></b></td>
      		<td width="50" align="center">&nbsp;<cfif outcomes.lo_pdf neq ''><a href="./los/files/#outcomes.lo_pdf#" title="Get PDF" target="_blank"><img #Application.Settings.PDFImg# /></a></cfif></td>
      		<td width="100">&nbsp;<cfif measureCount eq 0><span style="color:##FF0000">Measures</span><cfelse>Measures</cfif> (#measureCount#)</td>
      		<td width="40"><cfif measureCount gt 0><a href="./index.cfm?action=LOS_ViewMeasures_RO&loid=#outcomes.loid#&prog=#major#" title="View Measures"><img #Application.Settings.ViewImg# /></a></cfif></td>
      		<td width="30" align="left">&nbsp;</td>
      		<td width="220">&nbsp;</td>
    		</tr>
  		</cfloop>
  		</table>
		</cfif>
    &nbsp;<br />
    <h5 class="blueback"><a href="./index.cfm?action=LOS_ViewCM_RO&prog=#p_id#">Curriculum Map</a></h5>
    <cfinvoke component='script.los' method='getAGTerms' progId=#p_id# returnVariable="groups"></cfinvoke>
    <h5 class="blueback">Term Assessments
    <cfloop query="groups">&nbsp;<a href="./index.cfm?action=LOS_Browse&major=#major#&p_id=#p_id#&term=#groups.agTerm#" title="View Term Assessment Groups">#groups.agTerm#</a>&nbsp;</cfloop>
    <a href="./index.cfm?action=LOS_Browse&major=#major#&p_id=#p_id#&showall=1" title="View All Assessment Groups">Show All</a>
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
            <th>Outstanding</th>
            <th>Due Date</th>
          </tr>
          <cfloop query='aGroups'>
          <cfinvoke component='script.los' method='getOutcomeById' outcomeId=#aGroups.loid# returnVariable='q_lo'></cfinvoke>
          <cfinvoke component='script.los' method='countAssessments' groupId=#aGroups.loa_group_id# returnVariable='assessments'></cfinvoke>
          <cfset togo = aGroups.enrolled - assessments.count>
          <tr>
            <td>#aGroups.class#</td>
            <td>#q_lo.loShortName#</td>
            <td>#aGroups.lo_level#</td>
            <td>#aGroups.enrolled#</td>
            <td>#assessments.count#</td>
            <td>#togo#</td>
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
          <th>Outstanding</th>
          <th>Due Date</th>
        </tr>
        <cfloop query='aGroups'>
        <cfinvoke component='script.los' method='getOutcomeById' outcomeId=#aGroups.loid# returnVariable='q_lo'></cfinvoke>
        <cfinvoke component='script.los' method='countAssessments' groupId=#aGroups.loa_group_id# returnVariable='assessments'></cfinvoke>
        <cfset togo = aGroups.enrolled - assessments.count>
        <tr>
          <td>#aGroups.class#</td>
          <td>#q_lo.loShortName#</td>
          <td>#aGroups.lo_level#</td>
          <td>#aGroups.enrolled#</td>
          <td>#assessments.count#</td>
          <td>#togo#</td>
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

  <div class="rightContent" >
  <h4 class="blue linkage">Links</h4>
  
  <p>
  <img class='rightImg' src='images/logo/ieir_logo_200px.gif' />
  <cfinclude template='body_links.cfm'>
  </p>
  </div>

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
