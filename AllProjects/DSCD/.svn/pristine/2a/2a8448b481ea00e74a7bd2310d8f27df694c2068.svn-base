<% @ Language=VBScript %>
<% Option Explicit

Response.Buffer = True
Session.Timeout = 240
Response.Expires = 0

%>
<!--#include file=include/security.inc-->
<!--#include file=include/constants.inc-->
<%
Dim blnDebug
	blnDebug = False
'	blnDebug = True

If Not MrSecurity Then
	If blnDebug Then
		'TESTING
		lsUID = "12345"
		lsAmpID = "TESTING"
	Else
		Response.Redirect Application("Login")
		Response.End
	End If
End If
%>
<!--#include file=include/colors.inc-->
<!--#include file=include/ArrayFunctions.inc-->
<%

'***********************************************************************
'*********	Housekeeping
'***********************************************************************

Dim vntErrorNumber, vntErrorDesc
	vntErrorNumber = 0
	vntErrorDesc = vbNullString
Dim blnError
	blnError = False
Dim objError
	objError = 0
Dim errWhere
	errWhere = vbNullString
Dim errDesc
	errDesc = vbNullString


	Dim inx, inxRow, inxCol

	'indexes for array from objHoliday.List
	Dim inxOrgKey, inxOrg, inxOrgDesc, inxBldg, inxLoc, inxHolDt, inxUser, inxTS
		inxOrgKey	= 0
		inxOrg		= 1
		inxOrgDesc	= 2
		inxBldg		= 3
		inxLoc		= 4
		inxHolDt	= 5
		inxUser		= 6
		inxTS		= 7

	'indexes for radio values
	Dim xOrgKey, xOrg, xOrgDesc, xBldg, xLoc, xHolDt
		xOrgKey		= 0
		xOrg		= 1
		xOrgDesc	= 2
		xBldg		= 3
		xLoc		= 4
		xHolDt		= 5

	Dim vntReportingOrg, vntBldgNbr, vntLocationCde, vntHolidayDt
	Dim vntReportingOrgKeyID, vntReportingOrgDesc, arrTemp
		vntReportingOrgKeyID	= vbNullString
		vntReportingOrgDesc		= vbNullString
		'vntReportingOrg	= Trim(Request.Form("txtReportingOrg"))
		vntReportingOrg	= vbNullString
		vntBldgNbr		= Trim(Request.Form("txtBldgNbr"))
		vntLocationCde	= Trim(Request.Form("txtLocationCde"))
		IF vntLocationCde = vbNullString then vntLocationCde = "00"
		vntHolidayDt	= Trim(Request.Form("txtHolidayDt"))

		If Trim(Request.Form("selReportingOrg")) <> vbNullString Then
			arrTemp = Split(Trim(Request.Form("selReportingOrg")), "|")
			vntReportingOrgKeyID	= arrTemp(0)
			vntReportingOrg			= arrTemp(1)
		End If

	Dim vntKeyBldgNbr, vntKeyLocationCde, vntKeyHolidayDt
		vntKeyBldgNbr		= vbNullString
		vntKeyLocationCde	= vbNullString
		vntKeyHolidayDt		= vbNullString


	Dim strBtnReturn, strBtnAdd, strBtnUpdate, strBtnDelete, strBtnSubmit, strBtnCancel, strBtnContinue, strBtnBack
		strBtnReturn	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Return"">"
		strBtnAdd		= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Add"">"
		strBtnUpdate	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Update"" onclick=""return(validate_selection('Update', false));"">"
		strBtnDelete	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Delete"" onclick=""return(validate_selection('Delete', true));"">"
		strBtnSubmit	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Submit"" onclick=""return(validate_entries());"">"
		strBtnCancel	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Cancel"">"
		strBtnContinue	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Continue"">"
		strBtnBack		= "<input type=""button"" name=""btnBack"" id=""btnBack"" value=""Back"" onclick=""history.back();"">"

	Dim vntCommand, vntMode, strMsg
		vntCommand	= Ucase(Trim(Request.Form("smtCommand")))
		vntMode		= Ucase(Trim(Request.Form("hdnMode")))
		If vntMode = vbNullString Then vntMode = "LIST"
		strMsg = vbNullString

	Dim objHoliday, objOrgs, arrList, blnRC
	If vntCommand <> "UPDATE" AND vntCommand <> "ADD" AND vntCommand <> "RETURN" Then Set objHoliday = Server.CreateObject("DSCD.clsHolidaySchd")


