<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EOC Enrollment Troubleshooting</title>
	<link href="./css/style.css" rel="stylesheet" type="text/css" />
	<link href="./css/orpa.css" rel="stylesheet" type="text/css" />
</head>

<body>

    <cfset getSections=''>
		<cfquery name="getSections" datasource="EOC">
    	select class, course_title, instructor_name, instructor_fname, instructor_id, LastDayToDrop, course_id
      	from course
        where LastDayToDrop = '02/19/2009'
    </cfquery>
    <table cellpadding="0" cellspacing="2" border="1">
    <tr>
    	<th align="left">Class</th>
    	<th align="left">Title</th>
    	<th align="left">Instr. Last</th>
    	<th align="left">Instr. First</th>
    	<th align="left">Instr. Id</th>
    	<th align="left">Last Day to Drop</th>
    	<th align="left">Crs Id</th>
		</tr>      
    <cfloop query="getSections">
			<cfoutput>
      <tr>
        <td align="left">#getSections.class#</td>
        <td align="left">#getSections.course_title#</td>
        <td align="left">#getSections.instructor_name#</td>
        <td align="left">#getSections.instructor_fname#</td>
        <td align="left">#getSections.instructor_id#</td>
        <td align="left">#getSections.LastDayToDrop#</td>
        <td align="left">#getSections.course_id#</td>
      </tr>      
      <tr>
      	<td>&nbsp;</td>
        <td colspan="6">
         	<table align="left" cellpadding="0" cellspacing="0" border="1">
            <tr>
              <th align="left">Class</th>
              <th align="left">Title</th>
              <th align="left">Student Last</th>
              <th align="left">Student First</th>
              <th align="left">Email</th>
            </tr>
      </cfoutput>
     	<cfquery name="getStudents" datasource='EOC'>
      	select stu_id from student where course_id = #getSections.course_id#
      </cfquery>
      <cfloop query="getStudents">
        <cfquery name="studentInfo" datasource="StuCourseInfo">
          select firstName, lastName, email from EAS_St_Address where studentId = '#getStudents.stu_id#'
        </cfquery>
        <cfoutput>
            	<tr>
              	<td align="left">#getSections.class#</td>
                <td align="left">#getSections.course_title#</td>
                <td align="left">#studentInfo.lastName#</td>
                <td align="left">#studentInfo.firstName#</td>
                <td align="left">#studentInfo.email#</td>
              </tr>
        </cfoutput>
      </cfloop>
      	</table>
      <cfoutput>
        </td>
      </tr>
      </cfoutput>
		</cfloop>
    </table>
</body>
</html>
