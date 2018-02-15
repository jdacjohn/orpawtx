<!--- This is the data template --->
<CFPARAM NAME="OverRide" DEFAULT="N">

<CFSWITCH EXPRESSION="#Action#">
	<CFCASE VALUE="ProcessUserData">
		<CFINCLUDE TEMPLATE="AddUserData.cfm">
	</CFCASE>
	<CFCASE VALUE="EnterTask,EnterCommentData,DeleteLead,DeleteTask">
		<CFINCLUDE TEMPLATE="LeadEntryData.cfm">
	</CFCASE>
	<!--- Start Application Process Actions --->
	<CFCASE VALUE="AppPendingView,Process,UpdateApp,DeleteApp,MoveToPendingQueue,CancelPending,Unlock,AppStatusCheck,AppStatusCheckSubmit,AppStatusReport,GetCourseEval,GetCourseEvalSubmit">
		<CFINCLUDE TEMPLATE="AppProcessData.cfm">
	</CFCASE>
	<!--- End Application Process Actions --->
	<!--- Followup Queue actions --->
	<CFCASE VALUE="FollowUpQView,FollowUpDetails,FollowUpQSubmit,UnlockFollowUpQ,AddFollowupSubmit">
		<CFINCLUDE TEMPLATE="FollowUpQData.cfm">
	</CFCASE>
	<!--- End of Followup Queue actions --->
</CFSWITCH>

