<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<cfform name='calTest' format="flash" skin="haloBlue" width="300" height="300">
<cfcalendar
	name='testCal'
  height='150'
  mask='yyyy-mm-dd'
  monthNames='JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC'
  width='200'
  selecteddate='2009-01-10'
  startrange='2009-02-11'
  endrange='2009-02-28'
>
</cfform>
</body>
</html>
