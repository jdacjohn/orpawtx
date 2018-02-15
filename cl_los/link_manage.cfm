<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcomes Administration</h4>
	<cfif isdefined("loid") && isdefined("disc")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.cl_los' method='getOutcomeByid' outcomeId=#loid# returnVariable='outcome'></cfinvoke>
		<cfinvoke component='script.cl_los' method='getLinkedCourseInfo' outcomeId=#loid# returnVariable='courses'></cfinvoke>
    <cfinvoke component='script.cl_los' method='getInsertMajor' major='#disc#' returnVariable='prog_id'></cfinvoke>
		<h5 class="blueback">Course/Outcome Link Management:&nbsp;&nbsp;<a href="./index.cfm?action=CL_LOS_Admin_Link&disc=#disc#&pid=#prog_id#" title="Return to #disc#">#disc#</a></h5>
		<p>All courses currently linked to this outcome are shown below.  From this page you can remove any existing links or
    use the button at the bottom of the list to link a new course to this outcome.
		<table class="cloSummaryTable" cellspacing="0" cellpadding="0">
      <tr>
        <th colspan="3">Outcome: <span style="text-decoration:underline"><a title="#outcome.loDesc#">#outcome.loName#</a></span></th>
        <cfif outcome.lo_pdf neq ''>
	        <th><a href="./cl_los/files/#outcome.lo_pdf#" target="_blank" title="Get PDF"><img #Application.Settings.PDFImg# /></a></th>
        <cfelse>
        	<th>&nbsp;</th>
        </cfif>
      </tr>
      <tr>
        <th width="250">Course</th>
        <th>Add Date</th>
        <th>Change Date</th>
        <th>&nbsp;</th>
      </tr>
      <cfloop query="courses">
        <tr>
          <td width="250" style="border-bottom: 1px inherit;"><a title="Learning Activity: #courses.learningActivity# - Expected Result: #courses.intent#">#courses.secRubric#</a></td>
          <td>#DateFormat(courses.add_date,"mm/dd/yyyy")#</td>
          <td>#DateFormat(courses.change_date,"mm/dd/yyyy")#</td>
          <td align="center"><a href="./index.cfm?action=CL_LOS_Delete_Link&mapid=#courses.mapid#&outcomeId=#outcome.loid#&disc=#disc#" title="Unlink this Class"><img #Application.Settings.UnlinkImg# /></a></td>
        </tr>
      </cfloop>
      <cfif courses.RecordCount eq 0>
      	<tr><td colspan="4" align="center"><span style="color:##ff0000">There are currently no courses linked with this learning outcome.</span></td></tr>
      </cfif>
      <cfform name="newLinkForm" action="./index.cfm?action=CL_LOS_Create_Link" method="post" format="html">
      	<input type="hidden" name="outcomeId" value="#outcome.loid#" />
        <input type="hidden" name="disc" value="#disc#" />
        <tr>
        	<td colspan="4" align="left"><input type="submit" name="submit" value="Add new Link" /></td>
        </tr>
      </cfform>
    </table> 
		</p>
		</cfoutput>
		</div>
	<cfelse>
		<div class="rightContent">  
			<p>Select a course discipline from the list on the left to begin.</p>
    </div>
	</cfif>

	<cfif Action eq 'App_Home_Sys_Down'>
		<cfoutput>
		<p><span style="color:##ff0000; text-decoration:underline;">The #Application.Settings.SiteOwner2# Website is currently down for routine maintenance.  Please try
		back later.  We apologize for the inconvenience.  Please contact <a href="mailto:#Application.Settings.SiteContactEmail#">#Application.Settings.SiteContactName#</a> via email
		with any questions, or call #Application.Settings.SiteContactPhone#.</span><br />Thank You.</p>
		</cfoutput>
	</cfif>

</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">
<!--- Course Admin NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Manage Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_cl_admin_links.cfm">
		</ul>
	</div>
</div>
<!--- Course Admin NAV END --->

<!--- Course Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Course Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_cl_links.cfm">
		</ul>
	</div>
</div>
<!--- Course Outcomes NAV END --->

<!--- Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Learning Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="../los/los_links.cfm">
		</ul>
	</div>
</div>
<!--- Outcomes NAV END --->

</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
