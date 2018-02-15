<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Program Retention & Completion by Student Demographics</span></em></h5>
<p>Reports available on this page indicate enrollments, retention, and completion rates for individual programs
at specific locations for the 5 most recent academic years.  These rates are initially broken down between two groups
of new students:  Those who meet the Texas Success Initiative (TSI) requirements in general academic education,
and those who do not.  Please use the form below to select a TSTC West Texas campus location and a program of study.
</p>
<cfinvoke component='script.programs' method='getPrograms' returnvariable='activeMajors'></cfinvoke>
<cfif isdefined('progSel')>
	<cfset theProg = progSel>
<cfelse>
	<cfset theProg = ''>
</cfif>
<cfif isdefined('locSel')>
	<cfset theLoc = locSel>
<cfelse>
	<cfset theLoc = ''>
</cfif>

<cfoutput>
<cfform name="progSelForm" id="progSelForm" action="./index.cfm?action=Reports_CoreInd_Breakdown" method="post" format="html">
<table class="npTable">
	<tr>
  	<th width="130">Locations</th>
    <th>Academic Programs</th>
  </tr>
  <tr>
  	<td align="left">
    	<input type="radio" name="locSel" value='460' <cfif theLoc eq "460">checked <cfset campus="Abilene"></cfif> />Abilene<br />
    	<input type="radio" name="locSel" value='480' <cfif theLoc eq "480">checked <cfset campus="Breckenridge"></cfif> />Breckenridge<br />
    	<input type="radio" name="locSel" value='470' <cfif theLoc eq "470">checked <cfset campus="Brownwood"></cfif> />Brownwood<br />
    	<input type="radio" name="locSel" value='400' <cfif theLoc eq "400">checked <cfset campus="Sweetwater"></cfif> />Sweetwater<br />
<!---    	<input type="radio" name="locSel" value='4' <cfif theLoc eq "4">checked <cfset campus="TSTC West Texas"></cfif> />TSTC West Texas<br /> --->
    </td>
    <td>
    	<cfset count=0>
      <table cellpadding="0" cellspacing="0">
      <tr>
    	<cfloop query='activeMajors'>
      	<td style="border: 0px; vertical-align: top;"><input type="radio" name="progSel" value="#activeMajors.program#" <cfif (activeMajors.program eq theProg)> checked </cfif>  />#activeMajors.program#</td>
        <cfset count += 1>
        <cfif count eq 8>
        	</tr><tr>
          <cfset count=0>
        </cfif>
      </cfloop>
      </tr>
      </table>
    </td>
  </tr>
  <tr><td colspan="2" style="text-align:right;"><cfinput class="npTable" type="submit" name="submit" value="Submit" /></td></tr>
