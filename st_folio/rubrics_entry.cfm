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
      <cfinvoke component="script.students" method="getStudent" returnvariable="student_info" idno=#student#></cfinvoke>
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
    <h5 class="rubricDef">Rubrics Entry</h5>
    <cfform name="rubric_entry_f" id="rubric_entry_f" action="./index.cfm?Action=RUB_Submit_DB" method="post" format="html">
   	<input type="hidden" name="student_id" value="<cfoutput>#student_info.student_id#</cfoutput>" />
		<table class="rubricDETable" cellspacing="0" cellpadding="0">
	   	<tr>
     		<th style="background-color:##142855;color:##ffffff" align="left" >Assessment Type</th>
        <th style="background-color:##142855;color:##ffffff" align="left" ></th>
        <th style="background-color:##142855;color:##ffffff" align="left"></th>
      </tr>
      <tr>
      	<td width="183"><input type='radio' value='Baseline' name='assessment_type' id='assessment_type' />&nbsp;<b>Baseline</b></td>
        <td width="184"><input type='radio' value='Intermediate' name='assessment_type' id='assessment_type' />&nbsp;<b>Intermediate</b></td>
        <td width="183"><input type='radio' value='Capstone' name='assessment_type' id='assessment_type' />&nbsp;<b>Capstone</b></td>
			</tr>
      <tr>
      	<td colspan="2"><b>Comments:</b><br />
        	<textarea class="rubricEntryInput" name="comments" id="comments" value="" rows="4" cols="65"></textarea>
				</td>
        <td valign="top">Date: <cfinput type='datefield'  style="width:100px;" value='' name='assessment_date' id='assessment_date' mask="YYYY/MM/DD" readonly><br />
			</tr>
      <tr height="8"><td colspan="3">&nbsp;</td></tr>
      <cfinvoke component="script.rubrics" method="getRubricNames" returnvariable="rubrics"></cfinvoke>
      <tr>
      	<td colspan="3">
        	<table class="rubricDETable" cellspacing="0" cellpadding="0"> <!--- Rubrics Entry Table --->
          <cfoutput>
          <cfloop query="rubrics">
          	<tr>
          		<th style="background-color:##142855;color:##ffffff" width="20" align="left" valign="bottom"><a onclick="javascript:toggle('#rubrics.r_id#','.');"><img src="./images/buttons/expand.png" name="expand_#rubrics.r_id#" id="expand_#rubrics.r_id#"width="12" height="12" border="0" valign="bottom"></a></th>
              <th style="background-color:##142855;color:##ffffff" width="450" valign="bottom"><input type="checkbox" name="rubricselect_#rubrics.r_id#" />&nbsp;#rubrics.skill#</th>
              <th style="background-color:##142855;color:##ffffff" width="20" align="center" >1</th>
              <th style="background-color:##142855;color:##ffffff" width="20" align="center" >2</th>
              <th style="background-color:##142855;color:##ffffff" width="20" align="center" >3</th>
              <th style="background-color:##142855;color:##ffffff" width="20" align="center" >4</th>
            </tr>
            <tr id="#rubrics.r_id#" style="display:none">
            	<td colspan="6" width="550">
              	<table class="rubricDETable" cellspacing="0" cellpadding="0">
                <cfinvoke component="script.rubrics" method="getCompClasses" returnvariable="comp_classes" rid=#rubrics.r_id#></cfinvoke>
                <cfloop query="comp_classes">
                	<tr><td width="550" colspan="6">&nbsp;<i>#comp_classes.name#</i></td></tr>
                  <cfinvoke component="script.rubrics" method="getCompetencies" returnvariable="competencies" cc_id=#comp_classes.c_id#></cfinvoke>
                  <cfloop query="competencies">
                  <tr>
                  	<td width="20">&nbsp;</td>
                    <td width="450" align="left">&nbsp;<cfif competencies.name eq "">All Areas<cfelse>#competencies.name#</cfif></td>
                    <td width="20" align="center"><input type="radio" name="#rubrics.r_id#_#comp_classes.c_id#_#competencies.cmp_id#" value="1" /></td>
                    <td width="20" align="center"><input type="radio" name="#rubrics.r_id#_#comp_classes.c_id#_#competencies.cmp_id#" value="2" /></td>
                    <td width="20" align="center"><input type="radio" name="#rubrics.r_id#_#comp_classes.c_id#_#competencies.cmp_id#" value="3" /></td>
                    <td width="20" align="center"><input type="radio" name="#rubrics.r_id#_#comp_classes.c_id#_#competencies.cmp_id#" value="4" /></td>
                  </tr>
                  </cfloop>  <!--- End Competencies Loop --->
			          </cfloop>  <!--- End Competency Classes Loop --->
                </table>
              </td>
            </tr>
          </cfloop>  <!--- End Rubrics Loop --->
          </cfoutput>
          </table>  <!--- Close Rubrics Entry Table --->
        </td>
      </tr>
      <tr><td colspan="3" align="right"><input type="submit" value="Submit" name="submit" /></td></tr>
    </table>
		</cfform>
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
			<ul><cfinclude template="rubrics_links.cfm"></ul>
		</div>
	</div> <!--- End Rubric nav links --->

	<!--- Related Links --->
	<div class="leftNavContainer" >
		<h4 class="blue comm">Related Links</h4>
		<div class="navVertContainer">
			<ul><cfinclude template="qep_links.cfm"></ul>
		</div>
	</div> <!--- End related links --->

</div> <!--- End Div Main Left --->

<!-- MAIN BODY END -->
</div> <!--- End Div mainbody --->
