<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<cfquery name="insert_dr_final" datasource="ieir_assessment">
	insert into drr_11th_days values(#cohort#,'#term#',#loc#,'#program#','#major#',#new_stu#,#ret_stu#)
</cfquery>
<cflocation url="./drr_enter.cfm">  
</body>
</html>
