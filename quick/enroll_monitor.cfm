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
  <cfquery name="getCohort" datasource="ieir_assessment">
  	select cohort from year_terms where term = '#reportTerm#'
  </cfquery>
  <cfset emCohort = getCohort.cohort>
<cfelse>
	<cfset reportTerm = Application.Settings.EmTermTitle>
  <cfset emCohort = Application.Settings.EmTermCohort>
</cfif>
<cfif isdefined("sequence")>
	<cfset regSeq = sequence>
  <cfquery name="getRunDate" datasource='ieir_assessment'>
  	select distinct(run_date) as run_date from em_monitor where cohort=#emCohort# and seq=#regSeq#
  </cfquery>
  <cfset dateToday = DateFormat(getRunDate.run_date,'mm-dd-YYYY')>
</cfif>
<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Applications Monitor</span></em> for <cfoutput>#reportTerm#</cfoutput></h5>
<p><span style="color:#FF0000"><b>The TSTC West Texas Applications Monitor is changing with a new name and new features!</b></span> 
Mouse over column headers for information on what the numbers beneath those headers represent.  You can click on numbers in the report that
are <span style="text-decoration:underline;">underlined</span> to see a printable listing of the students in the category. If you 
mouse over underlined numbers at the campus level in the Division Detail section a pop-up will display showing applicable
student information which can also be printed.
</p>
<cfif isDefined('regSeq')>
	<cfinvoke component='script.em' method='em_summary' varCohort="#emCohort#" varSequence=#regSeq# returnVariable='em_lines'></cfinvoke>
<cfelse>
	<cfinvoke component='script.em' method='em_summary' varCohort="#emCohort#" returnVariable='em_lines'></cfinvoke>
</cfif>
<cfset sumNew = 0>
<cfset sumNewProj = 0>
<cfset sumRetProj = 0>
<cfset sumTotal = 0>
<cfset sumPending = 0>
<cfloop query="em_lines">
	<cfset sumNew += em_lines.new_apps>
  <cfset sumNewProj += em_lines.proj_new>
  <cfset sumRetProj += em_lines.proj_ret>
  <cfset sumTotal += (em_lines.proj_new + em_lines.proj_ret)>
  <cfset sumPending += em_lines.pending>
