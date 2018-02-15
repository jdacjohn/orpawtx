<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TSTC West Texas Institutional Effectiveness & Information Research</title>
<cfoutput>
<link href="#Application.Settings.BaseURL#/css/style.css" rel="stylesheet" type="text/css" />
<link href='#Application.Settings.BaseURL#/css/orpa.css' rel='stylesheet' type='text/css' />
<script type="text/javascript" language="javascript" src='#Application.Settings.BaseURL#/script/orpa.js'></script>
</cfoutput>
<script type="text/javascript"><!--//--><![CDATA[//><!--

sfHover = function() {
	var sfEls = document.getElementById("nav").getElementsByTagName("LI");
	for (var i=0; i<sfEls.length; i++) {
		sfEls[i].onmouseover=function() {
			this.className+=" sfhover";
		}
		sfEls[i].onmouseout=function() {
			this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
		}
	}
}
if (window.attachEvent) window.attachEvent("onload", sfHover);

//--><!]]></script>


</head>

<body>

<div id="mainContainer">


<div id="mainHeader">
<img src="../images/logo/logo.png" /> 


<div id="navHorzContainer">
		<!-- <div class="navHorzImgfloatleft"></div> -->
<cfinvoke
	component="script.links" method="getParentLinks" returnvariable="nav_main" link_div_id="mn_nav_01">
</cfinvoke>
<cfoutput>
<!--- <cfdump var="#nav_main#"> --->
			<ul id="nav">
			<cfloop query="nav_main">
      	<li><a href="#Application.Settings.BaseURL##nav_main.link_url#">#nav_main.link_label#</a>
        <cfquery name="nav_sub" datasource="ieir_webro">
        	select link_label,link_url,link_target from site_links
          	where link_parent = #nav_main.link_id# and link_active = 'Y'
        </cfquery>
        <!--- <cfdump var="#nav_sub#"> --->
        <cfif nav_sub.RecordCount>
					<ul>
          <cfloop query="nav_sub">
          	<li class="navSub"><a href="#Application.Settings.BaseURL##nav_sub.link_url#" <cfif nav_sub.link_target NEQ "">target="#nav_sub.link_target#" </cfif>>#nav_sub.link_label#</a></li>
          </cfloop>
          <li class="navSubBottom"><a href="##"></a></li>
          </ul>
        </li>
        </cfif>
      </cfloop>
</cfoutput>
      </ul>

<!--		<div class="navHorzImgfloatright"></div>-->

	</div>  
	<div id="topLogin">
	<form>
	Username:
	<input type='text' class='textarea' />
	Password:
	<input type='password' class='textarea' />

	<input type='submit' value='Login' class='loginHeaderSubmit' name='Send' alt='Submit' />
	</form>
	</div>

</div>
   
<div class="clearFix"></div>

<div id="mainBody">



<!-- MAIN RIGHT --->
<div id="mainRight">


<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>VOC Items Browser</span></em></h5>
<p>
<!-- <img class='rightImg' src='../images/logo/star_200px.gif' /> -->
Use the Select box below to choose a voc item.  The details of the voc item will appear in the lower half of the window.<br />
<cfinvoke
	component="script.colleague" method="getVocList" returnvariable="cVocList">
</cfinvoke>
<form name="vocListForm">
<input type="hidden" name="lastShown" value="" />
<select class="cvoc_list" name="voc_list" size="1" width="60">
	<option value=''>- Select a VOC Item -</option>
  <cfif cVocList.RecordCount>
  <cfoutput>
    <cfloop query='cVocList'>
      <option value='#cVocList.vid#' onclick="javascript:toggleVocDisplay('#cVocList.vid#');document.vocListForm.lastShown.value='#cVocList.vid#';">#cVocList.voc_name#</option>
    </cfloop>
  </cfoutput>
	</cfif>
</select>
</form>
</p>
</div>

<div class="rightContent" >
<h4 class="blue linkage">Voc Item Details</h4>

<cfif cVocList.RecordCount>
	<cfoutput>
		<cfloop query="cVocList">
			<cfinvoke
				component='script.colleague' method='getVocDetails' returnvariable='cVocLines' vocid=#cVocList.vid#>
			</cfinvoke>
			<cfif cVocLines.RecordCount>
				<div id="#cVocList.vid#" class="rightContent" style="display:none">
					<h5 class="rubricHeading"><em><span>#cVocList.voc_name#</span></em></h5>
					<p align="left">        
					<cfloop query='cVocLines'>
						#cVocLines.vseq#&nbsp;&nbsp;&nbsp;#cVocLines.voc_item#<br />
					</cfloop>
					</p>
        </div>  
			</cfif>
		</cfloop>
	</cfoutput>
</cfif>
</div>


</div>

<!-- MAIN RIGHT END -->

<div id="mainLeft">

<!-- PRINCIPLES NAV -->

<div class="leftNavContainer" >
<h4 class="blue principles">IEIR Utilities</h4>
	<div class="navVertContainer">
		<ul>
			<li><a href="sentences.cfm">VOC Items Browser</a></li>
		</ul>
	</div>
</div>


<!-- PRINCIPLES NAV END -->

<!-- COMMUNICATION NAV -->
<div class="leftNavContainer" >

<h4 class="blue comm">Links</h4>
	<div class="navVertContainer">
		<ul>
      <li><a href="../st_folio/index.html">Quality Enhancement Program</a></li>
      <li><a href="../staff/index.html">IEIR Staff</a></li>
      <li><a href="../surveys/index.html">Surveys</a></li>
      <li><a href="../link.html">Information Resources</a></li>
      <li><a href="../reports/index.html">Reporting</a></li>
      <li><a href="../link.html">Accountability Reference</a></li>
      <li><a href="../link.html">Quick Facts</a></li>
		</ul>
	</div>
</div>
<!-- COMMUNICATION NAV END -->


<!-- <a href="http://mycampus.westtexas.tstc.edu/"><img src="images/logo/mycampus_logo.gif" alt="MyCampus" style="padding-left:5px; border: 0px;" /></a> -->



</div>
<!-- MAIN BODY END -->
</div>

<div id="mainFooter">

<div class='tstcFooter'>

<div class='tstcFooterImg'>

<img src="../images/logo/footer_logo.gif" alt="" />

</div>

<div class='tstcFooterContent'>
© 2007 Texas State Technical College

</div>
</div>


</div>

</div>
</body>
</html>
