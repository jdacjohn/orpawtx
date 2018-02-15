<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcomes Administration</h4>
	<cfif isdefined("disc")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.cl_los' method='getDiscLOs' prog=#pid# returnvariable='outcomes'></cfinvoke>
		<!--- Learning Outcomes Section --->
		<h5 class="blueback">Course Learning Outcomes for #disc# <b>(#outcomes.recordcount#)</b>&nbsp;&nbsp;&nbsp;<a href="./index.cfm?action=CL_LOS_Admin_Add" title="Add a new Outcome to the Discipline">Add New?</a>&nbsp;&nbsp;&nbsp;</h5>
		<p>The table below lists all available outcomes for the selected academic major.  Click on the desired outcome to view
    existing course linkages for that outcome or to add a new course linkage.  If you do not see the outcome you're looking for,
    you can add a new outcome by clicking on the 'Add New' link shown in the blue header bar above.
			<table class="cloSummaryTable" cellspacing="0" cellpadding="0">
        <tr>
          <th width="25">&nbsp;</th>
          <th width="350">Outcome</th>
          <th width="100">Rev. Month</th>
          <th width="75">Rev. Year</th>
        </tr>
				<cfset outcomeCount = 0>
				<cfloop query="outcomes">
				<cfset outcomeCount += 1>
  				<tr>
        		<td width="25" align="right">#outcomeCount#.</td>
    				<td width="350">&nbsp;<a href="./index.cfm?action=CL_LOS_Manage_Links&disc=#disc#&loid=#outcomes.loid#" title="Manage Course Linkages">#outcomes.loName#</a></td>
          	<td width="100" align="center">#outcomes.loRevMonth#</td>
          	<td width="75" align="center">#outcomes.loRevYear#</td>
    			</tr>
  			</cfloop>
  		</table>
		</cfoutput>
    </p>
		</div>
	<cfelse>
		<div class="rightContent">  
			<p>Select a Major from the list on the left to begin.</p>
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

<h4 class="blue principles">Majors</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="disciplines_links.cfm">
		</ul>
	</div>
</div>
<!--- Disciplines NAV END --->

<!--- Course Admin NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Manage Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_cl_admin_links.cfm">
		</ul>
	</div>
</div>
<!--- Course Admin NAV END --->

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

</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
