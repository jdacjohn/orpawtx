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
<h5 class="blueback"><a href="./index.cfm?action=LOS_Admin&major=#prog#&p_id=#outcome_q.pid#">#prog#</a> - Student Learning Outcome:  #outcome_q.loName# - Assessment Measures</h5>
<p>
<hr width="100%" />
<table class="loCreateTable" cellspacing="0" cellpadding="0">
<cfform name="am_entry_f" id="am_entry_f" action='' method="post" format="html">
	<input type="hidden" name="lo_id" value="#loid#" />
  <input type="hidden" name="major" value="#prog#" />
  <input type="hidden" name="p_id" value="#outcome_q.pid#" />
  <tr>
  	<td width="150">Program Name</td>
    <td width="430"><input type='text' value='#outcome_q.loProgramName#' name='progName' id='progName' size="60" readonly /></td>
	</tr>
  <tr>
  	<td width="150">SLO Name</td>
    <td width="430"><input type='text' value='#outcome_q.loName#' name='loName' id='loName' size="60" readonly /></td>
	</tr>
  <tr>
  	<td width="150" valign="top">Description</td>
    <td width="430"><textarea class="loEntryInput" name="loDesc" id="loDesc" value="#outcome_q.loDesc#" rows="4" cols="75" readonly>#outcome_q.loDesc#</textarea></td>
	</tr>
  <tr>
  	<td width="150">Rev Month</td>
    <td width="430"><input type='text' value='#outcome_q.loRevMonth#' name='revMo' id='revMo' size="12" readonly /></td>
	</tr>
  <tr>
  	<td width="150">Rev Year</td>
    <td width="430"><input type='text' value='#outcome_q.loRevYear#' name='revYear' id='revYear' size="12" readonly /></td>
	</tr>
  </cfform>
  <cfloop query='measures'>
  <cfform name="#('am_edit_f' & measures.lomid)#" id="#('am_edit_f' & measures.lomid)#" action="./index.cfm?Action=LOS_UpdateMeasure_DB" method="post" format="html">
    <input type="hidden" name="lo_id" value="#loid#" />
    <input type="hidden" name="major" value="#prog#" />
    <input type="hidden" name="lomid" value="#measures.lomid#" />
  <tr>
    <td colspan="2"><h5 class="blueback">Assessment Measure Information: Activity #measures.measureNum#&nbsp;&nbsp;&nbsp;<a href="./index.cfm?action=LOS_DelLOM&lomid=#measures.lomid#&loid=#loid#&prog=#prog#">Delete</a></h5></td>
  </tr>
  <tr>
  	<td width="150" valign="top">Activity</td>
    <td width="430"><textarea class="loEntryInput" name="lomDesc" id="lomDesc" value="" rows="4" cols="75">#measures.lomDescription#</textarea></td>
	</tr>
  <cfinvoke component='script.los' method='getCriteria' lomid=#measures.lomid# returnVariable='criteria'></cfinvoke>
  <tr>
    <td colspan="2"><h5 class="blueback">Measurement Criteria: Activity #measures.measureNum#</h5></td>
  </tr>
  <cfloop query='criteria'>
  <tr>
  	<td width="150" valign="top">#critlabels[criteria.lomrScore]#</td>
    <td width="430"><textarea class="loEntryInput" name="#critlabels[criteria.lomrscore]#" id="#critlabels[criteria.lomrscore]#" rows="4" cols="75">#criteria.lomrDescription#</textarea></td>
	</tr>
  <tr>
    <td colspan="2" align="right"><hr width="100%" /></td>
  </tr>
	</cfloop>
  <tr>
    <td colspan="2" align="right"><input type="submit" value="Update" name="submit" /></td>
  </tr>
	</cfform>
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

<!--- <h4 class="blue principles">Majors</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_majors_links.cfm">
		</ul>
	</div> --->
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
