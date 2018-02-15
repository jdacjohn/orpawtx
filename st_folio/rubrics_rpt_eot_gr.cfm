<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <p>
      <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
			<h5 class="rubricDef">Rubrics: <em><span>End-of-Term Online Reporting</span></em></h5>
			Historically, the Instructional Programs at Texas State Technical College West Texas have relied on 'pencil
      and paper' methods of capturing essential skills assessment information for our students.  This information
      has been arrayed in a massive collection of student assessment files which contain baseline data for all new 
      student cohorts going back to the Fall 2005 term, and also capstone data for students who have graduated.</p>
      <p>The reports offered here reflect our most current set of on-line data as provided by the data entry effort 
      that is underway.  This data set continues to grow daily.</p>
      <br />
      </p>
      <cfinvoke
      	component="script.rubrics_rpt" method="getRubricTermGrads" returnvariable="gradInfo">
      </cfinvoke>

      <p>
			<h5 class="rubricDef">Rubrics: <em><span>Graduates with Capstone Rubrics</span></em></h5>
      <table class="reports">
        <tr valign="baseline">
          <th width="140">Term</th>
          <th width="100">Graduates</th>
          <th width="160"><span style='vertical-align:super'>1</span>Capstone Rubrics</th>          
          <th width="100">Ratio</th>
        </tr>
    		<cfloop index="ndx" from="1" to="#ArrayLen(gradInfo)#" step="1">
						<tr>
							<td><cfoutput>#gradInfo[ndx].term#</cfoutput></td>
							<td><cfoutput>#gradInfo[ndx].students#</cfoutput></td>
							<td><cfoutput>#gradInfo[ndx].capstones#</cfoutput></td>
							<td><cfoutput>#gradInfo[ndx].ratio#</cfoutput></td>
						</tr>
				</cfloop>
        </table><br />
        <span style='vertical-align:super'>1</span> This figure represents the actual number of graduates in the term for whom the
        system has recorded results for a capstone rubric.<br />
      </p>

		</div> <!--- End Div Right Content --->

		<div class="rightContent" > <!--- Bottom of Page Links --->
			<h4 class="blue linkage">Links</h4>
			<p><cfinclude template="../body_links.cfm"></p>
		</div>

	</div> <!--- End Div mainRight --->

	<div id="mainLeft">

		<!--- Rubric EOT Links --->
		<div class="leftNavContainer" >

			<h4 class="blue principles">End-of-Term Reports</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="rubric_rpt_eot_links.cfm">
        </ul>
			</div>
		</div> <!--- End Rubric Def Links --->
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
