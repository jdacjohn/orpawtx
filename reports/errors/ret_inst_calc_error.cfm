<cfparam name="retspan" default="">
<cfparam name="fallselects" default="">
<cfparam name="semselects" default="">
<!--- <cfoutput>
We've made it inside ret_inst_calc_error.cfm<br />
The value of respan=#respan#<br />
</cfoutput> --->
<cfset cohortSelectError="">
<cfif ((retspan eq "fa2fa") and (fallselects eq "")) or ((retspan eq "sm2sm") and (semselects eq "")) or retspan eq "">
	<cfset cohortSelectError="You must select at least 1 Cohort to calculate retention!">
  <cfset Action="RTC_Inst">
</cfif>
