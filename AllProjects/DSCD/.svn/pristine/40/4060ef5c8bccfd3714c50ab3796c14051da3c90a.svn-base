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
	'blnDebug = True

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

    ' get row restriction
    if Session("AdminUser") <> "true" Then
		Dim blnRetCode, objTop20Cust2, strBusiUnitRS
		if Session("BusinessUnitRS") = vbNullString Then
			Set objTop20Cust2 = Server.CreateObject("DSCD.clsTop20Cust")
			blnRetCode = objTop20Cust2.GetRowRestrictions(lsAmpID,strBusiUnitRS,vntErrorNumber,vntErrorDesc)
			Set objTop20Cust2 = Nothing
			if not blnRetCode or vntErrorNumber <> 0 then
				ReportError vntErrorNumber, vntErrorDesc, "getting row business unit row restrictions"
			end if
			Session("BusinessUnitRS") = replace(strBusiUnitRS,"~","'")
		end if
	end if
	
	Dim inx, inxRow, inxCol

	'indexes for array from objTop20Cust.List
	Dim inxOrgKey, inxOrg, inxCustID, inxRegionID, inxOrgDesc, inxCustDesc, inxCustType, inxUser, inxTS
		inxOrgKey	= 0
		inxOrg		= 1
        inxCustID   = 2
        inxRegionID = 3
		inxOrgDesc	= 4
		inxCustDesc	= 5
		inxCustType	= 6
		inxUser		= 7
		inxTS		= 8

	'indexes for radio values
	Dim xBusiUnit, xOrgKey, xCustID, xRegionID, xCustType, xCustOrg
        xBusiUnit = 0
		xCustType = 1
        xRegionID = 2		        
		xOrgKey	  = 3
        xCustID   = 4
        xCustOrg  = 5

	Dim vntCustomerOrg, vntBldgNbr, vntCustAccntNbr, vntHolidayDt, vntCustName
	Dim vntCustomerOrgKeyID, vntCustomerOrgDesc, arrTemp, vntBusiUnit, strUserBusiUnit, vntCustType, vntRegion
		vntCustomerOrgKeyID	= vbNullString
		vntCustomerOrgDesc		= vbNullString
		vntCustType				= vbNullString         
		if Session("BusinessUnit") <> vbNullString then
			vntBusiUnit = Session("BusinessUnit")
		else
			vntBusiUnit = vbNullString
		end if
		vntCustomerOrg	= vbNullString
		vntCustAccntNbr	= Trim(Request.Form("txtCustAccntNbr"))

		If Trim(Request.Form("selCustomerOrg")) <> vbNullString Then
			arrTemp = Split(Trim(Request.Form("selCustomerOrg")), "|")
			vntCustomerOrgKeyID	= arrTemp(0)
			vntCustomerOrg		= arrTemp(1)
		End If
		
		If Trim(Request.Form("selBusiUnit")) <> vbNullString Then
			arrTemp = Split(Trim(Request.Form("selBusiUnit")), "|")
			vntBusiUnit = arrTemp(0)
		End If
		
		If Trim(Request.Form("selCustType")) <> vbNullString Then
			arrTemp = Split(Trim(Request.Form("selCustType")), "|")
			vntCustType = arrTemp(0)
		End If
		
		If Trim(Request.Form("selRegion")) <> vbNullString Then
			arrTemp = Split(Trim(Request.Form("selRegion")), "|")
			vntRegion = arrTemp(0)
		End If
		IF vntRegion = vbNullString Then vntRegion = "0002"
		
		if vntCustType = "WW" Then 
			'vntRegion = "0001"
			vntCustomerOrgKeyID = 1
			vntCustomerOrg = "0001"
		else
		   IF vntRegion = "0001" Then vntRegion = "0002"		   
		end if

	Dim vntKeyBldgNbr, vntKeyLocationCde, vntKeyHolidayDt
		vntKeyBldgNbr		= vbNullString
		vntKeyLocationCde	= vbNullString
		vntKeyHolidayDt		= vbNullString


	Dim strBtnReturn, strBtnAdd, strBtnUpdate, strBtnDelete, strBtnSubmit, strBtnCancel, strBtnContinue, strBtnBack, strBtnValid
		strBtnReturn	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Return"">"
		strBtnAdd		= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Add"">"
		strBtnUpdate	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Update"" onclick=""return(validate_selection('Update', false));"">"
		strBtnDelete	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Delete"" onclick=""return(validate_selection('Delete', true));"">"
		strBtnSubmit	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Submit"" onclick=""return(validate_entries());"">"
		strBtnValid		= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Validate"" onclick=""return(validate_entries());"">"
		'strBtnCancel	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Cancel"">"
		strBtnCancel	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Return "">"
		strBtnContinue	= "<input type=""submit"" name=""smtCommand"" id=""smtCommand"" value=""Continue"">"
		strBtnBack		= "<input type=""button"" name=""btnBack"" id=""btnBack"" value=""Back"" onclick=""history.back();"">"

	Dim vntCommand, vntMode, strMsg, vntConf, vntCN, vntConfResp
		'vntCommand	= Ucase(Trim(Request.Form("smtCommand")))
		vntCommand	= Ucase(Request.Form("smtCommand"))
		vntMode		= Ucase(Trim(Request.Form("hdnMode")))
		vntConf		= Ucase(Trim(Request.Form("hdnConf")))
		vntConfResp = Ucase(Trim(Request.Form("hdnConfResp")))
		If vntMode = vbNullString Then vntMode = "LIST"
		strMsg = vbNullString
		vntCN = vbNullString
		vntConfResp = Ucase(Trim(Request.Form("hdnConfResp")))
		If vntConfResp = "YES" Then vntCommand = "INSERT"
		vntConf = "NO"

	Dim objOrgs, arrList, blnRC, objTop20Cust
	If vntCommand <> "RETURN" Then 
		Set objTop20Cust = Server.CreateObject("DSCD.clsTop20Cust")
	End If


