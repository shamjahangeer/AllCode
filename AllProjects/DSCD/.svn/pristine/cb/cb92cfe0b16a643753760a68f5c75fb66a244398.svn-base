<%@ Language=VBScript %>
<% Option Explicit %>
<% Response.Buffer = True %>
<% Server.ScriptTimeout = 600
   Session.Timeout = 240
   Response.Expires = 0	%>
<!--#include file=include/colors.inc-->
<!--#include file=include/security.inc-->
<!--#include file=include/constants.inc-->
<!--#include file=include/ServerStats.inc-->
<!--#include file=include/GetBrowserVersion.inc-->
<%
'Declare your variables
Dim objError
Dim errWhere
Dim errDesc
dim objList
Dim vntArray
Dim vntErrorNumber
Dim vntErrorDesc
dim vntWindow
dim vntDispCrit
	dim vntSumLate
	dim vntSumEarly
	dim vntTest
	dim vntSumEarlyPercnt
	dim vntSumLatePercnt
	dim vntOnTime
	dim vntCenter1
	dim vntCenter3
	dim vntCenter4
	dim vntCenter5
	dim vntCenter6
	dim vntCenter7
	dim vntCenter8
	dim vnt6Early
	dim vnt5Early
	dim vnt4Early
	dim vnt3Early
	dim vnt2Early
	dim vnt1Early
	dim vnt1Late
	dim vnt2Late
	dim vnt3Late
	dim vnt4Late
	dim vnt5Late
	dim vnt6Late
	dim vntEStep1
	dim vntEStep2
	dim vntEStep3
	dim vntEStep4
	dim vntEStep5
	dim vntEStep6
	dim vntLStep1
	dim vntLStep2
	dim vntLStep3
	dim vntLStep4
	dim vntLStep5
	dim vntLStep6
	dim vntTotal
	dim vntSmryType
	dim vntJITLate
	dim vntJITEarly
	dim vntJITEarlyPercnt
	dim vntJITLatePercnt
	dim vntJ
	dim vntHold
	dim vntSql
	dim vntInWindowPercnt
	dim vntInWindow

	dim vntTempWindow
	dim vntTempEarly
	dim vntTempLate
	dim vntDaysEarly
	dim vntDaysLate
	dim vntSessionId
	dim vntQSView
	dim vntQSCat
	dim vntQSInd
	dim vntQSWin
	dim vntQSRT
	dim vntTemp1
	dim vntTemp2
	dim vntViewDesc
	dim vntcatDesc
	dim vntWinDesc
	dim objRet
	dim blnrc
	dim strBrowser
	dim strVersion
	dim strOS
	dim vntNetscape


'Initialize your variables
objError = 0
errWhere = ""
errDesc = ""
vntWindow = 1
vntNetscape = false
'Uncomment when security matters
If Not MrSecurity Then
  Response.Redirect Application("Login")
End If


GetBrowserVersion strBrowser, strVersion, strOS
if instr(strBrowser, "Explorer") = 0 then
	vntNetscape = true
end if

vntQSView = Request.QueryString ("v")
vntQSCat = Request.QueryString ("c")
vntQSInd = Request.QueryString ("mdi")
vntQSWin = Request.QueryString ("w")
vntQSRT = Request.QueryString ("rt")

if Request.QueryString("s") <> "" then
	session("GetTotal") = ""
	vntSessionId = Request.QueryString ("s")
	Session("SrSessionId") = vntSessionId
else
	vntSessionId = Session("SrSessionId")
end if

if Request.Form("Submit") = "" then
	ServerStats vntQSView, vntQSCat
end if

Select Case Request.Form("Submit")

Case "Return"
	session("GetTotal") = ""
	Response.Redirect strServerUrl & appPath & "search.asp?s=" & vntSessionId
end select

Function FormatWords(strIn)
FormatWords = vbNullString

	Dim inxChar, inx, strOut

	If Len(strIn) > 1 Then
		strOut = Trim(strIn)
		strOut = CapAfterChar(strOut, " ")
		strOut = CapAfterChar(strOut, "/")
		strOut = CapAfterChar(strOut, "-")
		strOut = CapAfterChar(strOut, ",")
		strOut = CapAfterChar(strOut, ".")
		If UCase(Left(strOut, 4)) = "SAP " then
			strOut = UCase(Left(strOut, 4)) & Mid(strOut, 5)
		End If
	Else
		strOut = UCase(FormatJSstring(strIn))
	End If

	FormatWords = strOut

End Function


Function CapAfterChar(strIn, strChar)

	Dim inxChar, inx, strOut, intLen
		strOut = strIn
		intLen = Len(strOut)

	If intLen > 1 Then
		For inxChar = 1 To intLen - 1
			inx = InStr(inxChar, strIn, strChar)
			If inx > 0 Then
				strOut = Left(strOut, inx) & UCase(Mid(strOut, inx + 1, 1)) & Mid(strOut, inx + 2)
				inxChar = inx
			End If
			If inxChar > intLen Then Exit For
		Next
	End If

	CapAfterChar = strOut
