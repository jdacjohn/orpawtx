<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<cfoutput>
<cfinvoke component='script.courses' method='getCollege' location=#loc# returnVariable='college'></cfinvoke>
<h5 class="termReports"><em><span>Program Review Course Success Rates - TSTC #college#</span></em></h5>
<p>For the purposes of these reports, "Course Success" indicates the ratio of students who successfully 
complete a course.  The ratios for drop rates, fail rates, and success rates are based on the number of
students initially registered in a class, the number of students who withdrew from the class, and the number
of students who did not drop, but failed the class. Failure rates are based on the number of students who did
not withdraw from the class but completed with a final verified grade lower than C.<br />
The reports is sorted in order of the course name.  Drop rates and fail rates above
25% are indicated in <span style="color:##FF0000;font-weight:bold;">bold</span> as are success rates below 75%.</p>



<cfinvoke component='script.terms' method='getAcadYear' terms='#aySel#' returnvariable='theYear'></cfinvoke>
<p>
<cfif theYear neq ''>
<h5 class="termReports"><em><span>Selected #majorSel# Course Pass/Fail Rates for AY:  #theYear#</span></em></h5>
<cfelse>
<h5 class="rubricHeading"><em><span>Course Pass/Fail Rates for Term:  No Term Selected</span></em></h5>	
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
  <cfif theYear neq ''>
  	<cfinvoke component='script.courses' method='getProgramDropFailRates' terms='#aySel#' classes='#classes#' location=#loc# returnVariable='courses'></cfinvoke>
    <cfloop query="courses">
    <tr>
      <cfset dRate = courses.dropped / courses.students>
      <cfif (courses.students - courses.dropped) gt 0>
      	<cfset fRate = courses.fails / (courses.students - courses.dropped)>
      <cfelse>
      	<cfset fRate = 0>
      </cfif>
      <cfset success = (courses.students - courses.dropped - courses.fails)/courses.students>
			<cfif (dRate gt 0.25) || (fRate gt 0.25) || (success lt 0.75)>
      	<cfset flag='Y'>
      <cfelse>
      	<cfset flag='N'>
      </cfif>
      
    	<td width="75"><a href='./index.cfm?action=CS_Drilldown_Prog&course=#courses.course#&term=#aySel#&loc=#loc#'><cfif flag eq 'Y'><span style="color:##ff0000;">#courses.course#</span><cfelse>#courses.course#</cfif></a></td>
    	<td><cfif flag eq 'Y'><span style="color:##ff0000;">#courses.course_title#</span><cfelse>#courses.course_title#</cfif></td>
    	<td><a title="Course Length in Weeks">#courses.course_length#</a></td>
    	<td><a title="Students">#courses.students#</a></td>
    	<td><a title="Withdraws">#courses.dropped#</a></td>
    	<td><cfif dRate gt 0.25><a title="Drop Rate" style="color:##FF0000;">#NumberFormat(dRate * 100,'99.9')#%</a><cfelse><a title="Drop Rate">#NumberFormat(dRate * 100,'99.9')#%</a></cfif></td>
    	<td><a title="Fails">#courses.fails#</a></td>
    	<td><cfif fRate gt 0.25><a title="Fail Rate" style="color:##FF0000;">#NumberFormat(fRate * 100,'99.9')#%</a><cfelse><a title="Fail Rate">#NumberFormat(fRate * 100,'99.9')#%</a></cfif></td>
    	<td><cfif success lt 0.75><a title="Success Rate" style="color:##FF0000;">#NumberFormat(success * 100,'99.9')#%</a><cfelse><a title="Success Rate">#NumberFormat(success * 100,'99.9')#%</a></cfif></td>
    </tr>
    </cfloop>
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
