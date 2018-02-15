<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page updates an existing Course-Level Learning Outcome in the database --->
<!--- The first step is to upload the file --->
<cfif pdfFile neq ''>
	<cffile action="upload"
  				destination="#Application.Settings.CSLOUploadDir#"
          nameConflict="MakeUnique"
          fileField="pdfFile">
</cfif>

<div class="rightContent" >
<cfoutput>
<cfset clodata = StructNew()>
<cfset lodata.loName = loName>
<cfset lodata.loShortName = loShortName>
<cfset lodata.loDescription = Trim(loDesc)>
<cfset lodata.revMonth = revMo>
<cfset lodata.revYear = revYear>
<cfset lodata.rubric = selRubric>
<cfset lodata.loid = loid>
<cfif pdfFile neq ''>
	<cfset lodata.pdf = cffile.serverFile>
<cfelse>
	<cfset lodata.pdf = ''>
</cfif>
#lodata.pdf#

<cfinvoke component='script.cl_los' method='updateCLO' loData=#lodata# returnvariable='updateResult'></cfinvoke>
<br />
<cflocation url="./index.cfm?action=CL_LOS_Edit_Outcome&loid=#lodata.loid#&disc=#class#" />
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
