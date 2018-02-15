<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <p>
      <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
			<h5 class="rubricDef">Accuplacer: <em><span>End-of-Term Online Reporting</span></em></h5>
			<p>All Accuplacer Scores are downloaded from Accuplacer Online and stored in IEIR's database.  This allows us to
      analyze the test scores at a high level as well as provide information at the division and program levels.</p>
      <p>The reports offered here reflect our most current collection of data for Accuplacer Scores, as well as for Rubrics and Accuplacer
      test scores, which can be found in the related sections of this website.</p>
      <p>Please use the links in the upper left corner to access these reports.</p>
      <br />
      </p>
		</div> <!--- End Div Right Content --->

		<div class="rightContent" > <!--- Bottom of Page Links --->
			<h4 class="blue linkage">Links</h4>
			<p><cfinclude template="../body_links.cfm"></p>
		</div>

	</div> <!--- End Div mainRight --->

	<div id="mainLeft">

		<!--- ACP Report Links --->
		<div class="leftNavContainer" >

			<h4 class="blue principles">End-of-Term Reports</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="acp_rpt_eot_links.cfm">
        </ul>
			</div>
		</div> <!--- End ACP Report Links --->

		<!--- ACP Report Links --->
		<div class="leftNavContainer" >

			<h4 class="blue principles">Accuplacer Reports</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="acp_rpt_links.cfm">
        </ul>
			</div>
		</div> <!--- End ACP Report Links --->

		<!--- TER nav links --->
		<div class="leftNavContainer" >
			<h4 class="blue principles">Accuplacer On-Line</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="acp_links.cfm">
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
