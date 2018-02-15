<cfcomponent>

	<!--- Establish a Telnet Session to Colleague --->
	<cffunction name='openTelnet' access='public' returntype="struct">
  	<cfset sockContainer = StructNew()>
  	<cfset strResult=''>
    <cfset strCommand=''>
    <cfset crlf = CHR(13) & CHR(10)>
  	<!--- creating the object --->
   	<cfobject class="ActiveXperts.Tcp" type="com" name="objSocket" Action="Create">
   	<!--- connect to host --->
		<cfset objSocket.connect(Application.Settings.Telnet, Application.Settings.TelnetPort)>
    <cfset sockContainer.objSocket = objSocket>
   	<!--- log in --->
   	<cfif objSocket.LastError eq 0>
      <cfinvoke method='verifyReceiveData' promptString='login:' delay=0 openSocket='#sockContainer#'></cfinvoke>
   		<cfset objSocket.SendString(Application.Settings.TelnetUser)>
			<cfif objSocket.LastError eq 0>      
      	<cfinvoke method='verifyReceiveData' promptString='Password:' delay=0 openSocket='#sockContainer#'></cfinvoke>
	      <cfset objSocket.SendString(Application.Settings.TelnetPW)>
      <cfelse>
      	<cfoutput>Error occurred during login.<br /></cfoutput>
        <cfflush>
        <cfset sockContainer = StructNew()>
        <cfset sockContainer.objSocket = objSocket>
        <cfinvoke method='closeSocket' openSocket="#sockContainer#">
      	<cfabort>
      </cfif>
    <cfelse>
    	<cfset error = objSocket.LastError & ":" & objSocket.GetErrorDescription(objSocket.LastError)>
      <cfoutput>Telnet Connection Error Occurred.<br />#error#<br /></cfoutput>
   	</cfif>

   	<!--- Set session to Terminal --->
   	<cfif objSocket.LastError eq 0>	 
    	<cfset strCommand = "T">
     	<cfinvoke method='verifyReceiveData' promptString='Terminal or GUI? (T/G)->>' delay=0 openSocket='#sockContainer#'></cfinvoke>
<!---      <cfoutput>Returned from VerifiyReceiveData for "T"<br /></cfoutput>
      <cfflush> --->
			<cfset objSocket.SendString(strCommand)>
			<cfif objSocket.LastError neq 0>
      	<cfoutput>Error Occurred Selecting Terminal Mode<br /></cfoutput>
        <cfflush>
        <cfset sockContainer = StructNew()>
        <cfset sockContainer.objSocket = objSocket>
        <cfinvoke method='closeSocket' openSocket="#sockContainer#">
        <cfabort>
      </cfif>
   	</cfif>

   	<!--- Set 1 to indicate R18 Live --->
   	<cfif objSocket.LastError eq 0>	 
     	<cfset strCommand = "1">
     	<cfinvoke method='verifyReceiveData' promptString='(Please make a selection and press Enter)' delay=0 openSocket='#sockContainer#'></cfinvoke>
<!---      <cfoutput>Returned from Sys Select<br /></cfoutput>
      <cfflush> --->
			<cfset objSocket.SendString(strCommand)>
			<cfif objSocket.LastError neq 0>
      	<cfoutput>Error Occurred In System Select Menu<br /></cfoutput>
        <cfflush>
        <cfset sockContainer = StructNew()>
        <cfset sockContainer.objSocket = objSocket>
        <cfinvoke method='closeSocket' openSocket="#sockContainer#">
        <cfabort>
      </cfif>
   	</cfif>


   	<!--- Send Database Password --->
   	<cfif objSocket.LastError eq 0>
     	<cfinvoke method='verifyReceiveData' promptString="Enter Database Password for User 'jarnold':" delay=0 openSocket='#sockContainer#'></cfinvoke>
<!---      <cfoutput>Returned from Database Password Prompt<br /></cfoutput>
      <cfflush> --->
     	<cfset objSocket.SendString(Application.Settings.TelnetPW)>
			<cfif objSocket.LastError neq 0>
      	<cfoutput>Error Occurred Sending Database Password<br /></cfoutput>
        <cfflush>
        <cfset sockContainer = StructNew()>
        <cfset sockContainer.objSocket = objSocket>
        <cfinvoke method='closeSocket' openSocket="#sockContainer#">
        <cfabort>
      </cfif>
   	</cfif>

   	<!--- Send CRLF to nav past intro screen, then 1 to enter location code --->
		<!--- login sequence has changed in R18 - this part is no longer necessary - for the time being anyway... --->
   	<!--- <cfif objSocket.LastError eq 0>	 
     	<cfset objSocket.SendString(crlf)>
      <cfset objSocket.Sleep(2000)>
      <cfset objSocket.SendString("1")>
   	</cfif> --->

		<!--- Wait for the Colon Prompt --->
    <cfif objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#sockContainer#'></cfinvoke>
    <cfelse>
  		<cfset sockContainer = StructNew()>
  		<cfset sockContainer.objSocket = objSocket>
  		<cfinvoke method='closeSocket' openSocket="#sockContainer#">
			<cfoutput>Method Failed Waiting for Colon Prompt<br /></cfoutput>
  		<cfflush>
  		<cfabort>
		</cfif>

		<!--- Debug Abort Code
      <cfset sockContainer = StructNew()>
      <cfset sockContainer.objSocket = objSocket>
      <cfinvoke method='closeSocket' openSocket="#sockContainer#">
      <cfoutput>SUCCESS<br /></cfoutput>
      <cfflush>
      <cfabort>
    End Debug Abort Code --->

    <!--- Return the open socket connection --->
    <cfreturn sockContainer>
  </cffunction>

  <!--- receive the results --->
  <cffunction name='receiveData' access='private'>
  	<cfargument name='delay' type='numeric' required='yes'>
    <cfargument name='openSocket' type='struct' required='yes'>
    <cfset objSocket = openSocket.objSocket>
    <cfset crlf= CHR(13) & CHR(10)>
		<cfloop condition = "objSocket.HasData() eq -1">
    	<cfset strOutput = openSocket.objSocket.ReceiveString()>
			<cfoutput>#strOutput#<br /></cfoutput>
      <cfset openSocket.objSocket.Sleep(delay)>
    </cfloop>
	</cffunction>
  
  <!--- Loop for the right receiveString --->
  <cffunction name='verifyReceiveData' access='private'>
  	<cfargument name='delay' type='numeric' required='yes'>
    <cfargument name='promptString' type='string' required='yes'>
    <cfargument name='openSocket' type='struct' required='yes'>
    <cfif openSocket.objSocket.HasData()>
    	<cfset strOutput = openSocket.objSocket.ReceiveString()>
    <cfelse>
    	<cfset strOutput = ''>
    </cfif>
