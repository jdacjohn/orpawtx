<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
			<h5 class="rubricHeading"><em><span>Rubrics Entry</span></em></h5>

			<h5 class="rubricDef">Student Information</h5>

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
        	<cfinvoke
  					component="script.students" method="getStudent" returnvariable="student_info" idno=#student_id#>
          </cfinvoke>
					<cfoutput>          
            <tr>
              <td>&nbsp;</td>
              <td>#student_info.last_name#</td>
              <td>#student_info.first_name#</td>
              <td>#student_info.student_id#</td>
              <td>#student_info.program#</td>
              <td>#student_info.location#</td>
              <td>#student_info.start_term#</td>
            </tr>
       		</cfoutput>
        </table><br />&nbsp;
        <h5 class="rubricDef">Rubrics Submission Results</h5>
				<!--- <h5 class="red_error"><cfoutput>FieldsNames List = #fieldnames#</cfoutput></h5> --->
        <cfset fields = listtoarray(fieldnames)>
				<!--- Set up a struct to hold error information --->
        <cfset rubsub_errors = #QueryNew('err_no,label,description')#>
        <cfset num_errs = 0>
        <!--- Check the input form for missing, required information --->
        <!--- Make sure an assessment type was selected.  If not - error out. --->
        <cfif not isdefined("assessment_type")>
        	<cfset num_errs += 1>
					<cfset beavis = QueryAddRow(rubsub_errors)>
          <cfset beavis = QuerySetCell(rubsub_errors,'err_no',num_errs)>
          <cfset beavis = QuerySetCell(rubsub_errors,'label','Missing Assessment Type')>
					<cfset beavis = QuerySetCell(rubsub_errors,'description',
						"You <span style='text-decoration:underline'>must</span> select an assessment type in order to submit a Rubric. 
						Please click the 'Back' button and select either Baseline, Intermediate or Capstone before proceeding.")>
        </cfif>

        <cfif assessment_date eq 'YYYY-MM-DD' or assessment_date eq ''>
        	<cfset num_errs += 1>
					<cfset beavis = QueryAddRow(rubsub_errors)>
          <cfset beavis = QuerySetCell(rubsub_errors,'err_no',num_errs)>
          <cfset beavis = QuerySetCell(rubsub_errors,'label','Missing or Invalid Assessment Date')>
					<cfset beavis = QuerySetCell(rubsub_errors,'description',
						"Check that you have entered a date for this assessment and that the date is in the format of yyyy/mm/dd. You may use
						either slashes (/), dashes (-), or periods (.) to separate the years, months and days of the date.")>
        </cfif>
				<!--- Make sure at least one Rubric was selected --->
        <cfinvoke
        	component="script.rubrics" method="getRubricIds" returnvariable="rids">
        </cfinvoke>
        <cfset rubsel = 0>
        <cfset rubricList = ''>
        <cfloop query="rids">
        	<cfif isdefined("rubricselect_" & rids.r_id)>
          	<cfset rubsel += 1>
            <cfset rubricList = ListAppend(rubricList,rids.r_id,",")>
            <!--- <cfoutput>RubricList = #rubricList#<br /></cfoutput> --->
            <cfset ratings = 0>
            <cfloop index="fieldname" list=#fieldnames#>
            <!--- <cfoutput>Fieldname = #fieldname#<br /></cfoutput> --->
            	<cfif ListGetAt(fieldname,1,'_') eq rids.r_id>
              	<cfset ratings += 1>
              </cfif>
            </cfloop>
            <cfif ratings eq 0>
            	<cfset num_errs += 1>
							<cfset beavis = QueryAddRow(rubsub_errors)>
              <cfset beavis = QuerySetCell(rubsub_errors,'err_no',num_errs)>
              <cfset beavis = QuerySetCell(rubsub_errors,'label','No Ratings Applied for Selected Rubric')>
              <cfset beavis = QuerySetCell(rubsub_errors,'description',
                "Rubric #rids.r_id# (#rids.skill#) was checked but no scores were entered for that rubric.")>
            </cfif>
          </cfif>
        </cfloop>
        <cfif rubsel eq 0>
        	<cfset num_errs += 1>
					<cfset beavis = QueryAddRow(rubsub_errors)>
          <cfset beavis = QuerySetCell(rubsub_errors,'err_no',num_errs)>
          <cfset beavis = QuerySetCell(rubsub_errors,'label','No Rubric Selected')>
					<cfset beavis = QuerySetCell(rubsub_errors,'description',
						"You <span style='text-decoration:underline'>must</span> check at least one Rubric before submitting an assessment.")>
        </cfif>
        <!--- End of Error Checking --->
        
        <!--- Either display the errors or insert the assessment data. --->
				<cfif num_errs gt 0>
        	<h6 class="red_error">Errors occurred while attempting to submit your rubric.  Please refer to the details shown below.</h6>
          <cfoutput>
        	<cfloop query="rubsub_errors">
          	<span style='color:##ff0000;text-decoration:underline'>Error No. - #rubsub_errors.err_no#&nbsp;#rubsub_errors.label#</span><br />
            &nbsp;&nbsp;#rubsub_errors.description#<br />&nbsp;<br />
          </cfloop>
          </cfoutput>
        <cfelse>
        	<h6 class="blue_success">Rubric Submit Results for Student <cfoutput>#student_id#</cfoutput>:</h6>
        	<!--- Insert a new assessment record to the db --->
          <cfinvoke
          	component="script.assess" 
            method="insertRubric" 
            returnvariable="assessment" 
            studentId=#student_id# 
            assessmentType='#assessment_type#'
            assessmentDate='#assessment_date#'
            comments='#comments#'>
          </cfinvoke>
          <cfset assessmentId = assessment.GENERATED_KEY>
          <cfoutput>New assessment inserted into IR Database.  Assessment Id No: #assessmentId#<br /></cfoutput>
        	<!--- insert the competency ratings Iterate through the list of rubrics that were selected and then find
								all of the form fields that start with the rubric id.  These field names will contain the rubric
								id, the competency class id, and the competency id.  The value of the field will be the rating. --->
        	<cfloop index='rubric_id' list=#rubricList#>
            <cfloop index="fieldname" list=#fieldnames#>
            	<cfif ListGetAt(fieldname,1,'_') eq rubric_id>
              	<!--- We have a found a field belonging to this rubric --->
	            	<!--- <cfoutput>Fieldname = #fieldname#<br /></cfoutput> --->
                <cfset rubricId = ListGetAt(fieldname,1,'_')>
                <!--- <cfoutput>Rubric Id = #rubricId#<br /></cfoutput> --->
                <cfset ccid = ListGetAt(fieldname,2,'_')>
                <!--- <cfoutput>Competency Class Id = #ccid#<br /></cfoutput> --->
                <cfset cmpid = ListGetAt(fieldname,3,'_')>
                <!--- <cfoutput>Competency Id = #cmpid#<br /></cfoutput> --->
                <cfset rating = form[fieldname]>
                <!--- <cfoutput>Field Value = #rating#<br /></cfoutput> --->
                <cfinvoke
                	component="script.assess"
                  method="insertRating"
                  returnvariable="ratingInsertResult"
                  assessmentId=#assessment.GENERATED_KEY#
                  rubricId=#rubricId#
                  compClassId=#ccid#
                  compId=#cmpid#
                  rating=#rating#>
                </cfinvoke>
             	</cfif>
            </cfloop>
        	</cfloop>
          <cfoutput>Rubric Competency Ratings saved to IR Database for Assessment Id No: #assessmentId#.<br /></cfoutput>
          &nbsp;<br />
          <form action="./index.cfm?Action=RUB_Submit" name="doover" method="post">
          	<input type='submit' name='submit' value='Submit Another' />
          </form>
        </cfif>
		</div> <!--- End Div Right Content --->


		<div class="rightContent" > <!--- Bottom of Page Links --->
			<h4 class="blue linkage">Links</h4>
			<p><cfinclude template="../body_links.cfm"></p>
		</div>

	</div> <!--- End Div mainRight --->

	<div id="mainLeft">

		<!--- Rubric Def Links --->
		<div class="leftNavContainer" >

			<h4 class="blue principles">Rubrics Definitions</h4>
			<div class="navVertContainer">
				<ul><cfinclude template="./include/all_rubrics.cfm"></ul>
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
