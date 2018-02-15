<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<div class="rightContent" >
<cfoutput>
<cfset mapinfo = StructNew()>
<cfset mapinfo.rubric = secRubric>
<cfset mapinfo.level = level>
<cfset mapinfo.capstone = capstone>
<cfset mapinfo.cmid = cmid>
<cfset mapinfo.loid = loid>
<!--- Insert the new assessment measure --->
<cfinvoke component='script.los' method='insertMapping' mapInfo=#mapInfo#></cfinvoke>
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
