<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="loMainRight">
	<h4 class="blue instructional"><cfoutput>#Application.Settings.CollegeShortName#</cfoutput> Student Learning Outcomes</h4>
	<cfif isdefined("loag")>
		<div class="rightContent" >
		<cfoutput>
		<cfinvoke component='script.los' method='getAG' agId=#loag# returnvariable='aGroup'></cfinvoke>
		<cfinvoke component='script.programs' method='getProgFullNameById' progId=#aGroup.prog_id# returnvariable="progQuery"></cfinvoke>
		<!--- Learning Outcomes Section --->
		<h5 class="blueback">#progQuery.progName# Program Learning Outcomes Assessment Entry</h5>

    <cfform name="loRubricEntry" id="loRubricEntry" action="./index.cfm?action=LOS_SubmitRubric_DB" format="html">
    <table class="loSummaryTable" cellspacing="0" cellpadding="0">
    	<cfif isDefined('errorNum')>
      <tr>
      	<td colspan="5" width="590"><span style="color:##ff0000"><b>Your entry is missing required information.  Please ensure that the fields shown in RED have been entered
        and resubmit the rubric.</b></span></td>
      </tr>
      </cfif>
      <tr>
      	<td width="118"><cfif isdefined('errorNum')><span style="color: ##ff0000"><b>Student</b></span><cfelse>Student</cfif></td>
        <td width="118">&nbsp;</td>
        <td width="118"><cfif isdefined('errorNum')><span style="color: ##ff0000"><b>Student ID</b></span><cfelse>Student ID</cfif></td>
        <td width="118">Class</td>
        <td width="118">&nbsp;</td>
      </tr>
      <input type="hidden" name="loa_group_id" value="#loag#" />
      <input type="hidden" name="outcome_id" value="#aGroup.loid#" />
      <input type="hidden" name="lo_level" value="#aGroup.lo_level#" />
      <input type="hidden" name="major" value="#major#" />
      <input type="hidden" name="p_id" value="#p_id#" />
      <input type="hidden" name="addmore" id="addmore" value="" />
      <cfinvoke component='script.los' method='getStudents' class='#aGroup.class#' term='#aGroup.term#' loa_group_id=#loag# returnvariable="students"></cfinvoke>
      <tr>
      	<td colspan="2" width="236">
        	<select name='studentList' onchange="javascript:student.value = this.value;">
          	<option value=''></option>
            <cfloop query="students">
              <option value="#students.stc_person_id#">#students.scs_last_name#, #students.scs_first_name#</option>
            </cfloop>
          </select>
        </td>
        <td width="118"><input type="text" name="student" value='' maxlength="7" size="10" readonly /></td>
        <td colspan="2"><input type="text" name="class" value='#aGroup.class#' size="20" readonly /></td>
      </tr>
      <tr>
      	<td width="118">Term</td>
        <td width="118"><cfif isdefined('errorNum')><span style="color: ##ff0000"><b>Date</b></span><cfelse>Date</cfif></td>
        <td>Assessment Type</td>
        <td colspan="2">Instructor: #aGroup.instr_fname & ' ' & aGroup.instr_lname#</td>
			</tr>      	
      <tr>
      	<td width="118"><input type="text" name="term"  id="term" value='#aGroup.term#' maxlength="5" size="10" readonly /></td>
        <td width="118"><cfinput type='datefield'  style="width:70px;" value='' name='loaDate' id='loaDate' mask="YYYY-MM-DD" readonly></td>
        <td colspan="3" style="background-color:##ffffff; border: 1px solid;"><input type="radio" name="loLevel" value="I" <cfif aGroup.lo_level eq 'I'>checked</cfif> disabled />&nbsp;Introductory
        <input type="radio" name="loLevel" value="D" <cfif aGroup.lo_level eq 'D'>checked</cfif> disabled />&nbsp;Developing
        <input type="radio" name="loLevel" value="M" <cfif aGroup.lo_level eq 'M'>checked</cfif> disabled />&nbsp;Mastery</td>
			</tr>
      <tr>
      	<td colspan="5"><hr width="100%" /></td>
      </tr>
      <cfinvoke component="script.los" method='getOutcomeByID' outcomeId=#aGroup.loid# returnvariable="learningOutcome"></cfinvoke>
      <tr>
      	<td colspan="5"><h5 class="blueback">#learningOutcome.loProgramName# - #learningOutcome.loName#</h5></td>
      </tr>
      <tr>
      	<td colspan="5"><b>#learningOutcome.loDesc#<b></td>
      </tr>
      <tr>
      	<td colspan="5"><hr width="100%" /></td>
      </tr>
      <tr>
      	<td width="118" style="border-bottom: 1px solid;"><b>Activities</b></td>
      	<td width="118" style="border-bottom: 1px solid;"><b>Beginning</b></td>
      	<td width="118" style="border-bottom: 1px solid;"><b>Developing</b></td>
      	<td width="118" style="border-bottom: 1px solid;"><b>Competent</b></td>
      	<td width="118" style="border-bottom: 1px solid;"><b>Accomplished</b></td>
			</tr>
      <cfinvoke component='script.los' method='getMeasures' loid=#aGroup.loid# returnvariable='measures'></cfinvoke>
      <cfloop query="measures">
      	<tr>
        	<td style="border-bottom: 1px solid;"><b>Assessment Measure</b></td>
          <td colspan="4" style="border-bottom: 1px solid; border-left: 1px solid;"><cfif isdefined('errorNum')><span style="color: ##ff0000"></cfif><b>#measures.lomDescription#</b><cfif isdefined('errorNum')></span></cfif></td>
        </tr>
        <tr>
        	<td style="border-bottom: 1px solid;">&nbsp;</td>
          <cfinvoke component='script.los' method='getCriteria' lomid=#measures.lomid# returnvariable='criteria'></cfinvoke>
          <cfloop query='criteria'>
          	<td valign="top" style="border-left: 1px solid; border-bottom: 1px solid;"> <cfinput type='radio' name="#'rating_' & measures.lomid#" value="#criteria.lomrid#" /><br />#criteria.lomrDescription#</td>
          </cfloop>
        </tr>
      	<tr>
        	<td style="border-bottom: 1px solid;"><b>Comments</b></td>
          <td colspan="4" style="border-bottom: 1px solid; border-left: 1px solid;"><textarea class="loEntryInput" name="#'ratingComments_' & measures.lomid#" value='' cols="93"></textarea></td>
        </tr>
      </cfloop>
      <tr>
      	<td colspan="5"><hr width="100%" /></td>
      </tr>
      <tr>
      	<td colspan="5"><cfinput type="submit" name="submit" value="Submit" /><cfinput type="submit" name="add" value="Add Another" onclick="javascript:document.getElementById('addmore').value='yes'" /></td>
      </tr>
      <tr>
      	<td colspan="5"><hr width="100%" /></td>
      </tr>
    </table>
    </cfform>
		</cfoutput>
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

<!--- Program NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Majors</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_majors_links.cfm">
		</ul>
	</div>
</div>
<!--- Program NAV END --->

<!--- PGM Outcomes NAV --->
<div class="leftNavContainer" >

<h4 class="blue principles">Program Outcomes</h4>
	<div class="navVertContainer">
		<ul>
      <cfinclude template="los_pgm_links.cfm">
		</ul>
	</div>
</div>
<!--- PGM Outcomes NAV END --->

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