End Function

Function GenHtmlHead()
	response.write "<html>"
	response.write "<head>"
	response.write "<meta NAME=""GENERATOR"" Content=""Microsoft Visual InterDev 1.0"">"
	response.write "<title>" & Application("AppAbrv") & " - " & "Summary Results</title>"
	response.write "</head>"%>

	<!--#include file=include/NavBegin.inc-->
<%
	response.write "<td width=""5%"" align=center><a href=" & strServerUrl & appPath & Application("Home") & ">Home</a></td>"
	response.write "<td width=""20%"">&nbsp;</td>"
	response.write "<td width=""20%"">&nbsp;</td>"
	response.write "<td width=""20%"">&nbsp;</td>"
	response.write "<td width=""5%"" align=""center"">"
	response.write "<a href=" & strServerUrl & appHelp & Application("Help") & " target=""Help Window"">Help</a>"
	response.write "</td>"
%>
	<!--#include file=include/NavMiddle.inc-->
<%
		set objRet = server.CreateObject ("DSCD.clsView")
		blnRc = objRet.RetrieveView (vntQsView,vntViewDesc, vntErrorNumber, vntErrorDesc)
		set objRet = nothing
		if len(vntViewDesc) > 0 then
			vntTemp1 = lcase(right(vntViewDesc,len(vntViewDesc) - 1))
			vntTemp2 = left(vntViewDesc,1)
			vntViewDesc = vntTemp2 & vntTemp1
			vntViewdesc = FormatWords(vntViewDesc)
		end if

		set objRet = server.CreateObject ("DSCD.clsCategory")
		blnrc = objRet.RetrieveCategory(vntQSCat, vntCatdesc, vntErrorNumber, vntErrorDesc)
		set objRet = nothing
		if len(vntCatdesc) > 0 then
			vntTemp1 = lcase(right(vntCatdesc,len(vntCatdesc) - 1))
			vntTemp2 = left(vntCatdesc,1)
			vntCatdesc = vntTemp2 & vntTemp1
			vntCatdesc = FormatWords(vntCatDesc)
		end if

		if vntQSWin = "1" then
			vntWinDesc = "Customer Variable"
		else
			vntWinDesc = "Standard Default"
		end if
		if vntQSRT = "1" then
			vntTemp1 = "Country "
		elseif vntQSRT = "2" then
			vntTemp1 = "Ship-To Country "
		else
			vntTemp1 = ""
		end if
		response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>" & vntViewDesc & " by " & vntTemp1 &  vntCatdesc  & " - " & vntWinDesc & "</b></font></td>"
%>
	<!--#include file=include/NavEnd.inc-->
<%
	response.write "<br>"
	response.write "<br>"
end function

Function GenNavButtons()
Response.Write "<form name=""frmResults"" ACTION=""smResults.asp"" method=""POST"">"
	Response.Write "<table width=""100%"" border=""0"">" & vbcrlf
	Response.Write "<tr>" & vbcrlf
	Response.Write "    <td ALIGN=""left"" width=""10%"">" & vbcrlf
	Response.Write "    <input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Return""></td>" & vbcrlf
	Response.Write "    <td ALIGN=""right"" width=""40%"">" & vbcrlf
	Response.Write "    &nbsp;</td>" & vbcrlf
	Response.Write "</tr>" & vbcrlf
	Response.Write "</TABLE>"
End Function

Function GetList()
	vntTest = "3"
	vntSmryType = vntTest
	vntTempWindow = 1
	vntTempEarly = "0"
	vntTempLate = "0"
	set objList = server.CreateObject ("DSCD.clsResults")
	if vntQSRT = "1" then
		vntArray = objList.ListSummMonByCntry (vntSessionId,vntDispCrit,vntSmryType, _
									vntWindow, vntDaysEarly, vntDaysLate, _
									vntErrorNumber, vntErrorDesc, vntSql)
	else
		vntArray = objList.ListSummMnthly (vntSessionId,vntSumLate,vntSumEarly,vntSumEarlyPercnt,vntSumLatePercnt, _
									vntOnTime,vntCenter1,vntCenter3,vntCenter4,vntCenter5,vntCenter6,vntCenter7, _
									vntCenter8,vnt6Early,vnt5Early,vnt4Early,vnt3Early,vnt2Early,vnt1Early, _
									vnt1Late,vnt2Late,vnt3Late,vnt4Late,vnt5Late,vnt6Late,vntEStep1,vntEStep2, _
									vntEStep3,vntEStep4,vntEStep5,vntEStep6,vntLStep1,vntLStep2,vntLStep3, _
									vntLStep4,vntLStep5,vntLStep6,vntTotal, _
									vntJITEarly,vntJITEarlyPercnt,vntJITLate,vntJITLatePercnt, _
									vntWindow, vntDaysEarly, vntDaysLate, vntInWindowPercnt, vntInWindow, _
									vntSmryType,vntDispCrit,vntErrorNumber, vntErrorDesc, vntSql)
	end if
	set objList = nothing
end function

