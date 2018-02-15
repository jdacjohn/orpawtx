<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page inserts a new Learning Outcome into the database --->
<!--- The first step is to upload the file --->

<div class="rightContent" >
<cfoutput>
<cfset lomdata = StructNew()>
<cfset lomdata.loid = lo_id>
<cfset lomdata.measureNo = curMeasureCount + 1>
<cfset lomdata.description = trim(lomDesc)>
<!--- Insert the new assessment measure --->
<cfinvoke component='script.cl_los' method='insertLOM' lomData=#lomdata# returnvariable='amID'></cfinvoke>
<!--- Criteria now --->
<cfset ratingData = StructNew()>
<cfset ratingData.lomId = amID>
<cfset ratingData.score = 1>
<cfset ratingData.criteria = trim(lomRateBeg)>
<cfinvoke component='script.cl_los' method='insertLOMR' lomrData=#ratingData# returnVariable='lomrId'></cfinvoke>
<cfset ratingData = StructNew()>
<cfset ratingData.lomId = amID>
<cfset ratingData.score = 2>
<cfset ratingData.criteria = trim(lomRateDev)>
<cfinvoke component='script.cl_los' method='insertLOMR' lomrData=#ratingData# returnVariable='lomrId'></cfinvoke>
<cfset ratingData = StructNew()>
<cfset ratingData.lomId = amID>
<cfset ratingData.score = 3>
<cfset ratingData.criteria = trim(lomRateComp)>
<cfinvoke component='script.cl_los' method='insertLOMR' lomrData=#ratingData# returnVariable='lomrId'></cfinvoke>
<cfset ratingData = StructNew()>
<cfset ratingData.lomId = amID>
<cfset ratingData.score = 4>
<cfset ratingData.criteria = trim(lomRateAcc)>
<cfinvoke component='script.cl_los' method='insertLOMR' lomrData=#ratingData# returnVariable='lomrId'></cfinvoke>

<br />
<cflocation url="./index.cfm?action=CL_LOS_Edit_Outcome&loid=#lo_id#&disc=#disc#" />
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
