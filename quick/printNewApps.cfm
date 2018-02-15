<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<cfquery name='campus' datasource='ieir_assessment'>
	select campus from locations where lc_id = #loc#
</cfquery>
<cfif isdefined('major')>
	<h5 class="rubricHeading"><em><span>New Application Details</span></em> for <cfoutput>#major# for the #campus.campus# Campus.</cfoutput></h5>
<cfelse>  
	<h5 class="rubricHeading"><em><span>New Application Details</span></em> for <cfoutput>all majors for the #campus.campus# Campus.</cfoutput></h5>
</cfif>  

<cfif isdefined('major')>
  <cfinvoke component='script.em' method='getNewList' major='#major#' location=#loc# returnvariable='getNew'></cfinvoke>
  <cfoutput>
  <h5>The following individuals are reflected in Colleague as eligible to enroll for the upcoming term, but have not yet registered for classes.</h5>
  
  <table class="drrTable" align="left">
    <tr>
      <td align="left">Major: #major#</td>
      <td align="left">Location: #loc#</td>
      <td colspan='3'>&nbsp;</td>
    </tr>
    <tr>
      <th align="left">Applicant</th>
      <th align="left">Last Name</th>
      <th align="left">First Name</th>
      <th align="left">App. Status</th>
      <th align="left">Telephone</th>
    </tr>
    <cfif getNew.recordCount eq 0>
      <tr>
        <td align="left" colspan="5">All eligible students for this program and location have registered already.</td>
      </tr>
    <cfelse>
    <cfloop query="getNew">
      <tr>
        <td align="left">#getNew.applicant#</td>
        <td align="left">#getNew.last_name#</td>
        <td align="left">#getNew.first_name#</td>
        <td align="left">#getNew.app_status#</td>
        <td align="left">#getNew.phone#</td>
      </tr>
    </cfloop>
    </cfif>
    <tr><td colspan="5" align="left">&nbsp;</td></tr>
  </table>
  </cfoutput>
<cfelse>
  <cfinvoke component='script.em' method='getNewAppsForLoc' location=#loc# returnvariable='allMajors'></cfinvoke>
  <cfoutput>
  <h5>The following individuals are reflected in Colleague as eligible to register, but have not yet registered for classes at the location shown above.</h5>
  
  <table class="drrTable" align="left">
    <cfloop index="ndx" from="1" to="#ArrayLen(allMajors)#" step="1">
      <tr>
        <td align="left">Major: #allMajors[ndx].major#</td>
        <td align="left">Location: #loc#</td>
        <td colspan='3'>&nbsp;</td>
      </tr>
      <tr>
        <th align="left">Applicant</th>
        <th align="left">Last Name</th>
        <th align="left">First Name</th>
        <th align="left">App. Status</th>
        <th align="left">Telephone</th>
      </tr>
      <cfset getNew = allMajors[ndx].newAppList>
      <cfloop query="getNew">
        <tr>
          <td align="left">#getNew.applicant#</td>
          <td align="left">#getNew.last_name#</td>
          <td align="left">#getNew.first_name#</td>
          <td align="left">#getNew.app_status#</td>
          <td align="left">#getNew.phone#</td>
        </tr>
      </cfloop>
      <tr><td colspan="5" align="left">&nbsp;</td></tr>
    </cfloop>
  </table>
  </cfoutput>
</cfif>
</div>

<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p><cfinclude template="../body_links.cfm"></p>
</div>
</div>
<!-- MAIN RIGHT END -->

<div id="mainLeft">
</div>
<!-- MAIN BODY END -->
</div>
