<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="mainRight">


<div class="rightContent" >
<h4 class="blue instructional"><cfoutput>#Application.Settings.CLCollege#</cfoutput> Student Learning Outcomes Management</h4>
<p>
<cfoutput>
<!--- Required Information Section --->
<h5 class="blueback">&nbsp;Edit Course Learning Outcome</h5>
<p>
To get started, update any of the following information and then click the Save button.   
<span style="font-weight:bold">The Name of the Learning Outcome cannot be changed.</span><br />
<hr width="100%" />
<table class="cloCreateTable" width="100%" cellspacing="0" cellpadding="0">
<cfif isdefined("loid") && loid neq 0>
	<cfset theLO = loid>
  <cfinvoke component='script.cl_los' method='getOutcomeById' outcomeId=#theLO# returnVariable='theOutcome'></cfinvoke>
<cfelse>
	<cfset theLO = ''>
</cfif>

<cfform name="lo_entry_f" id="lo_entry_f" enctype="multipart/form-data" action="./index.cfm?Action=CL_LOS_Update_DB" method="post" format="html" preservedata="yes">
	<input type="hidden" name="loid" value="#theLO#" />
  <input type="hidden" name="class" value="#disc#" />
  <tr>
  	<td width="150">Program</td>
    </td>
    <td width="400"><input type='text' readonly='true' value='#theOutcome.lo_rubric#' name='selRubric' id='selRubric' size="10" maxlength="5" /></td>
	</tr>
  <tr>
  	<td width="150">Outcome Name</td>
    <td width="400" colspan="2"><input type='text' value='#theOutcome.loName#' name='loName' id='loName' size="60" maxlength="50"/></td>
	</tr>
  <tr>
  	<td width="150">Outcome Display Name</td>
    <td width="400" colspan="2"><input type='text' value='#theOutcome.loShortName#' name='loShortName' id='loShortName' size="60" maxlength="20"/></td>
	</tr>
  <tr>
  	<td width="150" valign="top">Description</td>
    <td width="400" colspan="2"><textarea class="loEntryInput" name="loDesc" id="loDesc" value="" rows="4" cols="75" >#theOutcome.loDesc#</textarea></td>
	</tr>
  <tr>
  	<td width="150">Rev Month</td>
    <td width="400" colspan="2"><input type='text' <cfif theLO neq ''>value='#theOutcome.loRevMonth#'<cfelse>value=''</cfif> name='revMo' id='revMo' size="12" maxlength="2" /></td>
	</tr>
  <tr>
  	<td width="150">Rev Year</td>
    <td width="400" colspan="2"><input type='text' <cfif theLO neq ''>value='#theOutcome.loRevYear#'<cfelse>value=''</cfif> name='revYear' id='revYear' size="12" maxlength="4" /></td>
	</tr>
  <tr>
  	<td width="150">Update PDF File</td>
    <td width="400" colspan="2"><cfinput type='file' value='' name="pdfFile" id="pdfFile" size="45"/></td>
	</tr>
	<tr><td colspan="3"><hr width="100%" /></td></tr>
  <tr>
    <td colspan="3" align="right"><input type="submit" value="Save" name="submit" /></td>
  </tr>
</cfform>
	<cfif isdefined("loid") && loid eq 0>
  	<tr><td colspan="3" style="color:##ff0000;font-weight:bold">The name entered for Learning Outcome already exists for 
    the selected discipline in the system. Please choose another name.</td></tr>
 	</cfif>
</table>
<hr width="100%" />
</p>
<cfif theLO neq ''>
	<h5 class="blueback">&nbsp;Assessment Measures</h5>
	<p>Use the links below to add the assessment measures and rating criteria for this learning outcome.
  <table class="cloSummaryTable" width="550" cellspacing="0" cellpadding="0">
  <cfinvoke component='script.cl_los' method='countMeasures' loid=#theOutcome.loid# returnvariable='measureCount'></cfinvoke>
    <tr>
      <td width="150" style="vertical-align:middle;"><b><a title="#theOutcome.loDesc#">#theOutcome.loShortName#</a></b></td>
      <td width="50" align="center"><cfif theOutcome.lo_pdf neq ''><a href="./cl_los/files/#theOutcome.lo_pdf#" target="_blank"><img #Application.Settings.PDFImg# /></a></cfif></td>
      <td width="100" style="vertical-align:middle;"><cfif measureCount eq 0><span style="color:##FF0000">Measures</span><cfelse>Measures</cfif> (#measureCount#)</td>
      <td width="40"><cfif measureCount gt 0><a href="./index.cfm?action=CL_LOS_BrowseEdit_Outcome&loid=#theOutcome.loid#&disc=#disc#" title="View Measures"><img #Application.Settings.ViewImg# /></a></cfif></td>
      <td width="30" align="left"><a href="./index.cfm?action=CL_LOS_Edit_AddMeasure&loid=#theOutcome.loid#&current=#measureCount#&disc=#disc#" title="Add New Measure"><img #Application.Settings.AddImg# /></a></td>
      <td>&nbsp;&nbsp;<a href="./index.cfm?action=CL_LOS_Edit_Measures&loid=#theOutcome.loid#&disc=#disc#" title="Edit Measures"><img #Application.Settings.EditImg# /></a>
      		&nbsp;&nbsp;<a href="./index.cfm?action=CL_LOS_Edit_Link&outcomeId=#theOutcome.loid#&disc=#theOutcome.lo_rubric#" title="Link Outcome to Class"><img #Application.Settings.LinkImg# /></a>
      </td>
    </tr>
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

<!--- Course Admin NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Find Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_edit_links.cfm">
		</ul>
	</div>
</div>
<!--- Course Admin NAV END --->

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
