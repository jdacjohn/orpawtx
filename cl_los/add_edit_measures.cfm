<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="mainRight">


<div class="rightContent" >
<h4 class="blue instructional"><cfoutput>#Application.Settings.CLCollege#</cfoutput> Student Learning Outcomes</h4>
<cfif isdefined("loid") && loid neq 0>
	<cfset theLO = loid>
  <cfinvoke component='script.cl_los' method='getOutcomeById' outcomeId=#theLO# returnVariable='theOutcome'></cfinvoke>
<cfelse>
	<cfset theLO = ''>
</cfif>
<cfoutput>
<h5 class="blueback">&nbsp;Course Learning Outcome - <a href="./index.cfm?action=CL_LOS_Admin_Add&loid=#theLO#" title="Return to Outcome">#theOutcome.loName#</a></h5>
<p><span style="text-decoration:underline"><b>Description:</b></span><br />#theOutcome.loDesc# - (Rev. #theOutcome.loRevMonth#/#theOutcome.loRevYear#)
<br />
<hr width="100%" />
<table class="cloSummaryTable" width="550" cellspacing="0" cellpadding="0">
<cfinvoke component='script.cl_los' method='countMeasures' loid=#theOutcome.loid# returnvariable='measureCount'></cfinvoke>
  <tr>
    <td width="50" align="center"><cfif theOutcome.lo_pdf neq ''><a href="./cl_los/files/#theOutcome.lo_pdf#" target="_blank" title="Get PDF"><img #Application.Settings.PDFImg# /></a></cfif></td>
    <td width="150" style="vertical-align:middle;"><b><a title="#theOutcome.loDesc#">#theOutcome.loShortName#</a></b></td>
    <td width="100" style="vertical-align:middle;"><cfif measureCount eq 0><span style="color:##FF0000">Measures</span><cfelse>Measures</cfif> (#measureCount#)</td>
    <td width="40">&nbsp;</td>
    <td width="30" align="left">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

</p>
<cfif theLO neq ''>
	<h5 class="blueback">&nbsp;Assessment Measures</h5>
	<p>
  <cfinvoke component='script.cl_los' method='getMeasures' loid=#loid# returnVariable='measures'></cfinvoke>
  <cfset critlabels = ArrayNew(1)>
  <cfset critlabels[1] = 'Beginning'>
  <cfset critlabels[2] = 'Developing'>
  <cfset critlabels[3] = 'Competent'>
  <cfset critlabels[4] = 'Accomplished'>

<table class="cloSummaryTable" cellspacing="0" cellpadding="0">
	<cfset measureCount=1>
  <cfloop query='measures'>
  <cfform name="#('editMeasure' & measureCount)#" id="#('editMeasure' & measureCount)#" action="./index.cfm?Action=CLOS_UpdateMeasure_DB" method="post" format="html">
    <input type="hidden" name="lo_id" value="#loid#" />
    <input type="hidden" name="lomid" value="#measures.lomid#" />
    <input type="hidden" name="disc" value="#disc#" />
  <tr>
    <td colspan="2"><h5 class="blueback"><span style="text-decoration:underline">Measurement Criteria #measureCount#</span>&nbsp;<a href="index.cfm?action=CL_LOS_Admin_Add_Xmeasure&lomid=#measures.lomid#&loid=#theLO#">Delete</a></h5></td>
  </tr>
  <tr>
  	<td width="150" valign="top">Activity</td>
    <td width="430"><textarea class="loEntryInput" name="lomDesc" id="lomDesc" value="" rows="4" cols="75">#measures.lomDescription#</textarea></td>
	</tr>
  <cfinvoke component='script.cl_los' method='getCriteria' lomid=#measures.lomid# returnVariable='criteria'></cfinvoke>
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
    <td colspan="2" align="left"><input type="submit" value="Update" name="submit" /></td>
  </tr>
  </cfform>
  <cfset measureCount += 1>
	</cfloop>

</table>
  </p>
</cfif>  
</cfoutput>

<p>Please contact <a href="mailto:john.arnold@sweetwater.tstc.edu">John Arnold</a> in the Office of Research,
Planning & Analysis at <span style="text-decoration:underline">325.235.7408</span> with any questions or suggestions.
</p>

</div>


<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p>
<cfinclude template='body_links.cfm'>
</p>
</div>


</div>

<!--- MAIN RIGHT END --->


<div id="mainLeft">

<!--- Course Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Browse Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_browse_links.cfm">
		</ul>
	</div>
</div>
<!--- Course Outcomes NAV END --->

<!--- Course Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Course Learning</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_cl_links.cfm">
		</ul>
	</div>
</div>
<!--- Course Outcomes NAV END --->

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