Function GetDailyList()
	vntTest = "3" ' 1-Schd to ship 2-request to ship
	vntSmryType = vntTest
	vntTempWindow = 2 ' 1-Customer Variable, 2-Standard Default
	vntTempEarly = "0"
	vntTempLate = "0"
	set objList = server.CreateObject ("DSCD.clsResults")
	if vntQSRT = "1" or vntQSRT = "2" then
		vntArray = objList.ListSummDlyByCntry (vntSessionId,vntQSRT,vntDispCrit,vntSmryType, _
									vntWindow, vntDaysEarly, vntDaysLate, _
									vntErrorNumber, vntErrorDesc, vntSql)
	else
		vntArray = objList.ListSummDaily (vntSessionId,vntSumLate,vntSumEarly,vntSumEarlyPercnt,vntSumLatePercnt, _
									vntOnTime,vntCenter1,vntCenter3,vntCenter4,vntCenter5,vntCenter6,vntCenter7, _
									vntCenter8,vnt6Early,vnt5Early,vnt4Early,vnt3Early,vnt2Early,vnt1Early, _
									vnt1Late,vnt2Late,vnt3Late,vnt4Late,vnt5Late,vnt6Late,vntEStep1,vntEStep2, _
									vntEStep3,vntEStep4,vntEStep5,vntEStep6,vntLStep1,vntLStep2,vntLStep3, _
									vntLStep4,vntLStep5,vntLStep6,vntTotal, _
									vntJITEarly,vntJITEarlyPercnt,vntJITLate,vntJITLatePercnt, _
									vntWindow, vntDaysEarly, vntDaysLate, vntInWindowPercnt, vntInWindow, _
									vntSmryType,vntDispCrit,vntErrorNumber, vntErrorDesc, vntSql)
	end if
	set objList = nothing
end function

Function PaintIt()

vntJ = false
'***********************Array Definition*************************************************
'0    def_six_plus_early        17   jit_three_early
'1    def_five_early            18   jit_two_early
'2    def_four_early            19   jit_one_early
'3    def_three_early           20   jit_on_time
'4    def_two_early             21   jit_one_late
'5    def_one_early             22   jit_two_late
'6    def_on_time               23   jit_three_late
'7    def_one_late              24   jit_four_late
'8    def_two_late              25   jit_five_late
'9    def_three_late            26   jit_six_plus_late
'10   def_four_late             27   jit_total
'11   def_five_late             ****These are worthless, defined for expansion**********
'12   def_six_plus_late         28   early_shpmts
'13   def_total                 29   on_time_shpmts
'14   jit_six_plus_early        30   late_shpmts
'15   jit_five_early            31   jit_early_shpmts
'16   jit_four_early            32   jit_late_shpmts
'*********************************************************************************************
if not isnull(vntarray) then
	With Response
		.Write sHR
		.Write "<TABLE WIDTH=100% BORDER=0 CELLSPACING=0 CELLPADDING=2 align=center>"
				.Write "<TR>"
					.Write "<TD align=center colspan=11" & sTDColor & ">"
						.Write sDisStrngFont2 & "Days Early" & sEndStrgFont2 & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD colspan=2" & sTDColor & ">&nbsp;</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=center colspan=11" & sTDColor & ">"
						.Write sDisStrngFont2 & "Days Late" & sEndStrgFont2 & "</TD>"
				.Write "</TR>"
				.Write "<TR>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "6+" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "5" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "4" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "3" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "2" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "1" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD colspan=2 align=center" & sTDColor & ">" & sDisStrngFont & "0" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "1" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "2" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "3" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "4" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "5" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "6+" & sEndStrgFont & "</TD>"
				.Write "</TR>"
'***************ROW 1****************************************************************
				.Write "<TR>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 6 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>"
						.Write vnt6Early & "</STRONG></font></TD>"
						'.Write "</td></tr></table>"
						'.Write ""
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 5 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vnt5Early & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 4 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vnt4Early & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 3 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vnt3Early & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 2 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vnt2Early & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 1 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vnt1Early & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD colspan=2 align=Center><font size=2 color=blue><STRONG>" & vntCenter1 & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 1 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					.Write "<STRONG>" & vnt1Late & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 2 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					.Write "<STRONG>" & vnt2Late & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 3 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					.Write "<STRONG>" & vnt3Late & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 4 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					.Write "<STRONG>" & vnt4Late & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 5 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					.Write "<STRONG>" & vnt5Late & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 6 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					.Write "<STRONG>" & vnt6Late & "</STRONG></font></TD>"
				.Write "</TR>"