'***********************************************************************
'*********	Main Processing
'***********************************************************************

	If Not blnError Then

		If vntCommand = "RETURN" Then
			Response.Redirect Application("Home")
			Response.End
		ElseIf vntCommand = "SUBMIT" Then
			blnRC = objTop20Cust.Validate(vntCustomerOrgKeyID, vntCustAccntNbr, vntCustType, vntBusiUnit, vntRegion, vntCustName, vntErrorNumber, vntErrorDesc)
			IF Not blnRC then
				ReportError vntErrorNumber, vntErrorDesc, "validating the record"
				vntCustName = ""				
			else
				vntCN = vntCustName
				vntMode = "ADD"
				vntConf = "YES"
			End if
			vntMode = "ADD"			
		ElseIf vntCommand = "INSERT" Then
			blnRC = objTop20Cust.Insert(vntCustomerOrgKeyID, vntCustAccntNbr, vntCustType, vntBusiUnit, vntRegion, lsAmpID, vntErrorNumber, vntErrorDesc)
			If blnRC And vntErrorNumber = 0 Then
				strMsg = "Record Added - (Cust Org:&nbsp;" & vntCustomerOrg & ") - (Cust Nbr:&nbsp;" & vntCustAccntNbr & ") - (Cust Type:&nbsp;" & vntCustType & ") - (Region:&nbsp;" & vntRegion & ")"
			Else
				ReportError vntErrorNumber, vntErrorDesc, "inserting the record"
			End If
			vntMode = "ADD"										
			vntConfResp = "NO"
		ElseIf vntCommand = "VALIDATE" Then		
			blnRC = objTop20Cust.Validate(vntCustomerOrgKeyID, vntCustAccntNbr, vntCustType, vntBusiUnit, vntRegion, vntCustName, vntErrorNumber, vntErrorDesc)
			IF Not blnRC then
				ReportError vntErrorNumber, vntErrorDesc, "validating the record"
				vntCustName = ""
			End If
			vntMode = "ADD"
		ElseIf vntCommand = "UPDATE" Then
			GetValues
			vntMode = vntCommand
		ElseIf vntCommand = "ADD" Then
			vntMode = vntCommand
		ElseIf vntCommand = "RETURN " Then
			vntMode ="LIST"			
		ElseIf vntCommand = "DELETE" Then
			GetValues
			blnRC = objTop20Cust.Delete(vntCustomerOrgKeyID, vntCustAccntNbr, vntCustType, vntBusiUnit, vntRegion, vntErrorNumber, vntErrorDesc)
			If blnRC And vntErrorNumber = 0 Then
				vntMode = "LIST"
				strMsg = "Record Deleted - (Cust Org:&nbsp;" & vntCustomerOrg & ") - (Cust Nbr:&nbsp;" & vntCustAccntNbr & ") - (Cust Type:&nbsp;" & vntCustType & ") - (Region:&nbsp;" & vntRegion & ")"
			Else
				ReportError vntErrorNumber, vntErrorDesc, "deleting the record"
			End If
		Else
			if vntMode <> "ADD" then vntMode = "LIST"
		End If
	End If


	Select Case vntMode
	Case "UPDATE", "ADD", "LIST", "VALIDATE", "INSERT":
		Dim inxOrgType, strTempOrgTypeID, arrOrgTypes, arrOrgIDs, arrOrgIDCols, arrOrgIDRows , arrBusiness, arrCustType, arrRegion
			strTempOrgTypeID = vbNullString

		if Session("AdminUser") = "true" then
			arrBusiness = objTop20Cust.ListProfitCtr(vbNullString, vntErrorNumber, vntErrorDesc)					
		else
			arrBusiness = objTop20Cust.ListProfitCtr(Session("BusinessUnitRS"), vntErrorNumber, vntErrorDesc)		
		end if

		If vntErrorNumber = 0 Then
			if vntMode = "LIST" then		
				arrList = objTop20Cust.List(vntBusiUnit, vntErrorNumber, vntErrorDesc)
				If vntErrorNumber = 0 Then
					DisplayList arrBusiness, arrList, strMsg
				Else
					ReportError vntErrorNumber, vntErrorDesc, "Retrieve List"
					DisplayError
				End If
			else

				'get orgs
 				Set objOrgs = Server.CreateObject("DSCD.clsOrgs")

				'arrOrgTypes = objOrgs.ListType(vntErrorNumber, vntErrorDesc)
				'If IsArray(arrOrgTypes) Then

					'For inxOrgType = LBound(arrOrgTypes, 2) To UBound(arrOrgTypes, 2)

						'If InStr(1, arrOrgTypes(1, inxOrgType), "COMPANY", vbTextCompare) > 0 Then
							'strTempOrgTypeID = arrOrgTypes(0, inxOrgType)
							arrList = vbNullString
							if vntRegion = "0001" then
								arrList = objOrgs.ListOrgIDs(strTempOrgTypeID, vntErrorNumber, vntErrorDesc)
							else
								arrList = objTop20Cust.ListRegOrgIDs2(vntRegion, vntErrorNumber, vntErrorDesc)
							end if
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
						'End If
					'Next
				'End If

				' define customer type
				Redim arrCustType(1,2)
				arrCustType(0,0) = "SHIP TO"
				arrCustType(1,0) = "Ship To"
				arrCustType(0,1) = "SOLD TO"
				arrCustType(1,1) = "Sold To"
				arrCustType(0,2) = "WW"
				arrCustType(1,2) = "WW"
				
				' define region
	            arrList = vbNullString
				arrList = objOrgs.ListOrgIDs("2", vntErrorNumber, vntErrorDesc)				
				If IsArray(arrList) Then		
					if vntCustType = "WW" Then 
						Redim arrRegion(1,UBound(arrList, 2)+1)				
					else
						Redim arrRegion(1,UBound(arrList, 2))
					end if
					For inxRow = LBound(arrList, 2) To UBound(arrList, 2)
						arrRegion(0, inxRow) = arrList(2, inxRow)
						arrRegion(1, inxRow) = arrList(3, inxRow)		
					Next
					if vntCustType = "WW" Then
						arrRegion(0, UBound(arrList, 2)+1) = "0001"
						arrRegion(1, UBound(arrList, 2)+1) = "0001 - Tyco Electronics"
					end if
				else
					ReportError vntErrorNumber, vntErrorDesc, "Retrieve Region Orgs"
					DisplayError				
				end if

				DisplayDetail arrOrgIDs, arrBusiness, arrCustType, arrRegion, strMsg
			end if
		Else
			ReportError vntErrorNumber, vntErrorDesc, vntErrorDesc & "Retrieve Business Units"
			DisplayError
		End If
		Set objOrgs = Nothing
	Case "ERROR":
		DisplayError
	End Select

	Set objTop20Cust = Nothing


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
			vntBusiUnit		    = arrVals(xBusiUnit)
			vntCustType         = arrVals(xCustType)
			vntRegion  		    = arrVals(xRegionID)
			vntCustomerOrgKeyID	= arrVals(xOrgKey)
			vntCustAccntNbr     = arrVals(xCustID)
			vntCustomerOrg      = arrVals(xCustOrg)
			If blnDebug Then
				RwLf "<br>vntBusiUnit = " & vntBusiUnit
				RwLf "<br>vntCustType = " & vntCustType
				RwLf "<br>vntRegion   = " & vntRegion
				RwLf "<br>vntCustomerOrgKeyID = " & vntCustomerOrgKeyID
				RwLf "<br>vntCustAccntNbr = " & vntCustAccntNbr
				RwLf "<br>vntCustOrg = " & vntCustomerOrg
			End If
		Else
			ReportError -13, "No Values Found", "GetValues"
		End If
