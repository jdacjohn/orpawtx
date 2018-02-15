<style type="text/css">
  .yui-tt {
    color: #0000FF;
    font-size:110%;
    border: 1px solid #0000FF;
    background-color: #ffea87;
		/* background: url(./images/nav_sub_bg5.png) repeat top; */
		padding: 5px;
    width: 300px;
		text-align:left;
  }
</style>
<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<cfset dateToday = DateFormat(Now(),"mm/dd/yyyy")>
<cfif isdefined("term")>
	<cfset reportTerm = term>
  <cfinvoke component='script.stu_appreg' method='getCohort' term='#reportTerm#' returnvariable="arCohort"></cfinvoke>
<cfelse>
	<cfset reportTerm = Application.Settings.AppRegTerm>
  <cfset arCohort = Application.Settings.AppRegCohort>
</cfif>
<cfif isdefined("sequence")>
	<cfset repSeq = sequence>
  <cfinvoke component='script.stu_appreg' method='getRunDate' appRegCohort=#arCohort# repSeq=#repSeq# returnVariable="dateToday"></cfinvoke>
</cfif>

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Applications to Enrollments</span></em> for <cfoutput>#reportTerm#</cfoutput></h5>
<p><b><i>Welcome to the new Applications and Enrollments Reports</i></b>.
</p>
<cfif isDefined('repSeq')>
	<cfinvoke component='script.stu_appreg' method='summaryCombined' varCohort="#arCohort#" varSequence=#repSeq# returnVariable='summaryLines'></cfinvoke>
<cfelse>
	<cfinvoke component='script.stu_appreg' method='summaryCombined' varCohort="#arCohort#" returnVariable='summaryLines'></cfinvoke>
</cfif>
<cfset sumApps = 0>
<cfset sumAccepted = 0>
<cfset sumEligible = 0>
<cfset sumPNew = 0>
<cfset sumPRet = 0>
<cfset sumPEnrolled = 0>
<cfset sumEnrolled = 0>
<cfset sumEnrolledNew = 0>
<cfloop query="summaryLines">
	<cfset sumApps += summaryLines.applied>
	<cfset sumAccepted += summaryLines.accepted>
  <cfset sumEligible += summaryLines.eligible>
  <cfset sumPNew += summaryLines.pNew>
  <cfset sumPRet += summaryLines.pRet>
  <cfset sumPEnrolled += (summaryLines.pNew + summaryLines.pRet)>
  <cfset sumEnrolled += summaryLines.enrolled>
  <cfset sumEnrolledNew += summaryLines.enrolledNew>
