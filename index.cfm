<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>TSTC West Texas Institutional Effectiveness & Information Research</title>
  <meta name="ROBOTS" content="NOINDEX, NOFOLLOW" />
	<link href="./css/style.css" rel="stylesheet" type="text/css" />
	<link href="./css/orpa.css" rel="stylesheet" type="text/css" />
	<style><cfinclude template="./css/los.css" /></style>

  <script language="JavaScript" src="./script/orpa.js" type="text/javascript"></script>
  
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
		} // end function
		
		if (window.attachEvent) window.attachEvent("onload", sfHover);

		//--><!]]></script>

</head>

<body>
<div id="mainContainer">
<cfif Action EQ "">
	<cfoutput>Setting Default Action</cfoutput>
	<cfset Action = #Application.Settings.DefaultAction#>
</cfif>
<!---<cfoutput>
Action Value in /index.cfm = #Action#<br />
</cfoutput> --->

<CFTRY>

<!--- Turn off the system here by un-commenting the code below --->
<!--- <CFSET Action = "App_Home_Sys_Down"> --->

<!--- Set up Errors recordset --->
<CFSET Errors = #QueryNew('Message,FieldName,FieldValue')#>

<!--- Set up the security template --->
<!--- Get the id of the action --->
<cfquery name="getActionId" datasource="#Application.Settings.ActionsDSN_RO#">
	select actionID from actions where action = '#Action#'
