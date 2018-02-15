<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
			<h5 class="rubricHeading"><em><span>View Rubrics</span></em></h5>

			<h5 class="rubricDef">Find Student</h5>
      To view assessments for a student, you must enter the student id 
      and click the 'Search' button.  The leading zero is not required when searching by student id.  A list of rubrics found for the 
      student will be displayed below.<br />&nbsp;
			<form action="index.cfm?Action=RUB_View_Select" name="assessmentSearch" method="post">
        <span class="studentSearchLabel">Student Id</span>: <input type="text" class="studentSearchInput" name="idno" value="0" maxlength="7" size="9" />&nbsp;&nbsp;
        <input type="submit" name="submit"  class="studentSearchLabel" value="Search" />
      </form><br />
      <span style="text-decoration:underline">Assessment Search Results</span>:<br />
      
      <table class="studentSearchTable" width="100%" align="left" cellpadding="0" cellspacing="0">
      	<tr>
        	<th></th>
          <th>Id</th>
        	<th>Student</th>
        	<th>Area</th>
        	<th>Type</th>
        	<th>Date</th>
        	<th>Semester</th>
        </tr>
        <cfif isdefined("idno")>
        	<cfinvoke
  					component="script.assess" method="getAssessments" returnvariable="assessments" studentId=#idno# assessmentArea='Rubric'>
          </cfinvoke>
      		<form name="assessmentSelect" action="./index.cfm?Action=RUB_View_Selected" method="post">
          <cfloop query='assessments'>
						<cfoutput>          
            <tr>
              <td><input type="radio" name="sid" value="#assessments.sid#" /></td>
              <td>#assessments.sid#</td>
              <td>#assessments.student#</td>
							<td>QEP Rubric</td>
              <td>#assessments.assessment_type#</td>
              <td>#DateFormat(assessments.assessment_date,'yyyy-mm-dd')#</td>
              <td>#assessments.semester#</td>
            </tr>
        		</cfoutput>
          </cfloop>
          <tr><td colspan="7" align="left">&nbsp;</td></tr>
          <tr><td colspan="7" align="left"><input type='submit' name='continue' class="studentSearchLabel" value='Continue' /></td></tr>
        	</form>
       	</cfif>
      </table><br />&nbsp;  
		</div> <!--- End Div Right Content --->

		<div class="rightContent" > <!--- Bottom of Page Links --->
			<h4 class="blue linkage">Links</h4>
			<p><cfinclude template="../body_links.cfm"></p>
		</div>

	</div> <!--- End Div mainRight --->

	<div id="mainLeft">

		<!--- Rubric Def Links --->
		<div class="leftNavContainer" >

			<h4 class="blue principles">Assessments</h4>
			<div class="navVertContainer">
				<ul><cfinclude template="./rubric_assess_links.cfm"></ul>
			</div>
		</div> <!--- End Rubric Def Links --->

		<!--- Rubrics nav links --->
		<div class="leftNavContainer" >
			<h4 class="blue principles">Rubrics</h4>
			<div class="navVertContainer">
				<ul>
      		<cfinclude template="rubrics_links.cfm">
				</ul>
			</div>
		</div> <!--- End Rubric nav links --->

		<!--- Related Links --->
		<div class="leftNavContainer" >
			<h4 class="blue comm">Related Links</h4>
			<div class="navVertContainer">
				<ul>
    			<cfinclude template="qep_links.cfm">
				</ul>
			</div>
		</div> <!--- End related links --->

	</div> <!--- End Div Main Left --->

<!-- MAIN BODY END -->
</div> <!--- End Div mainbody --->
