<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
			<h5 class="rubricHeading"><em><span>Rubrics On-Line Reference</span></em></h5>
			<!--- Default this param to the first rubric for cases where the page is called without an argument. --->
			<cfparam name='rubric' default='10000'>
			<cfinvoke
				component="script.rubrics" method="getRubric" returnvariable="rubric_info" rid=#rubric#>
			</cfinvoke>
			<h5 class="rubricDef">Rubric Definition: <em><span><cfoutput>#rubric_info.display_name#</cfoutput></span></em></h5>
			<cfoutput>#rubric_info.definition#</cfoutput>

			<h5 class="compHeading"><span><em><cfoutput>#rubric_info.skill#</cfoutput></em> Competency Classes</span></h5>
			<table class="rubricTable">
				<tr>
					<th><b>Competency Class</b></th>
					<th><b>Definition</b></th>
				</tr>
				<cfinvoke
					component="script.rubrics" method="getCompClasses" returnvariable="comp_classes" rid=#rubric#>
				</cfinvoke>
				<cfif comp_classes.RecordCount>
					<cfloop query='comp_classes'>
						<tr>
							<td class="rubricCompetencyCol"><cfoutput><a href="./index.cfm?action=RUB_Defs_CC&amp;rubric=#rubric#&amp;ccid=#comp_classes.c_id#" title="View Competencies">#comp_classes.name#</a></cfoutput></td>
							<td class="rubricDefinitionCol"><cfoutput>#comp_classes.description#</cfoutput></td>
						</tr>
					</cfloop>
				</cfif>
			</table><br />
		</div> <!--- End Div Right Content --->

		<div class="rightContent" > <!--- Bottom of Page Links --->
			<h4 class="blue linkage">Links</h4>
			<p><cfinclude template="../body_links.cfm"></p>
		</div>

	</div> <!--- End Div mainRight --->

	<div id="mainLeft">

		<!--- Rubric Def Links --->
		<div class="leftNavContainer" >

			<h4 class="blue principles">Rubrics Definitions</h4>
			<div class="navVertContainer">
				<ul><cfinclude template="./include/all_rubrics.cfm"></ul>
			</div>
		</div> <!--- End Rubric Def Links --->

		<!--- Rubrics nav links --->
		<div class="leftNavContainer" >
			<h4 class="blue principles">Rubrics</h4>
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
