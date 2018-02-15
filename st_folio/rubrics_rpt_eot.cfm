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
      <p>The department of Instituional Effectiveness & Information Research at TSTC West Texas has derived a leading-edge
      relational database system to capture all of this information and is in the process of entering all of this data to
      facilitate automated reporting capabilities and 'at a glance' snapshots of our current state in this area.  Additionally,
      this website, which is currently in beta, also boasts an online Rubrics Entry Application that is due to be rolled out
      to faculty in Fall 2008, thereby alleviating the need for further manual data entry.</p>
      <p>The reports offered here reflect our most current collection of data for Rubrics, as well as for TER and Accuplacer
      test scores.</p>
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
