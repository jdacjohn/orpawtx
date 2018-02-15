<div id="mainBody">
  <!--- MAIN RIGHT --->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <h5 class="rubricHeading"><em><span>Types of Retention</span></em></h5>
      <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
      <p>There are at least 4 acknowledged types of student retention measurements.  These are institiutional retention, 
        system retention, retention within the major, and course retention.  The Office of Research, Planning and Analysis focuses
        its efforts in measuring insititutional retention and reports these figures to the National Center for Education Studies (NCES)
        via the IPEDS Reporting System, while the TSTC Systems Office likewise reports institutional retention to the Texas Higher
        Education Coordinating Board (THECB).  While ORPA's efforts are focused in the area of institutional retention, figures related
        to retention within the major and course retention are also available upon request.  System retention is generally not tracked
        by colleges and universities due to the difficulty in tracking enrollment data, which is the basis for measuring retention, 
        across different colleges. </p>
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
    <!--- CALC NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue principles">Retention</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="./ret_links.cfm">
        </ul>
      </div>
    </div>
    <!--- CALC NAV END --->
    <!--- COMMUNICATION NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue comm">IEIR Reports</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="./report_links.cfm">
        </ul>
      </div>
    </div>
    <!--- COMMUNICATION NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
