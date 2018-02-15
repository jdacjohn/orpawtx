<div id="mainBody">


<!-- MAIN RIGHT --->
<div id="loMainRight">
<div class="rightContent" >
<!--- delete the new assessment measure and redirect back to the CM Edit Page--->
<cfinvoke component='script.cl_los' method='deleteCLOM' lomid=#lomid# loid=#loid#></cfinvoke>
<br />
<cflocation url="./index.cfm?action=CL_LOS_Edit_Outcome&loid=#loid#&disc=#disc#" />
</div>

<div class="rightContent" >

</div>


</div>

<!--- MAIN RIGHT END --->


<div id="loMainLeft">


</div> <!--- Main Left End --->
<!-- MAIN BODY END -->
</div>
