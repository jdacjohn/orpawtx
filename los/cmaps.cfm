<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcome Curriculum Maps</h4>
	<cfif isdefined("p_id")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.programs' method='getProgInfoById' progId=#p_id# returnvariable="progQuery"></cfinvoke>
		<cfinvoke component='script.los' method='getProgCM' p_id=#p_id# returnvariable='progMap'></cfinvoke>
		<!--- Learning Outcomes Section --->
		<h5 class="blueback">&nbsp;Program Learning Outcomes Alignment Matrix: <a href="./index.cfm?action=LOS_Browse&major=#progQuery.rubric#&p_id=#p_id#" title="Return to #progQuery.rubric#">#progQuery.progName#</a></h5>
		
    <table class="loSummaryTable" cellspacing="0" cellpadding="0">
    <cfinvoke component='script.los' method='getProgLOs' p_id=#p_id# returnvariable='outcomes'></cfinvoke>
    <cfset loArray = ArrayNew(1)>
    <cfset indexPos = 1>
    <cfloop query="outcomes">
    	<cfset loArray[indexPos] = outcomes.loid>
      <cfset indexPos += 1>
    </cfloop>
      <tr>
        <cfset indexPos = 1>
        <cfloop query="outcomes">
          <cfif indexPos eq 1>
            <td style="border-top: 1px solid ##142855">&nbsp;</td>
            <td style="border-top: 1px solid ##142855"><span style='text-decoration:underline'>Outcome #indexPos#</span></td>
          <cfelse>
            <td style="border-top: 1px solid ##142855"><span style='text-decoration:underline'>Outcome #indexPos#</span></td>
          </cfif>
          <cfset indexPos += 1>
        </cfloop>
      </tr>
      <tr>
        <cfset indexPos = 1>
        <cfloop query="outcomes">
          <cfif indexPos eq 1>
            <td style="border-bottom: 1px solid ##142855">Course</td>
            <cfinvoke component='script.los' method='countLOMappings' loid=#outcomes.loid# cmid=#progMap.progCMID# returnVariable='mapCount'></cfinvoke>
            <td style="border-bottom: 1px solid ##142855"><cfif mapCount eq 0><span style='color:##FF0000'>#outcomes.loName#</span><cfelse>#outcomes.loName#</cfif></td>
          <cfelse>
            <cfinvoke component='script.los' method='countLOMappings' loid=#outcomes.loid# cmid=#progMap.progCMID# returnVariable='mapCount'></cfinvoke>
            <td style="border-bottom: 1px solid ##142855"><cfif mapCount eq 0><span style='color:##FF0000'>#outcomes.loName#</span><cfelse>#outcomes.loName#</cfif></td>
          </cfif>
          <cfset indexPos += 1>
        </cfloop>
      </tr>
      <cfinvoke component='script.los' method='getMapSections' cmid=#progMap.progCMID# returnVariable='sections'></cfinvoke>
      <cfif sections.recordcount eq 0>
      	<tr>
        	<td colspan="#ArrayLen(loArray) + 1#"><span style="color:##FF0000">No Course Mappings Found.  In order to ADD a mapping to the curriculum map
          for this program, at least one Learning Outcome must be defined for the program.</span></td>
        </tr>
      <cfelse>
      <cfloop query='sections'>
      <tr>
      	<td><cfif sections.capstone eq 1><b></cfif>#sections.rubric#<cfif sections.capstone eq 1></b></cfif></td>
        <cfloop from="1" to="#ArrayLen(loArray)#" step="1" index="ndx">
        <cfinvoke component='script.los' method='getLevels' outcome=#loArray[ndx]# rubric='#sections.rubric#' map=#progMap.progCMID# returnvariable='levels'></cfinvoke>
          <td align="center">
        	<cfloop query="levels">
          	#levels.level#&nbsp;
          </cfloop>
         	</td>
        </cfloop>
      </tr>
      </cfloop>
      </cfif>
      <tr>
      	<td colspan="#ArrayLen(loArray) + 1#" style="border-top: 1px solid ##142855">Legend</td>
      </tr>
      <tr>
      	<td colspan="#ArrayLen(loArray) + 1#" style="border-top: 1px solid ##142855">I = Introduced</td>
      </tr>
      <tr>
      	<td colspan="#ArrayLen(loArray) + 1#" style="border-top: 1px solid ##142855">D = Develop and Practice with Feedback</td>
      </tr>
      <tr>
      	<td colspan="#ArrayLen(loArray) + 1#" style="border-top: 1px solid ##142855;">M = Demonstrated at the Mastery Level Appropriate for Certification/Graduation</td>
      </tr>
      <tr>
      	<td colspan="#ArrayLen(loArray) + 1#" style="border-top: 1px solid ##142855; border-bottom: 1px solid ##142855">Capstone courses are indicated in <b>BOLD</b>.</td>
      </tr>
    </table>
		<cfinvoke component='script.los' method='getProgCMInfo' map=#progMap.progCMID# returnvariable="progInfo"></cfinvoke>
    <p>Notes:<br />#progInfo.comments#<br />&nbsp;<br />Rev. #progInfo.cmRevMonth#/#progInfo.cmRevYear#
    <cfif progMap.cmPDF neq ''>&nbsp;<a href="./los/files/#progMap.cmPDF#" title="Get PDF" target="_blank"><img #Application.Settings.PDFImg# /></a></cfif>
    </p>
		</cfoutput>
		</div>
	<cfelse>
		<div class="rightContent">  
			<p>Curriculum Maps are created and maintained by each instructional divistion at <cfoutput>#Application.Settings.College#</cfoutput>.  These maps indicate the courses in a program's
      curriculum in which assessment of student learning outcomes will be conducted and the level, Introductory, Developing, or Mastery, at which the students are being
      assessed in the class.<br />&nbsp;<br />
      To view these curriculum maps, please select a major from the list on the left.</p>
    </div>
	</cfif>
	
	
	<cfif Action eq 'App_Home_Sys_Down'>
		<cfoutput>
		<p><span style="color:##ff0000; text-decoration:underline;">The #Application.Settings.SiteOwner2# Website is currently down for routine maintenance.  Please try
		back later.  We apologize for the inconvenience.  Please contact <a href="mailto:#Application.Settings.SiteContactEmail#">#Application.Settings.SiteContactName#</a> via email
		with any questions, or call #Application.Settings.SiteContactPhone#.</span><br />Thank You.</p>
		</cfoutput>
	</cfif>

  <div class="rightContent" >
  <h4 class="blue linkage">Links</h4>
  
  <p>
  <img class='rightImg' src='images/logo/ieir_logo_200px.gif' />
  <cfinclude template='body_links.cfm'>
  </p>
  </div>

</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">

<!--- Majors NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Majors</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_majors_links.cfm">
		</ul>
	</div>
</div>
<!--- Majors NAV END --->

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
