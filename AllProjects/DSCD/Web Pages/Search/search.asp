<%@ Language=VBScript%>
<%
Option Explicit

Response.Buffer = True
Server.ScriptTimeout = 600
Session.Timeout = 240
Response.Expires = 0
If Request.Cookies("ckiSubmitted") <> vbNullString Then
	Response.Cookies("ckiSubmitted").Path = Application("AspPath")
	Response.Cookies("ckiSubmitted").Expires = DateAdd("YYYY", -1, Now())
End If
%>
<!--#include file=include/security.inc-->
<!--#include file=include/constants.inc-->
<%
Dim blnDebug, blnJSDebug
	blnDebug = False
	blnJSDebug = False

'	blnDebug = True
'	blnJSDebug = True

	'Uncomment when security matters
If Not MrSecurity Then
	If blnDebug Then
		'TESTING
		lsUID = "51727"
		lsAmpID = "AMP51727"
		Response.Cookies("GED_AGI") = lsUID
		Response.Cookies("USERNAME_ASP") = lsAmpID
	Else
		Response.Redirect Application("Login")
		Response.End
	End If
End If
%>
<!--#include file=include/colors.inc-->
<!--#include file=include/ArrayFunctions.inc-->
<!--#include file=include/GetBrowserVersion.inc-->
<!--#include file=include/ServerStats.inc-->
<%

'***********************************************************************
'*********	Housekeeping
'***********************************************************************

Dim vntErrorNumber, vntErrorDesc
	vntErrorNumber = 0
	vntErrorDesc = vbNullString
Dim blnError, blnContinue
	blnError = False
	blnContinue = True
Dim objError
	objError = 0
Dim errWhere
	errWhere = vbNullString
Dim errDesc
	errDesc = vbNullString


'Determine Browser
	If strBrowser = vbNullString Then GetBrowserVersion strBrowser, strBrowserVer, strOS

	Dim blnIE, blnNS, blnNotSupported, intMajorVer
		blnIE		= (InStr(strBrowser, "Microsoft") > 0)
		blnNS		= (Instr(strBrowser, "Netscape") > 0)
		intMajorVer	= CInt(Left(strBrowserVer, 1))

	blnNotSupported	= ((Not (blnIE Or blnNS)) Or (blnIE And intMajorVer < 5) Or (blnNS And intMajorVer < 4))

	If blnNotSupported Then
		TellUserToUpdateBrowser
		Response.End
	End If

'Some constants
	Dim strDATE_DELIMITER
		strDATE_DELIMITER = "-"

	Dim valOrganization, valBldgLocation, valCustWW, valShippingFac, valTeam
	Dim valController, valMakeStock, valProdCode, valIndustryCde, valMfgBldg, valProfitCtr, valSAPSales
		valOrganization	= "1"
		valBldgLocation	= "2"
		valCustWW		= "3"
		valShippingFac	= "4"
		valTeam			= "5"
		valController	= "6"
		valMakeStock	= "7"
		valProdCode		= "8"
		valIndustryCde	= "9"
		valMfgBldg		= "10"
		valProfitCtr	= "11"
		valSAPSales		= "12"

	Dim valSummary, valNonConforming, valConforming, valPastDue, valOpen, valLeadTime, valOrganizationYTD
	Dim valBldgList, valLocList, valCustList, valWWList, valOrgList, valShipFacList, valTeamList, valControllerList
	Dim valMakeStockList, valGPLList, valPCList, valIndustryList, valIBCList, valCampusList, valCmpBldgList
	Dim valProfitCtrList, valCompetencyBusList, valSalesOfficeList, valSalesGroupList, valOpenSmry, valOpenNonConform
		valSummary				= "2"
		valNonConforming		= "3"
		valConforming			= "4"
		valPastDue				= "5"
		valOpen					= "6"
		valLeadTime				= "7"
		valOrganizationYTD		= "8"
		valBldgList				= "9"
		valLocList				= "10"
		valCustList				= "11"
		valWWList				= "12"
		valOrgList				= "13"
		valShipFacList			= "14"
		valTeamList				= "15"
		valControllerList		= "16"
		valMakeStockList		= "17"
		valGPLList				= "18"
		valPCList				= "19"
		valIndustryList			= "20"
		valIBCList				= "21"
		valCampusList			= "22"
		valCmpBldgList			= "23"
		valProfitCtrList		= "24"
		valCompetencyBusList	= "25"
		valSalesOfficeList		= "26"
		valSalesGroupList		= "27"
		valOpenSmry				= "28"
		valOpenNonConform		= "29"

'Vars to hold incoming form data
	Dim vntSessionID, vntCommand, strBrowser, strBrowserVer, strOS

	'select boxes
	Dim vntView, vntCategory, vntWindow, vntSummaryType, vntComparison
	Dim vntOrgType, vntOrgID, vntCustAcctType, vntCustOrgID, vntLeadTimeType, vntMfgOrgType, vntMfgOrgID
	Dim vntProfitCtr, vntIndustryBusCde, vntCompetencyBusCde

	'text boxes
	Dim vntFromDate, vntToDate, vntDaysEarly, vntDaysLate, vntPartNbr
	Dim vntInvOrgPlant, vntController, vntCntrllerEmpNbr, vntPlantBldgNbr, vntLocation
	Dim vntShipTo, vntSoldTo
	Dim vntCustomerNbr '(no longer used)
	Dim vntWWNbr, vntMakeStock, vntTeam, vntProductCode, vntGblProductLine, vntProdMgr
	Dim vntIndustryCde, vntMfgCampusID, vntMfgBldgNbr, vntSalesOffice
	Dim vntOrgDt, vntSubCompetencyBusCde, vntSalesGroup, GamAccount, vntMrpGroup, vntProdHostOrgID

	'radio buttons
	Dim vntDateFormat, vntOrgHierarchy, vntShipOpen

	'checkboxes
	Dim vntExport, vntByCountry, vntBySTCntry

	'Init form vars
	GetFormData

'Vars to hold data defaults
	'select boxes
	Dim vntViewDef, vntCategoryDef, vntWindowDef, vntSummaryTypeDef, vntComparisonDef
	Dim vntOrgTypeDef, vntOrgIDDef, vntCustAcctTypeDef, vntCustOrgIDDef, vntLeadTimeTypeDef,vntMfgOrgTypeDef, vntMfgOrgIDDef
	Dim vntProfitCtrDef, vntIndustryBusCdeDef, vntCompetencyBusCdeDef
		vntViewDef			= "1"			'organization
		vntCategoryDef		= "2"			'summary
		vntWindowDef		= "1"			'customer variable
		vntSummaryTypeDef	= "2"			'request to ship
		vntComparisonDef	= "1"			'compare to schedule
		vntOrgTypeDef		= "1"			'global
		vntOrgIDDef			= vbNullString
		vntCustAcctTypeDef	= "0"			'all
		vntCustOrgIDDef		= vbNullString
		vntLeadTimeTypeDef	= "1"
		vntMfgOrgTypeDef	= "1636"		'company
		vntMfgOrgIDDef		= vbNullString
		vntProfitCtrDef		= vbNullString
		vntIndustryBusCdeDef   = vbNullString
		vntCompetencyBusCdeDef = vbNullString

	'text boxes
	Dim vntFromDateDef, vntToDateDef, vntDaysEarlyDef, vntDaysLateDef, vntPartNbrDef
	Dim vntInvOrgPlantDef, vntControllerDef, vntCntrllerEmpNbrDef, vntPlantBldgNbrDef, vntLocationDef
	Dim vntShipToDef, vntSoldToDef ', vntCustomerNbrDef (no longer used)
	Dim vntWWNbrDef, vntMakeStockDef, vntTeamDef, vntProductCodeDef, vntGblProductLineDef, vntProdMgrDef
	Dim vntIndustryCdeDef, vntMfgCampusIDDef, vntMfgBldgNbrDef, vntSalesOfficeDef
	Dim vntOrgDtDef, vntSubCompetencyBusCdeDef, vntSalesGroupDef, vntMrpGroupDef, vntProdHostOrgIDDef
		vntFromDateDef			= Year(Date()) & strDATE_DELIMITER & Month(Date()) & strDATE_DELIMITER & Day(Date())
		vntToDateDef			= Year(Date()) & strDATE_DELIMITER & Month(Date()) & strDATE_DELIMITER & Day(Date())
		vntDaysEarlyDef			= 3
		vntDaysLateDef			= 0
		vntPartNbrDef			= vbNullString
		vntInvOrgPlantDef		= vbNullString
		vntControllerDef		= vbNullString
		vntCntrllerEmpNbrDef	= vbNullString
		vntPlantBldgNbrDef		= vbNullString
		vntLocationDef			= vbNullString
		'vntCustomerNbrDef		= vbNullString
		vntShipToDef			= vbNullString
		vntSoldToDef			= vbNullString
		vntWWNbrDef				= vbNullString
		vntMakeStockDef			= vbNullString
		vntTeamDef				= vbNullString
		vntProductCodeDef		= vbNullString
		vntGblProductLineDef	= vbNullString
		vntProdMgrDef			= vbNullString
		vntIndustryCdeDef		= vbNullString
		vntMfgCampusIDDef		= vbNullString
		vntMfgBldgNbrDef		= vbNullString
		vntSubCompetencyBusCdeDef = vbNullString
		vntSalesOfficeDef		= vbNullString
		vntSalesGroupDef		= vbNullString
		vntMrpGroupDef		    = vbNullString
		vntProdHostOrgIDDef     = vbNullString
		vntOrgDtDef				= Year(Date()) & strDATE_DELIMITER & Month(Date()) & strDATE_DELIMITER & Day(Date())

	'radio buttons
	Dim vntDateFormatDef, vntOrgHierarchyDef, vntShipOpenDef
		vntDateFormatDef	= "1"	'monthly
		vntOrgHierarchyDef	= "C"	'current
		vntShipOpenDef		= "1"	'shipped

	'checkboxes
	Dim vntExportDef, vntByCountryDef, vntBySTCntryDef
		vntExportDef	= "0"
		vntByCountryDef = "0"
		vntBySTCntryDef = "0"