</cfloop>
<cfoutput>
 <table class="drrTable" align="left" style="width:550px">
  <tr>
    <th colspan="8" align="left">TSTC West Texas New Student Applications to Enrollments as of #dateToday#</th>
  </tr>
  <tr>
    <td width='68' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The total number of applications received indicating a start term of #reportTerm#"><span style="text-decoration:underline">Applied</span></cftooltip>
    </td>
    <td width='68' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The total number of new applicants that have been accepted to the college for #reportTerm#"><span style="text-decoration:underline">Accepted</span></cftooltip>
    </td>
    <td width='68' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The total number of accepted applicants for #reportTerm# who are eligible to enroll in classes"><span style="text-decoration:underline">Eligible</span></cftooltip>
		</td>    
    <td width='68' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The projected number of accepted applicants who will actually enroll in classes"><span style="text-decoration:underline">p(New)</span></cftooltip>
		</td>    
    <td width='68' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The projected number of current students who will return in #reportTerm#"><span style="text-decoration:underline">p(Ret.)</span></cftooltip>
		</td>    
    <td width='68' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The projected number of both new and returning students who will enroll in classes for #reportTerm#"><span style="text-decoration:underline">p(Total)</span></cftooltip>
		</td>    
    <td width='68' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The actual number of new students who have enrolled in classes for #reportTerm#"><span style="text-decoration:underline">New Enr.</span></cftooltip>
		</td>    
    <td width='68' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The total number of students enrolled in classes for #reportTerm#"><span style="text-decoration:underline">Enrolled</span></cftooltip>
		</td>    
  </tr>
  <tr>
    <td width='68' align="center">#sumApps#</td>
    <td width='68' align="center">#sumAccepted#</td>
    <td width='68' align="center">#sumEligible#</td>
    <td width='68' align="center">#sumPNew#</td>
    <td width='68' align="center">#sumPRet#</td>
    <td width='68' align="center">#sumPEnrolled#</td>
    <td width='68' align="center">#sumEnrolledNew#</td>
    <td width='68' align="center">#sumEnrolled#</td>
  </tr>
  <tr>
  	<td colspan="8">
    	<cfchart format="jpg" showlegend="yes" chartwidth="540">
      	<cfchartseries type="bar" colorlist="808080,00ff00,0000ff,008080,ff00ff,ffff00,800000,800080" dataLabelStyle="value"
        		paintStyle="shade">
	      	<cfchartdata item="Applied" value="#sumApps#">
          <cfchartdata item="Accepted" value="#sumAccepted#">
          <cfchartdata item="Eligible" value="#sumEligible#">
          <cfchartdata item="p(New)" value="#sumPNew#">
          <cfchartdata item="p(Ret)" value="#sumPRet#">
          <cfchartdata item="p(Total)" value="#sumPEnrolled#">
          <cfchartdata item="Enrolled New" value="#sumEnrolledNew#">
          <cfchartdata item="Enrolled" value="#sumEnrolled#">
        </cfchartseries>
      </cfchart>
    </td>
  </tr>
  <tr>
  	<th colspan="8" align="left" style="border:0px"><a onclick="javascript:toggle('locations','.');"><img src="./images/buttons/collapse.png" name="expand_locations" id="expand_locations" width="12" height="12" border="0" valign="bottom"></a> Campus Detail</th>
  </tr>
  <tr id="locations">
  	<td colspan='8'>
    	<table width="1455" align="left" class="drrTable" style="width:550px; border:0px;">
        <tr>
          <td width="140"><span style="text-decoration:underline">Location</span></th>
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The total number of applications received indicating a start term of #reportTerm#"><span style="text-decoration:underline">Applied</span></cftooltip>
          </td>
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The total number of new applicants that have been accepted to the college for #reportTerm#"><span style="text-decoration:underline">Accepted</span></cftooltip>
          </td>
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The total number of accepted applicants for #reportTerm# who are eligible to enroll in classes"><span style="text-decoration:underline">Eligible</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of accepted applicants who will actually enroll in classes"><span style="text-decoration:underline">p(New)</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of current students who will return in #reportTerm#"><span style="text-decoration:underline">p(Ret.)</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of both new and returning students who will enroll in classes for #reportTerm#"><span style="text-decoration:underline">p(Total)</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The actual number of new students who have enrolled in classes for #reportTerm#"><span style="text-decoration:underline">New Enr.</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The total number of students enrolled in classes for #reportTerm#"><span style="text-decoration:underline">Enrolled</span></cftooltip>
          </td>    
        </tr>
				<cfloop query="summaryLines">
        	<cfinvoke component='script.stu_appreg' method='getCampus' location=#summaryLines.loc# returnVariable="campus"></cfinvoke>
          <tr>
            <td align="left">#campus#</td>
            <td align="right"><a href="./index.cfm?action=QL_A2R_Prt_Applied&loc=#summaryLines.loc#" target="_blank">#summaryLines.applied#</a></td>
            <td align="right"><a href="./index.cfm?action=QL_A2R_Prt_AC&loc=#summaryLines.loc#" target="_blank">#summaryLines.accepted#</td>
            <td align="right"><a href="./index.cfm?action=QL_A2R_Prt_EL&loc=#summaryLines.loc#" target="_blank">#summaryLines.eligible#</td>
            <td align="right">#summaryLines.pNew#</td>
            <td align="right">#summaryLines.pRet#</td>
            <td align="right">#summaryLines.pNew + summaryLines.pRet#</td>
            <td align="right">#summaryLines.enrolledNew#</td>
            <td align="right">#summaryLines.enrolled#</td>
          </tr>
      	</cfloop>
      </table>
    </td>
  </tr>
  
	<cfif isDefined('regSeq')>
    <cfinvoke component='script.stu_appreg' method='getDivisions' varCohort="#arCohort#" varSequence=#repSeq# returnVariable='divData'></cfinvoke>
  <cfelse>
    <cfinvoke component='script.stu_appreg' method='getDivisions' varCohort="#arCohort#" returnVariable='divData'></cfinvoke>
  </cfif>
  <tr>
    <th colspan="8" align="left"><a onclick="javascript:toggle('divisions','.');"><img src="./images/buttons/expand.png" name="expand_divisions" id="expand_divisions" width="12" height="12" border="0" valign="bottom"></a> Division Detail</th>
  </tr>
	<tr id="divisions">	
  	<td colspan="8">
    	<table class="drrTable" align="left" style="width:550px; border:0px;">
        <tr>
          <td align="left" width='140'>Division</td>
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The total number of applications received indicating a start term of #reportTerm#"><span style="text-decoration:underline">Applied</span></cftooltip>
          </td>
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The total number of new applicants that have been accepted to the college for #reportTerm#"><span style="text-decoration:underline">Accepted</span></cftooltip>
          </td>
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The total number of accepted applicants for #reportTerm# who are eligible to enroll in classes"><span style="text-decoration:underline">Eligible</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of accepted applicants who will actually enroll in classes"><span style="text-decoration:underline">p(New)</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of current students who will return in #reportTerm#"><span style="text-decoration:underline">p(Ret.)</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of both new and returning students who will enroll in classes for #reportTerm#"><span style="text-decoration:underline">p(Total)</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The actual number of new students who have enrolled in classes for #reportTerm#"><span style="text-decoration:underline">New Enr.</span></cftooltip>
          </td>    
          <td align="right">
            <cftooltip
              hideDelay="1000"
              preventOverlap="true"
              showDelay="100"
              tooltip="The total number of students enrolled in classes for #reportTerm#"><span style="text-decoration:underline">Enrolled</span></cftooltip>
          </td>    
        </tr>
        <cfloop index="ddx" from="1" to="#ArrayLen(divData)#" step="1"> <!--- Division Data Loop --->
          <tr>
            <td align="left"><a onclick="javascript:toggle('#divData[ddx].name#','.');"><img src="./images/buttons/expand.png" name="expand_#divData[ddx].name#" id="expand_#divData[ddx].name#" width="12" height="12" border="0" valign="bottom"></a> #divData[ddx].name#</td>
            <td align='right'>#divData[ddx].applied#</td>
            <td align='right'>#divData[ddx].accepted#</td>
            <td align='right'>#divData[ddx].eligible#</td>
            <td align='right'>#divData[ddx].pNew#</td>
            <td align='right'>#divData[ddx].pRet#</td>
            <td align='right'>#divData[ddx].pRet + divData[ddx].pNew#</td>
            <td align='right'>#divData[ddx].enrolledNew#</td>
            <td align='right'>#divData[ddx].enrolled#</td>
          </tr>
          <tr id="#divData[ddx].name#" style="display:none">
            <td colspan='9'>
              <table class="drrTable" align="left" style="width:550px; border:0px;">
								<cfif isDefined('repSeq')>
                  <cfinvoke component='script.stu_appreg' method='ar_detail' varCohort="#arCohort#" varSequence=#repSeq# varDiv='#divData[ddx].name#' returnVariable='arData'></cfinvoke>
                <cfelse>
                  <cfinvoke component='script.stu_appreg' method='ar_detail' varCohort="#arCohort#" varDiv='#divData[ddx].name#' returnVariable='arData'></cfinvoke>
                </cfif>
                <tr>
                  <td align="left" width="140">Major</td>
                  <td align="right">
                    <cftooltip
                      hideDelay="1000"
                      preventOverlap="true"
                      showDelay="100"
                      tooltip="The total number of applications received indicating a start term of #reportTerm#"><span style="text-decoration:underline">Applied</span></cftooltip>
                  </td>
                  <td align="right">
                    <cftooltip
                      hideDelay="1000"
                      preventOverlap="true"
                      showDelay="100"
                      tooltip="The total number of new applicants that have been accepted to the college for #reportTerm#"><span style="text-decoration:underline">Accepted</span></cftooltip>
                  </td>
                  <td align="right">
                    <cftooltip
                      hideDelay="1000"
                      preventOverlap="true"
                      showDelay="100"
                      tooltip="The total number of accepted applicants for #reportTerm# who are eligible to enroll in classes"><span style="text-decoration:underline">Eligible</span></cftooltip>
                  </td>    
                  <td align="right">
                    <cftooltip
                      hideDelay="1000"
                      preventOverlap="true"
                      showDelay="100"
                      tooltip="The projected number of accepted applicants who will actually enroll in classes"><span style="text-decoration:underline">p(New)</span></cftooltip>
                  </td>    
                  <td align="right">
                    <cftooltip
                      hideDelay="1000"
                      preventOverlap="true"
                      showDelay="100"
                      tooltip="The projected number of current students who will return in #reportTerm#"><span style="text-decoration:underline">p(Ret.)</span></cftooltip>
                  </td>    
                  <td align="right">
                    <cftooltip
                      hideDelay="1000"
                      preventOverlap="true"
                      showDelay="100"
                      tooltip="The projected number of both new and returning students who will enroll in classes for #reportTerm#"><span style="text-decoration:underline">p(Total)</span></cftooltip>
                  </td>    
                  <td align="right">
                    <cftooltip
                      hideDelay="1000"
                      preventOverlap="true"
                      showDelay="100"
                      tooltip="The actual number of new students who have enrolled in classes for #reportTerm#"><span style="text-decoration:underline">New Enr.</span></cftooltip>
                  </td>    
                  <td align="right">
                    <cftooltip
                      hideDelay="1000"
                      preventOverlap="true"
                      showDelay="100"
                      tooltip="The total number of students enrolled in classes for #reportTerm#"><span style="text-decoration:underline">Enrolled</span></cftooltip>
                  </td>    
                </tr>
         				<cfloop index="ndx" from="1" to="#ArrayLen(arData)#" step="1"> <!--- major data loop --->
                  <tr>
                    <td align="left"><a onclick="javascript:toggle('#arData[ndx].major#','.');"><img src="./images/buttons/expand.png" name="expand_#arData[ndx].major#" id="expand_#arData[ndx].major#" width="12" height="12" border="0" valign="bottom"></a> #arData[ndx].major#</td>
                    <td align='right'>#arData[ndx].applied#</td>
                    <td align='right'>#arData[ndx].accepted#</td>
                    <td align='right'>#arData[ndx].eligible#</td>
                    <td align='right'>#arData[ndx].pNew#</td>
                    <td align='right'>#arData[ndx].pRet#</td>
                    <td align='right'>#arData[ndx].pNew + arData[ndx].pRet#</td>
                    <td align='right'>#arData[ndx].enrolledNew#</td>
                    <td align='right'>#arData[ndx].enrolled#</td>
                  </tr>
   								<tr id="#arData[ndx].major#" style="display:none">
                   	<td colspan="9">
                     	<table class="drrTable" align="left" style="width:550px; border:0px;">
                     		<cfset locData = arData[ndx].locSpec>
                     		<cfloop index="jdx" from="1" to="#ArrayLen(locData)#" step="1"> <!--- Loc Data Loop --->
             						<tr>
               						<td width="137" align="left">#locData[jdx].campus#</td>
               						<cfif locData[jdx].applied gt 0>
                 						<cfset pendingList = locData[jdx].pendingList>
                 						<cfset pending = "*The following individuals have applications with a pending status and are not yet eligible to register for classes:   <a href='./index.cfm?action=QL_EM_Prt_Pending&major=#arData[ndx].major#&loc=#locData[jdx].loc#' target='_blank'>Print</a><br /><hr width='100%' /><br />">
                 						<cfloop query='pendingList'>
                   						<cfset pending = pending & "<span style='text-decoration:underline'>#pendingList.applicant#, #pendingList.first_name# #pendingList.last_name#, #pendingList.app_status#, #pendingList.phone#</span><br />">
                 						</cfloop>
                 						<td width="51" align="right"><cftooltip
                   						<!---autoDismissDelay="10000"--->
                   						hideDelay="2000"
                   						preventOverlap="true"
                   						showDelay="200"
                   						tooltip="#pending#">&nbsp;#locData[jdx].applied#&nbsp;</cftooltip></td>
               						<cfelse>
                 						<td width="51" align="right">#locData[jdx].applied#</td>
               						</cfif>
                          <td width="53" align="right">#locData[jdx].accepted#</td>
               						<cfif locData[jdx].eligible gt 0>
														<cfset newList = locData[jdx].newList>
                       			<cfset newOut = "*The following individuals are eligible to enroll in classes but have not registered:   <a href='./index.cfm?action=QL_EM_Prt_New&major=#arData[ndx].major#&loc=#locData[jdx].loc#' target='_blank'>Print</a><br /><hr width='100%' /><br />">
                       			<cfloop query='newList'>
                         			<cfset newOut = newOut & "<span style='text-decoration:underline'>#newList.applicant#, #newList.first_name# #newList.last_name#, #newList.app_status#, #newList.phone#</span><br />">
                       			</cfloop>
                       			<td width="50" align="right"><cftooltip
                         			<!---autoDismissDelay="10000"--->
                         			hideDelay="2000"
                         			preventOverlap="true"
                         			showDelay="200"
                         			tooltip="#newOut#">&nbsp;#locData[jdx].eligible#&nbsp;</cftooltip></td>
               						<cfelse>
                 						<td width="50" align="right">#locData[jdx].eligible#</td>
               						</cfif>
               						<td width="43" align="right">#locData[jdx].pNew#</td>
               						<td width="44" align="right">#locData[jdx].pRet#</td>
               						<td width="47" align="right">#locData[jdx].pNew + locData[jdx].pRet#</td>
               						<td width="55" align="right">#locData[jdx].enrolledNew#</td>
               						<td align="right">#locData[jdx].enrolled#</td>
             						</tr>
                      </cfloop>  <!--- End Loc Data Loop --->
											</table>
                    </td>
                  </tr>
		        		</cfloop> <!--- End majors loop --->
              </table>
          	</td>
          </tr>
        </cfloop> <!--- End Div Loop --->
      </table>
    </td>
  </tr>
