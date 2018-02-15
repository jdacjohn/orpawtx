<div id="mainBody">
<!--- MAIN RIGHT --->
<div id="mainRight">
<div class="rightContent" >
<h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
<h5 class="rubricHeading"><em><span>Colleague VOC Items Browser</span></em></h5>
<p>
<!--- <img class='rightImg' src='../images/logo/star_200px.gif' /> --->
Use the Select box below to choose a voc item.  The details of the voc item will appear in the lower half of the window.<br />
<cfinvoke
	component="script.colleague" method="getVocList" returnvariable="cVocList">
</cfinvoke>
<form name="vocListForm">
<input type="hidden" name="lastShown" value="" />
<select class="cvoc_list" name="voc_list" size="1" width="60" onchange="eval(this.value);">
	<option value=''>- Select a VOC Item -</option>
  <cfif cVocList.RecordCount>
  <cfoutput>
    <cfloop query='cVocList'>
      <option value="javascript:toggleVocDisplay('#cVocList.vid#');document.vocListForm.lastShown.value='#cVocList.vid#';">#cVocList.voc_name#</option>
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
<!--- MAIN RIGHT END --->

<div id="mainLeft">
<!--- ieir Admin NAV --->
<div class="leftNavContainer" >
<h4 class="blue principles">I.E. Links</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="./ieir_links.cfm"></ul>
	</div>
</div>
<!--- ieir utilities NAV END --->
<!--- Site links NAV --->
<!--- <div class="leftNavContainer" >
<h4 class="blue comm">I.E. Links</h4>
	<div class="navVertContainer">
		<ul><cfinclude template="sb_body_links.cfm"></ul>
	</div>
</div> --->
<!--- Site links NAV END --->
</div>
<!--- MAIN BODY END --->
</div>
