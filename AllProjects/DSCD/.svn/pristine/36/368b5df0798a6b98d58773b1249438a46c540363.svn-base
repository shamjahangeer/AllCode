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
<!--METADATA TYPE="TypeLib" UUID="{7BCD2133-64A0-4770-843C-090637114583}" -->
<%
'Declare your variables
Dim objError
Dim objRet
Dim errWhere
Dim errDesc
dim objList
dim blnRc
dim vntArray
dim vntErrorNumber
dim vntErrorDesc
dim vntCount
dim vntSql
dim intCount
dim vntPage
dim vntRecsLeft
dim vntColorNow
dim vntPageCount
dim vntLeftOver
dim blnPrev
dim vntRecordCount
dim blnStart
dim vntExport
dim vntPart
dim vntFileName
dim vntPath
dim objFSO
dim objText
dim vntExcelSeq
dim vntGetTotal
dim vntExtTotal
dim vntLocTotal
dim vntTBRTotal
dim vntShpQtyTotal
dim vntSessionId
dim vntQSView
dim vntQSCat
dim vntQSInd
dim vntQSWin
dim vntCustPercent, vntAmpPercent, vntCustCumu, vntAmpCumu, vntLeadTimeType
dim vntSmryType
dim vntCmprType
dim vntViewDesc
dim vntCatDesc
dim vntWinDesc
dim vntTemp1
dim vntTemp2
dim strBrowser
dim strVer
dim strOS
dim vntNetscape
dim vntHTemp
dim vntFound

dim vntTotSchds
dim vntTotEarly
dim vntTotOnTime
dim vntTotLate

dim vntJTotSchds
dim vntJTotEarly
dim vntJTotOnTime
dim vntJTotLate

dim vntEarlyPerc, vntOnTimePerc, vntLatePerc
dim vntJEarlyPerc, vntJonTimePerc, vntJlatePerc
dim blnEnd
dim vntTempArray
dim blnSecondTime 'Flag so we don't display the Jump To on the bottom row.

dim vntCurrMth
dim vntPrevMth
dim vntDispCrit

' excel writer variables
dim xlw
dim ws
dim hdrstyle
dim dtlstyle
dim totstyle

'Initialize your variables
vntTotSchds = 0
vntTotEarly = 0
vntTotOnTime = 0
vntTotLate = 0
vntNetscape = 0
blnEnd = false
blnPrev = false
blnStart = true
vntExport = 0
vntFileName = 1

objError = 0
errWhere = ""
errDesc = ""
blnSecondTime = false
'Uncomment when security matters
'Session("AdminUser") = "true"
If Not MrSecurity Then
  Response.Redirect Application("Login")
End If

GetBrowserVersion strBrowser, strVer, strOS
if instr(strBrowser, "Explorer") = 0 then
	vntNetscape = 1
end if

if Request.QueryString("s") <> "" then
	session("GetTotal") = ""
	vntSessionId = Request.QueryString ("s")
	Session("rSessionId") = vntSessionId
else
	vntSessionId = Session("rSessionId")
end if

if Request.QueryString ("v") <> "" then
	vntQSView = Request.QueryString ("v")
	Session("rQSView") = vntQSView
else
	vntQSView = Session("rQSView")
end if

if Request.QueryString ("c") <> "" then
	vntQSCat = Request.QueryString ("c")
	Session("rQSCat") = vntQSCat
else
	vntQSCat = Session("rQSCat")
end if

if Request.QueryString ("mdi") <> "" then
	vntQSInd = Request.QueryString ("mdi")
	Session("rQSInd") = vntQSInd
else
	vntQSInd = Session("rQSInd")
end if

if Request.QueryString ("w") <> "" then
	vntQSWin = Request.QueryString ("w")
	Session("rQSWin") = vntQSWin
else
	vntQSWin = Session("rQSWin")
end if

'This is used for paging
if Request.Form("Page") = "" then
	vntPage = 1
else
	vntPage = Request.Form("Page")
end if
if Request.Form("RecCount") = "" then
	vntRecordCount = 1
else
	vntRecordCount = Request.Form("RecCount")
end if
if Request.Form("Submit") = "" then
	ServerStats vntQSView, vntQSCat
end if

if Request.QueryString("x") = "1" then
	vntExport = 1
end if

Select Case Request.Form("Submit")
Case "Previous"
	vntPage = vntPage - 2
Case "Export"
	vntExport = 1
Case "Return"
	session("GetTotal") = ""
	Response.Redirect strServerUrl & appPath & "search.asp?s=" & vntSessionId
	'Response.Write strServerUrl & appPath & "search.asp?s=" & vntSessionId
case "Jump To"
'Response.Write "Page:" & vntPage & "<br>"
'Response.Write "CBO:" & Request.Form ("cboJump") & "<br>"
	'vntFound = instr(Request.Form ("cboJump"),",")
	'if vntFound <> 0 then
		vntPage = Request.Form ("cboJump")
	'end if
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
	response.write "<title>" & Application("AppAbrv") & " - " & "Your Search Results</title>"
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
		if isnull(vntQsView) or len(vntQsView) = 0 then
			if vntExport = 1 then vntExport = 0
			PaintSessionExpired()
			GenNavButtons()
			CloseTags()
			Response.Redirect strServerUrl & appPath & "search.asp?s=" & vntSessionId
		end if

		set objRet = server.CreateObject ("DSCD.clsView")
		blnRc = objRet.RetrieveView (vntQsView,vntViewDesc, vntErrorNumber, vntErrorDesc)
		set objRet = nothing
		If Err.number <> 0 then
			objError = Err.number
			errDesc = Err.description
			errWhere = " In function Create Object DSCD.clsView"
			exit function
		elseif vntErrorNumber <> 0 then
			objError = vntErrorNumber
			errDesc = vntErrorDesc
			errWhere = " In function DSCD.clsView.RetrieveView"
			exit function
		end if
		vntTemp1 = lcase(right(vntViewDesc,len(vntViewDesc) - 1))
		vntTemp2 = left(vntViewDesc,1)
		vntViewDesc = vntTemp2 & vntTemp1
		vntViewDesc = FormatWords (vntViewDesc)

		set objRet = server.CreateObject ("DSCD.clsCategory")
		blnrc = objRet.RetrieveCategory(vntQSCat, vntCatdesc, vntErrorNumber, vntErrorDesc)
		set objRet = nothing
		vntTemp1 = lcase(right(vntCatdesc,len(vntCatdesc) - 1))
		vntTemp2 = left(vntCatdesc,1)
		vntCatdesc = vntTemp2 & vntTemp1
		vntCatDesc = FormatWords(vntCatDesc)

		if vntQSWin = "1" and vntQSCat <> "7" then
			vntWinDesc = "Customer Variable"
		else
			vntWinDesc = "Standard Default"
		end if

		if vntQSView = "1" and vntQSCat = "8" then
			response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Organization Year-To-Date List - " & vntWinDesc & "</b></font></td>"
		elseif vntQSView = "3" and vntQSCat = "11" then
			response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Customer Account Number List</b></font></td>"
		elseif vntQSView = "3" and vntQSCat = "12" then
			response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Worldwide Account Number List</b></font></td>"
		elseif vntQSView = "4" and vntQSCat = "14" then
			response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Shipping Facility List - Warehouse Lates</b></font></td>"
		elseif vntQSView = "4" and (vntQSCat = "3" OR vntQSCat = "4") then
			response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>" & vntViewDesc & " by " &  vntCatdesc
		elseif vntQSCat = "6" then
			response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>" & vntViewDesc & " by " &  vntCatdesc
		else
			response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>" & vntViewDesc & " by " &  vntCatdesc  & " - " & vntWinDesc & "</b></font></td>"
		end if

		'response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>" & vntViewDesc & " by " &  vntCatdesc  & " - " & vntWinDesc & "</b></font></td>"

%>
	<!--#include file=include/NavEnd.inc-->
<%

end function

Function GenNavButtons()
Response.Write "<form name=""frmResults"" ACTION=""Results.asp"" method=""POST"">"
	Response.Write "<table width=""100%"" border=""0"">" & vbcrlf
	Response.Write "<tr>" & vbcrlf
	Response.Write "    <td ALIGN=""left"" width=""10%"">" & vbcrlf
	Response.Write "    <input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Return""></td>" & vbcrlf
	Response.Write "    <td ALIGN=""right"" width=""40%"">" & vbcrlf
	Response.Write "    <input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Export""></td>" & vbcrlf
	Response.Write "</tr>" & vbcrlf
	Response.Write "</TABLE>"
	Response.Write sHr
End Function

Function GetOrgYTD()
	set objList = server.CreateObject ("DSCD.clsResultsGeneral")
	vntArray = objList.ListOrgYTD(vntSessionId,vntCount,vntSmryType,vntCurrMth,vntPrevMth, _
							vntDispCrit,vntErrorNumber,vntErrorDesc, vntSql)
	Response.Write "Total Records:" & vntCount
	set objlist = nothing
end function

Function GetCustomerList()
	set objList = server.CreateObject ("DSCD.clsResultsGeneral")
	vntArray = objList.ListCust(vntSessionId,vntPage,vntExport,vntCount, _
							vntRecsLeft,vntSmryType,vntDispCrit,vntErrorNumber,vntErrorDesc, vntSql)
	Response.Write "Total Records:" & vntCount
	Set objList = nothing
end function

Function GetWWList()
	set objList = server.CreateObject ("DSCD.clsResultsGeneral")
	vntArray = objList.ListWW(vntSessionId,vntPage,vntExport,vntCount, _
							vntRecsLeft,vntSmryType,vntDispCrit,vntErrorNumber,vntErrorDesc, vntSql)
	Response.Write "Total Records:" & vntCount
	Set objList = nothing
end function

Function GetShpFcltyList()
	set objList = server.CreateObject ("DSCD.clsResultsGeneral")
	vntArray = objList.ListShpFclty(vntSessionId,vntExport,vntCount, _
							vntDispCrit,vntErrorNumber,vntErrorDesc, vntSql)
	Response.Write "Total Records:" & vntCount
	set objlist = nothing
end function

Function GetGeneral()
	if session("GetTotal") = "" then
		vntGetTotal = "1"
	else
		vntGetTotal = ""
	end if
	set objList = server.CreateObject ("DSCD.clsResults")
	if vntQSInd = "1" then
		vntArray = objList.ListGeneral(vntSessionId,vntGetTotal,vntPage,vntExport,vntCount, _
										vntRecsLeft,vntExtTotal, vntLocTotal,vntSmryType,vntTempArray,vntDispCrit,vntErrorNumber,vntErrorDesc, vntSql)
	else
		vntArray = objList.ListGeneralDly(vntSessionId,vntGetTotal,vntPage,vntExport,vntCount, _
										vntRecsLeft,vntExtTotal, vntLocTotal,vntSmryType,vntTempArray,vntDispCrit,vntErrorNumber,vntErrorDesc, vntSql)
	end if
	set objlist = nothing
	if session("GetTotal") = "" then
		session("GetTotal") = "1"
		session("ExtTotal") = vntExtTotal
		session("LocTotal") = vntLocTotal
	end if
end function
'*********************************************************************************************************
'Here are the values of vntArray Function GetLeadTime()
'*********************************************************************************************************
'Customer Lead Times
'Less Than 0		vntArray(0)				21-30				vntArray(13)
'0					vntArray(1)				31-40				vntArray(14)
'1					vntArray(2)				41-50				vntArray(15)
'2					vntArray(3)				51-60				vntArray(16)
'3					vntArray(4)				61-70				vntArray(17)
'4					vntArray(5)				71-80				vntArray(18)
'5					vntArray(6)				81-90				vntArray(19)
'6					vntArray(7)				91-100				vntArray(20)
'7					vntArray(8)				100+				vntArray(21)
'8					vntArray(9)
'9					vntArray(10)
'10					vntArray(11)
'11-20				vntArray(12)
'
'Tyco Lead Times
'Less Than 0		vntArray(21)				21-30				vntArray(34)
'0					vntArray(22)				31-40				vntArray(35)
'1					vntArray(23)				41-50				vntArray(36)
'2					vntArray(23)				51-60				vntArray(37)
'3					vntArray(25)				61-70				vntArray(38)
'4					vntArray(26)				71-80				vntArray(39)
'5					vntArray(27)				81-90				vntArray(40)
'6					vntArray(28)				91-100				vntArray(41)
'7					vntArray(29)				100+				vntArray(42)
'8					vntArray(30)
'9					vntArray(31)
'10					vntArray(32)
'11-20				vntArray(33)
'
'vntCustPercent, vntAmpPercent, vntCustCumu, vntAmpCumu
'	are array's that folows the Customer lead time format
'*********************************************************************************************************
Function GetLeadTime()
	set objList = server.CreateObject ("DSCD.clsResults")
	vntArray = objList.ListLead(vntSessionId,vntCustPercent, vntAmpPercent, vntCustCumu, vntAmpCumu, _
							vntCount,vntLeadTimeType,vntDispCrit,vntErrorNumber,vntErrorDesc, vntSql)
	set objlist = nothing
	if not isnull(vntArray) then
		Response.Write "Total Number of Schedules: " & vntArray(44,0)
	end if
