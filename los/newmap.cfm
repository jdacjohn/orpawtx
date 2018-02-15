<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcomes</h4>
	<cfif isdefined("prog")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.programs' method='getProgFullNameById' progId=#prog# returnvariable="progQuery"></cfinvoke>
		<cfinvoke component='script.los' method='getOutcomeById' outcomeId=#loid# returnvariable="outcome"></cfinvoke>
		<cfinvoke component='script.los' method='getMapSections' cmid=#cmid# returnvariable='sections'></cfinvoke>
    <h5 class="blueback">Program Learning Outcomes Alignment Matrix: #progQuery.progName#</h5>
		<h5 class="blueback">Assessment Mapping for Learning Outcome: #outcome.loName#</h5>
		<table class="loCreateTable" cellspacing="0" cellpadding="0">
		<cfform name="cmForm" id="cmForm" action="./index.cfm?Action=LOS_SubmitLOMapping_DB" method="post" format="html">
			<input type="hidden" name="cmid" value="#cmid#" />
      <input type="hidden" name="prog" value="#prog#" />
			<input type="hidden" name="loid" value="#loid#" />
      <tr>
        <td>Available Courses</td>
        <td>Course</td>
        <td>Capstone</td>
        <td>Assessment Type</td>
      </tr>
      <tr>
        <td>
        	<select class="loEntryInputNB" name='availableSections' onchange="javascript:secRubric.value = this.value;">
          	<cfloop query='sections'>
            	<option value='#sections.rubric#'>#sections.rubric#</option>
            </cfloop>
          </select>
        </td>
        <td><input class="loEntryInput" type='text' value='' name='secRubric' id='secRubric' size="12"/></td>
        <td><input type='radio' name='capstone' value='1' /> Yes <input type='radio' name='capstone' value='0' /> No </td>
        <td><input type='radio' name='level' value='I' /> I <input type='radio' name='level' value='D' /> D <input type='radio' name='level' value='M' /> M </td>
      </tr>
      <tr>
        <td colspan="4" align="right"><input type="submit" value="Save" name="submit" /></td>
      </tr>
		</cfform>
		</table>
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

<!--- PGM Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Program Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_pgm_links.cfm">
		</ul>
	</div>
</div>
<!--- PGM Outcomes NAV END --->

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
