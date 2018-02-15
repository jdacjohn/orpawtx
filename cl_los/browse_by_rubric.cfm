<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CLCollege#</cfoutput> Student Learning Outcomes</h4>
	<cfif isdefined("rubric")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.cl_los' method='getClasses' rubric='#rubric#' returnvariable='classes'></cfinvoke>
		<!--- Learning Outcomes Section --->
		<h5 class="blueback">Course Learning Outcomes Associated with classes matching the #rubric# Rubric &nbsp;&nbsp;<b>(#classes.recordcount#)</b></h5>
		<p>In order to view the rubrics for a class, select a class from the drop-down list and click on search.
    	<cfif isdefined("availableClasses") && availableClasses neq ''>
      	<cfset theClass = availableClasses>
      <cfelse>
      	<cfset theClass = ''>
      </cfif>
			<table class="cloSummaryTable" cellspacing="0" cellpadding="0">
				<cfform name="lo_entry_f" id="lo_entry_f" enctype="multipart/form-data" action="./index.cfm?Action=CL_LOS_Browse_Rubric&rubric=#rubric#" method="post" format="html">
        <tr>
          <td width="100">
            <select name='availableClasses' onchange="javascript:selClass.value = this.value;">
              <option value="">Available Classes</option>
              <cfloop query='classes'>
                <option value='#classes.secRubric#' <cfif (theClass neq '') && (theClass eq classes.secRubric)> selected </cfif> >#classes.secRubric#</option>
              </cfloop>
            </select>
          </td>
          <td width="250" align="left"><input type='text' name='selClass' id='selClass' <cfif (theClass neq '')> value="#theClass#" <cfelse> value="" </cfif> size="10" maxlength="5" /></td>
        </tr>
        <tr>
          <td colspan="2" align="right"><input type="submit" value="Search" name="submit" /></td>
        </tr>
        </cfform>
  		</table>
    </p>
    	<cfif isdefined("selClass") && selClass neq ''>
				<h5 class="blueback">Learning Outcomes for #selClass#</h5>
      	<p>
      	<cfinvoke component='script.cl_los' method='getOutcomesForClass' class='#selClass#' returnVariable='outcomes'></cfinvoke>
        <table class="cloSummaryTable" cellspacing="0" cellpadding="0">
          <tr>
            <th width="50" colspan="2">&nbsp;</th>
            <th width="25">&nbsp;</th>
            <th width="300">Outcome</th>
            <th width="100">Rev. Month</th>
            <th width="75">Rev. Year</th>
          </tr>
          <cfset outcomeCount = 0>
          <cfloop query="outcomes">
          <cfset outcomeCount += 1>
            <tr>
              <td width="25"><cfif outcomes.lo_pdf neq ''><a href="./cl_los/files/#outcomes.lo_pdf#" target="_blank" title="Get PDF File"><img #Application.Settings.PDFImg# /></a></cfif></td>
              <td width="25"><a href="./index.cfm?action=CL_LOS_Browse_Outcome&loid=#outcomes.loid#&disc=#rubric#" title="View Outcome"><img #Application.Settings.ViewImg# /></a></td>
              <td width="25" align="right">#outcomeCount#.</td>
              <td width="300">&nbsp;<span style="text-decoration:underline"><a title="#outcomes.loDesc#">#outcomes.loName#</a></span></td>
              <td width="100" align="center">#outcomes.loRevMonth#</td>
              <td width="75" align="center">#outcomes.loRevYear#</td>
            </tr>
          </cfloop>
        </table>
        </p>
      </cfif>
		</cfoutput>
    <p>Please contact <a href="mailto:john.arnold@sweetwater.tstc.edu">John Arnold</a> in the Office of Research,
    Planning & Analysis at <span style="text-decoration:underline">325.235.7408</span> with any questions or suggestions.
    </p>

		</div>
	<cfelse>
		<div class="rightContent">  
			<p>Select a rubric from the list on the left to begin.</p>
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

<!--- Disciplines NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Rubrics</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="rubrics_links.cfm">
		</ul>
	</div>
</div>
<!--- Disciplines NAV END --->

<!--- Course Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Course Outcomes</h4>
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
      <cfinclude template="../los/los_links.cfm">
		</ul>
	</div>
</div>
<!--- Outcomes NAV END --->

</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
