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
      	<p>Available program review data and documents for academic year
        #theYear# is show below and can be downloaded or viewed by clicking on the links provided.  Data files include the following:<br />
        Enrollments, Completions, and Placements (ECPs); Student Demographics, Financial Analysis information, and the Program Review
        Narrative documentation.</p>
        <cfinvoke component='script.pr_sets' method='getMajorsInYear' acadYear=#theYear# returnvariable='majors'></cfinvoke>
        <table class="loCreateTable" cellspacing="0" cellpadding="0">
				  <tr>
  					<th width="50">Major</th>
    				<th width="80">&nbsp;</th>
    				<th width="80">&nbsp;</th>
    				<th width="80">&nbsp;</th>
    				<th width="80">&nbsp;</th>
    				<th width="80">&nbsp;</th>
    				<th width="80">&nbsp;</th>
					</tr>
					<cfloop query='majors'>
				  <tr>
  					<td width="100">#majors.major#</td>
            <cfinvoke component="script.pr_sets" method="getDocsForYearAndProg" acadYear=#theYear# prog="#majors.major#" returnvariable="files"></cfinvoke>
            <cfset count = 0>
    				<cfloop query="files">
            	<td width="80"><a href="./ieir/prfiles/#files.filename#" target="_blank" title="View/Download dataset">#files.title#</a></td>
              <cfset count += 1>
    				</cfloop>
            <cfif count lt 6>
            	<cfloop index="ndx" from="#count#" to="6" step="1">
              	<td width="80">&nbsp;</td>
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
    <!---- Year NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue comm">Available Years</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="pr_year_links_full.cfm">
        </ul>
      </div>
    </div>
    <!--- Year NAV END --->
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
