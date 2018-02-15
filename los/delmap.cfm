<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<div class="rightContent" >
<!--- delete the new assessment measure and redirect back to the CM Edit Page--->
<cfinvoke component='script.los' method='deleteMapping' mapid=#mapid#></cfinvoke>
<br />
<cflocation url="./index.cfm?action=LOS_EditCM&prog=#p_id#" />
</div>

<div class="rightContent" >

</div>


</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">


</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
