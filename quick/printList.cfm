<div id="mainBody">
<!-- MAIN RIGHT --->
<div id="mainRight">

<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Outstanding Student Registrations</span></em> for <cfoutput>#major# in #loc#</cfoutput></h5>

<cfinvoke component='script.registration' method='getStudentList' major='#major#' location=#loc# returnvariable='getOutstanding'></cfinvoke>
<cfoutput>
<h5>The following students, currently enrolled for the <cfoutput>#Application.Settings.RetPrevTerm# term, have not yet registered for the #Application.Settings.RetTerm# term.</cfoutput></h5>

<table class="drrTable" align="left">
	<tr><td colspan="3" align="left">Registration Term: #Application.Settings.RetTerm#</td></tr>
  <tr>
  	<td align="left">Major: #major#</td>
    <td align="left">Location: #loc#</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
  	<th align="left">Student</th>
    <th align="left">Last Name</th>
    <th align="left">First Name</th>
  </tr>
  <cfloop query="getOutstanding">
  	<tr>
    	<td align="left">#getOutstanding.student_id#</td>
      <td align="left">#getOutstanding.lname#</td>
      <td align="left">#getOutstanding.fname#</td>
    </tr>
  </cfloop>
  <tr><td colspan="3" align="left">&nbsp;</td></tr>
  <tr><td colspan="3" align="left">This list does NOT include students who have applied for graduation or have withdrawn this term.</td></tr>
</table>
</cfoutput>
</div>

<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p><cfinclude template="../body_links.cfm"></p>
</div>
</div>
<!-- MAIN RIGHT END -->

<div id="mainLeft">
</div>
<!-- MAIN BODY END -->
</div>
