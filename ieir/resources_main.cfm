<div id="mainBody">
  <!--- MAIN RIGHT --->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Office of Research, Planning and Analysis</h4>
      <h5 class="rubricHeading"><em><span>Institutional Effectiveness</span></em></h5>
      <p><cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
      The list below provides links to various college planning documents.  These documents are provided in Adobe Portable
      Document format for you convenience.<br />
      <ul>
      	<li><a href="./ieir/iefiles/Strategic_Plan_2009.pdf" target="_blank">TSTC West Texas Strategic Plan</a></li>
        <li><a href="./ieir/iefiles/Instr_Effectiveness_Plan.pdf" target="_blank">TSTC West Texas Instructional Effectiveness Plan</a></li>
        <li><a href="./ieir/iefiles/Perkins_IE_Plan.pdf" target="_blank">TSTC West Texas Perkins Institutional Effectiveness Plan</a></li>
      </ul>
      </p>
    </div>
    <div class="rightContent" >
      <h4 class="blue linkage">Links</h4>
      <p>
        <cfinclude template="../body_links.cfm">
      </p>
    </div>
  </div>
  <!--- MAIN RIGHT END --->
  <div id="mainLeft">
    <!---- TER NAV --->
    <!---- <div class="leftNavContainer" >

<h4 class="blue principles">The T.E.R.</h4>
	<div class="navVertContainer">
		<ul>
    	<cfinclude template="ter_links.cfm">
		</ul>
	</div>
</div> --->
    <!--- TER NAV END --->
    <!---- Surveys NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue comm">IE Links</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="ieir_links.cfm">
        </ul>
      </div>
    </div>
    <!--- Surveys NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
