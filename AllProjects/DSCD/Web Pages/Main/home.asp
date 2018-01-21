<%@ Language=VBScript %>
<%
Option Explicit
Response.Buffer = True
Session.Timeout = 240
Response.Expires = 0
%>
<!--#include file=include/colors.inc-->
<!--#include file=include/Constants.inc-->
<!--#include file=include/security.inc-->
<!--#include file=include/GetBrowserVersion.inc-->
<%

'Declare your variables
Dim objError
Dim errWhere
Dim errDesc
Dim intUserLevel
Dim vntNetscape
Dim strBrowser
Dim strVer
Dim strOS

'Initialize your variables
objError = 0
errDesc = vbNullString
errWhere = vbNullString
intUserLevel = 0
vntNetscape = 0

Dim blnDebug
	blnDebug = False
'	blnDebug = True

'Uncomment when security matters
If Not MrSecurity Then
	If blnDebug Then
		'Testing
		lsUID = "51727"
		lsAmpID = "AMP51727"
'		lsAmpID = "SCD_0003"
	Else
		Response.Redirect Application("Login")
		Response.End
    End If
End If

'object vars
Dim objUser, vntErrNum, vntErrDesc, vntUser, objAnnounce, vntAnnounce

if Request.QueryString ("goUrl") <> "" then
	dim redirector
	GetUserLevel()
	UpdateProfile()
	redirector = strServerUrl & appPath & Request.QueryString ("goUrl") & "&v=" & Request.QueryString ("v") & "&c=" & Request.QueryString ("c") & "&w=" & Request.QueryString ("w") & "&mdi=" & Request.QueryString ("mdi")' & "&v=3&c=2&w=2&mdi=1"
	'Response.Write redirector
	Response.redirect (redirector)
end if
GetBrowserVersion strBrowser, strVer, strOS
if instr(strBrowser, "Explorer") = 0 then
	vntNetscape = 1
end if

Function GenHtmlHead()
	RwLf "<html>"
	RwLf "<head>"
	RwLf "<meta NAME=""GENERATOR"" Content=""Microsoft Visual InterDev 1.0"">"

	RwLf "<link rel=stylesheet type=text/css href=theme.css />"

	RwLf "</head>"
	RwLf "<BODY onLoad=ErrHandler()>"
	RwLf "<FORM name=frmHome action=home.asp method=post>"


	RwLf "	<table width=100% border=0 cellspacing=0 cellpadding=0>"
	RwLf "	  <tr>"
	RwLf "	    <td colspan=2>"

	RwLf "	    <table width=100% border=0 cellspacing=0 cellpadding=0>"
	RwLf "      <tr>"
	RwLf "        <td width=20><img src=images/TE_logo.gif></td>"
	RwLf "        <td valign=bottom align=left width=500><img src=images/site_icon.gif></td>"
	RwLf "        <td align=right valign=bottom><B><font size=4 color=#004080>Global Delivery Scorecard</font>&nbsp;&nbsp;</B></FONT><br><B><a href=home.asp class=nounderline>Home</a> | <a href=/dscd/help/dscdhelp.htm class=nounderline>Help</a></B>&nbsp;&nbsp;</td>"
	RwLf "      <tr>"
	RwLf "        <td background=images/ridge_edge.gif colspan=3 valign=top><img src=images/ridge.gif></td>"
	RwLf "      </tr>"
	RwLf "	    </table>"

	RwLf "	    </td>"
	RwLf "	  </tr>	"
	RwLf "	</table>"
	RwLf "<BR>"

End Function

