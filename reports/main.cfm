<cfoutput>
<style type="text/css" media="screen" >
	##track1 {
		position: absolute;
		background: transparent url(#Application.Settings.ImageBaseBgs#/redblue_slider_bg_200x9.png) no-repeat top right;
	}
	##track2 {
		position: absolute;
		background: transparent url(#Application.Settings.ImageBaseBgs#/redblue_slider_bg_200x9.png) no-repeat top right;
	}
</style>
</cfoutput>

<div id="mainBody">

<!-- MAIN RIGHT --->
<div id="mainRight">
<cfoutput>
<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Reporting and Core Indicators Quick Look</span></em></h5>
<p><img src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' class='rightImg' />
<!---<h5 class="rubricHeading">Fall 2005 - Fall 2006 <span><em>Retention: 85%</em></span></h5>
	<div id="track1" style="width:200px; height:10px;">
		<div id="handle1" style="width:10px; height:15px;"><img src="#Application.Settings.ImageBaseButtons#/slider_bttn.png" alt="85%" title="85%" style="float: left;" /></div>
	</div>
<h5 class="rubricHeading">Fall 2005 - Fall 2006 <span><em>Graduation Rate: 70%</em></span></h5>
	<div id="track2" style="width:200px; height:10px;">
		<div id="handle2" style="width:10px; height:15px;"><img src="#Application.Settings.ImageBaseButtons#/slider_bttn.png" alt="70%" title="70%" style="float: left;" /></div>
	</div>
</p> --->
</div>
</cfoutput>
<div class="rightContent" >
<h4 class="blue linkage">Links</h4>

<p><cfinclude template="../body_links.cfm"></p>
</div>


</div>

<!-- MAIN RIGHT END -->


<div id="mainLeft">

<!-- REPORTS NAV -->
<!--- <div class="leftNavContainer" >

<h4 class="blue principles">IEIR Reports</h4>
	<div class="navVertContainer">
		<ul>
    	<li><a href="./coreinds.html">Core Indicators</a></li>
    	<li><a href="./retain.html">Retention</a></li>
    	<li><a href="./graduate.html">Graduation</a></li>
    	<li><a href="./demog.html">Demographics</a></li>
		</ul>
	</div>
</div> --->
<!-- REPORTS NAV END -->

<!-- COMMUNICATION NAV -->
<div class="leftNavContainer" >

<h4 class="blue comm">IEIR Reports</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./report_links.cfm"></ul>
	</div>
</div>
<!-- COMMUNICATION NAV END -->

</div>
<!-- MAIN BODY END -->
</div>
