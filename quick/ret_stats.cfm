<style type="text/css">
  .yui-tt {
    color: #63698C;
    font-size:110%;
    border: 1px solid #63698C;
    background-color: #7B8294;
		background: url(./images/nav_sub_bg5.png) repeat top;
		padding: 5px;
    width:225px;
		text-align:left;
  }
</style>
<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<cfset dateToday = DateFormat(Now(),"mm/dd/yyyy")>
<!--- Set the term based on input parms if any, or app settings if none. --->
<cfif isdefined("term")>
	<cfset regTerm = term>
<cfelse>
	<cfset regTerm = Application.Settings.RetTerm>
</cfif>

<!--- Get the cohort numbers and the current term --->
<cfquery name="getRegCohort" datasource="ieir_assessment">
  select cohort from year_terms where term = '#"20" & regTerm#'
</cfquery>
<cfset regCohort = getRegCohort.cohort>
<cfset currentCohort = regCohort - 1>
<cfquery name="getCurrentTerm" datasource="ieir_assessment">
  select term from year_terms where cohort = #currentCohort#
</cfquery>
<cfset currentTerm = right(getCurrentTerm.term,5)>

<cfif isdefined("sequence")>
	<cfset regSeq = sequence>
</cfif>


<!--- DEBUGS --->
<!---  <cfoutput>
  	Registration Term = #regTerm# <br />
		Registration Cohort = #regCohort#<br />
    Current Term = #currentTerm#<br />
    Current Cohort = #currentCohort#<br />
  </cfoutput> --->
<!--- END DEBUGS --->

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Program Returning Student Registration Progress</span></em> for <cfoutput>#regTerm#</cfoutput></h5>

<cfif isDefined('regSeq')>
	<cfinvoke component='script.registration' method='ret_summary' varTerm="#regTerm#" varSequence=#regSeq# returnVariable='ret_lines'></cfinvoke>
<cfelse>
	<cfinvoke component='script.registration' method='ret_summary' varTerm="#regTerm#" returnVariable='ret_lines'></cfinvoke>
</cfif>
<cfset sumPrev = 0>
<cfset sumGrads = 0>
<cfset sumWDs = 0>
<cfset sumReadmits = 0>
<cfset sumReturners = 0>
<cfset sumRetInPrev = 0>
<cfloop query="ret_lines">
	<cfset sumPrev += ret_lines.prev_reg>
  <cfset sumGrads += ret_lines.grads>
  <cfset sumWDs += ret_lines.wds>
  <cfset sumReadmits += ret_lines.readmits>
  <cfset sumReturners += ret_lines.returners>
  <cfset sumRetInPrev += ret_lines.ret_in_prev>
