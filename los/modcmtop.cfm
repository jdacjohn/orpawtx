<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcomes</h4>
	<cfif isdefined("prog")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.programs' method='getProgFullNameById' progId=#prog# returnvariable="progQuery"></cfinvoke>
		<cfinvoke component='script.los' method='getProgCMInfo' map=#map# returnvariable="progMap"></cfinvoke>
		<h5 class="blueback">Program Learning Outcomes Alignment Matrix: #progQuery.progName#</h5>
		<table class="loCreateTable" cellspacing="0" cellpadding="0">
		<cfform name="editCMTop" id="editCMTop" action="./index.cfm?Action=LOS_SubmitCMTop_DB" method="post" format="html">
			<input type="hidden" name="cmid" value="#map#" />
      <input type="hidden" name="prog" value="#prog#" />
      <tr>
        <td width="150" valign="top">Comments</td>
        <td width="430"><textarea class="loEntryInput" name="cmComments" id="cmComments" value="" rows="4" cols="75">#progMap.comments#</textarea></td>
      </tr>
      <tr>
        <td width="150">Rev Month</td>
        <td width="430"><input type='text' value='#progMap.cmRevMonth#' name='revMo' id='revMo' size="12" /></td>
      </tr>
      <tr>
        <td width="150">Rev Year</td>
        <td width="430"><input type='text' value='#progMap.cmRevYear#' name='revYear' id='revYear' size="12"/></td>
      </tr>
      <tr>
        <td colspan="2" align="right"><input type="submit" value="Save" name="submit" /></td>
      </tr>
		</cfform>
		</table>
		</cfoutput>
		</div>
	<cfelse>
		<div class="rightContent">  
			<p>Select a program from the list on the left to begin.</p>
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