<!---   	<cfoutput>Initial Receive String in VerifyReceiveData is: #strOutput#<br /></cfoutput>
   	<cfflush> --->
		<cfloop condition = "#strOutput# neq #Trim(promptString)#">
      <cfset openSocket.objSocket.Sleep(delay)>
    	<cfset strOutput = Trim(openSocket.objSocket.ReceiveString())>
			<cfif strOutput neq ''>
				<cfoutput>#strOutput#<br /></cfoutput>
  	    <cfflush>
        <cfif strOutput eq 'Enter <New line> to continue...'>
          <cfset openSocket.objSocket.SendString(crlf)>
        </cfif>
      </cfif>
      <cfset openSocket.objSocket.Sleep(delay)>
    </cfloop>
	</cffunction>

  <!--- close the object --->
  <cffunction name="closeSocket" access='public'>
  	<cfargument name='openSocket' type='struct' required='yes'>
    <cfset crlf= CHR(13) & CHR(10)>
    <!--- Exit session properly --->
    <cfset openSocket.objSocket.SendString(crlf)>
   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfset openSocket.objSocket.SendString("quit")>
   	<cfinvoke method='verifyReceiveData' promptString="(Please make a selection and press Enter)" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfset openSocket.objSocket.SendString("7")>
    <cfset openSocket.objSocket.Disconnect()>
	</cffunction>
  
	<!--- Run the L.O. CS Scripts --->
  <cffunction name='runCS' access='public' returnType='struct'>
  	<cfargument name='openSocket' type='struct' required='yes'>
    <cfset crlf= CHR(13) & CHR(10)>
   	<!--- Invoke the colleague command that will run the Scripts --->
    <cfset openSocket.objSocket.SendString("JARNOLD.LO.CRSRECS")>
    <cfoutput>Running Course Recs Query JARNOLD.LO.CRSRECS<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="ENTER FIRST DIGIT OF LOCATION" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfif openSocket.objSocket.LastError eq 0>
			<cfset openSocket.objSocket.SendString(Application.Settings.CollegeLoc)>
    	<cfoutput>#Application.Settings.CollegeLoc#<br /></cfoutput>
    	<cfflush>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending College Location<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

   	<cfinvoke method='verifyReceiveData' promptString="Enter Term:" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfif openSocket.objSocket.LastError eq 0>
			<cfset openSocket.objSocket.SendString(Application.Settings.LOCollTerm)>
    	<cfoutput>#Application.Settings.LOCollTerm#<br /></cfoutput>
    	<cfflush>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Command<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

		<!--- Return the open socket to the sender --->
		<cfreturn openSocket>    
  </cffunction>
  
	<!--- Download LO Course Rec Data --->
	<cffunction name='downloadCSData' access='public' returntype="string">
  	<cfset strResult=''>
    <cfset strCommand=''>
    <cfset crlf = CHR(13) & CHR(10)>
  	<!--- creating the object --->
   	<cfobject class="ActiveXperts.FtpServer" type="com" name="objFtp" Action="Create">
   	<!--- connect to host --->
		<cfset objFtp.connect(Application.Settings.FTP, Application.Settings.FTPUser, Application.Settings.FTPPW)>
		<!--- ChangeDir to _HOLD_ --->
		<cfif objFtp.LastError eq "0">
    	<cfset objFtp.ChangeDir(Application.Settings.FTPDir)>
    </cfif>
    <!--- Transfer the CRSRECS file to local --->
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("jarnold_lo_crsrecs.txt", Application.Settings.FTPInDir & "jarnold_lo_crsrecs.txt")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("jarnold_lo_crsrecs.txt")>
      </cfif>
		</cfif>
    <cfif objFtp.LastError eq "0">
    	<cfset result=0>
    <cfelse>
    	<cfset result=objFtp.LastError & ": " & objFtp.GetErrorDescription(objFtp.LastError)>
    </cfif>
    <cfset objFtp.Disconnect()>
    <cfreturn result>      
	</cffunction>      

	<!--- Load the LO Course Data into tables --->
  <!--- This is a destructive load for current term data. All data in tables for the current term will be deleted prior to load --->
	<cffunction name='loadCSData' access='public'>
    <!--- Load the CRSRECS --->
  	<cfquery result="delCRSResults" datasource='#Application.Settings.IEIR#'>
    	delete from lo_course 
      	where term = '#Application.Settings.LOCollTerm#'
        	and substring(class,length(class) - 3) like '#Application.Settings.CollegeLoc#%'
    </cfquery>
    <cfquery result='loadCRSResults' datasource='#Application.Settings.IEIR#'>
			load data local infile '#Application.Settings.LOCrsRecsFile#' 
  			into table lo_course 
  			fields terminated by '\t' 
  			enclosed by '' 
  			lines terminated by '\n' 
  			(stu_id, course_id, class, course_title, instructor_name, instructor_fname, instructor_id, term, LastDayToDropStr, StartDateStr, EndDateStr)
 		</cfquery>
    <cfquery result='updateLDTDDate' datasource='#Application.Settings.IEIR#'>
    	update lo_course set LastDayToDrop =
      	concat('20',substr(LastDayToDropStr,7,2),'-',substr(LastDayToDropStr,1,2),'-',substr(LastDayToDropStr,4,2))
        where LastDayToDropStr != '' 
        	and term = '#Application.Settings.LOCollTerm#'
          and substring(class,length(class) - 3) like '#Application.Settings.CollegeLoc#%'
    </cfquery>
    <cfquery result='updateStartDate' datasource='#Application.Settings.IEIR#'>
    	update lo_course set StartDate =
      	concat('20',substr(StartDateStr,7,2),'-',substr(StartDateStr,1,2),'-',substr(StartDateStr,4,2))
        where StartDateStr != '' 
        	and term = '#Application.Settings.LOCollTerm#'      	
          and substring(class,length(class) - 3) like '#Application.Settings.CollegeLoc#%'
    </cfquery>
    <cfquery result='updateEndDate' datasource='#Application.Settings.IEIR#'>
    	update lo_course set EndDate =
      	concat('20',substr(EndDateStr,7,2),'-',substr(EndDateStr,1,2),'-',substr(EndDateStr,4,2))
        where EndDateStr != '' 
        	and term = '#Application.Settings.LOCollTerm#'
          and substring(class,length(class) - 3) like '#Application.Settings.CollegeLoc#%'
    </cfquery>
  </cffunction>

	<!--- Run the EAS Scripts --->
  <cffunction name='runEAS' access='public' returnType='struct'>
  	<cfargument name='openSocket' type='struct' required='yes'>
    <cfset crlf= CHR(13) & CHR(10)>
   	<!--- Invoke the colleague command that will run the first of the 5 EAS Scripts --->
    <cfset openSocket.objSocket.SendString("JARNOLD.EAS.CRSRECS")>
    <cfoutput>Running Course Recs Query JARNOLD.EAS.CRSRECS<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="Enter Term:" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfif openSocket.objSocket.LastError eq 0>
			<cfset openSocket.objSocket.SendString(Application.Settings.EASTerm)>
    	<cfoutput>#Application.Settings.EASTerm#<br /></cfoutput>
    	<cfflush>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Command<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

   	<!--- Invoke the colleague command that will run the 2nd of the 5 EAS Scripts --->
    <cfset openSocket.objSocket.SendString("JARNOLD.EAS.PHONES")>
    <cfoutput>Running Phones Query JARNOLD.EAS.PHONES<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="ENTER TERM" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfif openSocket.objSocket.LastError eq 0>
			<cfset openSocket.objSocket.SendString(Application.Settings.EASTerm)>
    	<cfoutput>#Application.Settings.EASTerm#<br /></cfoutput>
    	<cfflush>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Command<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

   	<!--- Invoke the colleague command that will run the 3rd of the 5 EAS Scripts --->
    <cfset openSocket.objSocket.SendString("JARNOLD.EAS.ST.ADDRESSES")>
    <cfoutput>Running Student Addresses Query JARNOLD.EAS.ST.ADDRESSES<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="ENTER TERM" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfif openSocket.objSocket.LastError eq 0>
			<cfset openSocket.objSocket.SendString(Application.Settings.EASTerm)>
    	<cfoutput>#Application.Settings.EASTerm#<br /></cfoutput>
    	<cfflush>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Command<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>
    
   	<!--- Invoke the colleague command that will run the 4th of the 5 EAS Scripts --->
    <cfset openSocket.objSocket.SendString("JARNOLD.EAS.STUDENT.LOCS")>
    <cfoutput>Running Student Location Query JARNOLD.EAS.STUDENT.LOCS<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="Enter Term" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfif openSocket.objSocket.LastError eq 0>
			<cfset openSocket.objSocket.SendString(Application.Settings.EASTerm)>
    	<cfoutput>#Application.Settings.EASTerm#<br /></cfoutput>
    	<cfflush>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Command<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

   	<!--- Invoke the colleague command that will run the 5th of the 5 EAS Scripts --->
    <cfset openSocket.objSocket.SendString("JARNOLD.EAS.STURECS")>
    <cfoutput>Running Student Query JARNOLD.EAS.STURECS<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="ENTER TERM:" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfif openSocket.objSocket.LastError eq 0>
			<cfset openSocket.objSocket.SendString(Application.Settings.EASTerm)>
    	<cfoutput>#Application.Settings.EASTerm#<br /></cfoutput>
    	<cfflush>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Command<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

		<!--- Return the open socket to the sender --->
		<cfreturn openSocket>    
  </cffunction>
  
	<!--- Download EAS Data --->
	<cffunction name='downloadEASData' access='public' returntype="string">
  	<cfset strResult=''>
    <cfset strCommand=''>
    <cfset crlf = CHR(13) & CHR(10)>
  	<!--- creating the object --->
   	<cfobject class="ActiveXperts.FtpServer" type="com" name="objFtp" Action="Create">
   	<!--- connect to host --->
		<cfset objFtp.connect(Application.Settings.FTP, Application.Settings.FTPUser, Application.Settings.FTPPW)>
		<!--- ChangeDir to _HOLD_ --->
		<cfif objFtp.LastError eq "0">
    	<cfset objFtp.ChangeDir(Application.Settings.FTPDir)>
    </cfif>
    <!--- Transfer the CRSRECS file to local --->
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("jarnold_eas_crsrecs.txt", Application.Settings.FTPInDir & "jarnold_eas_crsrecs.txt")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("jarnold_eas_crsrecs.txt")>
      </cfif>
		</cfif>
    <!--- Transfer the PHONES file to local --->
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("jarnold_eas_phones.txt", Application.Settings.FTPInDir & "jarnold_eas_phones.txt")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("jarnold_eas_phones.txt")>
      </cfif>
		</cfif>
    <!--- Transfer the ADDRESSES file to local --->
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("jarnold_eas_st_addresses.txt", Application.Settings.FTPInDir & "jarnold_eas_st_addresses.txt")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("jarnold_eas_st_addresses.txt")>
      </cfif>
		</cfif>
    <!--- Transfer the STU LOCS file to local --->
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("jarnold_eas_stulocs.txt", Application.Settings.FTPInDir & "jarnold_eas_stulocs.txt")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("jarnold_eas_stulocs.txt")>
      </cfif>
		</cfif>
    <!--- Transfer the STURECS file to local --->
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("jarnold_eas_sturecs.txt", Application.Settings.FTPInDir & "jarnold_eas_sturecs.txt")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("jarnold_eas_sturecs.txt")>
      </cfif>
		</cfif>

    <cfif objFtp.LastError eq "0">
    	<cfset result="0:  Success">
    <cfelse>
    	<cfset result=objFtp.LastError & ": " & objFtp.GetErrorDescription(objFtp.LastError)>
    </cfif>
    <cfset objFtp.Disconnect()>
    <cfreturn result>      
	</cffunction>      

	<!--- Load the EAS Data into tables in the EAS_Stucourseinfo DB --->
  <!--- This is a destructive load. All data in tables will be deleted prior to load --->
	<cffunction name='loadEASData' access='public'>
    <!--- Load the CRSRECS --->
  	<cfquery result="delCRSResults" datasource='EAS'>
    	delete from eas_course
    </cfquery>
    <cfquery result='loadCRSResults' datasource='EAS'>
			load data local infile '#Application.Settings.EASCrsRecsFile#' 
  			into table eas_course 
  			fields terminated by '\t' 
  			enclosed by '' 
  			lines terminated by '\n' 
  			(stu_id, course_id, class, course_title, instructor_name, instructor_fname, instructor_id, term, LastDayToDropStr, StartDateStr, EndDateStr)
 		</cfquery>
    <cfquery result='updateLDTDDate' datasource='EAS'>
    	update eas_course set LastDayToDrop =
      	concat('20',substr(LastDayToDropStr,7,2),'-',substr(LastDayToDropStr,1,2),'-',substr(LastDayToDropStr,4,2))
    </cfquery>
    <cfquery result='updateStartDate' datasource='EAS'>
    	update eas_course set StartDate =
      	concat('20',substr(StartDateStr,7,2),'-',substr(StartDateStr,1,2),'-',substr(StartDateStr,4,2))
    </cfquery>
    <cfquery result='updateEndDate' datasource='EAS'>
    	update eas_course set EndDate =
      	concat('20',substr(EndDateStr,7,2),'-',substr(EndDateStr,1,2),'-',substr(EndDateStr,4,2))
    </cfquery>
        
		<!--- Load the Phone records --->
  	<cfquery result="delPhoneResults" datasource='EAS'>
    	delete from eas_phones
    </cfquery>
    <cfquery result='loadPhonesResults' datasource='EAS'>
			load data local infile '#Application.Settings.EASPhonesFile#' 
  			into table eas_phones 
  			fields terminated by '\t' 
  			enclosed by '' 
  			lines terminated by '\n' 
  			(studentid, phoneType, phoneNumber)
 		</cfquery>    
		<!--- Load the Address records --->
  	<cfquery result="delAddressResults" datasource='EAS'>
    	delete from eas_st_address
    </cfquery>
    <cfquery result='loadAddressResults' datasource='EAS'>
			load data local infile '#Application.Settings.EASAddressesFile#' 
  			into table eas_st_address 
  			fields terminated by '\t' 
  			enclosed by '' 
  			lines terminated by '\n' 
  			(studentId, firstName, lastName, bestAddress, city, state, zip, phone, email)
 		</cfquery>    
		<!--- Load the LOC records --->
  	<cfquery result="delLocResults" datasource='EAS'>
    	delete from eas_stu_locs
    </cfquery>
    <cfquery result='loadLocsResults' datasource='EAS'>
			load data local infile '#Application.Settings.EASLocsFile#' 
  			into table eas_stu_locs
  			fields terminated by '\t' 
  			enclosed by '' 
  			lines terminated by '\n' 
  			(StudentID, StudentLoc)
 		</cfquery>    
		<!--- Load the STUREC records --->
  	<cfquery result="delSturecResults" datasource='EAS'>
    	delete from eas_student
    </cfquery>
    <cfquery result='loadStuRecsResults' datasource='EAS'>
			load data local infile '#Application.Settings.EASStuRecsFile#' 
  			into table eas_student
  			fields terminated by '\t' 
  			enclosed by '' 
  			lines terminated by '\n' 
  			(stu_id, last_name, first_name, course_id, course_title, active_program, LocationCode)
 		</cfquery>    

  </cffunction>

	<!--- Run the Daily Reg Report --->
  <cffunction name='runRegReport' access='public' returnType='struct'>
  	<cfargument name='openSocket' type='struct' required='yes'>
    <cfargument name='regDate' type='string' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfset crlf= CHR(13) & CHR(10)>
   	<!--- Invoke the colleague command that will run the daily reg report --->
    <cfset openSocket.objSocket.SendString("JARNOLD.REG.MAJOR")>
    <cfoutput>JARNOLD.REG.MAJOR<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="Enter Reg. Date (mm/dd/yy)" delay=0 openSocket='#openSocket#'></cfinvoke>
    <!--- Send the Date or report an error and abort--->
		<cfif openSocket.objSocket.LastError eq 0>
		  <cfset openSocket.objSocket.SendString(regDate)>
    	<cfoutput>#regDate#<br /></cfoutput>
    	<cfflush> 
	   	<cfinvoke method='verifyReceiveData' promptString="Enter Term" delay=0 openSocket='#openSocket#'></cfinvoke>
			<cfset openSocket.objSocket.SendString(term)>
    	<cfoutput>#term#<br /></cfoutput>
    	<cfflush>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Command<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>
		<!--- Return the open socket to the sender --->
		<cfreturn openSocket>    
  </cffunction> <!--- end function runRegReport() --->
  
	<!--- download Reg Data --->
	<cffunction name='downloadRegData' access='public' returntype="string">
  	<cfset sockContainer = StructNew()>
  	<cfset strResult=''>
    <cfset strCommand=''>
    <cfset crlf = CHR(13) & CHR(10)>
  	<!--- creating the object --->
   	<cfobject class="ActiveXperts.FtpServer" type="com" name="objFtp" Action="Create">
   	<!--- connect to host --->
		<cfset objFtp.connect(Application.Settings.FTP, Application.Settings.FTPUser, Application.Settings.FTPPW)>
		<!--- ChangeDir to _HOLD_ --->
		<cfif objFtp.LastError eq "0">
    	<cfset objFtp.ChangeDir(Application.Settings.FTPDir)>
    </cfif>
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("jarnold_daily_reg.txt", Application.Settings.FTPInDir & "jarnold_daily_reg.txt")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("jarnold_daily_reg.txt")>
      </cfif>
		</cfif>
    <cfset sockContainer.objSocket = objFtp>
    <cfif objFtp.LastError eq "0">
    	<cfset result="0:  Success">
    <cfelse>
    	<cfset result=objFtp.LastError & ": " & objFtp.GetErrorDescription(objFtp.LastError)>
    </cfif>
    <cfset objFtp.Disconnect()>
    <cfreturn result>      
	</cffunction>      

	<!--- Load the Daily Reg Report data into the database --->
  <cffunction name='loadRegData' access='public'>
  	<cfargument name="rptDate" type="string" required="yes">
    <cfargument name="term" type="string" required="yes">
  	<cfset seq=0>
		<!--- Get the latest sequence for the term --->
    <cfquery name='getSeq' datasource='#Application.Settings.IEIR_RO#'>
    	select max(seq) as regSequence from daily_reg where term = '#term#'
    </cfquery>
    <cfif getSeq.regSequence neq ''>
    	<cfset seq = getSeq.regSequence + 1>
    <cfelse>
    	<cfset seq = 1>
    </cfif>
    <cfquery result='loadResults' datasource='#Application.Settings.IEIR#'>
			load data local infile '#Application.Settings.RegFile#' 
  			into table daily_reg 
  			fields terminated by '\t' 
  			enclosed by '' 
  			lines terminated by '\n' 
  			( student_id,start_term,home_loc,reg_date,lname,fname,active_prog,stu_load,gender,age,ethnic_desc,marital_stat,active_major,change_opr, change_date, add_opr, add_date)
 		</cfquery>    
    <cfquery result='up1' datasource='#Application.Settings.IEIR#'>
    	update daily_reg set term = '#term#', seq = #seq# where term is null
    </cfquery>
    <cfquery result='up2' datasource='#Application.Settings.IEIR#'>
    	update daily_reg set reg_type = 'N' 
      	where term = '#term#' and start_term = '#term#'
    </cfquery>
    <cfquery result='up3' datasource='#Application.Settings.IEIR#'>
    	update daily_reg set reg_type = 'R' 
      	where term = '#term#' and start_term != '#term#'
    </cfquery>
    <cfquery result='up4' datasource='#Application.Settings.IEIR#'>
    	update daily_reg set rpt_date = '#rptDate#' where term = '#term#' and rpt_date is null
    </cfquery>
    <cfquery result='up5' datasource='#Application.Settings.IEIR#'>
    	update daily_reg set rpt_major = (select major from progs_majors where program = active_prog) where rpt_major is null
    </cfquery>
    
    <cfinvoke method='postProcessDR' term='#term#' seq=#seq# returnvariable='updateResult'></cfinvoke>
    
  </cffunction> <!--- end function loadRegData() --->
  
  <!--- Run a Post Process on the Reg Data to fix previous smart start students who are identified as returning instead of new. --->
  <CFFUNCTION name='postProcessDR' access='public' returnType='numeric'>
  	<cfargument name='term' type='string' required='yes'>
    <cfargument name='seq' type='numeric' required='yes'>
    
		<!--- Get the cohort for the report term --->
    <cfset cohort=''>
    <cfquery name='cohort' datasource='#Application.Settings.IEIR_RO#'>
    	select cohort as num from year_terms where term = concat('20','#term#')
    </cfquery>
    <!--- Get the term for the previous cohort --->
    <cfset prevTerm=''>
    <cfquery name='prevTerm' datasource='#Application.Settings.IEIR_RO#'>
    	select substring(term,3) as term from year_terms where cohort = (#cohort.num# - 1)
    </cfquery>
    
    <!--- Get a list of smart start students from the previous term based on course enrollment. --->
    <cfset ssStudents=''>
    <cfquery name='ssStudents' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(stc_person_id) as student from stu_course_sections
      	where scs_reporting_term = '#prevTerm.term#'
        	and stc_course_name in
          	(select course from smart_start where term = '#prevTerm.term#')
    </cfquery>
    <!--- Create an list of these ids to be used in the main loop below. --->
		<cfset studentList = ''>
		<cfloop query='ssStudents'>
			<cfset studentList = studentList & ssStudents.student & ','>
		</cfloop>
    <!--- Remove the last offending comma --->
    <cfset studentList = mid(studentList,1,len(studentList) - 1)>    
    
    <!--- Get all the returning students --->
    <cfset retQ=''>
    <cfquery name='retQ' datasource='#Application.Settings.IEIR_RO#'>
    	select student_id from daily_reg where term = '#term#' and seq = #seq# and reg_type = 'R' order by student_id
    </cfquery>
    
    <!--- Begin building another in-clause for the update statement --->
    <cfset studentIds = '('>
    
    <!--- Loop thru all the returning students.  If any of them are found in the smart start student list. Add them to the 
		      Student ID List to be updated. --->
    <cfloop query='retQ'>
    	<cfif ListFind(studentList,retQ.student_id) neq 0>
      	<cfset studentIds = studentIds & retQ.student_id & ','>
      </cfif>
    </cfloop>
    <!--- Remove the final comma from the student ID list --->
    <cfset studentIds = mid(studentIds,1,len(studentIds) -1) & ')'>
    
    <!--- Now update the smart start students to show as 'new' from the previous term. --->
    <cfset upQ=''>
    <cfquery result='upQ' datasource='#Application.Settings.IEIR#'>
    	update daily_reg set reg_type = 'N'
      	where term = '#term#'
        	and seq = #seq#
          and student_id in #studentIds#
          and start_term = '#prevTerm.term#'
    </cfquery>
    
    <cfreturn 0>
  </CFFUNCTION>
    

	<!--- Run the EM Withdrawals Report --->
  <cffunction name='runWithdrawals' access='public' returnType='struct'>
  	<cfargument name='openSocket' type='struct' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfset crlf= CHR(13) & CHR(10)>
   	<!--- Invoke the colleague command that will run the EM Withdraws for the current colleage term --->
    <cfset openSocket.objSocket.SendString("JARNOLD.EM.WITHDRAWALS.ABB")>
    <cfoutput>JARNOLD.EM.WITHDRAWALS.ABB<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="ENTER TERM" delay=0 openSocket='#openSocket#'></cfinvoke>
    <!--- Send the Current Colleague Term or report an error and abort--->
		<cfif openSocket.objSocket.LastError eq 0>
		  <cfset openSocket.objSocket.SendString(term)>
    	<cfoutput>#term#<br /></cfoutput>
    	<cfflush> 
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Current Colleague Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>
		<!--- Return the open socket to the sender --->
		<cfreturn openSocket>    
  </cffunction> <!--- end function runWithdrawals() --->

	<!--- Run the EM Grads Report --->
  <cffunction name='runGrads' access='public' returnType='struct'>
  	<cfargument name='openSocket' type='struct' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfset crlf= CHR(13) & CHR(10)>
   	<!--- Invoke the colleague command that will run the EM Withdraws for the current colleage term --->
    <cfset openSocket.objSocket.SendString("JARNOLD.EM.GRADS.ABB")>
    <cfoutput>JARNOLD.EM.GRADS.ABB<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="ENTER TERM" delay=0 openSocket='#openSocket#'></cfinvoke>
    <!--- Send the Current Colleague Term or report an error and abort--->
		<cfif openSocket.objSocket.LastError eq 0>
		  <cfset openSocket.objSocket.SendString(term)>
    	<cfoutput>#term#<br /></cfoutput>
    	<cfflush> 
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Current Colleague Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>
		<!--- Return the open socket to the sender --->
		<cfreturn openSocket>    
  </cffunction> <!--- end function runGrads() --->

	<!--- download Student Withdraw Data --->
	<cffunction name='downloadWDData' access='public' returntype="string">
  	<cfset sockContainer = StructNew()>
  	<cfset strResult=''>
    <cfset strCommand=''>
    <cfset crlf = CHR(13) & CHR(10)>
  	<!--- creating the object --->
   	<cfobject class="ActiveXperts.FtpServer" type="com" name="objFtp" Action="Create">
   	<!--- connect to host --->
		<cfset objFtp.connect(Application.Settings.FTP, Application.Settings.FTPUser, Application.Settings.FTPPW)>
		<!--- ChangeDir to _HOLD_ --->
		<cfif objFtp.LastError eq "0">
    	<cfset objFtp.ChangeDir(Application.Settings.FTPDir)>
    </cfif>
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("#Application.Settings.WDFileShortName#", Application.Settings.FTPInDir & "#Application.Settings.WDFileShortName#")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("#Application.Settings.WDFileShortName#")>
      </cfif>
		</cfif>
    <cfset sockContainer.objSocket = objFtp>
    <cfif objFtp.LastError eq "0">
    	<cfset result="0:  Success">
    <cfelse>
    	<cfset result=objFtp.LastError & ": " & objFtp.GetErrorDescription(objFtp.LastError)>
    </cfif>
    <cfset objFtp.Disconnect()>
    <cfreturn result>      
	</cffunction> <!--- end function downloadWDData() --->     

	<!--- download Student Grad Data --->
	<cffunction name='downloadGradData' access='public' returntype="string">
  	<cfset sockContainer = StructNew()>
  	<cfset strResult=''>
    <cfset strCommand=''>
    <cfset crlf = CHR(13) & CHR(10)>
  	<!--- creating the object --->
   	<cfobject class="ActiveXperts.FtpServer" type="com" name="objFtp" Action="Create">
   	<!--- connect to host --->
		<cfset objFtp.connect(Application.Settings.FTP, Application.Settings.FTPUser, Application.Settings.FTPPW)>
		<!--- ChangeDir to _HOLD_ --->
		<cfif objFtp.LastError eq "0">
    	<cfset objFtp.ChangeDir(Application.Settings.FTPDir)>
    </cfif>
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("#Application.Settings.GradFileShortName#", Application.Settings.FTPInDir & "#Application.Settings.GradFileShortName#")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("#Application.Settings.GradFileShortName#")>
      </cfif>
		</cfif>
    <cfset sockContainer.objSocket = objFtp>
    <cfif objFtp.LastError eq "0">
    	<cfset result="0:  Success">
    <cfelse>
    	<cfset result=objFtp.LastError & ": " & objFtp.GetErrorDescription(objFtp.LastError)>
    </cfif>
    <cfset objFtp.Disconnect()>
    <cfreturn result>      
	</cffunction> <!--- end function downloadWDData() --->     

	<!--- download Student App Data --->
	<cffunction name='downloadAppData' access='public' returntype="string">
  	<cfset sockContainer = StructNew()>
  	<cfset strResult=''>
    <cfset strCommand=''>
    <cfset crlf = CHR(13) & CHR(10)>
  	<!--- creating the object --->
   	<cfobject class="ActiveXperts.FtpServer" type="com" name="objFtp" Action="Create">
   	<!--- connect to host --->
		<cfset objFtp.connect(Application.Settings.FTP, Application.Settings.FTPUser, Application.Settings.FTPPW)>
		<!--- ChangeDir to _HOLD_ --->
		<cfif objFtp.LastError eq "0">
    	<cfset objFtp.ChangeDir(Application.Settings.FTPDir)>
    </cfif>
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("#Application.Settings.AppFileShortName#", Application.Settings.FTPInDir & "#Application.Settings.AppFileShortName#")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("#Application.Settings.AppFileShortName#")>
      </cfif>
		</cfif>
    <cfset sockContainer.objSocket = objFtp>
    <cfif objFtp.LastError eq "0">
    	<cfset result="0:  Success">
    <cfelse>
    	<cfset result=objFtp.LastError & ": " & objFtp.GetErrorDescription(objFtp.LastError)>
    </cfif>
    <cfset objFtp.Disconnect()>
    <cfreturn result>      
	</cffunction> <!--- end function downloadAppData() --->   

	<!--- Load the Withdraw data into the em_corrections table --->
  <cffunction name='loadWDData' access='public'>
  	<cfargument name='colTerm' type='string' required='yes'>
    <cfargument name='fullTerm' type='string' required='yes'>
    <cfif fileExists(#Application.Settings.WDFile#)>
      <cfquery result='clearResults' datasource='#Application.Settings.IEIR#'>
        delete from em_temp_wd_info
      </cfquery>
      <cfquery result='resetResults' datasource='#Application.Settings.IEIR#'>
        update em_corrections set withdraws = 0 where term = '#fullTerm#'
      </cfquery>
      <cfquery result='loadResults' datasource='#Application.Settings.IEIR#'>
        load data local infile '#Application.Settings.WDFile#' 
          into table em_temp_wd_info 
          fields terminated by '\t' 
          enclosed by '' 
          lines terminated by '\n' 
          (term,loc,atid,curstat,active_prog,name,statdate)
      </cfquery>    
      <cfquery result='processResults' datasource='#Application.Settings.IEIR#'>
        call processWDInfo()
      </cfquery>
    </cfif>
  </cffunction> <!--- end function loadWDData() --->

	<!--- Load the Grad data into the em_corrections table --->
  <cffunction name='loadGradData' access='public'>
  	<cfargument name='term' type='string' required='yes'>
    <cfif fileExists(#Application.Settings.GradFile#)>
      <cfquery result='clearResults' datasource='#Application.Settings.IEIR#'>
        delete from em_temp_grad_info
      </cfquery>
      <cfquery result='resetResults' datasource='#Application.Settings.IEIR#'>
        update em_corrections set ant_grads = 0 where term = '#term#'
      </cfquery>
      <cfquery result='loadResults' datasource='#Application.Settings.IEIR#'>
        load data local infile '#Application.Settings.GradFile#' 
          into table em_temp_grad_info 
          fields terminated by '\t' 
          enclosed by '' 
          lines terminated by '\n' 
          (term,loc,active_prog,atid)
      </cfquery>    
      <cfquery result='processResults' datasource='#Application.Settings.IEIR#'>
        call processGradInfo()
      </cfquery>
    </cfif>
  </cffunction> <!--- end function loadGradData() --->

	<!--- Run the EM Apps Report --->
  <cffunction name='runEMApps' access='public' returnType='struct'>
  	<cfargument name='openSocket' type='struct' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfset crlf= CHR(13) & CHR(10)>
   	<!--- Invoke the colleague command that will run the EM Apps for the current colleage term --->
    <cfset openSocket.objSocket.SendString("JARNOLD.EM.APPS")>
    <cfoutput>JARNOLD.EM.APPS<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="ENTER TERM" delay=0 openSocket='#openSocket#'></cfinvoke>
    <!--- Send the Current Colleague Term or report an error and abort--->
		<cfif openSocket.objSocket.LastError eq 0>
		  <cfset openSocket.objSocket.SendString(term)>
    	<cfoutput>#term#<br /></cfoutput>
    	<cfflush> 
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Current Colleague Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>
		<cfreturn openSocket>    
  </cffunction> <!--- end function runEMApps() --->

	<!--- Load the EM Application data into the database --->
  <cffunction name='loadAppData' access='public'>
  	<cfargument name='em_term' type='string' required='yes'>
    <cfargument name='em_cohort' type='numeric' required='yes'>
  	<cfif fileExists(#Application.Settings.AppFile#)>
      <cfquery result='clearResults' datasource='#Application.Settings.IEIR#'>
        delete from em_temp_app_info where rpt_term = '#em_term#'
      </cfquery>
      <cfquery result='loadResults' datasource='#Application.Settings.IEIR#'>
        load data local infile '#Application.Settings.AppFile#' 
          into table em_temp_app_info 
          fields terminated by '\t' 
          enclosed by '' 
          lines terminated by '\n' 
          (rpt_term,loc,major,program,last_name,first_name,middle,app_status,pref_city,phone,applicant,change_opr, change_date, add_opr, add_date)
      </cfquery>
      <cfset dateToday = DateFormat(Now(),"yyyy/mm/dd")>      
      <cfquery result='processResults' datasource='#Application.Settings.IEIR#'>
        call processAppInfo(#em_cohort#,'#em_term#','#dateToday#')
      </cfquery> 
    </cfif>
  </cffunction>

	<!--- Run the Bookstore report --->
  <cffunction name='runBookStoreStuLocs' access='public' returnType='struct'>
  	<cfargument name='openSocket' type='struct' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfset crlf= CHR(13) & CHR(10)>
   	<!--- Invoke the colleague command that will run the EM Withdraws for the current colleage term --->
    <cfset openSocket.objSocket.SendString("JARNOLD.BKSTORE.STULOCS")>
    <cfoutput>JARNOLD.BKSTORE.STULOCS<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="ENTER TERM" delay=0 openSocket='#openSocket#'></cfinvoke>
    <!--- Send the Current Colleague Term or report an error and abort--->
		<cfif openSocket.objSocket.LastError eq 0>
		  <cfset openSocket.objSocket.SendString(term)>
    	<cfoutput>#term#<br /></cfoutput>
    	<cfflush> 
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Current Colleague Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>
		<!--- Return the open socket to the sender --->
		<cfreturn openSocket>    
  </cffunction>

	<!--- download Bookstore Data --->
	<cffunction name='downloadBookstoreData' access='public' returntype="string">
  	<cfset sockContainer = StructNew()>
  	<cfset strResult=''>
    <cfset strCommand=''>
    <cfset crlf = CHR(13) & CHR(10)>
  	<!--- creating the object --->
   	<cfobject class="ActiveXperts.FtpServer" type="com" name="objFtp" Action="Create">
   	<!--- connect to host --->
		<cfset objFtp.connect(Application.Settings.FTP, Application.Settings.FTPUser, Application.Settings.FTPPW)>
		<!--- ChangeDir to _HOLD_ --->
		<cfif objFtp.LastError eq "0">
    	<cfset objFtp.ChangeDir(Application.Settings.FTPDir)>
    </cfif>
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("jarnold_bkstore.txt", Application.Settings.FTPInDir & "jarnold_bkstore.txt")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("jarnold_bkstore.txt")>
      </cfif>
		</cfif>
    <cfset sockContainer.objSocket = objFtp>
    <cfif objFtp.LastError eq "0">
    	<cfset result="0">
    <cfelse>
    	<cfset result=objFtp.LastError & ": " & objFtp.GetErrorDescription(objFtp.LastError)>
    </cfif>
    <cfset objFtp.Disconnect()>
    <cfreturn result>      
	</cffunction>      

	<!--- Load the bookstore data into the DB --->
	<cffunction name='loadBkStoreData' access='public'>
  	<cfargument name='bk_term' type='string' required='yes'>
  	<cfquery result='clearResults' datasource='#Application.Settings.IEIR#'>
    	delete from book_order_stu_locs_temp
    </cfquery>
    <cfquery result='loadResults' datasource='#Application.Settings.IEIR#'>
			load data local infile '#Application.Settings.BKFile#' 
  			into table book_order_stu_locs_temp 
  			fields terminated by '\t' 
  			enclosed by '' 
  			lines terminated by '\n' 
  			(term,sec_loc,stu_loc,sec_no,sec_rubric,sec,student,sec_start_str,sec_dept,cur_status)
 		</cfquery>
    <cfset dateToday = DateFormat(Now(),"yyyy/mm/dd")>      
    <cfquery name='getCohort' datasource='#Application.Settings.IEIR_RO#'>
    	select cohort from year_terms where term = concat('20','#bk_term#');
    </cfquery>
    <cfset cohort = getCohort.cohort>
    <cfset term = '20' & bk_term>
		<cfquery name='getSeq' datasource='#Application.Settings.IEIR_RO#'>
    	select max(seq) as seq from book_order_stu_locs where cohort = #cohort#
    </cfquery>
    <cfif getSeq.seq neq ''>
    	<cfset seq = getSeq.seq + 1>
    <cfelse>
    	<cfset seq = 1>
    </cfif>
    <cfset dateToday = DateFormat(Now(),"yyyy/mm/dd")>      
    
    <cfquery name='getDepts' datasource='#Application.Settings.IEIR_RO#'>
    	select distinct(sec_dept) as dept from book_order_stu_locs_temp order by sec_dept
    </cfquery>
		<cfloop query='getDepts'>
    	<cfset dept=getDepts.dept>
    	<cfquery name='getSections' datasource='#Application.Settings.IEIR_RO#'>
      	select distinct(sec_rubric) as secName, sec_no, sec_loc 
        	from book_order_stu_locs_temp 
          where sec_dept = '#getDepts.dept#' 
          order by sec_rubric,sec_loc
      </cfquery>
      <cfloop query='getSections'>
      	<cfset secName = getSections.secName>
        <cfset secLoc = getSections.sec_loc>
        <cfset secNo = getSections.sec_no>
        <cfquery name='getStuLocs' datasource='#Application.Settings.IEIR_RO#'>
        	select distinct(stu_loc) as stuLoc 
          	from book_order_stu_locs_temp 
            where sec_rubric = '#secName#' 
            	and sec_loc = #secLoc# 
              and sec_dept = '#dept#' 
            order by stu_loc
       	</cfquery>
        <cfloop query='getStuLocs'>
        	<!--- Get all registered students --->
        	<cfquery name='countStudents' datasource='#Application.Settings.IEIR_RO#'>
          	select count(student) as students 
            	from book_order_stu_locs_temp
          		where sec_dept = '#dept#' 
              and sec_rubric = '#secName#' 
              and sec_loc = #secLoc# 
              and stu_loc = #getStuLocs.stuLoc#
          </cfquery>
        	<!--- Get all dropped students --->
        	<cfquery name='countDrops' datasource='#Application.Settings.IEIR_RO#'>
          	select count(student) as dropped 
            	from book_order_stu_locs_temp
          		where sec_dept = '#dept#' 
              and sec_rubric = '#secName#' 
              and sec_loc = #secLoc# 
              and stu_loc = #getStuLocs.stuLoc# 
              and cur_status = 'X'
          </cfquery>
          <cfquery name='getSecCampus' datasource='#Application.Settings.IEIR_RO#'>
          	select campus from locations where lc_id = #secLoc#
          </cfquery>
          <cfquery name='getStuCampus' datasource='#Application.Settings.IEIR_RO#'>
          	select campus from locations where lc_id = #getStuLocs.stuLoc#
          </cfquery>
          <cfquery name="insertSummary" datasource='#Application.Settings.IEIR#'>
          	insert into book_order_stu_locs values(#cohort#,'#term#','#dept#','#secName#',#secLoc#,'#getSecCampus.campus#',#getStuLocs.stuLoc#,'#getStuCampus.campus#',#countStudents.students#,'#dateToday#',#seq#,#countDrops.dropped#)
          </cfquery>
        </cfloop>
      </cfloop>
    </cfloop>

  </cffunction> <!--- End function loadBkStoreData() --->

	<!--- Run the Daily SCS Job --->
  <cffunction name='runSCS' access='public' returnType='struct'>
  	<cfargument name='openSocket' type='struct' required='yes'>
    <cfargument name='term' type='string' required='yes'>
    <cfargument name='loc' type='numeric' required='yes'>
    <cfset crlf= CHR(13) & CHR(10)>
   	<!--- Invoke the colleague command that will run the EM Withdraws for the current colleage term --->
    <cfset openSocket.objSocket.SendString("JARNOLD.SCS.DAILY")>
    <cfoutput>JARNOLD.SCS.DAILY<br /></cfoutput>
    <cfflush>
   	<cfinvoke method='verifyReceiveData' promptString="ENTER TERM" delay=0 openSocket='#openSocket#'></cfinvoke>
    <!--- Send the Current Colleague Term or report an error and abort--->
		<cfif openSocket.objSocket.LastError eq 0>
		  <cfset openSocket.objSocket.SendString(term)>
    	<cfoutput>#term#<br /></cfoutput>
    	<cfflush> 
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

   	<cfinvoke method='verifyReceiveData' promptString="ENTER FIRST DIGIT OF LOCATION" delay=0 openSocket='#openSocket#'></cfinvoke>
    <!--- Send the Current Colleague Term or report an error and abort--->
		<cfif openSocket.objSocket.LastError eq 0>
		  <cfset openSocket.objSocket.SendString(loc)>
    	<cfoutput>#loc#<br /></cfoutput>
    	<cfflush> 
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending College Location<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>

    <!--- Wait for the job to finish or report an error and abort--->
    <cfif openSocket.objSocket.LastError eq 0>
	   	<cfinvoke method='verifyReceiveData' promptString=":" delay=0 openSocket='#openSocket#'></cfinvoke>
    <cfelse>
  		<cfinvoke method='closeSocket' openSocket="#openSocket#">
			<cfoutput>Method Failed Sending Term<br /></cfoutput>
  		<cfflush>
  		<cfabort>
    </cfif>
		<!--- Return the open socket to the sender --->
		<cfreturn openSocket>    
  </cffunction>

	<!--- download the SCS Data.  This function moves the output file from the _HOLD_ directory to the server. --->
	<cffunction name='downloadSCS' access='public' returntype="string">
  	<cfset sockContainer = StructNew()>
  	<cfset strResult=''>
    <cfset strCommand=''>
    <cfset crlf = CHR(13) & CHR(10)>
  	<!--- creating the object --->
   	<cfobject class="ActiveXperts.FtpServer" type="com" name="objFtp" Action="Create">
   	<!--- connect to host --->
		<cfset objFtp.connect(Application.Settings.FTP, Application.Settings.FTPUser, Application.Settings.FTPPW)>
		<!--- ChangeDir to _HOLD_ --->
		<cfif objFtp.LastError eq "0">
    	<cfset objFtp.ChangeDir(Application.Settings.FTPDir)>
    </cfif>
    <cfif objFtp.LastError eq "0">
    	<cfset objFtp.GetFile("jarnold_stucorsec_daily.txt", Application.Settings.FTPInDir & "jarnold_stucorsec_daily.txt")>
      <!--- Delete the file --->
      <cfif objFtp.LastError eq "0">
      	<cfset objFtp.DeleteFile("jarnold_stucorsec_daily.txt")>
      </cfif>
		</cfif>
    <cfset sockContainer.objSocket = objFtp>
    <cfif objFtp.LastError eq "0">
    	<cfset result="0">
    <cfelse>
    	<cfset result=objFtp.LastError & ": " & objFtp.GetErrorDescription(objFtp.LastError)>
    </cfif>
    <cfset objFtp.Disconnect()>
    <cfreturn result>      
	</cffunction>      

	<!--- Load the stucorsec data into the DB --->
	<cffunction name='loadSCS' access='public'>
  	<cfargument name='scs_term' type='string' required='yes'>
    <cfargument name='loc' type='numeric' required='yes'>
  	<cfquery result='clearResults' datasource='#Application.Settings.IEIR#'>
    	delete from stu_course_sections where scs_reporting_term = '#scs_term#' and scs_location like '#loc#%'
    </cfquery>
    <cfquery result='loadResults' datasource='#Application.Settings.IEIR#'>
			load data local infile '#Application.Settings.SCSFile#' 
  			into table stu_course_sections 
  			fields terminated by '\t' 
  			enclosed by '' 
  			lines terminated by '\n' 
        ( scs_location,
          scs_reporting_term,
          stc_verified_grade,
          stc_course_name,
          stc_section_no,
          stc_person_id,
          stc_acad_level,
          stc_cred,
          stc_final_grade,
          stc_gpa_cred,
          stc_grade_pts,
          scs_current_stu_type,
          scs_first_name,
          scs_last_name,
          scs_middle_name,
          scs_residency_status,
          stc_verified_grade_date,
          x_scs_noshow,
          x_scs_ssn,
          x_scs_sttr_id,
          scs_status)
 		</cfquery>
  	<cfquery result='clearBadons' datasource='#Application.Settings.IEIR#'>
    	delete from stu_course_sections 
      	where scs_reporting_term = '#scs_term#'
        	and scs_location like '#loc#'
        	and stc_verified_grade = ''
          and scs_status = ''
    </cfquery>

  </cffunction> <!--- End function loadSCS() --->

</cfcomponent>