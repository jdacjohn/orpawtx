<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<cfoutput>
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<cfinvoke component='script.courses' method='getCollege' location=#loc# returnVariable="college"></cfinvoke>
<h5 class="termReports"><em><span>Course Section Grade Distribution - TSTC #college#</span></em></h5>
<p></p>

<cfset theTerm=''>
<h5 class="termReports"><em><span>#term# Course Pass/Fail Rates for #course#</span></em></h5>

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
  <cfinvoke component='script.courses' method='getCourseDropFailRates' term='#right(term,5)#' course='#course#' loc=#loc# returnVariable='theCourse'></cfinvoke>
  <tr>
    <cfset dRate = theCourse.dropped / theCourse.students>
    <cfif (theCourse.students - theCourse.dropped) gt 0>
      <cfset fRate = theCourse.fails / (theCourse.students - theCourse.dropped)>
    <cfelse>
      <cfset fRate = 0>
    </cfif>
    <cfset success = (theCourse.students - theCourse.dropped - theCourse.fails)/theCourse.students>
    <cfif (dRate gt 0.25) || (fRate gt 0.25) || (success lt 0.75)>
      <cfset flag='Y'>
    <cfelse>
      <cfset flag='N'>
    </cfif>
    
    <td width="75"><cfif flag eq 'Y'><span style="color:##ff0000;">#theCourse.course#</span><cfelse>#theCourse.course#</cfif></td>
    <td><cfif flag eq 'Y'><span style="color:##ff0000;">#theCourse.course_title#</span><cfelse>#theCourse.course_title#</cfif></td>
    <td><a title="Course Length in Weeks">#theCourse.course_length#</a></td>
    <td><a title="Students">#theCourse.students#</a></td>
    <td><a title="Withdraws">#theCourse.dropped#</a></td>
    <td><cfif dRate gt 0.25><a title="Drop Rate" style="color:##FF0000;">#NumberFormat(dRate * 100,'99.9')#%</a><cfelse><a title="Drop Rate">#NumberFormat(dRate * 100,'99.9')#%</a></cfif></td>
    <td><a title="Fails">#theCourse.fails#</a></td>
    <td><cfif fRate gt 0.25><a title="Fail Rate" style="color:##FF0000;">#NumberFormat(fRate * 100,'99.9')#%</a><cfelse><a title="Fail Rate">#NumberFormat(fRate * 100,'99.9')#%</a></cfif></td>
    <td><cfif success lt 0.75><a title="Success Rate" style="color:##FF0000;">#NumberFormat(success * 100,'99.9')#%</a><cfelse><a title="Success Rate">#NumberFormat(success * 100,'99.9')#%</a></cfif></td>
  </tr>
</table>

<h5 class="termReports"><em><span>Sections and Grade Distributions</span></em></h5>

<cfinvoke component="script.courses" method="getGradeDistributions" term='#right(term,5)#' course='#course#' loc=#loc# returnvariable='sections'></cfinvoke>

<table class="csTable">
	<tr>
  	<th>Section</th>
    <th>Instructor</th>
    <th>A's</th>
    <th>B's</th>
    <th>C's</th>
    <th>D's</th>
    <th>F's</th>
    <th>S's</th>
    <th>U's</th>
  </tr>
  <cfloop index="ndx" from="1" to="#ArrayLen(sections)#" step="1">
    <tr>
      <td>#sections[ndx].secNo#</td>
      <td>#sections[ndx].iName#,&nbsp;#sections[ndx].iFName#</td>
      <td><a title="#sections[ndx].As#"><cfif sections[ndx].grades eq 0>0.0<cfelse>#NumberFormat((sections[ndx].As/sections[ndx].grades) * 100,'99.9')#</cfif>%</a></td>
      <td><a title="#sections[ndx].Bs#"><cfif sections[ndx].grades eq 0>0.0<cfelse>#NumberFormat((sections[ndx].Bs/sections[ndx].grades) * 100,'99.9')#</cfif>%</a></td>
      <td><a title="#sections[ndx].Cs#"><cfif sections[ndx].grades eq 0>0.0<cfelse>#NumberFormat((sections[ndx].Cs/sections[ndx].grades) * 100,'99.9')#</cfif>%</a></td>
      <td><a title="#sections[ndx].Ds#"><cfif sections[ndx].grades eq 0>0.0<cfelse>#NumberFormat((sections[ndx].Ds/sections[ndx].grades) * 100,'99.9')#</cfif>%</a></td>
      <td><a title="#sections[ndx].Fs#"><cfif sections[ndx].grades eq 0>0.0<cfelse>#NumberFormat((sections[ndx].Fs/sections[ndx].grades) * 100,'99.9')#</cfif>%</a></td>
      <td><a title="#sections[ndx].Ss#"><cfif sections[ndx].grades eq 0>0.0<cfelse>#NumberFormat((sections[ndx].Ss/sections[ndx].grades) * 100,'99.9')#</cfif>%</a></td>
      <td><a title="#sections[ndx].Us#"><cfif sections[ndx].grades eq 0>0.0<cfelse>#NumberFormat((sections[ndx].Us/sections[ndx].grades) * 100,'99.9')#</cfif>%</a></td>
    </tr>
  </cfloop>
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

<h4 class="blue principles">Class Reports</h4>
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
