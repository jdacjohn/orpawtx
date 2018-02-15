<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page updates an existing Learning Outcome in the database --->
<!--- The first step is to upload the new file if one is specified--->
<cfif pdfFile neq ''>

	<cffile action="upload"
  				destination="#Application.Settings.SLOUploadDir#"
          nameConflict="MakeUnique"
          fileField="pdfFile">
</cfif>

<div class="rightContent" >
<cfoutput>
<cfset lodata = StructNew()>
<cfset lodata.loid = lo_id>
<cfset lodata.loName = loName>
<cfset lodata.loShortName = loShortName>
<cfset lodata.loDescription = Trim(loDesc)>
<cfset lodata.revMonth = revMo>
<cfset lodata.revYear = revYear>
<cfset lodata.progId = p_id>
<cfset lodata.progName = progName>
<cfif pdfFile neq ''>
	<cfset lodata.pdf = cffile.serverFile>
<cfelse>
	<cfset lodata.pdf = ''>
</cfif>
#lodata.pdf#

<cfinvoke component='script.los' method='updateLO' loData=#lodata# returnvariable='newSLO'></cfinvoke>
<br />
<cflocation url="./index.cfm?action=LOS_Admin&major=#major#&p_id=#lodata.progId#" />
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
