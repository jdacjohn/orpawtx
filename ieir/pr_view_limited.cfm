<div id="mainBody">
  <!--- MAIN RIGHT --->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Office of Research, Planning and Analysis</h4>
      <h5 class="rubricHeading"><em><span>Institutional Effectiveness Program Review Data Sets</span></em></h5>
      <cfif isDefined('acadYear')>
      	<cfset theYear = acadYear>
      <cfelse>
      	<cfset theYear = 0>
      </cfif>
      <cfoutput>
			<cfif theYear gt 0>
      	<p>Available program review data for enrollments, completions and placements (ECPs), and student demographic data for academic year
        #theYear# is show below and can be accessed by clicking on the links provided.</p>
        <cfinvoke component='script.pr_sets' method='getMajorsInYear' acadYear=#theYear# returnvariable='majors'></cfinvoke>
        <table class="loCreateTable" cellspacing="0" cellpadding="0">
				  <tr>
  					<th width="50">Major</th>
    				<th width="125">Students</th>
    				<th width="125">ECPs</th>
    				<th width="125">Outcomes</th>
    				<th width="125">Narrative</th>
					</tr>
					<cfloop query='majors'>
				  <tr>
  					<td width="50">#majors.major#</td>
            <cfinvoke component="script.pr_sets" method="getLimitedForYearAndProg" acadYear=#theYear# prog="#majors.major#" returnvariable="files"></cfinvoke>
            <cfset count = 0>
    				<cfloop query="files">
            	<td width="125"><a href="./ieir/prfiles/#files.filename#" target="_blank" title="View/Download dataset">#files.title#</a></td>
              <cfset count += 1>
    				</cfloop>
            <cfif count lt 4>
            	<cfloop index="ndx" from="#count#" to="4" step="1">
              	<td width="125">&nbsp;</td>
              </cfloop>
            </cfif>
					</tr>
          </cfloop>
				</table>
      <cfelse>
				<p><cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /></cfoutput>
      	Please use the links shown to the left to access Program Review datasets available in this system.</p>
      </cfif>
      </cfoutput>
    </div>
    <div class="rightContent" >
      <h4 class="blue linkage">Links</h4>
      <p>
        <cfinclude template="../body_links.cfm">
      </p>
    </div>
  </div>
  <!--- MAIN RIGHT END --->
  <div id="mainLeft">
    <!---- Years NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue comm">Available Years</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="pr_year_links.cfm">
        </ul>
      </div>
    </div>
    <!--- Years NAV END --->
    <!---- IE NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue comm">IE Links</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="ieir_links.cfm">
        </ul>
      </div>
    </div>
    <!--- IE NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
