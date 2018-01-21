<%@ Language=VBScript %>
<%
Option Explicit
Server.ScriptTimeout = 900
Response.Expires = 0
Response.Buffer = true
%>
<!--#include file=include/colors.inc-->
<!--#include file=include/Constants.inc-->
<!--#include file=include/XLconst.inc-->
<!--#include file=include/security.inc-->
<!--#include file=include/ArrayFunctions.inc-->
<!--#include file=include/GetBrowserVersion.inc-->
<%
'On Error Resume Next

'lsAmpId = "AMP46434"
Dim objError, errDesc, errWhere, vntErrorNumber, vntErrorDesc, blnDebug
objError = 0
errDesc = vbNullString
errWhere = vbNullString
vntErrorNumber = "0"
vntErrorDesc = vbNullString
blnDebug = False

'Determine Browser
Dim strBrowser, strBrowserVer, strOS
	GetBrowserVersion strBrowser, strBrowserVer, strOS

	Dim blnIE, blnNS, blnNotSupported, intMajorVer
		blnIE = (InStr(strBrowser, "Microsoft") > 0)
		blnNS = (Instr(strBrowser, "Netscape") > 0)
		intMajorVer = CInt(Left(strBrowserVer, 1))

	blnNotSupported = (blnIE And intMajorVer < 5)

	If blnNotSupported Then
		TellUserToUpdateBrowser
		Response.End
	End If

Dim blnSendTransitionJS
	blnSendTransitionJS = True

'/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
'Determine mode by querystring or form vars
'\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/

Dim blnUsageStats
	blnUsageStats = (UCase(Trim(Request.QueryString("UsageStats"))) = "TRUE")

'/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
'|-|-|-|-|-|-|-|-|-|Main Program|-|-|-|-|-|-|-|-|-|
'\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/

'Testing
lsAMPid = "AMPT4296"
lsUID = "66746"

mrSecurity = True

If mrSecurity Then

	GenHtmlHead
	GenNavBar
	GenTableTitle

	If blnUsageStats Then 'And Session("Qicn_Admin") Then
		UsageStats
	Else
		blnSendTransitionJS = False
	End If
Else
	RwLf "<B>YOU ARE NOT AUTHORIZED TO USE THIS PAGE<B>"
End If

EndTableTitle

RwLf vbcrlf & "</FORM></BODY>" & vbcrlf

%>
<!--#include file=include/errhandler.inc-->
<%
	If 	blnSendTransitionJS Then
		rwlf "<SCRIPT LANGUAGE=""JavaScript"">"
		rwlf "<!--"
	  	' IF THE BROWSER IS MSIE4.0 FOR WINDOWS NT AND 95 ONLY, THEN bIsIE432 = TRUE
		rwlf "    var sAgent = navigator.userAgent"
		rwlf "    var bIs95NT = sAgent.indexOf('Windows 95') > -1 || sAgent.indexOf('Windows NT')  > -1 || sAgent.indexOf('Win32')  > -1 || sAgent.indexOf('Windows 98')  > -1 || sAgent.indexOf('Windows 2000')  > -1"
		rwlf "    var bIsIE4 = sAgent.indexOf('IE 4')  > -1 || sAgent.indexOf('IE 5')  > -1"
		rwlf "    var bIsIE432 = bIs95NT && bIsIE4"
		rwlf "    if (bIsIE432) {"
	    rwlf "        idHead.style.visibility = 'hidden'"
		rwlf "        idTransDiv.filters.item(0).apply()"
		rwlf "        idTransDiv.filters.item(0).transition = 23"
		rwlf "        idHead.style.visibility = 'visible'"
		rwlf "        idTransDiv.filters(0).play(1.000)"
		rwlf "    }"
		rwlf "//-->"
		rwlf "</SCRIPT>"
	End If
%>
</HTML>

<%
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\\                         Functions and Subroutines                           \\\
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Function GenHtmlHead()
	RwLf "<HTML>"
	RwLf "<HEAD>"
	RwLf "<TITLE>DSCD - Ad Hoc Reporting</TITLE>"
	RwLf "</HEAD>"
	RwLf "<BODY onLoad=""ErrHandler()"">"
End Function

Function GenNavBar()
	Dim sHeaderCell, sItemCell, sCloseCell
	RwLf "<form action=""adhoc.asp"" method=""post"" id=form1 name=form1>"
	sHeaderCell = "<tr" & sNavBotHeader & ">" & vbcrlf & chr(9) & "<td align=center>" & vbcrlf & chr(9) & chr(9) & "<font face=tahoma color=white size=1>"
	sItemCell = "<tr" & sNavTopHeader & ">" & vbcrlf & chr(9) & "<td align=center>" & vbcrlf & chr(9) & chr(9) & "<font face=tahoma size=1>"
	sCloseCell = chr(9) & "</td>" & vbcrlf & vbcrlf & "</tr>" & vbcrlf

	'Start Table
	RwLf "	<table border=1 cellpadding=4 cellspacing=0 width=115 bordercolor=#000080 align=left>"

	RwLf sHeaderCell
	RwLf "GENERAL"
	RwLf sCloseCell

	RwLf sItemCell
	RwLf "<a href=""" & strServerUrl & appPath & "home.asp"" Title=""Home"">Home</a>"
	RwLf sCloseCell

	RwLf sHeaderCell
	RwLf "INFORMATION"
	RwLf sCloseCell

	'If Session("Qicn_Admin") Then
		RwLf sItemCell
		RwLf "<a href=""" & StrServerUrl & appPath & "adhoc.asp?UsageStats=True"" Title=""Usage Statistics"">Usage Statistics</a>"
		RwLf sCloseCell
	'End If

	RwLf "</table>"
End Function

Function GenTableTitle()
	RwLf "<TABLE WIDTH=80% align=left BORDER=0 CELLSPACING=1 CELLPADDING=1>"
	RwLf "<TR>"
	RwLf		"<TD><font size=5 color=Navy><STRONG><EM>&nbsp;Welcome to Delivery Scorecard Ad Hoc</EM></strong></font></TD>"
	RwLf	"</TR>"
	RwLf	"<TR>"
	RwLf		"<TD>&nbsp;</TD>"
	RwLf "</TR>"
End Function

Function EndTableTitle()
	RwLf "</TABLE>"

End Function


