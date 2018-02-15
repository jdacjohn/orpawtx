<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.College#</cfoutput> Student Learning Outcomes</h4>
	<div class="rightContent" >
		<h5 class="blueback">Delete Course Level Learning Outcomes</h5>
		<p>
    <img class='rightImg' src='images/logo/star_200px.gif' />
		To begin, find the outcome you want to delete by using one of the links on the left.</p>
    <p>Please contact <a href="mailto:john.arnold@sweetwater.tstc.edu">John Arnold</a> in the Office of Research,
    Planning & Analysis at <span style="text-decoration:underline">325.235.7408</span> with any questions or suggestions.
    </p>
	</div>

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

<h4 class="blue principles">Find Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_delete_links.cfm">
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
