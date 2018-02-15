<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<!--- This page updates an existing Course-Level Learning Outcome in the database --->

<div class="rightContent" >
<cfoutput>

<cfinvoke component='script.cl_los' method='deleteCLO' loid=#loid# returnvariable='deleteResult'></cfinvoke>
<br />
<cflocation url="./index.cfm?action=CL_LOS_Delete_class&selClass=#class#" />
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
