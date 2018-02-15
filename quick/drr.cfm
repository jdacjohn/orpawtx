<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<cfset dateToday = DateFormat(Now(),"mm/dd/yyyy")>
<cfif isdefined("term")>
	<cfset reportTerm = term>
<cfelse>
	<cfset reportTerm = Application.Settings.RegTerm>
</cfif>
<cfif isdefined("sequence")>
	<cfset regSeq = sequence>
</cfif>

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<cfif isdefined("regSeq")>
	<cfinvoke component='script.registration' 
  	method='regSummary' 
    regTerm="#reportTerm#" 
    regSeq=#regSeq# 
    returnVariable='regSum'></cfinvoke>
<cfelse>
	<cfinvoke component='script.registration' 
  	method='regSummary' 
    regTerm="#reportTerm#" 
    returnVariable='regSum'></cfinvoke>
</cfif>
<h5 class="rubricHeading"><em><span>Daily Registration</span></em> for <cfoutput>#reportTerm#</cfoutput>
</h5>
<cfoutput>
<table class="drrTable" align="left">
  <tr>
    <th colspan="4" align="left">TSTC West Texas Registered Students - #reportTerm# - as of #DateFormat(regSum.rptDate,'yyyy-mm-dd')#</th>
  </tr>
  <tr>
    <td width='125'>New Students</td>
    <td width='125'>Returning Students</td>
    <td width='125'>Total</td>
    <td width='125'>#regSum.compTerm# Total</td>
  </tr>
  <tr>
    <td>#regSum.new#</td>
    <td>#regSum.ret#</td>
    <td>#regSum.total#</td>
    <td><cfif regSum.comp eq 0><a title="Please contact TSTC West Texas Office of Planning, Research & Analysis to obtain archived Registration Reports">n/a</a><cfelse>#regSum.comp#</cfif></td>
  </tr>
  <tr>
  	<th colspan="4" align="left" style="border:0px"><a onclick="javascript:toggle('locations','.');"><img src="./images/buttons/collapse.png" name="expand_locations" id="expand_locations" width="12" height="12" border="0" valign="bottom"></a> Campus Detail (Does not include Smart Start enrollments listed below)</th>
  </tr>
  <tr id="locations">
  	<td colspan='4'>
    	<table class="drrTable" align="left">
        <tr>
          <td colspan="2" align="left">Location</td>
          <td align="right">New</td>
          <td align="right">Returning</td>
          <td align="right">Total</td>
        </tr>
      <cfset locTotals = regSum.locTotals>
      <cfset ssAndReg = StructNew()>
      <cfset ssAndReg.All = 0>
      <cfloop index="kdx" from="1" to="#ArrayLen(locTotals)#" step="1">
      	<tr>
        	<td width="25">&nbsp;</td>
          <td width="100" align="left">#locTotals[kdx].location#</td>
          <td width="125" align="right">#locTotals[kdx].new#</td>
          <td width="125" align="right">#locTotals[kdx].ret#</td>
          <td width="125" align="right">#locTotals[kdx].total#</td>
        </tr>
        <cfswitch expression="#locTotals[kdx].location#">
        	<cfcase value='Abilene'>
          	<cfset ssAndReg.Abilene = locTotals[kdx].total>
          </cfcase>
          <cfcase value='Breckenridge'>
          	<cfset ssAndReg.Breckenridge = locTotals[kdx].total>
          </cfcase>
          <cfcase value='Brownwood'>
          	<cfset ssAndReg.Brownwood = locTotals[kdx].total>
          </cfcase>
          <cfcase value='Sweetwater'>
          	<cfset ssAndReg.Sweetwater = locTotals[kdx].total>
          </cfcase>
        </cfswitch>
        <cfset ssAndReg.All += locTotals[kdx].total>  
      </cfloop>
      </table>
    </td>
  </tr>
  <tr>
  	<th colspan="4" align="left" style="border:0px"><a onclick="javascript:toggle('smartStart','.');"><img src="./images/buttons/expand.png" name="expand_smartStart" id="expand_smartStart" width="12" height="12" border="0" valign="bottom"></a> Smart Start Enrollments</th>
  </tr>
  <tr id="smartStart" style="display:none">
  	<td colspan='4'>
    	<table class="drrTable" align="left">
        <tr>
          <td colspan="2" align="left">Location</td>
          <td align="right">Enrolled</td>
          <td align="right" colspan="2">Location ALL</td>
        </tr>
 			<cfinvoke component='script.registration' method='getSmartStart' regTerm='#reportTerm#' returnVariable='ssEnrollments'></cfinvoke>
      <cfset newSS=0>
      <cfloop index="ssdx" from="1" to="#ArrayLen(ssEnrollments)#" step="1">
      	<tr>
        	<td width="25">&nbsp;</td>
          <td width="100" align="left">#ssEnrollments[ssdx].campus#</td>
          <td width="125" align="right">#ssEnrollments[ssdx].enrolled#</td>
          <cfswitch expression="#ssEnrollments[ssdx].campus#">	
          	<cfcase value='Abilene'>
          		<td width="125" colspan="2" align="right">#ssAndReg.Abilene + ssEnrollments[ssdx].enrolled#</td>
            </cfcase>
          	<cfcase value='Breckenridge'>
          		<td width="125" colspan="2"  align="right">#ssAndReg.Breckenridge + ssEnrollments[ssdx].enrolled#</td>
            </cfcase>
          	<cfcase value='Brownwood'>
          		<td width="125" colspan="2"  align="right">#ssAndReg.Brownwood + ssEnrollments[ssdx].enrolled#</td>
            </cfcase>
          	<cfcase value='Sweetwater'>
          		<td width="125" colspan="2"  align="right">#ssAndReg.Sweetwater + ssEnrollments[ssdx].enrolled#</td>
            </cfcase>
          </cfswitch>
        </tr>
        <cfset newSS += ssEnrollments[ssdx].enrolled>
      </cfloop>
      <tr>
        <td width="125" colspan="2" align="left" style="border-top: 1px solid">TSTC West Texas</td>
        <td width="125" align="right" style="border-top: 1px solid">#newSS#</td>
        <td width="125" colspan="2"  align="right" style="border-top: 1px solid"><b>#ssAndReg.All + newSS#</b></td>
      </tr>
      </table>
    </td>
  </tr>
  
