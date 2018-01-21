<%@ Language=VBScript %>
<% Option Explicit %>
<% Response.Buffer = True %>
<% Session.Timeout = 360 
   Response.Expires = 0	%>
<!--#include file=include/colors.inc-->
<!--#include file=include/security.inc-->
<!--#include file=include/constants.inc-->
<%
'Declare your variables
Dim objError
Dim errWhere
Dim errDesc

'Initialize your variables
objError = 0
errDesc = vbNullString
errWhere = vbNullString

Dim blnDebug
	blnDebug = False
'	blnDebug = True

'Uncomment when security matters
If Not MrSecurity Then
	If blnDebug Then
		'Testing
		lsUID = "51727"
		lsAmpID = "AMP51727"
	Else
		Response.Redirect Application("Login")
		Response.End
    End If
End If

Dim strMode
	strMode = "List"

Dim strReturnBtn
	strReturnBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Return"">"

Dim vntCommand
	vntCommand		= Trim(Request.Form("smtSubmit"))

' object vars
Dim	objAnnounce, vntErrorNum, vntErrorDesc, vntAnnounce

Function GenHtmlHead()
	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>" & Application("AppAbrv") & " - " & "Information/News</title>"
	RwLf "</head>"
	RwLf "<body bgcolor=""#FFFFFF"""
	RwLf " topmargin=""1"""
	RwLf " alink=""lime"""
	RwLf " vlink=""red"""
	RwLf " link=""red"""
	RwLf " style=""font-family: Times New Roman, sans-serif"" onload=""ErrHandler();"">"
	RwLf "<form name=""frmMain"" id=""frmMain"" method=""post"" action=""histannounce.asp"">"

	RwLf "<table border=""1"" bordercolor=""" & sNavBorder & """ cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "<td>"
	RwLf "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "	<tr " & sNavTopHeader & ">"
	RwLf "		<td width=""20%"" align=""center""><a href=""home.asp"">Home</a></td>"
	RwLf "		<td width=""20%"">&nbsp;</td>"
	RwLf "		<td width=""20%"">&nbsp;</td>"
	RwLf "		<td width=""20%"">&nbsp;</td>"
	RwLf "		<td width=""20%"" align=""center"">"
	RwLf "		<a href=" & strServerUrl & appHelp & Application("Help") & " target=""Help Window"">Help</a></td>"
%>
	<!--#include file=include/NavMiddle.inc-->
<%
	RwLf "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Information/News</b></font></td>"
%>
	<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
End Function

Function GenListScreen()
	Dim intRow, intCol, strToday, strMonth, strDay, arrList, bln1stRow, blnHistory

	GenHtmlHead

	RwLf "<td align=""center"" colspan=""4"">"
	RwLf strReturnBtn 
	RwLf "</td>"

	RwLf "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""2"" align=""center"" name=""tblMain"" id=""tblMain"">"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	If Not IsObject(objAnnounce) Then
		Set objAnnounce = Server.CreateObject("DSCD.clsAnnounce")
		If err.number <> 0 Then
			objError = Err.number
			errDesc = Err.description
			errWhere = "Create Object objAnnounce"
			exit function		
		End If
	end if
	
	strMonth = cStr(Month(Date))
	if len(strMonth) < 2 then
		strMonth = "0" + strMonth
	end if
	strDay = cStr(Day(Date))
	if len(strDay) < 2 then
		strDay = "0" + strDay
	end if
	strToday = CStr(Year(Date)) + "-" +  strMonth + "-" + strDay

	arrList = objAnnounce.List2("Y", vntErrorNum, vntErrorDesc)
	If vntErrorNum <> 0 Then
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "retrieving anouncement list"
		exit function
	End If

	RwLf "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"

	If IsArray(arrList) Then
		'record details
		bln1stRow = True
		blnHistory = False
		For intRow = LBound(arrList, 2) To UBound(arrList, 2)
'			If arrList(1, intRow) = "N" or blnHistory Then
				If bln1stRow Then 
					bln1stRow = False
				Else 
					RwLf "<tr><td colspan=""3""><hr color=#DCDCDC></td></tr>"
				End if
				RwLf "<tr><td>" & arrList(2, intRow) & "</td></tr>"
'			End If
'			If arrList(1, intRow) = "Y" then blnHistory = True
		Next
	Else
		RwLf "No historical announcement to list!<br><br>"		
	End If

	RwLf "</table>"
	
	GenFooter	
End Function

Function GenDisplayError()
	objError	= vntErrorNum
	errDesc		= vntErrorDesc
	If errWhere = vbNullString Then errWhere = "the application"
	GenHTMLHead
	GenFooter
End Function

Sub GenFooter()
	RwLf "</table>"
	RwLf "</form></body></html>"	
End Sub

Sub Cleanup_Objects()
	If IsObject(objAnnounce) then Set objAnnounce = Nothing
End Sub

Sub Rw(strIn)
	Response.Write strIn
End Sub

Sub RwLf(strIn)
	Response.Write strIn
	Response.Write vbCrLf
End Sub

' main process
If vntCommand = "Return" Then	
	Cleanup_Objects()
	Response.Redirect Application("Home")
	Response.End
Else	
	GenListScreen	
End If

%>
<!--#include file=include/errHandler.inc-->
