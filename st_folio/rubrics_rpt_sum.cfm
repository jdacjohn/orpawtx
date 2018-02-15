<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
			<h5 class="rubricHeading"><em><span>Rubrics On-Line Reports</span></em></h5>
      <p>
      <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
			<h5 class="rubricDef">Rubrics: <em><span>Summary Report</span></em></h5>
			<br />
      <cfinvoke
      	component="script.rubrics_rpt" method="getRubricCount" returnvariable="rubricCount">
      </cfinvoke>
      <cfinvoke
      	component="script.rubrics_rpt" method="getBaselineCount" returnvariable="baselineCount">
      </cfinvoke>
      <cfinvoke
      	component="script.rubrics_rpt" method="getCapstoneCount" returnvariable="capstoneCount">
      </cfinvoke>
      <cfinvoke
      	component="script.rubrics_rpt" method="getMeasureableCount" returnvariable="measureableCount">
      </cfinvoke>
      <cfinvoke
      	component="script.rubrics_rpt" method="getMeasureableCohorts" returnvariable="cohortInfo">
      </cfinvoke>
      <cfinvoke
      	component="script.rubrics_rpt" method="getBaselineCohorts" returnvariable="baselineInfo">
      </cfinvoke>
      <cfinvoke
      	component="script.rubrics_rpt" method="getCapstoneCohorts" returnvariable="capstoneInfo">
      </cfinvoke>

      <table class="rubricRpts">
        <tr>
          <td width='175'>Rubrics In System:</td>
          <td align="left"><cfoutput>#rubricCount.count#</cfoutput></td>
        </tr>
        <tr>
          <td>Baselines In System:</td>
          <td><cfoutput>#baselineCount.count#</cfoutput></td>
        </tr>
        <tr>
          <td>Capstones In System:</td>
          <td><cfoutput>#capstoneCount.count#</cfoutput></td>
        </tr>
        <tr valign="baseline">
          <td><span style="vertical-align:super">1</span>Measureable Sets:</td>
          <td><cfoutput>#measureableCount.count#</cfoutput></td>
        </tr>
			</table><br />
      <span style="vertical-align:super">1</span>Measureable Sets indicates the number of students currently in the systems
      that have both baseline and capstone rubrics recorded.<br />&nbsp;<br />

			<h5 class="rubricDef">Rubrics: <em><span>QEP Reportable</span></em></h5>
	    <table class="reports">
        <tr valign="baseline">
          <th width="140">Cohort Start Term</th>
          <th width="100">Cohort Size</th>
          <th width="100">Graduates</th>
          <th width="160" align="left"><span style="vertical-align:super">2</span>QEP Reportable</th>
        </tr>
    		<cfloop index="ndx" from="1" to="#ArrayLen(cohortInfo)#" step="1">
						<tr>
							<td><cfoutput>#cohortInfo[ndx].cohort#</cfoutput></td>
							<td><cfoutput>#cohortInfo[ndx].cohortSize#</cfoutput></td>
							<td><cfoutput>#cohortInfo[ndx].grads#</cfoutput></td>
							<td><cfoutput>#cohortInfo[ndx].students#</cfoutput></td>
						</tr>
				</cfloop>
				</table><br />
      <span style="vertical-align:super">2</span>QEP Reportable indicates the number of students in the cohort
      for whom the system is currently showing both a baseline and a capstone Rubric.
      </p>
      <p>
			<h5 class="rubricDef">Rubrics: <em><span>Baselines by Cohort</span></em></h5>
      <table class="reports">
        <tr>
          <th width="140">Cohort Start Term</th>
          <th width="100">Cohort Size</th>
          <th width="100">Baselines</th>
          <th width="160">Ratio</th>
        </tr>
    		<cfloop index="ndx" from="1" to="#ArrayLen(baselineInfo)#" step="1">
						<tr>
							<td><cfif baselineInfo[ndx].cohort equal 'Totals'><cfoutput><i></cfoutput></cfif><cfoutput>#baselineInfo[ndx].cohort#</cfoutput><cfif baselineInfo[ndx].cohort equal 'Totals'><cfoutput></i></cfoutput></cfif></td>
							<td><cfoutput>#baselineInfo[ndx].cohortSize#</cfoutput></td>
							<td><cfoutput>#baselineInfo[ndx].baselines#</cfoutput></td>
							<td><cfoutput>#baselineInfo[ndx].ratio#</cfoutput></td>
						</tr>
				</cfloop>
        </table><br />
      </p>

      <p>
			<h5 class="rubricDef">Rubrics: <em><span>Capstones by Cohort</span></em></h5>
      <table class="reports">
        <tr>
          <th width="140">Cohort Start Term</th>
          <th width="100">Cohort Size</th>
          <th width="100">Capstones</th>
          <th width="160">Ratio</th>
        </tr>
    		<cfloop index="ndx" from="1" to="#ArrayLen(capstoneInfo)#" step="1">
						<tr>
							<td><cfif capstoneInfo[ndx].cohort equal 'Totals'><cfoutput><i></cfoutput></cfif><cfoutput>#capstoneInfo[ndx].cohort#</cfoutput><cfif capstoneInfo[ndx].cohort equal 'Totals'><cfoutput></i></cfoutput></cfif></td>
							<td><cfoutput>#capstoneInfo[ndx].cohortSize#</cfoutput></td>
							<td><cfoutput>#capstoneInfo[ndx].capstones#</cfoutput></td>
							<td><cfoutput>#capstoneInfo[ndx].ratio#</cfoutput></td>
						</tr>
				</cfloop>
        </table><br />
      </p>

		</div> <!--- End Div Right Content --->

		<div class="rightContent" > <!--- Bottom of Page Links --->
			<h4 class="blue linkage">Links</h4>
			<p><cfinclude template="../body_links.cfm"></p>
		</div>

	</div> <!--- End Div mainRight --->

	<div id="mainLeft">

		<!--- Rubric Def Links --->
		<div class="leftNavContainer" >

			<h4 class="blue principles">Rubrics Reports</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="rubric_rpt_links.cfm">
        </ul>
			</div>
		</div> <!--- End Rubric Def Links --->

		<!--- Rubrics nav links --->
		<div class="leftNavContainer" >
			<h4 class="blue principles">Rubrics On-Line</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="rubrics_links.cfm">
				</ul>
			</div>
		</div> <!--- End Rubric nav links --->

		<!--- Related Links --->
		<div class="leftNavContainer" >
			<h4 class="blue comm">Related Links</h4>
			<div class="navVertContainer">
				<ul>
    			<cfinclude template="qep_links.cfm">
				</ul>
			</div>
		</div> <!--- End related links --->

	</div> <!--- End Div Main Left --->

<!-- MAIN BODY END -->
</div> <!--- End Div mainbody --->