'***********************************************************************
'*********	Main Processing
'***********************************************************************

	If Not blnError Then

		If vntCommand = "RETURN" Then
			Response.Redirect Application("Home")
			Response.End
		ElseIf vntCommand = "SUBMIT" Then
			blnRC = objHoliday.Validate(vntReportingOrgKeyID, vntBldgNbr, vntLocationCde, vntHolidayDt, lsAmpID, vntErrorNumber, vntErrorDesc)
			IF Not blnRC then
				ReportError vntErrorNumber, vntErrorDesc, "validating the record"
			else
			If vntMode = "UPDATE" Then
				GetKeys
				blnRC = objHoliday.Update(vntReportingOrgKeyID, vntBldgNbr, vntLocationCde, vntHolidayDt, vntKeyBldgNbr, vntKeyLocationCde, vntKeyHolidayDt, lsAmpID, vntErrorNumber, vntErrorDesc)
				If blnRC And vntErrorNumber = 0 Then
					vntMode = "LIST"
					strMsg = "Record Updated"
				Else
					ReportError vntErrorNumber, vntErrorDesc, "updating the record"
				End If
			ElseIf vntMode = "ADD" Then
				blnRC = objHoliday.Insert(vntReportingOrgKeyID, vntBldgNbr, vntLocationCde, vntHolidayDt, lsAmpID, vntErrorNumber, vntErrorDesc)
				If blnRC And vntErrorNumber = 0 Then
					strMsg = "Record Added - (Org:&nbsp;" & vntReportingOrg & ") - (Bldg:&nbsp;" & vntBldgNbr & ") - (Location:&nbsp;" & vntLocationCde & ") - (Date:&nbsp;" & vntHolidayDt & ")"
				Else
					ReportError vntErrorNumber, vntErrorDesc, "inserting the record"
				End If
			Else
				ReportError vntErrorNumber, vntErrorDesc, "determining the application mode"
			End If
			end if
		ElseIf vntCommand = "UPDATE" Then
			GetValues
			vntMode = vntCommand
		ElseIf vntCommand = "ADD" Then
			vntMode = vntCommand
		ElseIf vntCommand = "DELETE" Then
			GetValues
			blnRC = objHoliday.Delete(vntReportingOrgKeyID, vntBldgNbr, vntLocationCde, vntHolidayDt, vntErrorNumber, vntErrorDesc)
			If blnRC And vntErrorNumber = 0 Then
				vntMode = "LIST"
				strMsg = "Record Deleted - (Org:&nbsp;" & vntReportingOrg & ") - (Bldg:&nbsp;" & vntBldgNbr & ") - (Location:&nbsp;" & vntLocationCde & ") - (Date:&nbsp;" & vntHolidayDt & ")"
			Else
				ReportError vntErrorNumber, vntErrorDesc, "deleting the record"
			End If
		Else
			vntMode = "LIST"
		End If
	End If


	Select Case vntMode
	Case "UPDATE", "ADD", "LIST":
		Dim inxOrgType, strTempOrgTypeID, arrOrgTypes, arrOrgIDs, arrOrgIDCols, arrOrgIDRows
			strTempOrgTypeID = vbNullString

		Set objOrgs = Server.CreateObject("DSCD.clsOrgs")

		arrOrgTypes = objOrgs.ListType(vntErrorNumber, vntErrorDesc)
		If IsArray(arrOrgTypes) Then

			For inxOrgType = LBound(arrOrgTypes, 2) To UBound(arrOrgTypes, 2)

                If InStr(1, arrOrgTypes(1, inxOrgType), "COMPANY", vbTextCompare) > 0 Then
	                strTempOrgTypeID = arrOrgTypes(0, inxOrgType)
	                arrList = vbNullString
					arrList = objOrgs.ListOrgIDs(strTempOrgTypeID, vntErrorNumber, vntErrorDesc)
					If IsArray(arrList) Then
						If IsArray(arrOrgIDs) Then
							arrOrgIDCols = -1 
							arrOrgIDRows = UBound(arrOrgIDs, 2)
							Redim Preserve arrOrgIDs(UBound(arrOrgIDs, 1), (UBound(arrOrgIDs, 2) + UBound(arrList, 2) + 1))
						Else
							arrOrgIDCols = -1
							arrOrgIDRows = -1
							Redim arrOrgIDs(UBound(arrList, 1), UBound(arrList, 2))
						End If
						For inxRow = LBound(arrList, 2) To UBound(arrList, 2)
							For inxCol = LBound(arrList, 1) To UBound(arrList, 1)
								arrOrgIDs((arrOrgIDCols + inxCol + 1), (arrOrgIDRows + inxRow + 1)) = arrList(inxCol, inxRow)
							Next
						Next
					End If
				End If
			Next
		End If
		If vntErrorNumber = 0 Then
			if vntMode = "LIST" then		
				If vntReportingOrgKeyID = vbNullString then	
					blnRC = objHoliday.GetLatestOrgKeyID(lsUID, vntReportingOrgKeyID, vntErrorNumber, vntErrorDesc)
					If vntReportingOrgKeyID = vbNullString then	vntReportingOrgKeyID = Cint(arrOrgIDs(0, LBound(arrOrgIDs, 2)))
				end if
				arrList = objHoliday.List(vntReportingOrgKeyID, vntErrorNumber, vntErrorDesc)
				If vntErrorNumber = 0 Then
					DisplayList arrOrgIDs, arrList, strMsg
				Else
					ReportError vntErrorNumber, vntErrorDesc, "Retrieve List"
					DisplayError
				End If
			else
				DisplayDetail arrOrgIDs, strMsg
			end if
		Else
			ReportError vntErrorNumber, vntErrorDesc, "Retrieve Orgs"
			DisplayError
		End If
		Set objOrgs = Nothing
	Case "ERROR":
		DisplayError
