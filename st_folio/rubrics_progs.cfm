<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
			<h5 class="rubricHeading"><em><span>Rubrics On-Line Reference</span></em></h5>
      <p>
      <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
			<h5 class="rubricDef">Rubrics: <em><span>By Instructional Program and Location</span></em></h5>
			The table below contains links for each program at the four TSTC West Texas College Locations. Click
      on the program links to view which rubrics students of these programs are being assessed against.</p>
      <p>&nbsp;<br />&nbsp;</p>
      <table>
        <tr>
          <td width="90" align="left"><b>Abilene</b></td>
          <cfinvoke 
          	component="script.programs" method="getLocProgs" returnvariable="programs" l_id="460">
          </cfinvoke>
          <td width="461" align="left"><cfloop query="programs"><a href="./index.cfm?action=RUB_Program&pid=<cfoutput>#programs.p_id#</cfoutput>"><cfoutput>#programs.program#</cfoutput></a>&nbsp;&nbsp;</cfloop></td>
        </tr>
        <tr>
          <td width="90" align="left"><b>Breckenridge</b></td>
          <cfinvoke 
          	component="script.programs" method="getLocProgs" returnvariable="programs" l_id="480">
          </cfinvoke>
          <td width="461" align="left"><cfloop query="programs"><a href="./index.cfm?action=RUB_Program&pid=<cfoutput>#programs.p_id#</cfoutput>"><cfoutput>#programs.program#</cfoutput></a>&nbsp;&nbsp;</cfloop></td>
        </tr>
        <tr>
          <td width="90" align="left"><b>Brownwood</b></td>
          <cfinvoke 
          	component="script.programs" method="getLocProgs" returnvariable="programs" l_id="470">
          </cfinvoke>
          <td width="461" align="left"><cfloop query="programs"><a href="./index.cfm?action=RUB_Program&pid=<cfoutput>#programs.p_id#</cfoutput>"><cfoutput>#programs.program#</cfoutput></a>&nbsp;&nbsp;</cfloop></td>
        </tr>
        <tr>
          <td width="90" align="left"><b>Sweetwater</b></td>
          <cfinvoke 
          	component="script.programs" method="getLocProgs" returnvariable="programs" l_id="400">
          </cfinvoke>
          <td width="461" align="left"><cfloop query="programs"><a href="./index.cfm?action=RUB_Program&pid=<cfoutput>#programs.p_id#</cfoutput>"><cfoutput>#programs.program#</cfoutput></a>&nbsp;&nbsp;</cfloop></td>
        </tr>
      </table>
      <br />
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