'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
'\\\            Server Stats Report           \\\
'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
Sub UsageStats()

	Dim strMsg, vntErrNum, vntErrDesc, strSQL
		strMsg = vbNullString
		vntErrNum = 0
		vntErrDesc = vbNullString
		strSQL = vbNullString

	Dim blnEdit, blnSendChartVBscript, strButtons
		blnEdit = True
		blnSendChartVBscript = False
		strButtons = vbNullString

	Dim arrReport, objAdhoc, inx
		arrReport = vbNullString

	Dim strAssocGUIDs, strAssocNetIDs, arrTemp1, arrTemp2, inxGUID, inxNetID
		strAssocGUIDs = Request.Form("hdnAssocGUIDs")
		strAssocNetIDs = Request.Form("hdnAssocNetIDs")
		arrTemp1 = vbNullString
		arrTemp2 = vbNullString
		inxGUID = 0
		inxNetID = 1

	Dim strDimension1, strDimension2
	Dim strFromDate, strFromTime, strToDate, strToTime
	Dim strScreens, strAssociates
	Dim strServers, strViews, strViewData, strCategories, strCatData
	'Dim strRemHosts, strBrowsers
	'Dim strOSs, strRemIPs

		strDimension1	= Trim(Request("lstDimension1"))
		strDimension2	= Trim(Request("lstDimension2"))
		strFromDate		= Trim(Request("txtFromDate"))
		strFromTime		= Trim(Request("txtFromTime"))
		strToDate		= Trim(Request("txtToDate"))
		strToTime		= Trim(Request("txtToTime"))
		strScreens		= Trim(Replace(Request("lstScreens"), " ", vbNullString))
		strAssociates	= Trim(Replace(Request("lstAssociates"), " ", vbNullString))
		strViews		= Trim(Replace(Request("lstViews"), " ", vbNullString))
		strViewData		= Trim(Request("strViewData"))
		strCategories	= Trim(Replace(Request("lstCategories"), " ", vbNullString))
		strCatData		= Trim(Request("strCatData"))
		strServers		= Trim(Replace(Request("lstServers"), " ", vbNullString))

	If Instr(strScreens, ",") > 0 Then
		Do While Left(strScreens, 1) = ","
			strScreens = Trim(Mid(strScreens, 2))
		Loop
		Do While Right(strScreens, 1) = ","
			strScreens = Trim(Left(strScreens, Len(strScreens) - 1))
		Loop
	End If

	If Instr(strAssociates, ",") > 0 Then
		Do While Left(strAssociates, 1) = ","
			strAssociates = Trim(Mid(strAssociates, 2))
		Loop
		Do While Right(strAssociates, 1) = ","
			strAssociates = Trim(Left(strAssociates, Len(strAssociates) - 1))
		Loop
	End If

	If Instr(strServers, ",") > 0 Then
		Do While Left(strServers, 1) = ","
			strServers = Trim(Mid(strServers, 2))
		Loop
		Do While Right(strServers, 1) = ","
			strServers = Trim(Left(strServers, Len(strServers) - 1))
		Loop
	End If

	If (strAssocGUIDs = vbNullString Or strAssocNetIds = vbNullString) And strAssociates <> vbNullString Then

		arrTemp1 = split(strAssociates, ",")

		If IsArray(arrTemp1) Then

			For inx = LBound(arrTemp1) To UBound(arrTemp1)

				arrTemp2 = split(arrTemp1(inx), "|")

				If IsArray(arrTemp2) Then
					strAssocGUIDs = strAssocGUIDs & arrTemp2(inxGUID) & ","
					strAssocNetIDs = strAssocNetIDs & arrTemp2(inxNetID) & ","
				End If
			Next
			If strAssocGUIDs <> vbNullString Then strAssocGUIDs = Left(strAssocGUIDs, Len(strAssocGUIDs) - 1)
			If strAssocNetIDs <> vbNullString Then strAssocNetIDs = Left(strAssocNetIDs, Len(strAssocNetIDs) - 1)
		End If
	End If

	'rwlf "Dimension 1:  " & strDimension1 & "<br>"
	'rwlf "Dimension 2:  " & strDimension2 & "<br>"
	'rwlf "From Date:  " & strFromDate & "<br>"
	'rwlf "From Time:  " & strFromTime & "<br>"
	'rwlf "To Date:  " & strToDate & "<br>"
	'rwlf "To Time:  " & strToTime & "<br>"
	'rwlf "Screens:  " & strScreens & "<br>"
	'rwlf "Associates:  " & strAssociates & "<br>"
	'rwlf "Views:  " & strViews & "<br>"
	'rwlf "Categories:  " & strCategories & "<br>"
	'rwlf "Servers:  " & strServers & "<br>"

	If Request("Usage_smtCommand") <> vbNullString Then

		Set objAdhoc = Server.CreateObject("DSCD.clsAdhoc")

		arrReport = objAdhoc.ServerStatReport(strDimension1, strDimension2, strFromDate, strFromTime, strToDate, strToTime, strScreens, strAssocGUIDs, strViews, strCategories, strServers, strSQL, vntErrNum, vntErrDesc)
		Set objAdhoc = Nothing

		If vntErrNum = 0 Then
			If IsArray(arrReport) Then
				blnSendChartVBscript = True
				strButtons = "<tr><td colspan=""4"">&nbsp;</td></tr><tr><td align=""right"" colspan=""4""><INPUT type=""submit"" name=""Usage_smtNewReport"" id=""Usage_smtNewReport"" value=""New Report""></td></tr><tr><td colspan=""4"">&nbsp;</td></tr>"
				blnEdit = False
			Else
				strMsg = "No Records Found"
				blnSendChartVBscript = False
			End If
		Else
			strMsg = "Error Encountered<br>" & vntErrNum & "<br>" & vntErrDesc
			arrReport = vbNullString
		End If
	End If

	If strButtons = vbNullString Then strButtons = "<tr><td colspan=""4"">&nbsp;</td></tr><tr><td align=""right"" colspan=""4""><INPUT type=""submit"" name=""Usage_smtCommand"" id=""Usage_smtCommand"" value=""Build Report""></td></tr><tr><td colspan=""4"">&nbsp;</td></tr>"

	rwlf "<tr>"
	'rwlf "<td align=""left"">"
	'rwlf "<h2><font color=""red"">Usage Reporting</font></h2>"
	'rwlf "</td>"
	rwlf "<td align=""left"">&nbsp;&nbsp;"
	rwlf "<div ID=""idTransDiv"" STYLE=""position:relative; top:0; left:0; height:0;filter:revealTrans(duration=3.0, transition=0);"">"
	rwlf "<h2 id=""idHead"" STYLE=""position:relative; visibility:visible; margin-bottom:0;""><font color=""red"">Usage Reporting<br>" & strMsg & "</font></h2>"
	rwlf "</div>"
    rwlf "</td>"
	rwlf "</tr>"