'	Case Else:
'		arrList = objHoliday.List(vntErrorNumber, vntErrorDesc)
'		If vntErrorNumber = 0 Then
'			DisplayList arrList, strMsg
'		Else
'			ReportError vntErrorNumber, vntErrorDesc, "Retrieve List"
'			DisplayError
'		End If
	End Select

	Set objHoliday = Nothing


'***********************************************************************
'*********	End Processing
'***********************************************************************



'####################################################
'#
'#             Functions and Subroutines
'#
'####################################################

Function GetKeys()
	Dim vntKeys, arrKeys
		vntKeys = Trim(Request.Form("rdoSelected"))
		If vntKeys <> vbNullString Then arrKeys = split(vntKeys, "|")
		If IsArray(arrKeys) Then
			vntKeyBldgNbr		= arrKeys(xBldg)
			vntKeyLocationCde	= arrKeys(xLoc)
			vntKeyHolidayDt		= arrKeys(xHolDt)
			If blnDebug Then
				RwLf "<br>vntKeyBldgNbr = " & vntKeyBldgNbr
				RwLf "<br>vntKeyLocationCde = " & vntKeyLocationCde
				RwLf "<br>vntKeyHolidayDt = " & vntKeyHolidayDt
			End If
		Else
			ReportError -13, "No Keys Found", "GetKeys"
		End If
End Function


