<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CLCollege#</cfoutput> Student Learning Outcomes</h4>
	<cfif isdefined("disc")>
		<div class="rightContent" >
		<cfoutput>
		<!--- Get all majors --->
    <cfinvoke component='script.cl_los' method='getDisciplines' returnvariable='disciplines'></cfinvoke>
		<cfinvoke component='script.cl_los' method='getDiscLOs' prog=#pid# returnvariable='outcomes'></cfinvoke>
		<!--- Learning Outcomes Section --->
		<h5 class="blueback">Course Learning Outcomes Classified with #disc# &nbsp;&nbsp;<b>(#outcomes.recordcount#)</b></h5>
		<p>The table below lists all available outcomes for the selected academic major.  Click on the desired outcome to view
    its details.  You can also move your mouse over the outcome in the table to see a description of that outcome.
		<table class="cloSummaryTable" cellspacing="0" cellpadding="0">
		<cfform name="copy_f" id="copy_f" enctype="multipart/form-data" action="./index.cfm?Action=CL_LOS_Copy_DB" 
			method="post" format="html" preservedata="yes">
      <tr><th colspan="3">Select a Major to Copy the Outcome(s) To:</th></tr>  
      <tr>
        <td width="350">*Major</td>
        <td width="100">
          <select name='availableMajors' onchange="javascript:theMajor.value = this.value;">
            <option value="">Copy To</option>
            <cfloop query='disciplines'>
            	<cfif disciplines.prog neq disc>
	              <option value='#disciplines.prog#'>#disciplines.prog#</option>
              </cfif>
            </cfloop>
          </select>
        </td>
        <td width="100"><cfinput type='text' value='' name='theMajor' id='theMajor' size="10" maxlength="10" required="yes" message="You must either select a major from the list or enter a major." /></td>
      </tr>
      <tr><th colspan="3">Available Outcomes</th></tr>  
      <tr>
        <th width="350">Outcome</th>
        <th width="100">Rev. Month</th>
        <th width="100">Rev. Year</th>
      </tr>
      <cfset outcomeCount = 0>
      <cfloop query="outcomes">
      <cfset outcomeCount += 1>
        <tr>
          <td width="350">
          	<cfinput type="checkbox" name="oldOutcome" value="#outcomes.loid#" onClick="javascript:submit.disabled=false;" />
            #outcomeCount# &nbsp; <span style="text-decoration:underline"><a title="#outcomes.loDesc#">#outcomes.loName#</a></span>
          </td>
          <td width="100" align="center">#outcomes.loRevMonth#</td>
          <td width="100" align="center">#outcomes.loRevYear#</td>
        </tr>
      </cfloop>
      <tr><td colspan="3"><input type="submit" name="submit" value="Copy" disabled /></td></tr>
			</cfform>
  		</table>
		</cfoutput>
    </p>

    <p>Please contact <a href="mailto:john.arnold@sweetwater.tstc.edu">John Arnold</a> in the Office of Research,
    Planning & Analysis at <span style="text-decoration:underline">325.235.7408</span> with any questions or suggestions.
    </p>

		</div>
	<cfelse>
		<div class="rightContent">  
			<p>Select a Major from the list on the left to begin.</p>
    </div>
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
