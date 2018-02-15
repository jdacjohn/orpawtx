<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CLCollege#</cfoutput> Student Learning Outcomes</h4>
	<cfif isdefined("disc")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.cl_los' method='getDiscLOs' prog=#pid# returnvariable='outcomes'></cfinvoke>
		<!--- Learning Outcomes Section --->
		<h5 class="blueback">Course Learning Outcomes Classified with #disc# &nbsp;&nbsp;<b>(#outcomes.recordcount#)</b></h5>
		<p>The table below lists all available outcomes for the selected academic discipline.  Click on the desired outcome to view
    its details.  You can also move your mouse over the outcome in the table to see a description of that outcome.
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
						<td width="25"><a href="./index.cfm?action=CL_LOS_Browse_Outcome&loid=#outcomes.loid#&disc=#disc#" title="View Outcome"><img #Application.Settings.ViewImg# /></a></td>
        		<td width="25" align="right">#outcomeCount#.</td>
    				<td width="300">&nbsp;<span style="text-decoration:underline"><a title="#outcomes.loDesc#">#outcomes.loName#</a></span></td>
          	<td width="100" align="center">#outcomes.loRevMonth#</td>
          	<td width="75" align="center">#outcomes.loRevYear#</td>
    			</tr>
  			</cfloop>
  		</table>
		</cfoutput>
    </p>

    <p>Please contact <a href="mailto:john.arnold@sweetwater.tstc.edu">John Arnold</a> in the Office of Research,
    Planning & Analysis at <span style="text-decoration:underline">325.235.7408</span> with any questions or suggestions.
    </p>

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

</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">

<!--- Disciplines NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Programs</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="disciplines_links.cfm">
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