</table>
</cfform>
<p>
<cfif theLoc neq ''>
<cfinvoke component='script.paradigm' method='getLast5YearsAndTerms' returnvariable="years"></cfinvoke>
<h5 class="rubricHeading"><em><span>Location:  #campus# Academic Years: <cfloop query="years">#years.acad_year#&nbsp;</cfloop></span></em></h5>
<cfelse>
<h5 class="rubricHeading"><em><span>Location:  None Selected</span></em></h5>	
</cfif>
The table below shows aggregate statistics for the chosen program and location over a 5-year period.  Statistics are based
on each starting cohort of new students within the selected program at the chosen location.  If you wish to see the actual
numbers behind the percentages, move your mouse over the percentage figure in the table.
<table class="npTable">
	<tr>
  	<th>Major</th>
    <th>&nbsp;</th>
    <th colspan="3">Retention</th>
    <th>&nbsp;</th>
  </tr>
  <tr>
  	<th><cfif isdefined('progSel')>#progSel#<cfelse>-</cfif></th>
    <th>Enrolled</th>
    <th>2 Terms</th>
    <th>3 Terms</th>
    <th>1 Year</th>
    <th>Completed*</th>
  </tr>
  <cfif ((theLoc neq '') && (theProg neq ''))>
  <cfinvoke component="script.paradigm" method="getParadigmForLocAndProg" location="#locSel#" program="#progSel#" returnvariable="parData"></cfinvoke>
  <tr>
  	<th>TSI-Met</th>
    <td align="center"><a title="#parData.tsi[1]#"><cfif (parData.tsi[1] + parData.nontsi[1]) gt 0>#numberformat(round((parData.tsi[1]/(parData.tsi[1] + parData.nontsi[1])) * 100),'99')#<cfelse>0</cfif>%</a></td>
    <td align="center"><a title="#parData.tsi[2]#"><cfif parData.tsi[1] gt 0>#numberformat(round((parData.tsi[2]/parData.tsi[1]) * 100),'99')#<cfelse>0</cfif>%</a></td>
    <td align="center"><a title="#parData.tsi[3]#"><cfif parData.tsi[1] gt 0>#numberformat(round((parData.tsi[3]/parData.tsi[1]) * 100),'99')#<cfelse>0</cfif>%</a></td>
    <td align="center"><a title="#parData.tsi[4]#"><cfif parData.tsi[1] gt 0>#numberformat(round((parData.tsi[4]/parData.tsi[1]) * 100),'99')#<cfelse>0</cfif>%</a></td>
    <td align="center"><a title="#parData.tsi[5]#"><cfif parData.tsi[1] gt 0>#numberformat(round((parData.tsi[5]/parData.tsi[1]) * 100),'99')#<cfelse>0</cfif>%</a></td>
  </tr>
  <tr>
  	<th>Non-TSI</th>
    <td align="center"><a title="#parData.nontsi[1]#"><cfif (parData.tsi[1] + parData.nontsi[1]) gt 0>#numberformat(round((parData.nontsi[1]/(parData.tsi[1] + parData.nontsi[1])) * 100),'99')#<cfelse>0</cfif>%</a></td>
    <td align="center"><a title="#parData.nontsi[2]#"><cfif parData.nontsi[1] gt 0>#numberformat(round((parData.nontsi[2]/parData.nontsi[1]) * 100),'99')#<cfelse>0</cfif>%</a></td>
    <td align="center"><a title="#parData.nontsi[3]#"><cfif parData.nontsi[1] gt 0>#numberformat(round((parData.nontsi[3]/parData.nontsi[1]) * 100),'99')#<cfelse>0</cfif>%</a></td>
    <td align="center"><a title="#parData.nontsi[4]#"><cfif parData.nontsi[1] gt 0>#numberformat(round((parData.nontsi[4]/parData.nontsi[1]) * 100),'99')#<cfelse>0</cfif>%</a></td>
    <td align="center"><a title="#parData.nontsi[5]#"><cfif parData.nontsi[1] gt 0>#numberformat(round((parData.nontsi[5]/parData.nontsi[1]) * 100),'99')#<cfelse>0</cfif>%</a></td>
  </tr>
  </cfif>  
</table>

