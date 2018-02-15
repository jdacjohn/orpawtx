<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<cfif isdefined('aySel')>
	<cfset theAY = aySel>
<cfelse>
	<cfset theAY = ''>
</cfif>
<cfif isDefined('majorSel')>
	<cfset theMajor = ucase(majorSel)>
<cfelse>
	<cfset theMajor = ''>
</cfif>

<cfif isdefined('loc')>
	<cfset theLoc = loc>
<cfelse>
	<cfset theLoc = 0>
</cfif>

<cfoutput>

<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<cfif theLoc neq 0>
	<cfinvoke component='script.courses' method='getCollege' location=#theLoc# returnVariable='college'></cfinvoke>
	<h5 class="termReports"><em><span>Annual Course Success Rates - #college#</span></em></h5>
<cfelse>
	<h5 class="termReports"><em><span>Annual Course Success Rates</span></em></h5>
</cfif>
<p>This form is to be used for the creation of a report that will reflect the annual success rate of courses
taught within an instructional program.  To create the report, begin by selecting a TSTC College and an academic year and enter
you program mnemonic.</p>

<cfif isDefined('courseAdds') && courseAdds neq ''>
	<cfinvoke component='script.programs' method='addCoursesForMajor' major='#theMajor#' location=#theLoc# courses='#courseAdds#'>
</cfif>

<!--- Get the last 5 active year/terms sets and active Colleges --->
<cfinvoke component='script.courses' method='getColleges' returnVariable='colleges'></cfinvoke>
<cfinvoke component='script.terms' method='getLast5YearsAndTerms' returnvariable='yts'></cfinvoke>
<cfform name="termSelForm" id="termSelForm" action="./index.cfm?action=TR_Prog_Success" method="post" format="html">
<table class="npTable">
	<tr>
  	<th colspan="5">Select a College</th>
  </tr>
  <tr>
  	<td colspan="5" style="border: 0px; vertical-align: middle;">
    	<cfloop query='colleges'>
    	<input type="radio" name="loc" value="#colleges.lc_id#" <cfif theLoc eq colleges.lc_id> checked </cfif> />#colleges.campus#&nbsp;
      </cfloop>
    </td>
  </tr>
	<tr>
  	<th colspan="5">Select an Academic Year for the Report</th>
  </tr>
  <tr>
  <cfloop query='yts'>
   	<td style="border: 0px; vertical-align: top;" width="100"><input type="radio" name="aySel"  value='#yts.terms#' <cfif theAY eq #yts.terms#> checked </cfif> />#yts.acad_year#</td>
  </cfloop>
  </tr>
  <tr>
  	<td style="border: 0px;">Major:</td>
  	<td style="border: 0px;"><input type="text" name="majorSel" value="#theMajor#" size="5" maxlength="5"/></td>
    <td colspan="3" style="border: 0px">&nbsp;</td>
  </tr>
  <tr>
  	<th colspan="4" style="border: 0px; vertical-align: top;">&nbsp;</th>
  	<td align="center" style="border: 0px; vertical-align: top;"><input type="submit" name="submit" value="Submit" /></td>
  </tr>
</table>
</cfform>

