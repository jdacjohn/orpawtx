<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="termReports"><em><span>Course Success</span></em></h5>
<p>For the purposes of these reports, "Course Success" indicates the ratio of students who successfully 
complete a course.  The ratios for drop rates, fail rates, and success rates are based on the number of
students initially registered in a class, the number of students who withdrew from the class, and the number
of students who did not drop, but failed the class. Failure rates are based on the number of students who did
not withdraw from the class but completed with a final verified grade lower than C.<br />
By default, the reports are sorted in order of the course name in order to allow faculty and program administrators
to easily locate classes of interest.  You may specify alternate
sorting options such as withdraw rate, fail rate, length of course, etc.  Drop rates and fail rates above
25% are indicated in <span style="color:#FF0000;font-weight:bold;">bold</span> as are success rates below 75%.<br />
In order to retrieve a report, select a term from the list of available terms below and click the Submit button.</p>

<cfinvoke component='script.terms' method='getActiveTermsArray' returnVariable='termArray'></cfinvoke>
<cfif isdefined('termSel')>
	<cfset theTerm = termSel>
<cfelse>
	<cfset theTerm = ''>
</cfif>

<cfif isdefined('loc')>
	<cfset theLoc = loc>
<cfelse>
	<cfset theLoc = 0>
</cfif>

<cfif isDefined('sort1')>
	<cfset s1 = sort1>
<cfelse>
	<cfset s1 = ''>
</cfif>
<cfif isDefined('sort2')>
	<cfset s2 = sort2>
<cfelse>
	<cfset s2 = ''>
</cfif>

<cfoutput>
<cfform name="termSelForm" id="termSelForm" action="./index.cfm?action=Reports_Term_CS" method="post" format="html">
<table class="npTable">
	<tr>
  	<th colspan="7">Available Terms</th>
  </tr>
  <cfset count=0>
  <tr>
 	<cfloop index="ndx" from="1" to="#ArrayLen(termArray) - 1#" step="1">
   	<td style="border: 0px; vertical-align: top;"><input type="radio" name="termSel" value="#termArray[ndx]#" <cfif (termArray[ndx] eq theTerm)> checked </cfif>  />#termArray[ndx]#</td>
    <cfset count += 1>
    <cfif count eq 7>
     	</tr><tr>
      <cfset count=0>
    </tr></cfif>
  </cfloop>
  
  <cfinvoke component='script.courses' method='getColleges' returnVariable='colleges'></cfinvoke>
  <tr>
  	<th>College:</th>
  	<td colspan="6" style="border: 0px; vertical-align: middle;">
    	<cfloop query='colleges'>
    	<input type="radio" name="loc" value="#colleges.lc_id#" <cfif theLoc eq colleges.lc_id> checked </cfif> />#colleges.campus#&nbsp;
      </cfloop>
    </td>
  </tr>
  <tr>
  	<th>1st Sort:</th>
  	<td colspan="6" style="border: 0px; vertical-align: middle;">
    	<input type="radio" name="sort1" value="course_length" <cfif s1 eq 'course_length'> checked </cfif> />Course Length
    	<input type="radio" name="sort1" value="successRate DESC" <cfif s1 eq 'successRate DESC'> checked </cfif> />Success Rate
    	<input type="radio" name="sort1" value="failRate DESC" <cfif s1 eq 'failRate DESC'> checked </cfif> />Fail Rate
    	<input type="radio" name="sort1" value="dropRate DESC" <cfif s1 eq 'dropRate DESC'> checked </cfif> />Drop Rate
      <input type='radio' name='sort1' value='' />Clear
    </td>
  </tr>
  <tr>
  	<th>2nd Sort:</th>
  	<td colspan="6" style="border: 0px; vertical-align: middle;">
    	<input type="radio" name="sort2" value="successRate DESC" <cfif s2 eq 'successRate DESC'> checked </cfif> />Success Rate
    	<input type="radio" name="sort2" value="failRate DESC" <cfif s2 eq 'failRate DESC'> checked </cfif> />Fail Rate
    	<input type="radio" name="sort2" value="dropRate DESC" <cfif s2 eq 'dropRate DESC'> checked </cfif> />Drop Rate
      <input type='radio' name='sort2' value='' />Clear
    </td>
  </tr>
  <tr>
  	<th colspan="6">&nbsp;</th>
  	<td align="center"><input type="submit" name="submit" value="Submit" /></td>
  </tr>
</table>
</cfform>

<p>
<cfif theTerm neq '' && theLoc neq 0>
  <cfinvoke component='script.courses' method='getCollege' location=#theLoc# returnVariable="college"></cfinvoke>
	<h5 class="termReports"><em><span>Course Pass/Fail Rates for Term:  #theTerm# - TSTC #College#</span></em></h5>
<cfelse>
<h5 class="rubricHeading"><em><span>Please Select both a Term and a College.</span></em></h5>	
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
  <cfif theTerm neq '' && theLoc neq 0>
  	<cfinvoke component='script.courses' method='getTermDropFailRates' term='#right(theTerm,5)#' location=#theLoc# sortClause1='#s1#' sortClause2='#s2#' returnVariable='courses'></cfinvoke>
    <cfinvoke component='script.courses' method='getCollege' location=#theLoc# returnVariable="college"></cfinvoke>
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
      
    	<td width="75"><cfif flag eq 'Y'><span style="color:##ff0000;">#courses.course#</span><cfelse>#courses.course#</cfif></td>
    	<td><a href="./index.cfm?action=CS_Drilldown&course=#courses.course#&term=#theTerm#&loc=#theLoc#"><cfif flag eq 'Y'><span style="color:##ff0000;">#courses.course_title#</span><cfelse>#courses.course_title#</cfif></a></td>
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
