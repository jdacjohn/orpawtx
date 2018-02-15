<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <p>
      <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
			<h5 class="rubricDef">TER: <em><span>End-Of-term Graduate Reports</span></em></h5>
      <p>The reports offered here reflect our most current collection of data for TER Scorese.  Texas State Technical College West Texas has bee
      administering the TER as a capstone measurement of Critical Thinking Skills to graduating students since the 2007 Summer
      Term.</p>
      <br />
     	</p>
      <cfinvoke
      	component="script.ter_rpt" method="getTerTermGrads" returnvariable="gradInfo">
      </cfinvoke>

      <p>
			<h5 class="rubricDef">TER: <em><span>Graduates with Capstone TER Results</span></em></h5>
      <table class="reports">
        <tr valign="baseline">
          <th width="140">Term</th>
          <th width="100">Graduates</th>
          <th width="160"><span style='vertical-align:super'>1</span>Capstone TERs</th>          
          <th width="100">Ratio</th>
        </tr>
    		<cfloop index="ndx" from="1" to="#ArrayLen(gradInfo)#" step="1">
						<tr>
							<td><a href="./index.cfm?action=TER_TERReports_EOT_GR_TERM&term=<cfoutput>#gradInfo[ndx].cohort#</cfoutput>"><cfoutput>#gradInfo[ndx].term#</cfoutput></a></td>
							<td><cfoutput>#gradInfo[ndx].students#</cfoutput></td>
							<td><cfoutput>#gradInfo[ndx].capstones#</cfoutput></td>
							<td><cfoutput>#gradInfo[ndx].ratio#</cfoutput></td>
						</tr>
				</cfloop>
        </table><br />
        <span style='vertical-align:super'>1</span> This figure represents the actual number of graduates in the term for whom the
        system has recorded results for a capstone TER Test.<br />
      </p>

		</div> <!--- End Div Right Content --->

		<div class="rightContent" > <!--- Bottom of Page Links --->
			<h4 class="blue linkage">Links</h4>
			<p><cfinclude template="../body_links.cfm"></p>
		</div>

	</div> <!--- End Div mainRight --->

	<div id="mainLeft">

		<!--- TER EOT Report Links --->
		<div class="leftNavContainer" >

			<h4 class="blue principles">End-of-Term Reports</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="ter_rpt_eot_links.cfm">
        </ul>
			</div>
		</div> <!--- End TER Report Links --->

		<!--- TER Report Links --->
		<div class="leftNavContainer" >

			<h4 class="blue principles">TER Reports</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="ter_rpt_links.cfm">
        </ul>
			</div>
		</div> <!--- End TER Report Links --->

		<!--- TER nav links --->
		<div class="leftNavContainer" >
			<h4 class="blue principles">TER On-Line</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="ter_links.cfm">
				</ul>
			</div>
		</div> <!--- End TER nav links --->

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
