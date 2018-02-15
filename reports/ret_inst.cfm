<div id="mainBody">
  <!--- MAIN RIGHT ---->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <h5 class="rubricHeading"><em><span>Institutional Retention Calculations</span></em></h5>
      <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
      <p>Institutional Retention measures student attrition rates from the start of one period, generally the Fall term,
      to the start of the next similarly occurring term.  The Fall to Fall retention measurement calculations utilize the
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
        <tr><td><input type="radio" name="retspan" id="retspan" value="fa2fa" onClick="javascript:hideList('sm2smList');showList('fa2faList');"/> Fall to Fall</td></tr>
        <tr><td><input type="radio" name="retspan" id="retspan" value="sm2sm" onClick="javascript:hideList('fa2faList');showList('sm2smList');"/> Semester to Semester</td></tr>
        <tr><td><input type="checkbox" name="byloc" /> Show by Campus</td></tr>
        <tr id="fa2faList" <cfif retspan eq "sm2sm" or retspan eq "">style="display: none"</cfif>>
          <td width="100%">
            <table class="retTable" style="border: 1px solid #142855;">
              <tr><th>Full Year Cohorts</th></tr>
              <tr>
                <td>
                  <select id="fallselects" name="fallselects" class="retTable" width="140" multiple>
                  	<cfinclude template="./include/fa_terms.cfm">
                  </select>
                </td>
              </tr>
            </table>
          </td>
         </tr>
        <tr id="sm2smList" <cfif retspan eq "fa2fa" or retspan eq "">style="display: none"</cfif>>
          <td width="100%">
            <table class="retTable" style="border: 1px solid #142855;">
              <tr><th>Semester Cohorts</th></tr>
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
          <td><input type="button" class="heading3" value="Continue" onClick="javascript:cform.submit();" /></td>
        </tr>
      </form>
      </table>      
    </div>
    <!--- IEIR Reports NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
