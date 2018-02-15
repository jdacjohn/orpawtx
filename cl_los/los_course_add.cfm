<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="mainRight">


<div class="rightContent" >
<h4 class="blue instructional"><cfoutput>#Application.Settings.CLCollege#</cfoutput> Student Learning Outcomes Management</h4>
<p>
<cfoutput>
<!--- Required Information Section --->
<h5 class="blueback">&nbsp;New Course Learning Outcome</h5>
<p>
Creating a new learning outcome rubric is a multistep process.  First, you will create the outcome by providing a name and description,
and associating the outcome with a 4- or 5-letter rubric representing the discipline to support ease of future searches for and classifications of
these outcomes.  Once this initial step has been completed, you will then create the required assessment measure(s) and rating
criteria for these measures.
To get started, enter the following information and then click the Save button. Required fields are marked with *.  
<span style="font-weight:bold">The Name of the Learning Outcome must be Unique.</span><br />
<hr width="100%" />
<table class="cloCreateTable" width="100%" cellspacing="0" cellpadding="0">
<cfif isdefined("loid") && loid neq 0>
	<cfset theLO = loid>
  <cfinvoke component='script.cl_los' method='getOutcomeById' outcomeId=#theLO# returnVariable='theOutcome'></cfinvoke>
<cfelse>
	<cfset theLO = ''>
</cfif>
<cfinvoke component='script.cl_los' method='getDisciplines' returnvariable='disciplines'></cfinvoke>

<cfform name="lo_entry_f" id="lo_entry_f" enctype="multipart/form-data" action="./index.cfm?Action=CL_LOS_Submit_DB" 
	method="post" format="html" preservedata="yes">
  <tr>
  	<td width="150">*Program</td>
    <td width="150">
      <select name='availableSections' onchange="javascript:selRubric.value = this.value;">
      	<option value="">Available Programs</option>
        <cfloop query='disciplines'>
          <option value='#disciplines.prog#' <cfif (theLO neq '') && (theOutcome.lo_rubric eq disciplines.prog)>selected</cfif> >#disciplines.prog#</option>
        </cfloop>
      </select>
    </td>
    <cfif theLO neq ''>
    	<cfset program = theOutcome.lo_rubric>
    <cfelse>
    	<cfset program = ''>
    </cfif>
    <td width="250"><cfinput type='text' value='#program#' name='selRubric' id='selRubric' size="10" maxlength="10" required="yes" message="You must either select a program from the list or enter a program." /></td>
	</tr>
  <tr>
  	<td width="150">*Outcome Name</td>
    <cfif theLO neq ''>
    	<cfset loName = theOutcome.loName>
    <cfelse>
    	<cfset loName = ''>
    </cfif>
    <td width="400" colspan="2"><cfinput type='text' value='#loName#' name='loName' id='loName' size="60" maxlength="50" required="yes" message="You must provide a name for the learning outcome." /></td>
	</tr>
  <tr>
  	<td width="150">*Outcome Display Name</td>
    <cfif theLO neq ''>
    	<cfset shortName = theOutcome.loShortName>
    <cfelse>
    	<cfset shortName = ''>
    </cfif>
    <td width="400" colspan="2"><cfinput type='text' value='#shortName#' name='loShortName' id='loShortName' size="60" maxlength="20" required="Yes" message="You must provide an alternate name to be used in limited displays." /></td>
	</tr>
  <tr>
  	<td width="150" valign="top">*Description</td>
    <cfif theLO neq ''>
    	<cfset desc = theOutcome.loDesc>
    <cfelse>
    	<cfset desc = ''>
    </cfif>
    <td width="400" colspan="2"><textarea class="loEntryInput" name="loDesc" id="loDesc" value="" rows="4" cols="75" required="yes" message="You must provide a description of the outcome." maxlength="400" >#desc#</textarea></td>
	</tr>
  <tr>
  	<td width="150">*Rev Month</td>
    <cfif theLO neq ''>
    	<cfset revM = theOutcome.loRevMonth>
    <cfelse>
    	<cfset revM = ''>
    </cfif>
    <td width="400" colspan="2"><cfinput type='text' value='#revM#' name='revMo' id='revMo' size="12" maxlength="2" required="yes" message="Please provide the revision month for this outcome." /></td>
	</tr>
  <tr>
  	<td width="150">*Rev Year</td>
    <cfif theLO neq ''>
    	<cfset revY = theOutcome.loRevYear>
    <cfelse>
    	<cfset revY = ''>
    </cfif>
    <td width="400" colspan="2"><cfinput type='text' value='#revY#' name='revYear' id='revYear' size="12" maxlength="4" required="yes" message="Please provide the revision year for this outcome." /></td>
	</tr>
  <cfif theLO eq ''>
  <tr>
  	<td width="150">PDF File</td>
    <td width="400" colspan="2"><cfinput type='file' value='' name="pdfFile" id="pdfFile" size="45"/></td>
	</tr>
	<tr><td colspan="3"><hr width="100%" /></td></tr>
  <tr>
    <td colspan="3" align="right"><input type="submit" value="Save" name="submit" /></td>
  </tr>
  </cfif>
</cfform>
	<cfif isdefined("loid") && loid eq 0>
  	<tr><td colspan="3" style="color:##ff0000;font-weight:bold">The name entered for Learning Outcome already exists 
    in the system. Please re-enter the outcome using a different name, or if you would like to copy an existing outcome from 
    one program to another, use the Copy Outcomes link found in the left navigation links.</td></tr>
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
      <td width="40"><cfif measureCount gt 0><a href="./index.cfm?action=CL_LOS_BrowseAdd_Outcome&loid=#theOutcome.loid#" title="View Measures"><img #Application.Settings.ViewImg# /></a></cfif></td>
      <td width="30" align="left"><a href="./index.cfm?action=CL_LOS_AddMeasure&loid=#theOutcome.loid#&current=#measureCount#" title="Add New Measure"><img #Application.Settings.AddImg# /></a></td>
      <td><cfif measureCount gt 0>&nbsp;&nbsp;<a href="./index.cfm?action=CLOS_EditSLO&loid=#theOutcome.loid#&disc=#program#" title="Edit Measures"><img #Application.Settings.EditImg# /></a></cfif>
      		&nbsp;&nbsp;<a href="./index.cfm?action=CL_LOS_Create_Link&outcomeId=#theOutcome.loid#&disc=#theOutcome.lo_rubric#" title="Link Outcome to Class"><img #Application.Settings.LinkImg# /></a>
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

<!--- Outcomes Admin NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Manage Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_cl_admin_links.cfm">
		</ul>
	</div>
</div>
<!--- Outcomes Admin NAV END --->

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