</cfloop>
<cfoutput>
<table class="drrTable" align="left">
  <tr>
    <th colspan="8" align="left">TSTC West Texas Current Student Registration Progress as of #dateToday#</th>
  </tr>
  <tr>
    <td>#currentTerm#</td>
    <td>Grad</td>
    <td>&nbsp;</td>
    <td>#regTerm#</td>
    <td>&nbsp;</td>
    <td>Total</td>
    <td>Current</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><a href="##" title="Students in the current term.">Reg</a></td>
    <td><a href="##" title="Anticipated graduates this term.">Apps</a></td>
    <td><a href="##" title="Students who have withdrawn this term">W/D</a></td>
    <td><a href="##" title="Re-admits (students who have been out for 2 or more terms)">Readmits</a></td>
    <td><a href="##" title="Current students less Grads, W/Ds, and Re-admits.">Goal</a></td>
    <td><a href="##" title="Returning students including previous students.">Returners</a></td>
    <td><a href="##" title="Current students registered for upcoming term.">Returners</a></td>
    <td><a href="##" title="Current students registered for new term / Goal">Progress</a></td>
  </tr>
  <tr>
    <td>#sumPrev#</td>
    <td>#sumGrads#</td>
    <td>#sumWDs#</td>
    <td>#sumReadmits#</td>
    <td>#sumPrev - sumGrads - sumWDs#</td>
    <td>#sumReturners#</td>
    <td>#sumRetInPrev#</td>
    
		<cfif (sumPrev - sumGrads - sumWDs) gt 0>
    	<cfset totPct = (sumRetInPrev/(sumPrev - sumGrads - sumWDs))>
    <cfelse>
    	<cfset totPct = 0>
    </cfif>
    
		<cfif totPct LTE 0.5>
      <td><span style='color:##FF0000;'>#NumberFormat((totPct * 100),"___")#%</span></td>
    </cfif>
    <cfif (totPct GT 0.5) && (totPct LTE 0.75)>
      <td><span style='color:##FFA800;'>#NumberFormat((totPct * 100),"___")#%</span></td>
    </cfif>
    <cfif totPct GT 0.75>
      <td><span style='color:##0000CC;'>#NumberFormat((totPct * 100),"___")#%</span></td>
    </cfif>
  </tr>
	<tr>
  	<th colspan="8" align="left" style="border:0px"><a onclick="javascript:toggle('locations','.');"><img src="./images/buttons/collapse.png" name="expand_locations" id="expand_locations" width="12" height="12" border="0" valign="bottom"></a> Campus Detail</th>
  </tr>
  <tr id="locations">
  	<td colspan='8'>
    	<table class="drrTable" align="left" style="border: 0px;">
        <tr>
          <td align="left" width="80">&nbsp;</td>
          <td align="left" width="40">#currentTerm#</td>
          <td align="left" width="40">Grad</td>
          <td align="left" width="40">&nbsp;</td>
          <td align="left" width="60">#regTerm#</td>
          <td align="left" width="70">&nbsp;</td>
          <td align="left" width="70">Total</td>
          <td align="left" width="70">Current</td>
          <td align="left" width="70">&nbsp;</td>
        </tr>
        <tr>
          <td align="left" width="80"><span style="text-decoration:underline">Location</span></td>
          <td align="left" width="40"><span style="text-decoration:underline"><a href="##" title="Students in the current term.">Reg</a></span></td>
          <td align="left" width="40"><span style="text-decoration:underline"><a href="##" title="Anticipated graduates this term.">Apps</a></span></td>
          <td align="left" width="40"><span style="text-decoration:underline"><a href="##" title="Students who have withdrawn this term">W/D</a></span></td>
          <td align="left" width="60"><span style="text-decoration:underline"><a href="##" title="Re-admits (students who have been out for 2 or more terms)">Readmits</a></span></td>
          <td align="left" width="70"><span style="text-decoration:underline"><a href="##" title="Current students less Grads, W/Ds, and Re-admits.">Goal</a></span></td>
          <td align="left" width="70"><span style="text-decoration:underline"><a href="##" title="Returning students including previous students.">Returners</a></span></td>
          <td align="left" width="70"><span style="text-decoration:underline"><a href="##" title="Current students registered for upcoming term.">Returners</a></span></td>
          <td align="left" width="70"><span style="text-decoration:underline"><a href="##" title="Current students registered for new term / Goal">Progress</a></span></td>
        </tr>
				<cfloop query="ret_lines">
        <cfquery name="getLoc" datasource="ieir_assessment">
          select campus from locations where lc_id = #ret_lines.loc#
        </cfquery>
        <cfset thisGoal = ret_lines.prev_reg - ret_lines.grads - ret_lines.wds>
        <cfif thisGoal GT 0>
	        <cfset thisPct = (ret_lines.ret_in_prev/thisGoal)>
        <cfelse>
        	<cfset thisPct = 1.00>
        </cfif>
      	<tr>
          <td align="left" width="80">#getLoc.campus#</td>
          <td align="center" width="40">#ret_lines.prev_reg#</td>
          <td align="center" width="40">#ret_lines.grads#</td>
          <td align="center" width="40">#ret_lines.wds#</td>
          <td align="center" width="60">#ret_lines.readmits#</td>
          <td align="center" width="70">#thisGoal#</td>
          <td align="center" width="70">#ret_lines.returners#</td>
          <td align="center" width="70">#ret_lines.ret_in_prev#</td>
					<cfif thisPct LTE 0.5>
            <td align="right" width="70"><span style='color:##FF0000;'>#NumberFormat((thisPct * 100),"___")#%</span></td>
          </cfif>
          <cfif (thisPct GT 0.5) && (thisPct LTE 0.75)>
            <td align="right" width="70"><span style='color:##FFA800;'>#NumberFormat((thisPct * 100),"___")#%</span></td>
          </cfif>
          <cfif thisPct GT 0.75>
            <td align="right" width="70"><span style='color:##0000CC;'>#NumberFormat((thisPct * 100),"___")#%</span></td>
          </cfif>
        </tr>
      </cfloop>
      </table>
    </td>
  </tr>
  
