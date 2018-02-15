<div id="mainBody">
  <!--- MAIN RIGHT --->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Office of Research, Planning and Analysis</h4>
      <h5 class="rubricHeading"><em><span>Institutional Effectiveness Program Review Resources</span></em></h5>
      <p><cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
      	Please use the links shown to the left to access Program Review datasets available in this system.</p>
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
    <!---- PR NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue comm">Program Review Data</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="pr_view_links.cfm">
        </ul>
      </div>
    </div>
    <!--- PR NAV END --->
    <!---- IE NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue comm">IE Links</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="ieir_links.cfm">
        </ul>
      </div>
    </div>
    <!--- IE NAV END --->

  </div>
  <!--- MAIN BODY END --->
</div>