'************ROW 2*******************************************
				.Write "<TR>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(19,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD colspan=2 align=Center"
				'***Display IE Hint
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(6,0)) - cdbl(vntArray(20,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(20,0) & """"
    					end if
    					.Write ">"
    			'***Display Netscape Hint
    					if vntNetscape and vntSmryType = "1" then
      						.Write "<font size=2 color=blue><STRONG>" & vntOnTime & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(20,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(20,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
    					else
    						if cdbl(vntArray(20,0)) > 0 and vntSmryType = "1" then
    							.write "<font size=2 color=black><STRONG>J &nbsp;</STRONG></font>"
    						end if
    						.write "<font size=2 color=blue><STRONG>" & vntOnTime & "</STRONG></font></TD>"
    					end if
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(21,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
				.Write "</TR>"
'***********FILLER***********************************************
			if not vntNetscape then
				.Write "<TR>"
					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD colspan=2 align=Center><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  					.Write "<TD></TD>"
  					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
				.Write "</TR>"
			end if
'*************ROW 3********************************
				.Write "<TR>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(18,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center"
    				'***Display IE Hint
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(5,0)) - cdbl(vntArray(19,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(19,0) & """"
    					end if
    					.Write ">"
      					if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 1 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					'***Display Netscape Hint
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntEStep1 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(19,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(19,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
      						.Write "<STRONG>" & vntEStep1 & "</STRONG></font></TD>"
      					end if
    					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
    					.Write "<TD colspan=2 align=Center" & sTDColor & "><font size=2><STRONG>" & vntCenter3 & "</STRONG></font></TD>"
    					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
    					.Write "<TD align=Center"
      			'***DISPLAY THE HINT***
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(7,0)) - cdbl(vntArray(21,0))
    						.Write " title=" & """" & "NON JITA: " & vntHold & "    JIT:" & vntArray(21,0) & """"
    					end if
    					.Write ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 1 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					'***Display Netscape Hint
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntLStep1 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(21,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(21,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
							.Write "<STRONG>" & vntLStep1 & "</STRONG></font></TD>"
						end if
    					.Write "<TD>&nbsp;</TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(22,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
    					.Write "<TD>&nbsp;</TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
  				.Write "</TR>"
 '********FILLER****************************
			if not vntNetscape then
    			.Write "<TR>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD colspan=2 align=Center><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    					.Write "<TD></TD>"
    					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
  				.Write "</TR>"
  			end if
 '************ROW 4*********************************
  				.Write "<TR>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(17,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center"
      			'***Display IE Hint
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(4,0)) - cdbl(vntArray(18,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(18,0) & """"
    					end if
    					.Write ">"
      					if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 2 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
			'****Display Netscape Hint
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntEStep2 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(18,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(18,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
      						.Write "<STRONG>" & vntEStep2 & "</STRONG></font></TD>"
      					end if
     					.Write " <TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD colspan=2 align=Center" & sTDColor & "><font size=2><STRONG>" & vntCenter4 & "</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center"
      			'***DISPLAY THE HINT***
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(8,0)) - cdbl(vntArray(22,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(22,0) & """"
    					end if
    					.Write ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 2 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
			'****Display Netscape Hint
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntLStep2 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(22,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(22,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
							.Write "<STRONG>" & vntLStep2 & "</STRONG></font></TD>"
						end if
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(23,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    			.Write "</TR>"
'*********FILLER***************************
			if not vntNetscape then
    			.Write "<TR>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD colspan=2 align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    			.Write "</TR>"
    		end if
'*********ROW 5************************************************
      			.Write "<TR>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(16,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center"
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(3,0)) - cdbl(vntArray(17,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(17,0) & """"
    					end if
    					.Write ">"
      					if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 3 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					'***Display Netscape Hint
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntEStep3 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(17,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(17,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
      						.Write "<STRONG>" & vntEStep3 & "</STRONG></font></TD>"
      					end if
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD colspan=2 align=Center" & sTDColor & "><font size=2><STRONG>" & vntCenter5 & "</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center"
      			'***DISPLAY THE HINT***
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(9,0)) - cdbl(vntArray(23,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(23,0) & """"
    					end if
    					.Write ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 3 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
				'***DISPLAY THE HINT***
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntLStep3 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(23,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(23,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
							.Write "<STRONG>" & vntLStep3 & "</STRONG></font></TD>"
						end if
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(24,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    			.Write "</TR>"
'*********Filler******************************************
			if not vntNetscape then
    			.Write "<TR>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD colspan=2 align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    			.Write "</TR>"
    		end if
'********ROW 6*********************************************************************
    			.Write "<TR>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(15,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center"
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(2,0)) - cdbl(vntArray(16,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(16,0) & """"
    					end if
    					.Write ">"
      					if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 4 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
				'***DISPLAY THE HINT***
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntEStep4 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(16,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(16,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
      						.Write "<STRONG>" & vntEStep4 & "</STRONG></font></TD>"
      					end if
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD colspan=2 align=Center" & sTDColor & "><font size=2><STRONG>" & vntCenter6 & "</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center"
      			'***DISPLAY THE HINT***
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(10,0)) - cdbl(vntArray(24,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(24,0) & """"
    					end if
    					.Write ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 4 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
				'***DISPLAY THE HINT***
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntLStep4 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(24,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(24,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
							.Write "<STRONG>" & vntLStep4 & "</STRONG></font></TD>"
						end if
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(25,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
    			.Write "</TR>"
    'Filler*********
			if not vntNetscape then
    			.Write "<TR>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD colspan=2 align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    			.Write "</TR>"
    		end if
'******ROW 7*******************************************************
      			.Write "<TR>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(14,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center"
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(1,0)) - cdbl(vntArray(15,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(15,0) & """"
    					end if
    					.Write ">"
      					if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 5 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
				'***DISPLAY THE HINT***
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntEStep5 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(15,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(15,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
      						.Write "<STRONG>" & vntEStep5 & "</STRONG></font></TD>"
      					end if
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD bgcolor=lightgrey>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD colspan=2 align=Center" & sTDColor & "><font size=2><STRONG>" & vntCenter7 & "</STRONG></font></TD>"
      					.Write "<TD bgcolor=lightgrey>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD bgcolor=lightgrey>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD bgcolor=lightgrey>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
      					.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					.Write "<TD align=Center"
      			'***DISPLAY THE HINT***
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(11,0)) - cdbl(vntArray(25,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(25,0) & """"
    					end if
    					.Write ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 5 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
				'***DISPLAY THE HINT***
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntLStep5 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(25,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(25,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
							.Write "<STRONG>" & vntLStep5 & "</STRONG></font></TD>"
						end if
      					.Write "<TD>&nbsp;</TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>"
    					if cdbl(vntArray(26,0)) > 0 and vntSmryType = "1" then
    						vntJ = true
    						.Write "J"
    					else
    						.write "&nbsp;"
    					end if
					.Write "</STRONG></font></TD>"
    			.Write "</TR>"
'********FILLER***********************************
			if not vntNetscape then
    			.Write "<TR>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD colspan=2 align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center><font size=2><STRONG></STRONG></font></TD>"
      					.Write "<TD></TD>"
      					.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG></STRONG></font></TD>"
    			.Write "</TR>"
    		end if
'**********ROW 8*********************************************
    			.Write "<TR>"
           				.Write "<TD align=Center"
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(0,0)) - cdbl(vntArray(14,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(14,0) & """"
    					end if
    					.Write ">"
      					if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 6 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
				'***DISPLAY THE HINT***
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntEStep6 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(14,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(14,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
      						.Write "<STRONG>" & vntEStep6 & "</STRONG></font></TD>"
      					end if
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD bgcolor=lightgrey>&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD colspan=2 align=Center" & sTDColor & "><font size=2><STRONG>" & vntCenter8 & "</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center" & sTDColor & "><font size=2><STRONG>&nbsp;</STRONG></font></TD>"
        				.Write "<TD" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center"
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(12,0)) - cdbl(vntArray(26,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(26,0) & """"
    					end if
    					.Write ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 6 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
				'***DISPLAY THE HINT***
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntLStep6 & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(26,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(26,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
							.Write "<STRONG>" & vntLStep6 & "</STRONG></font></TD>"
						end if
      			.Write "</TR>"
      '****Netscape??
			if not vntNetscape then
      			.Write "<TR>"
        				.Write "<TD colspan=26></TD>"
        				'.Write "</TD>"
        		.Write "</TR>"
        	end if
      			.Write "<TR" & sTDColor & ">"
        				.Write "<TD align=Center>" & sDisStrngFont & "Early" & sEndStrgFont & "</TD>"
 '******************Do we Display Jit WINDOWS 1 = yes
        				if vntSmryType = "1" then
        					.Write "<td>&nbsp;</td>"
        					.Write "<TD align=Center>" & sDisStrngFont & "JIT Early" & sEndStrgFont & "</TD>"
        					.Write "<TD colspan=9>&nbsp;</TD>"
        				else
        					.Write "<TD colspan=11>&nbsp;</TD>"
        				end if
        				.Write "<TD colspan=2 align=Center>" & sDisStrngFont & "In Window" & sEndStrgFont & "</TD>"
        				.Write "<TD colspan=5>&nbsp;</TD>"
        				.Write "<TD align=Center>" & sDisStrngFont & "Total" & sEndStrgFont & "</TD>"
        				if vntSmryType = "1" then
        					.Write "<TD colspan=3>&nbsp;</TD>"
        					'.Write "<TD></TD>"
        					.Write "<TD align=Center>" & sDisStrngFont & "JIT Late" & sEndStrgFont & "</TD>"
        					.Write "<TD>&nbsp;</TD>"
        				else
        				.Write "<TD colspan=5>&nbsp;</TD>"
        				end if
        				.Write "<TD align=Center>" & sDisStrngFont & "Late" & sEndStrgFont & "</TD>"
      			.Write "</TR>"
      			.Write "<TR>"
        				.Write "<TD align=Center>"
      						'if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
      						'end if
      					.Write "<STRONG>" & vntSumEarlyPercnt & "</STRONG></font></TD>"
 '******************Do we Display Jit WINDOWS 1 = yes
      					if vntSmryType = "1" then
      						'if vntWindow = 1 then
      							.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      							.Write "<TD align=Center>"
      							'.Write "<font size=2 color=red>"
      						'end if
      						.Write "<font size=2 color=red>"
      						.Write "<STRONG>" & vntJITEarlyPercnt & "</STRONG></font></TD>"
        					.Write "<TD colspan=9" & sTDColor & ">&nbsp;</TD>"
        				else
        					.Write "<TD colspan=11" & sTDColor & ">&nbsp;</TD>"
        				end if
        				.Write "<TD colspan=2 align=Center><font size=2 color=blue><STRONG>" & vntInWindowPercnt & "</STRONG></font></TD>"
        				.Write "<TD colspan=5" & sTDColor & ">&nbsp;</TD>"
        				.Write "<TD align=Center><font size=2><STRONG>100%</STRONG></font></TD>"
 '******************Do we Display Jit WINDOWS 1 = yes
        				if vntSmryType = "1" then
        					.Write "<TD colspan=3" & sTDColor & ">&nbsp;</TD>"
        					.Write "<TD align=Center>"
      						'if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
      						'end if
      						.Write "<STRONG>" & vntJITLatePercnt & "</STRONG></font></TD>"
      						.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					else
        					.Write "<TD colspan=5" & sTDColor & ">&nbsp;</TD>"
        				end if
        				.Write "<TD align=Center>"
      						'if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
      						'end if
      					.Write "<STRONG>" & vntSumLatePercnt & "</STRONG></font></TD>"
      			.Write "</TR>"
      		if not vntNetscape then
      			.Write "<TR>"
						.Write "<TD colspan=26" & sTDColor & "></TD>"
				.Write "</TR>"
			end if
      			.Write "<TR>"
         				.Write "<TD align=Center>"
      						'if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
      						'end if
      					.Write "<STRONG>" & vntSumEarly & "</STRONG></font></TD>"
 '******************Do we Display Jit WINDOWS 1 = yes
      					if vntSmryType = "1" then
      						'if vntWindow = 1 then
      							.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      							.Write "<TD align=Center>"
      							.Write "<font size=2 color=red>"
      						'end if
      						.Write "<STRONG>" & vntJITEarly & "</STRONG></font></TD>"
      						'if vntJ then
      						'	.Write "<TD colspan=8" & sTDColor & "></TD>"
      						'	.Write "<TD>J</TD>"
      						'else
        						.Write "<TD colspan=9" & sTDColor & ">&nbsp;</TD>"
        					'end if
        				else
         					.Write "<TD colspan=11" & sTDColor & ">&nbsp;</TD>"
         				end if
         				.Write "<TD colspan=2 align=Center><font size=2 color=blue><STRONG>" & vntInWindow & "</STRONG></font></TD>"
         				.Write "<TD colspan=5" & sTDColor & ">&nbsp;</TD>"
         				.Write "<TD align=Center"
    					if vntSmryType = "1" then
    						vntHold = cdbl(vntArray(13,0)) - cdbl(vntArray(27,0))
    						.Write " title=" & """" & "NON JIT: " & vntHold & "    JIT:" & vntArray(27,0) & """"
    					end if
    					.Write "><font size=2>"
    									'***DISPLAY THE HINT***
      					if vntNetscape and vntSmryType = "1" then
      						.Write "<STRONG>" & vntTotal & "</STRONG></font>"
      						.write "<a href=""javascript:alert('NON JIT:" & vntHold & "   JIT:" & vntArray(27,0) & "');"" name=""a1"" onMouseOver=""JIT(event, '" & vntHold & "', '" & vntArray(27,0) & "');"" onMouseOut=""HideJIT();"">"
      						.write "<font color=white>&nbsp;</font></a></TD>"
      					else
    						if cdbl(vntArray(27,0)) > 0 and vntSmryType = "1" then
    							.write "<font size=2 color=black><STRONG>J &nbsp;</STRONG></font>"
    						end if
    						.write "<STRONG>" & vntTotal & "</STRONG></font></TD>"
    					end if
'******************Do we Display Jit WINDOWS 1 = yes
         				if vntSmryType = "1" then
         					.Write "<TD colspan=3" & sTDColor & ">&nbsp;</TD>"
         					.Write "<TD align=Center>"
         					.Write "<font size=2 color=red>"
      						.Write "<STRONG>" & vntJITLate & "</STRONG></font></TD>"
      						.Write "<TD" & sTDColor & ">&nbsp;</TD>"
      					else
         					.Write "<TD colspan=5" & sTDColor & ">&nbsp;</TD>"
         				end if
         				.Write "<TD align=Center>"
      						'if vntWindow = 1 then
      							.Write "<font size=2 color=red>"
      						'end if
      					.Write "<STRONG>" & vntSumLate & "</STRONG></font></TD>"
       			.Write "</TR>"
      			.Write "<TR>"
      					if vntNetscape then
							.Write "<TD colspan=26" & sTDColor & ">&nbsp;</TD>"
						else
							.Write "<TD colspan=26" & sTDColor & "></TD>"
						end if
				.Write "</TR>"
				.Write "<TR>"
					if vntNetscape then
						.Write "<TD colspan=26" & sTDColor & ">&nbsp;</TD>"
					else
						.Write "<TD colspan=26" & sTDColor & "></TD>"
					end if
		.Write "</TABLE>"
		.Write sHr
		.write "<layer name=""lyrJIT"" id=""lyrJIT"" style=""position:absolute""></layer>"
	end with
else
	PaintNoResults()
end if
end function

Function PaintItByCountry()
Dim intCount
Dim sRow2Color
sRow2Color = " bgcolor=#EEEEEE"
vntJ = false
'***********************Array Definition*************************************************
'0    %_six_plus_early          19   num_on_time
'1    %_five_early              20   num_one_late
'2    %_four_early              21   num_two_late
'3    %_three_early             22   num_three_late
'4    %_two_early               23   num_four_late
'5    %_one_early               24   num_five_late
'6    %_on_time                 25   num_six_plus_late
'7    %_one_late                26   %_tot_early
'8    %_two_late                27   num_tot_early
'9    %_three_late              28   %_tot_jit_early
'10   %_four_late               29   num_tot_jit_early
'11   %_five_late               30   %_tot_on_time
'12   %_six_plus_late           31   num_tot_on_time
'13   num_six_plus_early        32   %_tot_jit_late
'14   num_five_early            33   num_tot_jit_late
'15   num_four_early            34   %_tot_late
'16   num_three_early           35   num_tot_late
'17   num_two_early             36   %_tot
'18   num_one_early             37   num_tot
'                               38   country_name
'*********************************************************************************************

if not isnull(vntarray) then
	With Response
		.Write sHR
		.Write "<TABLE WIDTH=100% BORDER=0 CELLSPACING=0 CELLPADDING=2 align=center>"
				.Write "<TR>"
					.Write "<TD align=left colspan=2>"
						.Write sDisStrngFont2 & "&nbsp;" & sEndStrgFont2 & "</TD>"
					.Write "<TD align=center colspan=11" & sTDColor & ">"
						.Write sDisStrngFont2 & "Days Early" & sEndStrgFont2 & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD colspan=2" & sTDColor & ">&nbsp;</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=center colspan=11" & sTDColor & ">"
						.Write sDisStrngFont2 & "Days Late" & sEndStrgFont2 & "</TD>"
				.Write "</TR>"
				.Write "<TR>"
					.Write "<TD align=left colspan=2>"
						.Write sDisStrngFont2 & "&nbsp;" & sEndStrgFont2 & "</TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "6+" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "5" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "4" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "3" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "2" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "1" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD colspan=2 align=center" & sTDColor & ">" & sDisStrngFont & "0" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "1" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "2" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "3" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "4" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "5" & sEndStrgFont & "</TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center" & sTDColor & ">" & sDisStrngFont & "6+" & sEndStrgFont & "</TD>"
				.Write "</TR>"

			For intCount = 0 To UBound(vntarray, 2)
				.Write "<TR><TD colspan=""28""><hr color=#DCDCDC></TD></TR>"
'***************ROW 1****************************************************************
				.Write "<TR>"
					.Write "<TD align=left colspan=2" & sRow2Color & ">"
						.Write sDisStrngFont2 & vntarray(38, intCount) & sEndStrgFont2 & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 6 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>"
						.Write vntarray(0, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 5 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(1, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 4 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(2, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 3 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(3, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 2 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(4, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 1 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(5, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD colspan=2 align=Center" & sRow2Color & ">"
						.Write "<font size=2 color=blue><STRONG>" & vntarray(6, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 1 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(7, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 2 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(8, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 3 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(9, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 4 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(10, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 5 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(11, intCount) & "</STRONG></font></TD>"
					.Write "<TD" & sRow2Color & ">"
						.Write "&nbsp;" & "</TD>"
					.Write "<TD align=Center" & sRow2Color & ">"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 6 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(12, intCount) & "</STRONG></font></TD>"
				.Write "</TR>"
'************ROW 2*******************************************
				.Write "<TR>"
					.Write "<TD align=left colspan=2>"
						.Write sDisStrngFont2 & "&nbsp;" & sEndStrgFont2 & "</TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 6 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>"
						.Write vntarray(13, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 5 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(14, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 4 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(15, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 3 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(16, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 2 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(17, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysEarly >= 1 Or vntSmryType = "1" then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(18, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD colspan=2 align=Center><font size=2 color=blue><STRONG>" & vntarray(19, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 1 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(20, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 2 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(21, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 3 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(22, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 4 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(23, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 5 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
						.Write "<STRONG>" & vntarray(24, intCount) & "</STRONG></font></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=Center>"
						If vntWindow = 1 then
							.Write "<font size=2 color=red>"
						else
							if vntDaysLate >= 6 then
								.Write "<font size=2 color=blue>"
							else
								.Write "<font size=2 color=red>"
							end if
						End if
					.Write "<STRONG>" & vntarray(25, intCount) & "</STRONG></font></TD>"
				.Write "</TR>"
'************ROW 3*******************************************
				.Write "<TR>"
					.Write "<TD align=left colspan=2>"
						.Write sDisStrngFont2 & "&nbsp;" & sEndStrgFont2 & "</TD>"

					.Write "<TD align=center" & sTDColor & ">"
						.Write sDisFont & "Early:" & sEndDisFont & "</TD>"
					.Write "<TD align=Left colspan=3>"
						.Write "<font size=2 color=red>"
						.Write "<STRONG>" & vntarray(26, intCount) & "&nbsp;&nbsp;" & vntarray(27, intCount) & "</STRONG></font></TD>"

					if vntSmryType = "1" then
						.Write "<TD align=center" & sTDColor & ">"
							.Write sDisFont & "JIT E:" & sEndDisFont & "</TD>"
						.Write "<TD align=Left colspan=3>"
							.Write "<font size=2 color=red>"
							.Write "<STRONG>" & vntarray(28, intCount) & "&nbsp;&nbsp;" & vntarray(29, intCount) & "</STRONG></font></TD>"
					else
						.Write "<TD colspan=4>" & "&nbsp;" & "</TD>"
					end if

					.Write "<TD align=center" & sTDColor & ">"
						.Write sDisFont & "OT:" & sEndDisFont & "</TD>"
					.Write "<TD align=Left colspan=4>"
						.Write "<font size=2 color=blue>"
						.Write "<STRONG>" & vntarray(30, intCount) & "&nbsp;&nbsp;" & vntarray(31, intCount) & "</STRONG></font></TD>"

					.Write "<TD align=center" & sTDColor & ">"
						.Write sDisFont & "Late:" & sEndDisFont & "</TD>"
					.Write "<TD align=Left colspan=3>"
						.Write "<font size=2 color=red>"
						.Write "<STRONG>" & vntarray(34, intCount) & "&nbsp;&nbsp;" & vntarray(35, intCount) & "</STRONG></font></TD>"

					if vntSmryType = "1" then
						.Write "<TD align=center" & sTDColor & ">"
							.Write sDisFont & "JIT L:" & sEndDisFont & "</TD>"
						.Write "<TD align=Left colspan=3>"
							.Write "<font size=2 color=red>"
							.Write "<STRONG>" & vntarray(32, intCount) & "&nbsp;&nbsp;" & vntarray(33, intCount) & "</STRONG></font></TD>"
					else
						.Write "<TD colspan=4>" & "&nbsp;" & "</TD>"
					end if

					.Write "<TD></TD>"
					.Write "<TD></TD>"
					.Write "<TD align=center" & sTDColor & ">"
						.Write sDisFont & "Total:" & sEndDisFont & "</TD>"
					.Write "<TD align=Left colspan=2>"
						.Write "<font size=2 color=black>"
						.Write "<STRONG>" & vntarray(37, intCount) & "</STRONG></font></TD>"
				.Write "</TR>"
			Next
		.Write "</TABLE>"
		GenNavButtons()
		.Write sHr
	end with
else
	PaintNoResults()
end if
End function

Function PaintNoResults()
	Response.Write "<br><strong><font size=6 color=red>Sorry...</font></strong><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;The search criteria you entered did <br>"
	Response.Write "not produce any results.<br><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;Please click on the " & """" & "Return Button" & """" & "<BR>"
	Response.Write "to go back to the Search Criteria Screen.<br>"
	if Session("AdminUser") = "true" then
		Response.Write "Error Number: " & vntErrorNumber & "<br>"
		Response.Write "Error Desc: " & vntErrorDesc & "<br>"
	end if
End function

Function PaintCriteria()
	with response
		.Write "<TABLE WIDTH=100% BORDER=0 CELLSPACING=0 CELLPADDING=0 align=left>"
			.Write "<TR>"
				.Write "<TD>"
				.Write "<font size=2>" & vntDispCrit & "</font>"
				.Write "</TD>"
			.Write "</TR>"
		.Write "</TABLE>"
		.Write "<br><br>"
  end with
end function

'Call your functions and/or subs
GenHtmlHead()
GenNavButtons()
if vntQSInd = "1" and not (vntQSRT = "1" or vntQSRT = "2") then
	GetList()
else
	GetDailyList()
end if
'GetList()
if vntQSRT = "1" or vntQSRT = "2" then
	paintitByCountry()
else
	paintit()
end if
PaintCriteria()
if Session("AdminUser") = "true" then
	response.Write vntsql
end if
Response.Write "</form>"
%>

<!--#include file=include/errHandler.inc-->
<script language = "JavaScript">

function Test ()
{
	alert("test")
}
        function JIT(evt, strNJIT, strJIT){

            var theLayer = document.layers['lyrJIT'];
                var strOutput = 'NON JIT=' + strNJIT + '&nbsp;&nbsp;:&nbsp;&nbsp;JIT=' + strJIT;

                theLayer.top = evt.pageY - 20;
                theLayer.left = evt.pageX;

                theLayer.bgColor = 'white';
                theLayer.document.open();
                theLayer.document.writeln(strOutput);
                theLayer.document.close();

                return true;
        }

        function HideJIT(){

            var theLayer = document.layers['lyrJIT'];
                        theLayer.document.open();
                        theLayer.document.writeln('');
                        theLayer.document.close();
                        theLayer.document.bgColor = null;
        }
</script>