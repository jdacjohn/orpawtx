<div id="mainBody">

	<!-- MAIN RIGHT --->
	<div id="mainRight">

		<div class="rightContent" >  <!--- Actual Body content --->
			<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
			<h5 class="rubricHeading"><em><span>Single Student Assessment Data</span></em></h5>

			<h5 class="rubricDef">Student Information</h5>
      <cfinvoke
        component="script.assess" method="getAssessment" returnvariable="assessment" sid=#sid#>
      </cfinvoke>

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
          component="script.students" method="getStudent" returnvariable="student_info" idno=#assessment.student#>
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
			<h5 class="rubricDef">Assessment Information</h5>
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
        <tr>
        	<cfoutput>
          <td>&nbsp;</td>
          <td>#assessment.sid#</td>
          <td>#assessment.student#</td>
					<td>QEP Rubric</td>
          <td>#assessment.assessment_type#</td>
          <td>#DateFormat(assessment.assessment_date,'yyyy-mm-dd')#</td>
          <td>#assessment.semester#</td>
          </cfoutput>
        </tr>
      </table><br />&nbsp;  
       
      <h5 class="rubricDef">Assessment Ratings</h5>
      <table class="rubricDETable" cellspacing="0" cellpadding="0">
      <cfoutput>
        <tr>
          <td colspan="3"><b>Comments:</b><br />&nbsp;<br /><i>#assessment.comments#</i></td>
        </tr>
        <tr height="8">
          <td colspan="3">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="3">
          	<table class="rubricDETable" cellspacing="0" cellpadding="0"> <!--- Rubrics View Table --->
              <cfinvoke
                component="script.assess" method="getRubrics" returnvariable="rubrics" sid=#assessment.sid#>
              </cfinvoke>
        			<cfloop query="rubrics">
              <cfinvoke
              	component="script.rubrics" method="getRubricName" returnvariable="rubric" r_id=#rubrics.rubric_id#>
              </cfinvoke>
            	<tr>
               	<th colspan="2" style="background-color:##142855;color:##ffffff" width="470" valign="bottom">#rubric.skill#</th>
               	<th colspan="4" style="background-color:##142855;color:##ffffff" width="80" align="center" >Rating</th>
             	</tr>
              <cfinvoke
              	component="script.assess" method="getCompClasses" returnvariable="classes" sid=#assessment.sid# rid=#rubrics.rubric_id#>
              </cfinvoke>
              <cfloop query="classes">
             	<tr>              	              
              	<td colspan="6" width="550">
                	<table class="rubricDETable" cellspacing="0" cellpadding="0">
                    <cfinvoke
                      component="script.rubrics" method="getCompClass" returnvariable="compClass" cc_id=#classes.comp_class_id#>
                    </cfinvoke>
                  	<tr>
                    	<td width="550" colspan="6">&nbsp;<i>#compClass.name#</i></td>
                   	</tr>
                    <cfinvoke
                      component="script.assess" method="getComps" returnvariable="comps" sid=#assessment.sid# rid=#rubrics.rubric_id# compClass=#classes.comp_class_id#>
                    </cfinvoke>
										<cfloop query="comps">
                    <cfinvoke
                      component="script.rubrics" method="getCompetency" returnvariable="comp" compId=#comps.competency_id#>
                    </cfinvoke>
                    <cfinvoke
                      component="script.assess" method="getRating" returnvariable="compRating" sid=#assessment.sid# rid=#rubrics.rubric_id# compClass=#classes.comp_class_id# comp=#comps.competency_id#>
                    </cfinvoke>
                   	<tr>
                     	<td width="20">&nbsp;</td>
                     	<td width="450" align="left">&nbsp;<cfif comp.name eq "">All Areas<cfelse>#comp.name#</cfif></td>
                     	<td colspan="4" width="80" align="center">#compRating.rating#</td>
                   	</tr>
                    </cfloop>  <!--- End comps loop --->
                 	</table>
               	</td>
             	</tr>
              </cfloop> <!--- End classes loop --->
            	</cfloop> <!--- End Rubrics Loop --->
           	</table>  <!--- Close Rubrics Entry Table --->
          </td>
        </tr>
        </cfoutput>
      </table>
      
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
