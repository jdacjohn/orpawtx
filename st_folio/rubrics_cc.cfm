<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <cfinvoke
      	component="script.rubrics" method="getRubricName" returnvariable="rubricName" r_id=#rubric#>
      </cfinvoke>
			<h5 class="rubricHeading">Rubric Competency Ratings: <em><span><cfoutput>#rubricName.skill#</cfoutput></span></em></h5>
			<!--- Default this param to the first rubric for cases where the page is called without an argument. --->
			<cfparam name='rubric' default='10000'>
			<cfinvoke
				component="script.rubrics" method="getCompClass" returnvariable="compClass" cc_id=#ccid#>
			</cfinvoke>
			<h5 class="compClassHeading">Competency: <em><span><cfoutput>#compClass.name#</cfoutput></span></em></h5>
			<cfoutput>#compClass.description#</cfoutput>

			<!--- <h5 class="compHeading"><span><em><cfoutput>#compClass.name#</cfoutput> Competency Classes</em></span></h5> --->

			<table class="compRatingTable">
        <tr>
          <th class="compRatingTableh1" colspan="5" width="113"><b>Progression</b></th>
        </tr>
        <tr>
          <th width="76"><b><span style="text-decoration:underline">Area</span></b></th>
          <th width="118"><b><span style="text-decoration:underline">Beginning</span></b></th>
          <th width="118"><b><span style="text-decoration:underline">Developing</span></b></th>
          <th width="118"><b><span style="text-decoration:underline">Competent</span></b></th>
          <th width="120"><b><span style="text-decoration:underline">Accomplished</span></b></th>
        </tr>
        <cfinvoke
        	component="script.rubrics" method="getCompetencies" returnvariable="competencies" cc_id=#ccid#>
        </cfinvoke>
        <cfloop query="competencies">
        <cfinvoke
        	component="script.rubrics" method="getCompetencyRatings" returnvariable="ratings" cmp_id=#competencies.cmp_id#>
        </cfinvoke>
        	<cfoutput>
					<tr valign="top">
          	<td><cfif competencies.name neq ''><span style="text-decoration:underline">#competencies.name#</span><cfelse>All Areas</cfif></td>
            <cfloop query="ratings">
            	<td>#ratings.description#</td>
            </cfloop>
  				</cfoutput>
  			</cfloop>
			</table>

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
