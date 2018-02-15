<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page uploads a curriculum map to the server. --->
<!--- The first step is to upload the new file if one is specified--->
<cfif isdefined('pdfFile') && pdffile neq ''>

	<cffile action="upload"
  				destination="#Application.Settings.SLOUploadDir#"
          nameConflict="MakeUnique"
          fileField="pdfFile">
</cfif>

<div class="rightContent" >
<cfoutput>
<cfif pdfFile neq ''>
	<cfset mapData = StructNew()>
	<cfset mapData.cmid = map>
	<cfset mapData.pdf = cffile.ServerFile>
	#mapData.pdf#
	<cfinvoke component='script.los' method='updateProgCMFile' mapData=#mapData# returnvariable='updateResult'></cfinvoke>
</cfif>
<br />
<cflocation url="./index.cfm?action=LOS_EditCM&prog=#prog#" />
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
