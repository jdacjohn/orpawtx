<div id="mainBody">
  <!--- MAIN RIGHT ---->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <h5 class="rubricHeading"><em><span>Retention Calculators</span></em></h5>
      <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
      <p>In order to view retention figures for Texas State Technical College West Texas, please
        select one of the links shown to the left. </p>
    </div>
    <div class="rightContent" >
      <h4 class="blue linkage">Links</h4>
      <p><cfinclude template="../body_links.cfm"></p>
    </div>
  </div>
  <!--- MAIN RIGHT END --->
  <div id="mainLeft">
    <!--- CALC NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue principles">Retention Calculator</h4>
      <div class="navVertContainer">
        <ul><cfinclude template="./retc_links.cfm"></ul>
      </div>
    </div>
    <!--- CALC NAV END --->
    <!--- IEIR Reports NAV --->
    <div class="leftNavContainer" >

<h4 class="blue comm">IEIR Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./report_links.cfm"></ul>
	</div>
</div>
    <!--- IEIR Reports NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
