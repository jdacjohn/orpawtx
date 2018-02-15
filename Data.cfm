<!--- This is the data template --->
<cfparam name="OverRide" default="N">

<cfswitch expression="#Action#">
	<cfcase value="ProcessUserData">
		<cfinclude template="AddUserData.cfm">
	</cfcase>
	<cfcase value="EnterTask,EnterCommentData,DeleteLead,DeleteTask">
		<cfinclude template="LeadEntryData.cfm">
	</cfcase>
	<!--- Start Application Process Actions --->
	<cfcase value="AppPendingView,Process,UpdateApp,DeleteApp,MoveToPendingQueue,CancelPending,Unlock,AppStatusCheck,AppStatusCheckSubmit,AppStatusReport,GetCourseEval,GetCourseEvalSubmit">
		<cfinclude template="AppProcessData.cfm">
	</cfcase>
	<!--- End Application Process Actions --->
	<!--- Followup Queue actions --->
	<cfcase value="FollowUpQView,FollowUpDetails,FollowUpQSubmit,UnlockFollowUpQ,AddFollowupSubmit">
		<cfinclude template="FollowUpQData.cfm">
	</cfcase>
	<!--- End of Followup Queue actions --->
  
  <!--- Everything above this line is Benny's.  Just using for reference now --->
  
  <!--- Retention Calculations --->
  <cfcase value="RTC_Inst_Display">
  	<cfinclude template="./reports/data/ret_inst_calc_data.cfm">
  </cfcase>
</cfswitch>