end function
'*********************************************************************************************************
'Here are the values of vntArray Function GetPstDueOpen()
'*********************************************************************************************************
'Inv Loc		vntArray(0)						Schd Date		vntArray(7)
'Part/Part Desc vntArray(1), vntArray(17)		RL Code			vntArray(8)
'Order Number	vntArray(2)
'Order Item		vntArray(13)					Days Late		vntArray(10)
'Shipment ID	vntArray(14)					JIT				vntArray(11)
'Cntrlr Code	vntArray(3)						On Dock Late	vntArray(12)
'Sch Qty		vntArray(4)						Customer Acct	vntArray(18)
'Rep as of DT	vntArray(5)						Bill Amt USD	vntArray(15)
'Req as of DT	vntArray(6)						Local Bill Amt	vntArray(16)
'												Local Bill Desc vntArray(20)
'TBR Amount		vntArray(22)					Order Recv'd Dt vntArray(21)
'ShipTo Name    vntArray(30)
'**********************************************************************************************************
Function GetPstDueOpen()
	if session("GetTotal") = "" then
		vntGetTotal = "1"
	else
		vntGetTotal = ""
	end if
	set objList = server.CreateObject ("DSCD.clsResults")
	vntArray = objList.ListPstDueOpen(vntSessionId,vntGetTotal,vntPage,vntExport,vntCount, _
										vntRecsLeft,vntTBRTotal,vntExtTotal,vntLocTotal,vntCmprType,vntDispCrit,vntErrorNumber,vntErrorDesc, vntSql)
	if session("GetTotal") = "" then
		session("GetTotal") = "1"
		session("TBRTotal") = vntTBRTotal
		session("ExtTotal") = vntExtTotal
		session("LocTotal") = vntLocTotal
	end if
	Response.Write "Total Records:" & vntCount
	Set objList = nothing
end function

Function GetConfNonConf()
dim vntWindow
'dim vntSmryType
dim vntBuildId
dim vntOrgCde
dim vntConform
dim intCount

	if session("GetTotal") = "" then
		vntGetTotal = "1"
	else
		vntGetTotal = ""
	end if
	set objList = server.CreateObject ("DSCD.clsResults")
	vntArray = objList.ListConfNonConf(vntSessionId,vntGetTotal,vntPage,vntExport,vntCount, _
										vntRecsLeft,vntTBRTotal,vntExtTotal,vntLocTotal,vntSmryType,vntDispCrit,vntShpQtyTotal,_
										vntErrorNumber,vntErrorDesc, vntSql)
	if session("GetTotal") = "" then
		session("GetTotal") = "1"
		session("TBRTotal") = vntTBRTotal
		session("ExtTotal") = vntExtTotal
		session("LocTotal") = vntLocTotal
		session("ShpQtyTotal") = vntShpQtyTotal
	end if
	Set objList = nothing
	Response.Write "Total Records:" & vntCount
end function

Function PaintExcelConfNonConf()
	dim vntReplace, txtFldName, txtProdMgr, txtMrpGrp, txthdr, vntPONbr, txtShipTo, txtSoldTo
	if vntSmryType = "3" then
		txtFldName = "Schedule Date"
	else
		txtFldName = "Release Date"
	end if
	'With objText
	  if vntQSView <> "4" then
		if vntQSView = "8" then
			txtProdMgr = "Product Manager,"
		else
			txtProdMgr = ""
		end if
		if vntQSCat = "29" then
			txthdr = "Ship Bldg/Plant,Storage Loc,TE Corp Part,Part Desc,Order Number,Order Item Nbr,Shipment ID,Cntrlr Code," & txtProdMgr & "Order Received Date," & txtFldName & ",Cmprsn Date,Cmprsn Code,Days Variance,JIT,Item Qty,Remaining Qty,ShipTo CustID,ShipTo CustName,SoldTo CustID,SoldTo CustName,Billing Amount TBR/USD,Billing Amount USD,Local Billing Amount,Currency Code,Sbmt Part,Cust Part Nbr,PO Nbr,PO Date,MRP Grp/Make Stk,PPSOC,Sales Doc Eff Date,Order Create by,Dlvry Doc Create Dt,Dlvry Doc Create Time,Dlvry Doc Create by,Request Date,Schedule Date"
		else
			txthdr = "Ship Bldg/Plant,Storage Loc,TE Corp Part,Part Desc,Order Number,Order Item Nbr,Shipment ID,Cntrlr Code," & txtProdMgr & "Order Received Date," & txtFldName & ",Ship Date,Cmprsn Date,Cmprsn Code,Days Variance,JIT,Item Qty,Ship Qty,Invoice Nbr,ShipTo CustID,ShipTo CustName,SoldTo CustID,SoldTo CustName,Billing Amount TBR/USD,Billing Amount USD,Local Billing Amount,Currency Code,Sbmt Part,Cust Part Nbr,PO Nbr,PO Date,Dispatch Nbr,MRP Grp/Make Stk,PPSOC,Sales Doc Eff Date,Order Create by,Dlvry Doc Create Dt,Dlvry Doc Create Time,Dlvry Doc Create by,Request Date,Schedule Date"
		end if
		WriteToExcelCell 1,"hdr",txthdr,txthdr
		for intcount = 0 to ubound(vntArray,2)
		if isnull(vntArray(16,intCount)) then
			vntReplace = vntArray(16, intCount)
		else
			vntReplace = replace(vntArray(16, intCount),","," ")
		end if
		if isnull(vntArray(31, intCount)) then
			vntPONbr = vntArray(31, intCount)
		else
			vntPONbr = replace(vntArray(31, intCount),","," ")
		end if
		if vntQSView = "8" then
			txtProdMgr = vntArray(24, intCount) & ","
		else
			txtProdMgr = ""
		end if
		if vntArray(35, intCount) <> "null" then
			txtMrpGrp = vntArray(35, intCount) 'MRP Group
		else
			txtMrpGrp = vntArray(35, intCount) 'Make Stock
		end if
		if isnull(vntArray(37,intCount)) then ' shipto
			txtShipTo = vntArray(37, intCount)
		else
			txtShipTo = replace(vntArray(37, intCount),","," ")
		end if
		if isnull(vntArray(38,intCount)) then ' soldto
			txtSoldTo = vntArray(38, intCount)
		else
			txtSoldTo = replace(vntArray(38, intCount),","," ")
		end if
		if vntQSCat = "29" then
			WriteToExcelCell intcount+2,"dtl",txthdr,vntArray(0, intCount) & "," & vntArray(39, intCount) & "," & vntArray(1, intCount) & "," & vntReplace & "," & vntArray(2, intCount) & "," & vntArray(12, intCount) & "," & vntArray(13, intCount) & "," & vntArray(21, intCount) & "," & txtProdMgr & vntArray(22, intCount) & "," & vntArray(3, intCount) & "," & vntArray(5, intCount) & "," &  vntArray(6, intCount) & "," & vntArray(7, intCount) & "," & vntArray(8, intCount) & "," & vntArray(27, intCount) & "," & vntArray(28, intCount) & "," & vntArray(17, intCount) & "," & txtShipTo & "," & vntArray(25, intCount) & "," & txtSoldTo & "," & vntArray(23, intCount) & "," & vntArray(15, intCount) & "," & vntArray(18, intCount) & "," & vntArray(20, intCount) & "," & vntArray(26, intCount) & "," & vntArray(30, intCount) & "," & vntPONbr & "," & vntArray(32, intCount) & "," & txtMrpGrp & "," & vntArray(33, intCount) & "," & vntArray(40, intCount) & "," & vntArray(41, intCount) & "," & vntArray(42, intCount) & "," & vntArray(43, intCount) & "," & vntArray(44, intCount) & "," & vntArray(45, intCount) & "," & vntArray(46, intCount)
		else
			WriteToExcelCell intcount+2,"dtl",txthdr,vntArray(0, intCount) & "," & vntArray(39, intCount) & "," & vntArray(1, intCount) & "," & vntReplace & "," & vntArray(2, intCount) & "," & vntArray(12, intCount) & "," & vntArray(13, intCount) & "," & vntArray(21, intCount) & "," & txtProdMgr & vntArray(22, intCount) & "," & vntArray(3, intCount) & "," & vntArray(4, intCount) & "," & vntArray(5, intCount) & "," &  vntArray(6, intCount) & "," & vntArray(7, intCount) & "," & vntArray(8, intCount) & "," & vntArray(27, intCount) & "," & vntArray(28, intCount) & "," & vntArray(29, intCount) & "," & vntArray(17, intCount) & "," & txtShipTo & "," & vntArray(25, intCount) & "," & txtSoldTo & "," & vntArray(23, intCount) & "," & vntArray(15, intCount) & "," & vntArray(18, intCount) & "," & vntArray(20, intCount) & "," & vntArray(26, intCount) & "," & vntArray(30, intCount) & "," & vntPONbr & "," & vntArray(32, intCount) & "," & vntArray(34, intCount) & "," & txtMrpGrp & "," & vntArray(33, intCount) & "," & vntArray(40, intCount) & "," & vntArray(41, intCount) & "," & vntArray(42, intCount) & "," & vntArray(43, intCount) & "," & vntArray(44, intCount) & "," & vntArray(45, intCount) & "," & vntArray(46, intCount)
		end if
		next
		if vntQSView = "8" then
			txtProdMgr = ","
		else
			txtProdMgr = ""
		end if
		if vntQSCat = "29" then
			WriteToExcelCell intcount+2,"tot",txthdr,",,,,,," & txtProdMgr & ",,,,,,Totals:,,," & replace(session("ShpQtyTotal"),",","") & ",,,,," & replace(session("TBRTotal"),",","") & "," & replace(session("ExtTotal"),",","") & "," & replace(session("LocTotal"),",","")
		else
			WriteToExcelCell intcount+2,"tot",txthdr,",,,,,," & txtProdMgr & ",,,,,,,Totals:,,," & replace(session("ShpQtyTotal"),",","") & ",,,,,," & replace(session("TBRTotal"),",","") & "," & replace(session("ExtTotal"),",","") & "," & replace(session("LocTotal"),",","")
		end if
	  else	'ship facility
		txthdr = "Ship Bldg/Plant,Storage Loc,TE Corp Part,Part Desc,Order Number,Order Item Nbr,Shipment ID,Cntrlr Code,Order Received Date,Release Date,Ship Date,Cmprsn Date,Cmprsn Code,Days Variance,JIT,Item Qty,Ship Qty,Invoice Nbr,ShipTo CustID,ShipTo CustName,SoldTo CustID,SoldTo CustName,Billing Amount TBR/USD,Billing Amount USD,Local Billing Amount,Currency Code,Sbmt Part,Cust Part Nbr,PO Nbr,PO Date,Dispatch Nbr,MRP Grp/Make Stk,PPSOC,Sales Doc Eff Date,Order Create by,Dlvry Doc Create Dt,Dlvry Doc Create Time,Dlvry Doc Create by,Request Date,Schedule Date"
		WriteToExcelCell 1,"hdr",txthdr,txthdr
		for intcount = 0 to ubound(vntArray,2)
		if isnull(vntArray(16,intCount)) then
			vntReplace = vntArray(16, intCount)
		else
			vntReplace = replace(vntArray(16, intCount),","," ")
		end if
		if isnull(vntArray(31, intCount)) then
			vntPONbr = vntArray(31, intCount)
		else
			vntPONbr = replace(vntArray(31, intCount),","," ")
		end if
		if vntArray(35, intCount) <> "null" then
			txtMrpGrp = vntArray(35, intCount) 'MRP Group
		else
			txtMrpGrp = vntArray(35, intCount) 'Make Stock
		end if
		if isnull(vntArray(37,intCount)) then ' shipto
			txtShipTo = vntArray(37, intCount)
		else
			txtShipTo = replace(vntArray(37, intCount),","," ")
		end if
		if isnull(vntArray(38,intCount)) then ' soldto
			txtSoldTo = vntArray(38, intCount)
		else
			txtSoldTo = replace(vntArray(38, intCount),","," ")
		end if
		WriteToExcelCell intcount+2,"dtl",txthdr,vntArray(0, intCount) & "," & vntArray(39, intCount) & "," & vntArray(1, intCount) & "," & vntReplace & "," & vntArray(2, intCount) & "," & vntArray(12, intCount) & "," & vntArray(13, intCount) & "," & vntArray(21, intCount) & "," & vntArray(22, intCount) & "," & vntArray(3, intCount) & "," & vntArray(4, intCount) & "," & vntArray(5, intCount) & "," &  vntArray(6, intCount) & "," & vntArray(7, intCount) & "," & vntArray(8, intCount) & "," & vntArray(27, intCount) & "," & vntArray(28, intCount) & "," & vntArray(29, intCount) & "," & vntArray(17, intCount) & "," & txtShipTo & "," & vntArray(25, intCount) & "," & txtSoldTo & "," & vntArray(23, intCount) & "," & vntArray(15, intCount) & "," & vntArray(18, intCount) & "," & vntArray(20, intCount) & "," & vntArray(26, intCount)& "," & vntArray(30, intCount) & "," & vntPONbr & "," & vntArray(32, intCount) & "," & vntArray(34, intCount) & "," & txtMrpGrp & "," & vntArray(33, intCount) & "," & vntArray(40, intCount) & "," & vntArray(41, intCount) & "," & vntArray(42, intCount) & "," & vntArray(43, intCount) & "," & vntArray(44, intCount) & "," & vntArray(45, intCount) & "," & vntArray(46, intCount)
		next
		WriteToExcelCell intcount+2,"tot",txthdr,",,,,,,,,,,,,,Totals:,,," & replace(session("ShpQtyTotal"),",","") & ",,,,,," & replace(session("TBRTotal"),",","") & "," & replace(session("ExtTotal"),",","") & "," & replace(session("LocTotal"),",","")
	  end if
	'end with
	AutoFitColumnsWidth intcount+2,Ubound(Split(txthdr,","))+1
