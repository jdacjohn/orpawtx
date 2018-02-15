<!--- Load all the report descriptions into an array so we can cut down on the number of db queries we use. --->
<!---<cfinvoke component='script.registration' method='getReportTitles' returnVariable='reportTitles'></cfinvoke>--->
<cfinvoke component='script.em' method='emPeriod' emTermCohort=#emCohort# returnVariable='reportDates'></cfinvoke>
<!--- Build an array so we'll know how many monthly calendars to create --->
<cfset months = ArrayNew(1)>
<cfset years = ArrayNew(1)>
<cfset monthNdx = 1>
<cfset currentMonth = 0>
<cfset currentYear = 0>
<cfset monthStarts = ArrayNew(1)>
<cfset monthEnds = ArrayNew(1)>
<cfloop index="i" from="1" to="#ArrayLen(reportDates)#">
	<cfif currentMonth neq Month(reportDates[i].rptDate)>
    <cfset currentMonth = Month(reportDates[i].rptDate)>
    <cfset currentYear = Year(reportDates[i].rptDate)>
    <cfset months[monthNdx] = currentMonth>
    <cfset years[monthNdx] = currentYear>
    <cfset monthStarts[monthNdx] = i>
    <cfif monthNdx gt 1>
    	<cfset monthEnds[monthNdx - 1] = i - 1>
    </cfif>
    <cfset monthNdx += 1>
  </cfif>
<!---  <cfoutput>#DateFormat(reportDates[i].rptDate,'yyyy-mm-dd')# Sequence: #reportDates[i].sequence# Month: #Month(reportDates[i].rptDate)# Day: #Day(reportDates[i].rptDate)# Year: #Year(reportDates[i].rptDate)#<br /></cfoutput> --->
</cfloop>
<!--- <cfoutput>Month Index = #monthNdx#<br /></cfoutput> --->
<cfset monthEnds[monthNdx - 1] = ArrayLen(reportDates)>
<!--- <cfoutput>Number of months in month array: #ArrayLen(months)#<br /></cfoutput>
<cfloop index="j" from="1" to="#monthNdx - 1#">
	<cfoutput>Month: #months[j]#  Year: #years[j]# MonthStart: #monthStarts[j]# MonthEnd: #monthEnds[j]#<br /></cfoutput>
</cfloop> --->

<cfset currentMonth = 0>
<cfset openCal = 0>
<cfset counter = 0>
<cfset days = 0>
<cfset firstReportDay = 0>
<cfloop index="ndx" from="1" to="#ArrayLen(months)#">
<!--- <cfoutput>Ndx = #ndx#<br /></cfoutput> --->
	<!--- If the month has changed, start a new calendar --->
  <cfif currentMonth neq months[ndx]>
  	<!--- Check to see if we need to close a previous month --->
  	<cfif openCal neq 0>
    	<cfoutput></table></cfoutput>
    </cfif>
    <!--- Start a new month --->
  	<cfoutput><br />
		<table border="0" cellspacing="0" cellpadding="0" width="175" height="150">
			<tr><th colspan="7" align="center">#MonthAsString(months[ndx])# #years[ndx]#</th></tr>
   		<tr>
   			<cfloop index="x" from="1" to="7">
      		<th align="center">#Left(dayOfWeekAsString(x),1)#</th>
   			</cfloop>
   		</tr>
    </cfoutput>
		<cfset firstOfTheMonth = createDate(years[ndx], months[ndx], 1)>
    <cfset dow = dayofWeek(firstOfTheMonth)>
    <cfset pad = dow - 1>
		<cfoutput><tr></cfoutput>
    <cfif pad gt 0>
    	<cfoutput><td colspan="#pad#">&nbsp;</td></cfoutput>
    </cfif>
    <cfset openCal = 1>
		<cfset days = daysInMonth(reportDates[monthStarts[ndx]].rptDate)>
    <!--- <cfoutput>Days in Month = #days#<br /></cfoutput> --->
    <cfset firstReportDay = day(reportDates[monthStarts[ndx]].rptDate)>
    <!--- <cfoutput>First Report Day = #firstReportDay#<br /></cfoutput> --->
		<cfset counter = pad + 1>
    <cfset lastFillDay = firstReportDay - 1>
    <!--- front fill calendar with non-linkable dates that precede the first report date in the month --->
    <cfloop index="y" from="1" to="#lastFillDay#">
       <cfoutput><td align="center">#y#</td></cfoutput>
       <cfset counter += 1>
       <cfif counter eq 8>
          <cfoutput></tr></cfoutput>
          <cfif y lt firstReportDay>
             <cfset counter = 1>
             <cfoutput><tr></cfoutput>
          </cfif>
       </cfif>
    </cfloop>
	</cfif>
	<!--- <cfoutput>Counter = #counter#<br /></cfoutput> --->
	<cfset dayCount = firstReportDay>
  <!--- <cfoutput>Day Count = #dayCount#<br /></cfoutput> --->
 	<!--- Only deal with dates belonging to the current month --->
	<cfloop index="x" from="#monthStarts[ndx]#" to="#monthEnds[ndx]#">
    <cfif dayCount lt day(reportDates[x].rptDate)>
    	<cfset endFill = day(reportDates[x].rptDate) - 1>
    	<cfloop index="j" from="#dayCount#" to="#endFill#">
    		<cfoutput><td align="center">#j#</td></cfoutput>
    		<cfset counter += 1>
    		<cfif counter is 8>
    			<cfoutput></tr></cfoutput>
      		<cfif j lt day(reportDates[monthEnds[ndx]].rptDate)>
      			<cfset counter = 1>
        		<cfoutput><tr></cfoutput>
      		</cfif>
    		</cfif>
      </cfloop>
			<cfset dayCount = day(reportDates[x].rptDate)>
    </cfif>
		<cfoutput><td align="center"><a href="./index.cfm?action=QL_WEM&sequence=#reportDates[x].sequence#&term=#reportDates[x].term#"><b>#day(reportDates[x].rptDate)#</b></a></td></cfoutput>
   	<cfset counter += 1>
   	<cfif counter is 8>
   		<cfoutput></tr></cfoutput>
    	<cfif dayCount lt day(reportDates[monthEnds[ndx]].rptDate)>
    		<cfset counter = 1>
     		<cfoutput><tr></cfoutput>
    	</cfif>
   	</cfif>
    <cfset dayCount += 1>
  </cfloop> <!--- End dates loop --->	

  <!--- back fill calendar with non-linkable dates that follow the last report date in the month --->
  <cfloop index="y" from="#dayCount#" to="#days#">
	  <cfoutput><td align="center">#y#</td></cfoutput>
    <cfset counter = counter + 1>
    <cfif counter is 8>
  	  <cfoutput></tr></cfoutput>
      <cfif y lt days>
    	  <cfset counter = 1>
        <cfoutput><tr></cfoutput>
      </cfif>
    </cfif>
  </cfloop>

	<cfif counter is not 8>
  	<cfset endPad = 8 - counter>
  	<cfoutput><td colspan="#endPad#">&nbsp;</td></tr></cfoutput>
	</cfif>

</cfloop>

<cfoutput>
</table>
</cfoutput>
