<%@ Language=VBScript %>
<% Option Explicit %>
<% Response.Buffer = True %>
<% Session.Timeout = 240
   Response.Expires = 0 %>
<!--#include file=include/colors.inc-->
<!--#include file=include/security.inc-->
<!--#include file=include/constants.inc-->
<%
'Declare Variables
Dim objError
Dim errWhere
Dim errDesc
Dim objList
Dim vntArray
Dim vntOpenShipInd
Dim vntCategoryNbr
Dim vntOrgKeyId
Dim vntOrdNbr
Dim vntItemNbr
Dim vntSchedId
Dim vntSql
Dim vntErrorNumber
Dim vntErrorDesc
Dim vntTopInd
Dim vntFldCnt

'Initial Variables
objError = 0
errWhere = ""
errDesc = ""

'Uncomment when security matters
'If Not MrSecurity Then
'	Response.Redirect Application("Login")
'End If
vntCategoryNbr = Request.QueryString("Cat")
vntOrgKeyId = Request.QueryString("Org")
vntOrdNbr = Request.QueryString("Ord")
vntItemNbr = Request.QueryString("OrdI")
vntSchedId = Request.QueryString("Shp")


Function GenHtmlHead()
    Response.Write "<html>"
    Response.Write "<head>"
    Response.Write "<meta NAME=""GENERATOR"" Content=""Microsoft Visual Interdev 1.0"">"
    Response.Write "<title>" & Application("appAbrv") & " - " & "Schedule Detail</Title>"
    Response.Write "</head>"
%>

    <!--#include file=include/NavBegin.inc-->
<%
    Response.Write "<td width=""20%"">&nbsp;</td>"
    Response.Write "<td width=""20%"">&nbsp;</td>"
    Response.Write "<td width=""20%"">&nbsp;</td>"
    Response.Write "<td width=""20%"">&nbsp;</td>"
    Response.Write "<td width=""5%"" align=""center"">"
    Response.Write "<a href=" & strServerUrl & appHelp & Application("Help") & " target =""Help Window"">Help</a>"
    Response.Write "</td>"
%>
    <!--#include file=include/NavMiddle.inc-->
<%
    Response.Write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Schedule Detail</b></Font></td>"
%>
    <!--#include file=include/NavEnd.inc-->
<%
    Response.Write "<br>"
'    Response.Write "<br>"
end function

Function GenNavButtons()
	If vntTopInd = "T" Then
		Response.Write "<form name=""frmDetail"" ACTION=""Detail.asp"" method=""POST"">"
	End If
	Response.Write "<table width=""100%"" border=""0"">" & vbcrlf
	Response.Write "<tr>" & vbcrlf
	Response.Write "    <td ALIGN=""left"" width=""10%"">" & vbcrlf
	Response.Write "    <input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Close""onclick=""window.close();""></td>" & vbcrlf
	Response.Write "    <td ALIGN=""right"" width=""40%"">" & vbcrlf
	Response.Write "    </td>" & vbcrlf
	Response.Write "</tr>" & vbcrlf
	Response.Write "</TABLE>"
End Function

Function GetList()
	'vntCategoryNbr = "5"
	'vntOrgKeyId = 442
	'vntOrdNbr = "000120090"
	'vntItemNbr = "004"
	'vntSchedId = "001"
	If vntCategoryNbr = "3" Or vntCategoryNbr = "4" Then
		vntOpenShipInd = "S"
	Else
		vntOpenShipInd = "O"
	End If
	set objList = server.CreateObject ("DSCD.clsDetail")
	vntArray =objList.ListDetail(vntOpenShipInd,vntOrgKeyId,vntOrdNbr,vntItemNbr,vntSchedId,vntFldCnt, _
									vntErrorNumber, vntErrorDesc, vntSql)
	set objList = nothing
end function

