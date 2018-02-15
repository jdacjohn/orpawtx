<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page copies outcomes from 1 program to another --->
<!--- The first step is to upload the file --->

<div class="rightContent" >
<cfoutput>

<!--- Get the id of the selected major or insert if it doesn't exist and get the new id. --->
<cfinvoke component='script.cl_los' method='getInsertMajor' major='#theMajor#' returnVariable='programId'></cfinvoke>
<!--- Copy the old outcomes and all components of them to the new major --->
<cfinvoke component="script.cl_los" method='copyOutcomes' program=#programId# outcomes='#oldOutcome#' returnVariable="newOutcome"></cfinvoke>


<br />
<cflocation url="./index.cfm?action=CL_LOS_Edit_Major&disc=#theMajor#&pid=#programId#" />
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
