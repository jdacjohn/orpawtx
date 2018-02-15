<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page inserts a new Learning Outcome into the database --->
<!--- The first step is to upload the file --->
<cfif EnrollmentPDF neq ''>

	<cffile action="upload"
  				destination="#Application.Settings.PRSetUploadDir#"
          nameConflict="MakeUnique"
          fileField="EnrollmentPDF">

	<cfset prdata = StructNew()>
  <cfset prdata.area = area>
  <cfset prdata.ay = trim(selAY)>
  <cfset prdata.major = Trim(selMajor)>
  <cfset prdata.docType = 'ENR'>
  <cfset prdata.fileName = cffile.serverFile>
  <cfset prdata.title = 'Enrollment'>
	<cfinvoke component='script.pr_sets' method='insertPRFile' prData=#prdata# returnvariable='result'></cfinvoke>

</cfif>

<cfif DemoPDF neq ''>

	<cffile action="upload"
  				destination="#Application.Settings.PRSetUploadDir#"
          nameConflict="MakeUnique"
          fileField="DemoPDF">

	<cfset prdata = StructNew()>
  <cfset prdata.area = area>
  <cfset prdata.ay = trim(selAY)>
  <cfset prdata.major = Trim(selMajor)>
  <cfset prdata.docType = 'DEMO'>
  <cfset prdata.fileName = cffile.serverFile>
  <cfset prdata.title = 'Demog.'>
	<cfinvoke component='script.pr_sets' method='insertPRFile' prData=#prdata# returnvariable='result'></cfinvoke>

</cfif>
<cfif FinAPDF neq ''>

	<cffile action="upload"
  				destination="#Application.Settings.PRSetUploadDir#"
          nameConflict="MakeUnique"
          fileField="FinAPDF">

	<cfset prdata = StructNew()>
  <cfset prdata.area = area>
  <cfset prdata.ay = trim(selAY)>
  <cfset prdata.major = Trim(selMajor)>
  <cfset prdata.docType = 'FINA'>
  <cfset prdata.fileName = cffile.serverFile>
  <cfset prdata.title = 'Fin. A'>
	<cfinvoke component='script.pr_sets' method='insertPRFile' prData=#prdata# returnvariable='result'></cfinvoke>

</cfif>

<cfif FinBPDF neq ''>

	<cffile action="upload"
  				destination="#Application.Settings.PRSetUploadDir#"
          nameConflict="MakeUnique"
          fileField="FinBPDF">

	<cfset prdata = StructNew()>
  <cfset prdata.area = area>
  <cfset prdata.ay = trim(selAY)>
  <cfset prdata.major = Trim(selMajor)>
  <cfset prdata.docType = 'FINB'>
  <cfset prdata.fileName = cffile.serverFile>
  <cfset prdata.title = 'Fin. B'>
	<cfinvoke component='script.pr_sets' method='insertPRFile' prData=#prdata# returnvariable='result'></cfinvoke>

</cfif>

<cfif narrative neq ''>

	<cffile action="upload"
  				destination="#Application.Settings.PRSetUploadDir#"
          nameConflict="MakeUnique"
          fileField="narrative">

	<cfset prdata = StructNew()>
  <cfset prdata.area = area>
  <cfset prdata.ay = trim(selAY)>
  <cfset prdata.major = Trim(selMajor)>
  <cfset prdata.docType = 'NAR'>
  <cfset prdata.fileName = cffile.serverFile>
  <cfset prdata.title = 'Narrative'>
	<cfinvoke component='script.pr_sets' method='insertPRFile' prData=#prdata# returnvariable='result'></cfinvoke>

</cfif>

<cfif outcomes neq ''>

	<cffile action="upload"
  				destination="#Application.Settings.PRSetUploadDir#"
          nameConflict="MakeUnique"
          fileField="outcomes">

	<cfset prdata = StructNew()>
  <cfset prdata.area = area>
  <cfset prdata.ay = trim(selAY)>
  <cfset prdata.major = Trim(selMajor)>
  <cfset prdata.docType = 'LOS'>
  <cfset prdata.fileName = cffile.serverFile>
  <cfset prdata.title = 'Outcomes'>
	<cfinvoke component='script.pr_sets' method='insertPRFile' prData=#prdata# returnvariable='result'></cfinvoke>

</cfif>

<div class="rightContent" >
<br />
<cflocation url="./index.cfm?action=IEIR_Admin_PR_Add" />
</div>

<div class="rightContent" >

</div>


</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">


</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