End Function

Function PaintExcelPstDueOpen()
	dim vntReplace, txtProdMgr, txthdr, vntPONbr, txtCustName

	'With objText
		if vntQSView = "8" then
			txtProdMgr = "Product Manager,"
		else
			txtProdMgr = ""
		end if
		if vntCmprType = "1" and vntQSCat = "5" then
			txthdr = "Inv Bldg/Plant,TE Corp Part,Part Desc,Order Number,Order Item Nbr,Shipment ID," & txtProdMgr & "Cntrlr Code,Item Qty,Remaining Qty," & _
					"Reported as of Date,Order Received Date,Schd Date,Days Late,JIT," & _
					"Cust Account ID,Cust Account Name,Booking Amount TBR/USD,Booking Amount USD,Local Booking Amount,Currency Code,Sbmt Part,Cust Part Nbr,PO Nbr,PO Date,PPSOC"
		elseif vntCmprType = "2" and vntQSCat = "5" then
			txthdr = "Inv Bldg/Plant,TE Corp Part,Part Desc,Order Number,Order Item Nbr,Shipment ID," & txtProdMgr & "Cntrlr Code,Item Qty,Remaining Qty," & _
					"Reported as of Date,Order Received Date,Request Date,Days Late,JIT," & _
					"Cust Account ID,Cust Account Name,Booking Amount TBR/USD,Booking Amount USD,Local Booking Amount,Currency Code,Sbmt Part,Cust Part Nbr,PO Nbr,PO Date,PPSOC"
		else
			txthdr = "Inv Bldg/Plant,TE Corp Part,Part Desc,Order Number,Order Item Nbr,Shipment ID," & txtProdMgr & "Cntrlr Code,Item Qty,Remaining Qty," & _
					"Reported as of Date,Order Received Date,Request Date,Schd Date,JIT," & _
					"Cust Account ID,Cust Account Name,Booking Amount TBR/USD,Booking Amount USD,Local Booking Amount,Currency Code,Sbmt Part,Cust Part Nbr,PO Nbr,PO Date,PPSOC"
		end if
		WriteToExcelCell 1,"hdr",txthdr,txthdr
		for intcount = 0 to ubound(vntArray,2)
			if isnull(vntArray(17, intCount)) then
				vntReplace = vntArray(17, intCount)
			else
				vntReplace = replace(vntArray(17, intCount),","," ")
			end if
			if isnull(vntArray(26, intCount)) then
				vntPONbr = vntArray(26, intCount)
			else
				vntPONbr = replace(vntArray(26, intCount),","," ")
			end if
			if vntQSView = "8" then
				txtProdMgr = "," & vntArray(23, intCount)
			else
				txtProdMgr = ""
			end if
			if isnull(vntArray(30, intCount)) then
				txtCustName = vntArray(30, intCount)
			else
				txtCustName = replace(vntArray(30, intCount),","," ")
			end if
			if vntCmprType = "1" and vntQSCat = "5" then
				WriteToExcelCell intcount+2,"dtl",txthdr,vntArray(0, intCount) & "," & vntArray(1, intCount) & "," & vntReplace & "," & vntArray(2, intCount) & "," & vntArray(13, intCount) & "," & vntArray(14, intCount) & txtProdMgr & _
					"," & vntArray(3, intCount) & "," & vntArray(24, intCount) & "," & vntArray(4, intCount) & "," & vntArray(5, intCount) & "," & vntArray(21, intCount) & "," &  vntArray(7, intCount) & "," & vntArray(10, intCount) & "," & vntArray(11, intCount) & "," & vntArray(18, intCount) & "," & _
					vntArray(30, intCount) & "," & vntArray(22, intCount) & "," & cstr(vntArray(15, intCount)) & "," & vntArray(16, intCount) & "," & vntArray(20,intCount) & "," & vntArray(29, intCount) & "," & vntArray(25, intCount) & "," & vntPONbr & "," & vntArray(27, intCount) & "," & vntArray(28, intCount)
			elseif vntCmprType = "2" and vntQSCat = "5" then
				WriteToExcelCell intcount+2,"dtl",txthdr,vntArray(0, intCount) & "," & vntArray(1, intCount) & "," & vntReplace & "," & vntArray(2, intCount) & "," & vntArray(13, intCount) & "," & vntArray(14, intCount) & txtProdMgr & _
					"," & vntArray(3, intCount) & "," & vntArray(24, intCount) & "," & vntArray(4, intCount) & "," & vntArray(5, intCount) & "," & vntArray(21, intCount) & "," &  vntArray(7, intCount) & "," & vntArray(10, intCount) & "," & vntArray(11, intCount) & "," & vntArray(18, intCount) & "," & _
					vntArray(30, intCount) & "," & vntArray(22, intCount) & "," & cstr(vntArray(15, intCount)) & "," & vntArray(16, intCount) & "," & vntArray(20,intCount) & "," & vntArray(29, intCount) & "," & vntArray(25, intCount) & "," & vntPONbr & "," & vntArray(27, intCount) & "," & vntArray(28, intCount)
			else
				WriteToExcelCell intcount+2,"dtl",txthdr,vntArray(0, intCount) & "," & vntArray(1, intCount) & "," & vntReplace & "," & vntArray(2, intCount) & "," & vntArray(13, intCount) & "," & vntArray(14, intCount) & txtProdMgr & _
					"," & vntArray(3, intCount) & "," & vntArray(24, intCount) & "," & vntArray(4, intCount) & "," & vntArray(5, intCount) & "," & vntArray(21, intCount) & "," & vntArray(6, intCount) & "," &  vntArray(7, intCount) & "," & vntArray(11, intCount) & "," & vntArray(18, intCount) & "," & _
					vntArray(30, intCount) & "," & vntArray(22, intCount) & "," & cstr(vntArray(15, intCount)) & "," & vntArray(16, intCount) & "," & vntArray(20,intCount) & "," & vntArray(29, intCount) & "," & vntArray(25, intCount) & "," & vntPONbr & "," & vntArray(27, intCount) & "," & vntArray(28, intCount)
			end if
		next
		if vntQSView = "8" then
			txtProdMgr = ","
		else
			txtProdMgr = ""
		end if
		if vntQSCat = "5" then
			WriteToExcelCell intcount+2,"tot",txthdr,",,,,," & txtProdMgr & ",,,,,,,,,,,Totals:," & replace(session("TBRTotal"),",","") & "," & replace(session("ExtTotal"),",","") & "," & replace(session("LocTotal"),",","")
		else
			WriteToExcelCell intcount+2,"tot",txthdr,",,,,," & txtProdMgr & ",,,,,,,,,,,Totals:," & replace(session("TBRTotal"),",","") & "," & replace(session("ExtTotal"),",","") & "," & replace(session("LocTotal"),",","")
		end if
	'end with
	AutoFitColumnsWidth intcount+2,Ubound(Split(txthdr,","))+1
End Function

Function PaintExcelLead()
	Dim txtLeadTimeHdr, txthdr
	If vntLeadTimetype = "1" then
		txtLeadTimeHdr = "Customer Lead Time:,"
	else
		txtLeadTimeHdr = "Shipped Schedules:,"
	end if
	'With objText
		txthdr = "Row Lables/Lead Times,Less Than Zero,0,1,2,3,4,5,6,7,8,9,10,11->20,21->30,31->40,41->50,51->60," & _
					"61->70,71->80,81->90,91->100,100+"
		WriteToExcelCell 1,"hdr",txthdr,txthdr
		WriteToExcelCell 2,"dtl",txthdr,txtLeadTimeHdr & vntArray(0,0) & "," & vntArray(1,0) & "," & vntArray(2,0) & "," & vntArray(3,0) & "," & vntArray(4,0) & "," & vntArray(5,0) & "," & vntArray(6,0) & "," & vntArray(7,0) & _
					  "," & vntArray(8,0) & "," & vntArray(9,0) & "," & vntArray(10,0) & "," & vntArray(11,0) & "," & vntArray(12,0) & "," & vntArray(13,0) & "," & vntArray(14,0) & "," & vntArray(15,0) & "," & vntArray(16,0) & _
					    "," & vntArray(17,0) & "," & vntArray(18,0) & "," & vntArray(19,0) & "," & vntArray(20,0) & "," & vntArray(21,0)
		WriteToExcelCell 3,"dtl",txthdr,"Percentage of Orders:," & vntCustPercent(0,0) & "," & vntCustPercent(1,0) & "," & vntCustPercent(2,0) & "," & vntCustPercent(3,0) & "," & vntCustPercent(4,0) & "," & vntCustPercent(5,0) & "," & vntCustPercent(6,0) & "," & vntCustPercent(7,0) & _
					  "," & vntCustPercent(8,0) & "," & vntCustPercent(9,0) & "," & vntCustPercent(10,0) & "," & vntCustPercent(11,0) & "," & vntCustPercent(12,0) & "," & vntCustPercent(13,0) & "," & vntCustPercent(14,0) & "," & vntCustPercent(15,0) & "," & vntCustPercent(16,0) & _
					    "," & vntCustPercent(17,0) & "," & vntCustPercent(18,0) & "," & vntCustPercent(19,0) & "," & vntCustPercent(20,0) & "," & vntCustPercent(21,0)
		WriteToExcelCell 4,"dtl",txthdr,"Cumulative Percentage:," & vntCustCumu(0,0) & "," & vntCustCumu(1,0) & "," & vntCustCumu(2,0) & "," & vntCustCumu(3,0) & "," & vntCustCumu(4,0) & "," & vntCustCumu(5,0) & "," & vntCustCumu(6,0) & "," & vntCustCumu(7,0) & _
					  "," & vntCustCumu(8,0) & "," & vntCustCumu(9,0) & "," & vntCustCumu(10,0) & "," & vntCustCumu(11,0) & "," & vntCustCumu(12,0) & "," & vntCustCumu(13,0) & "," & vntCustCumu(14,0) & "," & vntCustCumu(15,0) & "," & vntCustCumu(16,0) & _
					    "," & vntCustCumu(17,0) & "," & vntCustCumu(18,0) & "," & vntCustCumu(19,0) & "," & vntCustCumu(20,0) & "," & vntCustCumu(21,0)
		If vntLeadTimetype = "1" then
			WriteToExcelCell 5,"dtl",txthdr,"Tyco Lead Time:," & vntArray(22,0) & "," & vntArray(23,0) & "," & vntArray(24,0) & "," & vntArray(25,0) & "," & vntArray(26,0) & "," & vntArray(27,0) & "," & vntArray(28,0) & "," & vntArray(29,0) & _
					  "," & vntArray(30,0) & "," & vntArray(31,0) & "," & vntArray(32,0) & "," & vntArray(33,0) & "," & vntArray(34,0) & "," & vntArray(35,0) & "," & vntArray(36,0) & "," & vntArray(37,0) & "," & vntArray(38,0) & _
					    "," & vntArray(39,0) & "," & vntArray(40,0) & "," & vntArray(41,0) & "," & vntArray(42,0) & "," & vntArray(43,0)
			WriteToExcelCell 6,"dtl",txthdr,"Percentage of Orders:," & vntAmpPercent(0,0) & "," & vntAmpPercent(1,0) & "," & vntAmpPercent(2,0) & "," & vntAmpPercent(3,0) & "," & vntAmpPercent(4,0) & "," & vntAmpPercent(5,0) & "," & vntAmpPercent(6,0) & "," & vntAmpPercent(7,0) & _
					  "," & vntAmpPercent(8,0) & "," & vntAmpPercent(9,0) & "," & vntAmpPercent(10,0) & "," & vntAmpPercent(11,0) & "," & vntAmpPercent(12,0) & "," & vntAmpPercent(13,0) & "," & vntAmpPercent(14,0) & "," & vntAmpPercent(15,0) & "," & vntAmpPercent(16,0) & _
					    "," & vntAmpPercent(17,0) & "," & vntAmpPercent(18,0) & "," & vntAmpPercent(19,0) & "," & vntAmpPercent(20,0) & "," & vntAmpPercent(21,0)
			WriteToExcelCell 7,"dtl",txthdr,"Cumulative Percentage:," & vntAmpCumu(0,0) & "," & vntAmpCumu(1,0) & "," & vntAmpCumu(2,0) & "," & vntAmpCumu(3,0) & "," & vntAmpCumu(4,0) & "," & vntAmpCumu(5,0) & "," & vntAmpCumu(6,0) & "," & vntAmpCumu(7,0) & _
					  "," & vntAmpCumu(8,0) & "," & vntAmpCumu(9,0) & "," & vntAmpCumu(10,0) & "," & vntAmpCumu(11,0) & "," & vntAmpCumu(12,0) & "," & vntAmpCumu(13,0) & "," & vntAmpCumu(14,0) & "," & vntAmpCumu(15,0) & "," & vntAmpCumu(16,0) & _
					    "," & vntAmpCumu(17,0) & "," & vntAmpCumu(18,0) & "," & vntAmpCumu(19,0) & "," & vntAmpCumu(20,0) & "," & vntAmpCumu(21,0)
		end if
	'end with
	AutoFitColumnsWidth 8,23
End Function

Function PaintExcelGeneral()
	Dim vntDataSpec,vntDataSpec2
	dim vntDataGen
	dim vntHeadgen
	dim vntHeadSpec
	dim vntTemp
	dim vntEmpty
	dim vntTotal
	dim vntjTotal
	dim vntCount
	dim vntSpace
	dim vntcolcnt

	vntTemp = 0
	vntCount = 0

	'with objText

