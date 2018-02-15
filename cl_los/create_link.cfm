<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >

<h4 class="blue instructional"><cfoutput>#Application.Settings.CLCollege#</cfoutput> Student Learning Outcomes Management</h4>
<cfoutput>
<cfinvoke component='script.cl_los' method='getOutcomeById' outcomeId=#outcomeid# returnVariable="theOutcome"></cfinvoke>
<h5 class="blueback">
	Course/Outcome Link Management:&nbsp;&nbsp;<a href="./index.cfm?action=CL_LOS_Manage_Links&disc=#disc#&loid=#outcomeId#" title="Return to #disc#/#theOutcome.loShortName# Link Management">#disc#</a>
  - <a title="#theOutcome.loDesc#">#theOutcome.loShortName#</a>
</h5>
<p>
<!--- Required Information Section --->
<table class="cloCreateTable" width="100%" cellspacing="0" cellpadding="0">
<cfif isdefined("outcomeId") && outcomeId neq 0>
	<h5 class="blueback">&nbsp;Course-to-Outcome Linking for the '#theOutcome.loName#' Learning Outcome</h5>
	<p>
  <cfform name="link_entry_f" id="lo_entry_f" action="./index.cfm?Action=CL_LOS_Submit_Link" method="post" format="html">
    <tr>
      <td width="150">Course Rubric and No.</td>
      <td width="400">
        <input type='text' value='' name='rubric' id='rubric' size="15" maxlength="10" onchange="javascript:link_entry_f.linkit.disabled = false;" />
        (Example: #disc#-2301)
      </td>
    </tr>
    <tr>
      <td width="150" valign="top">Learning Activity</td>
      <td width="400"><textarea class="loEntryInput" name="activity" id="activity" value="" rows="4" cols="75">Indicate the class learning activity that will be used as the basis for assessing this outcome.</textarea></td>
    </tr>
    <tr>
      <td width="150" valign="top">Intended Outcome</td>
      <td width="400"><textarea class="loEntryInput" name="intent" id="intent" value="" rows="4" cols="75">What is the expected outcome? What is the expected level of competency and what percentage of students who satisfactorily complete the class are expected to achieve this level of competency?
      </textarea></td>
    </tr>
    <tr>
      <td colspan="2" align="right">
      	<input type="hidden" name="outcome" value="#outcomeId#" />
        <input type="hidden" name="disc" value="#disc#" />
      	<input type="submit" value="Link Course" name="linkit" id="linkit" disabled />
      </td>
    </tr>
  </cfform>
</cfif>
</table>
</p>
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