'HTML and Form element and label string constants
	Dim intDefFontSize, strDefFormat, strEndDefFormat, strErrorFormat
		intDefFontSize	= "2"
		strDefFormat	= "<font size=""" & intDefFontSize & """><b>"
		strEndDefFormat	= "</b></font>"
		'strErrorFormat  = "<font size=""" & intDefFontSize & """ color=red><b>"
		strErrorFormat = "<font size=""" & intDefFontSize & """><b>"

	'control buttons
	Dim strButtons, btnRestore, btnSubmit, strTopButtons, strLowButtons, btnRestore2, btnSubmit2, btnPartNbr
	Dim btnInvOrgPlant, btnController, btnMrpGroup, btnSalesOffice, btnSalesGroup, btnProdHostOrgID

	'Select Boxes
	Dim selView, selCategory, selWindow, selSummaryType, selComparison
	Dim selOrgType, selOrgID, selCustAcctType, selCustOrgID, selLeadTimeType, selMfgOrgType, selMfgOrgID
	Dim selProfitCtr, selIndustryBusCde, selCompetencyBusCde

	'Select Box Data
	Dim arrViewOpts, arrViewVals
	Dim arrCategoryOpts, arrCategoryVals
	Dim arrWindowOpts, arrWindowVals
	Dim arrSummaryTypeOpts, arrSummaryTypeVals
	Dim arrComparisonOpts, arrComparisonVals
	Dim arrOrgTypeOpts, arrOrgTypeVals
	Dim arrOrgIDs, arrOrgIDOpts, arrOrgIDVals
	Dim arrCustAcctTypeOpts, arrCustAcctTypeVals
	Dim arrCustOrgIDOpts, arrCustOrgIDVals
	Dim arrLeadTimeTypeOpts, arrLeadTimeTypeVals
	Dim arrMfgOrgTypeOpts, arrMfgOrgTypeVals
	Dim arrMfgOrgIDs, arrMfgOrgIDOpts, arrMfgOrgIDVals
	Dim arrProfitCtrOpts, arrProfitCtrVals
	Dim arrIndustryBusCdeOpts, arrIndustryBusCdeVals
	Dim arrCompetencyBusCdeOpts, arrCompetencyBusCdeVals

	'Text Boxes
	Dim hdnFromDate, txtToDate, txtDaysEarly, txtDaysLate, txtPartNbr
	Dim txtInvOrgPlant, txtController, txtCntrllerEmpNbr, txtPlantBldgNbr, txtLocation
	Dim txtShipTo, txtSoldTo ', txtCustomerNbr (no longer used)
	Dim txtWWNbr, txtMakeStock, txtTeam, txtProductCode, txtGblProductLine, txtProdMgr
	Dim txtIndustryCde, txtMfgCampusID, txtMfgBldgNbr, txtSalesOffice
	Dim txtOrgDt, txtSubCompetencyBusCde, txtSalesGroup, txtMrpGroup, txtProdHostOrgID

	'Radio Button Groups
	Dim hdnDateFormat, hdnDateFormat_HidePart, rdoOrgHierarchy, rdoShipOpen

	'Checkboxes
	Dim chkExport, chkByCountry, chkBySTCntry


	'Select Box Labels
	Dim selView_Lbl, selCategory_Lbl, selWindow_Lbl, selSummaryType_Lbl, selComparison_Lbl
	Dim selOrgType_Lbl, selOrgID_Lbl, selCustAcctType_Lbl, selCustOrgID_Lbl, selLeadTimeType_Lbl
	Dim selMfgOrgType_Lbl, selMfgOrgID_Lbl, selProfitCtr_Lbl, selIndustryBusCde_Lbl, selCompetencyBusCde_Lbl

	'Text Box Labels
	Dim hdnFromDate_Lbl, txtToDate_Lbl, txtDaysEarly_Lbl, txtDaysLate_Lbl, txtPartNbr_Lbl, txtDaysEarlyAll_Lbl
	Dim txtCntrllerEmpNbr_Lbl, txtPlantBldgNbr_Lbl, txtLocation_Lbl
	Dim txtShipTo_Lbl, txtSoldTo_Lbl, txtPlant_Lbl
	Dim txtWWNbr_Lbl, txtMakeStock_Lbl, txtTeam_Lbl, txtProductCode_Lbl, txtGblProductLine_Lbl, txtProdMgr_Lbl
	Dim txtIndustryCde_Lbl, txtMfgCampusID_Lbl, txtMfgBldgNbr_Lbl, txtSalesOffice_Lbl
	Dim txtOrgDt_Lbl, txtSubCompetencyBusCde_Lbl, txtSalesGroup_Lbl

	'Radio Button Group Labels
	Dim hdnDateFormat_Lbl, rdoOrgHierarchy_Lbl, rdoShipOpen_Lbl

	'Checkbox Labels
	Dim chkExport_Lbl, chkByCountry_Lbl, chkBySTCntry_Lbl

	Dim strQS
	Dim objSearch

	'lookup vars
	Dim vntPartNbrPrev, vntPartKeyID

'***********************************************************************
'*********	Main Processing
'***********************************************************************

	Set objSearch = Server.CreateObject("DSCD.clsSearch")

	If blnDebug Then RwLfRequest

	If blnContinue Then
		If vntCommand = "DEFAULTS" Then

			blnContinue = RestoreDefaults()
			If blnContinue Then GoURL "search.asp?s=" & vntSessionID

		ElseIf vntCommand = "PARTNBR" Then
			blnContinue = SaveToDB()
			Session("PartPartNumber") = Trim(Request.Form("hdnPartNbr"))
			Session("PartNumber") = "S"
			GoURL "PartNumber.asp?s=" & vntSessionID

		ElseIf vntCommand = "INVORGPLANT" Then
			blnContinue = SaveToDB()
			Session("InvOrgPlant") = Trim(Request.Form("hdnInvOrgPlant"))
			Session("InvOrgPlantAction") = "S"
			Session("InvOrgPlantOrgID") = vntOrgID
			GoURL "InvOrgPlant.asp?s=" & vntSessionID

		ElseIf vntCommand = "CONTROLLER" Then
			blnContinue = SaveToDB()
			Session("Controller") = Trim(Request.Form("hdnController"))
			Session("ControllerAction") = "S"
			Session("ControllerOrgID") = vntOrgID
			Session("ControllerInvOrgPlant") = vntInvOrgPlant
			GoURL "Controller.asp?s=" & vntSessionID

		ElseIf vntCommand = "MRPGROUP" Then
			blnContinue = SaveToDB()
			Session("MrpGroup") = Trim(Request.Form("hdnMrpGroup"))
			Session("MrpGroupAction") = "S"
			Session("MrpGroupOrgID") = vntOrgID
			GoURL "MrpGroup.asp?s=" & vntSessionID

		ElseIf vntCommand = "SALESOFFICE" Then
			blnContinue = SaveToDB()
			Session("SalesOffice") = Trim(Request.Form("hdnSalesOffice"))
			Session("SalesOfficeAction") = "S"
			Session("SalesOfficeOrgID") = vntOrgID
			GoURL "SalesOffice.asp?s=" & vntSessionID

		ElseIf vntCommand = "SALESGROUP" Then
			blnContinue = SaveToDB()
			Session("SalesGroup") = Trim(Request.Form("hdnSalesGroup"))
			Session("SalesGroupAction") = "S"
			Session("SalesGroupOrgID") = vntOrgID
			Session("SalesGroupSalesOffice") = vntSalesOffice
			GoURL "SalesGroup.asp?s=" & vntSessionID

		ElseIf vntCommand = "PRODHOSTORGID" Then
			blnContinue = SaveToDB()
			Session("ProdHostOrgID") = Trim(Request.Form("hdnProdHostOrgID"))
			Session("ProdHostOrgIDAction") = "S"
			Session("ProdHostOrgID") = vntOrgID
			GoURL "ProdHostOrg.asp?s=" & vntSessionID

		ElseIf vntCommand = "SUBMIT" Then
			if vntCategory = valOpenSmry then
				' set window to Standard default
				vntWindow = "2"
			end if

			blnContinue = GetPartKeyID()

			blnContinue = SaveToDB()

			blnContinue = SaveUserLog

			If blnContinue Then
				strQS = "?s=" & vntSessionID & "&v=" & vntView & "&c=" & vntCategory & "&w=" & vntWindow
				If	(((vntView = valOrganization And _
					vntCategory <> valOrganizationYTD) Or _
					(vntView = valCustWW)) And _
					vntPartNbr <> vbNullString) Or _
					(vntView = valProdCode And _
					 (vntWWNbr <> vbNullString or _
					  vntSoldTo <> vbNullString or _
					  (vntMakeStock <> vbNullString And _
					   (vntProdMgr <> vbNullString or _
					    vntCategory = valPCList) _
					  ) _
					 ) _
					) or _
					(vntCategory = valOpenSmry) _
					Then
					'-for product code view, always use dly (OIS dtl) if WWNbr
					' or SoldTo is null; or MakeStock and ProdMgr are not null;
					' or MakeStock is not null and Category is GPC list
					strQS = strQS & "&mdi=2"
				Else
					strQS = strQS & "&mdi=" & vntDateFormat
				End If
				If vntExport = "1" Then strQS = strQS & "&x=1"
				If vntByCountry = "1" Then strQS = strQS & "&rt=1"
				If vntBySTCntry = "2" Then strQS = strQS & "&rt=2"
%>
<!--#include file=include/InsertServerStats.inc-->
<%
				Response.Cookies("ckiSubmitted") = "true"
				Response.Cookies("ckiSubmitted").Path = Application("AspPath")
				If vntCategory = valSummary or vntCategory = valOpenSmry Then
					GoURL "smresults.asp" & strQS
				Else
					GoURL "results.asp" & strQS
				End If
			End If
		End If
	End If

	If blnContinue Then
		ClearFormVars
		blnContinue = RetrieveLastQuery()
	End If

	If blnContinue Then
		InitElementStrings
		InitElementLabelStrings
		DisplayScreen
	Else
		DisplayError
	End If

	CleanUp

'***********************************************************************
'*********	End Processing
'***********************************************************************



'***********************************************************************
'*********	Subroutines concerning data handling
'***********************************************************************
Sub ClearFormVars()
	vntView			= vbNullString
	vntCategory		= vbNullString
	vntWindow		= vbNullString
	vntSummaryType	= vbNullString
	vntComparison	= vbNullString
	vntOrgType		= vbNullString
	vntOrgID		= vbNullString
	vntCustAcctType	= vbNullString
	vntCustOrgID	= vbNullString
	vntLeadTimeType = vbNullString
	vntMfgOrgType	= vbNullString
	vntMfgOrgID		= vbNullString

	vntFromDate			= vbNullString
	vntToDate			= vbNullString
	vntDaysEarly		= vbNullString
	vntDaysLate			= vbNullString
	vntPartNbr			= vbNullString
	vntInvOrgPlant		= vbNullString
	vntController		= vbNullString
	vntCntrllerEmpNbr	= vbNullString
	vntPlantBldgNbr		= vbNullString
	vntLocation			= vbNullString
	vntWWNbr			= vbNullString
	vntMakeStock		= vbNullString
	vntTeam				= vbNullString
	vntProductCode		= vbNullString
	vntGblProductLine	= vbNullString
	vntProdMgr			= vbNullString
	vntIndustryCde		= vbNullString
	vntMfgCampusID		= vbNullString
	vntMfgBldgNbr		= vbNullString
	'vntCustomerNbr		= vbNullString
	vntShipTo			= vbNullString
	vntSoldTo			= vbNullString
	vntProfitCtr		= vbNullString
	vntIndustryBusCde	= vbNullString
	vntCompetencyBusCde	= vbNullString
	vntSubCompetencyBusCde	= vbNullString
	vntOrgDt			= vbNullString
	vntSalesOffice		= vbNullString
	vntSalesGroup		= vbNullString
	vntMrpGroup		    = vbNullString
	vntProdHostOrgID	= vbNullString

	vntDateFormat	= vbNullString
	vntOrgHierarchy	= vbNullString
	vntShipOpen		= vbNullString

	vntExport	= vbNullString
	vntByCountry = vbNullString
	vntBySTCntry = vbNullString
End Sub


Sub GetFormData()

	vntSessionID	= Trim(Request.QueryString("s"))

	vntCommand		= UCase(Trim(Request.Form("hdnCommand")))
	strBrowser		= Trim(Request.Form("hdnBrowser"))
	strBrowserVer	= Trim(Request.Form("hdnBrowserVer"))
	strOS			= Trim(Request.Form("hdnOS"))

	vntView			= Trim(Request.Form("selView"))
	vntCategory		= Trim(Request.Form("selCategory"))
	vntWindow		= Trim(Request.Form("selWindow"))
	vntSummaryType	= Trim(Request.Form("selSummaryType"))
	vntComparison	= Trim(Request.Form("selComparison"))
	vntOrgType		= Trim(Request.Form("selOrgType"))
	vntOrgID		= Trim(Request.Form("selOrgID"))
	vntCustAcctType	= Trim(Request.Form("selCustAcctType"))
	vntCustOrgID	= Trim(Request.Form("selCustOrgID"))
	vntLeadTimeType	= Trim(Request.Form("selLeadTimeType"))
	vntMfgOrgType	= Trim(Request.Form("selMfgOrgType"))
	vntMfgOrgID		= Trim(Request.Form("selMfgOrgID"))
	vntProfitCtr	= Trim(Request.Form("selProfitCtr"))
	vntIndustryBusCde	= Trim(Request.Form("selIndustryBusCde"))
	vntCompetencyBusCde	= Trim(Request.Form("selCompetencyBusCde"))

	vntFromDate			= Trim(Request.Form("hdnFromDate"))
	vntToDate			= Trim(Request.Form("txtToDate"))
	vntDaysEarly		= Trim(Request.Form("txtDaysEarly"))
	vntDaysLate			= Trim(Request.Form("txtDaysLate"))
	vntPartNbrPrev		= Trim(Request.Form("hdnPartNbr"))
	vntPartKeyID		= Trim(Request.Form("hdnPartKeyID"))
	vntPartNbr			= Trim(Request.Form("txtPartNbr"))
	vntInvOrgPlant		= Trim(Request.Form("txtInvOrgPlant"))
	vntController		= Trim(Request.Form("txtController"))
	vntCntrllerEmpNbr	= Trim(Request.Form("txtCntrllerEmpNbr"))
	vntPlantBldgNbr		= Trim(Request.Form("txtPlantBldgNbr"))
	vntLocation			= Trim(Request.Form("txtLocation"))
	vntWWNbr			= Trim(Request.Form("txtWWNbr"))
	vntMakeStock		= Trim(Request.Form("txtMakeStock"))
	vntTeam				= Trim(Request.Form("txtTeam"))
	vntProductCode		= Trim(Request.Form("txtProductCode"))
	vntGblProductLine	= Trim(Request.Form("txtGblProductLine"))
	vntProdMgr			= Trim(Request.Form("txtProdMgr"))
	vntIndustryCde		= Trim(Request.Form("txtIndustryCde"))
	vntMfgCampusID		= Trim(Request.Form("txtMfgCampusID"))
	vntMfgBldgNbr		= Trim(Request.Form("txtMfgBldgNbr"))
	'vntCustomerNbr		= Trim(Request.Form("txtCustomerNbr"))
	vntShipTo			= Trim(Request.Form("txtShipTo"))
	vntSoldTo			= Trim(Request.Form("txtSoldTo"))
	vntSubCompetencyBusCde	= Trim(Request.Form("txtSubCompetencyBusCde"))
	vntOrgDt			= Trim(Request.Form("txtOrgDt"))
	vntSalesOffice		= Trim(Request.Form("txtSalesOffice"))
	vntSalesGroup		= Trim(Request.Form("txtSalesGroup"))
	vntMrpGroup		    = Trim(Request.Form("txtMrpGroup"))
	vntProdHostOrgID	= Trim(Request.Form("txtProdHostOrgID"))

	vntDateFormat	= Trim(Request.Form("hdnDateFormat"))
	vntOrgHierarchy	= Trim(Request.Form("rdoOrgHierarchy"))
	vntShipOpen		= Trim(Request.Form("rdoShipOpen"))

	vntExport	= Trim(Request.Form("chkExport"))
	vntByCountry = Trim(Request.Form("chkByCountry"))
	vntBySTCntry = Trim(Request.Form("chkBySTCntry"))

	If vntDateFormat	= vbNullString Then vntDateFormat = vntDateFormatDef		'"1"
	'If vntOrgHierarchy	= vbNullString Then vntOrgHierarchy = vntOrgHierarchyDef	'"C"
	'If vntShipOpen		= vbNullString Then vntShipOpen = vntShipOpenDef			'"1"

End Sub


Function RestoreDefaults()
If blnDebug Then rwlf "RestoreDefaults()<br>"
RestoreDefaults = False

	Dim blnRC

	blnRC = objSearch.ResetSession(lsUID, vntSessionID, vntErrorNumber, vntErrorDesc)

	If Not blnRC Or vntErrorNumber <> 0 Then
		ReportError vntErrorNumber, vntErrorDesc, "RestoreDefaults()"
	Else
		RestoreDefaults = blnRC
	End If

End Function


Function RetrieveLastQuery()
If blnDebug Then rwlf "RetrieveLastQuery()<br>"
RetrieveLastQuery = False

	Dim blnRC, strURL

	If Len(vntSessionID) > 0 And IsNumeric(vntSessionID) Then

		blnRC = objSearch.RetrieveSessionASP(vntSessionID, vntView, vntCategory, _
										vntWindow, vntFromDate, vntToDate, _
										vntDaysEarly, vntDaysLate, vntDateFormat, _
										vntSummaryType, vntOrgHierarchy, vntOrgType, vntOrgID, _
										vntCustAcctType, vntPartNbr, vntPlantBldgNbr, _
										vntLocation, vntCustOrgID, vntShipTo, vntSoldTo, _
										vntWWNbr, vntInvOrgPlant, vntController, _
										vntCntrllerEmpNbr, vntMakeStock, vntTeam, _
										vntProductCode, vntGblProductLine, vntIndustryBusCde, _
										vntIndustryCde, vntMfgCampusID, vntMfgBldgNbr, _
										vntComparison, vntShipOpen, vntProfitCtr, _
										vntCompetencyBusCde, vntOrgDt, vntSubCompetencyBusCde, _
										vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, _
										vntMfgOrgType, vntMfgOrgID, GamAccount, vntPartKeyID, vntMrpGroup, _
										vntProdHostOrgID, vntErrorNumber, vntErrorDesc)

		'get part lookup value
		if Session("PartNumber") = "R" then
			vntPartNbr = Session("PartPartNumber")
			vntPartKeyID = Session("PartPartKeyID")
			Session("PartNumber") = ""
		end if

		'get inv org/plant lookup value
		if Session("InvOrgPlantAction") = "R" then
			vntInvOrgPlant = Session("InvOrgPlant")
			Session("InvOrgPlantAction") = ""
		end if

		'get controller lookup value
		if Session("ControllerAction") = "R" then
			vntController = Session("Controller")
			Session("ControllerAction") = ""
		end if

		'get Mrp group lookup value
		if Session("MrpGroupAction") = "R" then
			vntMrpGroup = Session("MrpGroup")
			Session("MrpGroupAction") = ""
		end if

		'get Sales Office lookup value
		if Session("SalesOfficeAction") = "R" then
			vntSalesOffice = Session("SalesOffice")
			Session("SalesOfficeAction") = ""
		end if

		'get Sales Group lookup value
		if Session("SalesGroupAction") = "R" then
			vntSalesGroup = Session("SalesGroup")
			Session("SalesGroupAction") = ""
		end if

		'get product host org id lookup value
		if Session("ProdHostOrgIDAction") = "R" then
			vntProdHostOrgID = Session("ProdHostOrgID")
			Session("ProdHostOrgIDAction") = ""
		end if
	Else
		vntErrorNumber = 100
	End If

	If Not blnRC Or vntErrorNumber <> 0 Then
		If vntErrorNumber = 100 Then
			blnRC = CreateSearchSession()
			If blnRC Then
				strURL = strServerURL & appPath & "search.asp?s=" & vntSessionID
				GoURL strURL
				Response.End
			End If
		Else
			ReportError vntErrorNumber, vntErrorDesc, "RetrieveLastQuery()"
		End If
	Else
		RetrieveLastQuery = blnRC
	End If

End Function


Function ClearSession()
If blnDebug Then RwLf "ClearSession()<br>"
ClearSession = False

	Dim blnRC

	blnRC = objSearch.ClearSession(lsUID, vntErrorNumber, vntErrorDesc)

	If Not blnRC Or vntErrorNumber <> 0 Then
		ReportError vntErrorNumber, vntErrorDesc, "ClearSession()"
	Else
		ClearSession = blnRC
	End If

End Function


Function CreateSearchSession()
If blnDebug Then RwLf "CreateSearchSession()<br>"
CreateSearchSession = False

	Dim blnRC

	blnRC = objSearch.CreateCurrentSession(lsUID, vntSessionID, vntErrorNumber, vntErrorDesc)

	If Not blnRC Or vntErrorNumber <> 0 Then
		ReportError vntErrorNumber, vntErrorDesc, "CreateSearchSession()"
	Else
		CreateSearchSession = blnRC
	End If

End Function


Function SaveToDB()
If blnDebug Then rwlf "SaveToDB()<br>"
SaveToDB = False

	Dim blnRC

	blnRC = objSearch.UpdateSession(lsAmpID, vntSessionID, vntView, vntCategory, _
									vntWindow, vntFromDate, vntToDate, _
									vntDaysEarly, vntDaysLate, vntDateFormat, _
									vntSummaryType, vntOrgHierarchy, vntOrgType, vntOrgID, _
									vntCustAcctType, vntPartNbr, vntPlantBldgNbr, _
									vntLocation, vntCustOrgID, vntShipTo, vntSoldTo, _
									vntWWNbr, vntInvOrgPlant, vntController, _
									vntCntrllerEmpNbr, vntMakeStock, vntTeam, _
									vntProductCode, vntGblProductLine, vntIndustryBusCde, _
									vntIndustryCde, vntMfgCampusID, vntMfgBldgNbr, _
									vntComparison, vntShipOpen, vntProfitCtr, _
									vntCompetencyBusCde, vntOrgDt, vntSubCompetencyBusCde, _
									vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, _
									vntMfgOrgType, vntMfgOrgID,GamAccount, vntPartKeyID, vntMrpGroup, _
									vntProdHostOrgID, vntErrorNumber, vntErrorDesc)


	If Not blnRC Or vntErrorNumber <> 0 Then
		ReportError vntErrorNumber, vntErrorDesc, "SaveToDB()"
	Else
		SaveToDB = blnRC
	End If

End Function


Function SaveUserLog()
If blnDebug Then rwlf "SaveUserLog()<br>"
SaveUserLog = False

	Dim blnRC

	blnRC = objSearch.SaveUserLog(lsAmpID, vntView, vntCategory, _
									vntWindow, vntFromDate, vntToDate, _
									vntDaysEarly, vntDaysLate, vntDateFormat, _
									vntSummaryType, vntOrgHierarchy, vntOrgType, vntOrgID, _
									vntCustAcctType, vntPartNbr, vntPlantBldgNbr, _
									vntLocation, vntCustOrgID, vntShipTo, vntSoldTo, _
									vntWWNbr, vntInvOrgPlant, vntController, _
									vntCntrllerEmpNbr, vntMakeStock, vntTeam, _
									vntProductCode, vntGblProductLine, vntIndustryBusCde, _
									vntIndustryCde, vntMfgCampusID, vntMfgBldgNbr, _
									vntComparison, vntShipOpen, vntProfitCtr, _
									vntCompetencyBusCde, vntOrgDt, vntSubCompetencyBusCde, _
									vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, _
									vntMfgOrgType, vntMfgOrgID,GamAccount, vntPartKeyID, vntMrpGroup, _
									vntProdHostOrgID, vntErrorNumber, vntErrorDesc)


	If Not blnRC Or vntErrorNumber <> 0 Then
		ReportError vntErrorNumber, vntErrorDesc, "SaveUserLog()"
	Else
		SaveUserLog = blnRC
	End If

End Function


Function GetPartKeyID()
If blnDebug Then RwLf "GetPartKeyID()<br>"
GetPartKeyID = False

	dim objList, vntArray, strSQL

	if ((vntView = valOrganization And vntCategory <> valOrganizationYTD) Or _
		 (vntView = valCustWW And vntCategory <> valOrgList)) and _
		 vntPartNbr <> vbNullString then
		if Session("PartNumber") = "S" or vntPartNbr <> vntPartNbrPrev then
			set objList = server.CreateObject ("DSCD.clsPart")
			vntArray = objList.List(vntPartNbr,"","1",strSQL,vntErrorNumber,vntErrorDesc)

			Set objList = nothing

			If vntErrorNumber <> 0 Then
				ReportError vntErrorNumber, vntErrorDesc, "GetPartKeyID()"
			Else
				if not isNull(vntArray) then
					if Ubound(vntArray, 2) > 0 then
						'more than one brand found
						Session("PartPartNumber") = vntPartNbr
						Session("PartLookupMode") = "Display"
						Session("PartNumber") = "S"
						GoURL "PartNumber.asp?s=" & vntSessionID
					else
						vntPartKeyID = vntArray(2, 0)
					end if
				else
					vntPartKeyID = -1 'not found
				end if
			end if
		end if
	end if
	GetPartKeyID = true
End Function

'***********************************************************************
'*********	Subroutines that Build HTML
'***********************************************************************

Sub InitElementStrings()
If blnDebug Then rwlf "InitElementStrings()<br>"

	btnRestore	= "<input type=""button"" name=""btnRestore"" id=""btnRestore"" value=""Restore Default Values"" onclick=""restore_defaults();"">"
	btnSubmit	= "<input type=""button"" name=""btnSubmit"" id=""btnSubmit"" value=""Submit"" onclick=""process_form();"">"
	btnRestore2	= Replace(btnRestore, "btnRestore", "btnRestore2")
	btnSubmit2	= Replace(btnSubmit, "btnSubmit", "btnSubmit2")
	strButtons	= "<table width=""100%"" border=""0""><tr><td align=""left"">%%RESTORE%%</td>" & _
						"<td align=""right"">%%SUBMIT%%</td></tr></table>"
	strTopButtons	= Replace(Replace(strButtons, "%%RESTORE%%", btnRestore), "%%SUBMIT%%", btnSubmit)
	strLowButtons	= Replace(Replace(strButtons, "%%RESTORE%%", btnRestore2), "%%SUBMIT%%", btnSubmit2)
	btnPartNbr	= "<input type=""button"" name=""btnPartNbr"" id=""btnPartNbr"" value=""Part Nbr:"" onclick=""partnbr_lookup();"">"
	btnInvOrgPlant	= "<input type=""button"" name=""btnInvOrgPlant"" id=""btnInvOrgPlant"" value=""Inv Org ID/Plant Number:"" onclick=""invorgplant_lookup();"">"
	btnController	= "<input type=""button"" name=""btnController"" id=""btnController"" value=""Controller:"" onclick=""controller_lookup();"">"
	btnMrpGroup	    = "<input type=""button"" name=""btnMrpGroup"" id=""btnMrpGroup"" value=""MRP Group:"" onclick=""mrpgroup_lookup();"">"
	btnSalesOffice  = "<input type=""button"" name=""btnSalesOffice"" id=""btnSalesOffice"" value=""SAP Sales Office:"" onclick=""salesoffice_lookup();"">"
	btnSalesGroup   = "<input type=""button"" name=""btnSalesGroup"" id=""btnSalesGroup"" value=""SAP Sales Group:"" onclick=""salesgroup_lookup();"">"
	btnProdHostOrgID = "<input type=""button"" name=""btnProdHostOrgID"" id=""btnProdHostOrgID"" value=""Product Host Org ID:"" onclick=""prodhostorgid_lookup();"">"

	Dim objLoad, inxView, inxRow, inxCol, vntArray
	Dim vntVariant

''''''''''''''''''''''''''''''
'	Build View Select
''''''''''''''''''''''''''''''
	selView = "<select name=""selView"" id=""selView"" onchange=""refresh_screen(1);"">" & vbcrlf
	selView = selView & "	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf & _
						"	<option>~~~~~~  Loading...  ~~~~~</option>" & vbCrLf
	selView = selView & "</select>"

	Set objLoad = Server.CreateObject("DSCD.clsView")
	vntArray = objLoad.ListViews(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrViewVals, FormatJSstring(vntArray(0, inxRow))
			push arrViewOpts, FormatWords(vntArray(1, inxRow))
		Next
		Erase vntArray
	Else
		push arrViewVals, vbNullString
		push arrViewVals, vbNullString
		push arrViewVals, vbNullString
		push arrViewOpts, "Error!"
		push arrViewOpts, vntErrorNumber
		push arrViewOpts, Replace(vntErrorDesc, "'", "\'")
	End If
	vntArray = vbNullString


''''''''''''''''''''''''''''''
'	Build Category Select
''''''''''''''''''''''''''''''
	selCategory = "<select name=""selCategory"" id=""selCategory"" onchange=""refresh_screen(2);"">" & vbCrLf
	selCategory = selCategory & "	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf & _
								"	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf & _
								"	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf & _
								"	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf & _
								"	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf & _
								"	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf & _
								"	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf & _
								"	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf & _
								"	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf & _
								"	<option>~~~~~~  Please...  ~~~~~~</option>" & vbCrLf
	selCategory = selCategory & "</select>"

	'Organization Categories
	For inxView = LBound(arrViewVals) To UBound(arrViewVals)
		vntArray = objLoad.ListViewCategories(arrViewVals(inxView), vntErrorNumber, vntErrorDesc)
		push arrCategoryVals, vntVariant
		arrCategoryVals(inxView) = Array()
		push arrCategoryOpts, vntVariant
		arrCategoryOpts(inxView) = Array()
		If IsArray(vntArray) Then
			For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
				push arrCategoryVals(inxView), FormatJSstring(vntArray(1, inxRow))
				push arrCategoryOpts(inxView), FormatWords(vntArray(2, inxRow))
			Next
			Erase vntArray
		Else
			push arrCategoryVals(inxView), "Error!"
			push arrCategoryVals(inxView), vbNullString
			push arrCategoryVals(inxView), vbNullString
			push arrCategoryOpts(inxView), "Error!"
			push arrCategoryOpts(inxView), FormatJSstring(vntErrorNumber)
			push arrCategoryOpts(inxView), FormatJSstring(vntErrorDesc)
		End If
		vntArray = vbNullString
	Next
	Set objLoad = Nothing



''''''''''''''''''''''''''''''
'	Build Window Select
''''''''''''''''''''''''''''''
	selWindow = "<select name=""selWindow"" id=""selWindow"" onchange=""refresh_screen(3);"">" & vbcrlf
	selWindow = selWindow & " <option>~~~~~~~  Wait...  ~~~~~~~</option>" & vbCrLf & _
							"	<option>~~~~~~~  Wait...  ~~~~~~~</option>" & vbCrLf
	selWindow = selWindow & "</select>"
	Set objLoad = Server.CreateObject("DSCD.clsWindow")
	vntArray = objLoad.ListWindows(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrWindowVals, FormatJSstring(vntArray(0, inxRow))
			push arrWindowOpts, FormatWords(vntArray(1, inxRow))
		Next
		Erase vntArray
	Else
		push arrWindowVals, vbNullString
		push arrWindowVals, vbNullString
		push arrWindowVals, vbNullString
		push arrWindowOpts, "Error!"
		push arrWindowOpts, FormatJSstring(vntErrorNumber)
		push arrWindowOpts, FormatJSstring(vntErrorDesc)
	End If
	vntArray = vbNullString
	Set objLoad = Nothing


''''''''''''''''''''''''''''''
'	Build Summary Type Select
''''''''''''''''''''''''''''''
'	selSummaryType = "SelectTag('selSummaryType', 'onchange=refresh_screen(8);', arrSummaryTypeOpts, arrSummaryTypeVals, (frmMain.selSummaryType.value ? frmMain.selSummaryType.value : strSummaryTypeDef))"
	selSummaryType = "SelectTag('selSummaryType', 'onchange=refresh_screen(3);', arrSummaryTypeOpts, arrSummaryTypeVals, (frmMain.selSummaryType.value ? frmMain.selSummaryType.value : strSummaryTypeDef))"
	Set objLoad = Server.CreateObject("DSCD.clsSummaryType")
	vntArray = objLoad.ListSmryTypes(vbNullString, vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrSummaryTypeVals, FormatJSstring(vntArray(0, inxRow))
			push arrSummaryTypeOpts, FormatWords(vntArray(1, inxRow))
		Next
		Erase vntArray
	Else
		push arrSummaryTypeVals, vbNullString
		push arrSummaryTypeVals, vbNullString
		push arrSummaryTypeVals, vbNullString
		push arrSummaryTypeOpts, "Error!"
		push arrSummaryTypeOpts, FormatJSstring(vntErrorNumber)
		push arrSummaryTypeOpts, FormatJSstring(vntErrorDesc)
	End If
	vntArray = vbNullString
	Set objLoad = Nothing


''''''''''''''''''''''''''''''
'	Build Lead-time Select
''''''''''''''''''''''''''''''
	selLeadTimeType = "SelectTag('selLeadTimeType', 'onchange=refresh_screen(3);', arrLeadTimeTypeOpts, arrLeadTimeTypeVals, (frmMain.selLeadTimeType.value ? frmMain.selLeadTimeType.value : strLeadTimeTypeDef))"
	Set objLoad = Server.CreateObject("DSCD.clsLeadtime")
	vntArray = objLoad.ListLeadTimeTypes(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrLeadTimeTypeVals, FormatJSstring(vntArray(0, inxRow))
			push arrLeadTimeTypeOpts, FormatWords(vntArray(1, inxRow))
		Next
		Erase vntArray
	Else
		push arrLeadTimeTypeVals, vbNullString
		push arrLeadTimeTypeVals, vbNullString
		push arrLeadTimeTypeVals, vbNullString
		push arrLeadTimeTypeOpts, "Error!"
		push arrLeadTimeTypeOpts, FormatJSstring(vntErrorNumber)
		push arrLeadTimeTypeOpts, FormatJSstring(vntErrorDesc)
	End If
	vntArray = vbNullString
	Set objLoad = Nothing


''''''''''''''''''''''''''''''
'	Build Comparison Select
''''''''''''''''''''''''''''''
	selComparison = "SelectTag('selComparison', '', arrComparisonOpts, arrComparisonVals, (frmMain.selComparison.value ? frmMain.selComparison.value : strComparisonDef))"
	Set objLoad = Server.CreateObject("DSCD.clsComparison")
	vntArray = objLoad.ListComparisonTypes(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrComparisonVals, FormatJSstring(vntArray(0, inxRow))
			push arrComparisonOpts, FormatWords(vntArray(1, inxRow))
		Next
		Erase vntArray
	Else
		push arrComparisonVals, vbNullString
		push arrComparisonVals, vbNullString
		push arrComparisonVals, vbNullString
		push arrComparisonOpts, "Error!"
		push arrComparisonOpts, FormatJSstring(vntErrorNumber)
		push arrComparisonOpts, FormatJSstring(vntErrorDesc)
	End If
	vntArray = vbNullString
	Set objLoad = Nothing


''''''''''''''''''''''''''''''
'	Build Org Type Select
''''''''''''''''''''''''''''''
	selOrgType = "SelectTag('selOrgType', 'onchange=rebuild_org_ids();refresh_screen(3);', arrOrgTypeOpts, arrOrgTypeVals, (frmMain.selOrgType.value ? frmMain.selOrgType.value : strOrgTypeDef))"
	Set objLoad = Server.CreateObject("DSCD.clsOrgs")
	vntArray = objLoad.ListType(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrOrgTypeVals, FormatJSstring(vntArray(0, inxRow))
			push arrOrgTypeOpts, FormatWords(vntArray(1, inxRow))
		Next
		Erase vntArray
	Else
		push arrOrgTypeVals, vbNullString
		push arrOrgTypeVals, vbNullString
		push arrOrgTypeVals, vbNullString
		push arrOrgTypeOpts, "Error!"
		push arrOrgTypeOpts, FormatJSstring(vntErrorNumber)
		push arrOrgTypeOpts, FormatJSstring(vntErrorDesc)
	End If
	vntArray = vbNullString


''''''''''''''''''''''''''''''
'	Build Mfg Org Type Select
''''''''''''''''''''''''''''''
	selMfgOrgType = "SelectTag('selMfgOrgType', 'onchange=rebuild_mfg_org_ids();refresh_screen(3);', arrMfgOrgTypeOpts, arrMfgOrgTypeVals, (frmMain.selMfgOrgType.value ? frmMain.selMfgOrgType.value : strMfgOrgTypeDef))"
	Set objLoad = Server.CreateObject("DSCD.clsOrgs")
	vntArray = objLoad.ListType(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrMfgOrgTypeVals, FormatJSstring(vntArray(0, inxRow))
			push arrMfgOrgTypeOpts, FormatWords(vntArray(1, inxRow))
		Next
		Erase vntArray
	Else
		push arrMfgOrgTypeVals, vbNullString
		push arrMfgOrgTypeVals, vbNullString
		push arrMfgOrgTypeVals, vbNullString
		push arrMfgOrgTypeOpts, "Error!"
		push arrMfgOrgTypeOpts, FormatJSstring(vntErrorNumber)
		push arrMfgOrgTypeOpts, FormatJSstring(vntErrorDesc)
	End If
	vntArray = vbNullString


''''''''''''''''''''''''''''''
'	Build Org ID Select
''''''''''''''''''''''''''''''
	selOrgID = "SelectTag('selOrgID', '', arrLoadingMsg, arrLoadingMsg, strOrgIDDef)"
	arrOrgIDs = objLoad.ListOrgIDs(vbNullString, vntErrorNumber, vntErrorDesc)
	If Not IsArray(arrOrgIDs) Then
		ReDim arrOrgIDs(3, 1)
		arrOrgIDs(0, 0) = vbNullString
		arrOrgIDs(1, 0) = vbNullString
		arrOrgIDs(2, 0) = vbNullString
		arrOrgIDs(3, 0) = FormatJSstring(vntErrorNumber)

		arrOrgIDs(0, 1) = vbNullString
		arrOrgIDs(1, 1) = vbNullString
		arrOrgIDs(2, 1) = vbNullString
		arrOrgIDs(3, 1) = FormatJSstring(vntErrorDesc)
	End If


''''''''''''''''''''''''''''''
'	Build Mfg Org ID Select
''''''''''''''''''''''''''''''
	selMfgOrgID = "SelectTag('selMfgOrgID', '', arrLoadingMsg, arrLoadingMsg, strMfgOrgIDDef)"
	arrMfgOrgIDs = objLoad.ListOrgIDs(vbNullString, vntErrorNumber, vntErrorDesc)
	If Not IsArray(arrMfgOrgIDs) Then
		ReDim arrMfgOrgIDs(3, 1)
		arrMfgOrgIDs(0, 0) = vbNullString
		arrMfgOrgIDs(1, 0) = vbNullString
		arrMfgOrgIDs(2, 0) = vbNullString
		arrMfgOrgIDs(3, 0) = FormatJSstring(vntErrorNumber)

		arrMfgOrgIDs(0, 1) = vbNullString
		arrMfgOrgIDs(1, 1) = vbNullString
		arrMfgOrgIDs(2, 1) = vbNullString
		arrMfgOrgIDs(3, 1) = FormatJSstring(vntErrorDesc)
	End If


''''''''''''''''''''''''''''''
'	Build Customer Org ID Select
''''''''''''''''''''''''''''''
	selCustOrgID = "SelectTag('selCustOrgID', '', arrCustOrgIDOpts, arrCustOrgIDVals, (frmMain.selCustOrgID.value ? frmMain.selCustOrgID.value : strCustOrgIDDef))"
	vntArray = objLoad.ListAcctOrgIds(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		push arrCustOrgIDVals, vbNullString
		push arrCustOrgIDOpts, vbNullString
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrCustOrgIDVals, FormatJSstring(vntArray(1, inxRow))
			push arrCustOrgIDOpts, FormatWords(vntArray(2, inxRow))
		Next
		Erase vntArray
	Else
		push arrCustOrgIDOpts, "Error!"
		push arrCustOrgIDOpts, FormatJSstring(vntErrorNumber)
		push arrCustOrgIDOpts, FormatJSstring(vntErrorDesc)
		push arrCustOrgIDVals, vbNullString
		push arrCustOrgIDVals, vbNullString
		push arrCustOrgIDVals, vbNullString
	End If
	vntArray = vbNullString
	Set objLoad = Nothing


''''''''''''''''''''''''''''''
'	Build Cust Acct Type Select
''''''''''''''''''''''''''''''
	selCustAcctType = "SelectTag('selCustAcctType', '', arrCustAcctTypeOpts, arrCustAcctTypeVals, (frmMain.selCustAcctType.value ? frmMain.selCustAcctType.value : strCustAcctTypeDef))"
	Set objLoad = Server.CreateObject("DSCD.clsCustomerType")
	vntArray = objLoad.ListCustTypes(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrCustAcctTypeVals, FormatJSstring(vntArray(0, inxRow))
			push arrCustAcctTypeOpts, FormatWords(vntArray(1, inxRow))
		Next
		Erase vntArray
	Else
		push arrCustAcctTypeOpts, "Error!"
		push arrCustAcctTypeOpts, FormatJSstring(vntErrorNumber)
		push arrCustAcctTypeOpts, FormatJSstring(vntErrorDesc)
		push arrCustAcctTypeVals, vbNullString
		push arrCustAcctTypeVals, vbNullString
		push arrCustAcctTypeVals, vbNullString
	End If
	vntArray = vbNullString
	Set objLoad = Nothing


''''''''''''''''''''''''''''''
'	Build Profit Center Select
''''''''''''''''''''''''''''''
	selProfitCtr = "SelectTag('selProfitCtr', '', arrProfitCtrOpts, arrProfitCtrVals, (frmMain.selProfitCtr.value ? frmMain.selProfitCtr.value : strProfitCtrDef))"
	Set objLoad = Server.CreateObject("DSCD.clsProfitCtr")
	vntArray = objLoad.ListProfitCtrs(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		push arrProfitCtrVals, vbNullString
		push arrProfitCtrOpts, vbNullString
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrProfitCtrVals, vntArray(0, inxRow)
			push arrProfitCtrOpts, vntArray(1, inxRow)
		Next
		Erase vntArray
	Else
		push arrProfitCtrOpts, "Error!"
		push arrProfitCtrOpts, FormatJSstring(vntErrorNumber)
		push arrProfitCtrOpts, FormatJSstring(vntErrorDesc)
		push arrProfitCtrVals, vbNullString
		push arrProfitCtrVals, vbNullString
		push arrProfitCtrVals, vbNullString
	End If
	vntArray = vbNullString
	Set objLoad = Nothing


''''''''''''''''''''''''''''''
'	Build Industry Business Select
''''''''''''''''''''''''''''''
	selIndustryBusCde = "SelectTag('selIndustryBusCde', '', arrIndustryBusCdeOpts, arrIndustryBusCdeVals, (frmMain.selIndustryBusCde.value ? frmMain.selIndustryBusCde.value : strIndustryBusCdeDef))"
	Set objLoad = Server.CreateObject("DSCD.clsIndustry")
	vntArray = objLoad.ListIBCs(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		push arrIndustryBusCdeVals, vbNullString
		push arrIndustryBusCdeOpts, vbNullString
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrIndustryBusCdeVals, vntArray(0, inxRow)
			push arrIndustryBusCdeOpts, vntArray(1, inxRow)
		Next
		Erase vntArray
	Else
		push arrIndustryBusCdeOpts, "Error!"
		push arrIndustryBusCdeOpts, FormatJSstring(vntErrorNumber)
		push arrIndustryBusCdeOpts, FormatJSstring(vntErrorDesc)
		push arrIndustryBusCdeVals, vbNullString
		push arrIndustryBusCdeVals, vbNullString
		push arrIndustryBusCdeVals, vbNullString
	End If
	vntArray = vbNullString
	Set objLoad = Nothing


''''''''''''''''''''''''''''''
'	Build Competency Business Select
''''''''''''''''''''''''''''''
	selCompetencyBusCde = "SelectTag('selCompetencyBusCde', '', arrCompetencyBusCdeOpts, arrCompetencyBusCdeVals, (frmMain.selCompetencyBusCde.value ? frmMain.selCompetencyBusCde.value : strCompetencyBusCdeDef))"
	Set objLoad = Server.CreateObject("DSCD.clsCompetencyBus")
	vntArray = objLoad.ListCBCs(vntErrorNumber, vntErrorDesc)
	If IsArray(vntArray) Then
		push arrCompetencyBusCdeVals, vbNullString
		push arrCompetencyBusCdeOpts, vbNullString
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			push arrCompetencyBusCdeVals, vntArray(0, inxRow)
			push arrCompetencyBusCdeOpts, vntArray(1, inxRow)
		Next
		Erase vntArray
	Else
		push arrCompetencyBusCdeOpts, "Error!"
		push arrCompetencyBusCdeOpts, FormatJSstring(vntErrorNumber)
		push arrCompetencyBusCdeOpts, FormatJSstring(vntErrorDesc)
		push arrCompetencyBusCdeVals, vbNullString
		push arrCompetencyBusCdeVals, vbNullString
		push arrCompetencyBusCdeVals, vbNullString
	End If
	vntArray = vbNullString
	Set objLoad = Nothing

	hdnFromDate			= "InputTag('text', 'hdnFromDate', frmMain.hdnFromDate.value, 'maxlength=10,size=12')"
	txtToDate			= "InputTag('text', 'txtToDate', frmMain.txtToDate.value, 'maxlength=10,size=12')"
	txtDaysEarly		= "InputTag('text', 'txtDaysEarly', frmMain.txtDaysEarly.value, 'maxlength=2,size=4')"
	txtDaysLate			= "InputTag('text', 'txtDaysLate', frmMain.txtDaysLate.value, 'maxlength=2,size=4')"
	'txtPartNbr			= "InputTag('text', 'txtPartNbr', frmMain.txtPartNbr.value, 'maxlength=11,size=12') + '&nbsp;&nbsp;<font size=""2""><b>(1-7-1)</b></font>'"
	txtPartNbr			= "InputTag('text', 'txtPartNbr', frmMain.txtPartNbr.value, 'maxlength=50,size=20')"
	txtInvOrgPlant		= "InputTag('text', 'txtInvOrgPlant', frmMain.txtInvOrgPlant.value, 'size=14')"
	txtController		= "InputTag('text', 'txtController', frmMain.txtController.value, 'size=12')"
	txtCntrllerEmpNbr	= "InputTag('text', 'txtCntrllerEmpNbr', frmMain.txtCntrllerEmpNbr.value, 'size=12')"
	txtPlantBldgNbr		= "InputTag('text', 'txtPlantBldgNbr', frmMain.txtPlantBldgNbr.value, 'size=14')"
	txtLocation			= "InputTag('text', 'txtLocation', frmMain.txtLocation.value, 'size=14')"
	'txtCustomerNbr		= "InputTag('text', 'txtCustomerNbr', frmMain.txtCustomerNbr.value, 'maxlength=12,size=14')"
	txtShipTo			= "InputTag('text', 'txtShipTo', frmMain.txtShipTo.value, 'maxlength=12,size=14')"
	txtSoldTo			= "InputTag('text', 'txtSoldTo', frmMain.txtSoldTo.value, 'maxlength=12,size=14')"
	txtWWNbr			= "InputTag('text', 'txtWWNbr', frmMain.txtWWNbr.value, 'maxlength=12,size=14')"
	txtMakeStock		= "InputTag('text', 'txtMakeStock', frmMain.txtMakeStock.value, 'size=14')"
	txtTeam				= "InputTag('text', 'txtTeam', frmMain.txtTeam.value, 'size=14')"
	txtProductCode		= "InputTag('text', 'txtProductCode', frmMain.txtProductCode.value, 'size=14')"
	txtGblProductLine	= "InputTag('text', 'txtGblProductLine', frmMain.txtGblProductLine.value, 'size=14')"
	txtProdMgr			= "InputTag('text', 'txtProdMgr', frmMain.txtProdMgr.value, 'size=30')"
	txtIndustryCde		= "InputTag('text', 'txtIndustryCde', frmMain.txtIndustryCde.value, 'size=14')"
	txtMfgCampusID		= "InputTag('text', 'txtMfgCampusID', frmMain.txtMfgCampusID.value, 'size=14')"
	txtMfgBldgNbr		= "InputTag('text', 'txtMfgBldgNbr', frmMain.txtMfgBldgNbr.value, 'size=14')"
	txtSubCompetencyBusCde = "InputTag('text', 'txtSubCompetencyBusCde', frmMain.txtSubCompetencyBusCde.value, 'size=14')"
	txtOrgDt			= "InputTag('text', 'txtOrgDt', frmMain.txtOrgDt.value, 'maxlength=10,size=14')"
	txtSalesOffice		= "InputTag('text', 'txtSalesOffice', frmMain.txtSalesOffice.value, 'size=14')"
	txtSalesGroup		= "InputTag('text', 'txtSalesGroup', frmMain.txtSalesGroup.value, 'size=14')"
	txtMrpGroup		    = "InputTag('text', 'txtMrpGroup', frmMain.txtMrpGroup.value, 'size=14')"
	txtProdHostOrgID    = "InputTag('text', 'txtProdHostOrgID', frmMain.txtProdHostOrgID.value, 'size=14')"

	hdnDateFormat			= "InputTag('radio', 'hdnDateFormat', '1', 'onclick=format_dates();refresh_screen(4);') + '&nbsp;YYYY" & strDATE_DELIMITER & "MM&nbsp;&nbsp;' + InputTag('radio', 'hdnDateFormat', '2', 'onclick=format_dates();refresh_screen(5);') + '&nbsp;YYYY" & strDATE_DELIMITER & "MM" & strDATE_DELIMITER & "DD'"
	hdnDateFormat_HidePart	= "InputTag('radio', 'hdnDateFormat', '1', 'onclick=refresh_screen(4);') + '&nbsp;YYYY" & strDATE_DELIMITER & "MM&nbsp;&nbsp;' + InputTag('radio', 'hdnDateFormat', '2', 'onclick=refresh_screen(5);') + '&nbsp;YYYY" & strDATE_DELIMITER & "MM" & strDATE_DELIMITER & "DD'"
	rdoOrgHierarchy			= "InputTag('radio', 'rdoOrgHierarchy', 'C', 'onclick=refresh_screen(6);') + '&nbsp;Current&nbsp;&nbsp;' + InputTag('radio', 'rdoOrgHierarchy', 'H', 'onclick=refresh_screen(7);') + '&nbsp;Historical'"
	rdoShipOpen				= "InputTag('radio', 'rdoShipOpen', '1', '') + '&nbsp;Shipped&nbsp;&nbsp;' + InputTag('radio', 'rdoShipOpen', '2', '') + '&nbsp;Open'"

	chkExport	= "InputTag('checkbox', 'chkExport', '1', '')"
	chkByCountry = "InputTag('checkbox', 'chkByCountry', '1', '')"
	chkBySTCntry = "InputTag('checkbox', 'chkBySTCntry', '2', '')"
	Set objLoad = Nothing
End Sub


Sub InitElementLabelStrings()
If blnDebug Then RwLf "InitElementLabelStrings()<br>"

	selView_Lbl			= "Select&nbsp;View:"
	selCategory_Lbl		= "Select&nbsp;Category:"
	selWindow_Lbl		= "Select&nbsp;Window:"
	selSummaryType_Lbl	= "Summary&nbsp;Type:&nbsp;&nbsp;"
	selComparison_Lbl	= "Comparison:&nbsp;&nbsp;"
	selOrgType_Lbl		= "Org&nbsp;Type:&nbsp;&nbsp;"
	selOrgID_Lbl		= "Org Id:&nbsp;&nbsp;"
	selCustAcctType_Lbl	= "Customer Account Type:&nbsp;&nbsp;"
	selCustOrgID_Lbl	= "Customer Org ID:&nbsp;&nbsp;"
	selLeadTimeType_Lbl	= "Lead-time Type:&nbsp;&nbsp;"
	selMfgOrgType_Lbl	= "Mfg Org Type:&nbsp;&nbsp;"
	selMfgOrgID_Lbl		= "Mfg Org Id:&nbsp;&nbsp;"
	selProfitCtr_Lbl	= "Profit Center:&nbsp;&nbsp;"
	selIndustryBusCde_Lbl	= "Industry Business:&nbsp;&nbsp;"
	selCompetencyBusCde_Lbl	= "Competency Business:&nbsp;&nbsp;"

	hdnFromDate_Lbl			= "Date&nbsp;Range:&nbsp;&nbsp;"
	txtToDate_Lbl			= "&nbsp;To&nbsp;"
	txtDaysEarly_Lbl		= "Days&nbsp;Early:&nbsp;&nbsp;"
    txtDaysEarlyAll_Lbl		= "All&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	txtDaysLate_Lbl			= "&nbsp;&nbsp;Late:&nbsp;&nbsp;"
	txtPartNbr_Lbl			= "Part&nbsp;Nbr:&nbsp;&nbsp;"
	txtCntrllerEmpNbr_Lbl	= "Controller Employee Nbr:&nbsp;&nbsp;"
	txtPlantBldgNbr_Lbl		= "Plant/Bldg Number:&nbsp;&nbsp;"
	txtLocation_Lbl			= "Location:&nbsp;&nbsp;"
	'txtCustomerNbr_Lbl		= "Customer Nbr:&nbsp;&nbsp;"
	txtShipTo_Lbl			= "Ship To:&nbsp;&nbsp;"
	txtSoldTo_Lbl			= "Sold To:&nbsp;&nbsp;"
	txtWWNbr_Lbl			= "Worldwide Number:&nbsp;&nbsp;"
	txtMakeStock_Lbl		= "Make Stock:&nbsp;&nbsp;"
	txtTeam_Lbl				= "&nbsp;Team:&nbsp;&nbsp;"
	txtProductCode_Lbl		= "Product Code:&nbsp;&nbsp;"
	txtGblProductLine_Lbl	= "GPL:&nbsp;&nbsp;"
	txtProdMgr_Lbl			= "Product Mgr. (Last,First):&nbsp;&nbsp;"
	txtIndustryCde_Lbl		= "Industry:&nbsp;&nbsp;"
	txtMfgCampusID_Lbl		= "Mfg Campus:&nbsp;&nbsp;"
	txtMfgBldgNbr_Lbl		= "Mfg Bldg Number:&nbsp;&nbsp;"
	txtSubCompetencyBusCde_Lbl	= "Sub-Competency Business:&nbsp;&nbsp;"
	txtOrgDt_Lbl			= "Org Date:&nbsp;&nbsp;"
	txtSalesOffice_Lbl		= "SAP Sales Office:&nbsp;&nbsp;"
	txtSalesGroup_Lbl		= "SAP Sales Group:&nbsp;&nbsp;"
	txtPlant_Lbl			= "Plant:&nbsp;&nbsp;"

	hdnDateFormat_Lbl	= "Monthly / Daily:&nbsp;&nbsp;"
	rdoOrgHierarchy_Lbl	= "Org Hierarchy:&nbsp;&nbsp;"
	rdoShipOpen_Lbl		= "Status:&nbsp;&nbsp;"

	chkExport_Lbl	= "Export&nbsp;Only:&nbsp;&nbsp;"
	chkByCountry_Lbl = "&nbsp;By Country"
	chkBySTCntry_Lbl = "&nbsp;By Ship-To Country"
End Sub


Sub GenHtmlHead()
If blnDebug Then RwLf "GenHtmlHead()<br>"

	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>" & Application("AppAbrv") & " - " & "Search</title>"

	If Not blnError Then
		GenJSCommonFunctions
		GenJS_Constants
		GenJS_refresh_screen
		GenJS_command_functions
		GenJS_check_edits
		GenJS_errHandler
		GenJS_StartUp
	End If

	RwLf "</head>"
	RwLf "<body bgcolor=""#FFFFFF"""
	RwLf " TOPMARGIN=""1"""
	RwLf " ALINK=""Lime"""
	RwLf " VLINK=""Red"""
	RwLf " LINK=""Red"""
	RwLf " style=""font-family: Times New Roman, sans-serif"" onload=""start_up();"">"

	RwLf "<table border=""1"" bordercolor=""" & sNavBorder & """ cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "<td>"
	RwLf "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "	<tr " & sNavTopHeader & ">"
	RwLf "		<td width=""20%"" align=""center""><a href=""home.asp"">Home</a></td>"
	If blnNS Then
		RwLf "	<td width=""60%"" align=""center"" colspan=""3""><font size=""2"">Note:&nbsp;&nbsp;If you are using Netscape Navigator, resizing this window will reset your entries.</font></td>"
	Else
		RwLf "	<td width=""20%"">&nbsp;</td>"
		RwLf "	<td width=""20%"">&nbsp;</td>"
		RwLf "	<td width=""20%"">&nbsp;</td>"
	End If
	RwLf "		<td width=""20%"" align=""center"">"
	RwLf "		<a href=" & strServerUrl & appHelp & Application("Help") & " target=""Help Window"">Help</a></td>"
%>
<!--#include file=include/NavMiddle.inc-->
<%
	RwLf "	<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Search Criteria</b></font></td>"
%>
<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
	RwLf "<br>"
End Sub


Sub GenHtmlFoot()
If blnDebug Then RwLf "GenHtmlFoot()<br>"

	RwLf "</body>"
	RwLf "</html>"
End Sub


Sub TellUserToUpdateBrowser()
If blnDebug Then RwLf "TellUserToUpdateBrowser()<br>"

	'RwLf "<?xml version=""1.0"" encoding=""UTF-8""?>"
	'RwLf "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN""" & vbcrlf & "			""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">"
	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>" & Application("AppAbrv") & " - " & "Browser Needs Updated</title>"
	RwLf "</head>"
