<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcomes Dashboard</h4>
	<h5 class="blueback">Instructional Divisions</h5>
  <cfinvoke component='script.programs' method='getDivisions' returnvariable="divList"></cfinvoke>
	<cfoutput>
  <cfloop query="divList">
		<span style="text-decoration:underline">#divList.division#</span><br />
    <cfinvoke component='script.programs' method='getDivMajors' division='#divList.division#' returnvariable="majorsList"></cfinvoke>
    Programs:  
    <cfloop query='majorsList'><a href='./index.cfm?action=LOS_Status&major=#majorsList.major#'>#majorsList.major#</a>&nbsp;&nbsp;</cfloop><br />
  </cfloop>
  &nbsp;<br />		
	<cfif isdefined("major")>
    <div class="rightContent" >
    <cfinvoke component='script.programs' method='getProgFullName' rubric='#major#' returnvariable="progQuery"></cfinvoke>
    <h5 class="blueback">#progQuery.progName#</h5>
  	<cfinvoke component='script.los' method='getAGTerms' progId=#progQuery.p_id# returnVariable="groups"></cfinvoke>
  	<cfloop query="groups">
    	<cfinvoke component='script.los' method='getTermCompRate' prog_id=#progQuery.p_id# term='#groups.agTerm#' returnvariable='groupInfo'></cfinvoke>
      <cfset background=''>
      <cfif groupInfo.pct le 0.5>
      	<cfset background='redstatus'>
      </cfif>
      <cfif groupInfo.pct gt 0.5 && groupInfo.pct le 0.75>
      	<cfset background='yellowstatus'>
      </cfif>
      <cfif groupInfo.pct gt 0.75 && groupInfo.pct le 0.9>
      	<cfset background='greenstatus'>
      </cfif>
      <cfif groupInfo.pct gt 0.9>
      	<cfset background='bluestatus'>
      </cfif>
  		<h5 class="#background#">
      	&nbsp;<a href="./index.cfm?action=LOS_Status&major=#major#&p_id=#progQuery.p_id#&term=#groups.agTerm#" title="View Term Assignments">#groups.agTerm#</a>&nbsp;
        Assignments: #groupInfo.loas#&nbsp;&nbsp;&nbsp;Assessments: #groupInfo.assessments#&nbsp;&nbsp;&nbsp;Completed: #groupInfo.done#&nbsp;&nbsp;&nbsp;Percent Complete: #(groupInfo.pct * 100)# %
      </h5>
    <cfif isDefined('term') and term eq groups.agTerm>
      <cfset agTerm = #term#>
      <cfinvoke component='script.los' method='getAssignmentResults' progId=#progQuery.p_id# term='#agTerm#' returnVariable="aGroups"></cfinvoke>
      <table class="loSummaryTable" cellspacing="0" cellpadding="0">
        <tr>
          <th>Outcome</th>
          <th>Level</th>
          <th>Class</th>
          <th>Enrolled</th>
          <th>Assessed</th>
          <th>Completion</th>
          <th>Rating</th>
        </tr>
        <cfloop query='aGroups'>
        <cfinvoke component='script.los' method='getOutcomeById' outcomeId=#aGroups.loid# returnVariable='q_lo'></cfinvoke>
        <cfinvoke component='script.los' method='countAssessments' groupId=#aGroups.loa_group_id# returnVariable='assessments'></cfinvoke>
        <cfset comp = (assessments.count/aGroups.enrolled) * 100>
        <cfif comp gt 0>
        	<cfinvoke component='script.los' method='getOutcomeResults' groupId=#aGroups.loa_group_id# outcomeId=#aGroups.loid# returnVariable='rating'></cfinvoke>
        <cfelse>
        	<cfset rating='n/a'>
        </cfif>
				<cfif aGroups.lo_level eq 'I'>
          <cfset minRating = 1>
        </cfif>
        <cfif aGroups.lo_level eq 'D'>
          <cfset minRating = 2>
        </cfif>
        <cfif aGroups.lo_level eq 'M'>
          <cfset minRating = 3>
        </cfif>
				<cfif rating neq 'n/a' && rating lt minRating>
          <cfset rateStyle='color:##FF0000;font-weight:bold'>
        <cfelse>
          <cfset rateStyle='color:##000000'>
        </cfif>							
        <tr>
          <td><cfif comp gt 0><a href="./index.cfm?action=LOS_Status&major=#major#&p_id=#progQuery.p_id#&term=#groups.agTerm#&groupId=#aGroups.loa_group_id#&outcome=#q_lo.loShortName#" title="Averages by Measure. Click on the Course Section to See Student Scores.">#q_lo.loShortName#</a><cfelse>#q_lo.loShortName#</cfif></td>
          <td>#aGroups.lo_level#</td>
          <td><cfif comp gt 0><a href="./index.cfm?action=LOS_Status&major=#major#&p_id=#progQuery.p_id#&term=#groups.agTerm#&groupId=#aGroups.loa_group_id#" title="#aGroups.instr_lname & ', ' & instr_fname & ' Email:  ' & instr_email#">#aGroups.class#</a>
							<cfelse><a title="#aGroups.instr_lname & ', ' & instr_fname & ' Email:  ' & instr_email#">#aGroups.class#</a>
							</cfif>
          </td>
          <td>#aGroups.enrolled#</td>
          <td>#assessments.count#</td>
          <td>#NumberFormat(comp,'99.99')# %</td>
          <td><cfif rating eq 'n/a'>#rating#<cfelse><span style="#rateStyle#">#NumberFormat(rating,'9.99')#</span></cfif></td>
        </tr>
        <cfif isDefined('groupId') && ! isDefined('outcome') && (groupId eq aGroups.loa_group_id)>
        	<tr>
          <cfinvoke component='script.los' method='getStudentSummaries' groupId=#aGroups.loa_group_id# outcomeId=#aGroups.loid# returnVariable='stuSummaries'></cfinvoke>
            <th colspan="2">&nbsp;</th>
            <th colspan="2">Student</th>
            <th>Date</th>
            <th>Points</th>
            <th>Average</th>
          </tr>
					<cfif aGroups.lo_level eq 'I'>
          	<cfset minScore = 1>
          </cfif>
					<cfif aGroups.lo_level eq 'D'>
          	<cfset minScore = 2>
          </cfif>
					<cfif aGroups.lo_level eq 'M'>
          	<cfset minScore = 3>
          </cfif>
          <cfloop query="stuSummaries">
          	<cfif stuSummaries.average lt minScore>
            	<cfset scoreStyle='color:##FF0000;font-weight:bold'>
            <cfelse>
            	<cfset scoreStyle='color:##000000'>
            </cfif>							
          	<tr>
            	<td colspan="2">&nbsp;</td>
              <td><a href="./index.cfm?action=LOS_SA_Result&assessment=#stuSummaries.loa_id#" target="_blank">#stuSummaries.student_lname#</a>,</td>
              <td>#stuSummaries.student_fname#</td>
              <td>#DateFormat(stuSummaries.loaDate,'yyyy-mm-dd')#</td>
              <td>#stuSummaries.points#</td>
              <td><span style="#scoreStyle#">#Numberformat(stuSummaries.average,'9.99')#</span></td>
            </tr>
          </cfloop>
        </cfif>
        <cfif isDefined('groupId') && isDefined('outcome') && (groupId eq aGroups.loa_group_id)>
          <cfinvoke component='script.los' method='getMeasurementSummaries' groupId=#aGroups.loa_group_id# outcomeId=#aGroups.loid# returnVariable='meaSummaries'></cfinvoke>
					<cfif aGroups.lo_level eq 'I'>
          	<cfset minAvg = 1>
          </cfif>
					<cfif aGroups.lo_level eq 'D'>
          	<cfset minAvg = 2>
          </cfif>
					<cfif aGroups.lo_level eq 'M'>
          	<cfset minAvg = 3>
          </cfif>
        	<tr>
            <th>&nbsp;</th>
            <th>Meas.</th>
            <th colspan="4">Description</th>
            <th>Average</th>
          </tr>
          <cfloop query="meaSummaries">
          	<cfif meaSummaries.average lt minAvg>
            	<cfset textStyle='color:##FF0000;font-weight:bold'>
            <cfelse>
            	<cfset textStyle='color:##000000'>
            </cfif>							
          	<tr>
            	<td>&nbsp;</td>
              <td>#meaSummaries.measureNum#</td>
              <td colspan="4">#meaSummaries.lomDescription#</td>
              <td><span style="#textStyle#">#Numberformat(meaSummaries.average,'9.99')#</span></td>
            </tr>
          </cfloop>
        </cfif>
        	
        </cfloop>
      </table>
    <p>To view individual assessment results at the student level click on the link under the Class column. To view assessment
    averages by measurement activity for any outcome, click on the name of the outcome under the Outcome column.  Moving yoru mouse
    over the course-section number will also provide the instructor name and email address.</p>
    </cfif>
    </cfloop>

    </div>
  </cfif>

  </cfoutput>

	<cfif Action eq 'App_Home_Sys_Down'>
		<cfoutput>
		<p><span style="color:##ff0000; text-decoration:underline;">The #Application.Settings.SiteOwner2# Website is currently down for routine maintenance.  Please try
		back later.  We apologize for the inconvenience.  Please contact <a href="mailto:#Application.Settings.SiteContactEmail#">#Application.Settings.SiteContactName#</a> via email
		with any questions, or call #Application.Settings.SiteContactPhone#.</span><br />Thank You.</p>
		</cfoutput>
	</cfif>

</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">

<!--- PGM Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Program Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_pgm_links.cfm">
		</ul>
	</div>
</div>
<!--- PGM Outcomes NAV END --->

<!--- Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Learning Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_links.cfm">
		</ul>
	</div>
</div>
<!--- Outcomes NAV END --->

</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
