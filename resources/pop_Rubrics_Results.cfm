<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Populated Rubrics Results Table Script</title>
</head>

<body>
<h2>Calculating and Loading Rubrics Results</h2>
<h2>Calculating Baseline Statistics...</h2>
  <div >
    	<cfinvoke component='rubrics_rpt' method='popBaselineRubricResults' returnvariable="script_success"></cfinvoke>
 	</div>
<h2>Calculating Intermediate Statistics...</h2>
  <div >
    	<cfinvoke component='rubrics_rpt' method='popIntermediateRubricResults' returnvariable="script_success"></cfinvoke>
 	</div>
<h2>Calculating Capstone Statistics...</h2>
  <div >
    	<cfinvoke component='rubrics_rpt' method='popCapstoneRubricResults' returnvariable="script_success"></cfinvoke>
 	</div>

		
    
</body>

</html>