</cfquery>
<cfif ListFind(Application.Settings.OpenActions,#getActionId.actionID#) EQ 0>
	<CFINCLUDE TEMPLATE="security.cfm">
</cfif>

<!--- Set up error handling template --->
<cfif ListFind(Application.Settings.ErrorList,ListLast(Action,"_")) NEQ 0>
	<cfinclude template="errors.cfm">
</cfif>
<!--- <cfoutput>
	Action Value after including errors.cfm = #Action#<br />
</cfoutput> --->

<!--- Set up Data template --->
<cfif ListFind(Application.Settings.DataList,ListLast(Action,"_")) NEQ 0>
	<cfinclude template="Data.cfm">
</cfif>

<!--- Include the menu templates here.  Menu is ALWAYS displayed. --->
<!--- <cfif ListFirst(Action, "_") NEQ "Login" AND MenuDisplay EQ "Y">
	<cfinclude template="menu.cfm">
</cfif> --->
<cfinclude template='menu.cfm'>

<CFSWITCH EXPRESSION="#Action#">
	<CFCASE VALUE="App_LogOut">
		<CFLOCK TIMEOUT="#CreateTimeSpan(0,0,0,10)#" SCOPE="Session">
      <cfset StructClear(Session)>
		</CFLOCK>
		<CFLOCATION URL="index.cfm">
	</CFCASE>
  
  <!--- Handle Errors a bit more elegantly --->
  <cfcase value="ERROR_WEB">
  	<cfinclude template="showError.cfm">
  </cfcase>
  
  <!--- User tried to access a restricted area of the site without being logged in. --->
  <cfcase value="Login">
  	<cfinclude template="login.cfm">
  </cfcase>
  <cfcase value="Login_Validate">
  	<cfinclude template="login_validate.cfm">
  </cfcase>
	
  <!--- ORPA Site Home Page --->
  <CFCASE VALUE="App_Home,App_Home_Sys_Down">
		<CFINCLUDE TEMPLATE="main.cfm">
	</CFCASE>
	
  <!--- QEP Subsite Pages --->
  <cfcase value='QEP_Home'>
  	<cfinclude template="./st_folio/main.cfm">
  </cfcase>
  <cfcase value='QEP_Rubrics'>
  	<cfinclude template='./st_folio/orpa_rubrics.cfm'>
  </cfcase>
  <cfcase value='QEP_TER'>
  	<cfinclude template='./st_folio/ter.cfm'>
  </cfcase>
  <cfcase value='QEP_AccuPlacer'>
  	<cfinclude template='./st_folio/accuplacer.cfm'>
  </cfcase>
  <cfcase value='QEP_Resources'>
  	<cfinclude template='./st_folio/resources.cfm'>
  </cfcase>
  <cfcase value='QEP_ResPCs'>
  	<cfinclude template='./st_folio/prog_comps.cfm'>
  </cfcase>
  
  <!--- QEP Subsite Pages - Rubrics --->
  <cfcase value='RUB_Defs'>
  	<cfinclude template='./st_folio/rubrics_def.cfm'>
  </cfcase>
  <cfcase value='RUB_Defs_CC'>
  	<cfinclude template='./st_folio/rubrics_cc.cfm'>
  </cfcase>
  <cfcase value='RUB_Progs'>
  	<cfinclude template='./st_folio/rubrics_progs.cfm'>
  </cfcase>
  <cfcase value='RUB_Program'>
  	<cfinclude template='./st_folio/rubrics_program.cfm'>
  </cfcase>
  <cfcase value='RUB_Assess'>
  	<cfinclude template='./st_folio/rubrics_assess.cfm'>
  </cfcase>
  <cfcase value='RUB_Pdf'>
  	<cfinclude template='./st_folio/rubrics_pdf.cfm'>
  </cfcase>
  
  <cfcase value='RUB_Submit,RUB_Submit_FindStudent'>
  	<cfinclude template='./st_folio/rubrics_sub_start.cfm'>
  </cfcase>
  <cfcase value='RUB_Submit_Entry'>
  	<cfinclude template='./st_folio/rubrics_entry.cfm'>
  </cfcase>
  <cfcase value='RUB_Submit_DB'>
  	<cfinclude template='./st_folio/rubrics_submit.cfm'>
  </cfcase> 
  <cfcase value='RUB_View,RUB_View_Select'>
  	<cfinclude template='./st_folio/rubrics_view_start.cfm'>
  </cfcase>
  <cfcase value='RUB_View_Selected'>
  	<cfinclude template='./st_folio/rubrics_view.cfm'>
  </cfcase>
  
  <cfcase value='RUB_RUBReports'>
  	<cfinclude template='./st_folio/rubrics_rpt.cfm'>
  </cfcase>
  <cfcase value='RUB_RUBReports_Sum'>
  	<cfinclude template='./st_folio/rubrics_rpt_sum2.cfm'>
  </cfcase>
  <cfcase value='RUB_RUBReports_EOT'>
  	<cfinclude template='./st_folio/rubrics_rpt_eot.cfm'>
  </cfcase>
  <cfcase value='RUB_RUBReports_COT'>
  	<cfinclude template='./st_folio/rubrics_rpt_cot.cfm'>
  </cfcase>
  <cfcase value='RUB_RUBReports_EOT_NS'>
  	<cfinclude template='./st_folio/rubrics_rpt_eot_ns.cfm'>
  </cfcase>
  <cfcase value='RUB_RUBReports_EOT_GR'>
  	<cfinclude template='./st_folio/rubrics_rpt_eot_gr.cfm'>
  </cfcase>


  <cfcase value='RUB_Admin'>
  	<cfinclude template='./st_folio/rubrics_admin.cfm'>
  </cfcase>
  
  <!--- QEP Subsite Pages - TER --->
  <cfcase value='TER_Test'>
  	<cfinclude template='./st_folio/ter_test.cfm'>
  </cfcase>

  <cfcase value='TER_TERReports'>
  	<cfinclude template='./st_folio/ter_rpt.cfm'>
  </cfcase>
  <cfcase value='TER_TERReports_Sum'>
  	<cfinclude template='./st_folio/ter_rpt_sum.cfm'>
  </cfcase>
  <cfcase value='TER_TERReports_EOT'>
  	<cfinclude template='./st_folio/ter_rpt_eot.cfm'>
  </cfcase>
  <cfcase value='TER_TERReports_COT'>
  	<cfinclude template='./st_folio/ter_rpt_cot.cfm'>
  </cfcase>
  <cfcase value='TER_TERReports_EOT_NS'>
  	<cfinclude template='./st_folio/ter_rpt_eot_ns.cfm'>
  </cfcase>
  <cfcase value='TER_TERReports_EOT_GR'>
  	<cfinclude template='./st_folio/ter_rpt_eot_gr.cfm'>
  </cfcase>
  
  <!--- QEP Subsite Pages - Accuplacer --->
  <cfcase value='ACP_Test'>
  	<cfinclude template='./st_folio/acp_test.cfm'>
  </cfcase>

  <cfcase value='ACP_ACPReports'>
  	<cfinclude template='./st_folio/acp_rpt.cfm'>
  </cfcase>
  <cfcase value='ACP_ACPReports_Sum'>
  	<cfinclude template='./st_folio/acp_rpt_sum.cfm'>
  </cfcase>
  <cfcase value='ACP_ACPReports_EOT'>
  	<cfinclude template='./st_folio/acp_rpt_eot.cfm'>
  </cfcase>
  <cfcase value='ACP_ACPReports_COT'>
  	<cfinclude template='./st_folio/acp_rpt_cot.cfm'>
  </cfcase>
  <cfcase value='ACP_ACPReports_EOT_NS'>
  	<cfinclude template='./st_folio/acp_rpt_eot_ns.cfm'>
  </cfcase>
  <cfcase value='ACP_ACPReports_EOT_GR'>
  	<cfinclude template='./st_folio/acp_rpt_eot_gr.cfm'>
  </cfcase>
  

  <!--- Staff Pages --->
  <cfcase value='Staff_Home'>
   	<cfinclude template='./staff/main.cfm'>
  </cfcase>
	<cfcase value="Staff_About">
   	<cfinclude template='./staff/about.cfm'>
  </cfcase>
	<cfcase value="Staff_Contact">
   	<cfinclude template='./staff/contact.cfm'>
  </cfcase>
	<cfcase value="Staff_Feedback">
   	<cfinclude template='./staff/feedback.cfm'>
  </cfcase>

  
  <!--- ORPA Surveys Pages --->
  <cfcase value='Surveys_Home'>
   	<cfinclude template='./surveys/main.cfm'>
  </cfcase>
	<cfcase value="Surveys_SSI">
   	<cfinclude template='./surveys/ssi.cfm'>
  </cfcase>
  <cfcase value="Surveys_NSI">
  	<cfinclude template="./surveys/nsi.cfm">
  </cfcase>
	<cfcase value="Surveys_EOC">
   	<cfinclude template='./surveys/eoc.cfm'>
  </cfcase>
  <cfcase value="Surveys_CCSSE">
  	<cfinclude template="./surveys/ccsse.cfm">
  </cfcase>
  <cfcase value="Surveys_ACE">
  	<cfinclude template="./surveys/ace.cfm">
  </cfcase>
  <cfcase value="Surveys_IOR">
  	<cfinclude template="./surveys/ior.cfm">
  </cfcase>
  
  <!--- Noel Levitz SSI Pages --->
  <cfcase value="NLSSI_0607">
  	<cfinclude template="./surveys/ssi0607.cfm">
  </cfcase>
  <cfcase value="NLSSI_0506">
  	<cfinclude template="./surveys/ssi0506.cfm">
  </cfcase>
  <cfcase value="NLSSI_0405">
  	<cfinclude template="./surveys/ssi0405.cfm">
  </cfcase>
  <cfcase value="NLSSI_0304">
  	<cfinclude template="./surveys/ssi0304.cfm">
  </cfcase>
  <cfcase value="NLSSI_0203">
  	<cfinclude template="./surveys/ssi0203.cfm">
  </cfcase>
  <cfcase value="NLSSI_0809">
  	<cfinclude template="./surveys/ssi0809.cfm">
  </cfcase>
  <cfcase value="NLSSI_1112">
  	<cfinclude template="./surveys/ssi1112.cfm">
  </cfcase>
  
  <!--- Non-Instructional Survey Pages --->
  <cfcase value="NSI_2007">
  	<cfinclude template="./surveys/nsi07.cfm">
  </cfcase>
  <cfcase value="NSI_2006">
  	<cfinclude template="./surveys/nsi06.cfm">
  </cfcase>

  <!--- ACE Survey Pages --->
  <cfcase value="ACE_2004">
  	<cfinclude template="./surveys/ace04.cfm">
  </cfcase>
  <cfcase value="ACE_2003">
  	<cfinclude template="./surveys/ace03.cfm">
  </cfcase>

    <!--- IEIR Reports Pages --->
  <cfcase value="Reports_Home">
   	<cfinclude template='./reports/main.cfm'>
  </cfcase>
	<cfcase value="Reports_CoreInd">
  	<cfinclude template="./reports/paradigm_trends.cfm">
  </cfcase>
	<cfcase value="Reports_CoreInd_PDF">
  	<cfinclude template="./reports/paradigm_trends_PDF.cfm">
  </cfcase>
	<cfcase value="Reports_CoreInd_Div">
  	<cfinclude template="./reports/paradigm_trends_div.cfm">
  </cfcase>
	<cfcase value="Reports_CoreInd_Div_PDF">
  	<cfinclude template="./reports/paradigm_trends_div_PDF.cfm">
  </cfcase>
	<cfcase value="Reports_CoreInd_Prog">
  	<cfinclude template="./reports/paradigm_trends_prog.cfm">
  </cfcase>
	<cfcase value="Reports_CoreInd_Prog_PDF">
  	<cfinclude template="./reports/paradigm_trends_prog_PDF.cfm">
  </cfcase>
	<cfcase value="Reports_CoreInd_Loc">
  	<cfinclude template="./reports/paradigm_trends_loc.cfm">
  </cfcase>
  <cfcase value="Reports_CoreInd_Loc_PDF">
  	<cfinclude template="./reports/paradigm_trends_loc_PDF.cfm">
  </cfcase>
  <cfcase value="Reports_CoreInd_Breakdown">
  	<cfinclude template="./reports/student_pops.cfm">
  </cfcase>
  <cfcase value="Reports_CoreInd_SS">
  	<cfinclude template="./reports/smart_start.cfm">
  </cfcase>
  <cfcase value="Reports_CoreInd_SS_PDF">
  	<cfinclude template="./reports/smart_start_pdf.cfm">
  </cfcase>
  <cfcase value="Reports_Term">
  	<cfinclude template="./reports/term_reports.cfm">
  </cfcase>
  <cfcase value="Reports_Term_CS">
  	<cfinclude template="./reports/term_report_cs.cfm">
  </cfcase>
  <cfcase value="CS_Drilldown">
  	<cfinclude template="./reports/cs_drilldown.cfm">
  </cfcase>
  <cfcase value="CS_Drilldown_Prog">
  	<cfinclude template="./reports/cs_drilldown_prog.cfm">
  </cfcase>
  <cfcase value="TR_Course_Compare">
  	<cfinclude template="./reports/course_compare.cfm">
  </cfcase>
  <cfcase value="TR_Prog_Success">
  	<cfinclude template="./reports/prog_success.cfm">
  </cfcase>
  <cfcase value="TR_Prog_Success_Run">
  	<cfinclude template="./reports/prog_report.cfm">
  </cfcase>
	<cfcase value="Reports_Retention">
  	<cfinclude template="./reports/retain.cfm">
  </cfcase>
	<cfcase value="Reports_Grads">
  	<cfinclude template="./reports/gradrates.cfm">
  </cfcase>
	<cfcase value="Reports_Demog">
  	<cfinclude template="./reports/sdemo.cfm">
  </cfcase>
	<cfcase value="Reports_Enroll">
  	<cfinclude template="./reports/enrollment.cfm">
  </cfcase>
  
  <!--- IEIR Reports - Core Indicators --->
  <cfcase value="RPTCI_PM">
  	<cfinclude template="./reports/coreinds_pm.cfm">
  </cfcase>
  <cfcase value="RPTCI_RetTypes">
  	<cfinclude template="./reports/retenttypes.cfm">
  </cfcase>
  <cfcase value="RPTCI_IPEDS">
  	<cfinclude template="./reports/coreinds_ipeds.cfm">
  </cfcase>
  <cfcase value="RPTCI_CB">
  	<cfinclude template="./reports/coreinds_cb.cfm">
  </cfcase>
  <cfcase value="RPTCI_Links">
  	<cfinclude template="./reports/coreinds_links.cfm">
  </cfcase>
  <cfcase value="RPTCI_RetCalc">
  	<cfinclude template="./reports/ret_calc.cfm">
  </cfcase>
  
  <!--- IEIR Reports - Retention Pages --->
  <cfcase value="Retention_Defs">
  	<cfinclude template="./reports/retentdefs.cfm">
  </cfcase>
  <cfcase value="Retention_Calc">
  	<cfinclude template="./reports/ret_calc.cfm">
  </cfcase>
  <cfcase value="RTC_Inst">
  	<cfinclude template="./reports/ret_inst.cfm">
  </cfcase>
  <cfcase value="RTC_Inst_Display">
  	<cfinclude template="./reports/ret_inst_show.cfm">
  </cfcase>
  <cfcase value="RTC_Cohort">
  	<cfinclude template="./reports/ret_cohort.cfm">
  </cfcase>
  <cfcase value="RTC_Cohort_Display">
  	<cfinclude template="./reports/ret_cohort_show.cfm">
  </cfcase>
  
  <!--- IEIR Reports - Graduation Rates --->
  
  
  <!--- IEIR Reports - Student Demographics --->
  
  <!--- IEIR Reports - Enrollment --->
	<cfcase value="Reports_Enr_Loc">
  	<cfinclude template="./reports/enr_loc.cfm">
  </cfcase>
	<cfcase value="Reports_Enr_Prog">
  	<cfinclude template="./reports/enr_prog.cfm">
  </cfcase>
  
  

	<!--- IEIR Accountability --->
  <cfcase value="Accty_Home">
  	<cfinclude template="./accty/main.cfm">
  </cfcase>

  <cfcase value="Accty_Participate">
  	<cfinclude template="./accty/partc.cfm">
  </cfcase>
  <cfcase value="Accty_Participate_Key">
  	<cfinclude template="./accty/partc_key.cfm">
  </cfcase>
  <cfcase value="Accty_Participate_Key1">
  	<cfinclude template="./accty/partc_key1.cfm">
  </cfcase>
  <cfcase value="Accty_Participate_Key2">
  	<cfinclude template="./accty/partc_key2.cfm">
  </cfcase>
  <cfcase value="Accty_Participate_Ctx">
  	<cfinclude template="./accty/partc_ctx.cfm">
  </cfcase>
  <cfcase value="Accty_Participate_Ctx1">
  	<cfinclude template="./accty/partc_ctx1.cfm">
  </cfcase>
  <cfcase value="Accty_Participate_Ctx2">
  	<cfinclude template="./accty/partc_ctx2.cfm">
  </cfcase>
  <cfcase value="Accty_Participate_Ctx3">
  	<cfinclude template="./accty/partc_ctx3.cfm">
  </cfcase>
  <cfcase value="Accty_Participate_Ctx4">
  	<cfinclude template="./accty/partc_ctx4.cfm">
  </cfcase>
  <cfcase value="Accty_Participate_Ctx5">
  	<cfinclude template="./accty/partc_ctx5.cfm">
  </cfcase>
  
  <cfcase value="Accty_Success">
  	<cfinclude template="./accty/success.cfm">
  </cfcase>

  <cfcase value="Accty_Success_Key">
  	<cfinclude template="./accty/success_key.cfm">
  </cfcase>
  <cfcase value="Accty_Success_Key1">
  	<cfinclude template="./accty/success_key1.cfm">
  </cfcase>
  <cfcase value="Accty_Success_Key2">
  	<cfinclude template="./accty/success_key2.cfm">
  </cfcase>
  <cfcase value="Accty_Success_Key3">
  	<cfinclude template="./accty/success_key3.cfm">
  </cfcase>
  <cfcase value="Accty_Success_Key4">
  	<cfinclude template="./accty/success_key4.cfm">
  </cfcase>
  <cfcase value="Accty_Success_Key5">
  	<cfinclude template="./accty/success_key5.cfm">
  </cfcase>

  <cfcase value="Accty_Success_Ctx">
  	<cfinclude template="./accty/success_ctx.cfm">
  </cfcase>
  <cfcase value="Accty_Success_Ctx1">
  	<cfinclude template="./accty/success_ctx1.cfm">
  </cfcase>
  <cfcase value="Accty_Success_Ctx2">
  	<cfinclude template="./accty/success_ctx2.cfm">
  </cfcase>
  <cfcase value="Accty_Success_Ctx3">
  	<cfinclude template="./accty/success_ctx3.cfm">
  </cfcase>
  <cfcase value="Accty_Success_Ctx4">
  	<cfinclude template="./accty/success_ctx4.cfm">
  </cfcase>

  <cfcase value="Accty_Exc">
  	<cfinclude template="./accty/excellence.cfm">
  </cfcase>
  <cfcase value="Accty_Exc_Key">
  	<cfinclude template="./accty/excellence_key.cfm">
  </cfcase>
  <cfcase value="Accty_Exc_Key1">
  	<cfinclude template="./accty/excellence_key1.cfm">
  </cfcase>

  <cfcase value="Accty_Exc_Ctx">
  	<cfinclude template="./accty/excellence_ctx.cfm">
  </cfcase>
  <cfcase value="Accty_Exc_Ctx1">
  	<cfinclude template="./accty/excellence_ctx1.cfm">
  </cfcase>
  <cfcase value="Accty_Exc_Ctx2">
  	<cfinclude template="./accty/excellence_ctx2.cfm">
  </cfcase>
  <cfcase value="Accty_Exc_Ctx3">
  	<cfinclude template="./accty/excellence_ctx3.cfm">
  </cfcase>
  <cfcase value="Accty_Exc_Ctx4">
  	<cfinclude template="./accty/excellence_ctx4.cfm">
  </cfcase>
  <cfcase value="Accty_Exc_Ctx5">
  	<cfinclude template="./accty/excellence_ctx5.cfm">
  </cfcase>

  <cfcase value="Accty_Research">
  	<cfinclude template="./accty/research.cfm">
  </cfcase>
  <cfcase value="Accty_Research_Key">
  	<cfinclude template="./accty/research_key.cfm">
  </cfcase>
  <cfcase value="Accty_Research_Ctx">
  	<cfinclude template="./accty/research_ctx.cfm">
  </cfcase>

  <cfcase value="Accty_IEE">
  	<cfinclude template="./accty/iee.cfm">
  </cfcase>
  <cfcase value="Accty_IEE_Key">
  	<cfinclude template="./accty/iee_key.cfm">
  </cfcase>
  <cfcase value="Accty_IEE_Key1">
  	<cfinclude template="./accty/iee_key1.cfm">
  </cfcase>
  <cfcase value="Accty_IEE_Key2">
  	<cfinclude template="./accty/iee_key2.cfm">
  </cfcase>
  <cfcase value="Accty_IEE_Key3">
  	<cfinclude template="./accty/iee_key3.cfm">
  </cfcase>

  <cfcase value="Accty_IEE_Ctx">
  	<cfinclude template="./accty/iee_ctx.cfm">
  </cfcase>
  <cfcase value="Accty_IEE_Ctx1">
  	<cfinclude template="./accty/iee_ctx1.cfm">
  </cfcase>
  <cfcase value="Accty_IEE_Ctx2">
  	<cfinclude template="./accty/iee_ctx2.cfm">
  </cfcase>
  <cfcase value="Accty_IEE_Ctx3">
  	<cfinclude template="./accty/iee_ctx3.cfm">
  </cfcase>

  <cfcase value="Accty_CIS">
  	<cfinclude template="./accty/cinfosys.cfm">
  </cfcase>
  <cfcase value="Accty_CIS_Enr">
  	<cfinclude template="./accty/cinfosys_enr.cfm">
  </cfcase>
  <cfcase value="Accty_CIS_SS">
  	<cfinclude template="./accty/cinfosys_ss.cfm">
  </cfcase>
  <cfcase value="Accty_CIS_Cost">
  	<cfinclude template="./accty/cinfosys_costs.cfm">
  </cfcase>
    
  <!--- IEIR Resources --->
  <cfcase value="IEIR_Home">
  	<cfinclude template="./ieir/main.cfm">
  </cfcase>
  <cfcase value="IEIR_Admin">
  	<cfinclude template="./ieir/admin.cfm">
  </cfcase>
  <cfcase value="IEIR_Admin_PR">
  	<cfinclude template="./ieir/admin_pr.cfm">
  </cfcase>
  <cfcase value="IEIR_Admin_PR_Add">
  	<cfinclude template="./ieir/admin_pr_add.cfm">
  </cfcase>
  <cfcase value="DocSet_Submit_DB">
  	<cfinclude template="./ieir/upload_pr_set.cfm">
  </cfcase>
  <cfcase value="IEIR_SntncBrws">
  	<cfinclude template="./ieir/sntncs.cfm">
  </cfcase>
  <cfcase value="IE_Prog_Rev">
  	<cfinclude template="./ieir/pr_view_main.cfm">
  </cfcase>
  <cfcase value="IEIR_PR_ViewLtd">
  	<cfinclude template="./ieir/pr_view_limited.cfm">
  </cfcase>
  <cfcase value="IEIR_PR_View">
  	<cfinclude template="./ieir/pr_view_full.cfm">
  </cfcase>
  <cfcase value="IE_Resources">
  	<cfinclude template="./ieir/resources_main.cfm">
  </cfcase>
  
  <!--- Quick Links --->
  <cfcase value='QL_Home'>
  	<cfinclude template="./quick/main.cfm">
  </cfcase>
  <cfcase value="QL_DRR">
  	<cfinclude template="./quick/drr.cfm">
  </cfcase>
  <cfcase value="QL_WEM">
  	<cfinclude template="./quick/enroll_monitor.cfm">
  </cfcase>
  <cfcase value="QL_BKS">
  	<cfinclude template="./quick/bkstore.cfm">
  </cfcase>
  <cfcase value="QL_RetStats">
  	<cfinclude template="./quick/ret_stats.cfm">
  </cfcase>
  <cfcase value="QL_RetStats_Prt">
  	<cfinclude template="./quick/printList.cfm">
  </cfcase>
  <cfcase value="QL_EM_Prt_Pending">
  	<cfinclude template="./quick/printPending.cfm">
  </cfcase>
  <cfcase value="QL_EM_Prt_New">
  	<cfinclude template="./quick/printNewApps.cfm">
  </cfcase>
  <cfcase value="QL_LOS">
  	<cfinclude template="./los/main.cfm">
  </cfcase>
  <cfcase value="QL_AppReg">
  	<cfinclude template="./quick/appreg_report.cfm">
  </cfcase>
  <cfcase value="QL_A2R_Prt_Applied">
  	<cfinclude template="./quick/printAllApps.cfm">
  </cfcase>
  
	<!--- Learning Outcomes --->

	<cfcase value="CL_LOS_Browse">
  	<cfinclude template="./cl_los/browse_main.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Browse_Class">
  	<cfinclude template="./cl_los/browse_by_class.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Browse_DISC">
  	<cfinclude template="./cl_los/browse_by_disc.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Browse_Rubric">
  	<cfinclude template="./cl_los/browse_by_rubric.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Browse_Outcome">
  	<cfinclude template="./cl_los/view_CLO.cfm">
  </cfcase>
  <cfcase value="CL_LOS_BrowseAdd_Outcome">
  	<cfinclude template="./cl_los/viewAdd_CLO.cfm">
  </cfcase>
  <cfcase value="CL_LOS_BrowseEdit_Outcome">
  	<cfinclude template="./cl_los/viewEdit_CLO.cfm">
  </cfcase>
  <cfcase value="LOS_Browse">
  	<cfinclude template="./los/outcomes.cfm">
  </cfcase>
  <cfcase value="LOS_CMS">
  	<cfinclude template="./los/cmaps.cfm">
  </cfcase>
  <cfcase value="LOS_Course">
  	<cfinclude template="./cl_los/los_course_main.cfm">
  </cfcase>
  <cfcase value="LOS_Entry">
  	<cfinclude template="./los/submitslo.cfm">
  </cfcase>
  <cfcase value="LOS_PL">
  	<cfinclude template="./los/los_pgm_main.cfm">
  </cfcase>
  <cfcase value="LOS_SA_Result">
  	<cfinclude template="./los/los_single_result.cfm">
  </cfcase>
  <cfcase value="LOS_Status">
  	<cfinclude template="./los/status_home.cfm">
  </cfcase>

	<!--- SLO Browse Pages --->

  <cfcase value="LOS_ViewCM_RO">
  	<cfinclude template="./los/viewCM_ro.cfm">
  </cfcase>
  <cfcase value="LOS_ViewMeasures_RO">
  	<cfinclude template="./los/viewMeasures_ro.cfm">
  </cfcase>

	<!--- SLO Admin Pages --->
	<!--- Course Level Admin Pages. --->

  <cfcase value="CL_LOS_AddMeasure">
  	<cfinclude template="./cl_los/cl_newMeasure.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Edit_AddMeasure">
  	<cfinclude template="./cl_los/cl_edit_newMeasure.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Admin">
  	<cfinclude template="./cl_los/los_course_admin.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Admin_Add">
  	<cfinclude template="./cl_los/los_course_add.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Admin_Copy">
  	<cfinclude template="./cl_los/copy_main.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Copy_DB">
  	<cfinclude template="./cl_los/copy_submit.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Admin_Delete">
  	<cfinclude template="./cl_los/delete_main.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Admin_Link">
  	<cfinclude template="./cl_los/link_lo_course.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Create_Link">
  	<cfinclude template="./cl_los/create_link.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Delete_Link">
  	<cfinclude template="./cl_los/deleteCourseLink.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Admin_Edit">
  	<cfinclude template="./cl_los/edit_main.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Edit_Class">
  	<cfinclude template="./cl_los/edit_by_class.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Delete_Class">
  	<cfinclude template="./cl_los/delete_by_class.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Edit_Major">
  	<cfinclude template="./cl_los/edit_by_major.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Edit_Rubric">
  	<cfinclude template="./cl_los/edit_by_rubric.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Edit_Outcome">
  	<cfinclude template="./cl_los/los_course_edit.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Manage_Links">
  	<cfinclude template="./cl_los/link_manage.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Submit_DB">
  	<cfinclude template="./cl_los/insertCLO.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Update_DB">
  	<cfinclude template="./cl_los/updateCLO.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Submit_Link">
  	<cfinclude template="./cl_los/insertCourseLink.cfm">
  </cfcase>
  <cfcase value="CL_LOS_SubmitMeasure_DB">
  	<cfinclude template="./cl_los/insertCLOM.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Edit_SubmitMeasure_DB">
  	<cfinclude template="./cl_los/edit_insertCLOM.cfm">
  </cfcase>
  <cfcase value="CLOS_EditSLO">
  	<cfinclude template="./cl_los/add_edit_measures.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Edit_Measures">
  	<cfinclude template="./cl_los/edit_edit_measures.cfm">
  </cfcase>
  <cfcase value="CLOS_UpdateMeasure_DB">
  	<cfinclude template="./cl_los/updateCLOM.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Edit_UpdateMeasure_DB">
  	<cfinclude template="./cl_los/edit_updateCLOM.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Admin_Add_XMeasure">
  	<cfinclude template="./cl_los/dellom.cfm">
  </cfcase>
  <cfcase value="CL_LOS_Edit_XMeasure">
  	<cfinclude template="./cl_los/edit_dellom.cfm">
  </cfcase>
  
  <!--- Program Level Admin Pages --->

  <cfcase value="LOS_AddMap">
  	<cfinclude template="./los/newmap.cfm">
  </cfcase>
  <cfcase value="LOS_AddMeasure">
  	<cfinclude template="./los/newMeasure.cfm">
  </cfcase>
  <cfcase value="LOS_Admin">
  	<cfinclude template="./los/admin.cfm">
  </cfcase>
  <cfcase value="LOS_DelLOM">
  	<cfinclude template="./los/dellom.cfm">
  </cfcase>
  <cfcase value="LOS_DelMap">
  	<cfinclude template="./los/delmap.cfm">
  </cfcase>
  <cfcase value="LOS_EditCM">
  	<cfinclude template="./los/modcm.cfm">
  </cfcase>
  <cfcase value="LOS_EditCMTop">
  	<cfinclude template="./los/modCMTop.cfm">
  </cfcase>
  <cfcase value="LOS_SubmitCMTop_DB">
  	<cfinclude template="./los/updateCMTop.cfm">
  </cfcase>
  <cfcase value="LOS_EditSLO">
  	<cfinclude template="./los/modslo.cfm">
  </cfcase>
  <cfcase value="LOS_NewCM">
  	<cfinclude template="./los/newcm.cfm">
  </cfcase>
  <cfcase value="LOS_NewSLO">
  	<cfinclude template="./los/newslo.cfm">
  </cfcase>
  <cfcase value="LOS_Submit_DB">
  	<cfinclude template="./los/insertLO.cfm">
  </cfcase>
  <cfcase value="LOS_SubmitLOMapping_DB">
  	<cfinclude template="./los/insertLOMapping.cfm">
  </cfcase>
  <cfcase value="LOS_SubmitMeasure_DB">
  	<cfinclude template="./los/insertLOM.cfm">
  </cfcase>
  <cfcase value="LOS_Update_DB">
  	<cfinclude template="./los/updateLO.cfm">
  </cfcase>
  <cfcase value="LOS_UpdateMeasure_DB">
  	<cfinclude template="./los/updateLOM.cfm">
  </cfcase>
  <cfcase value="LOS_UploadCMPDF">
  	<cfinclude template="./los/uploadCMPDF.cfm">
  </cfcase>
  <cfcase value="LOS_ViewMeasures">
  	<cfinclude template="./los/viewMeasures.cfm">
  </cfcase>

	<!--- Rubric Entry Pages --->
  <cfcase value="LOS_EnterRubric">
  	<cfinclude template="./los/rubform.cfm">
  </cfcase>
  <cfcase value="LOS_SubmitRubric_DB">
  	<cfinclude template="./los/insertRubric.cfm">
  </cfcase>
  
  <!--- SACS --->
  <cfcase value="SACS_Home">
  	<cfinclude template="./sacs/main.cfm">
  </cfcase>
	<cfcase value="SACS_Reaff">
  	<cfinclude template="./sacs/reaffirmation/main.cfm">
  </cfcase>
	<cfcase value="SACS_5YR">
  	<cfinclude template="./sacs/reaffirmation/5_yr_interim_rpt/main.cfm">
  </cfcase>
	<cfcase value="SACS_2005">
  	<cfinclude template="./sacs/reaffirmation/2004_report/complete_doc.cfm">
  </cfcase>

</CFSWITCH>
<CFCATCH>
	<cfif Mode neq 'DEV'>
	<CFMAIL
		TO="john.arnold@sweetwater.tstc.edu"
		FROM="noreply@sweetwater.tstc.edu"
		SUBJECT="ORPA_Web Error"
		TYPE="HTML"
	>
		<font face="Arial" size="2">
		<b>UserID:</b> <CFIF IsDefined('Session.UserID')>#Session.UserID#</CFIF><br>
		<b>Name:</b> <CFIF IsDefined('Session.Name')>#Session.Name#</CFIF><br>
		<b>ActionAccess:</b> <CFIF IsDefined('Session.ActionAccess')>#Session.ActionAccess#</CFIF><br>
		<b>Dept:</b> <CFIF IsDefined('Session.Dept')>#Session.Dept#</CFIF><hr>
		<b>Action:</b> #Action#<br>
		<b>Query String:</b>  #CGI.query_string#<br>
		<b>HTTP_REFERER:</b> #CGI.HTTP_REFERER#<br>
		<b>Path:</b> #CGI.Path_Translated#<br>
		<b>Browser:</b>  #CGI.http_user_agent#<br>
		<b>Date/Time:</b> #DateFormat(now(),'mm/dd/yyyy')# #TimeFormat(now(),'h:mm tt')#<br>
		<hr>
		<b>Message:</b><font color="red">#cfcatch.message#</font><br>
		<hr>
		<b>Detail:</b><font color="red">#cfcatch.detail#</font><br>
		<hr>
		<u><b>TagContext:</b></u><br>
		<CFLOOP INDEX="idx" FROM="1" TO="#ArrayLen(cfcatch.tagcontext)#">
			<CFSET sCurrent = cfcatch.tagcontext[idx]>
			#idx# #sCurrent["ID"]# (#sCurrent["LINE"]#,#sCurrent["COLUMN"]#) #sCurrent["TEMPLATE"]#<br>
		</CFLOOP>
		<CFIF IsDefined('Error') AND IsStruct(Error)>
			<b>Exception:</b> #Error.TYPE#<br>
			<b>Template:</b> #Error.Template#<br>
			#Error.Diagnostics#<br>
			#Error.generatedContent#<br>
		</CFIF>
		<CFIF IsDefined("Form.FieldNames")>
			<br><u><b>FormFields:</b></u><br>
			<CFLOOP List="#Form.FieldNames#" INDEX="IDX">
				<b>#IDX#:</b> #EVALUATE(IDX)#<br>
			</CFLOOP>
		</CFIF>
		</font>
	</CFMAIL>
  </cfif>
	<CF_FUL_Message Title="System Error" Type="FAILURE" Message="There has been a system error. This error has been reported to the webmaster so that it can be fixed. We apologize for the inconvenience." Abort="Yes">
</CFCATCH>
</CFTRY>
<!--- Add the footer include here --->
<cfinclude template="footer.cfm">
</body>
</html>

