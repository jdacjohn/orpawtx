<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page Updates a Learning Outcome Measurement Activity --->
<div class="rightContent" >
<cfoutput>
<cfset lomdata = StructNew()>
<cfset lomdata.lomid = lomid>
<cfset lomdata.description = trim(lomDesc)>
<!--- Update the assessment measure --->
<cfinvoke component='script.cl_los' method='updateCLOM' lomData=#lomdata#></cfinvoke>
<!--- Criteria now --->
<cfset ratingData = StructNew()>
<cfset ratingData.score = 1>
<cfset ratingData.criteria = trim(Beginning)>
<cfset ratingData.lomid = lomid>
<cfinvoke component='script.cl_los' method='updateCLOMR' lomrData=#ratingData#></cfinvoke>
<cfset ratingData = StructNew()>
<cfset ratingData.score = 2>
<cfset ratingData.criteria = trim(Developing)>
<cfset ratingData.lomid = lomid>
<cfinvoke component='script.cl_los' method='updateCLOMR' lomrData=#ratingData#></cfinvoke>
<cfset ratingData = StructNew()>
<cfset ratingData.score = 3>
<cfset ratingData.criteria = trim(Competent)>
<cfset ratingData.lomid = lomid>
<cfinvoke component='script.cl_los' method='updateCLOMR' lomrData=#ratingData#></cfinvoke>
<cfset ratingData = StructNew()>
<cfset ratingData.score = 4>
<cfset ratingData.criteria = trim(Accomplished)>
<cfset ratingData.lomid = lomid>
<cfinvoke component='script.cl_los' method='updateCLOMR' lomrData=#ratingData#></cfinvoke>

<br />
<cflocation url="./index.cfm?action=CLOS_EditSLO&loid=#lo_id#&disc=#disc#" />
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
