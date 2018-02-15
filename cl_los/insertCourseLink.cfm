<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<div class="rightContent" >
<cfoutput>
<cfset mapinfo = StructNew()>
<cfset mapinfo.rubric = trim(rubric)>
<cfset mapinfo.outcome = outcome>
<cfset mapinfo.intent = trim(intent)>
<cfset mapinfo.activity = trim(activity)>
<!--- Insert the new assessment measure --->
<cfinvoke component='script.cl_los' method='insertMapping' mapInfo=#mapInfo#></cfinvoke>
<br />
<cflocation url="./index.cfm?action=CL_LOS_Manage_Links&disc=#disc#&loid=#outcome#" />
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