'	If strMsg <> vbNullString Then
'		rwlf "<tr>"
'		rwlf "<td align=""left"">"
'		rwlf "<h3><font color=""red"">" & strMsg & "</font></h3>"
'		rwlf "</td>"
'		rwlf "</tr>"
'	End If

	rwlf "<tr><td align=""center""><table border=""0"" width=""90%"" id=""tblReportCriteria"">"

	rwlf strButtons

	Usage_DisplayReportControls blnEdit, strDimension1, strDimension2
	Usage_DisplayCriteria blnEdit, strFromDate, strFromTime, strToDate, strToTime, strScreens, strAssociates, strViewData, strViews, strCatData, strCategories, strServers

	rwlf strButtons
	rwlf "</table></td></tr>"

	If blnSendChartVBscript And IsArray(arrReport) Then SendChartVBscript arrReport, strDimension1, strDimension2
	rw "<script Language=""Javascript"">document.forms[0].action = 'adhoc.asp?UsageStats=True"
	If Request("showSQL") <> vbNullString Then rw "&showSQL=yes"
	rwlf "';</script>"

	If Not blnEdit Then
		rwlf "<input type=""hidden"" name=""lstDimension1"" id=""lstDimension1"" value=""" & strDimension1 & """>"
		rwlf "<input type=""hidden"" name=""lstDimension2"" id=""lstDimension2"" value=""" & strDimension2 & """>"
		rwlf "<input type=""hidden"" name=""txtFromDate"" id=""txtFromDate"" value=""" & strFromDate & """>"
		rwlf "<input type=""hidden"" name=""txtFromTime"" id=""txtFromTime"" value=""" & strFromTime & """>"
		rwlf "<input type=""hidden"" name=""txtToDate"" id=""txtToDate"" value=""" & strToDate & """>"
		rwlf "<input type=""hidden"" name=""txtToTime"" id=""txtToTime"" value=""" & strToTime & """>"
		rwlf "<input type=""hidden"" name=""lstScreens"" id=""lstScreens"" value=""" & strScreens & """>"
		rwlf "<input type=""hidden"" name=""lstAssociates"" id=""lstAssociates"" value=""" & strAssociates & """>"
		rwlf "<input type=""hidden"" name=""hdnAssocGUIDs"" id=""hdnAssocGUIDs"" value=""" & strAssocGUIDs & """>"
		rwlf "<input type=""hidden"" name=""hdnAssocNetIDs"" id=""hdnAssocNetIDs"" value=""" & strAssocNetIDs & """>"
		rwlf "<input type=""hidden"" name=""lstServers"" id=""lstServers"" value=""" & strServers & """>"
		rwlf "<input type=""hidden"" name=""lstViews"" id=""lstViews"" value=""" & strViews & """>"
		rwlf "<input type=""hidden"" name=""lstCategories"" id=""lstCategories"" value=""" & strCategories & """>"
	End If

	If Request("showSQL") <> vbNullString Then rwlf "Pay No Attention To The MAN Behind The Curtain<br>" & Replace(strSQL, vbcrlf, "<BR>")

	'rwlf "Pay No Attention To The MAN Behind The Curtain<br>" & Replace(strSQL, vbcrlf, "<BR>")

End Sub

Sub Usage_DisplayReportControls(blnEdit, strDimension1, strDimension2)

	Dim arrReportTypes, arrChartTypes, arrChartTypeValues, arr2DChartTypes, arr2DChartTypeValues, inx
		'arrReportTypes = Array("Screen", "Associate", "Server", "Browser", "Operating System", "Remote Host", "Remote IP")
		arrReportTypes = Array("Screen", "Associate", "Server", "View", "Category")
		arrChartTypes = Array("Bar", "Bar - 3D", "Column", "Column - 3D", "Pie", "Pie - Exploded", "Pie - 3D", "Pie - 3D - Exploded", "Radar - Points", "Radar - Filled")
		arrChartTypeValues = Array(xlBarStacked, xl3DBarStacked, xlColumnStacked, xl3DColumnStacked, xlPie, xlPieExploded, xl3DPie, xl3DPieExploded, xlRadarMarkers, xlRadarFilled)
		arr2DChartTypes = Array("Area", "Area - 3D", "Area - Stacked Values", "Area - 3D - Stacked Values", "Area - Stacked Percentage", "Area - 3D - Stacked Percentage", "Bar", "Bar - 3D", "Bar - Stacked Values", "Bar - 3D - Stacked Values", "Bar - Stacked Percentage", "Bar - 3D - Stacked Percentage", "Column - Clustered Values", "Column - 3D - Clustered Values", "Column - Stacked Values", "Column - 3D - Stacked Values", "Column - Stacked Percentage", "Column - 3D - Stacked Percentage", "Contour", "Doughnut", "Doughnut - Exploded", "Surface")
		arr2DChartTypeValues = Array(xlArea, xl3DArea, xlAreaStacked, xl3DAreaStacked, xlAreaStacked100, xl3DAreaStacked100, xlBarClustered, xl3DBarClustered, xlBarStacked, xl3DBarStacked, xlBarStacked100, xl3DBarStacked100, xlColumnClustered, xl3DColumnClustered, xlColumnStacked, xl3DColumnStacked, xlColumnStacked100, xl3DColumnStacked100, xlSurfaceTopView, xlDoughnut, xlDoughnutExploded, xlSurface)


	'rwlf "Dimension 1 (subroutine):  " & strDimension1 & "<br>"
	'rwlf "Dimension 2 (subroutine):  " & strDimension2 & "<br>"

	rwlf "<tr>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">Report&nbsp;Type:&nbsp;&nbsp;</font>"
	rwlf "</th>"
	rwlf "<td align=""left"" colspan=""3"">"
	If blnEdit Then
		rwlf "<select name=""lstDimension1"" id=""lstDimension1"">"
		For inx = LBound(arrReportTypes) To UBound(arrReportTypes)
			Rw "<option"
			If UCase(arrReportTypes(inx)) = UCase(strDimension1) Then Rw " SELECTED"
			rwlf ">" & arrReportTypes(inx) & "</option>"
		Next
		rwlf "</select>"
		rwlf "&nbsp;&nbsp;"
		rwlf "<select name=""lstDimension2"" id=""lstDimension2"">"
		rwlf "<option></option>"
		For inx = LBound(arrReportTypes) To UBound(arrReportTypes)
			Rw "<option value=""" & arrReportTypes(inx) & """"
			If UCase(arrReportTypes(inx)) = UCase(strDimension2) Then Rw " SELECTED"
			rwlf ">By " & arrReportTypes(inx) & "</option>"
		Next
		rwlf "</select>"
	Else
		Rw strDimension1
		If strDimension2 <> vbNullString Then rwlf " By " & strDimension2

		rwlf "</td>"
		rwlf "</tr>"

		rwlf "<tr>"
		rwlf "<th align=""right"">"
		rwlf "<font size=""2"">Chart&nbsp;Type:&nbsp;&nbsp;</font>"
		rwlf "</th>"
		rwlf "<td align=""left"" colspan=""3"">"
		rwlf "<select name=""lstChartType"" id=""lstChartType"">"
		If strDimension2 = vbNullString Then
			'1 Dimension Report
			For inx = LBound(arrChartTypes) To UBound(arrChartTypes)
				rwlf "<option value=""" & arrChartTypeValues(inx) & """>" & arrChartTypes(inx) & "</option>"
			Next
		Else
			'2 Dimension Report
			For inx = LBound(arr2DChartTypes) To UBound(arr2DChartTypes)
				rwlf "<option value=""" & arr2DChartTypeValues(inx) & """>" & arr2DChartTypes(inx) & "</option>"
			Next
		End If
		rwlf "</select>&nbsp;&nbsp;"
		rwlf "<input type=""button"" name=""btnBuildChart"" id=""btnBuildChart"" value=""Build Chart"">"
	End If
	rwlf "</td>"
	rwlf "</tr>"

End Sub

Sub Usage_DisplayCriteria(blnEdit, strFromDate, strFromTime, strToDate, strToTime, strScreens, strAssociates, strViewData, strViews, strCatData, strCategories, strServers)

	Dim intMaxOptions, arrTemp
		intMaxOptions = 6

	Dim objAdhoc, arrOptions, inx, inxRow, inxCol

	If blnEdit Then Set objAdhoc = Server.CreateObject("DSCD.clsAdhoc")

	rwlf "<tr>"
	rwlf "<td align=""center"" colspan=""4"">"
	rwlf "<hr>"
	rwlf "</td>"
	rwlf "</tr>"

	rwlf "<tr>"
	rwlf "<td align=""left"" colspan=""4"">"
	rwlf "<font color=""red"" size=""3""><b>Criteria</b></font></h4>"
	rwlf "</td>"
	rwlf "</tr>"

	rwlf "<tr>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">Dates</font>"
	rwlf "</th>"
	rwlf "<td align=""left"" colspan=""3"">"
	rwlf "<font size=""2"">&nbsp;YYYY-MM-DD&nbsp;&nbsp;HH:MM(:SS)&nbsp;&nbsp;</font>"
	rwlf "</td>"
	rwlf "</tr>"

	rwlf "<tr>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">From:&nbsp;&nbsp;</font>"
	rwlf "</th>"
	rwlf "<td align=""left"">"
	If blnEdit Then
		rwlf "<input type=""text"" name=""txtFromDate"" id=""txtFromDate"" value=""" & strFromDate & """ maxlength=""10"" size=""12"">&nbsp;"
		rwlf "<input type=""text"" name=""txtFromTime"" id=""txtFromTime"" value=""" & strFromTime & """ maxlength=""8"" size=""10"">"
	Else
		rwlf "<font size=""2"">" & strFromDate & "&nbsp;&nbsp;" & strFromTime & "</font>"
	End If
	rwlf "</td>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">To:&nbsp;&nbsp;</font>"
	rwlf "</th>"
	rwlf "<td align=""left"">"
	If blnEdit Then
		rwlf "<input type=""text"" name=""txtToDate"" id=""txtToDate"" value=""" & strToDate & """ maxlength=""10"" size=""12"">&nbsp;"
		rwlf "<input type=""text"" name=""txtToTime"" id=""txtToTime"" value=""" & strToTime & """ maxlength=""8"" size=""10"">"
	Else
		rwlf "<font size=""2"">" & strToDate & "&nbsp;&nbsp;" & strToTime & "</font>"
	End If
	rwlf "</td>"
	rwlf "</tr>"

	rwlf "<tr>"
	rwlf "<td align=""center"" colspan=""4"">"
	rwlf "&nbsp;"
	rwlf "</td>"
	rwlf "</tr>"


	rwlf "<tr>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">Screen&nbsp;Names:&nbsp;&nbsp;</font>"
	rwlf "</th>"
	'rwlf "<td align=""left"" colspan=""3"">"
	rwlf "<td align=""left"">"

	If blnEdit Then
		'Get Screen Names
		arrOptions = objAdhoc.GetServerStatScreens(vntErrorNumber, vntErrorDesc)
		If vntErrorNumber <> "0" Then
			ReDim arrOptions(0, 1)
			arrOptions(0, 0) = vntErrorNumber
			arrOptions(0, 1) = vntErrorDesc
		End If

		Rw "<select name=""lstScreens"" id=""lstScreens"""
		If IsArray(arrOptions) Then
			If Ubound(arrOptions, 2) + 1 > intMaxOptions Or UBound(arrOptions, 2) < 0 Then
				rwlf " size=""" & intMaxOptions & """ MULTIPLE>"
			Else
				rwlf " size=""" & UBound(arrOptions, 2) + 1 & """ MULTIPLE>"
			End If
			arrTemp = split(strScreens, ",")
			If IsArray(arrTemp) Then
				For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
					inxCol = 0
					Rw "<option"
					For inx = LBound(arrTemp) To UBound(arrTemp)
						If arrTemp(inx) = arrOptions(inxCol, inxRow) Then
							Rw " SELECTED"
							Exit For
						End If
					Next
					Rw ">"
					Rw arrOptions(inxCol, inxRow)
					rwlf "</option>"
				Next
			Else
				For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
					inxCol = 0
					Rw "<option>"
					Rw arrOptions(inxCol, inxRow)
					rwlf "</option>"
				Next
			End If
			Erase arrOptions
			arrOptions = vbNullString
		Else
			rwlf ">"
		End If
		rwlf "</select>"
	Else
		Rw "<font size=""2"">"
		If strScreens = vbNullString Then
			Rw "Any"
		Else
			Rw Replace(strScreens, ",", ", ")
		End If
		rwlf "</font>"
	End If
	rwlf "</td>"
	'rwlf "</tr>"



	'rwlf "<tr>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">Associates:&nbsp;&nbsp;</font>"
	rwlf "</th>"
	'rwlf "<td align=""left"" colspan=""3"">"
	rwlf "<td align=""left"">"

	If blnEdit Then

		Dim strCombined
			strCombined = vbNullString
		'Get Associates
		arrOptions = objAdhoc.GetServerStatUsers(vntErrorNumber, vntErrorDesc)
		If vntErrorNumber <> "0" Then
			ReDim arrOptions(0, 1)
			arrOptions(0, 0) = vntErrorNumber
			arrOptions(0, 1) = vntErrorDesc
		End If

		Rw "<select name=""lstAssociates"" id=""lstAssociates"""
		If IsArray(arrOptions) Then
			If Ubound(arrOptions, 2) + 1 > intMaxOptions Or UBound(arrOptions, 2) < 0 Then
				rwlf " size=""" & intMaxOptions & """ MULTIPLE>"
			Else
				rwlf " size=""" & UBound(arrOptions, 2) + 1 & """ MULTIPLE>"
			End If

			For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
				strCombined = arrOptions(0, inxRow) & "|" & arrOptions(1, inxRow)
				Rw "<option value="""
				Rw strCombined
				Rw """"
				If strAssociates = strCombined Or _
				InStr(strAssociates, strCombined & ",") > 0 Or _
				InStr(strAssociates, "," & strCombined) > 0 Then Rw " SELECTED"
				Rw ">"
				Rw arrOptions(1, inxRow)
				rwlf "</option>"
			Next
			Erase arrOptions
			arrOptions = vbNullString
		Else
			rwlf ">"
		End If
		rwlf "</select>"
	Else
		Rw "<font size=""2"">"
		If strAssociates = vbNullString Then
			Rw "Any"
		Else
            Dim inxNetworkID, blnComma
				arrTemp = vbNullString
            	inxNetworkID = 1
            	blnComma = False

			arrOptions = Split(strAssociates, ",")
			If IsArray(arrOptions) Then

                For inx = LBound(arrOptions) To UBound(arrOptions)

            		If arrOptions(inx) <> vbNullString Then
	            		arrTemp = split(arrOptions(inx), "|")
						If IsArray(arrTemp) Then
							If arrTemp(inxNetworkID) <> vbNullString Then
								If blnComma Then Rw ", "
								Rw arrTemp(inxNetworkID)
								blnComma = True
							Else
								If blnComma Then Rw ", "
								Rw "Error"
								blnComma = True
							End If
						Else
							If blnComma Then Rw ", "
							Rw "Error"
							blnComma = True
						End If
					End If
            	Next
				Erase arrOptions
				arrOptions = vbNullString
				If IsArray(arrTemp) Then
					Erase arrTemp
					arrTemp = vbNullstring
				End If
            End If
		End If
		rwlf "</font>"
	End If
	rwlf "</td>"
	rwlf "</tr>"



	rwlf "<tr>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">Views:&nbsp;&nbsp;</font>"
	rwlf "</th>"
	'rwlf "<td align=""left"" colspan=""3"">"
	rwlf "<td align=""left"">"
	Dim arrViewData

    If strViewData <> vbNullString Then
	    Do While(Instr(strViewData, "|||") > 0)
	    	strViewData = Replace(strViewData, "|||", "||")
	    Loop

		arrViewData = split(strViewData, "||")
		If IsArray(arrViewData) Then
			Redim arrOptions(1, UBound(arrViewData))
			For inxRow = LBound(arrViewData) To UBound(arrViewData)
				arrTemp = split(arrViewData(inxRow), "|")
				If IsArray(arrTemp) Then
					arrOptions(0, inxRow) = arrTemp(0)
					If UBound(arrTemp) > 0 Then arrOptions(1, inxRow) = arrTemp(1)
				Else
					arrOptions(0, inxRow) = arrTemp
					arrOptions(1, inxRow) = arrTemp
				End If
			Next
		Else
			Redim arrOptions(1, 0)
			arrTemp = split(arrViewData(inxRow), "|")
			If IsArray(arrTemp) Then
				arrOptions(0, 0) = arrTemp(0)
				arrOptions(1, 0) = arrTemp(1)
			Else
				arrOptions(0, 0) = arrTemp
				arrOptions(1, 0) = arrTemp
			End If
		End If
	End If

	'Get Views If Not Passed In
	If Not IsArray(arrOptions) Then
		arrOptions = objAdHoc.GetServerStatViews(vntErrorNumber, vntErrorDesc)
		If vntErrorNumber <> "0" Then
			ReDim arrOptions(0, 1)
			arrOptions(0, 0) = vntErrorNumber
			arrOptions(0, 1) = vntErrorDesc
		End If
	End If

	Dim arrViews
	arrViews = Split(strViews, ",")

	If blnEdit Then

		Rw "<select name=""lstViews"" id=""lstViews"""
		If IsArray(arrOptions) Then
			If Ubound(arrOptions, 2) + 1 > intMaxOptions Or UBound(arrOptions, 2) < 0 Then
				rwlf " size=""" & intMaxOptions & """ MULTIPLE>"
			Else
				rwlf " size=""" & UBound(arrOptions, 2) + 1 & """ MULTIPLE>"
			End If
			strViewData = vbNullString
			If IsArray(arrViews) Then
				For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
					'Build value-name array
					strViewData = strViewData & arrOptions(0, inxRow) & "|" & arrOptions(1, inxRow) & "||"
					'Build option list
					Rw "<option value="""
					Rw arrOptions(0, inxRow)
					Rw """"
					For inx = LBound(arrViews) To UBound(arrViews)
						If arrViews(inx) = arrOptions(0, inxRow) Then
							Rw " SELECTED"
							Exit For
						End If
					Next
					Rw ">"
					Rw arrOptions(1, inxRow)
					rwlf "</option>"
				Next
			Else
				For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
					'Build value-name array
					strViewData = strViewData & arrOptions(0, inxRow) & "|" & arrOptions(1, inxRow) & "||"
					'Build option list
					Rw "<option value="""
					Rw arrOptions(0, inxRow)
					Rw """>"
					Rw arrOptions(1, inxRow)
					rwlf "</option>"
				Next
			End If
			Erase arrOptions
			arrOptions = vbNullString
			If strViewData <> vbNullString Then strViewData = Left(strViewData, Len(strViewData) - 2)
		Else
			rwlf ">"
		End If
		rwlf "</select>"
	Else
		Rw "<font size=""2"">"
		If strViews = vbNullString Then
			Rw "Any"
		Else
			If IsArray(arrViews) Then
				For inx = LBound(arrViews) To UBound(arrViews)
					For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
						If arrViews(inx) = arrOptions(0, inxRow) Then
							Rw arrOptions(1, inxRow)
							If inx < UBound(arrViews) Then Rw ", "
							Exit For
						End If
					Next
				Next
			Else
				For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
					If arrViews = arrOptions(0, inxRow) Then Rw arrOptions(1, inxRow)
				Next
			End IF
		End If
		rwlf "</font>"
	End If
	rwlf "</td>"
	'rwlf "</tr>"
	Rw "<input type=""hidden"" name=""strViewData"" id=""strViewData"" value="""
	Rw strViewData
	RwLf """>"


	'rwlf "<tr>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">Categories:&nbsp;&nbsp;</font>"
	rwlf "</th>"
	'rwlf "<td align=""left"" colspan=""3"">"
	rwlf "<td align=""left"">"
	Dim arrCatData

    If strCatData <> vbNullString Then
	    Do While(Instr(strCatData, "|||") > 0)
	    	strCatData = Replace(strCatData, "|||", "||")
	    Loop

		arrCatData = split(strCatData, "||")
		If IsArray(arrCatData) Then
			Redim arrOptions(1, UBound(arrCatData))
			For inxRow = LBound(arrCatData) To UBound(arrCatData)
				arrTemp = split(arrCatData(inxRow), "|")
				If IsArray(arrTemp) Then
					arrOptions(0, inxRow) = arrTemp(0)
					If UBound(arrTemp) > 0 Then arrOptions(1, inxRow) = arrTemp(1)
				Else
					arrOptions(0, inxRow) = arrTemp
					arrOptions(1, inxRow) = arrTemp
				End If
			Next
		Else
			Redim arrOptions(1, 0)
			arrTemp = split(arrCatData(inxRow), "|")
			If IsArray(arrTemp) Then
				arrOptions(0, 0) = arrTemp(0)
				arrOptions(1, 0) = arrTemp(1)
			Else
				arrOptions(0, 0) = arrTemp
				arrOptions(1, 0) = arrTemp
			End If
		End If
	End If

	'Get Categories If Not Passed In
	If Not IsArray(arrOptions) Then
		arrOptions = objAdHoc.GetServerStatCategories(vntErrorNumber, vntErrorDesc)
		If vntErrorNumber <> "0" Then
			ReDim arrOptions(0, 1)
			arrOptions(0, 0) = vntErrorNumber
			arrOptions(0, 1) = vntErrorDesc
		End If
	End If

	Dim arrCats
	arrCats = Split(strCategories, ",")

	If blnEdit Then

		Rw "<select name=""lstCategories"" id=""lstCategories"""
		If IsArray(arrOptions) Then
			If Ubound(arrOptions, 2) + 1 > intMaxOptions Or UBound(arrOptions, 2) < 0 Then
				rwlf " size=""" & intMaxOptions & """ MULTIPLE>"
			Else
				rwlf " size=""" & UBound(arrOptions, 2) + 1 & """ MULTIPLE>"
			End If
			strCatData = vbNullString
			For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
				'Build value-name array
				strCatData = strCatData & arrOptions(0, inxRow) & "|" & arrOptions(1, inxRow) & "||"
				'Build option list
				Rw "<option value="""
				Rw arrOptions(0, inxRow)
				Rw """"
				If IsArray(arrViews) Then
					For inx = LBound(arrCats) To UBound(arrCats)
						If arrCats(inx) = arrOptions(0, inxRow) Then
							Rw " SELECTED"
							Exit For
						End If
					Next
				Else
					If arrCats = arrOptions(0, inxRow) Then
						Rw " SELECTED"
						Exit For
					End If
				End If
				Rw ">"
				Rw arrOptions(1, inxRow)
				rwlf "</option>"
			Next
			Erase arrOptions
			arrOptions = vbNullString
			If strCatData <> vbNullString Then strCatData = Left(strCatData, Len(strCatData) - 2)
		Else
			rwlf ">"
		End If
		rwlf "</select>"
	Else
		Rw "<font size=""2"">"
		If strCategories = vbNullString Then
			Rw "Any"
		Else
			If IsArray(arrCats) Then
				For inx = LBound(arrCats) To UBound(arrCats)
					For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
						If arrCats(inx) = arrOptions(0, inxRow) Then
							Rw arrOptions(1, inxRow)
							If inx < UBound(arrCats) Then Rw ", "
							Exit For
						End If
					Next
				Next
			Else
				For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
					If arrCats = arrOptions(0, inxRow) Then Rw arrOptions(1, inxRow)
				Next
			End IF
		End If
		rwlf "</font>"
	End If
	rwlf "</td>"
	rwlf "</tr>"
	Rw "<input type=""hidden"" name=""strCatData"" id=""strCatData"" value="""
	Rw strCatData
	RwLf """>"



	rwlf "<tr>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">Servers:&nbsp;&nbsp;</font>"
	rwlf "</th>"
	rwlf "<td align=""left"" colspan=""3"">"
	If blnEdit Then
		'Get Servers
		arrOptions = objAdhoc.GetServerStatServers(vntErrorNumber, vntErrorDesc)
		If vntErrorNumber <> "0" Then
			ReDim arrOptions(0, 1)
			arrOptions(0, 0) = vntErrorNumber
			arrOptions(0, 1) = vntErrorDesc
		End If

		Rw "<select name=""lstServers"" id=""lstServers"""
		If IsArray(arrOptions) Then
			If Ubound(arrOptions, 2) + 1 > intMaxOptions Or UBound(arrOptions, 2) < 0 Then
				rwlf " size=""" & intMaxOptions & """ MULTIPLE>"
			Else
				rwlf " size=""" & UBound(arrOptions, 2) + 1 & """ MULTIPLE>"
			End If
			For inxRow = LBound(arrOptions, 2) To UBound(arrOptions, 2)
				inxCol = 0
				Rw "<option"
				If InStr(strServers, arrOptions(inxCol, inxRow)) > 0 Then Rw " SELECTED"
				Rw ">"
				Rw arrOptions(inxCol, inxRow)
				rwlf "</option>"
			Next
			Erase arrOptions
			arrOptions = vbNullString
		Else
			rwlf ">"
		End If
		rwlf "</select>"
	Else
		Rw "<font size=""2"">"
		If strServers = vbNullString Then
			rwlf "Any"
		Else
			rwlf strServers
		End If
		rwlf "</font>"
	End If
	rwlf "</td>"
	rwlf "</tr>"

	'rwlf "<tr>"
	'rwlf "<th align=""right"">"
	'rwlf "&nbsp;"
	'rwlf "<font size=""2"">Remote&nbsp;Host:&nbsp;&nbsp;</font>"
	'rwlf "</th>"
	'rwlf "<td align=""left"" colspan=""3"">"
	'rwlf "&nbsp;"
	'rwlf "<input type=""text"" name=""txtRemHosts"" id=""txtRemHosts"" value="""" size=""25"">"
	'rwlf "</td>"
	'rwlf "</tr>"

	'rwlf "<tr>"
	'rwlf "<th align=""right"">"
	'rwlf "<font size=""2"">Browser:&nbsp;&nbsp;</font>"
	'rwlf "</th>"
	'rwlf "<td align=""left"" colspan=""3"">"
	'rwlf "<input type=""text"" name=""lstBrowsers"" id=""lstBrowsers"" value="""" size=""25"">"
	'rwlf "</td>"
	'rwlf "</tr>"

	'rwlf "<tr>"
	'rwlf "<th align=""right"">"
	'rwlf "<font size=""2"">Operating&nbsp;System:&nbsp;&nbsp;</font>"
	'rwlf "</th>"
	'rwlf "<td align=""left"" colspan=""3"">"
	'rwlf "<input type=""text"" name=""lstOSs"" id=""lstOSs"" value="""" size=""25"">"
	'rwlf "</td>"
	'rwlf "</tr>"

	Set objAdhoc = Nothing

