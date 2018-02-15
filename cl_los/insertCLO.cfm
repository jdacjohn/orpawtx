<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page inserts a new Course-Level Learning Outcome into the database --->
<!--- The first step is to upload the file --->
<cfif pdfFile neq ''>
	<cffile action="upload"
  				destination="#Application.Settings.CSLOUploadDir#"
          nameConflict="MakeUnique"
          fileField="pdfFile">
</cfif>

<!--- Error Checking --->

<div class="rightContent" >
<cfoutput>
<cfset clodata = StructNew()>
<cfset lodata.loName = loName>
<cfset lodata.loShortName = loShortName>
<cfset lodata.loDescription = Trim(loDesc)>
<cfset lodata.revMonth = revMo>
<cfset lodata.revYear = revYear>
<cfset lodata.rubric = selRubric>
<cfif pdfFile neq ''>
	<cfset lodata.pdf = cffile.serverFile>
<cfelse>
	<cfset lodata.pdf = ''>
</cfif>
#lodata.pdf#

<cfinvoke component='script.cl_los' method='insertCLO' loData=#lodata# returnvariable='newSLO'></cfinvoke>
<br />
<cflocation url="./index.cfm?action=CL_LOS_Admin_Add&loid=#newSLO.GENERATED_KEY#" />
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
