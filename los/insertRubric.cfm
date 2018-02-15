<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page inserts a new Learning Outcome Assessment into the database --->
<!--- The first step is to upload the file --->
<div class="rightContent" >
<cfoutput>
<cfset errorNum=0>
<cfset assessmentData = StructNew()>
<cfset assessmentData.groupId = loa_group_id>
<cfset assessmentData.outcomeId = outcome_id>
<cfset assessmentData.term = term>
<cfif student eq ''>
	<cfset errorNum += 1>
<cfelse>
	<cfset assessmentData.student = student>
 	<cfinvoke component='script.los' method='getStudentName' studentId=#student# term='#term#' class='#class#' returnVariable="studentName"></cfinvoke>
  <cfset assessmentData.studentFName = studentName.first>
  <cfset assessmentData.studentLName = studentName.last>
</cfif>
<cfif loaDate eq ''>
	<cfset errorNum += 1>
<cfelse>
	<cfset assessmentData.loaDate = loaDate>
</cfif>
<cfset assessmentData.loLevel = lo_level>

<cfif errorNum eq 0>
	<cfinvoke component='script.los' method='getLOMIds' outcomeId=#outcome_id# returnVariable='ids'></cfinvoke>
  <cfloop query='ids'>
  	<cfif !isdefined("rating_" & #ids.lomid#)>
    	<cfset errorNum += 1>
    </cfif>
  </cfloop>
</cfif>	
<!--- Errors:  #errorNum#<br />			
<cfdump var="#fieldnames#">
<cfdump var="#assessmentData#"> --->

<cfif errorNum eq 0>
	<cfinvoke component='script.los' method='insertRubric' assessmentData=#assessmentData# returnvariable='loaId'></cfinvoke>
  <cfloop query="ids">
		<cfset fieldname = "rating_" & ids.lomid>
    <cfset rating = form[fieldname]>
    <!--- Rating for #ids.lomid# = #rating#<br /> --->
    <cfset ratingData = StructNew()>
    <cfset ratingData.outcomeId = loaId>
    <cfset ratingData.measurementId = ids.lomid>
    <cfset ratingData.ratingId = rating>
    <cfinvoke component='script.los' method='getRatingScore' ratingId=#rating# returnVariable='score'></cfinvoke>
    <cfset ratingData.score = score>
    <cfset ratingData.comments = form["ratingComments_" & ids.lomid]>
    <!--- <cfdump var="#ratingData#"> --->
    <!--- Insert the scoring information --->
    <cfinvoke component='script.los' method='insertAssessmentRating' ratingData=#ratingData#></cfinvoke>
  </cfloop>
  <cfif isdefined('addmore') && addmore eq 'yes'>
		<cflocation url="./index.cfm?action=LOS_EnterRubric&loag=#loa_group_id#&major=#major#&p_id=#p_id#" />
  <cfelse>
		<cflocation url="./index.cfm?action=LOS_Entry&major=#major#&p_id=#p_id#" />
  </cfif>
<cfelse>
	<cflocation url="./index.cfm?action=LOS_EnterRubric&loag=#loa_group_id#&major=#major#&p_id=#p_id#&errorNum=#errorNum#" />
</cfif>
</cfoutput>
</div>

<div class="rightContent" >

</div>


</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">


</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
