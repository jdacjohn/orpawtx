<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Graph Test</title>
</head>

<body>
<h1>TSTC West Texas Program Trends Past 5 years</h1>

<cfchart format="flash" title="Paradigm Trends" showlegend="yes">
	<cfchartseries type="Line" seriescolor="##0033FF" serieslabel="Unduplicated Headcount">
  <cfchartdata item="FY06" value="2210" />
  <cfchartdata item="FY07" value="2069" />
  <cfchartdata item="FY08" value="2206" />
  <cfchartdata item="FY09" value="2438" />
  <cfchartdata item="FY10" value="2116" />
	</cfchartseries>
	<cfchartseries type="Line" seriescolor="##FF0000" serieslabel="Completions">
  <cfchartdata item="FY06" value="390" />
  <cfchartdata item="FY07" value="425" />
  <cfchartdata item="FY08" value="405" />
  <cfchartdata item="FY09" value="365" />
  <cfchartdata item="FY10" value="225" />
	</cfchartseries>
	<cfchartseries type="Line" seriescolor="##00FF00" serieslabel="Placements">
  <cfchartdata item="FY06" value="370" />
  <cfchartdata item="FY07" value="420" />
  <cfchartdata item="FY08" value="360" />
  <cfchartdata item="FY09" value="345" />
  <cfchartdata item="FY10" value="220" />
	</cfchartseries>
</cfchart>
</body>
</html>
