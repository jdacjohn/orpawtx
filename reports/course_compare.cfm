<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="termReports"><em><span>Course Comparison</span></em></h5>
<p>Use the form below to enter a course-name and two terms to compare success, drop, and fail rates. Once
the information has been entered, click on the 'Submit' button.</p>

<cfif isdefined('course')>
	<cfset theCourse = ucase(course)>
<cfelse>
	<cfset theCourse = ''>
</cfif>

<cfif isdefined('firstTerm')>
	<cfset term1 = ucase(firstTerm)>
<cfelse>
	<cfset term1 = ''>
</cfif>

<cfif isdefined('secTerm')>
	<cfset term2 = ucase(secTerm)>
<cfelse>
	<cfset term2 = ''>
</cfif>

<cfif isDefined('loc')>
	<cfset theLoc = loc>
<cfelse>
	<cfset theLoc = 0>
</cfif>

<cfoutput>
<cfform name="termSelForm" id="termSelForm" action="./index.cfm?action=TR_Course_Compare" method="post" format="html">
<cfinvoke component='script.courses' method='getColleges' returnVariable='colleges'></cfinvoke>
<table class="npTable">
	<tr>
  	<th colspan="7">Provide a search value for each field listed below.</th>
  </tr>
  <tr>  	
  	<td colspan="7" style="border: 0px; vertical-align: middle;">College:&nbsp;
    	<cfloop query='colleges'>
    	<input type="radio" name="loc" value="#colleges.lc_id#" <cfif theLoc eq colleges.lc_id> checked </cfif> />#colleges.campus#&nbsp;
      </cfloop>
    </td>
  </tr>
  <tr>
   	<td colspan="7" style="border: 0px; vertical-align: top;">
    	Course Name: <input type="text" name="course" value="#theCourse#"  size="12" maxlength="10" />
    	First Term: <input type="text" name="firstTerm" value="#term1#" size="6" maxlength="5" />
    	Second Term: <input type="text" name="secTerm" value="#term2#" size="6" maxlength="5" />
    </td>
  </tr>
  <tr>
  	<th colspan="6" width="500">&nbsp;</th>
  	<td align="center"><input type="submit" name="submit" value="Submit" /></td>
  </tr>
</table>
</cfform>

<p>
<cfif theCourse neq '' & theLoc neq 0>
	<cfinvoke component='script.courses' method='getCollege' location=#theLoc# returnVariable='college'></cfinvoke>
  <h5 class="termReports"><em><span>Course Pass/Fail Rate Comparison for Class:  #theCourse# - #college#</span></em></h5>
  <cfelse>
  <h5 class="termReports"><em><span>Course Pass/Fail Rate Comparison for Class:  Please enter a class and two different terms above.</span></em></h5>	
</cfif>
<cfif term1 neq '' && theCourse neq ''>
	<h5 class="termReports"><em><span>First Term: #term1#</span></em></h5>
<cfelse>	
	<h5 class="termReports"><em><span>First Term: None Entered</span></em></h5>
</cfif>
<table class="csTable">
  <tr>
    <th>Course</th>
    <th>Title</th>
    <th>Len</th>
    <th>Enr.</th>
    <th>'W'</th>
    <th>Drops</th>
    <th>'F'</th>
    <th>Fails</th>
    <th>Success</th>
  </tr>
  <cfif term1 neq '' && theCourse neq '' && theLoc neq 0>
    <cfinvoke component='script.courses' method='getCourseDropFailRates' term='#ucase(term1)#' course='#ucase(theCourse)#' loc=#theLoc# returnVariable='theCourse1'></cfinvoke>
    <tr>
    	<cfif theCourse1.course neq '-'>
				<cfset dRate = theCourse1.dropped / theCourse1.students>
        <cfif (theCourse1.students - theCourse1.dropped) gt 0>
          <cfset fRate = theCourse1.fails / (theCourse1.students - theCourse1.dropped)>
        <cfelse>
          <cfset fRate = 0>
        </cfif>
        <cfset success = (theCourse1.students - theCourse1.dropped - theCourse1.fails)/theCourse1.students>
        <cfif (dRate gt 0.25) || (fRate gt 0.25) || (success lt 0.75)>
          <cfset flag='Y'>
        <cfelse>
          <cfset flag='N'>
        </cfif>
      <cfelse>
      	<cfset flag='Y'>
        <cfset dRate = 0>
        <cfset fRate = 0>
        <cfset success = 0>
      </cfif>
      <td width="75"><cfif flag eq 'Y'><span style="color:##ff0000;">#theCourse1.course#</span><cfelse>#theCourse1.course#</cfif></td>
      <td><a href="./index.cfm?action=CS_Drilldown&course=#theCourse1.course#&term=#term1#&loc=#theLoc#"><cfif flag eq 'Y'><span style="color:##ff0000;">#theCourse1.course_title#</span><cfelse>#theCourse1.course_title#</cfif></a></td>
      <td><a title="Course Length in Weeks">#theCourse1.course_length#</a></td>
      <td><a title="Students">#theCourse1.students#</a></td>
      <td><a title="Withdraws">#theCourse1.dropped#</a></td>
      <td><cfif dRate gt 0.25><a title="Drop Rate" style="color:##FF0000;">#NumberFormat(dRate * 100,'99.9')#%</a><cfelse><a title="Drop Rate">#NumberFormat(dRate * 100,'99.9')#%</a></cfif></td>
      <td><a title="Fails">#theCourse1.fails#</a></td>
      <td><cfif fRate gt 0.25><a title="Fail Rate" style="color:##FF0000;">#NumberFormat(fRate * 100,'99.9')#%</a><cfelse><a title="Fail Rate">#NumberFormat(fRate * 100,'99.9')#%</a></cfif></td>
      <td><cfif success lt 0.75><a title="Success Rate" style="color:##FF0000;">#NumberFormat(success * 100,'99.9')#%</a><cfelse><a title="Success Rate">#NumberFormat(success * 100,'99.9')#%</a></cfif></td>
    </tr>
  </cfif>