'Create the different heading titles
	if vntQSCat = "10" then
		vntHeadSpec = "Organization,Ship Loc Code,"
		vntTemp = 2
	elseif vntQSCat = "13" then
		vntHeadSpec = "Organization,"
		vntTemp = 0
	elseif vntQSCat = "15" then
		vntHeadSpec = "Organization,Team Code,Team Name,"
		vntTemp = 3
	elseif vntQSCat = "16" then
		vntHeadSpec = "MRP Controller Unique Key (Inv Org ID/Plant Nbr),Controller Code,"
		vntTemp = 2
	elseif vntQSCat = "17" then
		vntHeadSpec = "Make Stock,Make Stock Desc,"
		vntTemp = 2
	elseif vntQSCat = "18" then
		vntHeadSpec = "GPL Code,GPL Name,"
		vntTemp = 2
	elseif vntQSCat = "19" then
		vntHeadSpec = "GPL Code,Product Code,Product Name,Product Manager,"
		vntTemp = 4
	elseif vntQSCat = "20" then
		vntHeadSpec = "Industry Code,Industry Name,"
		vntTemp = 2
	elseif vntQSCat = "21" then
		vntHeadSpec = "IBC Code,Industry Business Name,"
		vntTemp = 2
	elseif vntQSCat = "22" then
		vntHeadSpec = "PCOC,Mfg Campus ID,"
		vntTemp = 2
	elseif vntQSCat = "23" then
		vntHeadSpec = "PCOC,Mfg Campus ID,Mfg Bldg,GPL,"
		vntTemp = 4
	elseif vntQSCat = "24" then
		vntHeadSpec = "Profit Center,Name,"
		vntTemp = 2
	elseif vntQSCat = "25" then
		vntHeadSpec = "Competency Business,Sub-Competency Business,Name,"
		vntTemp = 3
	elseif vntQSCat = "26" then
		vntHeadSpec = "Sales Office,Name,Plant,"
		vntTemp = 3
	elseif vntQSCat = "27" then
		vntHeadSpec = "Sales Office,Sales Group,Name,Plant,"
		vntTemp = 4
	else
		if vntQSView = "10" then
			vntHeadSpec = "PCOC,Mfg Bldg,Mfg Bldg Name,"
		else
			vntHeadSpec = "Organization,Plant/Bldg,Plant/Bldg Name,"
		end if
		vntTemp = 3
	end if
'Finish the titles
	  if vntSmryType = "1" then
		vntHeadGen = "Total Schds,Total Early Schds,Percent Early,Total On-Time Schds," & _
					"Percent On Time,Total Late Schds,Percent Late,Total JIT Schds,Total Early JIT Schds,JIT Percent Early," & _
					"Total On-Time JIT Schds,JIT Percent on-Time,Total JIT Late Schds,JIT Percent Late"
	  else
		vntHeadGen = "Total Schds,Total Early Schds,Percent Early,Total On-Time Schds," & _
					"Percent On Time,Total Late Schds,Percent Late"
	  end if
	vntcolcnt = ubound(Split(vntHeadSpec & vntHeadGen, ","))
	WriteToExcelCell 1,"hdr",vntHeadSpec & vntHeadGen,vntHeadSpec & vntHeadGen


	  For intCount = 0 to Ubound(vntArray, 2)
		if vntArray(4,intCount) <> "0" then
			vntEarlyPerc = round((cdbl(vntArray(6,intCount)) /cdbl(vntArray(4,intCount))),3) * 100
			vntonTimePerc = round((cdbl(vntArray(8,intCount)) /cdbl(vntArray(4,intCount))),3) * 100
			vntLatePerc = round((cdbl(vntArray(10,intCount)) /cdbl(vntArray(4,intCount))),3) * 100
		else
			vntEarlyPerc = 0
			vntonTimePerc = 0
			vntLatePerc = 0
		end if

		if vntArray(5,intCount) <> "0" then
			vntJearlyPerc = round((cdbl(vntArray(7,intCount)) /cdbl(vntArray(4,intCount))),3) * 100
			vntJonTimePerc = round((cdbl(vntArray(9,intCount)) /cdbl(vntArray(4,intCount))),3) * 100
			vntJlatePerc = round((cdbl(vntArray(11,intCount)) /cdbl(vntArray(4,intCount))),3) * 100
		else
			vntJearlyPerc = 0
			vntJonTimePerc = 0
			vntJlatePerc = 0
		end if
'Only show the ones we have to
		if vntQSCat = "10" then
			vntDataSpec = vntArray(0,intCount) & "-" & replace(vntArray(1,intCount),","," ") & "," & vntArray(2,intCount) & ","
		elseif vntQSCat = "15" then
			If Instr(vntArray(1,intCount),",") > 0 then
				vntDataSpec = replace(vntArray(1,intCount),",","")
			else
				vntDataSpec = vntArray(1,intCount)
			end if
			If Instr(vntArray(3,intCount),",") > 0 then
				vntDataSpec2 = replace(vntArray(3,intCount),",","")
			else
				vntDataSpec2 = vntArray(3,intCount)
			end if
			vntDataSpec = vntArray(0,intCount) & "-" & vntDataSpec & "," & vntArray(2,intCount) & "," & vntDataSpec2 & ","
		elseif vntQSCat = "16" then
			vntDataSpec = vntArray(0,intCount) & "," & vntArray(2,intCount) & ","
		elseif vntQSCat = "13" then
			vntDataSpec = vntArray(0,intCount) & "-" & replace(vntArray(1,intCount),","," ") & ","
		elseif vntQSCat = "17" or vntQSCat = "18" or vntQSCat = "20" or vntQSCat = "21" or vntQSCat = "24" then 'or vntQSCat = "25" then
			if isnull(vntArray(3,intCount)) then
				vntDataSpec = cstr(vntArray(2,intCount)) & "," & vntArray(3,intCount) & ","
			else
				vntDataSpec = cstr(vntArray(2,intCount)) & "," & replace(vntArray(3,intCount),","," ") & ","
			end if
		elseif vntQSCat = "19" or vntQSCat = "27" then
			If Instr(vntArray(3,intCount),",") > 0 then
				vntDataSpec = replace(vntArray(3,intCount),",","")
			else
				vntDataSpec = vntArray(3,intCount)
			end if
			vntDataSpec = vntArray(0,intCount) & "," & vntArray(2,intCount) & "," & vntDataSpec & "," & vntArray(1,intCount) & ","
		elseif vntQSCat = "25" or vntQSCat = "26" then
			vntDataSpec = vntArray(0,intCount) & "," & vntArray(2,intCount) & "," & vntArray(3,intCount) & ","
		elseif vntQSCat = "22" then
			vntDataSpec = vntArray(0,intCount) & "-" & vntArray(1,intCount) & "," & vntArray(2,intCount) & ","
		elseif vntQSCat = "23" then
			vntDataSpec = vntArray(0,intCount) & "-" & vntArray(1,intCount) & "," & vntArray(2,intCount) & "," & vntArray(3,intCount) & ","	 & vntArray(12,intCount) & ","
		else
			If Instr(vntArray(3,intCount),",") > 0 then
				vntDataSpec = replace(vntArray(3,intCount),",","")
			else
				vntDataSpec = vntArray(3,intCount)
			end if
			vntDataSpec = vntArray(0,intCount) & "-" & vntArray(1,intCount) & "," & vntArray(2,intCount) & "," & vntDataSpec & ","
		end if

		if vntSmryType = 1 then
		vntDataGen = vntArray(4,intCount) & "," & vntArray(6,intCount) & "," & vntEarlyPerc & "," & _
			vntArray(8,intCount) & "," & vntonTimePerc & "," & vntArray(10,intCount) & "," & vntLatePerc & "," & _
			vntArray(5,intCount) & "," & vntArray(7,intCount) & "," & vntjEarlyPerc & "," & _
			vntArray(9,intCount) & "," & vntJonTimePerc & "," & vntArray(11,intCount) & "," & vntjLatePerc
		else
		vntDataGen = vntArray(4,intCount) & "," & vntArray(6,intCount) & "," & vntEarlyPerc & ","& _
			vntArray(8,intCount) & "," & vntonTimePerc & "," & vntArray(10,intCount) & "," & vntLatePerc
		end if
		WriteToExcelCell intCount+2,"dtl",vntHeadSpec & vntHeadGen,vntDataSpec & vntDataGen
	  Next

	  for vntCount = 1 to vntTemp - 1
		vntSpace = vntSpace & ","
	  next
	  vntSpace = vntSpace & "Totals:,"
	  if vntSmryType = "1" then
		vntTotal = replace(vntTempArray(0,0),",","") & "," &  replace(vntTempArray(1,0),",","") & "," & vntTempArray(2,0) & "," & replace(vntTempArray(3,0),",","") & "," & _
				   vntTempArray(4,0) & "," &  replace(vntTempArray(5,0),",","") & ","  &  vntTempArray(6,0) & "," &  replace(vntTempArray(7,0),",","") & ","  & _
				   replace(vntTempArray(8,0),",","") & "," &  vntTempArray(9,0) & ","  &  replace(vntTempArray(10,0),",","") & ","  &  vntTempArray(11,0) & ","  & _
				   replace(vntTempArray(12,0),",","") & "," &  vntTempArray(13,0)
	  else
		vntTotal = replace(vntTempArray(0,0),",","") & "," &  replace(vntTempArray(1,0),",","") & "," & vntTempArray(2,0) & "," & replace(vntTempArray(3,0),",","") & "," & _
				 vntTempArray(4,0) & "," &  replace(vntTempArray(5,0),",","") & ","  &  vntTempArray(6,0)
	  end if
	  WriteToExcelCell intCount+2,"tot",vntHeadSpec & vntHeadGen,vntSpace & vntTotal
	'end with
	AutoFitColumnsWidth intCount+2,vntcolcnt+1
End Function

Function PaintExcelOrgYTD()
	Dim txthdr, vntcolcnt
	'With objText
		txthdr = "Organization," & vntCurrMth & " Total Schedules," & vntCurrMth &" On-Time Schedules," & vntCurrMth &" On-Time Percent," & _
					vntPrevMth & " Total Schedules," & vntPrevMth &" On-Time Schedules," & vntPrevMth &" On-Time Percent," & _
					"YTD On-Time Total,YTD On-Time,YTD On-Time Percent"
		if vntSmryType = "1" then
			txthdr = txthdr & "," & vntCurrMth & " Total JIT Schedules," & vntCurrMth & " On-Time JIT Schedules," & vntCurrMth & " On-Time JIT Percent," & _
									vntPrevMth & " Total JIT Schedules," & vntPrevMth & " On-Time JIT Schedules," & vntPrevMth & " On-Time JIT Percent," & _
									" YTD JIT On-Time Total,YTD JIT On-Time,YTD JIT On-Time Percent"
		end if
		WriteToExcelCell 1,"hdr",txthdr,txthdr
		For intCount = 0 to (Ubound(vntArray,2) - 1)
			if vntSmryType = "1" then
				WriteToExcelCell intCount+2,"dtl",txthdr,replace(vntArray(0, intCount),",","") & "," & vntArray(2, intCount) & "," & vntArray(3, intCount) & "," & _
					vntArray(4,intcount) & "," & vntArray(5,intcount) & "," & vntArray(6,intcount) & "," & vntArray(7,intcount) & "," & _
					vntArray(8,intcount) & "," & vntArray(9,intcount) & "," & vntArray(10,intcount) & "," & _
					vntArray(11,intcount) & "," & vntArray(12,intcount) & "," & vntArray(13,intcount) & "," & vntArray(14,intcount) & "," & _
					vntArray(15,intcount) & "," & vntArray(16,intcount) & "," & vntArray(17,intcount) & "," & _
					vntArray(18,intcount) & "," & vntArray(19,intcount)
			else
				WriteToExcelCell intCount+2,"dtl",txthdr,replace(vntArray(0, intCount),",","") & "," & vntArray(2, intCount) & "," & vntArray(3, intCount) & "," & _
					vntArray(4,intcount) & "," & vntArray(5,intcount) & "," & vntArray(6,intcount) & "," & vntArray(7,intcount) & "," & _
					vntArray(8,intcount) & "," & vntArray(9,intcount) & "," & vntArray(10,intcount)
			end if
		next
	'end with
	vntcolcnt = ubound(Split(txthdr, ","))
	AutoFitColumnsWidth intCount+2,vntcolcnt+1
End Function

Function PaintExcelCustList()
	Dim txthdr
	'With objText
		txthdr = "Organization, Organization Name, Customer Account Nbr, Customer Window Early, " & _
					"Customer Window Late, Date of Last Shipment"
		WriteToExcelCell 1,"hdr",txthdr,txthdr
		For intCount = 0 to (Ubound(vntArray,2))
			WriteToExcelCell intCount+2,"dtl",txthdr,replace(vntArray(0, intCount),",","") & "," & replace(vntArray(1, intCount),",","") & "," & _
				replace(vntArray(2, intCount),",","") & "," & vntArray(3,intcount) & "," & _
				vntArray(4,intcount) & "," & vntArray(5,intcount)
		next
	'end with
	AutoFitColumnsWidth intCount+2,6
End Function