</table> 
</cfoutput>
</div>

<div class="rightContent" >
<h4 class="blue linkage">Legend</h4>

  <p>
  <b>Applied</b> = The total number of applications received by the college for the upcoming start term.<br />
  <b>Accepted</b> = Of the applications received, the number of applicants who have been accepted.<br />
  <b>Eligible</b> = Of the accepted applicants, those eligible to register for classes.<br />
  <b>p(New)</b> = The projected number of applicants who are accepted or eligible to register that actually will enroll in classes.<br />
  <b>p(Ret)</b> = The projected number of current students who will enroll in classes in the upcoming term.<br />
  <b>p(Total)</b> = The projected enrollment of both new and returning students based on historical show/no-show rates by academic program
  for the same terms in preceding years.<br />
  <b>New Enr.</b> = The actual number of new students who have enrolled for classes for the upcoming term.<br />
  <b>Enrolled</b> = The actual number of students who have enrolled for classes for the upcoming term.  This figure includes both new
  and returning students.<br />
  </p> 
  <p>Please contact <a href="mailto:john.arnold@sweetwater.tstc.edu">John Arnold</a> in the Office of Research,
      Planning & Analysis at <span style="text-decoration:underline">325.235.7408</span> with any questions or suggestions.
  </p>
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

<h4 class="blue principles">Term Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./ar_cal.cfm"></ul>
	</div>
</div> 
<!-- End term Reports Nav -->
 <div class="leftNavContainer" >

<h4 class="blue principles">Available Terms</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./ar_terms.cfm"></ul>
	</div>
</div>

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
