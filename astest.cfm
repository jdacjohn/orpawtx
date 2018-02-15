<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Just a Test Page</title>
</head>

<body>
<h2>Test</h2>


<style type="text/css">
  .yui-tt {
    color: #444;
    font-size:110%;
    border: 1px solid #444;
    background-color: #FFC;
    padding: 10px;
    width:250px;
  }
</style>
<cftooltip
    autoDismissDelay="5000"
    hideDelay="250"
    preventOverlap="true"
    showDelay="200"
    <!---sourceForTooltip="URL"--->
    tooltip="<ul><li>A</li><li>B</li><li>C</li></ul>">

    Eat Me

</cftooltip>
<br />Rerunning runRetFigs to test outstanding registrations of returners...
<cfinvoke component='script.registration' method='runRetFigs'></cfinvoke>
<br /> Check the following tables on DEV:
ret_stats<br />
reg_outs<br />
</body>

</body>
</html>