Function PaintExcelWWList()
	Dim txthdr
	'With objText
		txthdr = "Worldwide Account Nbr,Customer Name"
		WriteToExcelCell 1,"hdr",txthdr,txthdr
		For intCount = 0 to Ubound(vntArray,2)
			WriteToExcelCell intCount+2,"dtl",txthdr,vntArray(0, intCount) & "," & replace(vntArray(1, intCount),","," ")
		next
	'end with
	AutoFitColumnsWidth intCount+2,2
End Function

Function PaintExcelShpFcltyList()
	Dim txthdr
	'With objText
		txthdr = "Ship Loc, Organization, Total Schedules, " & _
					"Total On-Time Schedules, Percent OnTime, Total Late Schedules, Percent Late"
		WriteToExcelCell 1,"hdr",txthdr,txthdr
		For intCount = 0 to (Ubound(vntArray,2) - 1)
			WriteToExcelCell intCount+2,"dtl",txthdr,vntArray(0,intcount) & "," & replace(vntArray(1, intCount),",","") & "," & vntArray(2, intCount) & "," & vntArray(3, intCount) & "," & _
					vntArray(4,intcount) & "," & vntArray(5,intcount) & "," & vntArray(6,intcount)
		next
	'end with
	AutoFitColumnsWidth intCount+2,7
End Function

'*********************************************************************************************************
'Here are the values of vntArray Function GetGeneral()
'*********************************************************************************************************
'Org/Org Desc (may change based on list)	vntArray(0), vntArray(1)	Total JIT			vntArray(5)
'ViewDesc1 (list specific)					vntArray(2)					Total Early Jit		vntArray(7)
'ViewDesc2 (list specific)					vntArray(3)					JIT On Time			vntArray(9)
'Total Schds								vntArray(4)					Jit Late			vntArray(11)
'Total Early								vntArray(6)
'Total On-Time								vntArray(8)
'Total Late									vntArray(10)
'*********************************************************************************************************
function PaintGeneralType()
	dim vntLastOne

	vntColorNow = sRow1Color
	intcount = 0
	With Response
		.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
  			.Write "<tr" & sTableHeadBg & ">"
  				if vntQSCat = "17"or vntQSCat = "18" or vntQSCat = "20"  or vntQSCat = "21" or vntQSCat = "24" then 'or vntQSCat = "25" then
  				elseif vntQSCat = "19" then
  					.Write "<th ALIGN=""center""><font size=""2"" color = White>GPL Code</th>"
  				elseif vntQSCat = "25" then
  					.Write "<th ALIGN=""center""><font size=""2"" color = White>Competency Business</th>"
  				elseif vntQSCat = "26" or vntQSCat = "27" then
  					.Write "<th ALIGN=""center""><font size=""2"" color = White>Sales Office</th>"
  				elseif vntQSView = "10" and (vntQSCat = "9" or vntQSCat = "22" or vntQSCat = "23") then
  					.Write "<th ALIGN=""center""><font size=""2"" color = White>PCOC</th>"
  				elseif vntQSCat = "16" then
  					.Write "<th ALIGN=""center""><font size=""2"" color = White>MRP Controller Unique Key<br>(Inv Org ID/Plant Nbr)</th>"
  				else
     				.Write "<th ALIGN=""center""><font size=""2"" color = White>Organization</th>"
     			end if
				if vntQSCat = "27" then
					.Write "<th ALIGN=""center""><font size=""2"" color = White>Sales Group</th>"
				end if
     			if vntQSCat = "9" then
     				if vntQSView = "10" then 'Manufacturing Building
          				.Write "<th ALIGN=""center""><font size=""2"" color = White>Mfg<br>Bldg Nbr</th>"
          				.Write "<th ALIGN=""center""><font size=""2"" color = White>Mfg<br>Bldg Name</th>"
     				else
          				.Write "<th ALIGN=""center""><font size=""2"" color = White>Plant/<br>Bldg Nbr</th>"
          				.Write "<th ALIGN=""center""><font size=""2"" color = White>Plant/<br>Bldg Name</th>"
          			end if
          		elseif vntQSCat = "10" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Ship Loc<br>Code</th>"
          			'.Write "<th ALIGN=""center""><font size=""2"" color = White>Team Name</th>"
          		elseif vntQSCat = "15" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Team<br>Code</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Team Name</th>"
          		elseif vntQSCat = "16" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Controller<br>Code</th>"
          		elseif vntQSCat = "17" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Make<br>Stock</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Make Stock<br>Desc</th>"
          		elseif vntQSCat = "18" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>GPL<br>Code</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>GPL Name</th>"
          		elseif vntQSCat = "19" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Product<br>Code</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Product Name</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Product Manager</th>"
          		elseif vntQSCat = "20" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Industry<br>Code</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Industry Name</th>"
          		elseif vntQSCat = "21" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>IBC<br>Code</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Industry Business Name</th>"
          		elseif vntQSCat = "22" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Mfg.<br>Campus ID</th>"
          			'.Write "<th ALIGN=""center""><font size=""2"" color = White>Product Name</th>"
          		elseif vntQSCat = "23" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Mfg.<br>Campus ID</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Mfg.<br>Bldg Nbr ID</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>GPL</th>"
          		elseif vntQSCat = "24" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Profit<br>Center</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Name</th>"
          		elseif vntQSCat = "25" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Sub<br>Competency<br>Business</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Name</th>"
          		elseif vntQSCat = "26" or vntQSCat = "27" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Name</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Plant</th>"
          		end if
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Total<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Total<br>Early<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Percent<br>Early</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Total<br>On-Time<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Percent<br>On-Time</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Total<br>Late<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Percent<br>Late</th>"
          		if vntSmryType = "1" then
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Total<br>JIT<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Total<br>Early<br>JIT<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>JIT<br>Percent<br>Early</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>JIT<br>On-Time<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>JIT<br>Percent<br>On-Time</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>JIT<br>Late<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>JIT<br>Percent<br>Late</th>"
          		end if
			.Write "</tr>"
			vntLastOne = Ubound(vntArray, 2)
			PrintTotals()
			vntColorNow = sRow2Color
		For intCount = 0 to Ubound(vntArray, 2)
			if intcount > 0 then
				'no subtotals for 15,18
				if vntQScat = "19" or vntQScat = "25" or vntQScat = "26" then
					if cstr(vntArray(0,intCount)) <> cstr(vntArray(0,intCount -1)) then
						if vntQSCat = "13" or vntQSCat = "15" or vntQSCat = "18" or vntQSCat = "20" or vntQSCat = "21" or vntQSCat = "24" then 'or vntQSCat = "25"   then
						else
							PaintSubTotals()
						end if
					end if
				elseif vntQSCat = "17" then
					if cstr(left(vntArray(2,intCount),1)) <> cstr(left(vntArray(2,intCount -1),1)) then
						PaintSubTotals()
					end if
				elseif vntQSCat = "13" and vntQSView = "3" then
				elseif cstr(vntArray(2,intCount)) <> cstr(vntArray(2,intCount -1)) then
					if vntQSCat = "13" or vntQSCat = "15" or vntQSCat = "18" or vntQSCat = "20" or vntQSCat = "21" or vntQSCat = "24" then 'or vntQSCat = "25"   then
					else
						PaintSubTotals()
					end if
				end if
			end if
				.Write "<tr" & vntColornow & ">"
					if vntQSCat = "17" or vntQSCat = "18"  or vntQSCat = "20" or vntQSCat = "21"  or vntQSCat = "24" then 'or vntQSCat = "25"   then
		      		elseif vntQSCat = "19" or vntQSCat = "16" or vntQSCat = "25" or vntQScat = "26" or vntQScat = "27" then
		      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(0,intCount) & "</td>"
		      		else
		      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(0,intCount)
		      			if vntArray(1,intCount) <> "" then
		      				.Write  "-"
		      			end if
		      			.write vntArray(1,intCount) & "</td>"
      				end if
      				if vntQSCat = "13" then
      				else
      					.Write "<td ALIGN=""left""><font size=""2"">"
      						if isnull(vntArray(2,intCount)) then
      							.Write "&nbsp;"
      						else
      							.Write vntArray(2,intCount)
      						end if
      					.Write "</td>"
      				end if
      				if vntQSCat = "13" or vntQSCat = "10" or vntQSCat = "16" or vntQSCat = "22" then
      				else
      					.Write "<td ALIGN=""left""><font size=""2"">"
      						if  isnull(vntArray(3,intCount)) then
      							.Write "&nbsp;"
      						else
      							.Write vntArray(3,intCount)
      						end if
      					.Write  "</td>"
      				end if
      				if vntQSCat = "19" or vntQSCat = "27" then
      					.Write "<td ALIGN=""left""><font size=""2"">"
      						if len(trim(vntArray(1,intCount))) = 0 then
      							.Write "&nbsp;"
      						else
      							.Write vntArray(1,intCount)
      						end if
      					.Write  "</td>"
      				end if
      				if vntQSCat = "23" then
      					.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(12,intCount) & "</td>"
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(4,intCount) & "</td>"
      					vntTotSchds = vntTotSchds + cdbl(vntArray(4,intCount))
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(6,intCount) & "</td>"
      					vntTotEarly = vntTotEarly + cdbl(vntArray(6,intCount))
      				if cdbl(vntArray(4,intCount)) <> 0 then
      					vntEarlyPerc = round((cdbl(vntArray(6,intCount)) /cdbl(vntArray(4,intCount))),3) * 100
      				else
      					vntEarlyPerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntEarlyPerc & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(8,intCount) & "</td>"
      					vntTotonTime = vntTotOnTime + cdbl(vntArray(8,intCount))
      				if cdbl(vntArray(4,intCount)) <> 0 then
      					vntonTimePerc = round((cdbl(vntArray(8,intCount)) /cdbl(vntArray(4,intCount))),3) * 100
      				else
      					vntOnTimePerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntonTimePerc & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(10,intCount) & "</td>"
      					vntTotLate = vntTotLate + cdbl(vntArray(10,intCount))
      				if cdbl(vntArray(4,intCount)) <> 0 then
      					vntLatePerc = round((cdbl(vntArray(10,intCount)) /cdbl(vntArray(4,intCount))),3) * 100
      				else
      					vntLatePerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntLatePerc & "</td>" '****
   '********Paint the JIT Columns if warrented
      			if vntSmrytype = "1" then
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(5,intCount) & "</td>"
      					vntJTotSchds = vntJTotSchds + cdbl(vntArray(5,intCount))
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(7,intCount) & "</td>"
      					vntJTotEarly = vntJTotEarly + cdbl(vntArray(7,intCount))
					if  cdbl(vntArray(5,intCount)) <> 0 then
      					vntJearlyPerc = cdbl(round((cdbl(vntArray(7,intCount)) /cdbl(vntArray(4,intCount))),3) * 100) '5->4
      				else
      					vntJearlyPerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntJearlyPerc & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(9,intCount) & "</td>"
      					vntJTotOnTime = vntJTotOnTime + cdbl(vntArray(9,intCount))
      				if  cdbl(vntArray(5,intCount)) <> 0 then
      					vntJonTimePerc = round((cdbl(vntArray(9,intCount)) /cdbl(vntArray(4,intCount))),3) * 100 '5->4
      				else
      					vntJonTimePerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntJonTimePerc & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(11,intCount) & "</td>"
      					vntJTotLate = vntJTotLate + cdbl(vntArray(11,intCount))
      				if  cdbl(vntArray(5,intCount)) <> 0 then
      					vntJlatePerc = round((cdbl(vntArray(11,intCount)) /cdbl(vntArray(4,intCount))),3) * 100 '5->4
      				else
      					vntJlatePerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntJlatePerc & "</td>"
				end if
   				.Write "</tr>"
   				if vntColorNow= srow1color then
					vntColorNow = srow2color
				else
					vntColorNow = srow1color
				end if
				if vntLastOne = intCount then
					if vntQSCat = "13" or  vntQSCat = "15" or vntQSCat = "18" or vntQSCat = "20" or vntQSCat = "21" or vntQSCat = "24" then 'or vntQSCat = "25"   then
					else
						blnEnd = true
						PaintSubTotals()
					end if
				end if
   		next
   		PrintTotals()
      	.Write "</table>"
	end with
end function