%>
<!--#include file=include/NavBegin.inc-->
<%
	RwLf "	<td width=""20%"" align=""center""><a href=""home.asp"">Home</a></td>"
	RwLf "	<td width=""20%"">&nbsp;</td>"
	RwLf "	<td width=""20%"">&nbsp;</td>"
	RwLf "	<td width=""20%"">&nbsp;</td>"
	RwLf "	<td width=""20%"" align=""center"">"
	RwLf "		<a href=" & strServerUrl & appHelp & Application("Help") & " target=""Help Window"">Help</a></td>"
%>
<!--#include file=include/NavMiddle.inc-->
<%
	RwLf "	<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Search Criteria</b></font></td>"
%>
<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
	RwLf "<br>"
	RwLf "<h3>You are currently using " & strBrowser & " " & strBrowserVer & " running on " & strOS & "</h3>"
	RwLf "<h3>The search screen requires Microsoft Internet Explorer 5 or higher or Netscape 4 or higher.</h3>"
	RwLf "<h3>Please contact your LAN Administrator for an upgrade.</h3>"

	GenHTMLFoot
End Sub


Sub DisplayError()
If blnDebug Then RwLf "DisplayError()<br>"

	'RwLf "<?xml version=""1.0"" encoding=""UTF-8""?>"
	'RwLf "<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN""" & vbcrlf & "			""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">"
	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>" & Application("AppAbrv") & " - " & "Error!</title>"
	RwLf "</head>"
%>
<!--#include file=include/NavBegin.inc-->
<%
	RwLf "	<td width=""20%"" align=""left""><a href=""home.asp"">Home</a></td>"
	RwLf "	<td width=""20%"">&nbsp;</td>"
	RwLf "	<td width=""20%"">&nbsp;</td>"
	RwLf "	<td width=""20%"">&nbsp;</td>"
	RwLf "	<td width=""20%"" align=""right"">"
	RwLf "		<a href=" & strServerUrl & appHelp & Application("Help") & " target=""Help Window"">Help</a></td>"
%>
<!--#include file=include/NavMiddle.inc-->
<%
	RwLf "	<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Search Criteria</b></font></td>"
%>
<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
	RwLf "<br>"
	RwLf "<h3>The Following Error Was Encountered In " & errWhere & ":</h3><br>"
	RwLf "<h3>" & objError & "</h3><br>"
	RwLf "<h3>" & errDesc & "</h3><br>"
	RwLf "<form name=""frmSearch"" id=""frmSearch"" action=""search.asp?s=" & vntSessionID & """ method=""post"">"
	RwLf "<input type=""submit"" value=""Continue"">"
	RwLf "</form>"
	GenHTMLFoot

End Sub


Sub DisplayScreen()
If blnDebug Then RwLf "DisplayScreen()<br>"

	GenHtmlHead

	RwLf "<form name=""frmSearch"" id=""frmSearch"" action=""search.asp?s=" & vntSessionID & """ method=""post"">"

	HiddenVars

	RwLf strTopButtons

	RwLf "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""2"" align=""center"" name=""tblMain"" id=""tblMain"">"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<tr bgcolor=""lightgrey"">"
	RwLf "	<td align=""left"" colspan=""3"">"
	RwLf "	<font size=""4"" color=""navy""><b>Select View and Category</b></font></td>"
	RwLf "</tr>"

	RwLf "<tr>"
	RwLf "	<td width=""34%"" align=""left"">" & strDefFormat & selView_Lbl & strEndDefFormat & "</td>"
	RwLf "	<td width=""33%"" align=""left"">" & strDefFormat & selCategory_Lbl & strEndDefFormat & "</td>"
	RwLf "	<td width=""33%"" align=""left"">" & strDefFormat & selWindow_Lbl & strEndDefFormat & "</td>"
	RwLf "</tr>"

	RwLf "<tr>"
	RwLf "	<td align=""center"">"
	RwLf selView
	RwLf "	</td>"
	RwLf "	<td align=""center"">"
	RwLf selCategory
	RwLf "	</td>"
	RwLf "	<td align=""center"">"
	RwLf selWindow
	RwLf "	</td>"
	RwLf "</tr>"

	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"
	RwLf "</table>"
	If blnJSDebug Then RwLf "<textarea name=""txaDebug"" id=""txaDebug"" rows=""20"" style=""width:100%""></textarea>"
	RwLf "</form>"

	RwLf "<span id=""spnCriteria"" style=""position:absolute""></span>"

	GenHtmlFoot
End Sub


