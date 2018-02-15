<div id="mainBody">
  <!--- MAIN RIGHT --->
  <div id="mainRight">
    <div class="rightContent" >
      <h4 class="blue instructional">TSTC West Texas Institutional Effectiveness & Information Research</h4>
      <h5 class="rubricHeading"><em><span>Accountability Standards - Success Contextual Measures</span></em></h5>
      <p> <cfoutput><img class='rightImg' src='#Application.Settings.ImageBaseLogos#/ieir_logo_200px.gif' /> </cfoutput>
      	Vestibulum luctus dolor a orci. Nulla at mi. Nam volutpat. Phasellus tempor. Nulla facilisi. Etiam ac mauris. 
        Nam venenatis. Cras suscipit dolor et elit. Aliquam a lorem et enim laoreet scelerisque. Duis egestas justo 
        a nibh. Nam at felis at erat dictum tempus. Nulla at risus ac tortor varius viverra. </p>
      <p>Proin enim. Etiam nec leo. Nam non nunc. Morbi risus nibh, porttitor at, molestie at, volutpat vulputate, 
        nisi. Pellentesque adipiscing tincidunt justo. Vivamus semper. Aliquam imperdiet. Integer sit amet mauris. 
        Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut sed ligula. Aliquam sit amet nibh. Vivamus 
        condimentum quam ut quam. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Integer semper elit in justo. </p>
    </div>
    <div class="rightContent" >
      <h4 class="blue linkage">Links</h4>
      <p>
        <cfinclude template="../body_links.cfm">
      </p>
    </div>
  </div>
  <!--- MAIN RIGHT END --->
  <div id="mainLeft">
    <!--- CTX NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue principles">Contextual Measures</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="success_ctx_links.cfm">
        </ul>
      </div>
    </div>
    <!--- CTX NAV END --->
    <!--- Key Measures NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue principles">Success</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="success_links.cfm">
        </ul>
      </div>
    </div>
    <!--- key measures NAV END --->
    <!--- Accountability NAV --->
    <div class="leftNavContainer" >
      <h4 class="blue comm">Accountabilty</h4>
      <div class="navVertContainer">
        <ul>
          <cfinclude template="accty_links.cfm">
        </ul>
      </div>
    </div>
    <!--- Accountability NAV END --->
  </div>
  <!--- MAIN BODY END --->
</div>