Function GenNavBar()
	Dim sHeaderCell, sItemCell, sCloseCell, sgscwebUrl

	RwLf "<form action=""home.asp"" method=""post"" id=form1 name=form1>"
	sHeaderCell = "<tr" & sNavBotHeader & ">" & vbcrlf & chr(9) & "<td align=center>" & vbcrlf & chr(9) & chr(9) & "<font face=tahoma color=white size=1>"
	sItemCell = "<tr" & sNavTopHeader & ">" & vbcrlf & chr(9) & "<td align=center>" & vbcrlf & chr(9) & chr(9) & "<font face=tahoma size=1>"
	sCloseCell = chr(9) & "</font></td>" & vbcrlf & vbcrlf & "</tr>" & vbcrlf

	'Start Table
	RwLf "	<table border=1 cellpadding=4 cellspacing=0 width=115 bordercolor=#000080 align=left>"

	RwLf sHeaderCell
	RwLf "GENERAL"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""" & strServerUrl & appPath & "search.asp"" Title=""Search"">Search</a>"
	RwLf sCloseCell

	if InStr(strServerUrl, "orbeta") > 0 then
           sgscwebUrl = "http://gscwebd01/global/gsc/index.do"
	else if InStr(strServerUrl, "wb46") > 0 then
	        sgscwebUrl = "http://gscwebq01.us.tycoelectronics.com/global/gsc/index.do"
             else
		sgscwebUrl = "http://supplynetwork.tycoelectronics.com"
             end if
	end if

	RwLf sItemCell
'	RwLf "<a href=""http://163.241.154.216:9080/myproject/ChartTony?toto=0"" Title=""Focus 20 (Graphical)"">Focus 20 (Graphical)</a>"
	RwLf "<a href=""" & sgscwebUrl & """ Title=""Focus 20 (Graphical)"">Focus 20 (Graphical)</a>"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""" & strServerUrl & appPath & "preferences.asp"" Title=""Preferences"">Preferences</a>"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""" & strServerUrl & appPath & "orgcodexref.asp"" Title=""Org Code to Org ID Xref"">Org Code to Org ID Xref</a>"
	RwLf sCloseCell

	RwLf sHeaderCell
	RwLf "TRAINING"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""" & strServerUrl & appPath & "/training/dscd detailed training.htm"" target=""Training Window"" Title=""DetailedTraining"">Detailed Training</a>"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""" & strServerUrl & appPath & "/training/dscd learning examples.htm"" target=""Training Window"" Title=""CaseStudies"">Case Studies</a>"
	RwLf sCloseCell

	RwLf sHeaderCell
	RwLf "STATUS"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""" & strServerUrl & appPath & "loaddates.asp"" Title=""Last DB Load Date"">Last DB Load Date</a>"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""http://intracomm.tycoelectronics.com/"">IntraComm</a>"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""http://teisprojects.us.tycoelectronics.com/teis/ebs/lw/gscd/"">Global Delivery Scorecard Initiative</a>"
	RwLf sCloseCell

	RwLf sHeaderCell
	RwLf "MAINTENANCE"
	RwLf sCloseCell

	if intUserLevel > 1 then
		RwLf sItemCell
		RwLf "<a href=""" & strServerUrl & appPath & "top20custmaint.asp"" Title=""Focus 20 Customers"">Focus 20 Customers</a>"
		RwLf sCloseCell
	end if

	if intUserLevel > 2 then
		RwLf sItemCell
		RwLf "<a href=""" & strServerUrl & appPath & "reqparms.asp"" Title=""Required System Parms"">Required System Parms</a>"
		RwLf sCloseCell
	end if

'	if intUserLevel > 1	then
'		RwLf sItemCell
'		RwLf "<a href=""" & strServerUrl & appPath & "optparms.asp"" Title=""Optional System Parms"">Optional System Parms</a>"
'		RwLf sCloseCell
'	end if

	RwLf sItemCell
	RwLf "<a href=""" & strServerUrl & appPath & "hldysched.asp"" Title=""Holiday Schedules"">Holiday Schedules</a>"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""" & strServerUrl & appPath & "wkndsched.asp"" Title=""Weekend Schedules"">Weekend Schedules</a>"
	RwLf sCloseCell

	if intUserLevel > 1 then
		RwLf sItemCell
		RwLf "<a href=""" & strServerUrl & appPath & "prcslog.asp"" Title=""Process Log"">Process Log</a>"
		RwLf sCloseCell
	end if

	if intUserLevel > 1 then
		RwLf sItemCell
		RwLf "<a href=""" & strServerUrl & appPath & "adhoc.asp"" Title=""User Survey"">User Survey</a>"
		RwLf sCloseCell
	end if

	if intUserLevel > 2 then
		RwLf sItemCell
		RwLf "<a href=""" & strServerUrl & appPath & "editannouncement.asp"" Title=""Announcement"">Announcement</a>"
		RwLf sCloseCell
	end if

'	RwLf sHeaderCell
'	RwLf "DSCD SYSTEM"
'	RwLf sCloseCell

'	RwLf sItemCell
'	RwLf "<a href=mailto:aorbeta@tycoelectronics.com"" Title=""DSCD Admin"">DSCD Admin</a>"
'	RwLf sCloseCell

	RwLf "</table>"
End Function