function PaintSubTotals()
	with response
					.Write "<tr" & vntColornow & ">"
					if vntQSCat = "17" or vntQSCat = "18" or vntQSCat = "19" or vntQSCat = "25" or vntQSCat = "26" then
					else
						.Write "<td ALIGN=""left""><font size=""2"" color=blue>&nbsp;</td>"
					end if
					if blnEnd then
						if vntQSCat = "19" or vntQSCat = "25" or vntQSCat = "26" then
							.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(0,intCount) & "</td>"
							.Write "<td ALIGN=""left""><font size=""2"" color=blue>&nbsp;</td>"
						elseif vntQSCat = "17" then
							'if vntCount > 1 then
							'	.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & left(vntArray(2,intCount -1),1) & "</td>"
							'else
								.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & left(vntArray(2,intCount),1) & "</td>"
							'end if
						else
							.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(2,intCount) & "</td>"
						end if
						if vntQSCat = "10" or vntQSCat = "13" or  vntQSCat = "16" or vntQSCat = "22" then
						elseif vntQSCat = "17" or vntQSCat = "26" then
							.Write "<td ALIGN=""left""><font size=""2"" color=blue>&nbsp;</td>"
						elseif vntQSCat = "23" or vntQSCat = "19" or vntQSCat = "27" then
							.Write "<td ALIGN=""left""><font size=""2"" color=blue>&nbsp;</td>"
							.Write "<td ALIGN=""left""><font size=""2"" color=blue>&nbsp;</td>"
						elseif vntQSCat = "25" then
      						.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(1,intCount) & "</td>"
						else
      						'.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(3,intCount) & "</td>"
      						.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>"
      						if isnull(vntArray(3,intCount)) then
      							.Write "&nbsp;"
      						else
      							.Write vntArray(3,intCount)
      						end if
      						.Write  "</td>"
      					end if
      					'if vntQSCat = "23" then
      					'	.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(12,intCount) & "</td>"
      					'end if
					else
						if vntQSCat = "19" or vntQSCat = "25" or vntQSCat = "26" then
							.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(0,intCount -1) & "</td>"
							.Write "<td ALIGN=""left""><font size=""2"" color=blue>&nbsp;</td>"
						elseif vntQSCat = "17" then
							.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & left(vntArray(2,intCount -1),1) & "</td>"
						else
							.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(2,intCount -1) & "</td>"
						end if
						if vntQSCat = "10"  or vntQSCat = "13" or  vntQSCat = "16"  or vntQSCat = "22" then
						elseif vntQSCat = "17" or vntQSCat = "26"  then
							.Write "<td ALIGN=""left""><font size=""2"" color=blue>&nbsp;</td>"
						elseif vntQSCat = "23"  or vntQSCat = "19" or vntQSCat = "27" then
							.Write "<td ALIGN=""left""><font size=""2"" color=blue>&nbsp;</td>"
							.Write "<td ALIGN=""left""><font size=""2"" color=blue>&nbsp;</td>"
						elseif vntQSCat = "25" then
      						.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(1,intCount-1) & "</td>"
						else
      						.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>"
      						 if isnull(vntArray(3,intCount-1)) then
      							.Write "&nbsp;"
      						else
      							.Write vntArray(3,intCount-1)
      						end if
      						.Write  "</td>"
      					end if
      					'if vntQSCat = "23" then
      					'	.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(12,intCount - 1) & "</td>"
      					'end if
      				end if

      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntTotSchds & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntTotEarly & "</td>"
      				if cdbl(vntTotSchds) <> 0 then
      					vntEarlyPerc = round((cdbl(vntTotEarly) /cdbl(vntTotSchds)),3) * 100
      				else
      					vntEarlyPerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntEarlyPerc & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntTotOnTime & "</td>"
      				if cdbl(vntTotSchds) <> 0 then
      					vntonTimePerc = round((cdbl(vntTotOnTime) /cdbl(vntTotSchds)),3) * 100
      				else
      					vntOnTimePerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntonTimePerc & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntTotLate & "</td>"
      				if cdbl(vntTotSchds) <> 0 then
      					vntLatePerc = round((cdbl(vntTotLate) /cdbl(vntTotSchds)),3) * 100
      				else
      					vntLatePerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntLatePerc & "</td>" '****
      			if vntSmryType = "1" then
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntjTotSchds & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntJTotEarly & "</td>"
					if  cdbl(vntjTotSchds) <> 0 then
      					vntJearlyPerc = cdbl(round((cdbl(vntJTotEarly) /cdbl(vntTotSchds)),3) * 100)'5->4
      				else
      					vntJearlyPerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntJearlyPerc & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntJTotOnTime & "</td>"
      				if  cdbl(vntjTotSchds) <> 0 then
      					vntJonTimePerc = round((cdbl(vntJTotOnTime) /cdbl(vntTotSchds)),3) * 100 '5->4
      				else
      					vntJonTimePerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntJonTimePerc & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntJTotLate & "</td>"
      				if  cdbl(vntjTotSchds) <> 0 then
      					vntJlatePerc = round((cdbl(vntJTotLate) /cdbl(vntTotSchds)),3) * 100 '5->4
      				else
      					vntJlatePerc = 0
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntJlatePerc & "</td>"
      			end if
   					.Write "</tr>"
   					if vntColorNow= srow1color then
						vntColorNow = srow2color
					else
						vntColorNow = srow1color
					end if
						vntTotSchds = 0
						vntTotEarly = 0
						vntTotOnTime = 0
						vntTotLate = 0
						vntjTotSchds = 0
						vntjTotEarly = 0
						vntjTotOnTime = 0
						vntjTotLate = 0
		end with
end function

Function PrintTotals
	with response
   		.Write "<tr" & vntColornow & ">"
   			if vntQSCat = "13" or  vntQSCat = "17" or vntQSCat = "18" or vntQSCat = "20" or vntQSCat = "21" or vntQSCat = "24" then 'or vntQSCat = "25"   then
   			else
				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
			end if
			if vntQSCat = "13" or  vntQSCat = "10"  or vntQSCat = "16" or vntQSCat = "22" then
			else
      			.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      		end if
      		if vntQSCat = "23" or vntQSCat = "19" or vntQSCat = "27" then
      			.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      		end if
      		.Write "<td ALIGN=""right""><font size=""2""><strong>TOTALS:</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(0,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(1,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(2,0) & "</td>"
			.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(3,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(4,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(5,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(6,0) & "</td>"
      		if vntSmryType = "1" then
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(7,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(8,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(9,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(10,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(11,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(12,0) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2""><strong>" & vntTempArray(13,0) & "</td>"
      		end if
      	.Write "</tr>"
      end with
end function

Function PaintLeadResults()
	With Response
		.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
  			.Write "<tr" & sTableHeadBg & ">"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>Row Labels /<br>Lead Times</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Less<br>Than 0</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>0</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>1</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>2</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>3</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>4</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>5</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>6</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>7</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>8</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>9</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>10</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>11-20</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>21-30</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>31-40</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>41-50</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>51-60</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>61-70</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>71-80</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>81-90</th>"
				.Write "<th ALIGN=""center""><font size=""2"" color = White>91-100</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>100+</th>"
			.Write "</tr>"
			.Write "<tr" & sRow1Color & ">"
				if vntLeadTimeType = "1" then
					.Write "<td ALIGN=""right"" nowrap><font size=""2""><strong>Customer Lead Time:</strong></td>"
				else
					.Write "<td ALIGN=""right"" nowrap><font size=""2""><strong>Shipped Schedules:</strong></td>"
				end if
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(0,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(1,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(2,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(3,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(4,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(5,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(6,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(7,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(8,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(9,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(10,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(11,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(12,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(13,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(14,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(15,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(16,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(17,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(18,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(19,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(20,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(21,0) & "</td>"
			.Write "</tr>"
			.Write "<tr" & sRow2Color & ">"
				.Write "<td ALIGN=""right"" nowrap><font size=""2""><strong>Percentage of Orders:</strong></td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(0,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(1,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(2,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(3,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(4,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(5,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(6,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(7,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(8,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(9,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(10,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(11,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(12,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(13,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(14,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(15,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(16,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(17,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(18,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(19,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(20,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustPercent(21,0) & "</td>"
			.Write "</tr>"
			.Write "<tr" & sRow1Color & ">"
				.Write "<td ALIGN=""right"" nowrap><font size=""2""><strong>Cumulative Percentage:</strong></td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(0,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(1,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(2,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(3,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(4,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(5,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(6,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(7,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(8,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(9,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(10,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(11,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(12,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(13,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(14,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(15,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(16,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(17,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(18,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(19,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(20,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntCustCumu(21,0) & "</td>"
			.Write "</tr>"
			if vntLeadTimeType = "1" then
			.Write "<tr" & sRow2Color & ">"
				.Write "<td ALIGN=""right"" nowrap><font size=""2""><strong>Tyco Lead Time:</strong></td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(22,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(23,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(24,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(25,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(26,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(27,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(28,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(29,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(30,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(31,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(32,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(33,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(34,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(35,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(36,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(37,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(38,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(39,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(40,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(41,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(42,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(43,0) & "</td>"
			.Write "</tr>"
			.Write "<tr" & sRow1Color & ">"
				.Write "<td ALIGN=""right"" nowrap><font size=""2""><strong>Percentage of Orders:</strong></td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(0,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(1,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(2,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(3,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(4,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(5,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(6,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(7,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(8,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(9,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(10,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(11,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(12,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(13,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(14,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(15,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(16,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(17,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(18,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(19,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(20,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpPercent(21,0) & "</td>"
			.Write "</tr>"
			.Write "<tr" & sRow2Color & ">"
				.Write "<td ALIGN=""right"" nowrap><font size=""2""><strong>Cumulative Percentage:</strong></td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(0,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(1,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(2,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(3,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(4,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(5,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(6,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(7,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(8,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(9,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(10,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(11,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(12,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(13,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(14,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(15,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(16,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(17,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(18,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(19,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(20,0) & "</td>"
				.Write "<td ALIGN=""right""><font size=""2"">" & vntAmpCumu(21,0) & "</td>"
			.Write "</tr>"
			end if
		.Write "</table>"
	end with
end function

Function PaintPDueOpenResults()
	vntColorNow = sRow1Color
	blnStart = true
	SetPaging()
	intcount = 0
	With Response
		.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
  			.Write "<tr" & sTableHeadBg & ">"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>Inv<br>Bldg/<br>Plant</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>TE Corp Part</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Order<br>Number</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Order<br>Item Nbr</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Shipment<br>ID</th>"
          		if vntQSView = "8" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Product<br>Manager</th>"
          		end if
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Cntrlr<br>Code</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Item<br>Qty</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Rem'ng<br>Qty</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Reported<br>As of Date</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Order<br>Received Date</th>"
          		if vntCmprType = "1" and vntQSCat = "5" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Schd<br>Date</th>"
          		elseif vntCmprType = "2" and vntQSCat = "5" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Requested<br>Date</th>"
          		else
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Requested<br>Date</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Schd<br>Date</th>"
          		end if
          		if vntQSCat <>  "6" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Days<br>Late</th>"
          		end if
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>J<br>I<br>T</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Customer<br>Account</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Booking<br>Amount<br>TBR/USD</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Booking<br>Amount<br>USD</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Booking<br>Amount</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Submitted<br>Part</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Cust<br>Part</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>PO<br>Nbr</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>PO<br>Date</th>"
			.Write "</tr>"
		For intCount = 0 to Ubound(vntArray)
				.Write "<tr" & vntColornow & ">"
		      		.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,0) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2""><a href=" & strServerUrl & appPath & "Detail.asp?org=" & vntArray(intCount,19)& "&ord=" & vntArray(intCount,2) & "&ordi=" & vntArray(intCount,13) & "&shp=" & vntArray(intCount,14) & "&cat=" & vntQSCat  & " target=""Detail"">" & vntArray(intCount,1) & "</a>"
		 				.Write "<br>" & vntArray(intCount,17) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,2) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,13) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,14) & "</td>"
          			if vntQSView = "8" then
          				if len(trim(vntArray(intCount,23))) = 0 then
          					.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
          				else
      						.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,23) & "</td>"
      					end if
          			end if
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,3) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,24) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,4) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,5) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,21) & "</td>"
      				if vntCmprType = "1" and vntQSCat = "5" then
      					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,7) & "</td>"
      				elseif vntCmprType = "2" and vntQSCat = "5" then
      					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,7) & "</td>"
      				else
      					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,6) & "</td>"
      					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,7) & "</td>" '****
      				end if
      				if vntQSCat <> "6" then
      					.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,10) & "</td>"
      				end if
      				.Write "<td ALIGN=""center""><font size=""2"">" & vntArray(intCount,11) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,18) & "<br>" & vntArray(intCount,30) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,22) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,15) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,16) & " " & vntArray(intCount,20) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,29) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,25) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,26) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,27) & "</td>"
   				.Write "</tr>"
   				if vntColorNow= srow1color then
					vntColorNow = srow2color
				else
					vntColorNow = srow1color
				end if
   		next
				.Write "<tr" & vntColornow & ">"
		      		.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				if vntQSView = "8" then
      					.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				end if
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>" '****
      				if vntQSCat <> "5" then
      					.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				end if
      				if vntQSCat <> "6" then
      					.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      					'.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				end if
      				'.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2""><strong>Totals:</strong></td>"
      				.Write "<td ALIGN=""right""><font size=""2""><strong>" & session("TBRTotal") & "</strong></td>"
      				.Write "<td ALIGN=""right""><font size=""2""><strong>" & session("ExtTotal") & "</strong></td>"
      				.Write "<td ALIGN=""right""><font size=""2""><strong>" & session("LocTotal") & "</strong></td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
   				.Write "</tr>"
   		Response.Write "</table>"
   		blnStart = false
   		blnSecondTime = true
   		SetPaging()
	end with
end Function

'*********************************************************************************************************
'Here are the values of vntArray Function GetConfNonConf()
'*********************************************************************************************************
'ship loc			vntArray(0)						JIT					vntArray(8)
'Part/Part Desc		vntArray(1), vntArray(16)		On Dock				vntArray(9)
'Order Number		vntArray(2)						Cstmr Days Early	vntArray(10)
'Order Item			vntArray(12)					Cstmr Dyas Late		vntArray(11)
'Ship Id			vntArray(13)					Cstmr Acct			vntArray(17)
'Release/Sched Date	vntArray(3)						Billing Amt USD		vntArray(15)
'Ship Date			vntArray(4)						Billing Amt Local	vntArray(18)
'Comparison Dt		vntArray(5)						Local Curr Desc		vntArray(20)
'Comparison Cde		vntArray(6)						Cntrlr Code			vntArray(21)
'Days Variance		vntArray(7)						Order Received Date	vntArray(22)
'Billing Amt TBR	vntArray(23)					Prod Mgr			vntArray(24)
'Sold To			vntArray(25)					Sbmt Part			vntArray(26)
'Item Qty			vntArray(27)					Shipped Qty			vntArray(28)
'Invoice Nbr		vntArray(29)					Cust Part			vntArray(30)
'PO Nbr				vntArray(31)					PO Date				vntArray(32)
'PPSOC				vntArray(33)					Dispatch Nbr		vntArray(34)
'MRP Group			vntArray(35)					Make Stock			vntArray(36)
'Shipto Nm			vntArray(37)					Soldto Nm			vntArray(38)
'**********************************************************************************************************
Function PaintConNonResults()
	vntColorNow = sRow1Color
	blnStart = true
	SetPaging()
	With Response
		.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
  			.Write "<tr" & sTableHeadBg & ">"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>Ship<br>Bldg/<br>Plant</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>TE Corp Part</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Order<br>Number</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Order<br>Item Nbr</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Shipment<br>ID</th>"
          		if vntQSView = "8" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Product<br>Manager</th>"
          		end if
          		'if vntQSView = "4" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Cntrlr<br>Code</th>"
          		'end if
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Order<br>Received Date</th>"
				if vntSmryType = "3" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Schedule<br>Date</th>"
          		else
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Release<br>Date</th>"
				end if
				if vntQSCat <> "29" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Ship Date</th>"
          		end if
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Cmprsn<br>Date</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Cmprsn<br>Code</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Days<br>Variance</th>"
          		'if vntQSView <> "4" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>J<br>I<br>T</th>"
          		'end if
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Item<br>Qty</th>"
          		if vntQSCat = "29" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Rem'ng<br>Qty</th>"
          		else
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Ship<br>Qty</th>"
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Invoice<br>Nbr</th>"
          		end if
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Ship To<br>Account</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Sold To<br>Account</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Billing<br>Amount<br>TBR/USD</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Billing<br>Amount<br>USD</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Billing<br>Amount</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Submitted<br>Part</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Cust<br>Part<br>Nbr</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>PO<br>Nbr</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>PO<br>Date</th>"
				if vntQSCat <> "29" then
          			.Write "<th ALIGN=""center""><font size=""2"" color = White>Dispatch<br>Nbr</th>"
          		end if
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>MRP Grp/<br>Make<br>Stock</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>PPSOC</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Sales Doc Eff Date</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Order Create by</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Dlvry Doc Create Dt</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Dlvry Doc Create by</th>"
			.Write "</tr>"
		For intCount = 0 to Ubound(vntArray)
				.Write "<tr" & vntColornow & ">"
		      		.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,0) & "</td>"
		 			.Write "<td ALIGN=""left""><font size=""2""><a href=" & strServerUrl & appPath & "Detail.asp?org=" & vntArray(intCount,19)& "&ord=" & vntArray(intCount,2) & "&ordi=" & vntArray(intCount,12)  & "&shp=" & vntArray(intCount,13) & "&cat=" & vntQSCat & " target=""Detail"">" & vntArray(intCount,1) & "</a>"
		 				.Write "<br>" & vntArray(intCount,16) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,2) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,12) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,13) & "</td>"
          			if vntQSView = "8" then
          				if len(trim(vntArray(intCount,24))) = 0 then
          					.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
          				else
      						.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,24) & "</td>"
      					end if
          			end if
      				'if vntQSView = "4" then
      					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,21) & "</td>"
      				'end if
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,22) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,3) & "</td>"
      				if vntQSCat <> "29" then
      					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,4) & "</td>"
      				end if
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,5) & "</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,6) & "</td>" '****
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,7) & "</td>"
      				'if vntQSView <> "4" then
      					.Write "<td ALIGN=""center""><font size=""2"">" & vntArray(intCount,8) & "</td>"
      				'end if
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,27) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,28) & "</td>"
      				if vntQSCat <> "29" then
      					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,29) & "</td>"
      				end if
      				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,17) & "<br>" & vntArray(intCount,37) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,25) & "<br>" & vntArray(intCount,38) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,23) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,15) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,18) & " " & vntArray(intCount,20) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,26) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,30) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,31) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,32) & "</td>"
      				if vntQSCat <> "29" then
      					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,34) & "</td>"
      				end if
      				if vntArray(intCount,35) <> "null" then
						.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,35) & "</td>"
					else
						.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,36) & "</td>"
					end if
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,33) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,40) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,41) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,42) & "<br>" & vntArray(intCount,43) & "</td>"
					.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,44) & "</td>"
   				.Write "</tr>"
   				if vntColorNow= srow1color then
					vntColorNow = srow2color
				else
					vntColorNow = srow1color
				end if
   		next
				.Write "<tr" & vntColornow & ">"
		      		.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				if vntQSView = "8" then
      					.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				end if
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				'if vntQSView <> "4" then
      					.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      					.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				'end if
      				if vntQSCat <> "29" then
      					.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>" '****
      				end if
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>" '****
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2""><strong>Totals:</strong></td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""left""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2""><strong>" & session("ShpQtyTotal") & "</strong></td>"
      				if vntQSCat <> "29" then
      					.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				end if
      				'if vntQSView = "4" then
      					.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				'end if
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2""><strong>" & session("TBRTotal") & "</strong></td>"
      				.Write "<td ALIGN=""right""><font size=""2""><strong>" & session("ExtTotal") & "</strong></td>"
      				.Write "<td ALIGN=""right""><font size=""2""><strong>" & session("LocTotal") & "</strong></td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				if vntQSCat <> "29" then
      					.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				end if
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">&nbsp;</td>"
   				.Write "</tr>"
   		Response.Write "</table>"
   		blnStart = false
   		blnSecondTime = true
   		SetPaging()
	end with
