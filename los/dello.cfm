<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<div class="rightContent" >
<!--- delete the entire learning outcome and redirect back to the prog admin Page--->
<cfinvoke component='script.los' method='deleteLO' loid=#loid#></cfinvoke>
<br />
<cflocation url="./index.cfm?action=LOS_ViewMeasures&loid=#loid#&prog=#prog#" />
</div>

<div class="rightContent" >

</div>


</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">


</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
