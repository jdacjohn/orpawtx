<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
			<h5 class="rubricHeading"><em><span>Rubrics Entry</span></em></h5>

			<h5 class="rubricDef">Find Student</h5>
      To find a student, enter full or partial values into the first and last name search fields below, or the student id 
      and click the 'Search' button.  The leading zero is not required when searching by student id.<br />&nbsp;
			<form action="index.cfm?Action=RUB_Submit_FindStudent" name="studentSearch" method="post">
      	<span class="studentSearchLabel">First Name</span>: <input type="text" class="studentSearchInput" name="fname" value="" maxlength="25" size="10" />&nbsp;
        <span class="studentSearchLabel">Last Name</span>: <input type="text" class="studentSearchInput" name="lname" value="" maxlength="25" size="12" />&nbsp;
        <span class="studentSearchLabel">Student Id</span>: <input type="text" class="studentSearchInput" name="idno" value="0" maxlength="7" size="9" />&nbsp;&nbsp;
        <input type="submit" name="submit"  class="studentSearchLabel" value="Search" />
      </form><br />
      Student Search Results:<br />
      
      <table class="studentSearchTable" width="100%" align="left" cellpadding="0" cellspacing="0">
      	<tr>
        	<th></th>
        	<th>Last Name</th>
        	<th>First Name</th>
        	<th>Student Id</th>
        	<th>Major</th>
        	<th>Location</th>
        	<th>Start Term</th>
        </tr>
        <cfif isdefined("fname") and isdefined("lname") and isdefined("idno")>
        	<cfinvoke
  					component="script.students" method="findStudents" returnvariable="students" lname='#lname#' fname='#fname#' idno=#idno#>
          </cfinvoke>
      		<form name="studentSelect" action="./index.cfm?Action=RUB_Submit_Entry" method="post">
          <cfloop query='students'>
						<cfoutput>          
            <tr>
              <td><input type="radio" name="student" value="#students.student_id#" /></td>
              <td>#students.last_name#</td>
              <td>#students.first_name#</td>
              <td>#students.student_id#</td>
              <td>#students.program#</td>
              <td>#students.location#</td>
              <td>#students.start_term#</td>
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