</table>

<cfif term2 neq '' && theCourse neq '' && theLoc neq 0>
	<h5 class="termReports"><em><span>Second Term: #term2#</span></em></h5>
<cfelse>	
	<h5 class="termReports"><em><span>Second Term: None Entered</span></em></h5>
</cfif>
<table class="csTable">
  <tr>
    <th>Course</th>
    <th>Title</th>
    <th>Len</th>
    <th>Enr.</th>
    <th>'W'</th>
    <th>Drops</th>
    <th>'F'</th>
    <th>Fails</th>
    <th>Success</th>
  </tr>
  <cfif term2 neq '' && theCourse neq '' && theLoc neq 0>
    <cfinvoke component='script.courses' method='getCourseDropFailRates' term='#ucase(term2)#' course='#ucase(theCourse)#' loc=#theLoc# returnVariable='theCourse2'></cfinvoke>
    <tr>
    	<cfif theCourse2.course neq '-'>
				<cfset dRate = theCourse2.dropped / theCourse2.students>
        <cfif (theCourse2.students - theCourse2.dropped) gt 0>
          <cfset fRate = theCourse2.fails / (theCourse2.students - theCourse2.dropped)>
        <cfelse>
          <cfset fRate = 0>
        </cfif>
        <cfset success = (theCourse2.students - theCourse2.dropped - theCourse2.fails)/theCourse2.students>
        <cfif (dRate gt 0.25) || (fRate gt 0.25) || (success lt 0.75)>
          <cfset flag='Y'>
        <cfelse>
          <cfset flag='N'>
        </cfif>
      <cfelse>
      	<cfset flag='Y'>
        <cfset dRate = 0>
        <cfset fRate = 0>
        <cfset success = 0>
      </cfif>
      
      <td width="75"><cfif flag eq 'Y'><span style="color:##ff0000;">#theCourse2.course#</span><cfelse>#theCourse2.course#</cfif></td>
      <td><a href="./index.cfm?action=CS_Drilldown&course=#theCourse2.course#&term=#term2#&loc=#theLoc#"><cfif flag eq 'Y'><span style="color:##ff0000;">#theCourse2.course_title#</span><cfelse>#theCourse2.course_title#</cfif></a></td>
      <td><a title="Course Length in Weeks">#theCourse2.course_length#</a></td>
      <td><a title="Students">#theCourse2.students#</a></td>
      <td><a title="Withdraws">#theCourse2.dropped#</a></td>
      <td><cfif dRate gt 0.25><a title="Drop Rate" style="color:##FF0000;">#NumberFormat(dRate * 100,'99.9')#%</a><cfelse><a title="Drop Rate">#NumberFormat(dRate * 100,'99.9')#%</a></cfif></td>
      <td><a title="Fails">#theCourse2.fails#</a></td>
      <td><cfif fRate gt 0.25><a title="Fail Rate" style="color:##FF0000;">#NumberFormat(fRate * 100,'99.9')#%</a><cfelse><a title="Fail Rate">#NumberFormat(fRate * 100,'99.9')#%</a></cfif></td>
      <td><cfif success lt 0.75><a title="Success Rate" style="color:##FF0000;">#NumberFormat(success * 100,'99.9')#%</a><cfelse><a title="Success Rate">#NumberFormat(success * 100,'99.9')#%</a></cfif></td>
    </tr>
  </cfif>
</table>
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
