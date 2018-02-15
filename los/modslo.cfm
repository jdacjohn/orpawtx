<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">


<div class="rightContent" >
<cfoutput>
<h4 class="blue instructional">#Application.Settings.CollegeShortName# Student Learning Outcomes</h4>
<cfif isdefined("loid")>
<cfinvoke component='script.los' method='getOutcomeById' outcomeId=#loid# returnvariable="outcome_q"></cfinvoke>

<!--- Required Information Section --->
<h5 class="blueback"><a href="./index.cfm?action=LOS_Admin&major=#prog#&p_id=#outcome_q.pid#">#prog#</a> - Student Learning Outcome:  #outcome_q.loName#</h5>
<p>
<hr width="100%" />
<table class="loCreateTable" cellspacing="0" cellpadding="0">
<cfform name="mod_slo_f" id="am_entry_f" enctype="multipart/form-data" action="./index.cfm?Action=LOS_Update_DB" method="post" format="html">
	<input type="hidden" name="lo_id" value="#loid#" />
  <input type="hidden" name="major" value="#prog#" />
  <input type="hidden" name="p_id" value="#outcome_q.pid#" />
  <tr>
  	<td width="150">Program Name</td>
    <td width="430"><input type='text' value='#outcome_q.loProgramName#' name='progName' id='progName' size="60" readonly /></td>
	</tr>
  <tr>
  	<td width="150">SLO Name</td>
    <td width="430"><input type='text' value='#outcome_q.loName#' name='loName' id='loName' size="60" /></td>
	</tr>
  <tr>
  	<td width="150">SLO Abb. Name</td>
    <td width="430"><input type='text' value='#outcome_q.loShortName#' name='loShortName' id='loShortName' size="60" maxlength="20" /></td>
	</tr>
  <tr>
  	<td width="150" valign="top">Description</td>
    <td width="430"><textarea class="loEntryInput" name="loDesc" id="loDesc" value="#outcome_q.loDesc#" rows="4" cols="75" />#outcome_q.loDesc#</textarea></td>
	</tr>
  <tr>
  	<td width="150">Rev Month</td>
    <td width="430"><input type='text' value='#outcome_q.loRevMonth#' name='revMo' id='revMo' size="12" /></td>
	</tr>
  <tr>
  	<td width="150">Rev Year</td>
    <td width="430"><input type='text' value='#outcome_q.loRevYear#' name='revYear' id='revYear' size="12" /></td>
	</tr>
  <tr>
  	<td width="150">PDF File</td>
    <td width="430"><input type='text' value='#outcome_q.lo_pdf#' name="nowFile" id="nowFile" size="60" disabled /></td>
	</tr>
  <tr>
  	<td width="150">New PDF File</td>
    <td width="430"><cfinput type='file' value='' name="pdfFile" id="pdfFile" size="60"/></td>
	</tr>
  <tr>
    <td colspan="2" align="right"><input type="submit" value="Update" name="submit" /></td>
  </tr>
  </cfform>

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