Function PaintIt()
	Dim vntMfgParentLvl
	Dim vntMfgParentOrg
	Dim vntMfgLvl
	Dim vntMfgOrg
	Dim vntLevel
	Dim vntOrgHierarchy
	Dim vntCompDlvry

	vntLevel = vntArray(vntFldCnt+2,0) - 2
	vntOrgHierarchy = vntArray(vntFldCnt+3,0)
	vntMfgLvl = vntArray(vntFldCnt+4,0)
	IF vntMfgLvl <> "" Then
		vntMfgLvl = "Mfg " & vntMfgLvl & ":"
		vntMfgOrg = vntArray(vntFldCnt+5,0) & " - " & vntArray(vntFldCnt+6,0)
	End If
	vntMfgParentLvl = vntArray(vntFldCnt+7,0)
	IF vntMfgParentLvl <> "" Then
		vntMfgParentLvl = "Mfg " & vntMfgParentLvl & ":"
		vntMfgParentOrg = vntArray(vntFldCnt+8,0) & " - " & vntArray(vntFldCnt+9,0)
	End If

    With Response
		.Write sHR
		.Write "<TABLE WIDTH=100% BORDER=0 CELLSPACING=0 CELLPADDING=2 align=center>"
		.Write "<TR>"
		.Write "<TD align=left colspan=8" & sTDColor & ">" & sDisStrngFont2 & "Customer Information" & sEndStrgFont2 & "</TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Sold To:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD colspan=3 align=left><font size=2>" & vntarray(68,0) & "&nbsp;&nbsp;&nbsp;&nbsp;" & vntarray(vntFldCnt+10,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Worldwide Nbr:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(35,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Window Early:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(19,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Ship To:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD colspan=3 align=left><font size=2>" & vntarray(1,0) & "&nbsp;&nbsp;&nbsp;&nbsp;" & vntarray(vntFldCnt,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Part Nbr:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(37,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Window Late:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(20,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Ind Busns:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD colspan=7 align=left><font size=2>" & vntarray(53,0) & "&nbsp;&nbsp;&nbsp;&nbsp;" & vntarray(vntFldCnt+1,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<tr><td colspan=8>" & sHR & "</td></tr>"
		.Write "<TR>"
		.Write "<TD colspan=8" & sTDColor & ">" & sDisStrngFont2 & "Order Information" & sEndStrgFont2 & "</TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Order Nbr:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left width=""10%""><font size=2>" & vntOrdNbr & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Bill Amt(TBR/USD):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=right><font size=2>" & vntarray(46,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Schl Mthd:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(31,0) & "</font></TD>"
		.Write "<TD align=left>" & sDisStrngFont & "Force Bill:&nbsp;&nbsp;&nbsp;&nbsp;" & sEndStrgFont & "<font size=2>" & vntarray(47,0) & "</font></TD>"
		.Write "<TD align=left>" & sDisStrngFont & "Nbr Exp:&nbsp;&nbsp;" & sEndStrgFont & "<font size=2>" & vntarray(39,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Order Item Nbr:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntItemNbr & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Bill Amt(USD):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=right><font size=2>" & vntarray(11,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "PO Nbr:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(30,0) & "</font></TD>"
		.Write "<TD align=left>" & sDisStrngFont & "Order Type:&nbsp;&nbsp;&nbsp;&nbsp;" & sEndStrgFont & "<font size=2>" & vntarray(27,0) & "</font></TD>"
		If vntarray(71,0) = "1" Then
			vntCompDlvry = "Yes"
		ElseIf vntarray(71,0) = "0" Then
			vntCompDlvry = "No"
		Else
			vntCompDlvry = "&nbsp;"
		End if
		.Write "<TD align=left>" & sDisStrngFont & "Comp Dlvry:&nbsp;&nbsp;" & sEndStrgFont & "<font size=2>" & vntCompDlvry & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Shipment Id:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntSchedId & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Bill Amt(" & vntarray(9,0) & "):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=right><font size=2>" & vntarray(10,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "PO Date:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(29,0) & "</font></TD>"
		.Write "<TD align=left>" & sDisStrngFont & "Cstmr Type:&nbsp;&nbsp;&nbsp;&nbsp;" & sEndStrgFont & "<font size=2>" & vntarray(48,0) & "</font></TD>"
		.Write "<TD></TD>"
		.Write "</TR>"
		.Write "<tr><td colspan=8>" & sHR & "</td></tr>"
		.Write "<TR>"
		.Write "<TD colspan=7 align=left" & sTDColor & ">" & sDisStrngFont2 & "Miscellaneous Codes" & sEndStrgFont2 & "</TD>"
		.Write "<TD" & sTDColor & ">" & sDisStrngFont2 & "Manufacturing Info" & sEndStrgFont2 & "</TD>"
		.Write "</TR>"
		.Write "<TR>"
		If isArray(vntOrgHierarchy) Then
			.Write "<TD align=right>" & sDisStrngFont & vntOrgHierarchy(0,vntLevel) & " : " & sEndStrgFont & "</TD>"
			.Write "<TD align=left><font size=2>" & vntOrgHierarchy(1,vntLevel) & " - " & vntOrgHierarchy(2,vntLevel) &"</font></TD>"
		Else
			.Write "<TD align=right>" & sDisStrngFont & "Org Hierarchy Not Found" & sEndStrgFont & "</TD>"
			.Write "<TD align=left><font size=2>&nbsp;&nbsp;</font></TD>"
		End if
		.Write "<TD align=right>" & sDisStrngFont & "Invy Bldg/Plant:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(55,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Ship Bldg/Plant:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(23,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Mfg Campus:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(51,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		If vntLevel - 1 >= 0 Then
			.Write "<TD align=right>" & sDisStrngFont & vntOrgHierarchy(0,vntLevel - 1) & " : " & sEndStrgFont & "</TD>"
			.Write "<TD align=left><font size=2>" & vntOrgHierarchy(1,vntLevel - 1) & " - " & vntOrgHierarchy(2,vntLevel - 1) &"</font></TD>"
		Else
			.Write "<TD align=right>" & sDisStrngFont & "&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
			.Write "<TD align=left><font size=2>&nbsp;&nbsp;</font></TD>"
		End If
		.Write "<TD align=right>" & sDisStrngFont & "Invy Loc:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(32,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Storage Loc:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(24,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Mfg Bldg:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(52,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		If vntLevel - 2 >= 0 Then
			.Write "<TD align=right>" & sDisStrngFont & vntOrgHierarchy(0,vntLevel - 2) & " : " & sEndStrgFont & "</TD>"
			.Write "<TD align=left><font size=2>" & vntOrgHierarchy(1,vntLevel - 2) & " - " & vntOrgHierarchy(2,vntLevel - 2) &"</font></TD>"
		Else
			.Write "<TD align=right>" & sDisStrngFont & "&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
			.Write "<TD align=left><font size=2>&nbsp;&nbsp;</font></TD>"
		End If
		.Write "<TD align=right>" & sDisStrngFont & "Ind Code:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(49,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Actual Physical Ship Bldg:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(22,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & vntMfgParentLvl & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntMfgParentOrg & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		If vntLevel - 3 >= 0 Then
			.Write "<TD align=right>" & sDisStrngFont & vntOrgHierarchy(0,vntLevel - 3) & " : " & sEndStrgFont & "</TD>"
			.Write "<TD align=left><font size=2>" & vntOrgHierarchy(1,vntLevel - 3) & " - " & vntOrgHierarchy(2,vntLevel - 3) &"</font></TD>"
		Else
			.Write "<TD align=right>" & sDisStrngFont & "&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
			.Write "<TD align=left><font size=2>&nbsp;&nbsp;</font></TD>"
		End If
		.Write "<TD align=right>" & sDisStrngFont & "Profit Ctr:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(54,0) & "</font></TD>"
		'.Write "<TD align=right>" & sDisStrngFont & "Invy Loc:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		'.Write "<TD align=left><font size=2>" & vntarray(21,0) & "</font></TD>"
		.Write "<TD align=right>" & "&nbsp;&nbsp;" & "</TD>"
		.Write "<TD align=left><font size=2>" & "&nbsp;&nbsp;" & "</font></TD>"
		.Write "<TD align=Right>" & sDisStrngFont & vntMfgLvl & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntMfgOrg & "</font></TD>"
		.Write "</TR>"
		If vntLevel - 4 >= 0 Then
			.Write "<TR>"
			.Write "<TD align=right>" & sDisStrngFont & vntOrgHierarchy(0,vntLevel - 4) & " : " & sEndStrgFont & "</TD>"
			.Write "<TD align=left colspan=7><font size=2>" & vntOrgHierarchy(1,vntLevel - 4) & " - " & vntOrgHierarchy(2,vntLevel - 4) &"</font></TD>"
			.Write "</TR>"
		End If
		If vntLevel - 5 >= 0 Then
			.Write "<TR>"
			.Write "<TD align=right>" & sDisStrngFont & vntOrgHierarchy(0,vntLevel - 5) & " : " & sEndStrgFont & "</TD>"
			.Write "<TD align=left colspan=7><font size=2>" & vntOrgHierarchy(1,vntLevel - 5) & " - " & vntOrgHierarchy(2,vntLevel - 5) &"</font></TD>"
			.Write "</TR>"
		End If
		If vntLevel - 6 >= 0 Then
			.Write "<TR>"
			.Write "<TD align=right>" & sDisStrngFont & vntOrgHierarchy(0,vntLevel - 6) & " : " & sEndStrgFont & "</TD>"
			.Write "<TD align=left colspan=7><font size=2>" & vntOrgHierarchy(1,vntLevel - 6) & " - " & vntOrgHierarchy(2,vntLevel - 6) &"</font></TD>"
			.Write "</TR>"
		End If
		If vntLevel - 7 >= 0 Then
			.Write "<TR>"
			.Write "<TD align=right>" & sDisStrngFont & vntOrgHierarchy(0,vntLevel - 7) & " : " & sEndStrgFont & "</TD>"
			.Write "<TD align=left colspan=7><font size=2>" & vntOrgHierarchy(1,vntLevel - 7) & " - " & vntOrgHierarchy(2,vntLevel - 7) &"</font></TD>"
			.Write "</TR>"
		End If
		If vntLevel - 8 >= 0 Then
			.Write "<TR>"
			.Write "<TD align=right>" & sDisStrngFont & vntOrgHierarchy(0,vntLevel - 8) & " : " & sEndStrgFont & "</TD>"
			.Write "<TD align=left colspan=7><font size=2>" & vntOrgHierarchy(1,vntLevel - 8) & " - " & vntOrgHierarchy(2,vntLevel - 8) &"</font></TD>"
			.Write "</TR>"
		End If
		.Write "<tr><td colspan=8>" & sHR & "</td></tr>"
		.Write "<TR>"
		.Write "<TD colspan=5 align=left" & sTDColor & ">" & sDisStrngFont2 & "Part Information" & sEndStrgFont2 & "</TD>"
		.Write "<TD colspan=3 align=left" & sTDColor & ">" & sDisStrngFont2 & "Quantities" & sEndStrgFont2 & "</TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "TE Corp Part Nbr:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(0,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Sbmtd Part Nbr:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(72,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Item:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=right><font size=2>" & vntarray(3,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Available (RL5):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=right><font size=2>" & vntarray(5,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Gbl Prod Line:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(57,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Prod Code:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(34,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Released (RLR):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=right><font size=2>" & vntarray(7,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "On Credit (RL9):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=right><font size=2>" & vntarray(6,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Make Stock:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(33,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Comp Busns:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(50,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Reserved (RL1):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=right><font size=2>" &vntarray(4,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Shipped:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=right><font size=2>" & vntarray(8,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Mrp Group:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(70,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Controller:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(2,0) & "</font></TD>"
		.Write "<tr><td colspan=8>" & sHR & "</td></tr>"
		.Write "<TR>"
		.Write "<TD colspan=8 align=left" & sTDColor & ">" & sDisStrngFont2 & "Dates " & sEndStrgFont2 & sDisStrngFont & "(YYYY-MM-DD)" & sEndStrgFont & "</TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Received:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(26,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Cstmr Rqst:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(12,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "SAP Cstmr Rqst On-Dock:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(77,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Cstmr Credit Hold On:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(75,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Registered:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(28,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Cstmr Rqst Xpdt:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(38,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "SAP Schedule On-Dock:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(78,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Cstmr Credit Hold Off:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(76,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Order Booked:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(25,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Earliest Xpdt:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(42,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Non-Tyco Ctrld Dlvry Block On:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(44,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Schedule Credit Hold On:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(67,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Item Booked:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(69,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Current Xpdt:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(41,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Non-Tyco Ctrld Dlvry Block Off:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(45,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Schedule Credit Hold Off:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(43,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Schedule:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(13,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "TE On-Dock:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(15,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Tyco Ctrld Dlvry Block On:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(59,0) & "</font></TD>"
		.Write "<TD align=right></TD>"
		.Write "<TD align=left></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Release:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(14,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Shipped:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(18,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Tyco Ctrld Dlvry Block Off:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(60,0) & "</font></TD>"
		.Write "<TD align=right></TD>"
		.Write "<TD align=left></TD>"
		.Write "</TR>"
		.Write "<tr><td colspan=8>" & sHR & "</td></tr>"
		.Write "<TR>"
		.Write "<TD colspan=8 align=left" & sTDColor & ">" & sDisStrngFont2 & "Miscellaneous Fields" & sEndStrgFont2 & "</TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Non-Tyco Ctrld Dlvry Block:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(61,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Pick/Pack Time (Days):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(63,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Transport Lead-Time (Days):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(65,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "TMS Transit Days:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(21,0) & "</font></TD>"
		.Write "</TR>"
		.Write "<TR>"
		.Write "<TD align=right>" & sDisStrngFont & "Tyco Ctrld Dlvry Block:&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(62,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Loading Time (Days):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(64,0) & "</font></TD>"
		.Write "<TD align=right>" & sDisStrngFont & "Transit Time (Days):&nbsp;&nbsp;" & sEndStrgFont & "</TD>"
		.Write "<TD align=left><font size=2>" & vntarray(66,0) & "</font></TD>"
		.Write "<TD align=right></TD>"
		.Write "<TD align=left></TD>"
		.Write "</TR>"
		.Write "</TABLE>"
		.Write sHR
	end with
end function

Function DisplayError()

	If errWhere = vbNullString Then errWhere = "the application"

	Response.Write "<font size=""2""><table border=""0"">"
	Response.Write "<tr bgcolor=""#EEEEEE"">"
	Response.Write "<td>"
	Response.Write "There has been an error in " & errWhere & ":<br>Number:&nbsp;&nbsp;" & vntErrorNumber & "<br>Description:&nbsp;&nbsp;" & vntErrorDesc
	Response.Write "</td></tr>"
	Response.Write "</table></font>"
End Function

'Call Functions and/or subs
GenHtmlHead()
vntTopInd = "T"
GenNavButtons()
GetList()
if isArray(vntArray) then
	PaintIt()
else
	DisplayError()
end if
vntTopInd = ""
GenNavButtons()
%>

<!--#include file=include/errHandler.inc-->
