<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Post EM Finals to the DB</title>
</head>

<body>

<cfquery name="insert_em_final" datasource="ieir_assessment">
	insert into em_finals values(#cohort#,'#term#',#loc#,'#program#','#major#',#new_apps#,#proj_new#,#proj_ret#,#total_proj#,#pending#)
</cfquery>
<cflocation url="./em_enter.cfm">  
</body>
</html>

New Apps:  <cfinput type="text" name="new_aps"><br />
Proj New:  <cfinput type="text" name="proj_new"><br />
Proj Ret:  <cfinput type="text" name="proj_ret"><br />
Total Proj:  <cfinput type="text" name="total_proj"><br />
Pending:  <cfinput type="text" name="pending"><br />
