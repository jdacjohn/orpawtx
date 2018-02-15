<cfif isdefined("bk_cohort")>
	<cfset selCohort = bk_cohort>
  <cfinvoke component="script.terms" method="getTerm" varCohort=#selCohort# returnvariable="term">
  <cfset fullTerm = term.fullTerm>
<cfelse>
	<cfset selCohort = Application.Settings.BkStoreNextCohort>
  <cfset fullTerm = Application.Settings.BkStoreNextTermFull>
</cfif>
<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Section Enrollments by Student Location</span></em> for <cfoutput>#fullTerm#</cfoutput></h5>
<cfinvoke component="script.bkstore" method='latestRunDate' bk_cohort=#selCohort# returnvariable="lastRun"></cfinvoke>
<cfinvoke component="script.bkstore" method='getDeptSummary' bk_cohort=#selCohort# seqNo=#lastRun.seq# returnvariable="depts"></cfinvoke>

<cfoutput>
<table align="left" class="drrTable">
  <tr>
    <th colspan="4" width="498" align="left">TSTC West Texas Section Enrollment by Student Location as of #DateFormat(lastRun.runDate, 'mm/dd/yyyy')#</th>
  </tr>
  <tr>
  	<th colspan="4" align="left" style="border:0px"><a onclick="javascript:toggle('departments','.');"><img src="./images/buttons/collapse.png" name="expand_departments" id="expand_departments" width="12" height="12" border="0" valign="bottom"></a> Departments</th>
  </tr>
  <tr id="departments">
  	<td colspan='4'>
    	<table class="drrTable" align="left">
        <tr>
          <td width="124" align="left">Department</td>
          <td width="124" align="left">Sections</td>
          <td width="47" align="center">Registered</td>
          <td width="46" align="center">Dropped</td>
          <td width="46" align="center">Current</td>          
          <td width="109" align="right">Campuses</td>
        </tr>
				<cfloop query="depts">
          <tr>
            <td align="left"><a onclick="javascript:toggle('#depts.dept#','.');"><img src="./images/buttons/expand.png" name="expand_#depts.dept#" id="expand_#depts.dept#" width="12" height="12" border="0" valign="bottom"></a> #depts.dept#</td>
            <td align="left">#depts.sections#</td>
            <td align="right">#depts.registered#</td>
            <td align="right">#depts.drops#</td>
            <td align="right">#depts.registered - depts.drops#</td>
            <td align="right">#depts.locs#</td>
          </tr>
          <tr id="#depts.dept#" style="display:none">
          	<td colspan="6" align="left">
            	<table class="drrTable" align="left">
              	<cfinvoke component="script.bkstore" method="getDeptDetail" bk_cohort=#selCohort# dept="#depts.dept#" seqNo=#lastRun.seq# returnvariable="seclist"></cfinvoke>
                <cfset department = depts.dept>
								<cfloop query='seclist'>
              	<cfinvoke component="script.bkstore" method="getSecDetail" bk_cohort=#selCohort# dept="#depts.dept#" sectionName='#seclist.secName#' seqNo=#lastRun.seq# returnvariable="campusList"></cfinvoke>
                  <tr>
                  	<td width="124" align="left">&nbsp;</td>
                    <td width="124" align="left"><a onclick="javascript:toggle('#seclist.secName#','.');"><img src="./images/buttons/expand.png" name="expand_#seclist.secName#" id="expand_#seclist.secName#" width="12" height="12" border="0" valign="bottom"></a> <cfif seclist.locs gt 1><span style="text-decoration:underline;">#seclist.secName#</span><cfelse>#seclist.secName#</cfif></td>
                    <td width="47" align="right">#seclist.registered#</td>
                    <td width="46" align="right">#seclist.drops#</td>
                    <td width="46" align="right">#seclist.registered - seclist.drops#</td>
                    <td width="108" align="right">#seclist.locs#</td>
                  </tr>
                  <tr id="#seclist.secName#" style="display:none">
                    <td colspan="6" align="left">
											<table class="drrTable" align="left">
                        <cfloop query="campusList">
                        	<tr>
                        		<td colspan="2" width="248" align="left">&nbsp;</td>
                          	<td width="47" align="right">#campusList.registered#</td>
                          	<td width="46" align="right">#campusList.drops#</td>
                          	<td width="46" align="right">#campusList.registered - campusList.drops#</td>
                            <td width="108" align="right">#campusList.campus#</td>
                          </tr>
                        </cfloop>
                      </table>
                    </td>
                  </tr> 
                </cfloop>
              </table> 
            </td>
          </tr>
          
        </cfloop>
      </table>
    </td>
  </tr>
</table>
</cfoutput>
</div>

<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p><cfinclude template="../body_links.cfm"></p>
</div>
</div>
<!-- MAIN RIGHT END -->

<div id="mainLeft">
<!-- Term Reports nav -->
<div class="leftNavContainer" >

<h4 class="blue principles">Available Terms</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./bk_links.cfm"></ul>
	</div>
</div>
<!-- End term Reports Nav -->
<div class="leftNavContainer" >

<!-- COMMUNICATION NAV -->
<div class="leftNavContainer" >

<h4 class="blue comm">Other Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./quick_links.cfm"></ul>
	</div>
</div>
<!-- COMMUNICATION NAV END -->

</div>
<!-- MAIN BODY END -->
</div>
