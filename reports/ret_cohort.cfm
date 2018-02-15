<div id="mainBody">
  <!--- MAIN RIGHT ---->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <h5 class="rubricHeading"><em><span>Cohort Retention Calculations</span></em></h5>
      <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
      <p>Cohort Retention measures student attrition rates across semesters beginning with the starting semester of the cohort.  The Fall to Fall retention measurement calculations utilize the
      IPEDS retention definitions provided by the National Center for Education Statistics; i.e., the number of full-time
      first-time degree-seeking students in a given fall cohort who are still in attendance the following fall term, or have
      graduated prior to the next fall term.</p>
      <p>The semester to semester retention calculations rely on the same tracking methodology but use the shorter semester-based cycle and are based on
      semester cohorts of students rather than the full year cohorts utlized by the IPEDS retention schedule.</p>
      <p>Please select a Retention Span using the radio buttons shown to the left and then click the continue button to proceed.</p>
      <cfparam name="cohortSelectError" default="">
      <cfoutput>
      	<cfif cohortSelectError NEQ "">
        	<p><span style="color:##ff0000";><em>#cohortSelectError#</em></span></p>
        </cfif>
      </cfoutput>
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
    <cfparam name="retspan" default="">
    <div class="leftNavContainer" >
    <h4 class="blue comm">Retention Span</h4>
<!---      <div class="navVertContainer">
        <ul><cfinclude template="./report_links.cfm"></ul>
      </div> --->
      <table class="retTable" width="140" cellspacing="0" cellpadding="0" border="0">
      <form name="cform" method="post" action="index.cfm?action=RTC_Inst_Display"  enctype="multipart/form-data">
        <!--- <input type="hidden" name="Action" value="RTC_Inst_Display" /> --->
        <tr id="sm2smList">
          <td width="100%">
            <table class="retTable" style="border: 1px solid #142855;">
              <tr><th>Available Cohorts</th></tr>
              <tr>
                <td>
                  <select id="semselects" name="semselects" class="retTable" size="6" multiple>
                  	<cfinclude template="./include/all_terms.cfm">
                  </select>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>&nbsp;<input type="button" class="heading3" value="Calculate" onClick="javascript:cform.submit();" /></td>
        </tr>
        <tr><td><input type="checkbox" name="byloc" /> Show by Campus</td></tr>
      </form>
      </table>      
    </div>
    <!--- IEIR Reports NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
