<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Enter EM Finals</title>
</head>

<body>
<H4> EM Final Report Summary Entry - NON-Public</H4>
<p>This page is used as part of the set up process for the Enrollment Monitor.  For the current Term, enter the following information
for each program.  Before using this page, change the values of the cohort and term inputs to the current semester. 
cohort values increment by 1 from semester to semester. For locations, use the numeric designaotors:<br />
Sweetwater = 400<br />
Abilene = 460<br />
Brownwood = 470<br />
Breckenridge = 480<br />&nbsp;<br />
Leave the Program field blank.
</p>
<cfform name='em_entry' format="html" width="500" height="400" action="./post_em_finals.cfm">
Cohort:  <cfinput type="text" name="cohort" id="cohort" value="105"><br />
Term:  <cfinput type="text" name="term" value="2010/SP"><br />
Location:  <cfinput type="text" name="loc"><br />
Program:  <cfinput type="text" name="program"><br />
Major:  <cfinput type="text" name="major"><br />
New Apps:  <cfinput type="text" name="new_apps"><br />
Proj New:  <cfinput type="text" name="proj_new"><br />
Proj Ret:  <cfinput type="text" name="proj_ret"><br />
Total Proj:  <cfinput type="text" name="total_proj"><br />
Pending:  <cfinput type="text" name="pending"><br />
<cfinput type="submit" name="submit">
</cfform>
</body>
</html>
