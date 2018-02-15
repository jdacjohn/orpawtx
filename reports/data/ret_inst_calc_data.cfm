<!--- Make sure form fields are accessible --->
<cfparam name='retspan' default=''>
<cfparam name='fallselects' default=''>
<cfparam name='semselects' default=''>
<cfparam name='dev' default=''>
<cfparam name='pt' default=''>
<cfparam name='eth' default=''>
<cfparam name='ndev' default=''>
<cfparam name='byloc' default=''>
<!--- Convert some flags for processing the calculations --->

<!--- Process retention request for Fall-to-Fall --->
<cfif retspan eq "fa2fa">
	<cfinvoke	component="script.retention" method="getRetention" returnvariable="retentionSets" terms=#fallselects# term_inc=3 part_time=0></cfinvoke>
  <cfif dev eq "on">
		<cfinvoke component="script.retention" method="getRetentionDev" returnvariable="retentionSetsDev" terms=#fallselects# term_inc=3 dev_students=1></cfinvoke>
  </cfif>
  <cfif pt eq "on">
  	<cfinvoke component="script.retention" method="getRetention" returnvariable="retentionSetsPT" terms=#fallselects# term_inc=3 part_time=1></cfinvoke>
  </cfif>
  <cfif ndev eq "on">
  	<cfinvoke component="script.retention" method="getRetentionDev" returnVariable="retentionSetsNDev" terms=#fallselects# term_inc=3 dev_students=0></cfinvoke>
  </cfif>
<cfelse>
	<cfinvoke	component="script.retention" method="getRetention" returnvariable="retentionSets" terms=#semselects# term_inc=1 part_time=0></cfinvoke>
  <cfif dev eq "on">
		<cfinvoke component="script.retention" method="getRetentionDev" returnvariable="retentionSetsDev" terms=#semselects# term_inc=1 dev_students=1></cfinvoke>
  </cfif>
  <cfif pt eq "on">
  	<cfinvoke component="script.retention" method="getRetention" returnvariable="retentionSetsPT" terms=#semselects# term_inc=1 part_time=1></cfinvoke>
  </cfif>
  <cfif ndev eq "on">
  	<cfinvoke component="script.retention" method="getRetentionDev" returnVariable="retentionSetsNDev" terms=#semselects# term_inc=1 dev_students=0></cfinvoke>
  </cfif>
</cfif>