Sub HiddenVars()
If blnDebug Then RwLf "HiddenVars()<br>"

	'Misc
	RwLf "<input type=""hidden"" name=""hdnCommand"" id=""hdnCommand"" value="""">"

	Rw "<input type=""hidden"" name=""hdnBrowser"" id=""hdnBrowser"" value="""
	Rw strBrowser
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnBrowserVer"" id=""hdnBrowserVer"" value="""
	Rw strBrowserVer
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnOS"" id=""hdnOS"" value="""
	Rw strOS
	RwLf """>"

	'List Box Values
	Rw "<input type=""hidden"" name=""hdnView"" id=""hdnView"" value="""
	If IsNull(vntView) Or vntView = vbNullString Then vntView = vntViewDef
	Rw vntView
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnCategory"" id=""hdnCategory"" value="""
	If IsNull(vntCategory) Or vntCategory = vbNullString Then vntCategory = vntCategoryDef
	Rw vntCategory
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnWindow"" id=""hdnWindow"" value="""
	If IsNull(vntWindow) Or vntWindow = vbNullString Then vntWindow = vntWindowDef
	Rw vntWindow
	RwLf """>"


	Rw "<input type=""hidden"" name=""selSummaryType"" id=""selSummaryType"" value="""
	If IsNull(vntSummaryType) Or vntSummaryType = vbNullString Then vntSummaryType = vntSummaryTypeDef
	Rw vntSummaryType
	RwLf """>"

	Rw "<input type=""hidden"" name=""selComparison"" id=""selComparison"" value="""
	If IsNull(vntComparison) Or vntComparison = vbNullString Then vntComparison = vntComparisonDef
	Rw vntComparison
	RwLf """>"

	Rw "<input type=""hidden"" name=""selLeadTimeType"" id=""selLeadTimeType"" value="""
	If IsNull(vntLeadTimeType) Or vntLeadTimeType = vbNullString Then vntLeadTimeType = vntLeadTimeTypeDef
	Rw vntLeadTimeType
	RwLf """>"

	Rw "<input type=""hidden"" name=""selOrgType"" id=""selOrgType"" value="""
	If IsNull(vntOrgType) Or vntOrgType = vbNullString Then vntOrgType = vntOrgTypeDef
	Rw vntOrgType
	RwLf """>"

	Rw "<input type=""hidden"" name=""selMfgOrgType"" id=""selMfgOrgType"" value="""
	If IsNull(vntMfgOrgType) Or vntMfgOrgType = vbNullString Then vntMfgOrgType = vntMfgOrgTypeDef
	Rw vntMfgOrgType
	RwLf """>"

	Rw "<input type=""hidden"" name=""selOrgID"" id=""selOrgID"" value="""
	If IsNull(vntOrgID) Or vntOrgID = vbNullString Then vntOrgID = vntOrgIDDef
	Rw vntOrgID
	RwLf """>"

	Rw "<input type=""hidden"" name=""selMfgOrgID"" id=""selMfgOrgID"" value="""
	If IsNull(vntMfgOrgID) Or vntMfgOrgID = vbNullString Then vntMfgOrgID = vntMfgOrgIDDef
	Rw vntMfgOrgID
	RwLf """>"

	Rw "<input type=""hidden"" name=""selCustAcctType"" id=""selCustAcctType"" value="""
	If IsNull(vntCustAcctType) Or vntCustAcctType = vbNullString Then vntCustAcctType = vntCustAcctTypeDef
	Rw vntCustAcctType
	RwLf """>"

	Rw "<input type=""hidden"" name=""selCustOrgID"" id=""selCustOrgID"" value="""
	If IsNull(vntCustOrgID) Or vntCustOrgID = vbNullString Then vntCustOrgID = vntCustOrgIDDef
	Rw vntCustOrgID
	RwLf """>"

	'Textbox Values
	Rw "<input type=""hidden"" name=""hdnFromDate"" id=""hdnFromDate"" value="""
	If IsNull(vntFromDate) Or vntFromDate = vbNullString Then vntFromDate = vntFromDateDef
	Rw vntFromDate
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtToDate"" id=""txtToDate"" value="""
	If IsNull(vntToDate) Or vntToDate = vbNullString Then vntToDate = vntToDateDef
	Rw vntToDate
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtDaysEarly"" id=""txtDaysEarly"" value="""
	If IsNull(vntDaysEarly) Or vntDaysEarly = vbNullString Then vntDaysEarly = vntDaysEarlyDef
	Rw vntDaysEarly
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtDaysLate"" id=""txtDaysLate"" value="""
	If IsNull(vntDaysLate) Or vntDaysLate = vbNullString Then vntDaysLate = vntDaysLateDef
	Rw vntDaysLate
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtPartNbr"" id=""txtPartNbr"" value="""
	If IsNull(vntPartNbr) Or vntPartNbr = vbNullString Then vntPartNbr = vntPartNbrDef
	Rw vntPartNbr
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnPartNbr"" id=""hdnPartNbr"" value="""
	If IsNull(vntPartNbr) Or vntPartNbr = vbNullString Then vntPartNbr = vntPartNbrDef
	Rw vntPartNbr
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnPartKeyID"" id=""hdnPartKeyID"" value="""
	If IsNull(vntPartKeyID) Or vntPartKeyID = vbNullString Then vntPartKeyID = null
	Rw vntPartKeyID
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtInvOrgPlant"" id=""txtInvOrgPlant"" value="""
	If IsNull(vntInvOrgPlant) Or vntInvOrgPlant = vbNullString Then vntInvOrgPlant = vntInvOrgPlantDef
	Rw vntInvOrgPlant
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnInvOrgPlant"" id=""hdnInvOrgPlant"" value="""
	If IsNull(vntInvOrgPlant) Or vntInvOrgPlant = vbNullString Then vntInvOrgPlant = vntInvOrgPlantDef
	Rw vntInvOrgPlant
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtController"" id=""txtController"" value="""
	If IsNull(vntController) Or vntController = vbNullString Then vntController = vntControllerDef
	Rw vntController
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnController"" id=""hdnController"" value="""
	If IsNull(vntController) Or vntController = vbNullString Then vntController = vntControllerDef
	Rw vntController
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtCntrllerEmpNbr"" id=""txtCntrllerEmpNbr"" value="""
	If IsNull(vntCntrllerEmpNbr) Or vntCntrllerEmpNbr = vbNullString Then vntCntrllerEmpNbr = vntCntrllerEmpNbrDef
	Rw vntCntrllerEmpNbr
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtPlantBldgNbr"" id=""txtPlantBldgNbr"" value="""
	If IsNull(vntPlantBldgNbr) Or vntPlantBldgNbr = vbNullString Then vntPlantBldgNbr = vntPlantBldgNbrDef
	Rw vntPlantBldgNbr
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtLocation"" id=""txtLocation"" value="""
	If IsNull(vntLocation) Or vntLocation = vbNullString Then vntLocation = vntLocationDef
	Rw vntLocation
	RwLf """>"

	'Rw "<input type=""hidden"" name=""txtCustomerNbr"" id=""txtCustomerNbr"" value="""
	'If IsNull(vntCustomerNbr) Or vntCustomerNbr = vbNullString Then vntCustomerNbr = vntCustomerNbrDef
	'Rw vntCustomerNbr
	'RwLf """>"

	Rw "<input type=""hidden"" name=""txtShipTo"" id=""txtShipTo"" value="""
	If IsNull(vntShipTo) Or vntShipTo = vbNullString Then vntShipTo = vntShipToDef
	Rw vntShipTo
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtSoldTo"" id=""txtSoldTo"" value="""
	If IsNull(vntSoldTo) Or vntSoldTo = vbNullString Then vntSoldTo = vntSoldToDef
	Rw vntSoldTo
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtWWNbr"" id=""txtWWNbr"" value="""
	If IsNull(vntWWNbr) Or vntWWNbr = vbNullString Then vntWWNbr = vntWWNbrDef
	Rw vntWWNbr
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtMakeStock"" id=""txtMakeStock"" value="""
	If IsNull(vntMakeStock) Or vntMakeStock = vbNullString Then vntMakeStock = vntMakeStockDef
	Rw vntMakeStock
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtTeam"" id=""txtTeam"" value="""
	If IsNull(vntTeam) Or vntTeam = vbNullString Then vntTeam = vntTeamDef
	Rw vntTeam
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtProductCode"" id=""txtProductCode"" value="""
	If IsNull(vntProductCode) Or vntProductCode = vbNullString Then vntProductCode = vntProductCodeDef
	Rw vntProductCode
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtGblProductLine"" id=""txtGblProductLine"" value="""
	If IsNull(vntGblProductLine) Or vntGblProductLine = vbNullString Then vntGblProductLine = vntGblProductLineDef
	Rw vntGblProductLine
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtProdMgr"" id=""txtProdMgr"" value="""
	If IsNull(vntProdMgr) Or vntProdMgr = vbNullString Then vntProdMgr = vntProdMgrDef
	Rw vntProdMgr
	RwLf """>"

	Rw "<input type=""hidden"" name=""selIndustryBusCde"" id=""selIndustryBusCde"" value="""
	If IsNull(vntIndustryBusCde) Or vntIndustryBusCde = vbNullString Then vntIndustryBusCde = vntIndustryBusCdeDef
	Rw vntIndustryBusCde
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtIndustryCde"" id=""txtIndustryCde"" value="""
	If IsNull(vntIndustryCde) Or vntIndustryCde = vbNullString Then vntIndustryCde = vntIndustryCdeDef
	Rw vntIndustryCde
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtMfgCampusID"" id=""txtMfgCampusID"" value="""
	If IsNull(vntMfgCampusID) Or vntMfgCampusID = vbNullString Then vntMfgCampusID = vntMfgCampusIDDef
	Rw vntMfgCampusID
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtMfgBldgNbr"" id=""txtMfgBldgNbr"" value="""
	If IsNull(vntMfgBldgNbr) Or vntMfgBldgNbr = vbNullString Then vntMfgBldgNbr = vntMfgBldgNbrDef
	Rw vntMfgBldgNbr
	RwLf """>"

	Rw "<input type=""hidden"" name=""selProfitCtr"" id=""selProfitCtr"" value="""
	If IsNull(vntProfitCtr) Or vntProfitCtr = vbNullString Then vntProfitCtr = vntProfitCtrDef
	Rw vntProfitCtr
	RwLf """>"

	Rw "<input type=""hidden"" name=""selCompetencyBusCde"" id=""selCompetencyBusCde"" value="""
	If IsNull(vntCompetencyBusCde) Or vntCompetencyBusCde = vbNullString Then vntCompetencyBusCde = vntCompetencyBusCdeDef
	Rw vntCompetencyBusCde
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtSubCompetencyBusCde"" id=""txtSubCompetencyBusCde"" value="""
	If IsNull(vntSubCompetencyBusCde) Or vntSubCompetencyBusCde = vbNullString Then vntSubCompetencyBusCde = vntSubCompetencyBusCdeDef
	Rw vntSubCompetencyBusCde
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtOrgDt"" id=""txtOrgDt"" value="""
	If IsNull(vntOrgDt) Or vntOrgDt = vbNullString Then vntOrgDt = vntOrgDtDef
	Rw vntOrgDt
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtSalesOffice"" id=""txtSalesOffice"" value="""
	If IsNull(vntSalesOffice) Or vntSalesOffice = vbNullString Then vntSalesOffice = vntSalesOfficeDef
	Rw vntSalesOffice
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnSalesOffice"" id=""hdnSalesOffice"" value="""
	If IsNull(vntSalesOffice) Or vntSalesOffice = vbNullString Then vntSalesOffice = vntSalesOfficeDef
	Rw vntSalesOffice
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtSalesGroup"" id=""txtSalesGroup"" value="""
	If IsNull(vntSalesGroup) Or vntSalesGroup = vbNullString Then vntSalesGroup = vntSalesGroupDef
	Rw vntSalesGroup
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnSalesGroup"" id=""hdnSalesGroup"" value="""
	If IsNull(vntSalesGroup) Or vntSalesGroup = vbNullString Then vntSalesGroup = vntSalesGroupDef
	Rw vntSalesGroup
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtMrpGroup"" id=""txtMrpGroup"" value="""
	If IsNull(vntMrpGroup) Or vntMrpGroup = vbNullString Then vntMrpGroup = vntMrpGroupDef
	Rw vntMrpGroup
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnMrpGroup"" id=""hdnMrpGroup"" value="""
	If IsNull(vntMrpGroup) Or vntMrpGroup = vbNullString Then vntMrpGroup = vntMrpGroupDef
	Rw vntMrpGroup
	RwLf """>"

	Rw "<input type=""hidden"" name=""txtProdHostOrgID"" id=""txtProdHostOrgID"" value="""
	If IsNull(vntProdHostOrgID) Or vntProdHostOrgID = vbNullString Then vntProdHostOrgID = vntProdHostOrgIDDef
	Rw vntProdHostOrgID
	RwLf """>"

	Rw "<input type=""hidden"" name=""hdnProdHostOrgID"" id=""hdnProdHostOrgID"" value="""
	If IsNull(vntProdHostOrgID) Or vntProdHostOrgID = vbNullString Then vntProdHostOrgID = vntProdHostOrgIDDef
	Rw vntProdHostOrgID
	RwLf """>"

	'Radio Values
	Rw "<input type=""hidden"" name=""hdnDateFormat"" id=""hdnDateFormat"" value="""
	If IsNull(vntDateFormat) Or vntDateFormat = vbNullString Then vntDateFormat = vntDateFormatDef
	Rw vntDateFormat
	RwLf """>"

	Rw "<input type=""hidden"" name=""rdoOrgHierarchy"" id=""rdoOrgHierarchy"" value="""
	If IsNull(vntOrgHierarchy) Or vntOrgHierarchy = vbNullString Then vntOrgHierarchy = vntOrgHierarchyDef
	Rw vntOrgHierarchy
	RwLf """>"

	Rw "<input type=""hidden"" name=""rdoShipOpen"" id=""rdoShipOpen"" value="""
	If IsNull(vntShipOpen) Or vntShipOpen = vbNullString Then vntShipOpen = vntShipOpenDef
	Rw vntShipOpen
	RwLf """>"

	'checkboxes
	Rw "<input type=""hidden"" name=""chkExport"" id=""chkExport"" value=""0"">"
	Rw "<input type=""hidden"" name=""chkByCountry"" id=""chkByCountry"" value=""0"">"
	Rw "<input type=""hidden"" name=""chkBySTCntry"" id=""chkBySTCntry"" value=""0"">"

End Sub



'***********************************************************************
'*********	Building Javascript Functions
'***********************************************************************

Sub GenJS_StartUp()
If blnDebug Then RwLf "GenJS_StartUp()<br>"

%>
	<script language="javascript">
	<!--

	var frmMain;

	function cookie_check()
	{

		var blnSubmitted = false;
		var arrCookies = document.cookie.split('; ');
		var ckTempCookie = '';
		var strCkName = '';
		var strCkValue = '';
		var i;

		//looking for cookie to see if this page is fresh
		for(i in arrCookies){
			ckTempCookie = arrCookies[i].split('=');
			strCkName = ckTempCookie[0];
			if(ckTempCookie.length > 1){
				strCkValue = ckTempCookie[1];
			}
			blnSubmitted = (strCkName == escape('ckiSubmitted'));
			if(blnSubmitted)	break;
		}

		return (blnSubmitted);
	}

	function start_up(){
		if(cookie_check()){
			window.location.reload();
		}
		else{
			frmMain = document.frmSearch;
			MM_reloadPage(true);
			if(ErrHandler())	refresh_screen(0);
		}
	}

	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
	    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}

	// -->
	</script>
<%
End Sub

Sub GenJS_Constants()
If blnDebug Then RwLf "GenJS_Constants()<br>"
	Dim inx, inxView, inxRow, inxCol
%>
	<script language="javascript">
	<!--
		var strDefFormat				= '<%=Replace(strDefFormat, "/", "\/")%>';
		var strEndDefFormat				= '<%=Replace(strEndDefFormat, "/", "\/")%>';
		var strDefDateRange_inDays		= 7;
		var intMILLISECS_PER_SECOND		= 1000;
		var intMILLISECS_PER_MINUTE		= intMILLISECS_PER_SECOND * 60;
		var intMILLISECS_PER_HOUR		= intMILLISECS_PER_MINUTE * 60;
		var intMILLISECS_PER_DAY		= intMILLISECS_PER_HOUR * 24;
		var intMILLISECS_PER_WEEK		= intMILLISECS_PER_DAY * 7;
		var strDATE_DELIMITER			= '<%=strDATE_DELIMITER%>';
		var intMaxDateRange_inDays		= 42;
		var intMinDateRange_inDays		= 1;
		var intMaxDateRange_inMonths	= 1;
		var intMinDateRange_inMonths	= 1;
		var intMaxDateRange_inMonths_LT	= 2;
		var intMaxDaysEarly				= 6;
		var intMinDaysEarly				= 1;
		var intMaxDaysLate				= 6;
		var intMinDaysLate				= 1;

		var blnSelWindowEnabled = true;

		//reg expression constants
		var rexMonthly		= /^\d\d\d\d<%=strDATE_DELIMITER%>\d?\d$/;
		var rexDaily		= /^\d\d\d\d<%=strDATE_DELIMITER%>\d?\d<%=strDATE_DELIMITER%>\d?\d$/;
		var rexWhitespace	= /\s/g;

		//hdnDateFormat constants
		var inxMonthly	= 0;
		var inxDaily	= 1;

		//Load View arrays
		var arrViewOpts	= new Array('<%=join(arrViewOpts, "', '")%>');
		var arrViewVals	= new Array('<%=join(arrViewVals, "', '")%>');
		var strViewDef	= '<%=vntViewDef%>';

		//values of selView
		var valOrganization	= '<%=valOrganization%>';
		var valBldgLocation	= '<%=valBldgLocation%>';
		var valCustWW		= '<%=valCustWW%>';
		var valShippingFac	= '<%=valShippingFac%>';
		var valTeam			= '<%=valTeam%>';
		var valController	= '<%=valController%>';
		var valMakeStock	= '<%=valMakeStock%>';
		var valProdCode		= '<%=valProdCode%>';
		var valIndustryCde	= '<%=valIndustryCde%>';
		var valMfgBldg		= '<%=valMfgBldg%>';
		var valProfitCtr	= '<%=valProfitCtr%>';
		var valSAPSales		= '<%=valSAPSales%>';

		//category value constants
		var valSummary				= '<%=valSummary%>';
		var valNonConforming		= '<%=valNonConforming%>';
		var valConforming			= '<%=valConforming%>';
		var valPastDue				= '<%=valPastDue%>';
		var valOpen					= '<%=valOpen%>';
		var valLeadTime				= '<%=valLeadTime%>';
		var valOrganizationYTD		= '<%=valOrganizationYTD%>';
		var valBldgList				= '<%=valBldgList%>';
		var valLocList				= '<%=valLocList%>';
		var valCustList				= '<%=valCustList%>';
		var valWWList				= '<%=valWWList%>';
		var valOrgList				= '<%=valOrgList%>';
		var valShipFacList			= '<%=valShipFacList%>';
		var valTeamList				= '<%=valTeamList%>';
		var valControllerList		= '<%=valControllerList%>';
		var valMakeStockList		= '<%=valMakeStockList%>';
		var valGPLList				= '<%=valGPLList%>';
		var valPCList				= '<%=valPCList%>';
		var valIndustryList			= '<%=valIndustryList%>';
		var valIBCList				= '<%=valIBCList%>';
		var valCampusList			= '<%=valCampusList%>';
		var valCmpBldgList			= '<%=valCmpBldgList%>';
		var valProfitCtrList		= '<%=valProfitCtrList%>';
		var valCompetencyBusList	= '<%=valCompetencyBusList%>';
		var valSalesOfficeList		= '<%=valSalesOfficeList%>';
		var valSalesGroupList		= '<%=valSalesGroupList%>';
		var valOpenSmry				= '<%=valOpenSmry%>';
		var valOpenNonConform		= '<%=valOpenNonConform%>';

		var arrCategoryOpts	= new Array();
		var arrCategoryVals	= new Array();

		//Load Category arrays
<%
'-----------------------------------------------------------
	FOR inxView = LBOUND(arrViewVals) TO UBOUND(arrViewVals)
%>
		arrCategoryOpts[<%=inxView%>]	= new Array('<%=join(arrCategoryOpts(inxView), "', '")%>');
		arrCategoryVals[<%=inxView%>]	= new Array('<%=join(arrCategoryVals(inxView), "', '")%>');
<%
	NEXT
'-----------------------------------------------------------
%>

		var arrWindowOpts	= new Array('<%=join(arrWindowOpts, "', '")%>');
		var arrWindowVals	= new Array('<%=join(arrWindowVals, "', '")%>');
		var strWindowDef	= <%=vntWindowDef%>;

		//values of selWindow
		var strCustomerVariable	= '1';
		var strStandardDefault	= '2';

		//Drop down constants
		var arrSummaryTypeOpts		= new Array();
		var arrSummaryTypeVals		= new Array();
		var strSummaryTypeDef		= '<%=vntSummaryTypeDef%>';
		var arrSummaryTypeOpts_CV	= new Array('<%=arrSummaryTypeOpts(0)%>', '<%=arrSummaryTypeOpts(1)%>');
		var arrSummaryTypeVals_CV	= new Array('<%=arrSummaryTypeVals(0)%>', '<%=arrSummaryTypeVals(1)%>');
		var arrSummaryTypeOpts_SD	= new Array('<%=join(arrSummaryTypeOpts, "', '")%>');
		var arrSummaryTypeVals_SD	= new Array('<%=join(arrSummaryTypeVals, "', '")%>');
		var arrSummaryTypeOpts_OS	= new Array('<%=arrSummaryTypeOpts(2)%>');
		var arrSummaryTypeVals_OS	= new Array('<%=arrSummaryTypeVals(2)%>');

		//values of selSummaryType
		var valScheduleToShip		= '1';
		var valRequestToShip		= '2';
		var valRequestToSchedule	= '3';

		var arrComparisonOpts	= new Array('<%=join(arrComparisonOpts, "', '")%>');
		var arrComparisonVals	= new Array('<%=join(arrComparisonVals, "', '")%>');
		var strComparisonDef	= '<%=vntComparisonDef%>';

		var arrLeadTimeTypeOpts	= new Array('<%=join(arrLeadTimeTypeOpts, "', '")%>');
		var arrLeadTimeTypeVals	= new Array('<%=join(arrLeadTimeTypeVals, "', '")%>');
		var strLeadTimeTypeDef	= '<%=vntLeadTimeTypeDef%>';

		var arrOrgTypeOpts	= new Array('<%=join(arrOrgTypeOpts, "', '")%>');
		var arrOrgTypeVals	= new Array('<%=join(arrOrgTypeVals, "', '")%>');
		var strOrgTypeDef	= '<%=vntOrgTypeDef%>';

		var oidTypeID	= 1;
		var oidOrgID	= 2;
		var oidShortNm	= 3;
		var arrOrgIDs	= new Array();
<%
'-----------------------------------------------------------
	IF IsArray(arrOrgIDs) THEN
		FOR inx = LBound(arrOrgIDs, 1) To UBound(arrOrgIDs, 1)

			RwLf "		arrOrgIDs[" & inx & "] = new Array();"
		NEXT

		FOR inxRow = LBound(arrOrgIDs, 2) To UBound(arrOrgIDs, 2)
			FOR inxCol = LBound(arrOrgIDs, 1) To UBound(arrOrgIDs, 1)

				RwLf "		push(arrOrgIDs[" & inxCol & "], '" & arrOrgIDs(inxCol, inxRow) & "');"
			NEXT
		NEXT
	END IF
'-----------------------------------------------------------
%>
		var arrOrgIDOpts	= new Array();
		var arrOrgIDVals	= new Array();
		var arrLoadingMsg	= new Array('~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~');
		var strOrgIDDef		= '<%=vntOrgIDDef%>';

		var arrCustAcctTypeOpts	= new Array('<%=join(arrCustAcctTypeOpts, "', '")%>');
		var arrCustAcctTypeVals	= new Array('<%=join(arrCustAcctTypeVals, "', '")%>');
		var strCustAcctTypeDef	= '<%=vntCustAcctTypeDef%>';

		var arrCustOrgIDOpts	= new Array('<%=join(arrCustOrgIDOpts, "', '")%>');
		var arrCustOrgIDVals	= new Array('<%=join(arrCustOrgIDVals, "', '")%>');
		var strCustOrgIDDef		= '<%=vntCustOrgIDDef%>';

		var arrMfgOrgTypeOpts	= new Array('<%=join(arrMfgOrgTypeOpts, "', '")%>');
		var arrMfgOrgTypeVals	= new Array('<%=join(arrMfgOrgTypeVals, "', '")%>');
		var strMfgOrgTypeDef	= '<%=vntMfgOrgTypeDef%>';

		var arrMfgOrgIDs = new Array();
<%
'-----------------------------------------------------------
	IF IsArray(arrMfgOrgIDs) THEN
		FOR inx = LBound(arrMfgOrgIDs, 1) To UBound(arrMfgOrgIDs, 1)

			RwLf "		arrMfgOrgIDs[" & inx & "] = new Array();"
		NEXT

		FOR inxRow = LBound(arrMfgOrgIDs, 2) To UBound(arrMfgOrgIDs, 2)
			FOR inxCol = LBound(arrMfgOrgIDs, 1) To UBound(arrMfgOrgIDs, 1)

				RwLf "		push(arrMfgOrgIDs[" & inxCol & "], '" & arrMfgOrgIDs(inxCol, inxRow) & "');"
			NEXT
		NEXT
	END IF
'-----------------------------------------------------------
%>
		var arrMfgOrgIDOpts	= new Array();
		var arrMfgOrgIDVals	= new Array();
		var strMfgOrgIDDef		= '<%=vntMfgOrgIDDef%>';

		var arrProfitCtrOpts	= new Array('<%=join(arrProfitCtrOpts, "', '")%>');
		var arrProfitCtrVals	= new Array('<%=join(arrProfitCtrVals, "', '")%>');
		var strProfitCtrDef	    = '<%=vntProfitCtrDef%>';

		var arrIndustryBusCdeOpts	= new Array('<%=join(arrIndustryBusCdeOpts, "', '")%>');
		var arrIndustryBusCdeVals	= new Array('<%=join(arrIndustryBusCdeVals, "', '")%>');
		var strIndustryBusCdeDef	= '<%=vntIndustryBusCdeDef%>';

		var arrCompetencyBusCdeOpts	= new Array('<%=join(arrCompetencyBusCdeOpts, "', '")%>');
		var arrCompetencyBusCdeVals	= new Array('<%=join(arrCompetencyBusCdeVals, "', '")%>');
		var strCompetencyBusCdeDef	= '<%=vntCompetencyBusCdeDef%>';

		//initialize
		var strSavedFromDay	= strDATE_DELIMITER + '01';
		var strSavedToDay	= strDATE_DELIMITER + '01';

	// -->
	</script>
<%
End Sub

Sub GenJS_errHandler()
If blnDebug Then RwLf "GenJS_errHandler()<br>"

%>
<!--#include file=include/errHandler.inc-->
<%
End Sub

'************************** JS Function refresh_screen ******************
Sub GenJS_refresh_screen()
If blnDebug Then RwLf "GenJS_refresh_screen()<br>"

%>
	<script language="javascript">
	<!--

/////////////////////////////////////////////////
//	CLEAR_HIDDEN_FIELDS
/////////////////////////////////////////////////
	function clear_hidden_fields() {

		var what = frmMain.elements;
		var myType = '', myName = '';
		for (i=0, j=what.length; i<j; i++) {
			myType = (what[i].type).toLowerCase();
			myName = what[i].name;
			if ((myType == 'hidden') && (myName.slice(0,3) != 'hdn')) what[i].value = '';
		}
	}

/////////////////////////////////////////////////
//	UPDATE
/////////////////////////////////////////////////
	function update() {

		var what;
		if (document.getElementById)	what = document.getElementById('frmCriteria').elements;
		else if (document.all)			what = document.all['spnCriteria'].frmCriteria.elements;
		else if (document.layers)		what = document.layers['spnCriteria'].document.frmCriteria.elements;

		var myType = '', myName = '';
		for (i=0, j=what.length; i<j; i++) {
			myType = (what[i].type).toLowerCase();
			myName = what[i].name;
			if (myType == 'radio' && what[i].checked)
				frmMain.elements[myName].value = what[i].value;
			if (myType == 'checkbox')
				frmMain.elements[myName].value = ((what[i].checked) ? what[i].value : '');
			if (myType == 'password' || myType == 'text' || myType == 'textarea')
				frmMain.elements[myName].value = what[i].value;
			if (myType == 'select-one')
				frmMain.elements[myName].value = what[i].options[what[i].selectedIndex].value;
		}
		frmMain.hdnView.value		= frmMain.selView.options[frmMain.selView.selectedIndex].value;
		frmMain.hdnCategory.value	= frmMain.selCategory.options[frmMain.selCategory.selectedIndex].value;
		frmMain.hdnWindow.value		= frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;
		if(!(frmMain.hdnDateFormat.value))		frmMain.hdnDateFormat.value = '1';
		if(!(frmMain.rdoOrgHierarchy.value))	frmMain.rdoOrgHierarchy.value = 'C';
	}

/////////////////////////////////////////////////
//	ETADPU (update backwards)
/////////////////////////////////////////////////
	function etadpu() {

		var what;
		if (document.getElementById)	what = document.getElementById('frmCriteria').elements;
		else if (document.all)			what = document.all['spnCriteria'].frmCriteria.elements;
		else if (document.layers)		what = document.layers['spnCriteria'].document.frmCriteria.elements;

		var blnHasASelected = false;
		var myType = '', myName = '';
		for (i=0, j=what.length; i<j; i++) {
			myType = (what[i].type).toLowerCase();
			myName = what[i].name;

			if (myType == 'radio'){
				what[i].checked = (what[i].value == frmMain.elements[myName].value);
			}
			else if (myType == 'checkbox'){
				what[i].checked = (what[i].value == frmMain.elements[myName].value);
			}
			else if (myType == 'password' || myType == 'text' || myType == 'textarea'){
				what[i].value = frmMain.elements[myName].value;
			}
			else if (myType == 'select-one'){
				blnHasASelected = false;
				for(opt = 0; opt < what[i].length; opt++){
					if(frmMain.elements[myName].value == what[i].options[opt].value){
						blnHasASelected = true;
						what[i].options[opt].selected = true;
				}	}

				if(!(blnHasASelected)){
					what[i].options[0].selected = true;
					frmMain.elements[myName].value = what[i].options[0].value
		}	}	}

	}

/////////////////////////////////////////////////
//	REFRESH_SCREEN
/////////////////////////////////////////////////
	function refresh_screen(intActor) {

		if(intActor == 0){

			strViewValue = (frmMain.hdnView.value ? frmMain.hdnView.value : strViewDef);
			clear_select(frmMain.selView);
			inxDefault = 0;
			for(i = 0; i < arrViewVals.length; i++){
					if(arrViewVals[i] == strViewValue) inxDefault = i;
					blnDefSelected = (arrViewVals[i] == strViewValue);
					blnSelected = (arrViewVals[i] == strViewValue);
					add_option(frmMain.selView, frmMain.selView.length, arrViewOpts[i], arrViewVals[i], blnDefSelected, blnSelected);
			}
			frmMain.selView.options[inxDefault].selected = true;
		}
		else{
			update();
		}

		var inxView = frmMain.selView.selectedIndex;
		var strView = frmMain.selView.options[inxView].value;

		var strCategory;
		var strWindow;

		if(intActor < 2){	//If the View has been changed, then rebuild the Category list
			clear_select(frmMain.selCategory);
			strCatValue = (frmMain.hdnCategory.value ? frmMain.hdnCategory.value : strViewDef[inxView]);
			inxDefault = 0;
			if(inxView < arrCategoryOpts.length){
				for(i=0; i < arrCategoryOpts[inxView].length; i++){
					if(arrCategoryVals[inxView][i] == strCatValue) inxDefault = i;
					blnDefSelected = (arrCategoryVals[inxView][i] == strCatValue);
					blnSelected = (arrCategoryVals[inxView][i] == strCatValue);
					add_option(frmMain.selCategory, frmMain.selCategory.length, arrCategoryOpts[inxView][i], arrCategoryVals[inxView][i], blnDefSelected, blnSelected);
				}
				frmMain.selCategory.options[inxDefault].selected = true;
		}	}

		var strCategory
			if(frmMain.selCategory.selectedIndex >= 0){
				strCategory = frmMain.selCategory.options[frmMain.selCategory.selectedIndex].value;
			}


		var strTR		= '\n<tr>';
		var strTRend	= '\n<\/tr>';
		var strTDend	= '\n<\/td>';

		var strOutput = '<form name="frmCriteria">';
			strOutput += '\n<table name="tblOrganization" id="tblOrganization" width="100%" border="0" cellpadding="1" cellspacing="1">';

		var strFilterDate_Lbl;
			if(strCategory == valLeadTime) {
				if(frmMain.selLeadTimeType.value == '1'){
					strFilterDate_Lbl = 'Received ';
				}
				else{
					strFilterDate_Lbl = 'Shipped ';
				}
			}
			else if((strCategory == valOpenSmry) ||
				    (strCategory == valOpenNonConform)) {
					strFilterDate_Lbl = 'Cust Request ';
			}
			else{
				strFilterDate_Lbl = '';
			}

			//Row 1
			strOutput += strTR;
			if(inxView < arrViewOpts.length){
				if((strCategory == valSummary) ||
				   (strCategory == valOpenSmry)) {
					strOutput += TD('colspan=6,align=left,bgcolor=lightgrey') + '<font size="4" color="navy"><b>' + arrViewOpts[inxView] + ' Search Options</b>' + strEndDefFormat + strTDend;
				}
				else{
					strOutput += TD('colspan=5,align=left,bgcolor=lightgrey') + '<font size="4" color="navy"><b>' + arrViewOpts[inxView] + ' Search Options' + strEndDefFormat + strTDend;
					strOutput += TD('align=right,bgcolor=lightgrey') + strDefFormat + '<%=chkExport_Lbl%>' + <%=chkExport%> + strEndDefFormat + strTDend;
			}	}
			else{
				strOutput += TD('colspan=6,align=left,bgcolor=lightgrey') + '<font size="4" color="navy"><b>' + 'Error Message' + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

		switch(strView){

//*****************************************************
//	PAINT ORGANIZATION VIEW
//*****************************************************
		case valOrganization:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)		||
					(strCategory == valOpen)		||
					(strCategory == valOpenSmry)	||
					(strCategory == valOpenNonConform)	||
					(strCategory == valLeadTime)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			//rebuild_summary_type_array(strWindow);
			rebuild_summary_type_array(strWindow,strCategory);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + strFilterDate_Lbl + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;

			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				//Is Organization YTD the selected category?
				if(strCategory == valOrganizationYTD){
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strTDend;
				}
				else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				}
				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				//Is Organization YTD the selected category?
				if(strCategory == valOrganizationYTD){
					strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strTDend;
				}
				else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				}
				if(strCategory == valLeadTime){
					strOutput += TD('align=right') + strDefFormat + '<%=selLeadTimeType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selLeadTimeType%> + strTDend;
				}
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			//Is Organization YTD the selected category?
			if(strCategory == valOrganizationYTD){
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
				frmMain.hdnDateFormat.value = '1';
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				//strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat_HidePart%> + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			}
			if(
				(strCategory == valPastDue) ||
				(strCategory == valOpen)	){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else if(strCategory == valLeadTime){
				if(frmMain.selLeadTimeType.value == '1'){
					strOutput += TD('align=right') + strDefFormat + '<%=rdoShipOpen_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoShipOpen%> + strEndDefFormat + strTDend;
				}
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1')) {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkByCountry%> + strDefFormat;
				strOutput += '<%=chkByCountry_Lbl%>' + strEndDefFormat + strTDend;
			}
			else {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			}
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
			//if(	(strCategory == valOrganizationYTD)		||
			//	(!(frmMain.hdnDateFormat.value))		||
			//	(frmMain.hdnDateFormat.value == '1')	){
			if(strCategory == valOrganizationYTD){
				strOutput += TD('align=left,colspan=5') + <%=selCustAcctType%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
				//strOutput += TD('align=right') + strDefFormat + '<%=txtPartNbr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + '<%=btnPartNbr%>' + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtPartNbr%> + strTDend;
			}
			strOutput += strTRend;

			//Row 7
			if(strCategory == valLeadTime){
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=btnInvOrgPlant%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=5') + <%=txtInvOrgPlant%> + strDefFormat + ' <%=btnController%> ' + strEndDefFormat + <%=txtController%> + strTDend;
				strOutput += strTRend;
			}
			//if( (strCategory != valOrganizationYTD) &&
			//    (frmMain.hdnIsMultiPart.value == 'true') )  {
			//	strOutput += strTR;
			//	strOutput += TD('align=right,colspan=6') + strDefFormat + 'Found Multi-Part Numbers with different brand name for the part entered, please use Part Nbr lookup to select the specific part!' + strEndDefFormat + strTDend;
			//	strOutput += strTRend;
			//  }
			else{
				strOutput += strTR;
				strOutput += TD('align=left,colspan=6') + '&nbsp;' + strTDend;
				strOutput += strTRend;
			}
			break;

//*****************************************************
//	PAINT BLDG LOCATION VIEW
//*****************************************************
		case valBldgLocation:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)	||
					(strCategory == valOpen)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			rebuild_summary_type_array(strWindow);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtToDate%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtToDate%> + strTDend;
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			//if(
			//	(strCategory == valBldgList)	||
			//	(strCategory == valLocList)		){

			//	strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
			//	strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
			//	frmMain.hdnDateFormat.value = '1';
			//}
			//else{
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			//}
			if(
				(strCategory == valPastDue) ||
				(strCategory == valOpen) ){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1')) {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkByCountry%> + strDefFormat;
				strOutput += '<%=chkByCountry_Lbl%>' + strEndDefFormat + strTDend;
			}
			else {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			}
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
			strOutput += strTRend;

			//Row 7
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selProfitCtr_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selProfitCtr%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=btnMrpGroup%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtMrpGroup%> + strTDend;
			strOutput += strTRend;

			//Row 8
			strOutput += strTR;
			if(strCategory == valBldgList){
				strOutput += TD('align=left,colspan=6') + '&nbsp;' + strTDend;
			}
			else if(strCategory == valLocList){
				strOutput += TD('align=right') + strDefFormat + '<%=txtPlantBldgNbr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=5') + <%=txtPlantBldgNbr%> + strTDend;
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=txtPlantBldgNbr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtPlantBldgNbr%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtLocation_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtLocation%> + strTDend;
			}
			strOutput += strTRend;
			break;

//*****************************************************
//	PAINT CUST WW VIEW
//*****************************************************
		case valCustWW:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)		||
					(strCategory == valCustList)	||
					(strCategory == valWWList)		||
					(strCategory == valOpen)		||
					(strCategory == valLeadTime)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			rebuild_summary_type_array(strWindow);

			if(strCategory == valCustList){
				//Row 2
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=txtWWNbr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=5') + <%=txtWWNbr%> + strTDend;
				strOutput += strTRend;
			}
			else if(strCategory == valWWList){
				//Row 2
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=selCustOrgID_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selCustOrgID%> + strTDend;
				//strOutput += TD('align=right') + strDefFormat + '<%'=txtCustomerNbr_Lbl%>' + strEndDefFormat + strTDend;
				//strOutput += TD('align=left,colspan=2') + <%'=txtCustomerNbr%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtShipTo_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtShipTo%> + strTDend;
				strOutput += strTRend;

				//Row 3
				//strOutput += strTR;
				//strOutput += TD('align=right') + '&nbsp;' + strTDend;
				//strOutput += TD('align=left,colspan=2') + '&nbsp;' + strTDend;
				//strOutput += TD('align=right') + strDefFormat + '<%=txtSoldTo_Lbl%>' + strEndDefFormat + strTDend;
				//strOutput += TD('align=left,colspan=2') + <%=txtSoldTo%> + strTDend;
				//strOutput += strTRend;
			}
			else{
				//Row 2
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + strFilterDate_Lbl + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
				if(	(strWindow == strStandardDefault)	&&
					(blnSelWindowEnabled)				&&
					(frmMain.selSummaryType.value != valRequestToSchedule)	){

					//Is Organization List the selected category?
					//if(strCategory == valOrgList){
					//	strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strTDend;
					//}
					//else{
						strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
						strOutput += <%=txtToDate%> + strTDend;
					//}
					strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				    if(frmMain.selSummaryType.value == valScheduleToShip)
						strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
					else
						strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtDaysLate%> + strTDend;
				}
				else{
					//Is Organization List the selected category?
					//if(strCategory == valOrgList){
					//	strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strTDend;
					//}
					//else{
						strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
						strOutput += <%=txtToDate%> + strTDend;
					if(strCategory == valLeadTime){
						strOutput += TD('align=right') + strDefFormat + '<%=selLeadTimeType_Lbl%>' + strEndDefFormat + strTDend;
						strOutput += TD('align=left,colspan=2') + <%=selLeadTimeType%> + strTDend;
					}
				}	//}
				strOutput += strTRend;

				//Row 3
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				//Is Organization List the selected category?
				//if(strCategory == valOrgList){
				//	strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
				//	strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				//	strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
				//	frmMain.hdnDateFormat.value = '1';
				//}
				//else{
					//strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat_HidePart%> + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
					if(
						(strCategory == valPastDue) ||
						(strCategory == valOpen)	){

						strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
						strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
					}
					else if(strCategory == valLeadTime){
						if(frmMain.selLeadTimeType.value == '1'){
							strOutput += TD('align=right') + strDefFormat + '<%=rdoShipOpen_Lbl%>' + strEndDefFormat + strTDend;
							strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoShipOpen%> + strEndDefFormat + strTDend;
						}
					}
					else{
						strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
						strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
					}
				//}
				strOutput += strTRend;

				//Row 4
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.rdoOrgHierarchy.value == 'H'){
					strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
					strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
				}
				else{
					strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				}
				strOutput += strTRend;

				//Row 5
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
				if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1')) {
					strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkByCountry%> + strDefFormat;
					strOutput += '<%=chkByCountry_Lbl%>' + strEndDefFormat + strTDend;
				}
				else {
					strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
				}
				strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
				strOutput += strTRend;

				//Row 6
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=selCustOrgID_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selCustOrgID%> + strTDend;
				//strOutput += TD('align=right') + strDefFormat + '<%'=txtCustomerNbr_Lbl%>' + strEndDefFormat + strTDend;
				//strOutput += TD('align=left,colspan=2') + <%'=txtCustomerNbr%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtShipTo_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtShipTo%> + strTDend;
				strOutput += strTRend;

				//var strPartNbrTags = '';
				//if(
				//	(frmMain.hdnDateFormat.value == '2')	&&
				//	(strCategory != valOrgList)				){
				//	strPartNbrTags = TD('align=right') + strDefFormat + '<%=txtPartNbr_Lbl%>' + strEndDefFormat + strTDend;
				//	strPartNbrTags += TD('align=left,colspan=2') + <%=txtPartNbr%> + strTDend;
				//}

				//Row 7
				strOutput += strTR;
				if(strCategory == valLeadTime){
					strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
					//strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
					//strOutput += strPartNbrTags;
					strOutput += TD('align=right') + strDefFormat + '<%=txtSoldTo_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtSoldTo%> + strTDend;
					strOutput += strTRend;

					//Row 8
					strOutput += strTR;
					strOutput += TD('align=right') + strDefFormat + '<%=txtWWNbr_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtWWNbr%> + strTDend;
					//strOutput += TD('align=right') + strDefFormat + '<%=txtPartNbr_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=right') + '<%=btnPartNbr%>' + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtPartNbr%> + strTDend;
					strOutput += strTRend;

					//Row 9
					strOutput += strTR;
					strOutput += TD('align=right') + strDefFormat + '<%=btnInvOrgPlant%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtInvOrgPlant%> + strDefFormat + ' <%=btnController%> ' + strEndDefFormat + <%=txtController%> + strTDend;
					if(frmMain.hdnDateFormat.value == '2') {
						strOutput += TD('align=right') + strDefFormat + '<%=btnProdHostOrgID%>' + strTDend;
						strOutput += TD('align=left,colspan=2') + <%=txtProdHostOrgID%> + strTDend;
					}
				}
				else{
					strOutput += TD('align=right') + strDefFormat + '<%=txtWWNbr_Lbl%>' + strEndDefFormat + strTDend;
					//strOutput += TD('align=left,colspan=2') + <%=txtWWNbr%> + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtWWNbr%> + strTDend;
					//strOutput += strPartNbrTags;
					strOutput += TD('align=right') + strDefFormat + '<%=txtSoldTo_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtSoldTo%> + strTDend;
					strOutput += strTRend;

					//Row 8
					strOutput += strTR;
					if(strCategory != valOrgList){

						strOutput += TD('align=right') + strDefFormat + '<%=btnInvOrgPlant%>' + strEndDefFormat + strTDend;
						strOutput += TD('align=left,colspan=2') + <%=txtInvOrgPlant%> + strDefFormat + ' <%=btnController%> ' + strEndDefFormat + <%=txtController%> + strTDend;
						//strOutput += TD('align=right') + strDefFormat + '<%=txtPartNbr_Lbl%>' + strEndDefFormat + strTDend;
						strOutput += TD('align=right') + '<%=btnPartNbr%>' + strTDend;
						strOutput += TD('align=left,colspan=2') + <%=txtPartNbr%> + strTDend;
					}
					else{
						strOutput += TD('align=left,colspan=6') + '&nbsp;' + strTDend;
				}	}
				strOutput += strTRend;

				if(strCategory == valSummary){
					//Row 10
					strOutput += strTR;
					strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
		 			strOutput += TD('align=right') + strDefFormat + '<%=txtTeam_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtTeam%> + strTDend;
					strOutput += strTRend;
				}

				if(strCategory != valLeadTime && strCategory != valOrgList && frmMain.hdnDateFormat.value == '2'){
					//Row 11
					strOutput += strTR;
					strOutput += TD('align=right') + strDefFormat + '<%=btnProdHostOrgID%>' + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtProdHostOrgID%> + strTDend;
					strOutput += strTRend;
				}
			}

			break;
//*****************************************************
//	PAINT SHIPPING FACILITY VIEW
//*****************************************************
		case valShippingFac:

			disable_selWindow();

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
				//Is List the selected category?
				//if(strCategory == valShipFacList){
				//	strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				//}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
			if(strCategory == valShipFacList){
				strOutput += TD('align=left,colspan=5') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
				frmMain.hdnDateFormat.value = '1';
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=txtPlantBldgNbr_Lbl%>' + strEndDefFormat + strTDend;
			if(strCategory == valShipFacList){
				strOutput += TD('align=left,colspan=5') + <%=txtPlantBldgNbr%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=2') + <%=txtPlantBldgNbr%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtLocation_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtLocation%> + strTDend;
			}
			strOutput += strTRend;
			break;
//*****************************************************
//	PAINT TEAM VIEW
//*****************************************************
		case valTeam:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)		||
					(strCategory == valOpen)		||
					(strCategory == valLeadTime)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			rebuild_summary_type_array(strWindow);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + strFilterDate_Lbl + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				//Is List the selected category?
				//if(strCategory == valTeamList){
				//	strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				//}
				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				//Is List the selected category?
				//if(strCategory == valTeamList){
				//	strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				if(strCategory == valLeadTime){
					strOutput += TD('align=right') + strDefFormat + '<%=selLeadTimeType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selLeadTimeType%> + strTDend;
				}
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			//Is List the selected category?
			//if(strCategory == valTeamList){
			//	strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
			//	strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
			//	frmMain.hdnDateFormat.value = '1';
			//}
			//else{
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			//}
			if(
				(strCategory == valPastDue) ||
				(strCategory == valOpen) ){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else if(strCategory == valLeadTime){
				if(frmMain.selLeadTimeType.value == '1'){
					strOutput += TD('align=right') + strDefFormat + '<%=rdoShipOpen_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoShipOpen%> + strEndDefFormat + strTDend;
				}
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=txtProductCode_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtProductCode%> + strTDend;
			strOutput += strTRend;

			//Row 7
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
			if(strCategory == valTeamList){
				strOutput += TD('align=left,colspan=5') + <%=txtMakeStock%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
	 			strOutput += TD('align=right') + strDefFormat + '<%=txtTeam_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtTeam%> + strTDend;
			}
			strOutput += strTRend;

			//Row 8
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=btnInvOrgPlant%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtInvOrgPlant%> + strDefFormat + ' <%=btnController%> ' + strEndDefFormat + <%=txtController%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=txtGblProductLine_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtGblProductLine%> + strTDend;
			strOutput += strTRend;

			break;
//*****************************************************
//	PAINT CONTROLLER VIEW
//*****************************************************
		case valController:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)		||
					(strCategory == valOpen)		||
					(strCategory == valLeadTime)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			rebuild_summary_type_array(strWindow);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + strFilterDate_Lbl + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				//Is Controller List or Org List the selected category?
				//if(
				//	(strCategory == valControllerList)	||
				//	(strCategory == valOrgList)	){
				//	strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				//}
				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				//Is Controller List or Org List the selected category?
				//if(
				//	(strCategory == valControllerList)	||
				//	(strCategory == valOrgList)	){
				//	strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				if(strCategory == valLeadTime){
					strOutput += TD('align=right') + strDefFormat + '<%=selLeadTimeType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selLeadTimeType%> + strTDend;
				}
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			//Is Controller List or Org List the selected category?
			if(
			//	(strCategory == valControllerList)	||
				(strCategory == valOrgList)	){
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
				frmMain.hdnDateFormat.value = '1';
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			}
			if(
				(strCategory == valPastDue) ||
				(strCategory == valOpen)	){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else if(strCategory == valLeadTime){
				if(frmMain.selLeadTimeType.value == '1'){
					strOutput += TD('align=right') + strDefFormat + '<%=rdoShipOpen_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoShipOpen%> + strEndDefFormat + strTDend;
				}
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1')) {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkByCountry%> + strDefFormat;
				strOutput += '<%=chkByCountry_Lbl%>' + strEndDefFormat + strTDend;
			}
			else {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			}
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=txtGblProductLine_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtGblProductLine%> + strTDend;
			strOutput += strTRend;

			//Row 7
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
 			strOutput += TD('align=right') + strDefFormat + '<%=txtTeam_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtTeam%> + strTDend;
			strOutput += strTRend;

			//Row 8
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=btnMrpGroup%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtMrpGroup%> + strTDend;
			if(strCategory == valControllerList){
				strOutput += TD('align=right') + strDefFormat + '<%=txtCntrllerEmpNbr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtCntrllerEmpNbr%> + strTDend;
			}
			else {
				strOutput += TD('align=right') + strDefFormat + '<%=btnInvOrgPlant%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=5') + <%=txtInvOrgPlant%> + strDefFormat + ' <%=btnController%> ' + strEndDefFormat + <%=txtController%> + strTDend;
			}
			strOutput += strTRend;

			break;
//*****************************************************
//	PAINT MAKE STOCK VIEW
//*****************************************************
		case valMakeStock:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)		||
					(strCategory == valOpen)		||
					(strCategory == valLeadTime)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			rebuild_summary_type_array(strWindow);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + strFilterDate_Lbl + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				//Is Make Stock List the selected category?
				//if(strCategory == valMakeStockList){
				//	strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				//}
				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				//Is Make Stock List the selected category?
				//if(strCategory == valMakeStockList){
				//	strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				if(strCategory == valLeadTime){
					strOutput += TD('align=right') + strDefFormat + '<%=selLeadTimeType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selLeadTimeType%> + strTDend;
				}
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			//Is Make Stock List the selected category?
			//if(strCategory == valMakeStockList){
			//	strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
			//	strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
			//	frmMain.hdnDateFormat.value = '1';
			//}
			//else{
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			//}
			if(
				(strCategory == valPastDue) ||
				(strCategory == valOpen)	){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else if(strCategory == valLeadTime){
				if(frmMain.selLeadTimeType.value == '1'){
					strOutput += TD('align=right') + strDefFormat + '<%=rdoShipOpen_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoShipOpen%> + strEndDefFormat + strTDend;
				}
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1')) {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkByCountry%> + strDefFormat;
				strOutput += '<%=chkByCountry_Lbl%>' + strEndDefFormat + strTDend;
			}
			else {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			}
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
			if(strCategory == valSummary){
				strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtGblProductLine_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtGblProductLine%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + <%=selCustAcctType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 7
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
 			strOutput += TD('align=right') + strDefFormat + '<%=txtTeam_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtTeam%> + strTDend;
			strOutput += strTRend;

			//Row 8
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=btnMrpGroup%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtMrpGroup%> + strTDend;
			strOutput += strTRend;

			break;
//*****************************************************
//	PAINT PRODUCT CODE VIEW
//*****************************************************
		case valProdCode:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)		||
					(strCategory == valOpen)		||
					(strCategory == valLeadTime)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			rebuild_summary_type_array(strWindow);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + strFilterDate_Lbl + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				//Is GPL or PC List the selected category?
				//if(	(strCategory == valGPLList)	||
				//	(strCategory == valPCList)	){
                //
				//	strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				//}
				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				//Is GPL or PC List the selected category?
				//if(	(strCategory == valGPLList)	||
				//	(strCategory == valPCList)	){
                //
				//	strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				if(strCategory == valLeadTime){
					strOutput += TD('align=right') + strDefFormat + '<%=selLeadTimeType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selLeadTimeType%> + strTDend;
				}
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			//Is GPL or PC List the selected category?
			//if(	(strCategory == valGPLList)	||
			//	(strCategory == valPCList)	){

			//	strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
			//	strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
			//	frmMain.hdnDateFormat.value = '1';
			//}
			//else{
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			//}
			if(	(strCategory == valPastDue) ||
				(strCategory == valOpen)	){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else if(strCategory == valLeadTime){
				if(frmMain.selLeadTimeType.value == '1'){
					strOutput += TD('align=right') + strDefFormat + '<%=rdoShipOpen_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoShipOpen%> + strEndDefFormat + strTDend;
				}
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1')) {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkByCountry%> + strDefFormat;
				strOutput += '<%=chkByCountry_Lbl%>' + strEndDefFormat + strTDend;
			}
			else {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			}
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=txtGblProductLine_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtGblProductLine%> + strTDend;
			strOutput += strTRend;

			//Row 7
			strOutput += strTR;
			if(strCategory == valGPLList){
				strOutput += TD('align=right,') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtWWNbr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtWWNbr%> + strTDend;
			}
			else if(strCategory == valPCList){
				strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtWWNbr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtWWNbr%> + strTDend;
				strOutput += strTRend;
				//Row 8
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=txtProductCode_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtProductCode%> + strTDend;
				strOutput += TD('align=right,') + strDefFormat + '<%=txtProdMgr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtProdMgr%> + strTDend;
			}
			else if(strCategory == valSummary){
				strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
	 			strOutput += TD('align=right') + strDefFormat + '<%=txtTeam_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtTeam%> + strTDend;
				strOutput += strTRend;
				//Row 8
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=txtProductCode_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtProductCode%> + strTDend;
				strOutput += TD('align=right,') + strDefFormat + '<%=txtProdMgr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtProdMgr%> + strTDend;
				strOutput += strTRend;
				//Row 9
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=txtWWNbr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtWWNbr%> + strTDend;
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=txtProductCode_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtProductCode%> + strTDend;
	 			strOutput += TD('align=right') + strDefFormat + '<%=txtTeam_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtTeam%> + strTDend;
				//Row 8
				if(strCategory != valLeadTime) {
					strOutput += strTRend;
					strOutput += strTR;
					strOutput += TD('align=right') + strDefFormat + '<%=txtWWNbr_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtWWNbr%> + strTDend;
					strOutput += TD('align=right') + strDefFormat + '<%=txtProdMgr_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=txtProdMgr%> + strTDend;
				}
			}
			strOutput += strTRend;
			if(strCategory != valLeadTime){
				//Row 9
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=selCustOrgID_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selCustOrgID%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtSoldTo_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtSoldTo%> + strTDend;
				strOutput += strTRend;
			}

			break;
//*****************************************************
//	PAINT INDUSTRY CODE VIEW
//*****************************************************
		case valIndustryCde:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)		||
					(strCategory == valOpen)		||
					(strCategory == valLeadTime)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			rebuild_summary_type_array(strWindow);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + strFilterDate_Lbl + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				//Is Industry or IBC List the selected category?
				//if(	(strCategory == valIndustryList)	||
				//	(strCategory == valIBCList)	){
                //
				//	strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				//}
				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				//Is Industry or IBC List the selected category?
				//if(	(strCategory == valIndustryList)	||
				//	(strCategory == valIBCList)	){
                //
				//	strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strTDend;
				//}
				//else{
					strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
					strOutput += <%=txtToDate%> + strTDend;
				if(strCategory == valLeadTime){
					strOutput += TD('align=right') + strDefFormat + '<%=selLeadTimeType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selLeadTimeType%> + strTDend;
				}
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			//Is Industry or IBC List the selected category?
			//if(	(strCategory == valIndustryList)	|| removed to allow daily
			//if(	(strCategory == valIBCList)	){

			//	strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
			//	strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
			//	frmMain.hdnDateFormat.value = '1';
			//}
			//else{
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			//}
			if(	(strCategory == valPastDue) ||
				(strCategory == valOpen)	){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else if(strCategory == valLeadTime){
				if(frmMain.selLeadTimeType.value == '1'){
					strOutput += TD('align=right') + strDefFormat + '<%=rdoShipOpen_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoShipOpen%> + strEndDefFormat + strTDend;
				}
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1')) {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkByCountry%> + strDefFormat;
				strOutput += '<%=chkByCountry_Lbl%>' + strEndDefFormat + strTDend;
			}
			else {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			}
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=txtWWNbr_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtWWNbr%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=selIndustryBusCde_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selIndustryBusCde%> + strTDend;
			strOutput += strTRend;

			//Row 7
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
			if(strCategory == valIBCList){
				strOutput += TD('align=left,colspan=5') + <%=txtMakeStock%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtIndustryCde_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtIndustryCde%> + strTDend;
			}
			strOutput += strTRend;

			//Row 8
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=btnMrpGroup%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtMrpGroup%> + strTDend;
			strOutput += strTRend;

			break;
//*****************************************************
//	PAINT MFG BLDG VIEW
//*****************************************************
		case valMfgBldg:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)		||
					(strCategory == valOpen)		){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			rebuild_summary_type_array(strWindow);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtToDate%> + strTDend;

				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtToDate%> + strTDend;
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			//Is a List category selected?
			//if(	(strCategory == valCampusList)	||
			//	(strCategory == valCmpBldgList)	||
			//	(strCategory == valBldgList)	){

			//	strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
			//	strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
			//	frmMain.hdnDateFormat.value = '1';
			//}
			//else{
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			//}
			if(	(strCategory == valPastDue) ||
				(strCategory == valOpen)	){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selMfgOrgType_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selMfgOrgType%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=selMfgOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selMfgOrgID%> + strTDend;
			strOutput += strTRend;

			if(strCategory == valCmpBldgList){
				//Row 7
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtGblProductLine_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtGblProductLine%> + strTDend;
				strOutput += strTRend;

				//Row 8
				strOutput += strTR;
				if (frmMain.hdnDateFormat.value == '2') {
					strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
					strOutput += TD('align=right') + strDefFormat + '<%=txtMfgCampusID_Lbl%>' + strEndDefFormat + strTDend;
				} else {
					strOutput += TD('align=right,colspan=4') + strDefFormat + '<%=txtMfgCampusID_Lbl%>' + strEndDefFormat + strTDend;
				}
				strOutput += TD('align=left,colspan=2') + <%=txtMfgCampusID%> + strTDend;
				strOutput += strTRend;

				//Row 9
				strOutput += strTR;
				strOutput += TD('align=right,colspan=4') + strDefFormat + '<%=txtMfgBldgNbr_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtMfgBldgNbr%> + strTDend;
				strOutput += strTRend;
			}
			else if(strCategory == valBldgList){
				//Row 7
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=5') + <%=txtMakeStock%> + strTDend;
				strOutput += strTRend;

				//Row 8
				if (frmMain.hdnDateFormat.value == '2') {
					strOutput += strTR;
					strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=5') + <%=selCustAcctType%> + strTDend;
					strOutput += strTRend;
				}
			}
			else if(strCategory != valCampusList){
				//Row 7
				strOutput += strTR;
				strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtMfgCampusID_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtMfgCampusID%> + strTDend;
				strOutput += strTRend;

				//Row 8
				strOutput += strTR;
				if ( (frmMain.hdnDateFormat.value == '2') ||
					 (strCategory == valPastDue)          ||
					 (strCategory == valOpen)             ||
					 (strCategory == valNonConforming)    ||
					 (strCategory == valConforming)       ) {
					strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
					strOutput += TD('align=right') + strDefFormat + '<%=txtMfgBldgNbr_Lbl%>' + strEndDefFormat + strTDend;
				} else {
					strOutput += TD('align=right,colspan=4') + strDefFormat + '<%=txtMfgBldgNbr_Lbl%>' + strEndDefFormat + strTDend;
				}
				strOutput += TD('align=left,colspan=2') + <%=txtMfgBldgNbr%> + strTDend;
				strOutput += strTRend;
			}

			break;
//*****************************************************
//	PAINT PROFIT CENTER VIEW
//*****************************************************
		case valProfitCtr:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)		||
					(strCategory == valOpen)		||
					(strCategory == valOpenSmry)	||
					(strCategory == valOpenNonConform)	||
					(strCategory == valLeadTime)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			//rebuild_summary_type_array(strWindow);
			rebuild_summary_type_array(strWindow,strCategory);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + strFilterDate_Lbl + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtToDate%> + strTDend;

				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtToDate%> + strTDend;
				if(strCategory == valLeadTime){
					strOutput += TD('align=right') + strDefFormat + '<%=selLeadTimeType_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + <%=selLeadTimeType%> + strTDend;
				}
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			//Is a List category selected?
			//if(	(strCategory == valIBCList)	||
			//	(strCategory == valCompetencyBusList)	|| removed to allow daily
			//	(strCategory == valProfitCtrList)	){
			//	strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
			//	strOutput += TD('align=left,colspan=2') + strDefFormat + 'YYYY' + strDATE_DELIMITER + 'MM' + strEndDefFormat + strTDend;
			//	frmMain.hdnDateFormat.value = '1';
			//}
			//else{
				strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			//}
			if(	(strCategory == valPastDue) ||
				(strCategory == valOpen)	){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else if(strCategory == valLeadTime){
				if(frmMain.selLeadTimeType.value == '1'){
					strOutput += TD('align=right') + strDefFormat + '<%=rdoShipOpen_Lbl%>' + strEndDefFormat + strTDend;
					strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoShipOpen%> + strEndDefFormat + strTDend;
				}
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1')) {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkByCountry%> + strDefFormat;
				strOutput += '<%=chkByCountry_Lbl%>' + strEndDefFormat + strTDend;
			}
			else if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1636') && (frmMain.hdnDateFormat.value == '2')) {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkBySTCntry%> + strDefFormat;
				strOutput += '<%=chkBySTCntry_Lbl%>' + strEndDefFormat + strTDend;
			}
			else {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			}
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selCustAcctType_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selCustAcctType%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=selIndustryBusCde_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selIndustryBusCde%> + strTDend;
			strOutput += strTRend;

			//Row 7
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selProfitCtr_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selProfitCtr%> + strTDend;
			strOutput += TD('align=right') + strDefFormat + '<%=selCompetencyBusCde_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selCompetencyBusCde%> + strTDend;
			strOutput += strTRend;

			//Row 8
			//strOutput += strTR;
			//strOutput += TD('align=right,colspan=4') + strDefFormat + '<%=txtSubCompetencyBusCde_Lbl%>' + strEndDefFormat + strTDend;
			//strOutput += TD('align=left,colspan=2') + <%=txtSubCompetencyBusCde%> + strTDend;
			//strOutput += strTRend;

			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=txtMakeStock_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtMakeStock%> + strTDend;
 			strOutput += TD('align=right') + strDefFormat + '<%=txtSubCompetencyBusCde_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtSubCompetencyBusCde%> + strTDend;
			strOutput += strTRend;

			//Row 9
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=btnMrpGroup%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtMrpGroup%> + strTDend;
			strOutput += strTRend;

			break;

//*****************************************************
//	PAINT SAP SALES
//*****************************************************
		case valSAPSales:

			if (intActor < 3) {	//Rebuild the Window list
				if( (strCategory == valPastDue)	||
					(strCategory == valOpen)	){

					disable_selWindow();
				}
				else enable_selWindow();
			}
			strWindow = frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

			rebuild_summary_type_array(strWindow);

			//Row 2
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=hdnFromDate_Lbl%>' + strEndDefFormat + strTDend;
			if(	(strWindow == strStandardDefault)	&&
				(blnSelWindowEnabled)				&&
				(frmMain.selSummaryType.value != valRequestToSchedule)	){

				strOutput += TD('align=left,colspan=2') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtToDate%> + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtDaysEarly_Lbl%>' + strEndDefFormat + strTDend;
				if(frmMain.selSummaryType.value == valScheduleToShip)
					strOutput += TD('align=left,colspan=2') + '<%=txtDaysEarlyAll_Lbl%>' + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				else
					strOutput += TD('align=left,colspan=2') + <%=txtDaysEarly%> + strDefFormat + '<%=txtDaysLate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtDaysLate%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + <%=hdnFromDate%> + strDefFormat + '<%=txtToDate_Lbl%>' + strEndDefFormat;
				strOutput += <%=txtToDate%> + strTDend;
			}
			strOutput += strTRend;

			//Row 3
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=hdnDateFormat_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + strDefFormat + <%=hdnDateFormat%> + strEndDefFormat + strTDend;
			if(
				(strCategory == valPastDue) ||
				(strCategory == valOpen) ){

				strOutput += TD('align=right') + strDefFormat + '<%=selComparison_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selComparison%> + strTDend;
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=selSummaryType_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=selSummaryType%> + strTDend;
			}
			strOutput += strTRend;

			//Row 4
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=rdoOrgHierarchy_Lbl%>' + strEndDefFormat + strTDend;
			if(frmMain.rdoOrgHierarchy.value == 'H'){
				strOutput += TD('align=left,colspan=2') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
				strOutput += TD('align=right') + strDefFormat + '<%=txtOrgDt_Lbl%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtOrgDt%> + strTDend;
			}
			else{
				strOutput += TD('align=left,colspan=5') + strDefFormat + <%=rdoOrgHierarchy%> + strEndDefFormat + strTDend;
			}
			strOutput += strTRend;

			//Row 5
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgType_Lbl%>' + strEndDefFormat + strTDend;
			if ((strCategory == valSummary) && (frmMain.selOrgType.value == '1')) {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + '&nbsp;&nbsp;' + <%=chkByCountry%> + strDefFormat;
				strOutput += '<%=chkByCountry_Lbl%>' + strEndDefFormat + strTDend;
			}
			else {
				strOutput += TD('align=left,colspan=2') + <%=selOrgType%> + strTDend;
			}
			strOutput += TD('align=right') + strDefFormat + '<%=selOrgID_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=selOrgID%> + strTDend;
			strOutput += strTRend;

			//Row 6
			strOutput += strTR;
			strOutput += TD('align=right') + strDefFormat + '<%=txtPlant_Lbl%>' + strEndDefFormat + strTDend;
			strOutput += TD('align=left,colspan=2') + <%=txtPlantBldgNbr%> + strTDend;
			if(strCategory == valSalesOfficeList){
				strOutput += TD('align=left,colspan=6') + '&nbsp;' + strTDend;
			}
			else if(strCategory == valSalesGroupList){
				strOutput += TD('align=right') + strDefFormat + '<%=btnSalesOffice%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=5') + <%=txtSalesOffice%> + strTDend;
			}
			else{
				strOutput += TD('align=right') + strDefFormat + '<%=btnSalesOffice%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtSalesOffice%> + strTDend;
				//Row 7
				strOutput += strTR;
				strOutput += TD('align=right,colspan=4') + strDefFormat + '<%=btnSalesGroup%>' + strEndDefFormat + strTDend;
				strOutput += TD('align=left,colspan=2') + <%=txtSalesGroup%> + strTDend;
			}

			strOutput += strTRend;
			break;

//*****************************************************
			default:
				strOutput += strTR;
				strOutput += TD('align=center,colspan=6') + '<h2>Unrecognized View Type<\/h2>' + strTDend;
				strOutput += strTRend;
		}

		strOutput += strTR + TD('colspan=6') + '<%=sHR%>' + strTDend + strTRend;

		strOutput += strTR;
		strOutput += TD('colspan=6') + '<%=strLowButtons%>' + strTDend;
		strOutput += strTRend;

		//This row just for spacing purposes
		strOutput += strTR;
		strOutput += TD('width=16%') + '&nbsp;' + strTDend + TD('width=17%') + '&nbsp;' + strTDend + TD('width=17%') + '&nbsp;' + strTDend + TD('width=16%') + '&nbsp;' + strTDend + TD('width=17%') + '&nbsp;' + strTDend + TD('width=17%') + '&nbsp;' + strTDend;
		strOutput += strTRend;

		strOutput += '\n<\/table>';
		strOutput += '\n<\/form>';

<%	IF blnJSDebug Then
%>		//This is for debugging
		frmMain.txaDebug.value = strOutput;
<%	END IF
%>

		if (document.getElementById) {
			if (window.HTMLElement) {
				spanNode = document.getElementById('spnCriteria');
				while (spanNode.hasChildNodes()) spanNode.removeChild(spanNode.lastChild);
				var range = document.createRange();
				range.selectNodeContents(spanNode);
				spanNode.appendChild(range.createContextualFragment(strOutput));
			}
			else {
				document.all('spnCriteria').innerHTML = strOutput;
			}
			theForm = document.getElementById('frmCriteria');
		}
		else if (document.all){
			document.all('spnCriteria').innerHTML = strOutput;
			theForm = document.all('frmCriteria');
		}
		else if (document.layers) {
			document.layers['spnCriteria'].document.open();
			document.layers['spnCriteria'].document.writeln(strOutput);
			document.layers['spnCriteria'].document.close();

			theForm = document.layers['spnCriteria'].document.frmCriteria;
		}

		if(theForm.selOrgID)	rebuild_org_ids();
		if(theForm.selMfgOrgID)	rebuild_mfg_org_ids();

		etadpu();

		format_dates();

		switch(intActor){
//		case 4:
//			set_focus(theForm.hdnDateFormat[0]);
//			break;
//		case 5:
//			set_focus(theForm.hdnDateFormat[1]);
//			break;
		case 6:
			set_focus(theForm.rdoOrgHierarchy[0]);
			break;
		case 7:
			set_focus(theForm.rdoOrgHierarchy[1]);
			break;
		case 8:
			set_focus(theForm.selSummaryType);
			break;
		}

	}

/////////////////////////////////////////////////
//	REBUILD_SUMMARY_TYPE_ARRAY
/////////////////////////////////////////////////
	function rebuild_summary_type_array(strWinIn,strCategory){

		while(arrSummaryTypeOpts.length > 0){
			pop(arrSummaryTypeOpts);
			pop(arrSummaryTypeVals);
		}

		if((strCategory == valOpenSmry) ||
			(strCategory == valOpenNonConform)
		  ){
			for(i=0; i < arrSummaryTypeOpts_OS.length;i++){
				push(arrSummaryTypeOpts, arrSummaryTypeOpts_OS[i]);
				push(arrSummaryTypeVals, arrSummaryTypeVals_OS[i]);
		}	}
		else if(strWinIn == '1'){
			for(i=0; i < arrSummaryTypeOpts_CV.length;i++){
				push(arrSummaryTypeOpts, arrSummaryTypeOpts_CV[i]);
				push(arrSummaryTypeVals, arrSummaryTypeVals_CV[i]);
		}	}
		else{
			for(i=0; i < arrSummaryTypeOpts_SD.length;i++){
				push(arrSummaryTypeOpts, arrSummaryTypeOpts_SD[i]);
				push(arrSummaryTypeVals, arrSummaryTypeVals_SD[i]);
		}	}
	}

/////////////////////////////////////////////////
//	REBUILD_ORG_IDS
/////////////////////////////////////////////////
	function rebuild_org_ids(){

		var theForm;
		if (document.getElementById)	theForm = document.getElementById('frmCriteria').elements;
		else if (document.all)			theForm = document.all['spnCriteria'].frmCriteria.elements;
		else if (document.layers)		theForm = document.layers['spnCriteria'].document.frmCriteria.elements;

		while(arrOrgIDOpts.length > 0){
			pop(arrOrgIDOpts);
			pop(arrOrgIDVals);
		}
		frmMain.selOrgType.value == theForm.selOrgType.options[theForm.selOrgType.selectedIndex].value
		for(i=0;i < arrOrgIDs[0].length;i++){

			if(theForm.selOrgType.options[theForm.selOrgType.selectedIndex].value == arrOrgIDs[oidTypeID][i]){
				push(arrOrgIDOpts, arrOrgIDs[oidShortNm][i]);
				push(arrOrgIDVals, arrOrgIDs[oidOrgID][i]);
		}	}

		if(arrOrgIDOpts.length == 0){
			push(arrOrgIDOpts, '');
			push(arrOrgIDVals, '');
		}

		clear_select(theForm.selOrgID);
		for(i=0;i < arrOrgIDOpts.length;i++){
			blnDefSelected = ((arrOrgIDVals[i] == frmMain.selOrgID.value)||(i==0));
			blnSelected = ((arrOrgIDVals[i] == frmMain.selOrgID.value)||(i==0));
			add_option(theForm.selOrgID, theForm.selOrgID.length, arrOrgIDOpts[i], arrOrgIDVals[i], blnDefSelected, blnSelected);
			theForm.selOrgID.options[i].selected = ((arrOrgIDVals[i] == frmMain.selOrgID.value)||(i==0));
		}
	}

/////////////////////////////////////////////////
//	REBUILD_MFG_ORG_IDS
/////////////////////////////////////////////////
	function rebuild_mfg_org_ids(){

		var theForm;
		if (document.getElementById)	theForm = document.getElementById('frmCriteria').elements;
		else if (document.all)			theForm = document.all['spnCriteria'].frmCriteria.elements;
		else if (document.layers)		theForm = document.layers['spnCriteria'].document.frmCriteria.elements;

		while(arrMfgOrgIDOpts.length > 0){
			pop(arrMfgOrgIDOpts);
			pop(arrMfgOrgIDVals);
		}
		frmMain.selMfgOrgType.value == theForm.selMfgOrgType.options[theForm.selMfgOrgType.selectedIndex].value
		for(i=0;i < arrMfgOrgIDs[0].length;i++){

			if(theForm.selMfgOrgType.options[theForm.selMfgOrgType.selectedIndex].value == arrMfgOrgIDs[oidTypeID][i]){
				push(arrMfgOrgIDOpts, arrMfgOrgIDs[oidShortNm][i]);
				push(arrMfgOrgIDVals, arrMfgOrgIDs[oidOrgID][i]);
		}	}

		if(arrMfgOrgIDOpts.length == 0){
			push(arrMfgOrgIDOpts, '');
			push(arrMfgOrgIDVals, '');
		}

		clear_select(theForm.selMfgOrgID);
		for(i=0;i < arrMfgOrgIDOpts.length;i++){
			blnDefSelected = ((arrMfgOrgIDVals[i] == frmMain.selMfgOrgID.value)||(i==0));
			blnSelected = ((arrMfgOrgIDVals[i] == frmMain.selMfgOrgID.value)||(i==0));
			add_option(theForm.selMfgOrgID, theForm.selMfgOrgID.length, arrMfgOrgIDOpts[i], arrMfgOrgIDVals[i], blnDefSelected, blnSelected);
			theForm.selMfgOrgID.options[i].selected = ((arrMfgOrgIDVals[i] == frmMain.selMfgOrgID.value)||(i==0));
		}
	}

/////////////////////////////////////////////////
//	TD
/////////////////////////////////////////////////
	function TD(strAtts){

		strTag = '\n	<td';
		if (strAtts == '') return strTag + '>';

		var arrAtts, arrTemp;

		if(strAtts.indexOf(',') > -1){
			arrAtts = strAtts.split(',');

			for(i=0; i < arrAtts.length; i++){

				arrTemp = arrAtts[i].split('=');
				strTag += ' ' + arrTemp[0].toLowerCase() + '="' + arrTemp[1] + '"';
		}	}
		else{
			arrTemp = strAtts.split('=');
			strTag += ' ' + arrTemp[0].toLowerCase() + '="' + arrTemp[1] + '"';
		}
		strTag += '>';

		return strTag;
	}

/////////////////////////////////////////////////
//	INPUTTAG
/////////////////////////////////////////////////
	function InputTag(strType, strName, strVal, strAtts){

		strTag = '<input type="' + strType + '" name="' + strName + '" id="' + strName + '" value="' + strVal + '"';
		if (strAtts == '') return strTag + '\/>';

		var arrTemp;

		if (strAtts.indexOf(',') > -1){

			arrAtts = strAtts.split(',');

			for(i=0; i < arrAtts.length; i++){

				if(arrAtts[i].indexOf('=') > -1){
					arrTemp = arrAtts[i].split('=');
					strTag += ' ' + arrTemp[0].toLowerCase() + '="' + arrTemp[1] + '"';
				}
				else{
					strTag += ' ' + arrAtts[i].toLowerCase();
		}	}	}
		else{
			if(strAtts.indexOf('=') > -1){
				arrTemp = strAtts.split('=');
				strTag += ' ' + arrTemp[0].toLowerCase() + '="' + arrTemp[1] + '"';
			}
			else{
				strTag += ' ' + arrAtts[i].toLowerCase();
			}
		}
		strTag += '\/>';

		return strTag;
	}

/////////////////////////////////////////////////
//	SELECTTAG
/////////////////////////////////////////////////
	function SelectTag(strName, strAtts, arrOptions, arrVals, strDefaultVal){

		var arrAtts, arrTemp;
		strTag = '<select name="' + strName + '" id="' + strName + '"';

		if (strAtts != ''){

			arrAtts = strAtts.split(',');

			for(i=0; i < arrAtts.length; i++){

				if(arrAtts[i].indexOf('=') > -1){
					arrTemp = arrAtts[i].split('=');
					strTag += ' ' + arrTemp[0].toLowerCase() + '="' + arrTemp[1] + '"';
				}
				else{
					strTag += ' ' + arrAtts[i].toLowerCase();
		}	}	}

		strTag += '>';

		for (i = 0; i < arrOptions.length; i++){

			if (strDefaultVal != arrVals[i]){
				strTag += '<option value="' + arrVals[i] + '">' + arrOptions[i] + '<\/option>';
			}
			else{
				strTag += '<option value="' + arrVals[i] + '" selected>' + arrOptions[i] + '<\/option>';
			}
		}

		strTag += '<\/select>';

		return strTag;
	}

/////////////////////////////////////////////////
//	DISABLE_SELWINDOW
/////////////////////////////////////////////////
	function disable_selWindow(){
		clear_select(frmMain.selWindow);
		add_option(frmMain.selWindow, 0, 'N\/A', frmMain.hdnWindow.value, true, true);
		blnSelWindowEnabled = false;
	}


/////////////////////////////////////////////////
//	ENABLE_SELWINDOW
/////////////////////////////////////////////////
	function enable_selWindow(){
		clear_select(frmMain.selWindow);
		for(i=0; i < arrWindowOpts.length; i++){
			blnDefSelected = false;
			blnSelected = false;
			add_option(frmMain.selWindow, frmMain.selWindow.length, arrWindowOpts[i], arrWindowVals[i], blnDefSelected, blnSelected);
		}

		var strWinSelected = (frmMain.hdnWindow.value ? frmMain.hdnWindow.value : strWindowDef);
		for (i=0, j=frmMain.selWindow.length; i<j; i++) {
			frmMain.selWindow.options[i].selected = (frmMain.selWindow.options[i].value == strWinSelected);
		}
		blnSelWindowEnabled = true;
	}

	// -->
	</script>
<%
End Sub

Sub GenJSCommonFunctions()
If blnDebug Then RwLf "GenJSCommonFunctions()<br>"

%>
<!--#include file=include/JSFunctions.inc-->
	<script language="javascript">
	<!--
/////////////////////////////////////////////////
//	DATE FUNCTIONS
/////////////////////////////////////////////////
	function string2date(strDate, strDelim){

		var inxYear = 0;
		var inxMonth = 1;
		var inxDay = 2;

		//break up dates into year, month and date
		var arrDatePieces = strDate.split(strDATE_DELIMITER);

		//convert months to zero based (ie.  Jan = 0 not 1)
		arrDatePieces[inxMonth]--;

		//create date object
		if (arrDatePieces.length > 2) return new Date(arrDatePieces[inxYear], arrDatePieces[inxMonth], arrDatePieces[inxDay], 0, 0, 0);
		else return new Date(arrDatePieces[inxYear], arrDatePieces[inxMonth], 1, 0, 0, 0);
	}


	function date2string(dtDate){
		return (dtDate.getFullYear() + strDATE_DELIMITER + (dtDate.getMonth() + 1) + strDATE_DELIMITER + dtDate.getDate());
	}


	function tomorrow(strDate){
		return (date_add_string(strDate, 1, 'D'));
	}


	function yesterday(strDate){
		return (date_add_string(strDate, -1, 'D'));
	}


	function week_ago(strDate){
		return (date_add_string(strDate, -7, 'D'));
	}


	function last_day(strDate){

		if(	(IsValidDate(strDate))			||
			(IsValidDate(strDate + strDATE_DELIMITER + '01'))	){

			var arrDatePieces = strDate.split(strDATE_DELIMITER);
			var intYear = new Number(arrDatePieces[0]);
			var intMonth = new Number(arrDatePieces[1]);
				intMonth--;
			var dtDate;
			var dtLastDay;

			//make date object for the first day of NEXT month
			if(intMonth > 10)	dtDate = new Date((intYear + 1), 0, 1);
			else				dtDate = new Date(intYear, (intMonth + 1), 1);

			//subtract a day
			dtLastDay = date_add(dtDate, -1, 'D');

			return (date2string(dtLastDay));
		}
		else{
			return strDate;
		}

	}


	function date_add_string(strDate, intAmount, strUnits){

		if(IsValidDate(strDate)){

			var dtDate;
			var dtReturn;

			//make date object for the entered date
			dtDate = string2date(strDate);

			//subtract a day
			dtReturn = date_add(dtDate, intAmount, strUnits);

			return (date2string(dtReturn));
		}
		else{
			return strDate;
		}
	}


	function date_add(dtDate, intAmount, strUnits){

		if(IsValidDate(date2string(dtDate))){

			var dtReturn;
			var intYear		= new Number(dtDate.getFullYear());
			var intMonth	= new Number(dtDate.getMonth());
				intMonth--;
			var intDate		= new Number(dtDate.getDate());
			var intHours	= new Number(dtDate.getHours());
			var intMin		= new Number(dtDate.getMinutes());
			var intSec		= new Number(dtDate.getSeconds());
			var intMS		= new Number(dtDate.getMilliseconds());

			strUnits = strUnits.toUpperCase();
			switch(strUnits){
			case 'D':
				dtReturn = new Date(dtDate.valueOf() + (intAmount * intMILLISECS_PER_DAY));
				break;
			case 'Y':
				dtReturn = new Date(intYear + intAmount, intMonth, intDate, intHours, intMin, intSec, intMS);
				break;
			case 'M':
				if(intAmount > 0){
					for(i = intAmount;i > 0; i--){
						intMonth++;
						if(intMonth > 11){
							intMonth = 0;
							intYear++;
				}	}	}
				else{
					for(i = intAmount;i < 0; i++){
						intMonth--;
						if(intMonth < 0){
							intMonth = 11;
							intYear--;
				}	}	}
				dtReturn = new Date(intYear, intMonth, intDate, intHours, intMin, intSec, intMS);
				break;
			case 'H':
				dtReturn = new Date(dtDate.valueOf() + (intAmount * intMILLISECS_PER_HOUR));
				break;
			case 'MN':
				dtReturn = new Date(dtDate.valueOf() + (intAmount * intMILLISECS_PER_MINUTE));
				break;
			case 'S':
				dtReturn = new Date(dtDate.valueOf() + (intAmount * intMILLISECS_PER_SECOND));
				break;
			case 'MS':
				dtReturn = new Date(dtDate.valueOf() + intAmount);
				break;
			default:
				//default to days
				dtReturn = new Date(dtDate.valueOf() + (intAmount * intMILLISECS_PER_DAY));
			}

			return dtReturn;
		}
		else{
			return dtDate;
		}

	}


/////////////////////////////////////////////////
//	FORMAT_DATES
/////////////////////////////////////////////////
	function format_dates(){

		var theForm;
		if (document.getElementById)	theForm = document.getElementById('frmCriteria').elements;
		else if (document.all)			theForm = document.all['spnCriteria'].frmCriteria.elements;
		else if (document.layers)		theForm = document.layers['spnCriteria'].document.frmCriteria.elements;

		var dtToday = new Date();
		var strCurrentCategory = frmMain.selCategory.options[frmMain.selCategory.selectedIndex].value;

		var blnDaily = false;
		if(theForm.hdnDateFormat){
			blnDaily = (theForm.hdnDateFormat[inxDaily].checked);
		}
		else{
			blnDaily = (frmMain.hdnDateFormat.value == '2');
		}

		if(theForm.hdnFromDate)	frmMain.hdnFromDate.value = theForm.hdnFromDate.value;
		if(theForm.txtToDate)	frmMain.txtToDate.value = theForm.txtToDate.value;

		if(	(!(IsValidDate(frmMain.txtToDate.value)))			&&
			(!(IsValidDate(frmMain.txtToDate.value + strDATE_DELIMITER + '01')))	){

			if(strCurrentCategory == valOpen){
				frmMain.txtToDate.value = date_add_string(date2string(dtToday), 6, 'D');
			}
			else{
				frmMain.txtToDate.value = yesterday(date2string(dtToday));
		}	}

		frmMain.txtToDate.value.replace(rexWhitespace, '');
		if(blnDaily){
			if(rexMonthly.test(frmMain.txtToDate.value)){
				//frmMain.txtToDate.value = frmMain.txtToDate.value + (strSavedToDay ? strSavedToDay : strDATE_DELIMITER + '01' );
				if(strCurrentCategory == valOpen){
					frmMain.txtToDate.value = date_add_string(date2string(dtToday), 6, 'D');
				}
				else{
					frmMain.txtToDate.value = auto_to_date(frmMain.txtToDate.value);
			}	}
			else{
				if(frmMain.txtToDate.value)	strSavedToDay = frmMain.txtToDate.value.slice(frmMain.txtToDate.value.lastIndexOf(strDATE_DELIMITER), frmMain.txtToDate.value.length);
		}	}
		else{
			if(rexDaily.test(frmMain.txtToDate.value)){

				strSavedToDay = frmMain.txtToDate.value.slice(frmMain.txtToDate.value.lastIndexOf(strDATE_DELIMITER), frmMain.txtToDate.value.length);
				frmMain.txtToDate.value = frmMain.txtToDate.value.slice(0, frmMain.txtToDate.value.lastIndexOf(strDATE_DELIMITER));
		}	}

		if(	(!(IsValidDate(frmMain.hdnFromDate.value)))	&&
			(!(IsValidDate(frmMain.hdnFromDate.value + strDATE_DELIMITER + '01')))	){

			if(frmMain.txtToDate){
				if(	(IsValidDate(frmMain.txtToDate.value))			||
					(IsValidDate(frmMain.txtToDate.value + strDATE_DELIMITER + '01'))	){

					frmMain.hdnFromDate.value = week_ago(tomorrow(frmMain.txtToDate.value));
				}
				//else	frmMain.hdnFromDate.value = week_ago(yesterday(date2string(dtToday)));
				else	frmMain.hdnFromDate.value = week_ago(tomorrow(date2string(dtToday)));
		}	}

		frmMain.hdnFromDate.value.replace(rexWhitespace, '');
		if(blnDaily){
			blnNoToDate = false;
			if(rexMonthly.test(frmMain.hdnFromDate.value)){
				//frmMain.hdnFromDate.value = frmMain.hdnFromDate.value + (strSavedFromDay ? strSavedFromDay : strDATE_DELIMITER + '01' );
				if(frmMain.txtToDate){
					if(IsValidDate(frmMain.txtToDate.value)){
						frmMain.hdnFromDate.value = week_ago(tomorrow(frmMain.txtToDate.value));
					}
					else{
						blnNoToDate = true;
				}	}
				else{
					blnNoToDate = true;
			}	}
			else{
				blnNoToDate = true;
			}
			if(	(blnNoToDate)					&&
				(frmMain.hdnFromDate.value)		){

				strSavedFromDay = frmMain.hdnFromDate.value.slice(frmMain.hdnFromDate.value.lastIndexOf(strDATE_DELIMITER), frmMain.hdnFromDate.value.length);
		}	}
		else if(rexDaily.test(frmMain.hdnFromDate.value)){

				strSavedFromDay = frmMain.hdnFromDate.value.slice(frmMain.hdnFromDate.value.lastIndexOf(strDATE_DELIMITER), frmMain.hdnFromDate.value.length);
				frmMain.hdnFromDate.value = frmMain.hdnFromDate.value.slice(0, frmMain.hdnFromDate.value.lastIndexOf(strDATE_DELIMITER));
		}

		if(theForm.hdnFromDate)	theForm.hdnFromDate.value = frmMain.hdnFromDate.value;
		if(theForm.txtToDate)	theForm.txtToDate.value = frmMain.txtToDate.value;
<%
'		if(theForm.txtToDate){
'
'			if(	(!(IsValidDate(theForm.txtToDate.value)))			&&
'				(!(IsValidDate(theForm.txtToDate.value + strDATE_DELIMITER + '01')))	){
'
'				theForm.txtToDate.value = yesterday(date2string(dtToday));
'			}
'
'			theForm.txtToDate.value.replace(rexWhitespace, '');
'			if(blnDaily){
'				if(rexMonthly.test(theForm.txtToDate.value)){
'					//theForm.txtToDate.value = theForm.txtToDate.value + (strSavedToDay ? strSavedToDay : strDATE_DELIMITER + '01' );
'					theForm.txtToDate.value = auto_to_date(theForm.txtToDate.value);
'				}
'				else{
'					if(theForm.txtToDate.value)	strSavedToDay = theForm.txtToDate.value.slice(theForm.txtToDate.value.lastIndexOf(strDATE_DELIMITER), theForm.txtToDate.value.length);
'			}	}
'			else{
'				if(rexDaily.test(theForm.txtToDate.value)){
'
'					strSavedToDay = theForm.txtToDate.value.slice(theForm.txtToDate.value.lastIndexOf(strDATE_DELIMITER), theForm.txtToDate.value.length);
'					theForm.txtToDate.value = theForm.txtToDate.value.slice(0, theForm.txtToDate.value.lastIndexOf(strDATE_DELIMITER));
'		}	}	}
'
'		if(theForm.hdnFromDate){
'
'			if(	(!(IsValidDate(theForm.hdnFromDate.value)))	&&
'				(!(IsValidDate(theForm.hdnFromDate.value + strDATE_DELIMITER + '01')))	){
'
'				if(theForm.txtToDate){
'					if(	(IsValidDate(theForm.txtToDate.value))			||
'						(IsValidDate(theForm.txtToDate.value + strDATE_DELIMITER + '01'))	){
'
'						theForm.hdnFromDate.value = week_ago(theForm.txtToDate.value);
'					}
'					else	theForm.hdnFromDate.value = week_ago(yesterday(date2string(dtToday)));
'			}	}
'
'			theForm.hdnFromDate.value.replace(rexWhitespace, '');
'			if(blnDaily){
'				blnNoToDate = false;
'				if(rexMonthly.test(theForm.hdnFromDate.value)){
'					//theForm.hdnFromDate.value = theForm.hdnFromDate.value + (strSavedFromDay ? strSavedFromDay : strDATE_DELIMITER + '01' );
'					if(theForm.txtToDate){
'						if(IsValidDate(theForm.txtToDate.value)){
'							theForm.hdnFromDate.value = week_ago(theForm.txtToDate.value);
'						}
'						else{
'							blnNoToDate = true;
'						}
'					}
'					else{
'						blnNoToDate = true;
'					}
'				}
'				else{
'					blnNoToDate = true;
'				}
'				if(	(blnNoToDate)					&&
'					(theForm.hdnFromDate.value)		){
'
'					strSavedFromDay = theForm.hdnFromDate.value.slice(theForm.hdnFromDate.value.lastIndexOf(strDATE_DELIMITER), theForm.hdnFromDate.value.length);
'			}	}
'			else if(rexDaily.test(theForm.hdnFromDate.value)){
'
'					strSavedFromDay = theForm.hdnFromDate.value.slice(theForm.hdnFromDate.value.lastIndexOf(strDATE_DELIMITER), theForm.hdnFromDate.value.length);
'					theForm.hdnFromDate.value = theForm.hdnFromDate.value.slice(0, theForm.hdnFromDate.value.lastIndexOf(strDATE_DELIMITER));
'		}	}
%>
	}


	function auto_to_date(strDate){

		if(	(IsValidDate(strDate))			||
			(IsValidDate(strDate + strDATE_DELIMITER + '01'))	){

			var dtToday = new Date();
			var dtDate;
			var arrDatePieces	= strDate.split(strDATE_DELIMITER);
			var intYear			= new Number(arrDatePieces[0]);
			var intMonth		= new Number(arrDatePieces[1]);
			var intJSMonth		= intMonth - 1;
			var intDate			= new Number(dtToday.getDate());
			if(arrDatePieces.length > 2)	intDate = new Number(arrDatePieces[2]);

			if(	(intJSMonth == dtToday.getMonth())	&&
				(intYear == dtToday.getFullYear())	){

				return(yesterday(intYear + strDATE_DELIMITER + intMonth + strDATE_DELIMITER + intDate));
			}
			else{

				return(last_day(intYear + strDATE_DELIMITER + intMonth + strDATE_DELIMITER + intDate));
		}	}
		else{
			return strDate;
		}

	}

	// -->
	</script>
<%
End Sub

'************************** JS Function process_form ******************
Sub GenJS_command_functions()
If blnDebug Then RwLf "GenJS_command_functions()<br>"

%>
	<script language="javascript">
	<!--
/////////////////////////////////////////////////
//	PROCESS_FORM
/////////////////////////////////////////////////
		function process_form(){
			if(check_edits()){


				var strView		= frmMain.selView.options[frmMain.selView.selectedIndex].value;
				var strCategory	= frmMain.selCategory.options[frmMain.selCategory.selectedIndex].value;

				if(!(
					(strView == valCustWW)		&&
						((strCategory == valCustList)	||
						(strCategory == valWWList)		)
					)){
					clear_hidden_fields();
				}
				update();

<%			IF blnJSDebug THEN
				rwlf "alert(frmMain.hdnDateFormat.value);"
				rwlf "alert(frmMain.hdnFromDate.value);"
				rwlf "alert(frmMain.txtToDate.value);"
				rwlf "alert(frmMain.hdnPartNbr.value);"
				rwlf "alert(frmMain.txtPartNbr.value);"
%>				if(confirm('Submit?')){
					frmMain.hdnCommand.value = 'SUBMIT';
					frmMain.submit();
				}
<%			ELSE
%>				frmMain.hdnCommand.value = 'SUBMIT';
				frmMain.submit();
<%			END IF
%>
			}
		}

/////////////////////////////////////////////////
//	RESTORE_DEFAULTS
/////////////////////////////////////////////////
		function restore_defaults(){
			frmMain.hdnCommand.value = 'DEFAULTS';
			frmMain.submit();
		}

/////////////////////////////////////////////////
//	PARTNBR_LOOKUP
/////////////////////////////////////////////////
		function partnbr_lookup(){
		    update();
			frmMain.hdnCommand.value = 'PARTNBR';
			frmMain.hdnPartNbr.value = frmMain.txtPartNbr.value;
			frmMain.submit();
		}

/////////////////////////////////////////////////
//	INVORGPLANT_LOOKUP
/////////////////////////////////////////////////
		function invorgplant_lookup(){
			update();
<%			IF blnJSDebug THEN
				rwlf "alert(frmMain.txtInvOrgPlant.value);"
			END IF
%>
			frmMain.hdnCommand.value = 'INVORGPLANT';
			frmMain.hdnInvOrgPlant.value = frmMain.txtInvOrgPlant.value;
			frmMain.submit();
		}

/////////////////////////////////////////////////
//	CONTROLLER_LOOKUP
/////////////////////////////////////////////////
		function controller_lookup(){
			update();
<%			IF blnJSDebug THEN
				rwlf "alert(frmMain.txtController.value);"
			END IF
%>
			if (frmMain.txtInvOrgPlant.value == '')
			{
				alert('Please enter an Inv Org/Plant required for Controller lookup.');
				return;
			}
			frmMain.hdnCommand.value = 'CONTROLLER';
			frmMain.hdnController.value = frmMain.txtController.value;
			frmMain.submit();
		}

/////////////////////////////////////////////////
//	MRPGROUP_LOOKUP
/////////////////////////////////////////////////
		function mrpgroup_lookup(){
			update();
<%			IF blnJSDebug THEN
				rwlf "alert(frmMain.txtMrpGroup.value);"
			END IF
%>
			frmMain.hdnCommand.value = 'MRPGROUP';
			frmMain.hdnMrpGroup.value = frmMain.txtMrpGroup.value;
			frmMain.submit();
		}

/////////////////////////////////////////////////
//	SALESOFFICE_LOOKUP
/////////////////////////////////////////////////
		function salesoffice_lookup(){
			update();
<%			IF blnJSDebug THEN
				rwlf "alert(frmMain.txtSalesOffice.value);"
			END IF
%>
			frmMain.hdnCommand.value = 'SALESOFFICE';
			frmMain.hdnSalesOffice.value = frmMain.txtSalesOffice.value;
			frmMain.submit();
		}

/////////////////////////////////////////////////
//	SALESGROUP_LOOKUP
/////////////////////////////////////////////////
		function salesgroup_lookup(){
			update();
<%			IF blnJSDebug THEN
				rwlf "alert(frmMain.txtSalesGroup.value);"
			END IF
%>
			if (frmMain.txtSalesOffice.value == '')
			{
				alert('Please enter a Sales Office required for Sales Group lookup.');
				return;
			}
			frmMain.hdnCommand.value = 'SALESGROUP';
			frmMain.hdnSalesGroup.value = frmMain.txtSalesGroup.value;
			frmMain.submit();

		}

/////////////////////////////////////////////////
//	PRODHOSTORGID_LOOKUP
/////////////////////////////////////////////////
		function prodhostorgid_lookup(){
			update();
<%			IF blnJSDebug THEN
				rwlf "alert(frmMain.txtProdHostOrgID.value);"
			END IF
%>
			frmMain.hdnCommand.value = 'PRODHOSTORGID';
			frmMain.hdnProdHostOrgID.value = frmMain.txtProdHostOrgID.value;
			frmMain.submit();
		}
	// -->
	</script>
<%
End Sub


'************************** JS Function check_edits ******************
Sub GenJS_check_edits()
If blnDebug Then RwLf "GenJS_check_edits()<br>"

%>
	<script language="javascript">
	<!--

/////////////////////////////////////////////////
//	CHECK_EDITS
/////////////////////////////////////////////////
	function check_edits(){

		var theForm;
		if (document.getElementById)	theForm = document.getElementById('frmCriteria').elements;
		else if (document.all)			theForm = document.all['spnCriteria'].frmCriteria.elements;
		else if (document.layers)		theForm = document.layers['spnCriteria'].document.frmCriteria.elements;

		var blnContinue = false;

		var inxView		= frmMain.selView.selectedIndex;
		var strView		= frmMain.selView.options[inxView].value;
		var strCategory	= frmMain.selCategory.options[frmMain.selCategory.selectedIndex].value;
		var strWindow	= frmMain.selWindow.options[frmMain.selWindow.selectedIndex].value;

		var blnMonthlyFormat = true;
		if(theForm.hdnDateFormat){
			blnMonthlyFormat = (!(theForm.hdnDateFormat[inxDaily].checked));
			theForm.hdnDateFormat[inxMonthly].checked = blnMonthlyFormat;
		}
		else if(theForm.hdnFromDate){
			frmMain.hdnDateFormat.value = '1';
		}

		switch(blnContinue){
		case false:

			//These will only apply to times when these elements are visible

			//are the date range fields filled in and valid?
			//Valid dates are not in future and From is before or same as To
			if(	(theForm.hdnFromDate)	&&
				(theForm.txtToDate)		){

				if(!(valid_dates(theForm.hdnFromDate, theForm.txtToDate, (!(blnMonthlyFormat)), (strCategory==valLeadTime)))){
					break;
			}	}

			if(theForm.txtDaysEarly){
				if(	(isNaN(theForm.txtDaysEarly.value))	||
					(!(theForm.txtDaysEarly.value))		){
					alert('Please enter a valid number for Days Early');
					set_focus(theForm.txtDaysEarly);
					break;
				}
				if(theForm.txtDaysEarly.value > 5){
					alert('Days Early cannot be greater than 5');
					set_focus(theForm.txtDaysEarly);
					break;
			}	}
			if(theForm.txtDaysLate){
				if(	(isNaN(theForm.txtDaysLate.value))	||
					(!(theForm.txtDaysLate.value))		){
					alert('Please enter a valid number for Days Late');
					set_focus(theForm.txtDaysLate);
					break;
				}
				if(theForm.txtDaysLate.value > 5){
					alert('Days Late cannot be greater than 5');
					set_focus(theForm.txtDaysLate);
					break;
			}	}

			if(theForm.txtOrgDt){
				if(!(IsValidDate(theForm.txtOrgDt.value))){
					alert('Please enter a valid Org Date');
					set_focus(theForm.txtOrgDt);
					break;
			}	}

			if(theForm.txtController){
				if(theForm.txtController.value){
					if(!(value_exists(theForm.txtInvOrgPlant, 'Please enter an Inventory Org\/Plant when a Controller is entered.'))) break;
			}	}

			if(theForm.selOrgType){
				if(!(theForm.selOrgType.options[theForm.selOrgType.selectedIndex].value)){
					alert('Please select an Org Type');
					set_focus(theForm.selOrgType);
					break;
			}	}

			if(theForm.selOrgID){
				if(!(theForm.selOrgID.options[theForm.selOrgID.selectedIndex].value)){
					alert('Please select an Org ID');
					set_focus(theForm.selOrgID);
					break;
			}	}

			if(theForm.txtShipTo){
				strTemp = theForm.txtShipTo.value.replace(/-/g, '');
				if(strTemp.length > 10){
					alert('Please enter a valid Ship-To Number');
					set_focus(theForm.txtShipTo);
					break;
			}	}

			if(theForm.txtSoldTo){
				strTemp = theForm.txtSoldTo.value.replace(/-/g, '');
				if(strTemp.length > 8){
					alert('Please enter a valid Sold-To Number');
					set_focus(theForm.txtSoldTo);
					break;
			}	}

			if(theForm.txtWWNbr){
				strTemp = theForm.txtWWNbr.value.replace(/-/g, '');
				if(strTemp.length > 10){
					alert('Please enter a valid World Wide Number');
					set_focus(theForm.txtWWNbr);
					break;
			}	}

	//***********************************/
	//edits specific to Organization View
	//***********************************/
			if(strView == valOrganization){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				if(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			||
					(strCategory == valLeadTime)		){

					if(theForm.selOrgID){
						//look up level
						strOrgID = theForm.selOrgID.options[theForm.selOrgID.selectedIndex].value;
						blnBreak = false;
						for(i=0; i < arrOrgIDs[oidTypeID].length; i++){

							if(strOrgID == arrOrgIDs[oidOrgID][i]){
								if(higher_than_company(arrOrgIDs[oidTypeID][i])){

									alert('Please choose an Org ID of Company level or below');
									set_focus(theForm.selOrgType);
									blnBreak = true;
									break;
						}	}	}
						if(blnBreak)	break;
				}	}
			}
	//***********************************/
	//edits specific to Bldg Location View
	//***********************************/
			else if(strView == valBldgLocation){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				if(theForm.txtPlantBldgNbr){
					if(!(value_exists(theForm.txtPlantBldgNbr, 'Please enter a Plant\/Building Number'))) break;
				}
			}
	//***********************************/
	//edits specific to Customer WW View
	//***********************************/
			else if(strView == valCustWW){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				//if(	(theForm.txtCustomerNbr)	&&
				//		(theForm.txtWWNbr)			){
				if(	(theForm.txtShipTo)	&&
					(theForm.txtSoldTo)	&&
					(theForm.txtWWNbr)	){

					if(theForm.txtWWNbr.value){
						//if(theForm.txtCustomerNbr.value){
						//	alert('Please select a Customer Org ID when entering a Customer Number');
						//	set_focus(theForm.selCustOrgID);
						//	break;
						//}
						if(	(theForm.txtShipTo.value)	||
							(theForm.txtSoldTo.value)	){

							if(theForm.selCustOrgID.options[theForm.selCustOrgID.selectedIndex].value == ''){

								alert('Please select a Customer Org ID when entering a Ship-To or Sold-To Number');
								set_focus(theForm.selCustOrgID);
								break;
						}	}
						else{
							theForm.selCustOrgID.selectedIndex = 0;
						}
					}
					else{
						//if(!(theForm.txtCustomerNbr.value)){
						//	alert('Please enter a Customer Number or a World Wide Number');
						//	set_focus(theForm.txtCustomerNbr);
						//	break;
						//}
						if((!(theForm.txtShipTo.value))	&&
							(!(theForm.txtSoldTo.value))){
							alert('Please enter a Ship-To, Sold-To or a World Wide Number');
							set_focus(theForm.txtWWNbr);
							break;
						}
						else if(theForm.selCustOrgID.options[theForm.selCustOrgID.selectedIndex].value == ''){
							alert('Please select a Customer Org ID when entering a Ship-To or Sold-To Number');
							set_focus(theForm.selCustOrgID);
							break;
					}	}

				}
				//else if(theForm.txtCustomerNbr){
				else if((theForm.txtShipTo)	&&
						(theForm.txtSoldTo)	){

					//if(!(theForm.txtCustomerNbr.value)){
                    //
					//	alert('Please select a Customer Org ID and enter a Customer Number');
					//	set_focus(theForm.txtCustomerNbr);
					//	break;
					//}
					if(	(!(theForm.txtShipTo.value))	&&
						(!(theForm.txtSoldTo.value))	){

						alert('Please enter a Ship-To and\/or Sold-To number');
						if(theForm.txtShipTo)		set_focus(theForm.txtShipTo);
						else if(theForm.txtSoldTo)	set_focus(theForm.txtSoldTo);
						break;
					}
					else if(theForm.selCustOrgID.options[theForm.selCustOrgID.selectedIndex].value == ''){

						alert('Please select a Customer Org ID');
						set_focus(theForm.selCustOrgID);
						break;
				}	}
				else if(theForm.txtShipTo){

					if(theForm.txtShipTo.value){

						if(theForm.selCustOrgID.options[theForm.selCustOrgID.selectedIndex].value == ''){

							alert('Please select a Customer Org ID when entering a Ship-To or Sold-To Number');
							set_focus(theForm.selCustOrgID);
							break;
					}	}
					else{
						alert('Please enter a Ship-To Number and Customer Org ID');
						break;
				}	}
				else if(theForm.txtWWNbr){
					if(!(theForm.txtWWNbr.value)){

						alert('Please enter a World Wide Number');
						set_focus(theForm.txtWWNbr);
						break;
				}	}

				if(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			||
					(strCategory == valLeadTime)		){

					if(theForm.selOrgID){
						//look up level
						strOrgID = theForm.selOrgID.options[theForm.selOrgID.selectedIndex].value;
						blnBreak = false;
						for(i=0; i < arrOrgIDs[oidTypeID].length; i++){

							if(strOrgID == arrOrgIDs[oidOrgID][i]){
								if(higher_than_company(arrOrgIDs[oidTypeID][i])){

									alert('Please choose an Org ID of Company level or below');
									set_focus(theForm.selOrgType);
									blnBreak = true;
									break;
						}	}	}
						if(blnBreak)	break;
				}	}
			}
	//***********************************/
	//edits specific to Shipping Facility View
	//***********************************/
			else if(strView == valShippingFac){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				if(!(value_exists(theForm.txtPlantBldgNbr, 'Please enter a Plant\/Building Number'))) break;

				if(	(strCategory != valConforming)		&&
					(strCategory != valNonConforming)	){

					if(theForm.txtLocation){
						if(!(value_exists(theForm.txtLocation, 'Please enter a Location Code'))) break;
				}	}
			}
	//***********************************/
	//edits specific to Team View
	//***********************************/
			else if(strView == valTeam){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				if(theForm.selOrgType.options[theForm.selOrgType.selectedIndex].value == '1'){
					alert('An Org Type of \'Global\' is invalid for the Team view');
					set_focus(theForm.selOrgType);
					break;
				}

				if(theForm.txtTeam){
					if(!(value_exists(theForm.txtTeam, 'Please enter a Team'))) break;
				}
			}
	//***********************************/
	//edits specific to Controller View
	//***********************************/
			else if(strView == valController){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				if(	(	(strCategory == valControllerList) ||
						(strCategory == valOrgList)
					)	&&
					(theForm.selOrgType.options[theForm.selOrgType.selectedIndex].value == '1')
				  ){

					//alert('An Org Type of \'Global\' is invalid for the Controller view');
					alert('An Org Type of \'Global\' is invalid for this view and category combination');
					set_focus(theForm.selOrgType);
					break;
				}

				if(strCategory != valControllerList){
					if(	(!(value_exists(theForm.txtInvOrgPlant, 'Please enter an Inventory Org/Plant')))	||
						(!(value_exists(theForm.txtController, 'Please enter a Controller')))	){

						break;
					}
				} else {
					if(	(theForm.txtMakeStock.value || theForm.txtMrpGroup.value) &&
						(blnMonthlyFormat) &&
						(theForm.txtCntrllerEmpNbr.value) ){
						alert('For Monthly, Controller Emp Nbr entry is not allowed when Make Stock and/or MRP Group value are also entered and vise versa');
						set_focus(theForm.txtCntrllerEmpNbr);
						blnBreak = false;
						break;
					}
				}

				if(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			||
					(strCategory == valLeadTime)		){

					if(theForm.selOrgID){
						//look up level
						strOrgID = theForm.selOrgID.options[theForm.selOrgID.selectedIndex].value;
						blnBreak = false;
						for(i=0; i < arrOrgIDs[oidTypeID].length; i++){

							if(strOrgID == arrOrgIDs[oidOrgID][i]){
								if(higher_than_company(arrOrgIDs[oidTypeID][i])){

									alert('Please choose an Org ID of Company level or below');
									set_focus(theForm.selOrgType);
									blnBreak = true;
									break;
						}	}	}
						if(blnBreak)	break;
				}	}
			}
	//***********************************/
	//edits specific to Make Stock View
	//***********************************/
			else if(strView == valMakeStock){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				//if(	(strCategory != valMakeStockList)	&&
				//	(!(value_exists(theForm.txtMakeStock, 'Please enter Make Stock')))){

				//	break;
				//}
				if (strCategory != valMakeStockList) {
				   if( !((theForm.txtMakeStock.value) || (theForm.txtMrpGroup.value))) {
				      alert('Please enter Make Stock and/or MRP Group');
				      set_focus(theForm.txtMakeStock);
				      break;
				   }
                }

				if(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			||
					(strCategory == valLeadTime)		){

					if(theForm.selOrgID){
						//look up level
						strOrgID = theForm.selOrgID.options[theForm.selOrgID.selectedIndex].value;
						blnBreak = false;
						for(i=0; i < arrOrgIDs[oidTypeID].length; i++){

							if(strOrgID == arrOrgIDs[oidOrgID][i]){
								if(higher_than_company(arrOrgIDs[oidTypeID][i])){

									alert('Please choose an Org ID of Company level or below');
									set_focus(theForm.selOrgType);
									blnBreak = true;
									break;
						}	}	}
						if(blnBreak)	break;
				}	}
			}
	//***********************************/
	//edits specific to Product Code View
	//***********************************/
			else if(strView == valProdCode){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				if(	(strCategory != valGPLList)	&&
					(strCategory != valPCList)	){

					if(	(!(theForm.txtGblProductLine.value))	&&
						(!(theForm.txtProductCode.value))	){

							value_exists(theForm.txtGblProductLine, 'Please enter either a Global Product Line or\na Product Code');
							break;
				}	}

				if(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			||
					(strCategory == valLeadTime)		){

					if(theForm.selOrgID){
						//look up level
						strOrgID = theForm.selOrgID.options[theForm.selOrgID.selectedIndex].value;
						blnBreak = false;
						for(i=0; i < arrOrgIDs[oidTypeID].length; i++){

							if(strOrgID == arrOrgIDs[oidOrgID][i]){
								if(higher_than_company(arrOrgIDs[oidTypeID][i])){

									alert('Please choose an Org ID of Company level or below');
									set_focus(theForm.selOrgType);
									blnBreak = true;
									break;
						}	}	}
						if(blnBreak)	break;
				}	}

				if(	strCategory != valLeadTime){
					if(	(theForm.txtSoldTo.value)	){

						if(theForm.selCustOrgID.options[theForm.selCustOrgID.selectedIndex].value == ''){

							alert('Please select a Customer Org ID when entering a Sold-To Number');
							set_focus(theForm.selCustOrgID);
							break;
					}	}
					else{
						theForm.selCustOrgID.selectedIndex = 0;
					}
				}
			}
	//***********************************/
	//edits specific to Industry Code View
	//***********************************/
			else if(strView == valIndustryCde){

				//if(	(strCategory == valNonConforming)	||
				//	(strCategory == valConforming)		||
				//	(strCategory == valPastDue)			||
				//	(strCategory == valOpen)			||
				//	(strCategory == valLeadTime)		){
				if(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			){

					if(	(blnMonthlyFormat)					&&
						(strCategory != valLeadTime)		){

						//check size of date range
						if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
							set_focus(theForm.txtToDate);
							break;
					}	}

					if(	(!(theForm.txtIndustryCde.value))			&&
						(!(theForm.selIndustryBusCde.value))	) {
						if(!(value_exists(theForm.txtIndustryCde, 'Please enter Industry Business and/or Industry Code'))) break;
					}

				}

				if(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			||
					(strCategory == valLeadTime)		){

					if(theForm.selOrgID){
						//look up level
						strOrgID = theForm.selOrgID.options[theForm.selOrgID.selectedIndex].value;
						blnBreak = false;
						for(i=0; i < arrOrgIDs[oidTypeID].length; i++){

							if(strOrgID == arrOrgIDs[oidOrgID][i]){
								if(higher_than_company(arrOrgIDs[oidTypeID][i])){

									alert('Please choose an Org ID of Company level or below');
									set_focus(theForm.selOrgType);
									blnBreak = true;
									break;
						}	}	}
						if(blnBreak)	break;
				}	}
			}
	//***********************************/
	//edits specific to Manufacturing Bldg View
	//***********************************/
			else if(strView == valMfgBldg){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				if(	(strCategory != valCampusList)	&&
					(strCategory != valBldgList)	){

					if(	(!(theForm.txtMfgCampusID.value))	&&
						(!(theForm.txtMfgBldgNbr.value))	){

						if(theForm.selMfgOrgID){
							//look up level
							strMfgOrgID = theForm.selMfgOrgID.options[theForm.selMfgOrgID.selectedIndex].value;
							blnBreak = false;
							for(i=0; i < arrMfgOrgIDs[oidTypeID].length; i++){

								if(strMfgOrgID == arrMfgOrgIDs[oidOrgID][i]){
									if(higher_than_company(arrMfgOrgIDs[oidTypeID][i])){

										alert('Please make sure you have entered one of the following:\n - A Manufacturing Campus ID\n - A Manufacturing Bldg Number\n - A Mfg Org Type of Company or lower');
										set_focus(theForm.selMfgOrgType);
										blnBreak = true;
										break;
							}	}	}
							if(blnBreak)	break;
						}
				}	}

				if(strCategory == valBldgList){
					if(theForm.selMfgOrgID){
						//look up level
						strMfgOrgID = theForm.selMfgOrgID.options[theForm.selMfgOrgID.selectedIndex].value;
						blnBreak = false;
						for(i=0; i < arrMfgOrgIDs[oidTypeID].length; i++){

							if(strMfgOrgID == arrMfgOrgIDs[oidOrgID][i]){
								if(higher_than_company(arrMfgOrgIDs[oidTypeID][i])){

									alert('Please choose a Mfg Org ID of Company level or below');
									set_focus(theForm.selMfgOrgType);
									blnBreak = true;
									break;
						}	}	}
						if(blnBreak)	break;
				}	}
			}
	//***********************************/
	//edits specific to Profit Center View
	//***********************************/
			else if(strView == valProfitCtr){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				if(	(strCategory != valIBCList)				&&
					(strCategory != valProfitCtrList)		&&
					(strCategory != valCompetencyBusList)	){

					if(	(!(theForm.selProfitCtr.value))			&&
						(!(theForm.selIndustryBusCde.value))	&&
						(!((theForm.selCompetencyBusCde.value) || (theForm.txtSubCompetencyBusCde.value)))	){

							value_exists(theForm.selProfitCtr, 'Please enter one of the following:\n\n  --  Profit Center\n  --  Industry Business Code\n  --  Competency Business Code');
							break;
				}	}

			}
	//***********************************/
	//edits specific to SAP Sales View
	//***********************************/
			else if(strView == valSAPSales){

				if(	(blnMonthlyFormat)
				&&(	(strCategory == valNonConforming)	||
					(strCategory == valConforming)		||
					(strCategory == valPastDue)			||
					(strCategory == valOpen)			)
				){
					//check size of date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths))){
						set_focus(theForm.txtToDate);
						break;
				}	}

				if( (theForm.txtSalesOffice)
				&& (strCategory != valSalesGroupList)
				){
					if(!(value_exists(theForm.txtSalesOffice, 'Please enter a Sales Office'))) break;
				}
			}
	//***********************************/

			blnContinue = true;
			break;
		default:
			blnContinue = false;
		}

		return blnContinue;
	}

/////////////////////////////////////////////////
//	HIGHER_THAN_COMPANY
/////////////////////////////////////////////////
	function higher_than_company(intOrgTypeID){

		return(	(intOrgTypeID == '1')	||
				(intOrgTypeID == '2')	||
				(intOrgTypeID == '3')	);

	}

/////////////////////////////////////////////////
//	SET_FOCUS
/////////////////////////////////////////////////
	function set_focus(objElement){

		objElement.focus();
		if(	(objElement.type == 'text')		||
			(objElement.type == 'password')	||
			(objElement.type == 'textarea')	){

			objElement.select();
		}
	}

/////////////////////////////////////////////////
//	VALUE_EXISTS
/////////////////////////////////////////////////
	function value_exists(objElement, strMessage){

		var blnEmpty = true;

		if(objElement){

			blnEmpty = (!(objElement.value));

			if(blnEmpty){
				alert(strMessage);
				set_focus(objElement);
		}	}

		return (!(blnEmpty));
	}


/////////////////////////////////////////////////
//	VALID_DATES
/////////////////////////////////////////////////
	function valid_dates(objFromDate, objToDate, blnDaily, blnLeadTime){

		//create date objects
		var dtFromDate = false;
		var dtToDate = false;
		var dtToday = new Date();

		var strCategory = frmMain.selCategory.options[frmMain.selCategory.selectedIndex].value;

		var strFromAfterToMsg = 'Please ensure that the \'To\' date is later than or the same as the \'From\' date.';
		var strNoFutureDatesMsg = 'Please enter a date that is no later than today';
		var strBadDateMsg = 'Please enter a valid date in the selected format';

		if(objToDate){

			if(	(	(blnDaily) &&
					(!(IsValidDate(objToDate.value)))
			)||(	(!(blnDaily)) &&
					(!(IsValidDate(objToDate.value + strDATE_DELIMITER + '01')))
				)
			){
				alert(strBadDateMsg);
				set_focus(objToDate);
				return false;
			}

			dtToDate = string2date(objToDate.value, strDATE_DELIMITER);

			//ensure that date is earlier than or equal to today if Open is not the category
			if(	(strCategory != valOpen)	&&
				(strCategory != valOpenSmry) &&
				(dtToDate > dtToday)		){

				alert(strNoFutureDatesMsg);
				set_focus(objToDate);
				return false;
		}	}

		if(objFromDate){

			if(	(	(blnDaily) &&
					(!(IsValidDate(objFromDate.value)))
			)||(	(!(blnDaily)) &&
					(!(IsValidDate(objFromDate.value + strDATE_DELIMITER + '01')))
				)
			){
				alert(strBadDateMsg);
				set_focus(objFromDate);
				return false;
			}

			dtFromDate = string2date(objFromDate.value, strDATE_DELIMITER);

			if(dtFromDate && dtToDate){

				//ensure From date comes before To date
				if(dtFromDate > dtToDate){
					alert(strFromAfterToMsg);
					if(dtFromDate > dtToday)	set_focus(objFromDate);
					else						set_focus(objToDate);
					return false;
				}

				if(blnLeadTime){
					//check size of monthly date range
					if(!(date_range_within_monthly_limit(theForm.hdnFromDate, theForm.txtToDate, intMaxDateRange_inMonths_LT)))	return false;
				}
				else{
					if(blnDaily){
						//check size of daily date range
						if(!(date_range_within_daily_limit(objFromDate, objToDate, intMaxDateRange_inDays)))	return false;
			}	}	}

			//ensure that date is earlier than or equal to today if Open is not the category
			if(	(strCategory != valOpen)	&&
				(strCategory != valOpenSmry) &&
				(dtFromDate > dtToday)		){

				alert(strNoFutureDatesMsg);
				set_focus(objFromDate);
				return false;
		}	}

		return true;
	}


/////////////////////////////////////////////////
//	DATE_RANGE_WITHIN_DAILY_LIMIT
/////////////////////////////////////////////////
	function date_range_within_daily_limit(objFromDate, objToDate, intLimitInDays){

		//create date objects
		var dtFromDate = string2date(objFromDate.value, strDATE_DELIMITER);
		var dtToDate = string2date(objToDate.value, strDATE_DELIMITER);
		var dtToday = new Date();

		//difference in milliseconds
		intDiff_inMSecs = dtToDate - dtFromDate;

		//calculate days and convert to string
		var strDiff_inDays = new String(intDiff_inMSecs / intMILLISECS_PER_DAY);

		//find the decimal point
		var intPointInx = strDiff_inDays.indexOf('.');

		var intDiff_inWholeDays;

		//get just the whole days
		if(intPointInx >= 0){
			intDiff_inWholeDays = strDiff_inDays.substring(0, intPointInx);
		}
		else{
			intDiff_inWholeDays = strDiff_inDays;
		}

		//add one because range is inclusive
		intDiff_inWholeDays++;

		if(intDiff_inWholeDays <= intLimitInDays){
			return true;
		}
		else{
			alert('Please enter a date range covering ' + intLimitInDays + ' days or less.\nYour entered date range covers ' + intDiff_inWholeDays + ' days.');
			set_focus(objToDate);
			return false;
		}
	}


/////////////////////////////////////////////////
//	DATE_RANGE_WITHIN_MONTHLY_LIMIT
/////////////////////////////////////////////////
	function date_range_within_monthly_limit(objFromDate, objToDate, intLimitInMonths){

		//create date objects
		var dtFromDate = string2date(objFromDate.value, strDATE_DELIMITER);
		var dtToDate = string2date(objToDate.value, strDATE_DELIMITER);
		var dtToday = new Date();

		strMsg = 'Please enter a date range of no more than ' + intLimitInMonths + ' month';
		if(dtToDate.getFullYear() == dtFromDate.getFullYear()){

			if((dtToDate.getMonth() - dtFromDate.getMonth()) < intLimitInMonths){
				return true;
			}
			else{
				if(intLimitInMonths != 1) strMsg += 's';
				strMsg += '.';
				alert(strMsg);
				return false;
		}	}
		else{
			var intTotalMonths = 12 - dtFromDate.getMonth();
			for(var yyyy = dtFromDate.getFullYear() + 1; yyyy <= dtToDate.getFullYear(); yyyy++){

				if(yyyy == dtToDate.getFullYear()){
					for(mm = 0; mm <= dtToDate.getMonth(); mm++){

						intTotalMonths++;
				}	}
				else intTotalMonths += 12;
			}

			if(intTotalMonths <= intLimitInMonths){
				return true;
			}
			else{
				if(intLimitInMonths != 1) strMsg += 's';
				strMsg += '.';
				alert(strMsg);
				return false;
		}	}
	}

	// -->
	</script>
<%
End Sub


'***********************************************************************
'*********	Misc Internal Functions
'***********************************************************************

Sub GoURL(strGoURL)
	CleanUp
	Response.Clear
	Response.Redirect strGoURL
	Response.End
End Sub


Sub CleanUp()
	'Add any clean up activities to this sub

	Set objSearch = Nothing
End Sub


Sub ReportError(vntEN, vntED, vntEW)

	objError = vntEN
	errDesc = vntED
	errWhere = vntEW
	blnError = True
End Sub


Function FormatJSstring(strIn)
	FormatJSstring = Replace(Replace(Trim(strIn), "/", "\/"), "'", "\'")
End Function


Function FormatWords(strIn)
FormatWords = vbNullString

	Dim inxChar, inx, strOut

	If Len(strIn) > 1 Then
		strOut = Trim(strIn)
		If Left(strOut, 4) = "SAP " then
			strOut = FormatJSstring(UCase(Left(strOut, 4)) & LCase(Mid(strOut, 5)))
		Else
			strOut = FormatJSstring(UCase(Left(strOut, 1)) & LCase(Mid(strOut, 2)))
		End If
		strOut = CapAfterChar(strOut, " ")
		strOut = CapAfterChar(strOut, "/")
		strOut = CapAfterChar(strOut, "-")
		strOut = CapAfterChar(strOut, ",")
		strOut = CapAfterChar(strOut, ".")
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

Sub Rw(strIn)
	Response.Write strIn
End Sub

Sub RwLf(strIn)
	Response.Write strIn
	Response.Write vbCrLf
End Sub

Sub RwLfRequest()
	Dim thingy
	RwLf "<h2>Request Querystring</h2>"
	For Each thingy in Request.querystring
		If Request.querystring(thingy) <> vbNullString Then RwLf thingy & " = " & Request.querystring(thingy) & "<br>"
	Next
	RwLf "<h2>Request Vars</h2>"
	For Each thingy in Request.form
		If Request.Form(thingy) <> vbNullString Then RwLf thingy & " = " & Request.Form(thingy) & "<br>"
	Next
End Sub
%>