end function
'*********************************************************************************************************
'Here are the values of vntArray Function GetOrgYTD()
'*********************************************************************************************************
'Org Level/Org ID/Org Desc			vntArray(0)		Current Month JIT Total Schedules		vntArray(11)
'Subtotal Line Ind					vntArray(1)		Current Month JIT On-Time Schedules		vntArray(3)
'Current Month Total Schedules		vntArray(2)		Current Month JIT On-Time Percent		vntArray(4)
'Current Month On-Time Schedules	vntArray(3)		Previous Month JIT Total Schedules		vntArray(5)
'Current Month On-Time Percent		vntArray(4)		Previous Month JIT On-Time Schedules	vntArray(6)
'Previous Month Total Schedules		vntArray(5)		Previous Month JIT On-Time Percent		vntArray(7)
'Previous Month On-Time Schedules	vntArray(6)		YTD JIT Total Schedules					vntArray(8)
'Previous Month On-Time Percent		vntArray(7)		YTD JIT On-Time Schedules				vntArray(8)
'YTD Total Schedules				vntArray(8)		YTD JIT	On-Time Percent					vntArray(10)
'YTD On-Time Schedules				vntArray(8)
'YTD On-Time Percent				vntArray(10)
'Last row of array contains the Grand Totals for all columns
'*********************************************************************************************************
Function PaintOrgYTDResults()
	vntColorNow = sRow1Color
	blnStart = true
	intcount = 0
	With Response
      	if vntSmryType = "1" then
			.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
		else
			.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
		end if
  			.Write "<tr" & sTableHeadBg & ">"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>Organization</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntCurrMth & "<br>Total<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntCurrMth & "<br>On-Time<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntCurrMth & "<br>On-Time<br>Percent</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntPrevMth & "<br>Total<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntPrevMth & "<br>On-Time<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntPrevMth & "<br>On-Time<br>Percent</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White> YTD<br>On-Time<br>Total</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White> YTD<br>On-Time </th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White> YTD<br>On-Time<br>Percent</th>"
        	if vntSmryType = "1" then
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntCurrMth & "<br>Total JIT<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntCurrMth & "<br>On-Time JIT<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntCurrMth & "<br>On-Time JIT<br>Percent</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntPrevMth & "<br>Total JIT<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntPrevMth & "<br>On-Time JIT<br>Schedules</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>" & vntPrevMth & "<br>On-Time JIT<br>Percent</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White> YTD JIT<br>On-Time<br>Total</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White> YTD JIT<br>On-Time </th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White> YTD JIT<br>On-Time<br>Percent</th>"
			end if
			.Write "</tr>"
		PrintYTDTotals()
		For intCount = 0 to (Ubound(vntArray,2) - 1)
			.Write "<tr" & vntColornow & ">"
			if vntArray(1,intCount) <> "N" then  'Subtotal
				.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(0,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(2,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(3,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(4,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(5,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(6,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(7,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(8,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(9,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(10,intCount) & "</td>"
        		if vntSmryType = "1" then
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(11,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(12,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(13,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(14,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(15,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(16,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(17,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(18,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(19,intCount) & "</td>"
				end if
			else
				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(0,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(2,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(3,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(4,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(5,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(6,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(7,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(8,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(9,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(10,intCount) & "</td>"
        		if vntSmryType = "1" then
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(11,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(12,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(13,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(14,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(15,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(16,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(17,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(18,intCount) & "</td>"
      				.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(19,intCount) & "</td>"
				end if
			end if
   			.Write "</tr>"
  			if vntColorNow= srow1color then
				vntColorNow = srow2color
			else
				vntColorNow = srow1color
			end if
   		next
		PrintYTDTotals()
   		Response.Write "</table>"
   		blnStart = false
	end with
end Function

Function PrintYTDTotals
	with response
		intCount = Ubound(vntArray,2)
   		.Write "<tr" & vntColornow & ">"
		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(0,intCount) & "</td>"
      	.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(2,intCount) & "</td>"
      	.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(3,intCount) & "</td>"
      	.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(4,intCount) & "</td>"
      	.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(5,intCount) & "</td>"
      	.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(6,intCount) & "</td>"
      	.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(7,intCount) & "</td>"
      	.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(8,intCount) & "</td>"
      	.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(9,intCount) & "</td>"
      	.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(10,intCount) & "</td>"
        if vntSmryType = "1" then
      		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(11,intCount) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(12,intCount) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(13,intCount) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(14,intCount) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(15,intCount) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(16,intCount) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(17,intCount) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(18,intCount) & "</td>"
      		.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(19,intCount) & "</td>"
		end if
      	.Write "</tr>"
    end with
end function
'*********************************************************************************************************
'Here are the values of vntArray Function GetCustomerList()
'*********************************************************************************************************
'Org ID - Org Desc			vntArray(0)
'Customer Nbr				vntArray(1)
'Customer Name				vntArray(2)
'Early Window				vntArray(3)
'Late Window				vntArray(4)
'Last Ship Date				vntArray(5)
'*********************************************************************************************************
Function PaintCustomerList()
	vntColorNow = sRow1Color
	blnStart = true
	SetPaging()
	intcount = 0
	With Response
		.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
  			.Write "<tr" & sTableHeadBg & ">"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>Organization</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Customer<br>Account Nbr</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Customer Name</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Customer<br>Window Early</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Customer<br>Window Late</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Date of Last<br>Shipment</th>"
			.Write "</tr>"
		For intCount = 0 to Ubound(vntArray)
			.Write "<tr" & vntColornow & ">"
		     	.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,0) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,1) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,2) & "&nbsp;</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,3) & "&nbsp;</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(intCount,4) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,5) & "&nbsp;</td>"
   			.Write "</tr>"
   			if vntColorNow= srow1color then
				vntColorNow = srow2color
			else
				vntColorNow = srow1color
			end if
   		next
   		Response.Write "</table>"
   		blnStart = false
   		blnSecondTime = true
   		SetPaging()
	end with
end Function
'*********************************************************************************************************
'Here are the values of vntArray Function GetWWList()
'*********************************************************************************************************
'WorldWide Nbr				vntArray(0)
'WorldWide Name				vntArray(1)
'*********************************************************************************************************
Function PaintWWList()
	vntColorNow = sRow1Color
	blnStart = true
	SetPaging()
	intcount = 0
	With Response
		.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
  			.Write "<tr" & sTableHeadBg & ">"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Worldwide<br>Account Nbr</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Customer Name</th>"
			.Write "</tr>"
		For intCount = 0 to Ubound(vntArray)
			.Write "<tr" & vntColornow & ">"
		     	.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,0) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,1) & "&nbsp;</td>"
   			.Write "</tr>"
   			if vntColorNow= srow1color then
				vntColorNow = srow2color
			else
				vntColorNow = srow1color
			end if
   		next
   		Response.Write "</table>"
   		blnStart = false
   		blnSecondTime = true
   		SetPaging()
	end with
end Function
'*********************************************************************************************************
'Here are the values of vntArray Function GetShpFcltyList()
'*********************************************************************************************************
'Ship Location			vntArray(0)
'Org ID - Org Desc		vntArray(1)
'Total Schedules		vntArray(2)
'On-Time Schedules		vntArray(3)
'On-Time Percent		vntArray(4)
'Late Schedules			vntArray(5)
'Late Percent			vntArray(6)
'Last row of array contains the Grand Totals for all columns
'*********************************************************************************************************
Function PaintShpFcltyResults()
	vntColorNow = sRow1Color
	blnStart = true
	SetPaging()
	intcount = 0
	With Response
		.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
  		.Write "<tr" & sTableHeadBg & ">"
         	.Write "<th ALIGN=""right""><font size=""2"" color = White>Ship<br>Loc</th>"
     		.Write "<th ALIGN=""left""><font size=""2"" color = White>Organization</th>"
         	.Write "<th ALIGN=""right""><font size=""2"" color = White>Total<br>Schedules</th>"
          	.Write "<th ALIGN=""right""><font size=""2"" color = White>Total<br>On-Time<br>Schedules</th>"
          	.Write "<th ALIGN=""right""><font size=""2"" color = White>Percent<br>On-Time</th>"
          	.Write "<th ALIGN=""right""><font size=""2"" color = White>Total Late<br>Schedules</th>"
          	.Write "<th ALIGN=""right""><font size=""2"" color = White>Percent<br>Late</th>"
			.Write "</tr>"
		For intCount = 0 to Ubound(vntArray,2)
			.Write "<tr" & vntColornow & ">"
			if vntArray(0,intCount) = "" or vntArray(1,intCount) = "" then  'Subtotal
				.Write "<td ALIGN=""left""><font size=""2"" color=blue><strong>" & vntArray(0,intCount) & "&nbsp;</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(1,intCount) & "&nbsp;</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(2,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(3,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(4,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(5,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"" color=blue><strong>" & vntArray(6,intCount) & "</td>"
      		else
				.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(0,intCount) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(1,intCount) & "&nbsp;</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(2,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(3,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(4,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(5,intCount) & "</td>"
      			.Write "<td ALIGN=""right""><font size=""2"">" & vntArray(6,intCount) & "</td>"
      		end if
   			.Write "</tr>"
  			if vntColorNow= srow1color then
				vntColorNow = srow2color
			else
				vntColorNow = srow1color
			end if
   		next
   		Response.Write "</table>"
   		blnStart = false
   		blnSecondTime = true
   		SetPaging()
	end with
end Function

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

End Function

Function PaintSessionExpired()
	Response.Write "<br><strong><font size=6 color=red>Sorry...</font></strong><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;Your web session expired.<br><br><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;Please click on the " & """" & "Return Button" & """" & "<BR>"
	Response.Write "to go back to the Search Criteria Screen.<br>"
	if Session("AdminUser") = "true" then
		Response.Write "Error Number: " & vntErrorNumber & "<br>"
		Response.Write "Error Desc: " & vntErrorDesc & "<br>"
	end if
End Function

Function PaintExcelNoResults()
	'With objText
		ws.Cells(1, 1) = "Sorry..."
		ws.Cells(2, 1) = "The search criteria you entered did"
		ws.Cells(3, 1) = "not produce any results."
		ws.Cells(4, 1) = "Please close Excel "
		ws.Cells(5, 1) = "and try again"
	'end with
end function

Function SetPaging()
dim vntJumpCnt
if vntCount > 100 then
	vntPageCount = vntCount / 100
	vntPageCount = int(vntPageCount)
	vntLeftOver = vntCount mod 100
	if vntLeftOver <> 0 then
		vntPageCount = vntPageCount + 1
	end if
else
	vntPageCount = 1
end if
'if vntRecsleft > 50 then
	Response.Write "<center>"
	Response.Write "<table border=""0"" cellpadding=""3"" cellspacing=""0"" width=""100%"">"
	Response.Write "<tr>"
	'Response.Write "<td align=center>"
	if vntRecsLeft > 100 then
	    'Response.Write vntPage
		if vntPage > 1 then
			Response.Write "<td width=50% align=right><input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Previous""></td>"
			blnPrev = true
		end if
		if blnPrev then
			Response.Write "<td width=50% align=left colspan=2><input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Next""></td>"
		else
			Response.Write "<td colspan=2 align=center><input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Next""></td>"
		end if
	else
		if vntPage > 1 then
			Response.Write "<td colspan=2 align=center><input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Previous""></td>"
		else
			Response.Write "<td colspan=2 align=center></td>"
		end if
	end if
		Response.Write "</tr>"
		Response.Write "<tr>"
		if vntNetscape and cint(vntPage) > 1 and cint(vntPage) <> cint(vntPageCount) then
			Response.Write "<td colspan=2 align=right><font size=1><strong>Page " & vntPage & " of " & vntPageCount & "</strong></font></td>" & vbcrlf
	    else
			Response.Write "<td colspan=2 align=center><font size=1><strong>Page " & vntPage & " of " & vntPageCount & "</strong></font></td>" & vbcrlf
		end if
		if vntRecsLeft > 100 or vntPageCount > 1  then
			Response.Write "<td width=5% align=right nowrap>"
			if not blnSecondTime then
				Response.Write "<INPUT type=submit name=""SUBMIT"" value=""Jump To""> "
				Response.Write "<SELECT id=""cboJump"" name=""cboJump"">"
				for vntJumpCnt = 1 to vntPageCount
					if cstr(vntJumpCnt) = cstr(vntPage) then
						Response.Write "<OPTION value=" & vntJumpCnt & " selected>" & vntJumpCnt & "</option>"
					else
						Response.Write "<OPTION value=" & vntJumpCnt & ">" & vntJumpCnt & "</option>"
					end if
				next
				Response.Write "</select>"
			end if
			Response.Write "</td>"
		end if
	Response.Write "</tr></table></center>"
	if not blnStart then
		vntPage = vntPage + 1
		Response.Write "<INPUT type=""hidden"" id=""RecCount"" name=""RecCount"" value=" & """" & vntRecsLeft & """" & ">"
		Response.Write "<INPUT type=""hidden"" id=""Page"" name=""Page"" value=" & """" & vntPage & """" & ">"
	end if

end function

Function CloseTags()
	Response.Write "</form>"
	Response.Write "</html>"
end function

Function WriteToExcelCell(row, rowtype, hdrStr, CommaSepStr)
    dim arrParam, arrHdr, col
	arrParam = Split(CommaSepStr, ",")
	arrHdr = Split(Ucase(hdrStr), ",")
	For col = 0 to Ubound(arrParam)
		if Ubound(arrParam) = Ubound(arrHdr) then
			if instr(arrHdr(col),"QTY") > 0 or instr(arrHdr(col),"AMT") > 0 or _
				instr(arrHdr(col),"AMOUNT") > 0 or instr(arrHdr(col),"TOTAL") > 0 or _
				instr(arrHdr(col),"PERCENT") > 0 or instr(arrHdr(col),"ON-TIME") > 0 or _
				instr(arrHdr(col),"VARIANCE") > 0 then
				' no text format - numeric field
			else
				ws.Cells(row, col+1).Format.Number = 49
			end if
		end if
		if rowtype = "hdr" then
			ws.Cells(row, col+1).Style = hdrstyle
		elseif rowtype = "tot" then
			ws.Cells(row, col+1).Style = totstyle
		end if
		ws.Cells(row, col+1).Format.font.size = 8
		ws.Cells(row, col+1).Value = arrParam(col)
	next
End Function

Function AutoFitColumnsWidth(max_row, max_col)
	ws.Cells.Range(1,1,max_row,max_col).AutoFitwidth
End Function

function CreateFile()
	Const ForWriting = 2
	dim objExport
	dim vntreturn
	CleanupExcel()
	set objExport = server.CreateObject ("DSCD.clsUser")
	vntReturn = objExport.GetExcelSeq (vntExcelSeq, vntErrorNumber, vntErrorDesc)
	set objExport = nothing
	If Err.number <> 0 then
		objError = Err.number
		errDesc = Err.description
		errWhere = " In function CreateFile Create Object-For Excel"
		exit function
	end if

	Set xlw = Server.CreateObject("Softartisans.ExcelWriter")
	'Set xlw = Server.CreateObject("SoftArtisans.OfficeWriter.ExcelWriter")
	Set ws = xlw.Worksheets(1)
	Set hdrstyle = xlw.CreateStyle
    hdrstyle.Font.Bold = True
    'hdrstyle.Font.Size = 8

	Set totstyle = xlw.CreateStyle
    totstyle.Font.Bold = True
    totstyle.HorizontalAlignment = sahaRight

	Set dtlstyle = xlw.CreateStyle
    dtlstyle.Font.Size = 8

	'vntFileName = vntExcelSeq & ".csv"
	vntFileName = vntExcelSeq & ".xls"
	vntPath = Server.MapPath("export\") & "\"
	'set objFso = Server.CreateObject("Scripting.FileSystemObject")
	'set objText = objFso.OpenTextFile(vntPath & vntFileName,ForWriting, True)'"C:\InetPub\wwwroot\gimn\export\"
end function

Function CloseFile()
	'xlw.Save vntPath & vntFileName, saOpenInExcel
	'objText.close
	xlw.Save vntFileName, saOpenInExcel
	set objText = nothing
	set objFso = nothing
	Set xlw = nothing
	Response.end
end function

Function CleanupExcel()
dim vntFullPath
dim objFileSystem
dim objFolder
dim vntTemp
dim vntarray
dim intCount
dim objFile
vntPath = Server.MapPath("export\") & "\"
vntFullPath = Server.MapPath("export\") & "\"

Set objFileSystem = Server.CreateObject("Scripting.FileSystemObject")
Set objFolder = objFileSystem.GetFolder(vntPath)'"C:\InetPub\wwwroot\gimn\export"
For Each objFile in objFolder.Files
	if cdate(formatdatetime(objFile.datelastmodified, 2)) < cdate(formatdatetime(date, 2)) then
		vntTemp = vntTemp & objFile.Name & ","
	end if
next

Const ForWriting = 2

if vntTemp <> "" then
	vntTemp = left(vntTemp, len(vntTemp) - 1)
	vntArray = split(vntTemp,",")

	for intCount = 0 to Ubound(vntArray)
		objFileSystem.DeleteFile vntFullPath & vntArray(intCount),false
	next
end if
set objFolder = nothing
set objFileSystem = nothing
end Function

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
'**********************************************************************************************************
'************************** DRIVER FUNCTIONS BASED UPON CATEGORY ******************************************
'**********************************************************************************************************

GenHtmlHead()
GenNavButtons()
Select Case vntQSCat
	case "3", "4","29"
		GetConfNonConf()
		if vntExport = 1 then
			CreateFile()
			if isnull(vntArray) then
				PaintExcelNoResults()
			else
				PaintExcelConfNonConf()
			end if
			CloseFile()
		else
			if isnull(vntArray) then
				PaintNoResults()
			else
				PaintConNonResults()
			end if
		end if
	Case "5", "6"
		GetPstDueOpen()
		if vntExport = 1 then
			CreateFile()
			if isnull(vntArray) then
				PaintExcelNoResults()
			else
				PaintExcelPstDueOpen()
			end if
			CloseFile()
		else
			if isnull(vntArray) then
				PaintNoResults()
			else
				PaintPDueOpenResults()
			end if
		end if
	Case "7"
		GetLeadTime()
		if vntExport = 1 then
			CreateFile()
			if isnull(vntArray) then
				PaintExcelNoResults()
			else
				PaintExcelLead()
			end if
			CloseFile()
		else
			if isnull(vntArray) then
				PaintNoResults()
			else
				PaintLeadResults()
			end if
		end if
	Case "8"
		GetOrgYTD()
		if vntExport = 1 then
			CreateFile()
			if isNull(vntArray) then
				PaintExcelNoResults()
			else
				PaintExcelOrgYTD()
			end if
			CloseFile()
		else
			if isNull(vntArray) then
				PaintNoResults()
			else
				PaintOrgYTDResults()
			end if
		end if
	Case "11"
		GetCustomerList()
		if vntExport = 1 then
			CreateFile()
			if isNull(vntArray) then
				PaintExcelNoResults()
			else
				PaintExcelCustList()
			end if
			CloseFile()
		else
			if isNull(vntArray) then
				PaintNoResults()
			else
				PaintCustomerList()
			end if
		end if
	Case "12"
		GetWWList()
		if vntExport = 1 then
			CreateFile()
			if isNull(vntArray) then
				PaintExcelNoResults()
			else
				PaintExcelWWList()
			end if
			CloseFile()
		else
			if isNull(vntArray) then
				PaintNoResults()
			else
				PaintWWList()
			end if
		end if
	case "14"
		GetShpFcltyList()
		if vntExport = 1 then
			CreateFile()
			if isNull(vntArray) then
				PaintExcelNoResults()
			else
				PaintExcelShpFcltyList()
			end if
			CloseFile()
		else
			if isNull(vntArray) then
				PaintNoResults()
			else
				PaintShpFcltyResults()
			end if
		end if
	Case Else
		getgeneral()
		if vntExport = 1 then
			CreateFile()
			if isnull(vntArray) then
				PaintExcelNoResults()
			else
				PaintExcelGeneral()
			end if
			CloseFile()
		else
			if isnull(vntArray) then
				PaintNoResults()
			else
				PaintGeneralType()
			end if
		end if
End Select

GenNavButtons()
PaintCriteria()
if Session("AdminUser") = "true" then
	Response.Write "Sql: " & vntSql & "<br>"
end if
CloseTags()


%>

<!--#include file=include/errHandler.inc-->
<SCRIPT LANGUAGE=javascript>
<!--
if (<%=vntExport%> == 1) {
	if (<%=vntNetscape%> == 1) {
	var myBars = 'directories=no,location=no,menubar=no'
	var myOptions = 'width=400,height=200'
	var myFeatures = myBars + ',' + myOptions;
		window.open ("<%=strServerUrl%><%=appPath%>transfer.asp?export=true&file=<%=vntFileName%>",'',myFeatures)
		//window.open ("<%=strServerUrl%><%=appPath%>transfer.asp?export=true&file=<%=vntFileName%>")
	}
	else {
		window.open ("<%=strServerUrl%><%=appPath%>export/<%=vntFileName%>")
	}
	history.back()
	}
//-->
</SCRIPT>