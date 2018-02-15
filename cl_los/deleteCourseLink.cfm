<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<div class="rightContent" >
<cfoutput>
<!--- Delete the new assessment measure --->
<cfinvoke component='script.cl_los' method='deleteMapping' linkId=#mapId#></cfinvoke>
<br />
<cflocation url="./index.cfm?action=CL_LOS_Manage_Links&disc=#disc#&loid=#outcomeId#" />
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
