<div id="mainBody">
  <!--- MAIN RIGHT --->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Office of Research, Planning and Analysis</h4>
      <h5 class="rubricHeading"><em><span>Institutional Effectiveness Admin Home</span></em></h5>
      <p><cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
      	Please use the links to the left to access I.E. Administration Functions.</p>
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
      <h4 class="blue comm">IE Admin</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="ieir_links_admin.cfm">
        </ul>
      </div>
    </div>
    <!--- Surveys NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
