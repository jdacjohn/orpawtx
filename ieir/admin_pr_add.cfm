<div id="mainBody">
  <!--- MAIN RIGHT --->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Office of Research, Planning and Analysis</h4>
      <h5 class="rubricHeading"><em><span>Add Program Review Documentation Sets</span></em></h5>
      <p>
      	Use the form below to upload Program Review Documentation for an Instructional Program.  Each documentation set
        should consist of 4 files:  Enrollment, Completions, and Placement, Demographics, Financial Analysis A, and
        Financial Analysis B.</p>
<cfoutput>
<cfinvoke component="script.pr_sets" method="getAYs" returnvariable="ays"></cfinvoke>
<cfinvoke component="script.pr_sets" method="getMajors" returnvariable="Majors"></cfinvoke>

<table class="loCreateTable" cellspacing="0" cellpadding="0">
<cfform name="add_set_f" id="add_set_f" enctype="multipart/form-data" action="./index.cfm?Action=DocSet_Submit_DB" method="post" format="html">
  <cfinput type="hidden" name="area" value="Prog_Rev" />
  <tr>
  	<td width="150">Acad. Year</td>
    <td width="150">
      <select name='availableAYs' onchange="javascript:selAY.value = this.value;">
      	<option value="">Available AYs</option>
        <cfloop query='ays'>
          <option value='#ays.ay#'>#ays.ay#</option>
        </cfloop>
      </select>
    </td>
    <td width="250"><input type='text' name='selAY' id='selAY' size="10" maxlength="4" /></td>
	</tr>
  <tr>
  	<td width="150">Major</td>
    <td width="150">
      <select name='availableMajors' onchange="javascript:selMajor.value = this.value;">
      	<option value="">Available Majors</option>
        <cfloop query='majors'>
          <option value='#majors.major#'>#majors.major#</option>
        </cfloop>
      </select>
    </td>
    <td width="250"><input type='text' name='selMajor' id='selMajor' size="10" maxlength="4" /></td>
	</tr>
  <tr>
  	<td width="150">Enrollments</td>
    <td width="400" colspan="2"><cfinput type='file' value='' name="EnrollmentPDF" id="EnrollmentPDF" size="40"/></td>
	</tr>
  <tr>
  	<td width="150">Demographics</td>
    <td width="400" colspan="2"><cfinput type='file' value='' name="DemoPDF" id="DemoPDF" size="40"/></td>
	</tr>
  <tr>
  	<td width="150">Fin. Anal. A</td>
    <td width="400" colspan="2"><cfinput type='file' value='' name="FinAPDF" id="FinAPDF" size="40"/></td>
	</tr>
  <tr>
  	<td width="150">Fin. Anal. B</td>
    <td width="400" colspan="2"><cfinput type='file' value='' name="FinBPDF" id="FinBPDF" size="40"/></td>
	</tr>
  <tr>
  	<td width="150">Narrative</td>
    <td width="400" colspan="2"><cfinput type='file' value='' name="narrative" id="narrative" size="40"/></td>
	</tr>
  <tr>
  	<td width="150">Outcomes</td>
    <td width="400" colspan="2"><cfinput type='file' value='' name="outcomes" id="outcomes" size="40"/></td>
	</tr>
  <tr>
    <td colspan="3" align="right"><hr width="100%" /></td>
  </tr>
  <tr>
    <td colspan="3" align="right"><input type="submit" value="Save" name="submit" /></td>
  </tr>
</cfform>
</table>
</cfoutput>        
    </div>
    <div class="rightContent" >
      <h4 class="blue linkage">Links</h4>
      <p>
        <cfinclude template="../body_links.cfm">
      </p>
    </div>
  </div>
  <!--- MAIN RIGHT END --->
  <div id="mainLeft">
    <!---- TER NAV --->
    <!---- <div class="leftNavContainer" >

<h4 class="blue principles">The T.E.R.</h4>
	<div class="navVertContainer">
		<ul>
    	<cfinclude template="ter_links.cfm">
		</ul>
	</div>
</div> --->
    <!--- TER NAV END --->
    <!---- Surveys NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue comm">PR Admin</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="ieir_pr_admin.cfm">
        </ul>
      </div>
    </div>
    <!--- Surveys NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