Function GenScrnInfo()
	Dim vntTxtDate, vntTxtMsg, intCnt, arrList, bln1stRow, intRow

	RwLf "<TABLE WIDTH=90% align=left BORDER=0 CELLSPACING=1 CELLPADDING=1>"
	RwLf "<TR>"
	RwLf "<TD><font size=5 color=Navy><STRONG><EM>Welcome to Global Delivery Scorecard</EM></strong></font>"
	RwLf "<BR><BR>"
	RwLf "Global Delivery Scorecards provides <STRONG>worldwide</STRONG>"
	RwLf " reporting of Tyco Electronics' delivery Performance."
	RwLf "<BR><BR><BR>"
	RwLf "<font size=4 color=Navy><STRONG><U>Enhancement Information</U></strong></font>"
	RwLf "</TD></TR>"

    Set objAnnounce = CreateObject("DSCD.clsAnnounce")
	arrList = objAnnounce.List2("N", vntErrNum, vntErrDesc)

	if err.number <> 0 then
		objError = Err.number
		errDesc = Err.description
		errWhere = "getting announcement info objAnnounce Create Object"
		exit function
	elseif vntErrNum <> 0 then
		objError = vntErrNum
		errDesc = vntErrDesc
		errWhere = "getting announcement info objAnnounce.Retrieve"
		exit function
	end if

	If IsArray(arrList) Then
		'record details
		bln1stRow = True
		For intRow = LBound(arrList, 2) To UBound(arrList, 2)
			If bln1stRow Then
				bln1stRow = False
			Else
				RwLf "<tr><td colspan=""3""><hr color=#DCDCDC></td></tr>"
			End if
			RwLf "<tr><td>" & arrList(2, intRow) & "</td></tr>"
		Next
	End If

	RwLf "<TR><TD>"
	RwLf "<BR>"
	RwLf "<a href=""" & strServerUrl & appPath & "histannounce.asp"" Title=""Information/News"">Information/News</a>"
	if vntNetscape = 1 then
		for intCnt = 0 to 10
			RwLf "<BR>"
		next
	end if
	RwLf "</TD></TR>"
	RwLf "</TABLE>"
End Function

Sub Rwlf(strIn)
	Response.Write strIn
	Response.Write vbCrLf
End Sub

Sub GenFooter()
	RwLf "</form></body></html>"
End Sub

Function GetUserLevel()
	Dim intCnt

	Session("GeneralUser") = "false"
	Session("IntermediateUser") = "false"
	Session("AdminUser") = "false"

	If Not IsObject(objUser) Then
		set objUser = Server.CreateObject ("DSCD.clsUser")
	End If
	vntUser = objUser.ListUserRoles(lsAmpId, vntErrNum, vntErrDesc)

	if err.number <> 0 then
		objError = Err.number
		errDesc = Err.description
		errWhere = "Get User level objUser create object"
		exit function
	elseif vntErrNum <> 0 then
		objError = vntErrNum
		errDesc = vntErrDesc
		errWhere = "Get User level vntUser array"
		exit function
	end if

	if Not IsArray(vntUser) then
		objError = "-1"
		errDesc = "Get User level role not defined"
		errWhere = "Get User level vntUser array"
		exit function
	elseif UBound(vntUser) < 0 then
		objError = "-1"
		errDesc = "Get User level role not defined"
		errWhere = "Get User level vntUser array"
		exit function
	end if

	for intCnt = 0 to ubound(vntUser)
		select case vntUser(intCnt,0)
			case "SCD_INQUIRY_ROLE":
				if intUserLevel < 1 then intUserLevel = 1
				Session("GeneralUser") = "true"
			case "SCD_LOCAL_UPDATE_ROLE":
				if intUserLevel < 2 then intUserLevel = 2
				Session("IntermediateUser") = "true"
			case "SCD_ADMIN_ROLE":
				if intUserLevel < 3 then intUserLevel = 3
				Session("AdminUser") = "true"
		End select
	next
	Session("BusinessUnit") = "CCC"
	if intUserLevel = 0 then
		'objError = 999
		'errDesc = "You must have a DSCD role defined"
		'errWhere = "Get User level role not defined"
		Session("GeneralUser") = "true"
	end if
End Function

Function UpdateProfile()

	If Not IsObject(objUser) Then
		Set objUser = Server.CreateObject ("DSCD.clsUser")
	End If
	vntUser = objUser.UpdateProfile(lsUID,lsAmpId,vntErrNum,vntErrDesc)

	if err.number <> 0 then
		objError = Err.number
		errDesc = Err.description
		errWhere = "Update User profile objUser create object"
		exit function
	elseif vntErrNum <> 0 then
		objError = vntErrNum
		errDesc = vntErrDesc
		errWhere = "Update User profile function"
		exit function
	end if
End Function

GenHtmlHead()
GetUserLevel()
UpdateProfile()
GenNavBar()
GenScrnInfo()
GenFooter()
If IsObject(objAnnounce) Then Set objAnnounce = Nothing
If IsObject(objUser) Then Set objUser = Nothing

%>
<!--#include file=include/errhandler.inc-->