</p>
  <cfif ((theLoc neq '') && (theProg neq ''))>
  <cfinvoke component="script.paradigm" method="getZipBreakdowns" location="#locSel#" program="#progSel#" returnvariable="zipBreaks"></cfinvoke>
	<p>The table below indicates new student origiinations base on zip code over the last 5 academic years, broken down by TSI-Met
  and non-TSI-Met students.  In cases where more than 10 distinct zip codes are found for the new students in either group, the
  list of zip codes is limited to the 10 most prevalent student zip codes. Where there are less than 10 zip codes for the entire student
  group, all zip codes are shown.  Click on any zip code in the table to see a demographic break-out of students from that zip
  code.
  <table class="npTable">
    <tr>
      <th colspan="2">TSI Students</th>
      <th colspan="2">Non-TSI Students</th>
    </tr>
    <tr>
      <td colspan="2">
        <table width="250">
          <tr>
            <th width="50%">Zip Code</th>
            <th width="50%">Percentage</th>
          </tr>
        <cfloop query='zipBreaks.tsi.breakouts'>
          <tr>
            <th><a href="./index.cfm?action=Reports_CoreInd_Breakdown&zip=#zipBreaks.tsi.breakouts.zip#&progSel=#theProg#&locSel=#theLoc#">#zipBreaks.tsi.breakouts.zip#</a></th>
            <td><a title="#zipBreaks.tsi.breakouts.students#">#NumberFormat(round((zipBreaks.tsi.breakouts.students/zipBreaks.tsi.students) * 100),'99')#%</a></td>
          </tr>
        </cfloop>
        </table>
      </td>
      <td colspan="2">
        <table width="250">
          <tr>
            <th>Zip Code</th>
            <th>Percentage</th>
          </tr>
        <cfloop query='zipBreaks.nontsi.breakouts'>
          <tr>
            <th><a href="./index.cfm?action=Reports_CoreInd_Breakdown&zip=#zipBreaks.nontsi.breakouts.zip#&progSel=#theProg#&locSel=#theLoc#">#zipBreaks.nontsi.breakouts.zip#</a></th>
            <td><a title="#zipBreaks.nontsi.breakouts.students#">#NumberFormat(round((zipBreaks.nontsi.breakouts.students/zipBreaks.nontsi.students) * 100),'99')#%</a></td>
          </tr>
        </cfloop>
        </table>
      </td>
    </tr>
  </table>
	</p>
	<cfif isDefined('zip')>
  	<cfinvoke component='script.paradigm' method='getZipDemos' location='#locSel#' program='#progSel#' zip='#zip#' returnVariable='zipCode'></cfinvoke>
    <cfset tsiStudents = zipCode.tsi.males.students + zipCode.tsi.females.students>
    <cfset nontsiStudents = zipCode.nonTSI.males.students + zipCode.nonTSI.females.students>
    <p>The table blow shows demographic break-outs for the selected zip code.  Break-outs are show for TSI versus Non-TSI
    students, ratios of Male versus Female students within each of those groups, and age ranges below that, showing what
    portion of students within each age range is economically disadvantaged at the start of the college career.  Predominant
    Age, Gender, and Economic Status groups within each zip code should be readily identifiable from this data assuming that
    sample sizes are adequate.  To view the number of students exist within each demographic breakdown, move your mouse over
    the ratio in the table.<br />
    The age ranges used in the break-out are:<br />
    Under 18<br />
    18 to 20<br/>
    21 to 24<br />
    25 to 29<br />
    30 to 39<br />
    40 and over.<br />
    If no students are represented by a particular age range, that range is omitted from the table.
    
    
    <table class="npTable">
    	<tr>
      	<th colspan="12">Demographics for Zip Code:&nbsp;&nbsp; #zip#</th>
      </tr>
      <tr>
      	<th colspan="4">TSI-Met Students</th>
        <td colspan="2"><a title='#tsiStudents#'>#NumberFormat(round((tsiStudents/(tsiStudents + nontsiStudents)) * 100),'99')#%</a></td>
        <th colspan="4">Non-TSI-Met Students</th>
        <td colspan="2"><a title='#nontsiStudents#'>#NumberFormat(round((nontsiStudents/(tsiStudents + nontsiStudents)) * 100),'99')#%</a></td>
      </tr>
      <tr>
      	<th colspan="2">Female</th>
        <td><a title="#zipcode.tsi.females.students#"><cfif tsiStudents gt 0>#NumberFormat(round((zipCode.tsi.females.students/tsiStudents) * 100), '99')#<cfelse>0</cfif>%</a></td>
      	<th colspan="2">Male</th>
        <td><a title="#zipcode.tsi.males.students#"><cfif tsiStudents gt 0>#NumberFormat(round((zipCode.tsi.males.students/tsiStudents) * 100), '99')#<cfelse>0</cfif>%</a></td>
      	<th colspan="2">Female</th>
        <td><a title="#zipcode.nonTSI.females.students#"><cfif nontsiStudents gt 0>#NumberFormat(round((zipCode.nonTSI.females.students/nontsiStudents) * 100), '99')#<cfelse>0</cfif>%</a></td>
      	<th colspan="2">Male</th>
        <td><a title="#zipcode.nonTSI.males.students#"><cfif nontsiStudents gt 0>#NumberFormat(round((zipCode.nonTSI.males.students/nontsiStudents) * 100), '99')#<cfelse>0</cfif>%</a></td>
      </tr>
      <cfif (zipCode.tsi.females.ages.under18.students + zipCode.tsi.males.ages.under18.students + zipCode.nonTSI.females.ages.under18.students + zipCode.nonTSI.males.ages.under18.students) gt 0>
        <tr>  
          <th colspan="2">Under 18</th>
          <td><a title="#zipcode.tsi.females.ages.under18.students#"><cfif zipCode.tsi.females.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.under18.students/zipCode.tsi.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Under 18</th>
          <td><a title="#zipcode.tsi.males.ages.under18.students#"><cfif zipCode.tsi.males.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.under18.students/zipCode.tsi.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Under 18</th>
          <td><a title="#zipcode.nonTSI.females.ages.under18.students#"><cfif zipCode.nonTSI.females.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.under18.students/zipCode.nonTSI.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Under 18</th>
          <td><a title="#zipcode.nonTSI.males.ages.under18.students#"><cfif zipCode.nonTSI.males.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.under18.students/zipCode.nonTSI.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Disadv</th>
          <td><a title="#zipcode.tsi.females.ages.under18.econDisadv#"><cfif zipCode.tsi.females.ages.under18.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.under18.econDisadv/zipCode.tsi.females.ages.under18.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.tsi.males.ages.under18.econDisadv#"><cfif zipCode.tsi.males.ages.under18.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.under18.econDisadv/zipCode.tsi.males.ages.under18.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.under18.econDisadv#"><cfif zipCode.nonTSI.females.ages.under18.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.under18.econDisadv/zipCode.nonTSI.females.ages.under18.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.under18.econDisadv#"><cfif zipCode.nonTSI.males.ages.under18.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.under18.econDisadv/zipCode.nonTSI.males.ages.under18.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.females.ages.under18.econOK#"><cfif zipCode.tsi.females.ages.under18.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.under18.econOK/zipCode.tsi.females.ages.under18.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.males.ages.under18.econOK#"><cfif zipCode.tsi.males.ages.under18.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.under18.econOK/zipCode.tsi.males.ages.under18.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.under18.econOK#"><cfif zipCode.nonTSI.females.ages.under18.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.under18.econOK/zipCode.nonTSI.females.ages.under18.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.under18.econOK#"><cfif zipCode.nonTSI.males.ages.under18.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.under18.econOK/zipCode.nonTSI.males.ages.under18.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
      </cfif>
      <cfif (zipCode.tsi.females.ages.eighteenTo20.students + zipCode.tsi.males.ages.eighteenTo20.students + zipCode.nonTSI.females.ages.eighteenTo20.students + zipCode.nonTSI.males.ages.eighteenTo20.students) gt 0>
        <tr>  
          <th colspan="2">18 to 20</th>
          <td><a title="#zipcode.tsi.females.ages.eighteenTo20.students#"><cfif zipCode.tsi.females.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.eighteenTo20.students/zipCode.tsi.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">18 to 20</th>
          <td><a title="#zipcode.tsi.males.ages.eighteenTo20.students#"><cfif zipCode.tsi.males.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.eighteenTo20.students/zipCode.tsi.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">18 to 20</th>
          <td><a title="#zipcode.nonTSI.females.ages.eighteenTo20.students#"><cfif zipCode.nonTSI.females.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.eighteenTo20.students/zipCode.nonTSI.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">18 to 20</th>
          <td><a title="#zipcode.nonTSI.males.ages.eighteenTo20.students#"><cfif zipCode.nonTSI.males.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.eighteenTo20.students/zipCode.nonTSI.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Disadv</th>
          <td><a title="#zipcode.tsi.females.ages.eighteenTo20.econDisadv#"><cfif zipCode.tsi.females.ages.eighteenTo20.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.eighteenTo20.econDisadv/zipCode.tsi.females.ages.eighteenTo20.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.tsi.males.ages.eighteenTo20.econDisadv#"><cfif zipCode.tsi.males.ages.eighteenTo20.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.eighteenTo20.econDisadv/zipCode.tsi.males.ages.eighteenTo20.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.eighteenTo20.econDisadv#"><cfif zipCode.nonTSI.females.ages.eighteenTo20.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.eighteenTo20.econDisadv/zipCode.nonTSI.females.ages.eighteenTo20.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.eighteenTo20.econDisadv#"><cfif zipCode.nonTSI.males.ages.eighteenTo20.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.eighteenTo20.econDisadv/zipCode.nonTSI.males.ages.eighteenTo20.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.females.ages.eighteenTo20.econOK#"><cfif zipCode.tsi.females.ages.eighteenTo20.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.eighteenTo20.econOK/zipCode.tsi.females.ages.eighteenTo20.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.males.ages.eighteenTo20.econOK#"><cfif zipCode.tsi.males.ages.eighteenTo20.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.eighteenTo20.econOK/zipCode.tsi.males.ages.eighteenTo20.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.eighteenTo20.econOK#"><cfif zipCode.nonTSI.females.ages.eighteenTo20.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.eighteenTo20.econOK/zipCode.nonTSI.females.ages.eighteenTo20.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.eighteenTo20.econOK#"><cfif zipCode.nonTSI.males.ages.eighteenTo20.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.eighteenTo20.econOK/zipCode.nonTSI.males.ages.eighteenTo20.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
      </cfif>
      <cfif (zipCode.tsi.females.ages.twentyOneTo24.students + zipCode.tsi.males.ages.twentyOneTo24.students + zipCode.nonTSI.females.ages.twentyOneTo24.students + zipCode.nonTSI.males.ages.twentyOneTo24.students) gt 0>
        <tr>  
          <th colspan="2">21 to 24</th>
          <td><a title="#zipcode.tsi.females.ages.twentyOneTo24.students#"><cfif zipCode.tsi.females.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.twentyOneTo24.students/zipCode.tsi.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">21 to 24</th>
          <td><a title="#zipcode.tsi.males.ages.twentyOneTo24.students#"><cfif zipCode.tsi.males.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.twentyOneTo24.students/zipCode.tsi.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">21 to 24</th>
          <td><a title="#zipcode.nonTSI.females.ages.twentyOneTo24.students#"><cfif zipCode.nonTSI.females.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.twentyOneTo24.students/zipCode.nonTSI.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">21 to 24</th>
          <td><a title="#zipcode.nonTSI.males.ages.twentyOneTo24.students#"><cfif zipCode.nonTSI.males.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.twentyOneTo24.students/zipCode.nonTSI.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Disadv</th>
          <td><a title="#zipcode.tsi.females.ages.twentyOneTo24.econDisadv#"><cfif zipCode.tsi.females.ages.twentyOneTo24.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.twentyOneTo24.econDisadv/zipCode.tsi.females.ages.twentyOneTo24.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.tsi.males.ages.twentyOneTo24.econDisadv#"><cfif zipCode.tsi.males.ages.twentyOneTo24.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.twentyOneTo24.econDisadv/zipCode.tsi.males.ages.twentyOneTo24.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.twentyOneTo24.econDisadv#"><cfif zipCode.nonTSI.females.ages.twentyOneTo24.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.twentyOneTo24.econDisadv/zipCode.nonTSI.females.ages.twentyOneTo24.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.twentyOneTo24.econDisadv#"><cfif zipCode.nonTSI.males.ages.twentyOneTo24.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.twentyOneTo24.econDisadv/zipCode.nonTSI.males.ages.twentyOneTo24.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.females.ages.twentyOneTo24.econOK#"><cfif zipCode.tsi.females.ages.twentyOneTo24.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.twentyOneTo24.econOK/zipCode.tsi.females.ages.twentyOneTo24.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.males.ages.twentyOneTo24.econOK#"><cfif zipCode.tsi.males.ages.twentyOneTo24.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.twentyOneTo24.econOK/zipCode.tsi.males.ages.twentyOneTo24.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.twentyOneTo24.econOK#"><cfif zipCode.nonTSI.females.ages.twentyOneTo24.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.twentyOneTo24.econOK/zipCode.nonTSI.females.ages.twentyOneTo24.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.twentyOneTo24.econOK#"><cfif zipCode.nonTSI.males.ages.twentyOneTo24.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.twentyOneTo24.econOK/zipCode.nonTSI.males.ages.twentyOneTo24.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
      </cfif>
      <cfif (zipCode.tsi.females.ages.twentyFiveTo29.students + zipCode.tsi.males.ages.twentyFiveTo29.students + zipCode.nonTSI.females.ages.twentyFiveTo29.students + zipCode.nonTSI.males.ages.twentyFiveTo29.students) gt 0>
        <tr>  
          <th colspan="2">25 to 29</th>
          <td><a title="#zipcode.tsi.females.ages.twentyFiveTo29.students#"><cfif zipCode.tsi.females.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.twentyFiveTo29.students/zipCode.tsi.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">25 to 29</th>
          <td><a title="#zipcode.tsi.males.ages.twentyFiveTo29.students#"><cfif zipCode.tsi.males.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.twentyFiveTo29.students/zipCode.tsi.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">25 to 29</th>
          <td><a title="#zipcode.nonTSI.females.ages.twentyFiveTo29.students#"><cfif zipCode.nonTSI.females.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.twentyFiveTo29.students/zipCode.nonTSI.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">25 to 29</th>
          <td><a title="#zipcode.nonTSI.males.ages.twentyFiveTo29.students#"><cfif zipCode.nonTSI.males.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.twentyFiveTo29.students/zipCode.nonTSI.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Disadv</th>
          <td><a title="#zipcode.tsi.females.ages.twentyFiveTo29.econDisadv#"><cfif zipCode.tsi.females.ages.twentyFiveTo29.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.twentyFiveTo29.econDisadv/zipCode.tsi.females.ages.twentyFiveTo29.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.tsi.males.ages.twentyFiveTo29.econDisadv#"><cfif zipCode.tsi.males.ages.twentyFiveTo29.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.twentyFiveTo29.econDisadv/zipCode.tsi.males.ages.twentyFiveTo29.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.twentyFiveTo29.econDisadv#"><cfif zipCode.nonTSI.females.ages.twentyFiveTo29.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.twentyFiveTo29.econDisadv/zipCode.nonTSI.females.ages.twentyFiveTo29.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.twentyFiveTo29.econDisadv#"><cfif zipCode.nonTSI.males.ages.twentyFiveTo29.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.twentyFiveTo29.econDisadv/zipCode.nonTSI.males.ages.twentyFiveTo29.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.females.ages.twentyFiveTo29.econOK#"><cfif zipCode.tsi.females.ages.twentyFiveTo29.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.twentyFiveTo29.econOK/zipCode.tsi.females.ages.twentyFiveTo29.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.males.ages.twentyFiveTo29.econOK#"><cfif zipCode.tsi.males.ages.twentyFiveTo29.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.twentyFiveTo29.econOK/zipCode.tsi.males.ages.twentyFiveTo29.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.twentyFiveTo29.econOK#"><cfif zipCode.nonTSI.females.ages.twentyFiveTo29.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.twentyFiveTo29.econOK/zipCode.nonTSI.females.ages.twentyFiveTo29.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.twentyFiveTo29.econOK#"><cfif zipCode.nonTSI.males.ages.twentyFiveTo29.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.twentyFiveTo29.econOK/zipCode.nonTSI.males.ages.twentyFiveTo29.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
      </cfif>
      <cfif (zipCode.tsi.females.ages.thirtyTo39.students + zipCode.tsi.males.ages.thirtyTo39.students + zipCode.nonTSI.females.ages.thirtyTo39.students + zipCode.nonTSI.males.ages.thirtyTo39.students) gt 0>
        <tr>  
          <th colspan="2">30 to 39</th>
          <td><a title="#zipcode.tsi.females.ages.thirtyTo39.students#"><cfif zipCode.tsi.females.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.thirtyTo39.students/zipCode.tsi.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">30 to 39</th>
          <td><a title="#zipcode.tsi.males.ages.thirtyTo39.students#"><cfif zipCode.tsi.males.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.thirtyTo39.students/zipCode.tsi.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">30 to 39</th>
          <td><a title="#zipcode.nonTSI.females.ages.thirtyTo39.students#"><cfif zipCode.nonTSI.females.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.thirtyTo39.students/zipCode.nonTSI.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">30 to 39</th>
          <td><a title="#zipcode.nonTSI.males.ages.thirtyTo39.students#"><cfif zipCode.nonTSI.males.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.thirtyTo39.students/zipCode.nonTSI.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Disadv</th>
          <td><a title="#zipcode.tsi.females.ages.thirtyTo39.econDisadv#"><cfif zipCode.tsi.females.ages.thirtyTo39.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.thirtyTo39.econDisadv/zipCode.tsi.females.ages.thirtyTo39.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.tsi.males.ages.thirtyTo39.econDisadv#"><cfif zipCode.tsi.males.ages.thirtyTo39.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.thirtyTo39.econDisadv/zipCode.tsi.males.ages.thirtyTo39.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.thirtyTo39.econDisadv#"><cfif zipCode.nonTSI.females.ages.thirtyTo39.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.thirtyTo39.econDisadv/zipCode.nonTSI.females.ages.thirtyTo39.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.thirtyTo39.econDisadv#"><cfif zipCode.nonTSI.males.ages.thirtyTo39.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.thirtyTo39.econDisadv/zipCode.nonTSI.males.ages.thirtyTo39.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.females.ages.thirtyTo39.econOK#"><cfif zipCode.tsi.females.ages.thirtyTo39.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.thirtyTo39.econOK/zipCode.tsi.females.ages.thirtyTo39.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.males.ages.thirtyTo39.econOK#"><cfif zipCode.tsi.males.ages.thirtyTo39.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.thirtyTo39.econOK/zipCode.tsi.males.ages.thirtyTo39.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.thirtyTo39.econOK#"><cfif zipCode.nonTSI.females.ages.thirtyTo39.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.thirtyTo39.econOK/zipCode.nonTSI.females.ages.thirtyTo39.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.thirtyTo39.econOK#"><cfif zipCode.nonTSI.males.ages.thirtyTo39.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.thirtyTo39.econOK/zipCode.nonTSI.males.ages.thirtyTo39.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
      </cfif>
      <cfif (zipCode.tsi.females.ages.fortyPlus.students + zipCode.tsi.males.ages.fortyPlus.students + zipCode.nonTSI.females.ages.fortyPlus.students + zipCode.nonTSI.males.ages.fortyPlus.students) gt 0>
        <tr>  
          <th colspan="2">40 +</th>
          <td><a title="#zipcode.tsi.females.ages.fortyPlus.students#"><cfif zipCode.tsi.females.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.fortyPlus.students/zipCode.tsi.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">40 +</th>
          <td><a title="#zipcode.tsi.males.ages.fortyPlus.students#"><cfif zipCode.tsi.males.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.fortyPlus.students/zipCode.tsi.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">40 +</th>
          <td><a title="#zipcode.nonTSI.females.ages.fortyPlus.students#"><cfif zipCode.nonTSI.females.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.fortyPlus.students/zipCode.nonTSI.females.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">40 +</th>
          <td><a title="#zipcode.nonTSI.males.ages.fortyPlus.students#"><cfif zipCode.nonTSI.males.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.fortyPlus.students/zipCode.nonTSI.males.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Disadv</th>
          <td><a title="#zipcode.tsi.females.ages.fortyPlus.econDisadv#"><cfif zipCode.tsi.females.ages.fortyPlus.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.fortyPlus.econDisadv/zipCode.tsi.females.ages.fortyPlus.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.tsi.males.ages.fortyPlus.econDisadv#"><cfif zipCode.tsi.males.ages.fortyPlus.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.fortyPlus.econDisadv/zipCode.tsi.males.ages.fortyPlus.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.fortyPlus.econDisadv#"><cfif zipCode.nonTSI.females.ages.fortyPlus.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.fortyPlus.econDisadv/zipCode.nonTSI.females.ages.fortyPlus.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Disadv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.fortyPlus.econDisadv#"><cfif zipCode.nonTSI.males.ages.fortyPlus.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.fortyPlus.econDisadv/zipCode.nonTSI.males.ages.fortyPlus.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
        <tr> 
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.females.ages.fortyPlus.econOK#"><cfif zipCode.tsi.females.ages.fortyPlus.students gt 0>#NumberFormat(round((zipCode.tsi.females.ages.fortyPlus.econOK/zipCode.tsi.females.ages.fortyPlus.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.tsi.males.ages.fortyPlus.econOK#"><cfif zipCode.tsi.males.ages.fortyPlus.students gt 0>#NumberFormat(round((zipCode.tsi.males.ages.fortyPlus.econOK/zipCode.tsi.males.ages.fortyPlus.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.females.ages.fortyPlus.econOK#"><cfif zipCode.nonTSI.females.ages.fortyPlus.students gt 0>#NumberFormat(round((zipCode.nonTSI.females.ages.fortyPlus.econOK/zipCode.nonTSI.females.ages.fortyPlus.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
          <th colspan="2">Econ. Adv.</th>
          <td><a title="#zipcode.nonTSI.males.ages.fortyPlus.econOK#"><cfif zipCode.nonTSI.males.ages.fortyPlus.students gt 0>#NumberFormat(round((zipCode.nonTSI.males.ages.fortyPlus.econOK/zipCode.nonTSI.males.ages.fortyPlus.students) * 100), '99')#<cfelse>0</cfif>%</a></td>
        </tr>
      </cfif>
    </table>
    </p>
<!---   	<cfdump var='#zipCode#'> --->
  </cfif>
	
	</cfif>
  
</cfoutput>
</div>

<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p><cfinclude template="../body_links.cfm"></p>
</div>
</div>
<!-- MAIN RIGHT END -->

<div id="mainLeft">
<!-- Indicators NAV -->
<div class="leftNavContainer" >

<h4 class="blue principles">New Paradigm</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./ci_links.cfm"></ul>
	</div>
</div>
<!-- INDICATORS NAV END -->

<!-- COMMUNICATION NAV -->
<div class="leftNavContainer" >

<h4 class="blue comm">IEIR Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./report_links.cfm"></ul>
	</div>
</div>
<!-- COMMUNICATION NAV END -->

</div>
<!-- MAIN BODY END -->
</div>
