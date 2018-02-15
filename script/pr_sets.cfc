<!--- This component contains methods for managing and viewing program review documentation sets. --->
<cfcomponent>

	<!--- Get a list of Academic Years already in the table for program reviews. --->
	<cffunction name="getAYs" access="public" returntype="query">
		<cfset ays=''>
    <cfquery name="ays" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(ay) from doc_set where area="Prog_Rev" order by ay
    </cfquery>
 		<cfreturn ays>
	</cffunction>

	<!--- Get a restricted file list for view pr information --->
	<cffunction name="getDocsForYearAndProg" access="public" returntype="query">
		<cfargument name='acadYear' type='numeric' required='yes'>
    <cfargument name='prog' type='string' required='yes'>
		<cfset files=''>
    <cfquery name="files" datasource="#Application.Settings.IEIR_RO#">
    	select filename, doctype, title from doc_set 
      	where ay = #acadYear# and major = '#prog#' and area = 'Prog_Rev' 
      	order by title
    </cfquery>
 		<cfreturn files>
	</cffunction>

	<!--- Get a restricted file list for view pr information --->
	<cffunction name="getLimitedForYearAndProg" access="public" returntype="query">
		<cfargument name='acadYear' type='numeric' required='yes'>
    <cfargument name='prog' type='string' required='yes'>
		<cfset files=''>
    <cfquery name="files" datasource="#Application.Settings.IEIR_RO#">
    	select filename, doctype,title from doc_set 
      	where ay = #acadYear# and major = '#prog#' and area = 'Prog_Rev' and doctype in ('ENR','DEMO','LOS','NAR')
      	order by title
    </cfquery>
 		<cfreturn files>
	</cffunction>

	<!--- Get a list of Majors already in the table for program reviews. --->
	<cffunction name="getMajors" access="public" returntype="query">
		<cfset majors=''>
    <cfquery name="majors" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(major) from doc_set where area="Prog_Rev" order by major
    </cfquery>
 		<cfreturn majors>
	</cffunction>


	<!--- Get a list of Majors already in the table for program reviews. --->
	<cffunction name="getMajorsInYear" access="public" returntype="query">
		<cfargument name='acadYear' type='numeric' required='yes'>
		<cfset majors=''>
    <cfquery name="majors" datasource="#Application.Settings.IEIR_RO#">
    	select distinct(major) from doc_set where area="Prog_Rev" and ay = #acadYear# order by major
    </cfquery>
 		<cfreturn majors>
	</cffunction>

	<!--- Insert a document into the tables. --->
  <cffunction name="insertPRFile" access="public" returntype="struct">
		<cfargument name="prData" type="struct" required="yes">
    <!--- If we're replacing an existing file, delete the existing first --->
    <cfset isThere=''>
    <cfquery name='isThere' datasource='#Application.Settings.IEIR_RO#'>
    	select count(*) as count from doc_set
      	where area = '#prData.area#'
        	and ay = #prData.ay#
          and major = '#prData.major#'
          and doctype = '#prData.docType#'
    </cfquery>
    <cfif isThere.count gt 0>
    	<cfset delRes=''>
      <cfquery name='delRes' datasource='#Application.Settings.IEIR#'>
      	delete from doc_set where area = '#prData.area#' and ay = '#prData.ay#' and major = '#prData.major#' and doctype = '#prData.doctype#'
   		</cfquery>
    </cfif>
  	<cfset insertRes=''>
    <cfquery result="insertRes" datasource="#Application.Settings.IEIR#">
    	insert into doc_set values(null,'#prData.area#',#prData.ay#,'#prData.major#','#prData.docType#','#prData.fileName#', '#prData.title#')
    </cfquery>
    <cfreturn insertRes>
  </cffunction>
  
</cfcomponent>