End Function


Sub GenHTMLHead()

	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>DSCD - Focus 20 Customer Maintenance</title>"

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
	RwLf "<form name=""frmMain"" id=""frmMain"" method=""post"" action""top20custmaint.asp"">"

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
	RwLf "	<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Focus 20 Customer Maintenance</b></font></td>"
%>
<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
	RwLf "<br>"
End Sub


Sub GenHTMLFoot()
	RwLf "<input type=""hidden"" name=""hdnMode"" id=""hdnMode"" value=""" & vntMode & """>"
	RwLf "<input type=""hidden"" name=""hdnConf"" id=""hdnConf"" value=""" & vntConf & """>"
	RwLf "<input type=""hidden"" name=""hdnConfResp"" id=""hdnConfResp"" value=""" & vntConfResp & """>"	
	RwLf "<input type=""hidden"" name=""hdnCN"" id=""hdnCN"" value=""" & vntCN & """>"	
	RwLf "</form></body></html>"
End Sub


Function DisplayList(arrBusiUnits, arrArray, strMessage)

	Dim arrColHeaders

	arrColHeaders = Array("Sel", "Region", "Customer OrgID / Name", "Customer Nbr / Name", "Customer Type", "User Id", "Date Changed")

    	Dim strButtons
		strButtons = strBtnReturn & "&nbsp;&nbsp;" & strBtnAdd & "&nbsp;&nbsp;" & strBtnDelete

	GenHTMLHead

	RwLf strButtons

	RwLf "<tr>"
	RwLf "<th align=""right"" width=""25%"">"
	RwLf "<font size=""2""><strong>Business&nbsp;Units:&nbsp;&nbsp;</strong></font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	RwLf "<select name=""selBusiUnit"" id=""selBusiUnit"" onchange=""refresh_screen()"">"

	Dim inxRow, inxCol
	If IsArray(arrBusiUnits) Then
		For inxRow = LBound(arrBusiUnits, 2) To UBound(arrBusiUnits, 2)
			Rw "<option value=""" & arrBusiUnits(0, inxRow) & "|" & arrBusiUnits(1, inxRow) & """"
			If vntBusiUnit <> vbNullString and vntBusiUnit = arrBusiUnits(0, inxRow) Then Rw " SELECTED"
			RwLf ">" & arrBusiUnits(0, inxRow) & " - " & arrBusiUnits(1, inxRow) & "</option>"
		Next
	Else
		RwLf "<option value=""-1"">Error - Business Unit Could Not Be Retrieved</option>"
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
			RwLf "<td><input type=""radio"" name=""rdoSelected"" id=""rdoSelected"" value=""" & vntBusiUnit & "|" & arrArray(inxCustType, inxRow) & "|" & arrArray(inxRegionID, inxRow) & "|" & arrArray(inxOrgKey, inxRow) & "|" & arrArray(inxCustID, inxRow) & "|" & arrArray(inxOrg, inxRow) & """ onclick=""blnSelected=true;""></td>"
			For inxCol = inxRegionID To UBound(arrArray, 1)
				RwLf "<td><font size=""2"">"
				Rw arrArray(inxCol, inxRow)
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
		RwLf "<center><h2>No Focus 20 Customer Found</h2></center><br><br>"
	End If
	GenHTMLFoot

End Function


Sub DisplayDetail(arrOrgs, arrBusiUnits, arrCustType, arrRegion, strMessage)

    Dim strButtons
		strButtons = vbNullString
		If IsArray(arrBusiUnits) Then strButtons = strBtnSubmit & "&nbsp;&nbsp;"
		'If IsArray(arrBusiUnits) Then strButtons = strBtnValid & "&nbsp;&nbsp;" & strBtnSubmit & "&nbsp;&nbsp;"
		strButtons = strButtons & strBtnCancel

	If strMessage = vbNullString Then
		strMessage = "<font size=""4"" " & sTableHeadFont & ">" & Left(vntMode, 1) & LCase(Mid(vntMode, 2)) & " Focus 20 Customers</font>"
	Else
		strMessage = "<font size=""4"" " & sTableHeadFont & ">" & Left(vntMode, 1) & LCase(Mid(vntMode, 2)) & " Focus 20 Customers</font><font size=""2"" " & sTableHeadFont & ">&nbsp;&nbsp;&nbsp;&nbsp;--&nbsp;&nbsp;" & strMessage & "</font>"
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
	RwLf "<font size=""2"">Business&nbsp;Units:&nbsp;&nbsp;</font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	RwLf "<select name=""selBusiUnit"" id=""selBusiUnit"">"

	Dim inxRow, inxCol
	If IsArray(arrBusiUnits) Then
		For inxRow = LBound(arrBusiUnits, 2) To UBound(arrBusiUnits, 2)
			Rw "<option value=""" & arrBusiUnits(0, inxRow) & "|" & arrBusiUnits(1, inxRow) & """"
			If vntBusiUnit <> vbNullString and vntBusiUnit = arrBusiUnits(0, inxRow) Then Rw " SELECTED"
			RwLf ">" & arrBusiUnits(0, inxRow) & " - " & arrBusiUnits(1, inxRow) & "</option>"
		Next
	Else
		RwLf "<option value=""-1"">Error - Business Units Could Not Be Retrieved</option>"
	End If
	RwLf "</select>"
	RwLf "</td>"
	RwLf "</tr>"

	RwLf "<tr>"
	RwLf "<th align=""right"" width=""25%"">"
	RwLf "<font size=""2"">Customer&nbsp;Type:&nbsp;&nbsp;</font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	RwLf "<select name=""selCustType"" id=""selCustType"" onchange=""refresh_screen()"">"

	If IsArray(arrCustType) Then
		For inxRow = LBound(arrCustType, 2) To UBound(arrCustType, 2)
			Rw "<option value=""" & arrCustType(0, inxRow) & "|" & arrCustType(1, inxRow) & """"
			If vntCustType <> vbNullString and vntCustType = arrCustType(0, inxRow) Then Rw " SELECTED"
			RwLf ">" & arrCustType(1, inxRow) & "</option>"
		Next
	Else
		RwLf "<option value=""-1"">Error - Customer Type Could Not Be Retrieved</option>"
	End If
	RwLf "</select>"
	RwLf "</td>"
	RwLf "</tr>"	
	
	RwLf "<tr>"
	RwLf "<th align=""right"" width=""25%"">"
	RwLf "<font size=""2"">Region:&nbsp;&nbsp;</font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	RwLf "<select name=""selRegion"" id=""selRegion"" onchange=""refresh_screen()"">"

	If IsArray(arrRegion) Then
		For inxRow = LBound(arrRegion, 2) To UBound(arrRegion, 2)
			Rw "<option value=""" & arrRegion(0, inxRow) & "|" & arrRegion(1, inxRow) & """"
			If vntRegion <> vbNullString and vntRegion = arrRegion(0, inxRow) Then Rw " SELECTED"
			RwLf ">" & arrRegion(1, inxRow) & "</option>"
		Next
	Else
		RwLf "<option value=""-1"">Error - Region Could Not Be Retrieved</option>"
	End If
	RwLf "</select>"

	RwLf "</td>"
	RwLf "</tr>"	

	RwLf "<tr>"
	RwLf "<th align=""right"" width=""25%"">"
	RwLf "<font size=""2"">Customer&nbsp;Org:&nbsp;&nbsp;</font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	if vntCustType = "WW" then
		Rw "Tyco Electronics"
	else
		RwLf "<select name=""selCustomerOrg"" id=""selCustomerOrg"">"

		If IsArray(arrOrgs) Then
			For inxRow = LBound(arrOrgs, 2) To UBound(arrOrgs, 2)
				Rw "<option value=""" & arrOrgs(0, inxRow) & "|" & arrOrgs(3, inxRow) & """"
				If vntCustomerOrgKeyID <> vbNullString Then If CInt(arrOrgs(0, inxRow)) = CInt(vntCustomerOrgKeyID) Then Rw " SELECTED"
				RwLf ">" & arrOrgs(3, inxRow) & "</option>"
			Next
		Else
			RwLf "<option value=""-1"">Error - Orgs Could Not Be Retrieved1</option>"
		End If
		RwLf "</select>"
	end if
	RwLf "</td>"
	RwLf "</tr>"

	RwLf "<tr>"
	RwLf "<th align=""right"">"
	RwLf "<font size=""2"">Customer&nbsp;Account&nbsp;Number:&nbsp;&nbsp;</font>"
	RwLf "</th>"
	RwLf "<td align=""left"">"
	RwLf "<input type=""text"" name=""txtCustAccntNbr"" id=""txtCustAccntNbr"" value=""" & vntCustAccntNbr & """ maxlength=""10"" size=""12"">"
	If vntCustType = "SOLD TO" Then 
		RwLf "Please enter the full 8 positions with leading zeroes and without dashes" 
	Else
		RwLf "Please enter the full 10 positions with leading zeroes and without dashes" 	
	End If
	RwLf "</td>"
	RwLf "</tr>"

'	RwLf "<tr>"
'	RwLf "<th align=""right"" width=""25%"">"
'	RwLf "&nbsp;"	
'	RwLf "</th>"	
'	RwLf "<td align=""left"">"	
'	RwLf vntCustName 	
'	RwLf "</td>"
'	RwLf "</tr>"	
	
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
	RwLf strBtnContinue
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

		if(theForm.hdnConf.value == 'YES' ) { 
			var ans = false;
			ans = confirm('Add Customer ' + theForm.hdnCN.value + '?');
			//var ans = confirm('Is it your confirmation.....?');
//			alert('Is it your confirmation.....?');
			if (ans) { 
				theForm.hdnConfResp.value='YES';				
			} else { 
				theForm.hdnConfResp.value='NO';
			}
			document.frmMain.submit()
		}
		else {
			ErrHandler();
		}
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

		switch(blnContinue){
		default:

			theForm.txtCustAccntNbr.value = theForm.txtCustAccntNbr.value.toUpperCase();
			if(!(theForm.txtCustAccntNbr.value)){
				alert('Please enter a valid Customer Number');
				theForm.txtCustAccntNbr.focus();
				theForm.txtCustAccntNbr.select();
				break;
			}

			blnContinue = true;
		}
		return(blnContinue);
	}
	
	function refresh_screen(){
	    frmMain.hdnMode.value = 'ADD';
		frmMain.submit();
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