</cfoutput>
<!--- <cfoutput>RegSum.seq = #regSum.seq#<br /></cfoutput> --->
<cfinvoke component='script.registration' 
	method='regDetail' 
  regSequence=#regSum.seq# 
  regTerm="#reportTerm#" 
  returnVariable='regData'></cfinvoke>
  <tr>
    <th colspan="4" align="left"><a onclick="javascript:toggle('programs','.');"><img src="./images/buttons/expand.png" name="expand_programs" id="expand_programs" width="12" height="12" border="0" valign="bottom"></a> Program Detail</th>
  </tr>
	<tr id="programs" style="display:none">	
  	<td colspan="4">
    	<table class="drrTable" align="left">
        <tr>
          <td width='125'>Program</td>
          <td width='125' align='right'>New</td>
          <td width='125' align='right'>Returning</td>
          <td width='125' align='right'>Total</td>
        </tr>
        <cfoutput>
        <cfloop index="ndx" from="1" to="#ArrayLen(regData) - 1#" step="1">
        <tr>
          <td><a onclick="javascript:toggle('#regData[ndx].program#','.');"><img src="./images/buttons/expand.png" name="expand_#regData[ndx].program#" id="expand_#regData[ndx].program#" width="12" height="12" border="0" valign="bottom"></a> #regData[ndx].program#</td>
          <td align='right'>#regData[ndx].new#</td>
          <td align='right'>#regData[ndx].ret#</td>
          <td align='right'>#regData[ndx].total#</td>
        </tr>
        <tr id="#regData[ndx].program#" style="display:none">
          <td colspan='4'>
            <table class="drrTable" align="left">
            <cfset locData = regData[ndx].locSpec>
            <cfloop index="jdx" from="1" to="#ArrayLen(locData)#" step="1">
              <tr>
                <td width="25">&nbsp;</td>
                <td width="100" align="left">#locData[jdx].location#</td>
                <td width="125" align="right">#locData[jdx].new#</td>
                <td width="125" align="right">#locData[jdx].ret#</td>
                <td width="125" align="right">#locData[jdx].total#</td>
              </tr>
            </cfloop>
            </table>
          </td>
        </tr>
        </cfloop>
				</cfoutput>
        <tr>
          <td style="border-top: 1px solid"><cfoutput>#regData[ArrayLen(regData)].program#</cfoutput></td>
          <td style="border-top: 1px solid" align='right'><cfoutput>#regData[ArrayLen(regData)].new#</cfoutput></td>
          <td style="border-top: 1px solid" align='right'><cfoutput>#regData[ArrayLen(regData)].ret#</cfoutput></td>
          <td style="border-top: 1px solid" align='right'><cfoutput>#regData[ArrayLen(regData)].total#</cfoutput></td>
        </tr>
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
		<ul><cfinclude template="./reg_cal.cfm"></ul>
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