</cfoutput>

<cfif isDefined('regSeq')>
	<cfinvoke component='script.registration' method='getRetStats' varTerm="#regTerm#" varSequence=#regSeq# returnVariable='retStats'></cfinvoke>
<cfelse>
	<cfinvoke component='script.registration' method='getRetStats' varTerm="#regTerm#" returnVariable='retStats'></cfinvoke>
</cfif>
  <tr>
    <th colspan="9" align="left"><a onclick="javascript:toggle('programs','.');"><img src="./images/buttons/expand.png" name="expand_programs" id="expand_programs" width="12" height="12" border="0" valign="bottom"></a> Program Detail</th>
  </tr>
	<tr id="programs">	
  	<td colspan="9">
    	<table class="drrTable" align="left" style="border: 0px;">
        <tr>
          <td align="left" width="110"><span style="text-decoration:underline">Major</span></td>
          <td align="left" width="40"><span style="text-decoration:underline"><a href="#" title="Students in the current term.">Reg</a></span></td>
          <td align="left" width="40"><span style="text-decoration:underline"><a href="#" title="Anticipated graduates this term.">Grads</a></span></td>
          <td align="left" width="40"><span style="text-decoration:underline"><a href="#" title="Students who have withdrawn this term">W/D</a></span></td>
          <td align="left" width="60"><span style="text-decoration:underline"><a href="#" title="Re-admits (students who have been out for 2 or more terms)">Readmits</a></span></td>
          <td align="left" width="60"><span style="text-decoration:underline"><a href="#" title="Current students less Grads, W/Ds, and Re-admits.">Goal</a></span></td>
          <td align="left" width="60"><span style="text-decoration:underline"><a href="#" title="Returning students including previous students.">Total Returners</a></span></td>
          <td align="left" width="60"><span style="text-decoration:underline"><a href="#" title="Current students registered for upcoming term.">Current Returners</a></span></td>
          <td align="left" width="70"><span style="text-decoration:underline"><a href="#" title="Current students registered for new term / Goal">Progress</a></span></td>
        </tr>
        <cfoutput>
        <cfloop index="ndx" from="1" to="#ArrayLen(retStats)#" step="1">
        <cfset goal = retStats[ndx].prev - retStats[ndx].grads - retStats[ndx].wds>
        <cfif goal gt 0>
        	<cfset pct = (retStats[ndx].ret_in_prev/goal)>
        <cfelse>
        	<cfset pct = 1.00>
        </cfif>
        <tr>
          <td align="left" width="110"><a onclick="javascript:toggle('#retStats[ndx].major#','.');"><img src="./images/buttons/expand.png" name="expand_#retStats[ndx].major#" id="expand_#retStats[ndx].major#" width="12" height="12" border="0" valign="bottom"></a> #retStats[ndx].major#</td>
          <td align='center' width="40">#retStats[ndx].prev#</td>
          <td align='center' width="40">#retStats[ndx].grads#</td>
          <td align='center' width="40">#retStats[ndx].wds#</td>
          <td align='center' width="60">#retStats[ndx].readmits#</td>
          <td align='center' width="60">#goal#</td>
          <td align='center' width="60">#retStats[ndx].returners#</td>
          <td align='center' width="60">#retStats[ndx].ret_in_prev#</td>
					<cfif pct LTE 0.5>
	          <td align='right' width="70"><span style='color:##FF0000;'>#NumberFormat((pct * 100),"___")#%</span></td>
          </cfif>
          <cfif (pct GT 0.5) && (pct LTE 0.75)>
	          <td align='right' width="70"><span style='color:##FFA800;'>#NumberFormat((pct * 100),"___")#%</span></td>
          </cfif>
          <cfif pct GT 0.75>
	          <td align='right' width="70"><span style='color:##0000CC;'>#NumberFormat((pct * 100),"___")#%</span></td>
          </cfif>
        </tr>
        <tr id="#retStats[ndx].major#" style="display:none">
          <td colspan='9'>
            <table class="drrTable" align="left">
            <cfset locData = retStats[ndx].locSpec>
            <cfloop index="jdx" from="1" to="#ArrayLen(locData)#" step="1">
            <cfset locGoal = locData[jdx].prev - locData[jdx].grads - locData[jdx].wds>
            <cfif locGoal GT 0>
            	<cfset locPct = (locData[jdx].ret_in_prev/locGoal)>
            <cfelse>
            	<cfset locPct = 1.00>
            </cfif>
              <tr>
                <td align="left" width="95">#locData[jdx].campus#</td>
                <td align="center" width="40">#locData[jdx].prev#</td>
                <td align="center" width="40">#locData[jdx].grads#</td>
                <td align="center" width="40">#locData[jdx].wds#</td>
                <td align="center" width="60">#locData[jdx].readmits#</td>
                <td align='center' width="60">
                <cfif ArrayLen(locData[jdx].chasem) GT 0>
									<cfset outstanding = "*The following students have not yet <br />registered for next term:   <a href='./index.cfm?action=QL_RetStats_Prt&major=#retStats[ndx].major#&loc=#locData[jdx].loc#' target='_blank'>Print</a><br /><hr width='225' /><br />">
                  <cfloop index="kdx" from="1" to="#ArrayLen(locData[jdx].chasem)#" step="1">
                    <cfset outstanding = outstanding & "<span style='text-decoration:underline'>#locData[jdx].chasem[kdx].lname#, #locData[jdx].chasem[kdx].fname#</span><br />">
                  </cfloop>
                  <cfset outstanding = outstanding & "<br /><hr width='225' />*Pending graduating and withdrawn students are NOT included in this list.">
                  <cftooltip
                    <!---autoDismissDelay="10000"--->
                    hideDelay="10000"
                    preventOverlap="true"
                    showDelay="200"
                    tooltip="#outstanding#">&nbsp;#locGoal#&nbsp;</cftooltip>
                <cfelse>
                	#locGoal#
                </cfif>
								</td>
                <td align='center' width="60">#locData[jdx].returners#</td>
                <td align='center' width="60">#locData[jdx].ret_in_prev#</td>
								<cfif locPct LTE 0.5>
                  <td align='right' width="70"><span style='color:##FF0000;'>#NumberFormat((locPct * 100),"___")#%</span></td>
                </cfif>
                <cfif ((locPct GT 0.5) && (locPct LTE 0.75))>
                  <td align='right' width="70"><span style='color:##FFA800;'>#NumberFormat((locPct * 100),"___")#%</span></td>
                </cfif>
                <cfif locPct GT 0.75>
                  <td align='right' width="70"><span style='color:##0000CC;'>#NumberFormat((locPct * 100),"___")#%</span></td>
                </cfif>
              </tr>
            </cfloop>
            </table>
          </td>
        </tr>
        </cfloop>
				</cfoutput>
      </table>
    </td>
  </tr>
</table>

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
		<ul><cfinclude template="./ret_stats_cal.cfm"></ul>
	</div>
</div>
<!-- End term Reports Nav -->
<div class="leftNavContainer" >

<h4 class="blue principles">Previous Terms</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./reg_terms.cfm"></ul>
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