</cfloop>
<cfoutput>
 <table class="drrTable" align="left" style="width:550px">
  <tr>
    <th colspan="5" align="left">TSTC West Texas Applications and Enrollment Projections as of #dateToday#</th>
  </tr>
  <tr>
    <td width='110' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The number of new student applications for #reportTerm# that are in a pending status and not eligible to enroll for classes."><span style="text-decoration:underline">Pending  Apps.</span></cftooltip>
    </td>
    <td width='110' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The number of new students who have been accepted and/or are eligible to register for #reportTerm#"><span style="text-decoration:underline">Eligible</span></cftooltip>
    </td>
    <td width='110' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The PROJECTED number of new students who have been accepted and/or are eligible to register for #reportTerm# that actually WILL register for classes."><span style="text-decoration:underline">Proj. New</span></cftooltip>
    </td>
    <td width='110' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The PROJECTED number of #Application.Settings.CurrentColTerm# students who will enroll in classes for #reportTerm#."><span style="text-decoration:underline">Proj. Ret.</span></cftooltip>
    </td>
    <td width='110' align="center">
    	<cftooltip
				hideDelay="500"
        preventOverlap="true"
        showDelay="100"
        tooltip="The PROJECTED total enrollment of both new and returning students for #reportTerm#"><span style="text-decoration:underline">Proj. Enrollment</span></cftooltip>
    </td>
  </tr>
  <tr>
    <td width='110' align="center">#sumPending#</td>
    <td width='110' align="center">#sumNew#</td>
    <td width='110' align="center">#sumNewProj#</td>
    <td width='110' align="center">#sumRetProj#</td>
    <td width='110' align="center">#sumTotal#</td>
  </tr>
  <tr>
  	<td colspan="5">
    	<cfchart format="jpg" showlegend="yes" chartwidth="540">
      	<cfchartseries type="bar" colorlist="ff0000,00ff00,008080,feff0e,0000ff" 
        		dataLabelStyle="value" paintStyle="shade">
	      	<cfchartdata item="Pending" value="#sumPending#">
          <cfchartdata item="Eligible" value="#sumNew#">
          <cfchartdata item="Proj. New" value="#sumNewProj#">
          <cfchartdata item="Proj. Ret." value="#sumRetProj#">
          <cfchartdata item="Proj. Total" value="#sumTotal#">
        </cfchartseries>
      </cfchart>
    </td>
  </tr>
  <tr>
  	<th colspan="5" align="left" style="border:0px"><a onclick="javascript:toggle('locations','.');"><img src="./images/buttons/collapse.png" name="expand_locations" id="expand_locations" width="12" height="12" border="0" valign="bottom"></a> Campus Detail</th>
  </tr>
  <tr id="locations">
  	<td colspan='5'>
    	<table class="drrTable" align="left" style="width:550px; border: 0px;">
        <tr>
          <td width='100' align="left">Location</td>
          <td width='90' align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The number of new students who have been accepted and/or are eligible to register for #reportTerm# at the indicated campus."><span style="text-decoration:underline">Eligible</span></cftooltip>
          </td>
          <td width='90' align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of new students who have been accepted and/or are eligible to register for #reportTerm# that actually WILL register for classes at the indicated campus."><span style="text-decoration:underline">Proj. New</span></cftooltip>
          </td>
          <td width='90' align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of #Application.Settings.CurrentColTerm# students at the indicated campus who will enroll in classes for #reportTerm#."><span style="text-decoration:underline">Proj. Ret.</span></cftooltip>
          </td>
          <td width='90' align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The number of new student applications for #reportTerm# for the indicated campus that are in a pending status and not eligible to enroll for classes."><span style="text-decoration:underline">Pending</span></cftooltip>
          </td>
          <td width='90' align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected total enrollment of both new and returning students for #reportTerm# for the indicated campus."><span style="text-decoration:underline">Proj. Total</span></cftooltip>
          </td>
        </tr>
				<cfloop query="em_lines">
          <cfquery name="getLoc" datasource="ieir_assessment">
            select campus from locations where lc_id = #em_lines.loc#
          </cfquery>
          <cfset total = em_lines.proj_new + em_lines.proj_ret>
          <tr>
            <td align="left">#getLoc.campus#</td>
            <td align="right"><a href="./index.cfm?action=QL_EM_Prt_New&loc=#em_lines.loc#" target="_blank">#em_lines.new_apps#</a></td>
            <td align="right">#em_lines.proj_new#</td>
            <td align="right">#em_lines.proj_ret#</td>
            <td align="right"><a href="./index.cfm?action=QL_EM_Prt_Pending&loc=#em_lines.loc#" target="_blank">#em_lines.pending#</a></td>
            <td align="right">#total#</td>
          </tr>
      	</cfloop>
      </table>
    </td>
  </tr>
  
	<cfif isDefined('regSeq')>
    <cfinvoke component='script.em' method='em_divisions' varCohort="#emCohort#" varSequence=#regSeq# returnVariable='divData'></cfinvoke>
  <cfelse>
    <cfinvoke component='script.em' method='em_divisions' varCohort="#emCohort#" returnVariable='divData'></cfinvoke>
  </cfif>
  <tr>
    <th colspan="5" align="left"><a onclick="javascript:toggle('divisions','.');"><img src="./images/buttons/expand.png" name="expand_divisions" id="expand_divisions" width="12" height="12" border="0" valign="bottom"></a> Division Detail</th>
  </tr>
	<tr id="divisions">	
  	<td colspan="5">
    	<table class="drrTable" align="left" style="width:550px; border: 0px;">
        <tr>
          <td width="120" align="left">Division</td>
          <td width="70" align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The number of new students within the instructional division who have been accepted and/or are eligible to register for #reportTerm#."><span style="text-decoration:underline">Eligible</span></cftooltip>
          </td>
          <td width="90" align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of new students who have been accepted and/or are eligible to register for #reportTerm# that actually WILL register for classes at the indicated campus."><span style="text-decoration:underline">Proj. New</span></cftooltip>
          </td>
          <td width="90" align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected number of #Application.Settings.CurrentColTerm# students in the division who will enroll in classes for #reportTerm#."><span style="text-decoration:underline">Proj. Ret.</span></cftooltip>
          </td>
          <td width="90" align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The number of new student applications for #reportTerm# for the instructional division that are in a pending status and not eligible to enroll for classes."><span style="text-decoration:underline">Pending</span></cftooltip>
          </td>
          <td width="90" align="right">
            <cftooltip
              hideDelay="500"
              preventOverlap="true"
              showDelay="100"
              tooltip="The projected total enrollment of both new and returning students for #reportTerm# for the instructional division."><span style="text-decoration:underline">Proj. Total</span></cftooltip>
          </td>
        </tr>
        <cfloop index="ddx" from="1" to="#ArrayLen(divData)#" step="1"> <!--- Division Data Loop --->
          <tr>
            <td align="left"><a onclick="javascript:toggle('#divData[ddx].name#','.');"><img src="./images/buttons/expand.png" name="expand_#divData[ddx].name#" id="expand_#divData[ddx].name#" width="12" height="12" border="0" valign="bottom"></a> #divData[ddx].name#</td>
            <td align='right'>#divData[ddx].new#</td>
            <td align='right'>#divData[ddx].projected_new#</td>
            <td align='right'>#divData[ddx].projected_returning#</td>
            <td align='right'>#divData[ddx].pending#</td>
            <td align='right'>#divData[ddx].projected_total#</td>
          </tr>
          <tr id="#divData[ddx].name#" style="display:none">
            <td colspan='6'>
              <table class="drrTable" align="left" style="width:550px; border: 0px;">
								<cfif isDefined('regSeq')>
                  <cfinvoke component='script.em' method='em_detail' varCohort="#emCohort#" varSequence=#regSeq# varDiv='#divData[ddx].name#' returnVariable='emData'></cfinvoke>
                <cfelse>
                  <cfinvoke component='script.em' method='em_detail' varCohort="#emCohort#" varDiv='#divData[ddx].name#' returnVariable='emData'></cfinvoke>
                </cfif>
                <tr>	
                  <td>
                    <table class="drrTable" align="left" style="width:550px; border: 0px;">
                      <tr>
                        <td align="left" width="120">Program</td>
                        <td align="right" width="70">
                          <cftooltip
                            hideDelay="500"
                            preventOverlap="true"
                            showDelay="100"
                            tooltip="The number of new students in the program who have been accepted and/or are eligible to register for #reportTerm#."><span style="text-decoration:underline">Eligible</span></cftooltip>
                        </td>
                        <td align="right" width="90">
                          <cftooltip
                            hideDelay="500"
                            preventOverlap="true"
                            showDelay="100"
                            tooltip="The PROJECTED number of new students who have been accepted in the program and/or are eligible to register for #reportTerm# that actually WILL register for classes."><span style="text-decoration:underline">Proj. New</span></cftooltip>
                        </td>
                        <td align="right" width="90">
                          <cftooltip
                            hideDelay="500"
                            preventOverlap="true"
                            showDelay="100"
                            tooltip="The PROJECTED number of #Application.Settings.CurrentColTerm# students in the program who will register for classes for #reportTerm#."><span style="text-decoration:underline">Proj. Ret.</span></cftooltip>
                        </td>
                        <td align="right" width="90">
                          <cftooltip
                            hideDelay="500"
                            preventOverlap="true"
                            showDelay="100"
                            tooltip="The number of new student applications for #reportTerm# for the program that are in a pending status and are not yet eligible to enroll in the college."><span style="text-decoration:underline">Pending</span></cftooltip>
                        </td>
                        <td align="right" width="90">
                          <cftooltip
                            hideDelay="500"
                            preventOverlap="true"
                            showDelay="100"
                            tooltip="The projected total enrollment of both new and returning students for #reportTerm# in the program."><span style="text-decoration:underline">Proj. Total</span></cftooltip>
                        </td>
                      </tr>
               				<cfloop index="ndx" from="1" to="#ArrayLen(emData)#" step="1"> <!--- major data loop --->
                        <tr>
                          <td align="left" width="120"><a onclick="javascript:toggle('#emData[ndx].major#','.');"><img src="./images/buttons/expand.png" name="expand_#emData[ndx].major#" id="expand_#emData[ndx].major#" width="12" height="12" border="0" valign="bottom"></a> #emData[ndx].major#</td>
                          <td align='right' width="70">#emData[ndx].newApps#</td>
                          <td align='right' width="90">#emData[ndx].projectedNew#</td>
                          <td align='right' width="90">#emData[ndx].projectedReturning#</td>
                          <td align='right' width="90">#emData[ndx].pendingApps#</td>
                          <td align='right' width="90">#emData[ndx].projectedTotal#</td>
                        </tr>
        								<tr id="#emData[ndx].major#" style="display:none">
                        	<td colspan="6">
                          	<table class="drrTable" align="left" style="width:550px; border: 0px;">
                        		<cfset locData = emData[ndx].locSpec>
                        		<cfloop index="jdx" from="1" to="#ArrayLen(locData)#" step="1"> <!--- Loc Data Loop --->
                  						<tr>
                    						<td width="117" align="left">#locData[jdx].campus#</td>
                    						<cfif locData[jdx].newApps gt 0>
																	<cfset newList = locData[jdx].newList>
                            			<cfset newOut = "*The following individuals are eligible to enroll but have not registered for classes:   <a href='./index.cfm?action=QL_EM_Prt_New&major=#emData[ndx].major#&loc=#locData[jdx].loc#' target='_blank'>Print</a><br /><hr width='300' /><br />">
                            			<cfloop query='newList'>
                              			<cfset newOut = newOut & "<span style='text-decoration:underline'>#newList.applicant#, #newList.first_name# #newList.last_name#, #newList.app_status#, #newList.phone#</span><br />">
                            			</cfloop>
                            			<td width="70" align="right"><!---autoDismissDelay="10000"--->
																		<cftooltip
                              			<!---autoDismissDelay="10000"--->
                              			hideDelay="5000"
                              			preventOverlap="true"
                              			showDelay="200"
                              			tooltip="#newOut#"><span style="text-decoration:underline;">#locData[jdx].newApps#</span></cftooltip></td>
                    						<cfelse>
                      						<td width="70" align="right">#locData[jdx].newApps#</td>
                    						</cfif>
                    						<td width="90" align="right">#locData[jdx].projectedNew#</td>
                    						<td width="90" align="right">#locData[jdx].projectedReturning#</td>
                    						<cfif locData[jdx].pendingApps gt 0>
                      						<cfset pendingList = locData[jdx].pendingList>
                      						<cfset pending = "*The following individuals have <br />applications with a pending status:   <a href='./index.cfm?action=QL_EM_Prt_Pending&major=#emData[ndx].major#&loc=#locData[jdx].loc#' target='_blank'>Print</a><br /><hr width='300' /><br />">
                      						<cfloop query='pendingList'>
                        						<cfset pending = pending & "<span style='text-decoration:underline'>#pendingList.applicant#, #pendingList.first_name# #pendingList.last_name#, #pendingList.app_status#, #pendingList.phone#</span><br />">
                      						</cfloop>
                      						<td width="90" align="right"><cftooltip
                        						<!---autoDismissDelay="10000"--->
                        						hideDelay="5000"
                        						preventOverlap="true"
                        						showDelay="200"
                        						tooltip="#pending#"><span style="text-decoration:underline;">#locData[jdx].pendingApps#</span></cftooltip></td>
                    						<cfelse>
                      						<td width="90" align="right">#locData[jdx].pendingApps#</td>
                    						</cfif>
                    						<td width="90" align="right">#locData[jdx].projectedTotal#</td>
                  						</tr>
                            </cfloop>  <!--- End Loc Data Loop --->
													</table>
                        </td>
                      </tr>
		        					</cfloop> <!--- End majors loop --->
                		</table>
          				</td>
        				</tr>
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
<h4 class="blue linkage">Explanation of Changes/Legend</h4>

  <p>
  <b>Unassigned</b> contains all programs that are in teach out or on 'hold' and are not assigned to a particular division based on
  the most current information provided to IE/IR by the Instructional Division.<br />
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
		<ul><cfinclude template="./em_cal.cfm"></ul>
	</div>
</div>
<!-- End term Reports Nav -->
<div class="leftNavContainer" >

<h4 class="blue principles">Previous Terms</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./em_terms.cfm"></ul>
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