<!--- Course selection/deletion areas --->
<cfif theAY neq '' && theMajor neq '' && theLoc neq 0>

	<cfif isDefined('courseSel')>
    <cfinvoke component='script.programs' method='deleteCoursesForMajor' major='#theMajor#' courses='#courseSel#' location=#theLoc# returnVariable='result'></cfinvoke>
  </cfif>

	<cfinvoke component='script.programs' method='getCourses' prog='#theMajor#' location=#theLoc# returnvariable='progCourses'></cfinvoke>
	<cfset classString='('>
  <!--- Create an 'in clause' to use in report generation --->
  <cfloop query="progCourses">
  	<cfset classString = classString & '"' & '#progCourses.course#' & '",'>
  </cfloop>
  <!--- Remove the last offending comma and close out the clause --->
  <cfif classString neq '('>
	  <cfset classString = left(classString,len(classString) - 1) & ')'>
  <cfelse>
  	<cfset classString = '()'>
  </cfif>
  
	<cfform name="courseEdit" id="termSelForm" action="./index.cfm?action=TR_Prog_Success" method="post" format="html">
	<table class="npTable">
		<cfif progCourses.RecordCount gt 0>
      <tr>
        <th colspan="5" align="left">Courses Associated with this Major are shown Here.</th>
      </tr>
    <cfelse>
      <tr>
        <th colspan="5">There are no courses associated with this Major at this time.</th>
      </tr>
    </cfif>
		<cfset count=0>
    <tr>
    <cfloop query='progCourses'>  	
      <td style="border: 0px; vertical-align: top;">
        <input type="checkbox" name='courseSel' value='#progCourses.course#' />#progCourses.course#
      </td>
      <cfset count += 1>
      <cfif count eq 5>
        </tr><tr>
        <cfset count=0>
      </cfif>
    </cfloop>
    </tr>
    <cfif progCourses.RecordCount gt 0>
      <tr>
        <th colspan="4" width="500"> <span style="text-decoration:underline">Select</span> courses to remove, if desired.
        	<input type="hidden" name='aySel' value='#theAY#' />
          <input type="hidden" name="majorSel" value='#theMajor#' />
          <input type="hidden" name="loc" value="#theLoc#" />
        </th>
        <td align="center"><input type="submit" name="submit" value="Delete Selected" /></td>
      </tr>
    </cfif>
 	</table>
	</cfform>

	<cfif isdefined('courseM')>
  	<cfset mnemonic = ucase(courseM)>
  <cfelse>
  	<cfset mnemonic = ''>
  </cfif>

  <cfform name="courseAdd" id="courseAdd" action="./index.cfm?action=TR_Prog_Success" method="post" format="html">
  <table class="npTable">
    <tr>
      <th colspan="7">Add Courses by Entering a Course Rubric. (i.e., DFTG, MATH, etc)</th>
    </tr>
    <tr>
      <td colspan="7" style="border: 0px; vertical-align: top;">
        Course Mnemonic: <input type="text" name="courseM" value="#mnemonic#"  size="12" maxlength="10" />
      </td>
    </tr>
    <tr>
      <th colspan="6" width="500">
        	<input type="hidden" name='aySel' value='#theAY#' />
          <input type="hidden" name="majorSel" value='#theMajor#' />
          <input type="hidden" name="loc" value="#theLoc#" />
      </th>
      <td align="center"><input type="submit" name="submit" value="Find" /></td>
    </tr>
  </table>
  </cfform>
	
  <!--- Get a list of all courses that match the mnemonic from the selected AY. --->
	<cfif mnemonic neq ''>
  	<cfset termInClause = '(' & theAY & ')'>
  	<cfinvoke component='script.courses' method='findCoursesForTerms' mnemonic='#mnemonic#' terms='#termInClause#' exclude='#classString#' returnvariable="coursesFound"></cfinvoke>

    <cfform name="courseAdd" id="courseAdd" action="./index.cfm?action=TR_Prog_Success" method="post" format="html">
    <table class="npTable">
      <cfif coursesFound.RecordCount gt 0>
        <tr>
          <th colspan="5" align="left">Courses Associated with this Major Taught in the Selected AY.</th>
        </tr>
      <cfelse>
        <tr>
          <th colspan="5">There were no courses associated with this Major taught in the Selected AY.</th>
        </tr>
      </cfif>
      <cfset count=0>
      <tr>
      <cfloop query='coursesFound'>  	
        <td style="border: 0px; vertical-align: top;">
          <input type="checkbox" name='courseAdds' value='#coursesFound.class#' />#coursesFound.class#
        </td>
        <cfset count += 1>
        <cfif count eq 5>
          </tr><tr>
          <cfset count=0>
        </cfif>
      </cfloop>
      </tr>
      <cfif coursesFound.RecordCount gt 0>
        <tr>
          <th colspan="4" width="500"> <span style="text-decoration:underline">Add</span> courses from your list by selecting them and pressing 'Add'
            <input type="hidden" name='aySel' value='#theAY#' />
            <input type="hidden" name="majorSel" value='#theMajor#' />
          	<input type="hidden" name="loc" value="#theLoc#" />
          </th>
          <td align="center"><input type="submit" name="submit" value="Add Selected" /></td>
        </tr>
      </cfif>
    </table>
    </cfform>

  </cfif> 

  <cfform name="runReport" id="courseAdd" action="./index.cfm?action=TR_Prog_Success_Run" method="post" format="html">
  <table class="npTable">
    <tr>
      <th colspan="4" width="500"> <span style="text-decoration:underline">Run the Report</span>
        <input type="hidden" name='aySel' value='#theAY#' />
        <input type="hidden" name="majorSel" value='#theMajor#' />
        <input type="hidden" name="classes" value='#classString#' />
        <input type="hidden" name="loc" value="#theLoc#" />
      </th>
      <td align="center"><input type="submit" name="submit" value="Run Report" /></td>
    </tr>
  </table>
  </cfform>

</cfif>
</cfoutput>

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
<!-- Class Reports NAV -->
<div class="leftNavContainer" >

<h4 class="blue principles">Course Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./term_cs_links.cfm"></ul>
	</div>
</div>
<!-- Class Reports NAV END -->

<!-- Term Reports NAV -->
<div class="leftNavContainer" >

<h4 class="blue principles">Term Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./term_reports_links.cfm"></ul>
	</div>
</div>
<!-- Term Reports NAV END -->

<!-- IEIR Reports Home NAV -->
<div class="leftNavContainer" >

<h4 class="blue comm">IEIR Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./report_links.cfm"></ul>
	</div>
</div>
<!-- IEIR Reports Home NAV END -->

</div>
<!-- MAIN BODY END -->
</div>
