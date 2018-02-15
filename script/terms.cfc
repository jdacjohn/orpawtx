<!--- This component contains methods for manipulating term info in the database. --->
<cfcomponent>

	<cffunction name="getAcadYear" access="public" returnType="string">
  	<cfargument name='terms' type='string' required='yes'>
    <cfset getYear=''>
    <cfquery name='getYear' datasource='#Application.Settings.IEIR_RO#'>
    	select acad_year from fiscal_years where terms = '#terms#'
    </cfquery>
    <cfreturn getYear.acad_year>
  </cffunction>
  
	<!--- Get the term associated with a cohort number. --->
	<cffunction name="getTerm" access="public" returntype="query">
		<cfargument name="varCohort" type="numeric" required="yes">
		<cfquery name="term" datasource="#Application.Settings.IEIR_RO#">
    	select term as fullTerm from year_terms where cohort = #varCohort#
    </cfquery>
		<cfreturn term>
	</cffunction>
  
  <!--- Get all active terms --->
  <cffunction name="getActiveTermsArray" access="public" returnType="array">
  	<cfset termArray=ArrayNew(1)>
    <cfset ndx=0>
    <cfset tQ=''>
    <cfquery name='tq' datasource="#Application.Settings.IEIR_RO#">
    	select term from year_terms where active = 'Y' order by cohort
    </cfquery>
    <cfloop query='tq'>
    	<cfset ndx += 1>
      <cfset termArray[ndx] = tq.term>
    </cfloop>
    <cfreturn termArray>
  </cffunction>

	<!--- Return a query with information about the last 5 full academic years. --->
  <cffunction name="getLast5YearsAndTerms" access="public" returntype="query">
  	<cfset yearsAndTerms=''>
    <cfquery name='getLast' datasource='#Application.Settings.IEIR_RO#'>
    	select seq from fiscal_years where latest = 'Y'
    </cfquery>
    <cfquery name='yearsAndTerms' datasource='#Application.Settings.IEIR_RO#'>
    	select seq, fy, acad_year, terms from fiscal_years where seq <= #getLast.seq# and seq >= #getLast.seq - 4#
      	order by seq
    </cfquery>
    <cfreturn yearsAndTerms>
  </cffunction>

</cfcomponent>