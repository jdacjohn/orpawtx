<div id="mainBody">
  <!--- MAIN RIGHT ---->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <h5 class="rubricHeading"><em><span>Institutional Retention Calculations: <cfif retspan EQ "fa2fa">Annual Cohorts<cfelse>Semester Cohorts</cfif></span></em></h5>
      <!--- <img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /> --->
		  <table class="retStatsTable" align="left">
    		<tr>
      		<th>&nbsp;</th>
      		<th>Cohort Size*</th>
      		<th>End Term</th>
      		<th>Re-Enrolled</th>
      		<th>Completed</th>
      		<th>Retention</th>
    		</tr>
        <cfloop index="ndx" from="1" to="#ArrayLen(retentionSets)#" step="1">
  			<cfif retentionSets[ndx].location neq "">
  				<tr>
    				<th colspan="6" style="text-align:left; text-indent:5px;"><cfoutput>#retentionSets[ndx].location#</cfoutput></th>
    			</tr>
    		</cfif>
        <cfoutput>
    		<tr>
      		<td>#retentionSets[ndx].startTerm#</td>
      		<td>#retentionSets[ndx].startClassSize#</td>
      		<td>#retentionSets[ndx].endTerm#</td>
      		<td>#retentionSets[ndx].endClassSize#</td>
      		<td>#retentionSets[ndx].completers#</td>
      		<td>%#DecimalFormat(retentionSets[ndx].retained)#</td>
    		</tr>
        </cfoutput>
     		</cfloop>
  			<tr>
    			<td colspan="6" class="retStats" align="left">
			  		* Cohort size is based on the number of first-time, full-time degree-seeking students as defined by the Texas Higher Education Coordinating Board.
      		</td>
    		</tr>
  			<tr>
    			<th colspan="6">Available Filters</th>
    		</tr>
				<form name="cform" method="post" action="index.cfm?action=RTC_Inst_Display"  enctype="multipart/form-data">    		
        <tr>
    			<td colspan="6" align="left">
      			<input type="checkbox" name="dev" <cfif dev eq "on">checked</cfif> /> Developmental Students
      			<input type="checkbox" name="ndev" <cfif ndev eq "on">checked</cfif> /> Non-Developmenal Students
      			<input type="checkbox" name="pt" <cfif pt eq "on">checked</cfif> /> Part-time Students<br />
      		</td>
    		</tr>
    		<tr>
    			<td colspan="6"><input type="button" class="heading3" name="filter" value="Apply Filters" onclick="javascript:cform.submit();"/></td>
    		</tr>
        <!--- Show the Developmental Student retention figures is appropriate --->
        <cfif dev eq "on">
        <tr>
          <th colspan="6">Retention Statistics for Developmental Students</th>
        </tr>
        <tr>
          <th>&nbsp;</th>
          <th>Cohort Size*</th>
          <th>End Term</th>
          <th>Re-enrolled</th>
          <th>Completed</th>
          <th>Retention</th>
        </tr>
        <cfloop index="ndx" from="1" to="#ArrayLen(retentionSetsDev)#" step="1">
        <cfif retentionSetsDev[ndx].location neq "">
        <tr>
          <th colspan="6" style="text-align:left; text-indent:5px;"><cfoutput>#retentionSetsDev[ndx].location#</cfoutput></th>
        </tr>
        </cfif>
        <cfoutput>
        <tr>
          <td>#retentionSetsDev[ndx].startTerm#</td>
      		<td>#retentionSetsDev[ndx].startClassSize#</td>
      		<td>#retentionSetsDev[ndx].endTerm#</td>
      		<td>#retentionSetsDev[ndx].endClassSize#</td>
      		<td>#retentionSetsDev[ndx].completers#</td>
      		<td>%#DecimalFormat(retentionSetsDev[ndx].retained)#</td>
        </tr>
        </cfoutput>
        </cfloop>
        <tr>
          <td colspan="6" class="retStats" align="left">
            * Cohort size is based on the number of first-time, full-time degree-seeking students as defined by the Texas Higher Education Coordinating Board
            who were enrolled in Developmental Education courses during their first semester of college.
          </td>
        </tr>
        </cfif>
        <!--- Show the retention for only Non-developmental students if appropriate --->
        <cfif ndev eq "on">
        <tr>
          <th colspan="6">Retention Statistics for Non-Developmental Students</th>
        </tr>
        <tr>
          <th>&nbsp;</th>
          <th>Cohort Size*</th>
          <th>End Term</th>
          <th>Re-enrolled</th>
          <th>Completed</th>
          <th>Retention</th>
        </tr>
        <cfloop index="ndx" from="1" to="#ArrayLen(retentionSetsNDev)#" step="1">
        <cfif retentionSetsNDev[ndx].location neq "">
        <tr>
          <th colspan="6" style="text-align:left; text-indent:5px;"><cfoutput>#retentionSetsNDev[ndx].location#</cfoutput></th>
        </tr>
        </cfif>
        <cfoutput>
        <tr>
          <td>#retentionSetsNDev[ndx].startTerm#</td>
      		<td>#retentionSetsNDev[ndx].startClassSize#</td>
      		<td>#retentionSetsNDev[ndx].endTerm#</td>
      		<td>#retentionSetsNDev[ndx].endClassSize#</td>
      		<td>#retentionSetsNDev[ndx].completers#</td>
      		<td>%#DecimalFormat(retentionSetsNDev[ndx].retained)#</td>
        </tr>
        </cfoutput>
        </cfloop>
        <tr>
          <td colspan="6" class="retStats" align="left">
            * Cohort size is based on the number of first-time, full-time degree-seeking students as defined by the Texas Higher Education Coordinating Board
            who were not enrolled in Developmental Education courses during their first semester of college.
          </td>
        </tr>
        </cfif>
        <!--- Show the retention figures for part-time students --->
        <cfif pt eq "on">
        <tr>
          <th colspan="6">Retention Statistics for Part-Time Students</th>
        </tr>
        <tr>
          <th>&nbsp;</th>
          <th>Cohort Size*</th>
          <th>End Term</th>
          <th>Re-enrolled</th>
          <th>Completed</th>
          <th>Retention</th>
        </tr>
        <cfloop index="ndx" from="1" to="#ArrayLen(retentionSetsPT)#" step="1">
        <cfif retentionSetsPT[ndx].location neq "">
        <tr>
          <th colspan="6" style="text-align:left; text-indent:5px;"><cfoutput>#retentionSetsPT[ndx].location#</cfoutput></th>
        </tr>
        </cfif>
        <cfoutput>
        <tr>
          <td>#retentionSetsPT[ndx].startTerm#</td>
      		<td>#retentionSetsPT[ndx].startClassSize#</td>
      		<td>#retentionSetsPT[ndx].endTerm#</td>
      		<td>#retentionSetsPT[ndx].endClassSize#</td>
      		<td>#retentionSetsPT[ndx].completers#</td>
      		<td>%#DecimalFormat(retentionSetsPT[ndx].retained)#</td>
        </tr>
        </cfoutput>
        </cfloop>
				<tr>
          <td colspan="6" class="retStats" align="left">
            * Cohort size is based on the number of first-time, part-time degree-seeking students as defined by the Texas Higher Education Coordinating Board.
          </td>
        </tr>
        </cfif>
  		</table>
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
    <div class="leftNavContainer" >
    <h4 class="blue comm">Retention Span</h4>
      <table class="retTable" width="140" cellspacing="0" cellpadding="0" border="0">
      <!--- <form name="cform" method="post" action="index.cfm?action=RTC_Inst_Display"  enctype="multipart/form-data"> --->
        <input type="hidden" name="Action" value="RTC_Inst_Display" />
        <tr><td><input type="radio" name="retspan" id="retspan" value="fa2fa" onClick="javascript:hideList('sm2smList');showList('fa2faList');" <cfif retspan EQ "fa2fa">checked</cfif>/> Fall to Fall</td></tr>
        <tr><td><input type="radio" name="retspan" id="retspan" value="sm2sm" onClick="javascript:hideList('fa2faList');showList('sm2smList');" <cfif retspan EQ "sm2sm">checked</cfif>/> Semester to Semester</td></tr>
        <tr><td><input type="checkbox" name="byloc" <cfif byloc eq "on">checked</cfif> /> Show by Campus</td></tr>
        <tr id="fa2faList" <cfif retspan EQ "sm2sm">style="display: none"</cfif>>
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
        <tr id="sm2smList" <cfif retspan eq "fa2fa">style="display: none"</cfif>>
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
          <td>&nbsp;<input type="button" class="heading3" value="Recalculate" onClick="javascript:cform.submit();" /></td>
        </tr>
      </form>
      </table>      
    </div>
    <!--- IEIR Reports NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
>