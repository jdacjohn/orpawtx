<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
    	
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
			<h5 class="rubricHeading"><em><span>Rubrics On-Line Reference</span></em></h5>
      <cfinvoke component="script.programs" method="getProgCampus" returnvariable="program" p_id=#pid#></cfinvoke>
      <cfinvoke component="script.programs" method="getProgName" returnvariable="progName" p_id=#pid#></cfinvoke>
			<h5 class="rubricDef">Rubrics: <em><span><cfoutput>#program.campus# #progName.program#</cfoutput> Program</span></em></h5>
			The college faculty and program advisory committees have selected the essential skills shown in the table below for the
      <cfoutput>#program.campus# #progName.program#</cfoutput> Program.<br />&nbsp;
      </p>
        <table class="rubricTable">
          <tr>
            <th width="150"><b>Rubric</b></td>
            <th width="421"><b>Definition</b></td>
          </tr>
          <cfinvoke
          	component="script.rubrics" method="getProgramRubrics" returnvariable="rubrics" p_id=#pid#>
          </cfinvoke>
          <cfoutput>
          <cfloop query="rubrics">
          <tr valign="top">
            <td class="rubricCompetencyCol"><a href="./index.cfm?action=RUB_Defs&rubric=#rubrics.r_id#" title="View Rubric">#rubrics.skill#</a></td>
            <td class="rubricDefinitionCol">#rubrics.definition#</td>
          </tr>
        <!--  <tr><td colspan="2">&nbsp;</td></tr> -->
					</cfloop>
          </cfoutput>
        </table>
		</div> <!--- End Div Right Content --->

		<div class="rightContent" > <!--- Bottom of Page Links --->
			<h4 class="blue linkage">Links</h4>
			<cfinclude template="../body_links.cfm">
		</div>

	</div> <!--- End Div mainRight --->

	<div id="mainLeft">

		<!--- Rubric Def Links --->
	<div class="leftNavContainer" >

			<h4 class="blue principles">Program Rubrics</h4>
			<div class="navVertContainer">
				<ul>
        	<li><a href="javascript;">Program Link</a>
          <li><a href="javascript;">Program Link 2</a>
          <li><a href="javascript;">Program Link x</a>
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