End Sub

Sub SendChartVBscript(arrDataVals, strDimension1, strDimension2)

	'<SERVER SIDE ASP>
	Dim inxRow, inxCol

	Dim strChartTitle
	Dim strSeriesName

	If strDimension2 = vbNullString Then

		strChartTitle = strDimension1 & " Usage"
		strSeriesName = strDimension1 & " Hits"
	'</SERVER SIDE ASP>

	'<CLIENT SIDE>
%>

<script Language="VBSCRIPT">
'<!--
	sub btnBuildChart_onClick()		'client side subroutine

		Dim arrDataVals(<%=UBound(arrDataVals, 2) + 1%>, <%=UBound(arrDataVals, 1)%>)
			arrDataVals(0, 0) = ""
			arrDataVals(0, 1) = "<%=strSeriesName%>"
<%
	'<SERVER SIDE ASP>
	    For inxRow = LBound(arrDataVals, 2) To UBound(arrDataVals, 2)
	        rwlf "		arrDataVals(" & inxRow + 1 & ", 0) = """ & arrDataVals(0, inxRow) & """"
	        rwlf "		arrDataVals(" & inxRow + 1 & ", 1) = " & arrDataVals(1, inxRow)
	    Next
	'</SERVER SIDE ASP>
%>

		Build1DimCharts document.forms(0).lstChartType.value, arrDataVals, "<%=strChartTitle%>", 40, 30, 12
	end sub

	Sub Build1DimCharts(strChartType, arrRngVals, strTitle, intElevation, intPieHeight, intExplosion)		'client side subroutine

		Dim blnBarStacked, bln3DBarStacked, blnColumnStacked, bln3DColumnStacked, blnPie, bln3DPie, blnPieExploded, bln3DPieExploded, blnRadarPoints, blnRadarFilled
	        blnBarStacked = (strChartType = "<%=xlBarStacked%>")
	        bln3DBarStacked = (strChartType = "<%=xl3DBarStacked%>")
	        blnColumnStacked = (strChartType = "<%=xlColumnStacked%>")
	        bln3DColumnStacked = (strChartType = "<%=xl3DColumnStacked%>")
			blnPie = (strChartType = "<%=xlPie%>")
			bln3DPie = (strChartType = "<%=xl3DPie%>")
			blnPieExploded = (strChartType = "<%=xlPieExploded%>")
			bln3DPieExploded = (strChartType = "<%=xl3DPieExploded%>")
			blnRadarPoints = (strChartType = "<%=xlRadarMarkers%>")
			blnRadarFilled = (strChartType = "<%=xlRadarFilled%>")

	    ' Launch Excel
	    Dim app
	    Set app = CreateObject("Excel.Application")
	    app.WindowState = <%=xlMinimized%>

	    ' Add a new workbook
	    Dim wb

	    ' Add a new workbook
	    Set wb = app.Workbooks.Add()

	    Dim rng
	    Set rng = wb.ActiveSheet.Range("A1").Resize(UBound(arrRngVals, 1) + 1, UBound(arrRngVals, 2) + 1)

	    ' Now assign them all in one shot...
	    rng.Value = arrRngVals

	    ' Add a new chart based on the data
	    Dim TheChart

	    Set TheChart = wb.Charts.Add()

	    TheChart.ChartType = <%=xl3DPieExploded%>

	    TheChart.SetSourceData rng, <%=xlColumns%>
	    TheChart.Location <%=xlLocationAsNewSheet%>, "Report"

	    TheChart.SizeWithWindow = True
	    TheChart.HasTitle = True
	    TheChart.ChartTitle.Left = 0
	    TheChart.ChartTitle.Top = 0
	    TheChart.ChartTitle.Caption = strTitle
	    TheChart.ChartTitle.Font.Size = 14
	    TheChart.ChartTitle.Font.Bold = True

	    TheChart.Legend.Position = <%=xlLegendPositionBottom%>
	    TheChart.Legend.Left = Round((TheChart.ChartArea.Width - TheChart.Legend.Width) / 2, 0)
	    TheChart.Legend.Font.Size = 10

	    TheChart.PlotArea.Fill.Visible = False
	    TheChart.PlotArea.Border.LineStyle = 0

	    TheChart.PlotArea.Height = Round(TheChart.ChartArea.Height * 0.6, 0)
	    TheChart.PlotArea.Top = Round((TheChart.ChartArea.Height - TheChart.PlotArea.Height) / 2, 0)
	    TheChart.PlotArea.Left = Round((TheChart.ChartArea.Width - TheChart.PlotArea.Width) / 2, 0)

	    If blnBarStacked Or bln3DBarStacked Or blnColumnStacked Or bln3DColumnStacked Then
	    	TheChart.ApplyDataLabels <%=xlDataLabelsShowValue%>
		ElseIf blnPie Or bln3DPie Or blnPieExploded Or bln3DPieExploded Then
	    	TheChart.ApplyDataLabels <%=xlDataLabelsShowLabelAndPercent%>
	    Else
	    	TheChart.ApplyDataLabels <%=xlDataLabelsShowNone%>
	    End If

	    Dim dblTotal
	        dblTotal = 0

	    For inxRow = 1 To UBound(arrRngVals, 1)
	        dblTotal = dblTotal + arrRngVals(inxRow, 1)
	    Next

	    Dim intSlice1Angle
	        intSlice1Angle = (360 - Round(360 * ((arrRngVals(1, 1) / dblTotal) / 2), 0))

	    TheChart.Elevation = intElevation
	    TheChart.HeightPercent = intPieHeight

	'    Dim intStep
	'    Dim intRotate
	'    intStep = 1
	'    intRotate = intSlice1Angle
	'    Do While intStep = 1
	'        For r = 30 To 20 Step -1
	'            If intRotate Mod r = 0 Then
	'                intStep = r
	'                Exit For
	'            End If
	'        Next
	'        If intStep = 1 Then intRotate = intRotate - 1
	'
	'    Loop
	'
	    Dim colSeries
	    Dim objSeries
	    Set colSeries = TheChart.SeriesCollection
	    Set objSeries = colSeries.Item(1)

	'    app.WindowState = <%=xlMaximized%>
	'	app.Visible = True

	'    If intStep > 15 Then
	'        objSeries.Explosion = 0
	'        For r = 1 To intRotate Step intStep
	'            If objSeries.Explosion < intExplosion Then objSeries.Explosion = Round((r * intExplosion) / intRotate, 0)
	'            TheChart.Rotation = r
	'        Next
	'    End If
		If blnPieExploded or bln3DPieExploded Then objSeries.Explosion = intExplosion
		TheChart.Pie3DGroup.FirstSliceAngle = intSlice1Angle

	    TheChart.ChartType = CInt(strChartType)

		app.Visible = True
	    app.WindowState = <%=xlMaximized%>

	    Set objSeries = Nothing
	    Set colSeries = Nothing
	    Set TheChart = Nothing
	    Set rng = Nothing
	    Set wb = Nothing
	    Set app = Nothing
	End Sub

' -->
</script>
<%
	'</CLIENT SIDE>

	'<SERVER SIDE ASP>
	Else
		strChartTitle = "Usage:  " & strDimension1 & " By " & strDimension2
	'</SERVER SIDE ASP>

	'<CLIENT SIDE>
%>
<script Language="VBSCRIPT">
'<!--
	sub btnBuildChart_onClick()		'client side subroutine

		Dim arrDataVals(<%=UBound(arrDataVals, 1)%>, <%=UBound(arrDataVals, 2)%>)
<%
	'<SERVER SIDE ASP>
		For inxCol = LBound(arrDataVals, 1) To UBound(arrDataVals, 1)
		    For inxRow = LBound(arrDataVals, 2) To UBound(arrDataVals, 2)
		        rwlf "		arrDataVals(" & inxCol & ", " & inxRow & ") = """ & arrDataVals(inxCol, inxRow) & """"
			Next
	    Next
	'</SERVER SIDE ASP>
%>

		Build2DimCharts document.forms(0).lstChartType.value, arrDataVals, "<%=strChartTitle%>", 40
	end sub

	Sub Build2DimCharts(strChartType, arrRngVals, strTitle, intElevation)		'client side subroutine

		Dim blnArea, bln3DArea, blnAreaStacked, bln3DAreaStacked, blnAreaStacked100, bln3DAreaStacked100, blnBarClustered, bln3DBarClustered, blnBarStacked, bln3DBarStacked, blnBarStacked100, bln3DBarStacked100, blnColumnClustered, bln3DColumnClustered, blnColumnStacked, bln3DColumnStacked, blnColumnStacked100, bln3DColumnStacked100, blnSurfaceTopView, blnDoughnut, blnDoughnutExploded, xlSurface
			blnArea = (strChartType = "<%=xlArea%>")
			bln3DArea = (strChartType = "<%=xl3DArea%>")
			blnAreaStacked = (strChartType = "<%=xlAreaStacked%>")
			bln3DAreaStacked = (strChartType = "<%=xl3DAreaStacked%>")
			blnAreaStacked100 = (strChartType = "<%=xlAreaStacked100%>")
			bln3DAreaStacked100 = (strChartType = "<%=xl3DAreaStacked100%>")
			blnBarClustered = (strChartType = "<%=xlBarClustered%>")
			bln3DBarClustered = (strChartType = "<%=xl3DBarClustered%>")
			blnBarStacked = (strChartType = "<%=xlBarStacked%>")
			bln3DBarStacked = (strChartType = "<%=xl3DBarStacked%>")
			blnBarStacked100 = (strChartType = "<%=xlBarStacked100%>")
			bln3DBarStacked100 = (strChartType = "<%=xl3DBarStacked100%>")
			blnColumnClustered = (strChartType = "<%=xlColumnClustered%>")
			bln3DColumnClustered = (strChartType = "<%=xl3DColumnClustered%>")
			blnColumnStacked = (strChartType = "<%=xlColumnStacked%>")
			bln3DColumnStacked = (strChartType = "<%=xl3DColumnStacked%>")
			blnColumnStacked100 = (strChartType = "<%=xlColumnStacked100%>")
			bln3DColumnStacked100 = (strChartType = "<%=xl3DColumnStacked100%>")
			blnSurfaceTopView = (strChartType = "<%=xlSurfaceTopView%>")
			blnDoughnut = (strChartType = "<%=xlDoughnut%>")
			blnDoughnutExplode = (strChartType = "<%=xlDoughnutExploded%>")
			blnSurface = (strChartType = "<%=xlSurface%>")

	    ' Launch Excel
	    Dim app
	    Set app = CreateObject("Excel.Application")
	    app.WindowState = <%=xlMinimized%>

	    ' Add a new workbook
	    Dim wb

	    ' Add a new workbook
	    Set wb = app.Workbooks.Add()

	    Dim rng
	    Set rng = wb.ActiveSheet.Range("A1").Resize(UBound(arrRngVals, 1) + 1, UBound(arrRngVals, 2) + 1)

	    ' Now assign them all in one shot...
	    rng.Value = arrRngVals

	    ' Add a new chart based on the data
	    Dim TheChart

	    Set TheChart = wb.Charts.Add()

	    TheChart.SetSourceData rng, <%=xlColumns%>
	    TheChart.Location <%=xlLocationAsNewSheet%>, "Report"
    	TheChart.ChartType = CInt(strChartType)

	    TheChart.SizeWithWindow = True
	    TheChart.HasTitle = True
	    TheChart.ChartTitle.Left = 0
	    TheChart.ChartTitle.Top = 0
	    TheChart.ChartTitle.Caption = strTitle
	    TheChart.ChartTitle.Font.Size = 14
	    TheChart.ChartTitle.Font.Bold = True

	    TheChart.Legend.Position = <%=xlLegendPositionBottom%>
	    TheChart.Legend.Left = Round((TheChart.ChartArea.Width - TheChart.Legend.Width) / 2, 0)
	    TheChart.Legend.Font.Size = 10

	    TheChart.PlotArea.Fill.Visible = False
	    TheChart.PlotArea.Border.LineStyle = 0

	    TheChart.PlotArea.Height = Round(TheChart.ChartArea.Height * 0.6, 0)
	    TheChart.PlotArea.Top = Round((TheChart.ChartArea.Height - TheChart.PlotArea.Height) / 2, 0)
	    TheChart.PlotArea.Left = Round((TheChart.ChartArea.Width - TheChart.PlotArea.Width) / 2, 0)

	    If blnArea Or bln3DArea Or blnAreaStacked Or bln3DAreaStacked Or blnAreaStacked100 Or bln3DAreaStacked100 Or blnBarStacked Or bln3DBarStacked Or bln3DBarStacked100 Or blnColumnStacked Or bln3DColumnStacked Or bln3DColumnStacked100 Then
	    	TheChart.ApplyDataLabels <%=xlDataLabelsShowValue%>
	    ElseIf Not blnSurface And Not blnSurfaceTopView Then
	    	TheChart.ApplyDataLabels <%=xlDataLabelsShowNone%>
	    End If

	    If bln3DArea Or bln3DAreaStacked Or bln3DAreaStacked100 Or _
	    	bln3DBarClustered or bln3DBarStacked Or bln3DBarStacked100 Or _
	    	bln3DColumnClustered Or bln3DColumnStacked Or bln3DColumnStacked100 Or _
	    	blnSurface Then

	    		TheChart.Elevation = intElevation
	    End If

		app.Visible = True
	    app.WindowState = <%=xlMaximized%>

	    Set TheChart = Nothing
	    Set rng = Nothing
	    Set wb = Nothing
	    Set app = Nothing
	End Sub

' -->
</script>

<%
	'</CLIENT SIDE>

	'<SERVER SIDE ASP>
	End If

End Sub


Sub TellUserToUpdateBrowser()
If blnDebug Then RwLf "TellUserToUpdateBrowser()<br>"

	'RwLf "<?xml version=""1.0"" encoding=""UTF-8""?>"
	'RwLf "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN""" & vbcrlf & "			""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">"
	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>" & Application("AppAbrv") & " - " & "Browser Needs Updated</title>"
	RwLf "</head>"
	RwLf "<body>"
	RwLf "<br>"
	RwLf "<br>"
	RwLf "<h3>You are currently using " & strBrowser & " " & strBrowserVer & " running on " & strOS & "</h3>"
	RwLf "<h3>This screen requires Microsoft Internet Explorer 5 or above.</h3>"
	RwLf "<h3>Please download the latest version:<ul>"
	RwLf "<li><a href=""http://www.microsoft.com/windows/IE/"" alt=""Click to go to Microsoft"">Download Microsoft Internet Explorer</a></li>"
	RwLf "</ul></h3>"

	RwLf "</body>"
End Sub


Sub OldCodeStorage_DoNotCall()
	rwlf "<tr>"
	rwlf "<th align=""right"">"
	rwlf "<font size=""2"">Chart&nbsp;Type:&nbsp;&nbsp;</font>"
	rwlf "</th>"
	rwlf "<td align=""left"" colspan=""3"">"
	rwlf "<select name=""lstChartType"" id=""lstChartType"">"
	rwlf "<option></option>"
	rwlf "</select>"
	rwlf "</td>"
	rwlf "</tr>"
End Sub

Sub Rw(strIn)
	Response.Write strIn
End Sub

Sub Rwlf(strIn)
	Response.Write strIn
	Response.Write vbCrLf
End Sub
%>