Function GetValues()
	Dim vntVals, arrVals
		vntVals = Trim(Request.Form("rdoSelected"))
		If vntVals <> vbNullString Then arrVals = split(vntVals, "|")
		If IsArray(arrVals) Then
			vntReportingOrgKeyID	= arrVals(xOrgKey)
			vntReportingOrg			= arrVals(xOrg)
			vntReportingOrgDesc		= arrVals(xOrgDesc)
			vntBldgNbr				= arrVals(xBldg)
			vntLocationCde			= arrVals(xLoc)
			vntHolidayDt			= arrVals(xHolDt)
			If blnDebug Then
				RwLf "<br>vntReportingOrgKeyID = " & vntReportingOrgKeyID
				RwLf "<br>vntReportingOrg = " & vntReportingOrg
				RwLf "<br>vntBldgNbr = " & vntBldgNbr
				RwLf "<br>vntLocationCde = " & vntLocationCde
				RwLf "<br>vntHolidayDt = " & vntHolidayDt
			End If
		Else
			ReportError -13, "No Values Found", "GetValues"
		End If
End Function


Sub GenHTMLHead()

	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>DSCD - Holiday Maintenance</title>"

	GenJS_StartUp
	If vntMode = "LIST" Then
		GenJS_List
	ElseIf vntMode = "UPDATE" OR vntMode = "ADD" Then
		GenJS_Edit
	End If

	RwLf "</head>"
	RwLf "<body bgcolor=""#FFFFFF"""
	RwLf " topmargin=""1"""
	RwLf " alink=""lime"""
	RwLf " vlink=""red"""
	RwLf " link=""red"""
	RwLf " style=""font-family: Times New Roman, sans-serif"" onload=""start_up();"">"
	RwLf "<form name=""frmMain"" id=""frmMain"" method=""post"" action""hldysched.asp"">"

	RwLf "<table border=""1"" bordercolor=""" & sNavBorder & """ cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "<td>"
	RwLf "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "	<tr " & sNavTopHeader & ">"
	RwLf "		<td width=""20%"" align=""center""><a href=""" & Application("Home") & """>Home</a></td>"
	RwLf "		<td width=""20%"">&nbsp;</td>"
	RwLf "		<td width=""20%"">&nbsp;</td>"
	RwLf "		<td width=""20%"">&nbsp;</td>"
	RwLf "		<td width=""20%"" align=""center"">"
	RwLf "		<a href=" & strServerUrl & appHelp & Application("Help") & " target=""Help Window"">Help</a></td>"
%>
<!--#include file=include/NavMiddle.inc-->
<%
	RwLf "	<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Holiday Parameter Maintenance</b></font></td>"
%>
<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
	RwLf "<br>"
End Sub


Sub GenHTMLFoot()
	RwLf "<input type=""hidden"" name=""hdnMode"" id=""hdnMode"" value=""" & vntMode & """>"
	RwLf "</form></body></html>"
End Sub


Function DisplayList(arrOrgs, arrArray, strMessage)

	Dim arrColHeaders

	arrColHeaders = Array("Sel", "Reporting Org", "Plant/Building Nbr", "Location Code", "Holiday Date", "User Id", "Date Changed")

    Dim strButtons
		strButtons = strBtnReturn & "&nbsp;&nbsp;" & strBtnAdd & "&nbsp;&nbsp;" & strBtnUpdate & "&nbsp;&nbsp;" & strBtnDelete

	GenHTMLHead

	RwLf strButtons

	RwLf "<tr>"
	RwLf "<th align=""right"" width=""25%"">"
	RwLf "<font size=""2""><strong>Reporting&nbsp;Org:&nbsp;&nbsp;</strong></font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	RwLf "<select name=""selReportingOrg"" id=""selReportingOrg"" onchange=""refresh_screen()"">"

	Dim inxRow, inxCol
	If IsArray(arrOrgs) Then
			For inxRow = LBound(arrOrgs, 2) To UBound(arrOrgs, 2)
				Rw "<option value=""" & arrOrgs(0, inxRow) & "|" & arrOrgs(3, inxRow) & """"
				If vntReportingOrgKeyID <> vbNullString Then If CInt(arrOrgs(0, inxRow)) = CInt(vntReportingOrgKeyID) Then Rw " SELECTED"
				RwLf ">" & arrOrgs(3, inxRow) & "</option>"
			Next
	Else
		RwLf "<option value=""-1"">Error - Orgs Could Not Be Retrieved</option>"
	End If
	RwLf "</select>"
	RwLf "</td>"
	RwLf "</tr>"

	RwLf sHR

	If IsArray(arrArray) Then

		RwLf "<br><table border=""1"" width=""100%"" " & sTableBorder & ">"

		If strMessage <> vbNullString Then
			RwLf "<tr " & sTableHeadBg & ">"
			RwLf "<td colspan=""" & Cstr(UBound(arrColHeaders) + 1) & """><font size=""2"" " & sTableHeadFont & ">" & strMessage & "</font></td>"
			RwLf "</tr>"
		End If

		'Column Headers
		RwLf "<tr " & sTableHeadBg & ">"
		For inx = LBound(arrColHeaders) To UBound(arrColHeaders)
			RwLf "<th><font size=""2"" " & sTableHeadFont & ">" & arrColHeaders(inx) & "</font></td>"
		Next
		RwLf "</tr>"

		Dim strRowColor
		strRowColor = sRow1Color
		For inxRow = LBound(arrArray, 2) To UBound(arrArray, 2)
			RwLf "<tr " & strRowColor & ">"
			RwLf "<td><input type=""radio"" name=""rdoSelected"" id=""rdoSelected"" value=""" & arrArray(inxOrgKey, inxRow) & "|" & FormatOrg(arrArray(inxOrg, inxRow)) & "|" & arrArray(inxOrgDesc, inxRow) & "|" & arrArray(inxBldg, inxRow) & "|" & arrArray(inxLoc, inxRow) & "|" & arrArray(inxHolDt, inxRow) & """ onclick=""blnSelected=true;""></td>"
			For inxCol = inxOrgDesc To UBound(arrArray, 1)
				RwLf "<td><font size=""2"">"
				If inxCol <> inxOrgDesc Then
					Rw arrArray(inxCol, inxRow)
				Else
					Rw FormatOrg(arrArray(inxOrg, inxRow)) & " - "
					If Not IsNull(arrArray(inxOrgDesc, inxRow)) Then
						Rw arrArray(inxOrgDesc, inxRow)
					Else
						Rw "Not a ScoreCard Org"
					End If
				End If
				RwLf "</font></td>"
			Next
		    RwLf "</tr>"
		    If strRowColor = sRow1Color Then
		    	strRowColor = sRow2Color
		    Else
		    	strRowColor = sRow1Color
		    End If
		Next
		RwLf "</table>"

		RwLf sHR
		RwLf strButtons
	Else
		RwLf "<center><h2>No Holiday Parameters Found</h2></center><br><br>"
	End If
	GenHTMLFoot

End Function


Sub DisplayDetail(arrOrgs, strMessage)

    Dim strButtons
		strButtons = vbNullString
		If IsArray(arrOrgs) Then strButtons = strBtnSubmit & "&nbsp;&nbsp;"
		strButtons = strButtons & strBtnCancel

	If strMessage = vbNullString Then
		strMessage = "<font size=""4"" " & sTableHeadFont & ">" & Left(vntMode, 1) & LCase(Mid(vntMode, 2)) & " Holiday Parameters</font>"
	Else
		strMessage = "<font size=""4"" " & sTableHeadFont & ">" & Left(vntMode, 1) & LCase(Mid(vntMode, 2)) & " Holiday Parameters</font><font size=""2"" " & sTableHeadFont & ">&nbsp;&nbsp;&nbsp;&nbsp;--&nbsp;&nbsp;" & strMessage & "</font>"
	End If

	GenHTMLHead
	RwLf strButtons
	RwLf sHR
	RwLf "<table border=""0"" width=""100%"">"

	RwLf "<tr>"
	RwLf "<td colspan=""2"" " & sTableHeadBg & ">"
	RwLf strMessage
	RwLf "</td>"
	RwLf "</tr>"

	RwLf "<tr>"
	RwLf "<th align=""right"" width=""25%"">"
	RwLf "<font size=""2"">Reporting&nbsp;Org:&nbsp;&nbsp;</font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	'RwLf "<input type=""text"" name=""txtReportingOrg"" id=""txtReportingOrg"" value=""" & vntReportingOrg & """>"
	RwLf "<select name=""selReportingOrg"" id=""selReportingOrg"">"

	Dim inxRow, inxCol
	If IsArray(arrOrgs) Then
'		If vntMode = "ADD" Then
'			For inxRow = LBound(arrOrgs, 2) To UBound(arrOrgs, 2)
'				Rw "<option value=""" & arrOrgs(0, inxRow) & "|" & arrOrgs(3, inxRow) & """"
'				RwLf ">" & arrOrgs(3, inxRow) & "</option>"
'			Next
'		Else
			For inxRow = LBound(arrOrgs, 2) To UBound(arrOrgs, 2)
				Rw "<option value=""" & arrOrgs(0, inxRow) & "|" & arrOrgs(3, inxRow) & """"
				If vntReportingOrgKeyID <> vbNullString Then If CInt(arrOrgs(0, inxRow)) = CInt(vntReportingOrgKeyID) Then Rw " SELECTED"
				RwLf ">" & arrOrgs(3, inxRow) & "</option>"
			Next
'		End If
	Else
		RwLf "<option value=""-1"">Error - Orgs Could Not Be Retrieved</option>"
	End If
	RwLf "</select>"
	RwLf "</td>"
	RwLf "</tr>"

	RwLf "<tr>"
	RwLf "<th align=""right"">"
	RwLf "<font size=""2"">Plant/Building&nbsp;Nbr:&nbsp;&nbsp;</font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	RwLf "<input type=""text"" name=""txtBldgNbr"" id=""txtBldgNbr"" value=""" & vntBldgNbr & """ maxlength=""4"" size=""6"">"
	RwLf "</td>"
	RwLf "</tr>"

	RwLf "<tr>"
	RwLf "<th align=""right"">"
	RwLf "<font size=""2"">Location&nbsp;Code:&nbsp;&nbsp;</font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	RwLf "<input type=""text"" name=""txtLocationCde"" id=""txtLocationCde"" value=""" & vntLocationCde & """ maxlength=""4"" size=""6"">"
	RwLf "</td>"
	RwLf "</tr>"

	RwLf "<tr>"
	RwLf "<th align=""right"">"
	RwLf "<font size=""2"">Holiday&nbsp;Date:&nbsp;&nbsp;</font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	RwLf "<input type=""text"" name=""txtHolidayDt"" id=""txtHolidayDt"" value=""" & vntHolidayDt & """ maxlength=""10"" size=""12"">"
	RWLf "(YYYY-MM-DD)"
	RwLf "</td>"
	RwLf "</tr>"

	RwLf "</table>"
	RwLf sHR
	RwLf strButtons

	RwLf "<input type=""hidden"" name=""rdoSelected"" id=""rdoSelected"" value=""" & Trim(Request.Form("rdoSelected")) & """>"
	GenHTMLFoot

End Sub


Function DisplayError()

	If errWhere = vbNullString Then errWhere = "the application"

	GenHTMLHead
	RwLf "<font size=""2""><table border=""0"">"
	RwLf "<tr bgcolor=""#EEEEEE"">"
	RwLf "<td>"
'	RwLf "There has been an error in " & errWhere & ":<br>Number:&nbsp;&nbsp;" & vntErrorNumber & "<br>Description:&nbsp;&nbsp;" & vntErrorDesc
	RwLf "</td></tr>"
	RwLf "<tr><td>"
'	RwLf strBtnContinue
	RwLf "</td></tr></table></font>"
	GenHTMLFoot
End Function

Sub ReportError(vntEN, vntED, vntEW)

	objError = vntEN
	errDesc = vntED
	errWhere = vntEW
	blnError = True
	vntMode = "ERROR"
End Sub


Function FormatOrg(strOrgIn)

	Dim strOrg

	If IsNull(strOrgIn) Then
		strOrg = vbNullString
	Else
		strOrg = Trim(strOrgIn)
	End If

	FormatOrg = Replace(Space(4 - Len(strOrg)) & strOrg, " ", "0")

End Function


Sub RwLf(strIn)
	Response.Write strIn
	Response.Write vbCrLf
End Sub

Sub Rw(strIn)
	Response.Write strIn
End Sub


Sub GenJS_StartUp()
	GenJS_Common
%>
<!--#include file=include/errHandler.inc-->
<script language="javascript">
<!--

	var theForm;
	var blnSelected = false;

	function start_up(){

		theForm = document.forms[0];
		ErrHandler();
	}

// -->
</script>
<%
End Sub


Sub GenJS_Common()
%>
<!--#include file=include/JSFunctions.inc-->
<%
End Sub


Sub GenJS_Edit()
	Dim inxRow, inxOrgID
		inxOrgID = 2
%>
<script language="javascript">
<!--
	var	arrValidOrgs = new Array();
<%	IF IsArray(arrList) THEN
		FOR inxRow = LBound(arrList, 2) To UBound(arrList, 2)
			RwLf "		push(arrValidOrgs, '" & FormatOrg(arrList(inxOrgID, inxRow)) & "');"
		NEXT
	END IF
%>

	function validate_entries(){

		var blnContinue = false;
//		var blnValidOrg = false;

		switch(blnContinue){
		default:
/*			if(!(theForm.txtReportingOrg.value)){
				alert('Please enter a valid Reporting Org Code');
				theForm.txtReportingOrg.focus();
				theForm.txtReportingOrg.select();
				break;
			}	
*/
			theForm.txtBldgNbr.value = theForm.txtBldgNbr.value.toUpperCase();
			if(!(theForm.txtBldgNbr.value)){
				alert('Please enter a valid Plant/Building Number');
				theForm.txtBldgNbr.focus();
				theForm.txtBldgNbr.select();
				break;
			}
			theForm.txtLocationCde.value = theForm.txtLocationCde.value.toUpperCase();
			if(!(theForm.txtLocationCde.value)){
				alert('Please enter a valid Location Code');
				theForm.txtLocationCde.focus();
				theForm.txtLocationCde.select();
				break;
			}
			if(!(IsValidDate(theForm.txtHolidayDt.value))){
				alert('Please enter a valid Holiday Date');
				theForm.txtHolidayDt.focus();
				theForm.txtHolidayDt.select();
				break;
			}
/*			for(i=0;i < arrValidOrgs.length; i++){
				blnValidOrg = (arrValidOrgs[i] == theForm.txtReportingOrg.value);
				if(blnValidOrg)	break;
			}
			if(!(blnValidOrg)){
				alert('Please enter a valid Reporting Org Code');
				theForm.txtReportingOrg.focus();
				theForm.txtReportingOrg.select();
				break;
			}
*/
			blnContinue = true;
		}
		return(blnContinue);
	}

// -->
</script>
<%
End Sub


Sub GenJS_List()
%>
<script language="javascript">
<!--

	function validate_selection(strAction, blnConfirm){

		var blnContinue = false;

		blnContinue = blnSelected;

		if(blnContinue){
			if(blnConfirm)	blnContinue = confirm(strAction + ' selected record?');
		}
		else{
			alert('Please select a record to ' + strAction);
		}

		return(blnContinue);
	}
	
	function refresh_screen(){
		document.frmMain.submit()
	}	

// -->
</script>
<%
End Sub



%>