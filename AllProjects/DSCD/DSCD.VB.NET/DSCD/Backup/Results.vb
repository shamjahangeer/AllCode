Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsResults
    Inherits ServicedComponent
	
    '##ModelId=3A9294480365
	Private Const bPoolSetting As Boolean = False
	
	'##ModelId=3A9298BC000F
	Private ObjContext As System.EnterpriseServices.ContextUtil
	
	'##ModelId=3A8BF545025F
    Public Function ListSummDaily(ByVal vntSessionID As String, ByRef vntSumLate As Object, ByRef vntSumEarly As Object, ByRef vntSumEarlyPercnt As Object, ByRef vntSumLatePercnt As Object, ByRef vntOnTime As Object, ByRef vntCenter1 As Object, ByRef vntCenter3 As Object, ByRef vntCenter4 As Object, ByRef vntCenter5 As Object, ByRef vntCenter6 As Object, ByRef vntCenter7 As Object, ByRef vntCenter8 As Object, ByRef vnt6Early As Object, ByRef vnt5Early As Object, ByRef vnt4Early As Object, ByRef vnt3Early As Object, ByRef vnt2Early As Object, ByRef vnt1Early As Object, ByRef vnt1Late As Object, ByRef vnt2Late As Object, ByRef vnt3Late As Object, ByRef vnt4Late As Object, ByRef vnt5Late As Object, ByRef vnt6Late As Object, ByRef vntEStep1 As Object, ByRef vntEStep2 As Object, ByRef vntEStep3 As Object, ByRef vntEStep4 As Object, ByRef vntEStep5 As Object, ByRef vntEStep6 As Object, ByRef vntLStep1 As Object, ByRef vntLStep2 As Object, ByRef vntLStep3 As Object, ByRef vntLStep4 As Object, ByRef vntLStep5 As Object, ByRef vntLStep6 As Object, ByRef vntTotal As Object, ByRef vntJITEarly As Object, ByRef vntJITEarlyPercnt As Object, ByRef vntJITLate As Object, ByRef vntJITLatePercnt As Object, ByRef vntWindowId As Object, ByRef vntDaysEarly As Object, ByRef vntDaysLate As Object, ByRef vntInWindowPercnt As Object, ByRef vntInWindow As Object, ByRef vntSmryType As Object, ByRef vntDispCrit As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String, ByRef strSql As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim objSearch As New clsSearch
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
        Dim vntCount As Object
        Dim vntArray As Object = Nothing
        Dim dblTemp1 As Double
        Dim dblTemp2 As Double
        Dim blnCommon As Boolean
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
        Dim vntCurrentHist As String = ""
        Dim vntOrgID As String = ""
        Dim vntMonthDailyInd As String = ""
        Dim vntCustAcctTypeCde As String = ""
        Dim vntPart As String = ""
        Dim vntPlant As String = ""
        Dim vntLocation As String = ""
        Dim vntacctOrgKey As String = ""
        Dim vntShipTo As String = ""
        Dim vntSoldTo As String = ""
        Dim vntWWCust As String = ""
        Dim vntInvOrg As String = ""
        Dim vntController As String = ""
        Dim vntCntlrEmpNbr As String = ""
        Dim vntStkMake As String = ""
        Dim vntTeam As String = ""
        Dim vntProdCde As String = ""
        Dim vntProdLne As String = ""
        Dim vntIBC As String = ""
        Dim vntIC As String = ""
        Dim vntMfgCampus As String = ""
        Dim vntMfgBuilding As String = ""
        Dim vntComparisonType As String = ""
        Dim vntOpenShpOrder As String = ""
        Dim vntProfit As String = ""
        Dim vntCBC As String = ""
        Dim vntSubCBC As String = ""
        Dim vntOrgDate As String = ""
        Dim vntOrgType As String = ""
        Dim vntKeyId As Long
        Dim vntLevel As String = ""
        Dim vntLength As Integer
        Dim vntOrgTypeDesc As String = ""
        Dim intCountST As Integer
        Dim vntTemp As String = ""
        Dim vntTempWW As String = ""
        Dim vntTempWW2 As String = ""
        Dim intCountWW As Integer
        Dim intFound As Integer
        Dim objGetWWName As New clsWrldWide
        Dim objGetShipToName As New clsShipTo
        Dim objGetSoldToName As New clsSoldTo
        Dim vntName As String = ""
        Dim vntTemp2 As String = ""
        Dim vntCustOrg As String = ""
        Dim vntProdMgr As String = ""
        Dim vntLeadTimeType As String = ""
        Dim vntSalesOffice As String = ""
        Dim vntSalesGroup As String = ""
        Dim vntMfgOrgType As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgLevel As String = ""
        Dim GamAccount As String = ""
        Dim vntPartKeyID As String = ""
        Dim vntMrpGroupCde As String = ""
        Dim vntHostOrgID As String = ""
        Dim strwhere As String
        On Error GoTo ErrorHandler

        blnCommon = False
        dblTemp1 = 0
        dblTemp2 = 0

        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResults.ListSummDaily")
        End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDate, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNumber, vntErrorDesc)

        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        
        If Not blnrc Or vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsSearch.RetrieveSession from clsResults.ListSummDaily")
        End If

        If vntOrgID <> "" Then
            
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"
            
            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDate, vntLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListSummDaily")
            End If

            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
        End If

        If vntMfgOrgId <> "" Then
            
            blnrc = objOrgs.RetrieveType(vntMfgOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Mfg Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Mfg Org ID:</strong> " & vntMfgOrgId & ";"

            blnrc = objOrgs.RetrieveLevel(vntMfgOrgId, vntCurrentHist, vntOrgDate, vntMfgLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListSummDaily")
            End If

            If Len(vntMfgLevel) > 6 Then
                vntMfgLevel = Right(vntMfgLevel, 2)
            Else
                vntMfgLevel = Right(vntMfgLevel, 1)
            End If
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org ID:</strong> " & vntacctOrgKey & ";"
            
            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDate, vntKeyId, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If

            vntacctOrgKey = vntKeyId
        End If
        
        If vntWindowId = "1" Then 'Customer Variable
            If vntSmryType = "1" Then
                strSql = " SELECT   NVL(SUM(DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, -999), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, -6),1)), 0) var_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -5, 1)), 0) var_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -4, 1)), 0) var_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -3, 1)), 0) var_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -2, 1)), 0) var_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -1, 1)), 0) var_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 0, 1)), 0) var_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 1, 1)), 0) var_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 2, 1)), 0) var_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 3, 1)), 0) var_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 4, 1)), 0) var_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 5, 1)), 0) var_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, 6), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, 999),1)), 0) var_six_plus_late,   "
                strSql = strSql & " NVL(COUNT(*), 0) var_total,    "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, -999), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, -6), 1))), 0) jit_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -5, 1))), 0) jit_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -4, 1))), 0) jit_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -3, 1))), 0) jit_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -2, 1))), 0) jit_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -1, 1))), 0) jit_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 0, 1))), 0) jit_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 1, 1))), 0) jit_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 2, 1))), 0) jit_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 3, 1))), 0) jit_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 4, 1))), 0) jit_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 5, 1))), 0) jit_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, 6), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, 999), 1))), 0) jit_six_plus_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', 1)), 0) jit_total "
                vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
            Else
                strSql = " SELECT NVL(SUM(DECODE(GREATEST(VARBL_REQUEST_SHIP_VARIANCE, -999), LEAST(VARBL_REQUEST_SHIP_VARIANCE, -6),1)), 0) var_six_plus_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -5, 1)), 0) var_five_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -4, 1)), 0) var_four_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -3, 1)), 0) var_three_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -2, 1)), 0) var_two_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -1, 1)), 0) var_one_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 0, 1)), 0) var_on_time, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 1, 1)), 0) var_one_late, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 2, 1)), 0) var_two_late, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 3, 1)), 0) var_three_late, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 4, 1)), 0) var_four_late, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 5, 1)), 0) var_five_late, "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(VARBL_REQUEST_SHIP_VARIANCE, 6), LEAST(VARBL_REQUEST_SHIP_VARIANCE, 999),1)), 0) var_six_plus_late, "
                strSql = strSql & " NVL(COUNT(*), 0) var_total,   "
                blnCommon = True
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
            End If
        Else
            If vntSmryType = "1" Then
                strSql = " SELECT NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -6),1)), 0) def_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -5, 1)), 0) def_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -4, 1)), 0) def_four_early,  "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -3, 1)), 0) def_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -2, 1)), 0) def_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -1, 1)), 0) def_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 0, 1)), 0) def_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 1, 1)), 0) def_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 2, 1)), 0) def_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 3, 1)), 0) def_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 4, 1)), 0) def_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 5, 1)), 0) def_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 6), LEAST(SCHEDULE_TO_SHIP_VARIANCE, 999),1)), 0) def_six_plus_late,   "
                strSql = strSql & " NVL(COUNT(*), 0) def_total,  "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -6), 1))), 0) jit_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -5, 1))), 0) jit_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -4, 1))), 0) jit_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -3, 1))), 0) jit_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -2, 1))), 0) jit_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -1, 1))), 0) jit_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 0, 1))), 0) jit_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 1, 1))), 0) jit_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 2, 1))), 0) jit_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 3, 1))), 0) jit_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 4, 1))), 0) jit_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 5, 1))), 0) jit_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 6), LEAST(SCHEDULE_TO_SHIP_VARIANCE, 999), 1))), 0) jit_six_plus_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', 1)), 0) jit_total"
                vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
            ElseIf vntSmryType = "2" Then  'Standard Default (2) Request To Ship
                strSql = " SELECT NVL(SUM(DECODE(GREATEST(REQUEST_TO_SHIP_VARIANCE, -999), LEAST(REQUEST_TO_SHIP_VARIANCE, -6),1)), 0) def_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -5, 1)), 0) def_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -4, 1)), 0) def_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -3, 1)), 0) def_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -2, 1)), 0) def_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -1, 1)), 0) def_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 0, 1)), 0) def_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 1, 1)), 0) def_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 2, 1)), 0) def_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 3, 1)), 0) def_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 4, 1)), 0) def_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 5, 1)), 0) def_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(REQUEST_TO_SHIP_VARIANCE, 6), LEAST(REQUEST_TO_SHIP_VARIANCE, 999),1)), 0) def_six_plus_late,  "
                strSql = strSql & " NVL(COUNT(*), 0) def_total,  "
                blnCommon = True
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
            Else ' Standard Default (3) Request to Schd
                strSql = " SELECT NVL(SUM(DECODE(GREATEST(REQUEST_TO_SCHEDULE_VARIANCE, -999), LEAST(REQUEST_TO_SCHEDULE_VARIANCE, -6),1)), 0) def_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -5, 1)), 0) def_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -4, 1)), 0) def_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -3, 1)), 0) def_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -2, 1)), 0) def_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -1, 1)), 0) def_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 0, 1)), 0) def_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 1, 1)), 0) def_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 2, 1)), 0) def_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 3, 1)), 0) def_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 4, 1)), 0) def_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 5, 1)), 0) def_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(REQUEST_TO_SCHEDULE_VARIANCE, 6), LEAST(REQUEST_TO_SCHEDULE_VARIANCE, 999),1)), 0) def_six_plus_late,   "
                strSql = strSql & " NVL(COUNT(*), 0) def_total,   "
                blnCommon = True
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request to Schedule;"
            End If
        End If

        If blnCommon Then 'Common worthless code that keeps the array in sync
            strSql = strSql & " 0 jit_six_plus_early,   "
            strSql = strSql & " 0 jit_five_early,   "
            strSql = strSql & " 0 jit_four_early,   "
            strSql = strSql & " 0 jit_three_early,   "
            strSql = strSql & " 0 jit_two_early,   "
            strSql = strSql & " 0 jit_one_early,   "
            strSql = strSql & " 0 jit_on_time,   "
            strSql = strSql & " 0 jit_one_late,   "
            strSql = strSql & " 0 jit_two_late,   "
            strSql = strSql & " 0 jit_three_late,   "
            strSql = strSql & " 0 jit_four_late,   "
            strSql = strSql & " 0 jit_five_late,   "
            strSql = strSql & " 0 jit_six_plus_late,   "
            strSql = strSql & " 0 jit_total"
        End If

        If vntCategoryId = "28" Then
            strSql = strSql & " FROM ORDER_ITEM_OPEN A, "
        Else
            strSql = strSql & " FROM ORDER_ITEM_SHIPMENT A, "
        End If
        
        strSql = strSql & " ORGANIZATIONS_DMN C "

        If vntViewId = "8" And vntProdMgr <> "" Then
            strSql = strSql & ", GED_PUBLIC_TABLE F "
        End If

        If vntViewId = "10" Then
            strSql = strSql & " , ORGANIZATIONS_DMN D "
        End If

        If vntViewId = "3" And vntHostOrgID <> "" Then
            strSql = strSql & ", GBL_PRODUCT gp "
            strSql = strSql & ", GBL_LEGAL_ORG_DESCENDENTS glod "
        End If

        strSql = strSql & " WHERE  C.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        
        If vntViewId = "10" Then
            strSql = strSql & " AND  D.LAYER" & vntMfgLevel & "_ORGANIZATION_ID = '" & vntMfgOrgId & "' "
            strSql = strSql & " AND  A.MFR_ORG_KEY_ID = D.ORGANIZATION_KEY_ID "
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID "
        Else
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID "
        End If

        If vntViewId = "8" And vntProdMgr <> "" Then
            strSql = strSql & " AND (F.ASOC_GLOBAL_ID(+) = A.PRODUCT_MANAGER_GLOBAL_ID) "
        End If

        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                Else

                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                    vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
                End If
            Else
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                    vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                    vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
                End If
            End If
            If vntViewId = "10" Then
                If vntCurrentHist = "C" Then
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                    vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                    vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                    vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
                End If
            End If
        Else
            strSql = strSql & " AND C.RECORD_STATUS_CDE = 'C' "
            vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
        End If

        strSql = strSql & " AND " & IIf(vntCategoryId = "28", "CUSTOMER_REQUEST_DATE", "AMP_SHIPPED_DATE") & " BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"

        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"

        If vntStkMake <> "" Then
            vntLength = Len(vntStkMake)
            strSql = strSql & " AND substr(STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            vntDispCrit = vntDispCrit & " <strong>Make Stock:</strong> " & vntStkMake & ";"
        End If

        If vntMrpGroupCde <> "" Then
            If InStr(vntMrpGroupCde, ",") > 0 Then
                strSql = strSql & " AND MRP_GROUP_CDE IN ( " & QuoteStr(vntMrpGroupCde) & " ) "
            Else
                strSql = strSql & " AND MRP_GROUP_CDE " & IIf(InStr(vntMrpGroupCde, "%") > 0, "LIKE '", "= '") & vntMrpGroupCde & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>MRP Group:</strong> " & vntMrpGroupCde & ";"
        End If

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        If vntTeam <> "" Then
            strSql = strSql & " AND TEAM_CODE = '" & vntTeam & "' "
            vntDispCrit = vntDispCrit & " <strong>Team:</strong> " & vntTeam & ";"
        End If

        If vntProdLne <> "" Then
            If InStr(vntProdLne, ",") > 0 Then
                strSql = strSql & " AND PRODUCT_LINE_CODE IN ( " & QuoteStr(vntProdLne) & " )"
            Else
                strSql = strSql & " AND PRODUCT_LINE_CODE = '" & vntProdLne & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Product Line:</strong> " & vntProdLne & ";"
        End If

        If vntInvOrg <> "" Then
            If InStr(vntInvOrg, ",") > 0 Then
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID IN ( " & QuoteStr(vntInvOrg) & " ) "
            Else
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID " & IIf(InStr(vntInvOrg, "%") > 0, "LIKE '", "= '") & vntInvOrg & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Inv Org/Plant:</strong> " & vntInvOrg & ";"
        End If

        If vntProdCde <> "" Then
            strSql = strSql & " AND PRODUCT_CODE = '" & vntProdCde & "' "
            vntDispCrit = vntDispCrit & " <strong>Product Code:</strong> " & vntProdCde & ";"
        End If

        If vntWWCust <> "" Then
            vntTemp2 = vntWWCust
            intFound = 0
            vntTempWW = ""
            vntTempWW2 = ""
            intCountWW = 0
            intFound = InStr(vntWWCust, "-")

            If intFound <> 0 Then
                vntTempWW = Left(vntWWCust, intFound - 1)
                vntTempWW2 = Right(vntWWCust, Len(vntWWCust) - intFound)
            Else
                If Len(vntWWCust) > 10 Then
                    Err.Raise(901, , "WorldWide Number is invalid.  These numbers are required to have a maximum of 10 characters")
                ElseIf Len(vntWWCust) <= 8 Then
                    vntTempWW = vntWWCust
                ElseIf Len(vntWWCust) = 9 Then
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 1)
                Else
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 2)
                End If
            End If

            If Len(vntTempWW) < 8 Then
                For intCountWW = 1 To 8 - Len(vntTempWW)
                    vntTemp = vntTemp & "0"
                Next
                vntWWCust = vntTemp & vntTempWW
            Else
                vntWWCust = vntTempWW
            End If

            If Len(vntTempWW2) = 1 Then
                vntTempWW2 = "0" & vntTempWW2
                vntWWCust = vntWWCust & vntTempWW2
            Else
                vntWWCust = vntWWCust & vntTempWW2
            End If

            If Len(vntWWCust) > 8 Then
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
                strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
            Else
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
            End If

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntShipTo <> "" Then
            vntTemp2 = vntShipTo
            intCountST = 0
            vntTemp = ""
            vntShipTo = Replace(vntShipTo, "-", "")

            If Len(vntShipTo) < 10 Then
                For intCountST = 1 To 10 - Len(vntShipTo)
                    vntTemp = "0" & vntTemp
                Next
                vntShipTo = vntTemp & vntShipTo
            End If

            If Len(vntShipTo) > 10 Then
                Err.Raise(901, , "Ship To Number is invalid.  These numbers are required to have 10 characters")
            Else
                strSql = strSql & " AND PURCHASE_BY_ACCOUNT_BASE = '" & Left(vntShipTo, 8) & "'"
                strSql = strSql & " AND SHIP_TO_ACCOUNT_SUFFIX = '" & Right(vntShipTo, 2) & "'"
            End If

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntacctOrgKey <> "" Then
            strSql = strSql & " AND ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey
        End If

        If vntMfgCampus <> "" Then
            strSql = strSql & " AND MFG_CAMPUS_ID = '" & vntMfgCampus & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Campus:</strong> " & vntMfgCampus & ";"
        End If

        If vntMfgBuilding <> "" Then
            strSql = strSql & " AND MFG_BUILDING_NBR = '" & vntMfgBuilding & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Building:</strong> " & vntMfgBuilding & ";"
        End If

        If vntIBC <> "" Then
            If InStr(vntIBC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE IN ( " & QuoteStr(vntIBC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE = '" & vntIBC & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry Business:</strong> " & vntIBC & ";"
        End If

        If vntIC <> "" Then
            If InStr(vntIC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_CODE IN ( " & QuoteStr(vntIC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_CODE LIKE '" & vntIC & "%' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry:</strong> " & vntIC & ";"
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If vntPart <> "" And Not IsDBNull(vntPartKeyID) Then
            '    intCountST = 0
            '    vntTemp = ""
            '    vntPart = Replace(vntPart, "-", "")
            '    If Len(vntPart) < 9 Then
            '        For intCountST = 1 To 9 - Len(vntPart)
            '            vntTemp = "0" & vntTemp
            '        Next
            '        vntPart = vntTemp & vntPart
            '    End If
            '    strSql = strSql & " AND Part_Nbr = '" & vntPart & "' "
            strSql = strSql & " AND PART_KEY_ID = " & vntPartKeyID
            vntDispCrit = vntDispCrit & " <strong>Part:</strong> " & vntPart & ";"
        End If

        If vntController <> "" Then
            If InStr(vntController, ",") > 0 Then
                strSql = strSql & " AND PRODCN_CNTRLR_CODE IN ( " & QuoteStr(vntController) & " ) "
            Else
                strSql = strSql & " AND PRODCN_CNTRLR_CODE " & IIf(InStr(vntController, "%") > 0, "LIKE '", "= '") & vntController & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Controller:</strong> " & vntController & ";"
        End If

        If vntPlant <> "" Then
            strSql = strSql & " AND (ACTUAL_SHIP_BUILDING_NBR = '" & vntPlant & "')"
            vntDispCrit = vntDispCrit & " <strong>Plant/Blg:</strong> " & vntPlant & ";"
        End If

        If vntLocation <> "" Then
            strSql = strSql & " AND ACTUAL_SHIP_LOCATION = '" & vntLocation & "'"
            vntDispCrit = vntDispCrit & " <strong>Location:</strong> " & vntLocation & ";"
        End If

        If vntCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_ID = '" & vntCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Competency Business:</strong> " & vntCBC & ";"
        End If

        If vntSubCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_FNCTN_ID = '" & vntSubCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Sub-Competency Business:</strong> " & vntSubCBC & ";"
        End If

        If vntProfit <> "" Then
            strSql = strSql & " AND PROFIT_CENTER_ABBR_NM = '" & vntProfit & "' "
            vntDispCrit = vntDispCrit & " <strong>Profit Center:</strong> " & vntProfit & ";"
        End If

        If vntSalesOffice <> "" Then
            If InStr(vntSalesOffice, ",") > 0 Then
                strSql = strSql & " AND A.SALES_OFFICE_CDE IN ( " & QuoteStr(vntSalesOffice) & " ) "
            Else
                strSql = strSql & " AND A.SALES_OFFICE_CDE " & IIf(InStr(vntSalesOffice, "%") > 0, "LIKE '", "= '") & vntSalesOffice & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Office:</strong> " & vntSalesOffice & ";"
        End If

        If vntSalesGroup <> "" Then
            If InStr(vntSalesGroup, ",") > 0 Then
                strSql = strSql & " AND A.SALES_GROUP_CDE IN ( " & QuoteStr(vntSalesGroup) & " ) "
            Else
                strSql = strSql & " AND A.SALES_GROUP_CDE " & IIf(InStr(vntSalesGroup, "%") > 0, "LIKE '", "= '") & vntSalesGroup & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Group:</strong> " & vntSalesGroup & ";"
        End If

        If vntSoldTo <> "" Then
            vntTemp2 = vntSoldTo
            intCountST = 0
            vntTemp = ""
            vntSoldTo = Replace(vntSoldTo, "-", "")

            If Len(vntSoldTo) < 8 Then
                For intCountST = 1 To 8 - Len(vntSoldTo)
                    vntTemp = "0" & vntTemp
                Next
                vntSoldTo = vntTemp & vntSoldTo
            End If

            If Len(vntSoldTo) > 8 Then
                Err.Raise(901, , "Sold To Number is invalid.  These numbers are required to have 8 characters")
            Else
                strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
            End If

            blnrc = objGetSoldToName.RetrieveName(vntCustOrg, vntSoldTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetSoldToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntProdMgr <> "" Then
            strSql = strSql & ParseProdMgr(vntProdMgr)
            vntDispCrit = vntDispCrit & " <strong>Product Mgr:</strong> " & vntProdMgr & ";"
        End If

        If vntViewId = "3" And vntHostOrgID <> "" Then
            strSql = strSql & " AND glod.GLOD_LEGAL_ORG_ID IN ( " & QuoteStr(vntHostOrgID) & " ) "
            strSql = strSql & " AND gp.PROD_HOST_ORG_ID = glod.GLOD_DESCENDENT_LEGAL_ORG_ID "
            strSql = strSql & " AND a.PRODUCT_CODE = gp.PROD_CODE"
            vntDispCrit = vntDispCrit & " <strong>Product Host OrgID:</strong> " & vntHostOrgID & ";"
        End If

        vntCount = 0
        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)
        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsTemplate.ListExample call to CallRS for Public View Query")
        End If

        ListSummDaily = Nothing
        If vntCount > 0 Then
            'For any recordsets we will pass back to the web ASP pages variant arrays
            vntArray = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListSummDaily = System.DBNull.Value
        End If

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

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If Not IsDBNull(ListSummDaily) Then
            If vntArray(13, 0) <> 0 Then
                vntOnTime = VB6.Format(CInt(vntArray(6, 0)), "#,##0")
                vntCenter1 = VB6.Format(System.Math.Round(CDbl(vntArray(6, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter3 = VB6.Format(System.Math.Round((CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter4 = VB6.Format(System.Math.Round((CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter5 = VB6.Format(System.Math.Round((CDbl(vntArray(3, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter6 = VB6.Format(System.Math.Round((CDbl(vntArray(2, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter7 = VB6.Format(System.Math.Round((CDbl(vntArray(1, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter8 = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt6Early = VB6.Format(System.Math.Round(CDbl(vntArray(0, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt5Early = VB6.Format(System.Math.Round(CDbl(vntArray(1, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt4Early = VB6.Format(System.Math.Round(CDbl(vntArray(2, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt3Early = VB6.Format(System.Math.Round(CDbl(vntArray(3, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt2Early = VB6.Format(System.Math.Round(CDbl(vntArray(4, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt1Early = VB6.Format(System.Math.Round(CDbl(vntArray(5, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt1Late = VB6.Format(System.Math.Round(CDbl(vntArray(7, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt2Late = VB6.Format(System.Math.Round(CDbl(vntArray(8, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt3Late = VB6.Format(System.Math.Round(CDbl(vntArray(9, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt4Late = VB6.Format(System.Math.Round(CDbl(vntArray(10, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt5Late = VB6.Format(System.Math.Round(CDbl(vntArray(11, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt6Late = VB6.Format(System.Math.Round(CDbl(vntArray(12, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntEStep1 = VB6.Format(vntArray(5, 0), "#,##0")
                vntEStep2 = VB6.Format(vntArray(4, 0), "#,##0")
                vntEStep3 = VB6.Format(vntArray(3, 0), "#,##0")
                vntEStep4 = VB6.Format(vntArray(2, 0), "#,##0")
                vntEStep5 = VB6.Format(vntArray(1, 0), "#,##0")
                vntEStep6 = VB6.Format(vntArray(0, 0), "#,##0")
                vntLStep1 = VB6.Format(vntArray(7, 0), "#,##0")
                vntLStep2 = VB6.Format(vntArray(8, 0), "#,##0")
                vntLStep3 = VB6.Format(vntArray(9, 0), "#,##0")
                vntLStep4 = VB6.Format(vntArray(10, 0), "#,##0")
                vntLStep5 = VB6.Format(vntArray(11, 0), "#,##0")
                vntLStep6 = VB6.Format(vntArray(12, 0), "#,##0")
                vntTotal = VB6.Format(vntArray(13, 0), "#,##0")

                If vntWindowId = "1" Then
                    vntSumLate = VB6.Format(CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                    vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)), "#,##0")
                    vntInWindowPercnt = vntCenter1
                    vntInWindow = vntOnTime
                ElseIf vntWindowId = "2" Then  ' Standard Default
                    'Figure out Days Early
                    If vntDaysEarly = "" Then
                        vntDaysEarly = "0"
                    End If
                    If vntSmryType = "1" Then 'all earlies are ontime except JIT for STS
                        vntSumEarly = 0
                    Else
                        Select Case vntDaysEarly
                            Case "0"
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)), "#,##0")
                            Case "1"
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(19, 0)), "#,##0")
                            Case "2"
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)), "#,##0")
                            Case "3"
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)), "#,##0")
                            Case "4"
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0)), "#,##0")
                            Case "5"
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(15, 0)), "#,##0")
                            Case Else
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)), "#,##0")
                        End Select
                    End If
                    'Figure out Days Late
                    If vntDaysLate = "" Then
                        vntDaysLate = "0"
                    End If
                    Select Case vntDaysLate
                        Case "0"
                            vntSumLate = VB6.Format(CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                        Case "1"
                            vntSumLate = VB6.Format(CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(21, 0)), "#,##0")
                        Case "2"
                            vntSumLate = VB6.Format(CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)), "#,##0")
                        Case "3"
                            vntSumLate = VB6.Format((CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0))) + (CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0))), "#,##0")
                        Case "4"
                            vntSumLate = VB6.Format(CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)), "#,##0")
                        Case "5"
                            vntSumLate = VB6.Format(CDbl(vntArray(12, 0)) + CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)), "#,##0")
                        Case Else
                            vntSumLate = VB6.Format(CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                    End Select

                    vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> "

                    'Figure out In Window
                    If vntSmryType = "1" Then 'all earlies are ontime except JIT for STS
                        vntDispCrit = vntDispCrit & "All;"
                        dblTemp1 = (CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(0, 0))) - (CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(14, 0)))
                    Else
                        vntDispCrit = vntDispCrit & vntDaysEarly & ";"
                        Select Case vntDaysEarly
                            Case "0"
                                dblTemp1 = 0
                            Case "1"
                                dblTemp1 = (CDbl(vntArray(5, 0))) - (CDbl(vntArray(19, 0)))
                            Case "2"
                                dblTemp1 = (CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0))) - (CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)))
                            Case "3"
                                dblTemp1 = (CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(3, 0))) - (CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)))
                            Case "4"
                                dblTemp1 = (CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(2, 0))) - (CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0)))
                            Case "5"
                                dblTemp1 = (CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(1, 0))) - (CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(15, 0)))
                            Case Else
                                dblTemp1 = 0
                        End Select
                        'If vntSmryType = "1" Then 'all earlies are ontime except JIT for STS
                        'vntSumEarly = 0
                    End If

                    vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"

                    Select Case vntDaysLate
                        Case "0"
                            dblTemp2 = 0
                        Case "1"
                            dblTemp2 = (CDbl(vntArray(7, 0))) - (CDbl(vntArray(21, 0)))
                        Case "2"
                            dblTemp2 = (CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0))) - (CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)))
                        Case "3"
                            'dblTemp2 = (CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)))
                            dblTemp2 = (CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0))) - (CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)))
                        Case "4"
                            dblTemp2 = (CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0))) - (CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)))
                        Case "5"
                            dblTemp2 = (CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0))) - (CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)))
                        Case Else
                            dblTemp2 = 0
                    End Select

                    vntInWindow = VB6.Format(dblTemp1 + dblTemp2 + vntOnTime, "#,##0")
                    vntInWindowPercnt = VB6.Format(System.Math.Round(vntInWindow / CDbl(vntArray(13, 0)), 3), "0.0%")
                End If

                vntSumEarlyPercnt = VB6.Format(System.Math.Round(CInt(vntSumEarly) / CInt(vntArray(13, 0)), 3), "0.0%")
                vntSumLatePercnt = VB6.Format(System.Math.Round(CDbl(vntSumLate) / CDbl(vntArray(13, 0)), 3), "0.0%")

                If vntSmryType = "1" Then
                    vntJITLate = VB6.Format(CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)), "#,##0")
                    vntJITEarly = VB6.Format(CDbl(vntArray(14, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(19, 0)), "#,##0")
                    vntJITEarlyPercnt = VB6.Format(System.Math.Round(CInt(vntJITEarly) / CInt(vntArray(13, 0)), 3), "0.0%")
                    vntJITLatePercnt = VB6.Format(System.Math.Round(CDbl(vntJITLate) / CDbl(vntArray(13, 0)), 3), "0.0%")
                    If vntWindowId = "2" Then
                        vntSumEarly = vntJITEarly
                        vntSumEarlyPercnt = vntJITEarlyPercnt
                    End If
                End If

                ListSummDaily = vntArray
            Else
                Err.Raise(100, , "The divisor(total) equaled 0 which means no results were found.(in clsResults.ListSummDaily)")
            End If
        End If

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListSummDaily = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function
	
	'##ModelId=3A8BF550026F
    Public Function ListConfNonConf(ByVal vntSessionID As String, ByVal vntGetTotal As Object, ByVal vntPage As Object, ByVal vntExport As Object, ByRef vntCount As Object, ByRef vntRecsLeft As Object, ByRef vntTBRTotal As Object, ByRef vntExtTotal As Object, ByRef vntLocalTotal As Object, ByRef vntSmryType As Object, ByRef vntDispCrit As Object, ByRef vntShpQtyTotal As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objConnection As New ADODB.Connection
        Dim objCallRS As New clsCallRS
        Dim objSearch As New clsSearch
        Dim objList As Object
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
        Dim vntArray As Object
        Dim intPageCount As Integer
        Dim intRecsLeft As Integer
        Dim intCount As Integer
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntWindowId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
        Dim vntCurrentHist As String = ""
        Dim vntOrgKeyId As String = ""
        Dim vntDaysEarly As String = ""
        Dim vntDaysLate As String = ""
        Dim vntMonthDailyInd As String = ""
        Dim vntCustAcctTypeCde As String = ""
        Dim vntPart As String = ""
        Dim vntPlant As String = ""
        Dim vntLocation As String = ""
        Dim vntacctOrgKey As String = ""
        Dim vntShipTo As String = ""
        Dim vntSoldTo As String = ""
        Dim vntWWCust As String = ""
        Dim vntInvOrg As String = ""
        Dim vntController As String = ""
        Dim vntCntlrEmpNbr As String = ""
        Dim vntStkMake As String = ""
        Dim vntTeam As String = ""
        Dim vntProdCde As String = ""
        Dim vntProdLne As String = ""
        Dim vntIBC As String = ""
        Dim vntIC As String = ""
        Dim vntMfgCampus As String = ""
        Dim vntMfgBuilding As String = ""
        Dim vntComparisonType As String = ""
        Dim vntOpenShpOrder As String = ""
        Dim vntProfit As String = ""
        Dim vntCBC As String = ""
        Dim vntSubCBC As String = ""
        Dim vntOrgDate As String = ""
        Dim vntLevel As String = ""
        Dim vntKeyId As Long
        Dim vntTempArray As Object
        Dim vntOrgType As String = ""
        Dim vntLength As Integer
        Dim vntOrgTypeDesc As String = ""
        Dim intCountST As Integer
        Dim vntTemp As String = ""
        Dim vntTempWW As String = ""
        Dim vntTempWW2 As String = ""
        Dim intCountWW As Integer
        Dim intFound As Integer
        Dim objGetWWName As New clsWrldWide
        Dim objGetShipToName As New clsShipTo
        Dim objGetSoldToName As New clsSoldTo
        Dim vntName As String = ""
        Dim vntTemp2 As String = ""
        Dim vntCustOrg As String = ""
        Dim vntProdMgr As String = ""
        Dim vntLeadTimeType As String = ""
        Dim vntSalesOffice As String = ""
        Dim vntSalesGroup As String = ""
        Dim vntMfgOrgType As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgLevel As String = ""
        Dim GamAccount As String = ""
        Dim vntPartKeyID As String = ""
        Dim vntMrpGroupCde As String = ""
        Dim vntHostOrgID As String = ""

        On Error GoTo ErrorHandler

        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResults.ListConfNonConf")
        End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgKeyId, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDate, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNumber, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsSearch.RetrieveSession")
        End If
        'Create one instance of an object to be used in a couple of places
        
        If vntDaysEarly = "" Then
            vntDaysEarly = 0
        End If
        
        If vntDaysLate = "" Then
            vntDaysLate = 0
        End If

        If vntViewId = "4" Then
            vntWindowId = ""
        End If

        If vntOrgKeyId <> "" Then
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If
            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgKeyId & ";"

            blnrc = objOrgs.RetrieveLevel(vntOrgKeyId, vntCurrentHist, vntOrgDate, vntLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " (In call to clsOrgs.RetrieveLevel)")
            End If

            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
        End If

        If vntMfgOrgId <> "" Then
            blnrc = objOrgs.RetrieveType(vntMfgOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Mfg Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Mfg Org ID:</strong> " & vntMfgOrgId & ";"

            blnrc = objOrgs.RetrieveLevel(vntMfgOrgId, vntCurrentHist, vntOrgDate, vntMfgLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListConfNonConf")
            End If

            If Len(vntMfgLevel) > 6 Then
                vntMfgLevel = Right(vntMfgLevel, 2)
            Else
                vntMfgLevel = Right(vntMfgLevel, 1)
            End If
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org Id:</strong> " & vntacctOrgKey & ";"

            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDate, vntKeyId, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If

            vntacctOrgKey = vntKeyId
        End If

        'strSql = " SELECT ACTUAL_SHIP_LOCATION SL, "
        strSql = " SELECT ACTUAL_SHIP_BUILDING_NBR SL, "
        strSql = strSql & " TYCO_ELECTRONICS_CORP_PART_NBR Part_Number, "
        strSql = strSql & " AMP_ORDER_NBR ONBR, "
        If vntSmryType <> "3" Then
            strSql = strSql & " TO_CHAR(RELEASE_DATE, 'YYYY-MM-DD') computed_comparison_date_1, "
        Else
            strSql = strSql & " TO_CHAR(AMP_SCHEDULE_DATE, 'YYYY-MM-DD') computed_comparison_date_1, "
        End If
        strSql = strSql & " TO_CHAR(AMP_SHIPPED_DATE, 'YYYY-MM-DD') computed_comparison_date_2, "

        If vntSmryType = "1" Then
            strSql = strSql & " TO_CHAR(DECODE(SCHEDULE_SHIP_CMPRSN_CODE, 'C', SCHEDULE_OFF_CREDIT_HOLD_DATE, 'T', TEMP_HOLD_OFF_DATE, 'R', CUSTOMER_REQUEST_DATE, 'E', CUSTOMER_EXPEDITE_DATE, 'S', AMP_SCHEDULE_DATE, 'L', NULL, 'X', EARLIEST_EXPEDITE_DATE), 'YYYY-MM-DD') computed_comparison_date, "
            strSql = strSql & " DECODE(SCHEDULE_SHIP_CMPRSN_CODE, 'C', 'CREDIT', 'T', 'TEMP HOLD', 'R', 'CUST RQST', 'E', 'CUST EXP', 'S', 'SCHEDULE', 'L', 'LATE CODE', 'X', 'EXPEDITE') computed_comparison_code, "
            vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
        ElseIf vntSmryType = "2" Then
            strSql = strSql & " TO_CHAR(DECODE(REQUEST_SHIP_CMPRSN_CODE, 'C', SCHEDULE_OFF_CREDIT_HOLD_DATE, 'T', TEMP_HOLD_OFF_DATE, 'R', CUSTOMER_REQUEST_DATE, 'E', CUSTOMER_EXPEDITE_DATE, 'U', CUSTOMER_REQUEST_DATE, 'D', NULL), 'YYYY-MM-DD') computed_comparison_date, "
            strSql = strSql & " DECODE(REQUEST_SHIP_CMPRSN_CODE, 'C', 'CREDIT', 'T', 'TEMP HOLD', 'R', 'CUST RQST', 'E', 'CUST EXP', 'U', 'URG RQST', 'D', 'Distribution STS Ind') computed_comparison_code, "
            vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
        ElseIf vntSmryType = "3" Then
            strSql = strSql & " TO_CHAR(DECODE(REQUEST_SCHEDULE_CMPRSN_CODE, 'R', CUSTOMER_REQUEST_DATE, 'U', CUSTOMER_REQUEST_DATE), 'YYYY-MM-DD') computed_comparison_date, "
            strSql = strSql & " DECODE(REQUEST_SCHEDULE_CMPRSN_CODE, 'R', 'CUST RQST', 'U', 'URG RQST') computed_comparison_code, "
            vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request to Schedule;"
        Else 'ship facility
            strSql = strSql & " TO_CHAR(DECODE(SHIP_FACILITY_CMPRSN_CODE, 'C', SCHEDULE_OFF_CREDIT_HOLD_DATE, 'T', TEMP_HOLD_OFF_DATE, 'R', CUSTOMER_REQUEST_DATE, 'E', CUSTOMER_EXPEDITE_DATE, 'S', AMP_SCHEDULE_DATE, 'L', NULL, 'X', CURRENT_EXPEDITE_DATE, 'A', RELEASE_DATE, 'M', CONSOLIDATION_DT), 'YYYY-MM-DD') computed_comparison_date, "
            strSql = strSql & " DECODE(SHIP_FACILITY_CMPRSN_CODE, 'C', 'CREDIT', 'T', 'TEMP HOLD', 'R', 'CUST RQST', 'E', 'CUST EXP', 'S', 'SCHEDULE', 'L', 'LATE CODE', 'X', 'EXPEDITE', 'A', 'RELEASE', 'M', 'MILK RUN') computed_comparison_code, "
        End If

        If vntWindowId = "1" Then
            If vntSmryType = "1" Then
                strSql = strSql & " VARBL_SCHEDULE_SHIP_VARIANCE computed_variance, "
            ElseIf vntSmryType = "2" Then
                strSql = strSql & " VARBL_REQUEST_SHIP_VARIANCE computed_variance, "
            End If
        ElseIf vntWindowId = "2" Then
            If vntSmryType = "1" Then
                strSql = strSql & " SCHEDULE_TO_SHIP_VARIANCE computed_variance, "
            ElseIf vntSmryType = "2" Then
                strSql = strSql & " REQUEST_TO_SHIP_VARIANCE computed_variance, "
            Else
                strSql = strSql & " REQUEST_TO_SCHEDULE_VARIANCE computed_variance, "
            End If
        Else 'for ship facility
            strSql = strSql & " RELEASE_TO_SHIP_VARIANCE computed_variance, "
        End If
        
        strSql = strSql & " CUSTOMER_TYPE_CODE CTC, "
        'strSql = strSql & " DECODE('0', NVL(TO_CHAR(ACTUAL_ON_DOCK_DATE), '0'), '0', TO_CHAR(DECODE(-1, SIGN(AMP_SHIPPED_DATE - AMP_SCHEDULE_DATE), 0, 1)), '0', TO_CHAR(AMP_SHIPPED_DATE - AMP_SCHEDULE_DATE), '0', TO_CHAR(AMP_SHIPPED_DATE - ACTUAL_ON_DOCK_DATE), '0', '1') DOC_Ind, "
        strSql = strSql & " '0' DOC_Ind, "
        strSql = strSql & " NBR_WINDOW_DAYS_EARLY NDE, "
        strSql = strSql & " NBR_WINDOW_DAYS_LATE NDL, "
        strSql = strSql & " ORDER_ITEM_NBR OIN, "
        strSql = strSql & " SHIPMENT_ID SI, "
        strSql = strSql & " NULL TempCode  ,"
        strSql = strSql & " EXTENDED_BOOK_BILL_AMOUNT BillAmount, "
        strSql = strSql & " B.PART_DESC part_desc, "
        strSql = strSql & " PURCHASE_BY_ACCOUNT_BASE||SHIP_TO_ACCOUNT_SUFFIX customer_account_nbr,"
        strSql = strSql & " LOCAL_CURRENCY_BILLED_AMOUNT LCBillAmt,"
        strSql = strSql & " A.ORGANIZATION_KEY_ID OrgID, "
        strSql = strSql & " ISO_CURRENCY_CODE_1 ICC, " '
        strSql = strSql & " PRODCN_CNTRLR_CODE PCC "
        strSql = strSql & " ,TO_CHAR(ORDER_RECEIVED_DATE, 'YYYY-MM-DD') ORD "
        strSql = strSql & " ,BUDGET_RATE_BOOK_BILL_AMT TBRAmount "
        
        If vntViewId = "8" Then
            strSql = strSql & " ,F.FIRST_NAME||DECODE(F.MIDDLE_INITIAL,NULL,'',' '||F.MIDDLE_INITIAL)||' '||F.LAST_NAME ProdMgrName "
        Else
            strSql = strSql & " ,Null ProdMgrName "
        End If
        
        strSql = strSql & " ,SOLD_TO_CUSTOMER_ID SoldTo "
        strSql = strSql & " ,SBMT_PART_NBR SbmtPart "
        strSql = strSql & " ,ITEM_QUANTITY ItemQty "
        
        If vntCategoryId = "29" Then
            strSql = strSql & " ,REMAINING_QTY_TO_SHIP ShipQty "
        Else
            strSql = strSql & " ,QUANTITY_SHIPPED ShipQty "
        End If
        
        strSql = strSql & " ,INVOICE_NBR InvNbr "
        strSql = strSql & " ,CUSTOMER_REFERENCE_PART_NBR CustPart "
        strSql = strSql & " ,PURCHASE_ORDER_NBR PONbr "
        strSql = strSql & " ,TO_CHAR(PURCHASE_ORDER_DATE, 'YYYY-MM-DD') PODate "
        strSql = strSql & " ,E.ORGANIZATION_ID PPSOC "
        
        If vntCategoryId = "29" Then
            strSql = strSql & " ,'' DocNo "
        Else
            strSql = strSql & " ,DELIVERY_DOCUMENT_NBR_ID DocNo "
        End If
        
        strSql = strSql & " ,MRP_GROUP_CDE MrpGroup "
        strSql = strSql & " ,STOCK_MAKE_CODE MakeStock "
        strSql = strSql & " ,shipto.CUSTOMER_NM ShiptoNm "
        strSql = strSql & " ,soldto.CUSTOMER_NM SoldtoNm "
        strSql = strSql & " ,a.STORAGE_LOCATION_ID SLoc "
        strSql = strSql & " ,TO_CHAR(a.ORDER_RECEIVED_DT, 'YYYY-MM-DD') OrderRecDt "
        strSql = strSql & " ,a.ORDER_CREATED_BY_NTWK_USER_ID OrderCreateBy "
        strSql = strSql & " ,TO_CHAR(a.DELIVERY_DOC_CREATION_DT, 'YYYY-MM-DD') DlvryDocCreateDt "
        strSql = strSql & " ,a.DELIVERY_DOC_CREATION_TM DlvryDocCreateTm "
        strSql = strSql & " ,a.DLVR_DOC_CRET_BY_NTWK_USER_ID DlvryDocCreateBy "
        strSql = strSql & " ,TO_CHAR(CUSTOMER_REQUEST_DATE, 'YYYY-MM-DD') CustomerRequestDate "
        strSql = strSql & " ,TO_CHAR(AMP_SCHEDULE_DATE, 'YYYY-MM-DD') AmpScheduleDate "

        If vntCategoryId = "29" Then
            strSql = strSql & " FROM ORDER_ITEM_OPEN A, "
        Else
            strSql = strSql & " FROM ORDER_ITEM_SHIPMENT A, "
        End If
        
        strSql = strSql & " CORPORATE_PARTS B "
        
        If vntOrgKeyId <> "" Then
            strSql = strSql & ", ORGANIZATIONS_DMN C "
        End If
        
        If vntViewId = "8" Then
            strSql = strSql & ", GED_PUBLIC_TABLE F "
        End If
        
        If vntViewId = "10" Then
            strSql = strSql & ", ORGANIZATIONS_DMN D "
        End If

        strSql = strSql & ", ORGANIZATIONS_DMN E "

        If vntViewId = "3" And vntHostOrgID <> "" Then
            strSql = strSql & ", GBL_PRODUCT gp "
            strSql = strSql & ", GBL_LEGAL_ORG_DESCENDENTS glod "
        End If

        strSql = strSql & ", CUSTOMER_PARTNER_DMN_CURR_V shipto "
        strSql = strSql & ", CUSTOMER_PARTNER_DMN_CURR_V soldto "
        strSql = strSql & " WHERE A.PART_KEY_ID = B.PART_KEY_ID (+) "

        If vntCategoryId = "29" Then
            strSql = strSql & " AND CUSTOMER_REQUEST_DATE BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"
            strSql = strSql & " AND E.ORGANIZATION_KEY_ID(+) = A.PART_PRCR_SRC_ORG_KEY_ID "
            strSql = strSql & " AND E.RECORD_STATUS_CDE (+) = 'C' "
        Else
            strSql = strSql & " AND AMP_SHIPPED_DATE BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"
            strSql = strSql & " AND E.ORGANIZATION_KEY_ID(+) = A.PART_PRCR_SRC_ORG_KEY_ID "
            strSql = strSql & " AND E.EFFECTIVE_FROM_DT(+) <= A.AMP_SHIPPED_DATE "
            strSql = strSql & " AND E.EFFECTIVE_TO_DT(+) >= A.AMP_SHIPPED_DATE "
        End If

        If vntViewId = "8" Then
            strSql = strSql & " AND (F.ASOC_GLOBAL_ID(+) = A.PRODUCT_MANAGER_GLOBAL_ID) "
        End If

        vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"
        
        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        If vntOrgKeyId <> "" Then
            strSql = strSql & " AND  C.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgKeyId & "' "
            If vntViewId = "10" Then
                strSql = strSql & " AND D.LAYER" & vntMfgLevel & "_ORGANIZATION_ID = '" & vntMfgOrgId & "' "
                strSql = strSql & " AND  A.MFR_ORG_KEY_ID = D.ORGANIZATION_KEY_ID(+) "
                strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID(+) "
            Else
                strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID "
            End If
            If vntCurrentHist <> "" Then
                If vntCurrentHist = "C" Then
                    If vntViewId = "10" Then
                        strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                        strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                        strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                        strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                    Else

                        strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                    End If
                    vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
                Else
                    If vntViewId = "10" Then
                        strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                        strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                        strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                        strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                    Else
                        strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                        strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                    End If
                    vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                    vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
                End If
            Else
                strSql = strSql & " AND RECORD_STATUS_CDE = 'C' "
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
            End If
            
            If vntViewId = "10" Then
                If vntCurrentHist = "C" Then
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
            End If
        End If

        If vntWindowId = "1" Then 'cust variable
            If vntSmryType = "1" Then 'STR
                If vntCategoryId = "3" Then
                    strSql = strSql & " AND (VARBL_SCHEDULE_SHIP_VARIANCE <> 0) "
                Else
                    strSql = strSql & " AND VARBL_SCHEDULE_SHIP_VARIANCE = 0 "
                End If
            Else 'STR
                If vntCategoryId = "3" Then
                    strSql = strSql & " AND (VARBL_REQUEST_SHIP_VARIANCE <> 0) "
                Else
                    strSql = strSql & " AND VARBL_REQUEST_SHIP_VARIANCE = 0 "
                End If
            End If
            
        ElseIf vntWindowId = "2" Then 'std default
            If vntSmryType = "1" Then 'STS
                vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> All;"
                vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
                If vntCategoryId = "3" Then 'non conforming
                    'strSql = strSql & " AND ((SCHEDULE_TO_SHIP_VARIANCE NOT BETWEEN -" & vntDaysEarly & " AND " & vntDaysLate & ") "
                    strSql = strSql & " AND ((SCHEDULE_TO_SHIP_VARIANCE > " & vntDaysLate & ") "
                    strSql = strSql & " OR  (SCHEDULE_TO_SHIP_VARIANCE <> 0 "
                    'strSql = strSql & " AND (SCHEDULE_TO_SHIP_VARIANCE BETWEEN -" & vntDaysEarly & " AND " & vntDaysLate & ") "
                    strSql = strSql & " AND CUSTOMER_TYPE_CODE = 'J'))"
                Else 'conforming
                    'strSql = strSql & " AND (((SCHEDULE_TO_SHIP_VARIANCE BETWEEN -" & vntDaysEarly & " AND " & vntDaysLate & ") "
                    strSql = strSql & " AND (((SCHEDULE_TO_SHIP_VARIANCE <= " & vntDaysLate & ") "
                    strSql = strSql & " AND ((CUSTOMER_TYPE_CODE IS NULL) OR (CUSTOMER_TYPE_CODE <> 'J'))) "
                    strSql = strSql & " OR ((SCHEDULE_TO_SHIP_VARIANCE = 0) "
                    strSql = strSql & " AND (CUSTOMER_TYPE_CODE = 'J'))) "
                End If

            ElseIf vntSmryType = "2" Then
                vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
                vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
                If vntCategoryId = "3" Then
                    strSql = strSql & " AND (REQUEST_TO_SHIP_VARIANCE NOT BETWEEN -" & vntDaysEarly & " AND " & vntDaysLate & ") "
                Else
                    strSql = strSql & " AND (REQUEST_TO_SHIP_VARIANCE BETWEEN -" & vntDaysEarly & " AND " & vntDaysLate & ") "
                End If

            ElseIf vntSmryType = "3" Then
                If vntCategoryId = "3" Or vntCategoryId = "29" Then
                    strSql = strSql & " AND REQUEST_TO_SCHEDULE_VARIANCE <> 0 "
                Else
                    strSql = strSql & " AND REQUEST_TO_SCHEDULE_VARIANCE = 0 "
                End If
            End If
            'vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
            'vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"

        Else
            If vntCategoryId = "3" Then
                strSql = strSql & " AND RELEASE_TO_SHIP_VARIANCE > 0 "
            Else
                strSql = strSql & " AND ((RELEASE_TO_SHIP_VARIANCE BETWEEN -3 AND 0 "
                strSql = strSql & " AND (CUSTOMER_TYPE_CODE IS NULL OR CUSTOMER_TYPE_CODE <> 'J')) "
                strSql = strSql & " OR (RELEASE_TO_SHIP_VARIANCE = 0 AND CUSTOMER_TYPE_CODE = 'J')) "
            End If
        End If

        If vntPlant <> "" Then
            strSql = strSql & " AND (ACTUAL_SHIP_BUILDING_NBR = '" & vntPlant & "')"
            vntDispCrit = vntDispCrit & " <strong>Plant/Blg:</strong> " & vntPlant & ";"
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If vntPart <> "" And Not IsDBNull(vntPartKeyID) Then
            '    intCountST = 0
            '    vntTemp = ""
            '    vntPart = Replace(vntPart, "-", "")
            '    If Len(vntPart) < 9 Then
            '        For intCountST = 1 To 9 - Len(vntPart)
            '            vntTemp = "0" & vntTemp
            '        Next
            '        vntPart = vntTemp & vntPart
            '    End If
            '    strSql = strSql & " AND A.Part_Nbr = '" & vntPart & "' "
            strSql = strSql & " AND A.PART_KEY_ID = " & vntPartKeyID
            vntDispCrit = vntDispCrit & " <strong>Part:</strong> " & vntPart & ";"
        End If

        If vntLocation <> "" Then
            strSql = strSql & " AND ACTUAL_SHIP_LOCATION = '" & vntLocation & "'"
            vntDispCrit = vntDispCrit & " <strong>Location:</strong> " & vntLocation & ";"
        End If

        If vntTeam <> "" Then
            strSql = strSql & " AND TEAM_CODE = '" & vntTeam & "'"
            vntDispCrit = vntDispCrit & " <strong>Team:</strong> " & vntTeam & ";"
        End If

        If vntController <> "" Then
            If InStr(vntController, ",") > 0 Then
                strSql = strSql & " AND PRODCN_CNTRLR_CODE IN ( " & QuoteStr(vntController) & " ) "
            Else
                strSql = strSql & " AND PRODCN_CNTRLR_CODE " & IIf(InStr(vntController, "%") > 0, "LIKE '", "= '") & vntController & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Controller:</strong> " & vntController & ";"
        End If

        If vntInvOrg <> "" Then
            If InStr(vntInvOrg, ",") > 0 Then
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID IN ( " & QuoteStr(vntInvOrg) & " ) "
            Else
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID " & IIf(InStr(vntInvOrg, "%") > 0, "LIKE '", "= '") & vntInvOrg & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Inv Org/Plant:</strong> " & vntInvOrg & ";"
        End If

        If vntStkMake <> "" Then
            vntLength = Len(vntStkMake)
            strSql = strSql & " AND substr(STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            vntDispCrit = vntDispCrit & " <strong>Make Stock:</strong> " & vntStkMake & ";"
        End If

        If vntMrpGroupCde <> "" Then
            If InStr(vntMrpGroupCde, ",") > 0 Then
                strSql = strSql & " AND MRP_GROUP_CDE IN ( " & QuoteStr(vntMrpGroupCde) & " ) "
            Else
                strSql = strSql & " AND MRP_GROUP_CDE " & IIf(InStr(vntMrpGroupCde, "%") > 0, "LIKE '", "= '") & vntMrpGroupCde & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>MRP Group:</strong> " & vntMrpGroupCde & ";"
        End If

        If vntProdCde <> "" Then
            strSql = strSql & " AND PRODUCT_CODE = '" & vntProdCde & "'"
            vntDispCrit = vntDispCrit & " <strong>Product Code:</strong> " & vntProdCde & ";"
        End If

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        If vntProdLne <> "" Then
            If InStr(vntProdLne, ",") > 0 Then
                strSql = strSql & " AND PRODUCT_LINE_CODE IN ( " & QuoteStr(vntProdLne) & " )"
            Else
                strSql = strSql & " AND PRODUCT_LINE_CODE = '" & vntProdLne & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Product Line:</strong> " & vntProdLne & ";"
        End If

        If vntMfgCampus <> "" Then
            strSql = strSql & " AND MFG_CAMPUS_ID = '" & vntMfgCampus & "'"
            vntDispCrit = vntDispCrit & " <strong>Mfg Campus:</strong> " & vntMfgCampus & ";"
        End If

        If vntMfgBuilding <> "" Then
            strSql = strSql & " AND MFG_BUILDING_NBR = '" & vntMfgBuilding & "'"
            vntDispCrit = vntDispCrit & " <strong>Mfg Building:</strong> " & vntMfgBuilding & ";"
        End If

        If vntIBC <> "" Then
            If InStr(vntIBC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE IN ( " & QuoteStr(vntIBC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE = '" & vntIBC & "'"
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry Business:</strong> " & vntIBC & ";"
        End If

        If vntIC <> "" Then
            If InStr(vntIC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_CODE IN ( " & QuoteStr(vntIC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_CODE LIKE '" & vntIC & "%'"
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry:</strong> " & vntIC & ";"
        End If

        If vntWWCust <> "" Then
            vntTemp2 = vntWWCust
            intFound = 0
            vntTempWW = ""
            vntTempWW2 = ""
            intCountWW = 0
            intFound = InStr(vntWWCust, "-")
            If intFound <> 0 Then
                vntTempWW = Left(vntWWCust, intFound - 1)
                vntTempWW2 = Right(vntWWCust, Len(vntWWCust) - intFound)
            Else
                If Len(vntWWCust) > 10 Then
                    Err.Raise(901, , "WorldWide Number is invalid.  These numbers are required to have a maximum of 10 characters")
                ElseIf Len(vntWWCust) <= 8 Then
                    vntTempWW = vntWWCust
                ElseIf Len(vntWWCust) = 9 Then
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 1)
                Else
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 2)
                End If
            End If

            If Len(vntTempWW) < 8 Then
                For intCountWW = 1 To 8 - Len(vntTempWW)
                    vntTemp = vntTemp & "0"
                Next
                vntWWCust = vntTemp & vntTempWW
            Else
                vntWWCust = vntTempWW
            End If

            If Len(vntTempWW2) = 1 Then
                vntTempWW2 = "0" & vntTempWW2
                vntWWCust = vntWWCust & vntTempWW2
            Else
                vntWWCust = vntWWCust & vntTempWW2
            End If

            If Len(vntWWCust) > 8 Then
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
                strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
            Else
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
            End If

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntShipTo <> "" Then
            vntTemp2 = vntShipTo
            intCountST = 0
            vntTemp = ""
            vntShipTo = Replace(vntShipTo, "-", "")
            If Len(vntShipTo) < 10 Then
                For intCountST = 1 To 10 - Len(vntShipTo)
                    vntTemp = "0" & vntTemp
                Next
                vntShipTo = vntTemp & vntShipTo
            End If

            If Len(vntShipTo) > 10 Then
                Err.Raise(901, , "Ship To Number is invalid.  These numbers are required to have 10 characters")
            Else
                strSql = strSql & " AND PURCHASE_BY_ACCOUNT_BASE = '" & Left(vntShipTo, 8) & "'"
                strSql = strSql & " AND SHIP_TO_ACCOUNT_SUFFIX = '" & Right(vntShipTo, 2) & "'"
            End If

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntacctOrgKey <> "" Then
            strSql = strSql & " AND ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey
        End If

        If vntCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_ID = '" & vntCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Competency Business:</strong> " & vntCBC & ";"
        End If

        If vntSubCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_FNCTN_ID = '" & vntSubCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Sub-Competency Business:</strong> " & vntSubCBC & ";"
        End If

        If vntProfit <> "" Then
            strSql = strSql & " AND PROFIT_CENTER_ABBR_NM = '" & vntProfit & "' "
            vntDispCrit = vntDispCrit & " <strong>Profit Center:</strong> " & vntProfit & ";"
        End If

        If vntSalesOffice <> "" Then
            If InStr(vntSalesOffice, ",") > 0 Then
                strSql = strSql & " AND A.SALES_OFFICE_CDE IN ( " & QuoteStr(vntSalesOffice) & " ) "
            Else
                strSql = strSql & " AND A.SALES_OFFICE_CDE " & IIf(InStr(vntSalesOffice, "%") > 0, "LIKE '", "= '") & vntSalesOffice & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Office:</strong> " & vntSalesOffice & ";"
        End If

        If vntSalesGroup <> "" Then
            If InStr(vntSalesGroup, ",") > 0 Then
                strSql = strSql & " AND A.SALES_GROUP_CDE IN ( " & QuoteStr(vntSalesGroup) & " ) "
            Else
                strSql = strSql & " AND A.SALES_GROUP_CDE " & IIf(InStr(vntSalesGroup, "%") > 0, "LIKE '", "= '") & vntSalesGroup & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Group:</strong> " & vntSalesGroup & ";"
        End If

        If vntSoldTo <> "" Then
            vntTemp2 = vntSoldTo
            intCountST = 0
            vntTemp = ""
            vntSoldTo = Replace(vntSoldTo, "-", "")

            If Len(vntSoldTo) < 8 Then
                For intCountST = 1 To 8 - Len(vntSoldTo)
                    vntTemp = "0" & vntTemp
                Next
                vntSoldTo = vntTemp & vntSoldTo
            End If

            If Len(vntSoldTo) > 8 Then
                Err.Raise(901, , "Sold To Number is invalid.  These numbers are required to have 8 characters")
            Else
                strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
            End If

            blnrc = objGetSoldToName.RetrieveName(vntCustOrg, vntSoldTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetSoldToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntProdMgr <> "" Then
            strSql = strSql & ParseProdMgr(vntProdMgr)
            vntDispCrit = vntDispCrit & " <strong>Product Mgr:</strong> " & vntProdMgr & ";"
        End If

        If vntViewId = "3" And vntHostOrgID <> "" Then
            strSql = strSql & " AND glod.GLOD_LEGAL_ORG_ID IN ( " & QuoteStr(vntHostOrgID) & " ) "
            strSql = strSql & " AND gp.PROD_HOST_ORG_ID = glod.GLOD_DESCENDENT_LEGAL_ORG_ID "
            strSql = strSql & " AND a.PRODUCT_CODE = gp.PROD_CODE"
            vntDispCrit = vntDispCrit & " <strong>Product Host OrgID:</strong> " & vntHostOrgID & ";"
        End If

        strSql = strSql & " AND a.SHIP_TO_CUSTOMER_KEY_ID = shipto.CUSTOMER_KEY_ID "
        strSql = strSql & " AND a.SOLD_TO_CUSTOMER_KEY_ID = soldto.CUSTOMER_KEY_ID "
        strSql = strSql & " ORDER BY Part_Number ASC, computed_comparison_date_2 ASC"

        objList = objCallRS.CallRS_WithConn(objConnection, strSql, vntCount, vntErrorNumber, vntErrorDesc)
        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsResults.ListConfNonConf call to CallRS for Conform-NonConform Query")
        End If

        If vntCount > 0 Then
            If vntGetTotal = "1" Then
                vntTempArray = objList.GetRows
                intCount = 0
                For intCount = 0 To UBound(vntTempArray, 2)
                    vntTBRTotal = vntTBRTotal + CDbl(vntTempArray(23, intCount))
                    vntExtTotal = vntExtTotal + CDbl(vntTempArray(15, intCount))
                    vntLocalTotal = vntLocalTotal + CDbl(vntTempArray(18, intCount))
                    vntShpQtyTotal = vntShpQtyTotal + CInt(vntTempArray(28, intCount))
                Next
                vntTBRTotal = VB6.Format(vntTBRTotal, "$#,####,##0.00")
                vntExtTotal = VB6.Format(vntExtTotal, "$#,####,##0.00")
                vntLocalTotal = VB6.Format(vntLocalTotal, "#,####,##0.00")
                vntShpQtyTotal = VB6.Format(vntShpQtyTotal, "#,####,##0")
            End If
            
            If vntExport = "1" Then 'This would be true, process entire recordset
                'objList.Sort = "Part_Number ASC, computed_comparison_date_2 ASC"
                objList.MoveFirst()
                ListConfNonConf = objList.GetRows
            Else
                'objList.Sort = "Part_Number ASC, computed_comparison_date_2 ASC"
                objList.PageSize = 100
                objList.AbsolutePage = vntPage
                If vntCount > 100 Then
                    intRecsLeft = CInt(vntCount) - ((vntPage - 1) * 100)
                    If intRecsLeft < 0 Then
                        intRecsLeft = CInt(vntCount) - ((vntPage - 1) * 100)
                    End If
                    If intRecsLeft >= 100 Then
                        intPageCount = 100
                    Else
                        intPageCount = intRecsLeft
                    End If
                Else
                    intPageCount = vntCount
                End If
                vntRecsLeft = intRecsLeft
                
                ReDim vntArray(CInt(intPageCount) - 1, objList.Fields.Count)
                intCount = 0
                Do Until intCount = intPageCount
                    vntArray(intCount, 0) = objList.Fields.Item("SL").Value
                    vntArray(intCount, 1) = objList.Fields.Item("Part_Number").Value
                    vntArray(intCount, 2) = objList.Fields.Item("ONBR").Value

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("computed_comparison_date_1").Value) Then
                        vntArray(intCount, 3) = "&nbsp;"
                    ElseIf objList.Fields.Item("computed_comparison_date_1").Value = "0001-01-01" Then
                        vntArray(intCount, 3) = "9999-99-99"
                    Else
                        vntArray(intCount, 3) = objList.Fields.Item("computed_comparison_date_1").Value
                    End If

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("computed_comparison_date_2").Value) Then
                        vntArray(intCount, 4) = "&nbsp;"
                    ElseIf objList.Fields.Item("computed_comparison_date_2").Value = "0001-01-01" Then
                        vntArray(intCount, 4) = "9999-99-99"
                    Else
                        vntArray(intCount, 4) = objList.Fields.Item("computed_comparison_date_2").Value
                    End If

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("computed_comparison_date").Value) Then
                        vntArray(intCount, 5) = "&nbsp;"
                    Else
                        If objList.Fields.Item("computed_comparison_date").Value = "0001-01-01" Then
                            vntArray(intCount, 5) = "9999-99-99"
                        Else
                            vntArray(intCount, 5) = objList.Fields.Item("computed_comparison_date").Value
                        End If
                    End If
                    vntArray(intCount, 6) = objList.Fields.Item("computed_comparison_code").Value
                    vntArray(intCount, 7) = objList.Fields.Item("computed_variance").Value

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("CTC").Value) Then
                        vntArray(intCount, 8) = "&nbsp;"
                    Else
                        vntArray(intCount, 8) = objList.Fields.Item("CTC").Value
                    End If

                    vntArray(intCount, 9) = objList.Fields.Item("DOC_Ind").Value
                    vntArray(intCount, 10) = objList.Fields.Item("NDE").Value
                    vntArray(intCount, 11) = objList.Fields.Item("NDL").Value
                    vntArray(intCount, 12) = objList.Fields.Item("OIN").Value
                    vntArray(intCount, 13) = objList.Fields.Item("SI").Value
                    vntArray(intCount, 14) = objList.Fields.Item("TempCode").Value
                    vntArray(intCount, 15) = VB6.Format(objList.Fields.Item("BillAmount").Value, "$#,###.00")
                    vntArray(intCount, 16) = objList.Fields.Item("part_desc").Value
                    vntArray(intCount, 17) = objList.Fields.Item("customer_account_nbr").Value
                    vntArray(intCount, 18) = objList.Fields.Item("LCBillAmt").Value
                    vntArray(intCount, 19) = objList.Fields.Item("OrgID").Value
                    vntArray(intCount, 20) = objList.Fields.Item("ICC").Value
                    vntArray(intCount, 21) = objList.Fields.Item("PCC").Value

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("ORD").Value) Then
                        vntArray(intCount, 22) = "&nbsp;"
                    ElseIf objList.Fields.Item("ORD").Value = "0001-01-01" Then
                        vntArray(intCount, 22) = "9999-99-99"
                    Else
                        vntArray(intCount, 22) = objList.Fields.Item("ORD").Value
                    End If

                    vntArray(intCount, 23) = VB6.Format(objList.Fields.Item("TBRAmount").Value, "$#,###.00")
                    vntArray(intCount, 24) = objList.Fields.Item("ProdMgrName").Value
                    vntArray(intCount, 25) = objList.Fields.Item("SoldTo").Value

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("SbmtPart").Value) Then
                        vntArray(intCount, 26) = "&nbsp;"
                    Else
                        vntArray(intCount, 26) = objList.Fields.Item("SbmtPart").Value
                    End If

                    vntArray(intCount, 27) = VB6.Format(objList.Fields.Item("ItemQty").Value, "#,###")
                    vntArray(intCount, 28) = VB6.Format(objList.Fields.Item("ShipQty").Value, "#,###")
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 29) = IIf(IsDBNull(objList.Fields.Item("InvNbr").Value), "&nbsp;", objList.Fields.Item("InvNbr").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 30) = IIf(IsDBNull(objList.Fields.Item("CustPart").Value), "&nbsp;", objList.Fields.Item("CustPart").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 31) = IIf(IsDBNull(objList.Fields.Item("PONbr").Value), "&nbsp;", objList.Fields.Item("PONbr").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 32) = IIf(IsDBNull(objList.Fields.Item("PODate").Value), "&nbsp;", objList.Fields.Item("PODate").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 33) = IIf(IsDBNull(objList.Fields.Item("PPSOC").Value), "&nbsp;", objList.Fields.Item("PPSOC").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 34) = IIf(IsDBNull(objList.Fields.Item("DocNo").Value), "&nbsp;", objList.Fields.Item("DocNo").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 35) = IIf(IsDBNull(objList.Fields.Item("MrpGroup").Value), "null", objList.Fields.Item("MrpGroup").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 36) = IIf(IsDBNull(objList.Fields.Item("MakeStock").Value), "&nbsp;", objList.Fields.Item("MakeStock").Value)
                    vntArray(intCount, 37) = IIf(IsDBNull(objList.Fields.Item("ShiptoNm").Value), "&nbsp;", objList.Fields.Item("ShiptoNm").Value)
                    vntArray(intCount, 38) = IIf(IsDBNull(objList.Fields.Item("SoldtoNm").Value), "&nbsp;", objList.Fields.Item("SoldtoNm").Value)
                    vntArray(intCount, 39) = IIf(IsDBNull(objList.Fields.Item("SLoc").Value), "&nbsp;", objList.Fields.Item("SLoc").Value)
                    vntArray(intCount, 40) = IIf(IsDBNull(objList.Fields.Item("OrderRecDt").Value), "&nbsp;", objList.Fields.Item("OrderRecDt").Value)
                    vntArray(intCount, 41) = IIf(IsDBNull(objList.Fields.Item("OrderCreateBy").Value), "&nbsp;", objList.Fields.Item("OrderCreateBy").Value)
                    vntArray(intCount, 42) = IIf(IsDBNull(objList.Fields.Item("DlvryDocCreateDt").Value), "&nbsp;", objList.Fields.Item("DlvryDocCreateDt").Value)
                    vntArray(intCount, 43) = IIf(IsDBNull(objList.Fields.Item("DlvryDocCreateTm").Value), "&nbsp;", objList.Fields.Item("DlvryDocCreateTm").Value)
                    vntArray(intCount, 44) = IIf(IsDBNull(objList.Fields.Item("DlvryDocCreateBy").Value), "&nbsp;", objList.Fields.Item("DlvryDocCreateBy").Value)
                    vntArray(intCount, 45) = IIf(IsDBNull(objList.Fields.Item("CustomerRequestDate").Value), "&nbsp;", objList.Fields.Item("CustomerRequestDate").Value)
                    vntArray(intCount, 46) = IIf(IsDBNull(objList.Fields.Item("AmpScheduleDate").Value), "&nbsp;", objList.Fields.Item("AmpScheduleDate").Value)
                    objList.MoveNext()
                    intCount = intCount + 1
                Loop

                ListConfNonConf = vntArray
            End If
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListConfNonConf = System.DBNull.Value
        End If

        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If
        objConnection = Nothing

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        Exit Function

ErrorHandler:
        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If
        objConnection = Nothing
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListConfNonConf = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function
	
	'##ModelId=3A8BF5590019
    Public Function ListPstDueOpen(ByVal vntSessionID As String, ByVal vntGetTotal As String, ByVal vntPage As String, ByVal vntExport As Object, ByRef vntCount As Object, ByRef vntRecsLeft As Object, ByRef vntTBRTotal As Object, ByRef vntExtTotal As Object, ByRef vntLocalTotal As Object, ByRef vntComparisonType As Object, ByRef vntDispCrit As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objConnection As New ADODB.Connection
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim objSearch As New clsSearch
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
        Dim vntArray As Object
        'Dim intPageCount As Short
        'Dim intRecsLeft As Short
        'Dim intCount As Short
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntWindowId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntSmryType As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgID As Object
        'Dim vntDaysEarly As Object
        'Dim vntDaysLate As Object
        'Dim vntMonthDailyInd As Object
        'Dim vntCustAcctTypeCde As Object
        'Dim vntPart As Object
        'Dim vntPlant As Object
        'Dim vntLocation As Object
        'Dim vntacctOrgKey As Object
        'Dim vntShipTo As Object
        'Dim vntSoldTo As Object
        'Dim vntWWCust As Object
        'Dim vntInvOrg As Object
        'Dim vntController As Object
        'Dim vntCntlrEmpNbr As Object
        'Dim vntStkMake As Object
        'Dim vntTeam As Object
        'Dim vntProdCde As Object
        'Dim vntProdLne As Object
        'Dim vntIBC As Object
        'Dim vntIC As Object
        'Dim vntMfgCampus As Object
        'Dim vntMfgBuilding As Object
        'Dim vntOpenShpOrder As Object
        'Dim vntProfit As Object
        'Dim vntCBC As Object
        'Dim vntSubCBC As Object
        'Dim vntOrgDate As Object
        'Dim vntLevel As Object
        'Dim vntKeyId As Object
        'Dim vntTempArray As Object
        'Dim vntOrgType As Object
        'Dim vntLength As Object
        'Dim vntOrgTypeDesc As Object
        'Dim intCountST As Short
        'Dim vntTemp As Object
        'Dim vntTempWW As Object
        'Dim vntTempWW2 As Object
        'Dim intCountWW As Short
        'Dim intFound As Short
        '      Dim objGetWWName As New clsWrldWide
        '      Dim objGetShipToName As New clsShipTo
        '      Dim objGetSoldToName As New clsSoldTo
        'Dim vntName As Object
        'Dim vntTemp2 As Object
        'Dim vntCustOrg As Object
        'Dim vntProdMgr As Object
        'Dim vntLeadTimeType As Object
        'Dim vntSalesOffice As Object
        'Dim vntSalesGroup As Object
        'Dim vntMfgOrgType As Object
        'Dim vntMfgOrgId As Object
        'Dim vntMfgLevel As Object
        'Dim GamAccount As Object
        'Dim vntPartKeyID As Object
        'Dim vntMrpGroupCde As Object
        'Dim vntHostOrgID As Object
        Dim intPageCount As Integer
        Dim intRecsLeft As Integer
        Dim intCount As Integer
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntWindowId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
        Dim vntSmryType As String = ""
        Dim vntCurrentHist As String = ""
        Dim vntOrgID As String = ""
        Dim vntOrgKeyId As String = ""
        Dim vntDaysEarly As String = ""
        Dim vntDaysLate As String = ""
        Dim vntMonthDailyInd As String = ""
        Dim vntCustAcctTypeCde As String = ""
        Dim vntPart As String = ""
        Dim vntPlant As String = ""
        Dim vntLocation As String = ""
        Dim vntacctOrgKey As String = ""
        Dim vntShipTo As String = ""
        Dim vntSoldTo As String = ""
        Dim vntWWCust As String = ""
        Dim vntInvOrg As String = ""
        Dim vntController As String = ""
        Dim vntCntlrEmpNbr As String = ""
        Dim vntStkMake As String = ""
        Dim vntTeam As String = ""
        Dim vntProdCde As String = ""
        Dim vntProdLne As String = ""
        Dim vntIBC As String = ""
        Dim vntIC As String = ""
        Dim vntMfgCampus As String = ""
        Dim vntMfgBuilding As String = ""
        'Dim vntComparisonType As String = ""
        Dim vntOpenShpOrder As String = ""
        Dim vntProfit As String = ""
        Dim vntCBC As String = ""
        Dim vntSubCBC As String = ""
        Dim vntOrgDate As String = ""
        Dim vntLevel As String = ""
        Dim vntKeyId As Long
        Dim vntTempArray As Object
        Dim vntOrgType As String = ""
        Dim vntLength As Integer
        Dim vntOrgTypeDesc As String = ""
        Dim intCountST As Integer
        Dim vntTemp As String = ""
        Dim vntTempWW As String = ""
        Dim vntTempWW2 As String = ""
        Dim intCountWW As Integer
        Dim intFound As Integer
        Dim objGetWWName As New clsWrldWide
        Dim objGetShipToName As New clsShipTo
        Dim objGetSoldToName As New clsSoldTo
        Dim vntName As String = ""
        Dim vntTemp2 As String = ""
        Dim vntCustOrg As String = ""
        Dim vntProdMgr As String = ""
        Dim vntLeadTimeType As String = ""
        Dim vntSalesOffice As String = ""
        Dim vntSalesGroup As String = ""
        Dim vntMfgOrgType As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgLevel As String = ""
        Dim GamAccount As String = ""
        Dim vntPartKeyID As String = ""
        Dim vntMrpGroupCde As String = ""
        Dim vntHostOrgID As String = ""
        On Error GoTo ErrorHandler

        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResults.ListConfNonConf")
        End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDate, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNumber, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsSearch.RetrieveSession")
        End If

        If vntOrgID <> "" Then

            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"

            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDate, vntLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel")
            End If

            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
        End If

        If vntMfgOrgId <> "" Then

            blnrc = objOrgs.RetrieveType(vntMfgOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Mfg Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Mfg Org ID:</strong> " & vntMfgOrgId & ";"

            blnrc = objOrgs.RetrieveLevel(vntMfgOrgId, vntCurrentHist, vntOrgDate, vntMfgLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListPastDueOpen")
            End If

            If Len(vntMfgLevel) > 6 Then
                vntMfgLevel = Right(vntMfgLevel, 2)
            Else
                vntMfgLevel = Right(vntMfgLevel, 1)
            End If
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org ID:</strong> " & vntacctOrgKey & ";"

            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDate, vntKeyId, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If

            vntacctOrgKey = vntKeyId
        End If

        'strSql = " SELECT   INVENTORY_LOCATION_CODE ILC,   "
        strSql = " SELECT INVENTORY_BUILDING_NBR ILC, "
        strSql = strSql & " TYCO_ELECTRONICS_CORP_PART_NBR Part_Number,   "
        strSql = strSql & " AMP_ORDER_NBR AON,   "
        strSql = strSql & " PRODCN_CNTRLR_CODE PCC,   "
        strSql = strSql & " (RESRVN_LEVEL_1 + RESRVN_LEVEL_5 + RESRVN_LEVEL_9 + QUANTITY_RELEASED) RemainQty,   "
        strSql = strSql & " TO_CHAR(REPORTED_AS_OF_DATE, 'YYYY-MM-DD') RD,   "

        If vntCategoryId = "5" Then
            strSql = strSql & " Null ReqDate,  "
        ElseIf vntCategoryId = "6" Then
            strSql = strSql & " TO_CHAR(CUSTOMER_REQUEST_DATE, 'YYYY-MM-DD') ReqDate,  "
        End If

        If vntComparisonType = "1" Then
            strSql = strSql & " TO_CHAR(AMP_SCHEDULE_DATE, 'YYYY-MM-DD') computed_comparison_date,   "
            vntDispCrit = vntDispCrit & " <strong>Comparison:</strong> Compare to Schedule;"
        ElseIf vntComparisonType = "2" Then
            If vntCategoryId = "6" Then 'Opens
                strSql = strSql & " TO_CHAR(AMP_SCHEDULE_DATE, 'YYYY-MM-DD') computed_comparison_date,   "
            Else
                strSql = strSql & " TO_CHAR(CUSTOMER_REQUEST_DATE, 'YYYY-MM-DD') computed_comparison_date,   "
            End If
            vntDispCrit = vntDispCrit & " <strong>Comparison:</strong> Compare to Request;"
        End If

        'If vntCategoryId = 5 Then
        strSql = strSql & " DECODE(1, SIGN(RESRVN_LEVEL_1),1, SIGN(RESRVN_LEVEL_5),5, SIGN(RESRVN_LEVEL_9),9) Reserve_Level,   "
        'ElseIf vntCategoryId = 6 Then
        '    strSql = strSql & " NULL Reserve_Level, "
        'End If
        
        'strSql = strSql & " TEMP_HOLD_IND THI,   "
        strSql = strSql & " Null THI,   "

        If vntCategoryId = "5" Then
            If vntComparisonType = "1" Then
                strSql = strSql & " CURRENT_TO_SCHEDULE_VARIANCE Days_Late,   "
            ElseIf vntComparisonType = "2" Then
                strSql = strSql & " CURRENT_TO_REQUEST_VARIANCE Days_Late,   "
            End If
        ElseIf vntCategoryId = "6" Then
            strSql = strSql & " Null Days_Late,  "
        End If

        strSql = strSql & " CUSTOMER_TYPE_CODE CTC,   "
        
        If vntCategoryId <> "6" Then
            'strSql = strSql & " DECODE('0', NVL(TO_CHAR(ACTUAL_ON_DOCK_DATE),'0'), '0', TO_CHAR(AMP_SCHEDULE_DATE - ACTUAL_ON_DOCK_DATE), '0', '1') DOC_Ind,   "
            strSql = strSql & " '0' DOC_Ind,   "
        Else
            strSql = strSql & " NULL DOC_Ind,   "
        End If
        
        strSql = strSql & " ORDER_ITEM_NBR OIN,   "
        strSql = strSql & " SHIPMENT_ID SI,   "
        strSql = strSql & " extended_book_bill_amount EBBA,  "
        strSql = strSql & " local_currency_billed_amount LCBA, "
        strSql = strSql & " B.PART_DESC part_desc, "
        strSql = strSql & " PURCHASE_BY_ACCOUNT_BASE||SHIP_TO_ACCOUNT_SUFFIX customer_account_nbr,   "
        strSql = strSql & " A.ORGANIZATION_KEY_ID OrgID, "
        strSql = strSql & " ISO_CURRENCY_CODE_1 ICC, "
        strSql = strSql & " TO_CHAR(ORDER_RECEIVED_DATE, 'YYYY-MM-DD') ORD"
        strSql = strSql & " ,BUDGET_RATE_BOOK_BILL_AMT TBRAmount "
        
        If vntViewId = "8" Then
            strSql = strSql & " ,F.FIRST_NAME||DECODE(F.MIDDLE_INITIAL,NULL,'',' '||F.MIDDLE_INITIAL)||' '||F.LAST_NAME ProdMgrName "
        Else
            strSql = strSql & " ,Null ProdMgrName "
        End If
        
        strSql = strSql & " ,ITEM_QUANTITY ItemQty "
        strSql = strSql & " ,CUSTOMER_REFERENCE_PART_NBR CustPart "
        strSql = strSql & " ,PURCHASE_ORDER_NBR PONbr "
        strSql = strSql & " ,TO_CHAR(PURCHASE_ORDER_DATE, 'YYYY-MM-DD') PODate "
        strSql = strSql & " ,E.ORGANIZATION_ID PPSOC "
        strSql = strSql & " ,SBMT_PART_NBR SbmtPart "
        strSql = strSql & " ,shipto.CUSTOMER_NM ShiptoNm "
        strSql = strSql & " FROM ORDER_ITEM_OPEN A, "
        strSql = strSql & " CORPORATE_PARTS B"

        If vntOrgID <> "" Or GamAccount <> "" Then
            strSql = strSql & ", ORGANIZATIONS_DMN C "
        End If
        
        If vntViewId = "8" Then
            strSql = strSql & ", GED_PUBLIC_TABLE F "
        End If

        If vntViewId = "10" Then
            strSql = strSql & ", ORGANIZATIONS_DMN D "
        End If

        If GamAccount <> "" Then
            strSql = strSql & ", GBL_ALL_CUST_PURCH_BY G "
        End If

        strSql = strSql & ", ORGANIZATIONS_DMN E "

        If vntViewId = "3" And vntHostOrgID <> "" Then
            strSql = strSql & ", GBL_PRODUCT gp "
            strSql = strSql & ", GBL_LEGAL_ORG_DESCENDENTS glod "
        End If

        strSql = strSql & ", CUSTOMER_PARTNER_DMN_CURR_V shipto "
        strSql = strSql & " WHERE A.PART_KEY_ID = B.PART_KEY_ID (+) "
        strSql = strSql & " AND E.ORGANIZATION_KEY_ID(+) = A.PART_PRCR_SRC_ORG_KEY_ID "
        strSql = strSql & " AND E.RECORD_STATUS_CDE(+) = 'C' "

        If vntViewId = "8" Then
            strSql = strSql & " AND (F.ASOC_GLOBAL_ID(+) = A.PRODUCT_MANAGER_GLOBAL_ID) "
        End If
        
        If vntOrgID <> "" Then
            strSql = strSql & " AND  C.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        End If
        
        If vntViewId = "10" Then
            strSql = strSql & " AND  D.LAYER" & vntMfgLevel & "_ORGANIZATION_ID = '" & vntMfgOrgId & "' "
            strSql = strSql & " AND  A.MFR_ORG_KEY_ID = D.ORGANIZATION_KEY_ID(+) "
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID(+) "
        ElseIf GamAccount <> "" Then
            strSql = strSql & "AND C.ORGANIZATION_ID = g.PB_ACCT_ORG_ID"
        Else
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID "
        End If
        
        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                Else
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                End If
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
            Else
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
            End If
            
            If vntViewId = "10" Then
                If vntCurrentHist = "C" Then
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
            End If
        Else
            strSql = strSql & " AND C.RECORD_STATUS_CDE = 'C' "
            vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
        End If

        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        If vntComparisonType = "1" Then
            strSql = strSql & " AND AMP_SCHEDULE_DATE BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"
            vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"
        ElseIf vntComparisonType = "2" Then
            strSql = strSql & " AND CUSTOMER_REQUEST_DATE BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"
            vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"
        End If

        If vntCategoryId = "5" Then
            If vntComparisonType = "1" Then
                strSql = strSql & " AND (CURRENT_TO_SCHEDULE_VARIANCE > 0)"
            ElseIf vntComparisonType = "2" Then
                strSql = strSql & " AND (CURRENT_TO_REQUEST_VARIANCE > 0)"
            End If
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If vntPart <> "" And Not IsDBNull(vntPartKeyID) Then
            '    intCountST = 0
            '    vntTemp = ""
            '    vntPart = Replace(vntPart, "-", "")
            '    If Len(vntPart) < 9 Then
            '        For intCountST = 1 To 9 - Len(vntPart)
            '            vntTemp = "0" & vntTemp
            '        Next
            '        vntPart = vntTemp & vntPart
            '    End If
            '    strSql = strSql & " AND A.Part_Nbr = '" & vntPart & "' "
            strSql = strSql & " AND A.PART_KEY_ID = " & vntPartKeyID
            vntDispCrit = vntDispCrit & " <strong>Part:</strong> " & vntPart & ";"
        End If

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        If vntPlant <> "" Then
            strSql = strSql & " AND (INVENTORY_BUILDING_NBR = '" & vntPlant & "')"
            vntDispCrit = vntDispCrit & " <strong>Plant/Blg:</strong> " & vntPlant & ";"
        End If

        If vntLocation <> "" Then
            strSql = strSql & " AND INVENTORY_LOCATION_CODE = '" & vntLocation & "'"
            vntDispCrit = vntDispCrit & " <strong>Location:</strong> " & vntLocation & ";"
        End If

        If vntacctOrgKey <> "" Then
            strSql = strSql & " AND ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey
        End If

        If vntShipTo <> "" Then
            vntTemp2 = vntShipTo
            intCountST = 0
            vntTemp = ""
            vntShipTo = Replace(vntShipTo, "-", "")
            If Len(vntShipTo) < 10 Then
                For intCountST = 1 To 10 - Len(vntShipTo)
                    vntTemp = "0" & vntTemp
                Next
                vntShipTo = vntTemp & vntShipTo
            End If

            If Len(vntShipTo) > 10 Then
                Err.Raise(901, , "Ship To Number is invalid.  These numbers are required to have 10 characters")
            Else
                strSql = strSql & " AND PURCHASE_BY_ACCOUNT_BASE = '" & Left(vntShipTo, 8) & "'"
                strSql = strSql & " AND SHIP_TO_ACCOUNT_SUFFIX = '" & Right(vntShipTo, 2) & "'"
            End If

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntWWCust <> "" Then
            vntTemp2 = vntWWCust
            intFound = 0
            vntTempWW = ""
            vntTempWW2 = ""
            intCountWW = 0
            intFound = InStr(vntWWCust, "-")

            If intFound <> 0 Then
                vntTempWW = Left(vntWWCust, intFound - 1)
                vntTempWW2 = Right(vntWWCust, Len(vntWWCust) - intFound)
            Else
                If Len(vntWWCust) > 10 Then
                    Err.Raise(901, , "WorldWide Number is invalid.  These numbers are required to have a maximum of 10 characters")
                ElseIf Len(vntWWCust) <= 8 Then
                    vntTempWW = vntWWCust
                ElseIf Len(vntWWCust) = 9 Then
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 1)
                Else
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 2)
                End If
            End If

            If Len(vntTempWW) < 8 Then
                For intCountWW = 1 To 8 - Len(vntTempWW)
                    vntTemp = vntTemp & "0"
                Next
                vntWWCust = vntTemp & vntTempWW
            Else
                vntWWCust = vntTempWW
            End If

            If Len(vntTempWW2) = 1 Then
                vntTempWW2 = "0" & vntTempWW2
                vntWWCust = vntWWCust & vntTempWW2
            Else
                vntWWCust = vntWWCust & vntTempWW2
            End If

            If Len(vntWWCust) > 8 Then
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
                strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
            Else
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
            End If

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntInvOrg <> "" Then
            If InStr(vntInvOrg, ",") > 0 Then
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID IN ( " & QuoteStr(vntInvOrg) & " ) "
            Else
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID " & IIf(InStr(vntInvOrg, "%") > 0, "LIKE '", "= '") & vntInvOrg & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Inv Org/Plant:</strong> " & vntInvOrg & ";"
        End If

        If vntController <> "" Then
            If InStr(vntController, ",") > 0 Then
                strSql = strSql & " AND PRODCN_CNTRLR_CODE IN ( " & QuoteStr(vntController) & " ) "
            Else
                strSql = strSql & " AND PRODCN_CNTRLR_CODE " & IIf(InStr(vntController, "%") > 0, "LIKE '", "= '") & vntController & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Controller:</strong> " & vntController & ";"
        End If

        If vntStkMake <> "" Then
            vntLength = Len(vntStkMake)
            strSql = strSql & " AND substr(STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            vntDispCrit = vntDispCrit & " <strong>Make Stock:</strong> " & vntStkMake & ";"
        End If

        If vntMrpGroupCde <> "" Then
            If InStr(vntMrpGroupCde, ",") > 0 Then
                strSql = strSql & " AND MRP_GROUP_CDE IN ( " & QuoteStr(vntMrpGroupCde) & " ) "
            Else
                strSql = strSql & " AND MRP_GROUP_CDE " & IIf(InStr(vntMrpGroupCde, "%") > 0, "LIKE '", "= '") & vntMrpGroupCde & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>MRP Group:</strong> " & vntMrpGroupCde & ";"
        End If

        If vntTeam <> "" Then
            strSql = strSql & " AND TEAM_CODE = '" & vntTeam & "' "
            vntDispCrit = vntDispCrit & " <strong>Team:</strong> " & vntTeam & ";"
        End If

        If vntProdCde <> "" Then
            strSql = strSql & " AND PRODUCT_CODE = '" & vntProdCde & "' "
            vntDispCrit = vntDispCrit & " <strong>Product Code:</strong> " & vntProdCde & ";"
        End If

        If vntProdLne <> "" Then
            If InStr(vntProdLne, ",") > 0 Then
                strSql = strSql & " AND PRODUCT_LINE_CODE IN ( " & QuoteStr(vntProdLne) & " )"
            Else
                strSql = strSql & " AND PRODUCT_LINE_CODE = '" & vntProdLne & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Product Line:</strong> " & vntProdLne & ";"
        End If

        If vntIBC <> "" Then
            If InStr(vntIBC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE IN ( " & QuoteStr(vntIBC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE = '" & vntIBC & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry Business:</strong> " & vntIBC & ";"
        End If

        If vntIC <> "" Then
            If InStr(vntIC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_CODE IN ( " & QuoteStr(vntIC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_CODE LIKE '" & vntIC & "%'"
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry:</strong> " & vntIC & ";"
        End If

        If vntMfgCampus <> "" Then
            strSql = strSql & " AND MFG_CAMPUS_ID = '" & vntMfgCampus & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Campus:</strong> " & vntMfgCampus & ";"
        End If

        If vntMfgBuilding <> "" Then
            strSql = strSql & " AND MFG_BUILDING_NBR = '" & vntMfgBuilding & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Building:</strong> " & vntMfgBuilding & ";"
        End If

        If vntCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_ID = '" & vntCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Competency Business:</strong> " & vntCBC & ";"
        End If

        If vntSubCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_FNCTN_ID = '" & vntSubCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Sub-Competency Business:</strong> " & vntSubCBC & ";"
        End If

        If vntProfit <> "" Then
            strSql = strSql & " AND PROFIT_CENTER_ABBR_NM = '" & vntProfit & "' "
            vntDispCrit = vntDispCrit & " <strong>Profit Center:</strong> " & vntProfit & ";"
        End If

        If vntSalesOffice <> "" Then
            If InStr(vntSalesOffice, ",") > 0 Then
                strSql = strSql & " AND A.SALES_OFFICE_CDE IN ( " & QuoteStr(vntSalesOffice) & " ) "
            Else
                strSql = strSql & " AND A.SALES_OFFICE_CDE " & IIf(InStr(vntSalesOffice, "%") > 0, "LIKE '", "= '") & vntSalesOffice & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Office:</strong> " & vntSalesOffice & ";"
        End If

        If vntSalesGroup <> "" Then
            If InStr(vntSalesGroup, ",") > 0 Then
                strSql = strSql & " AND A.SALES_GROUP_CDE IN ( " & QuoteStr(vntSalesGroup) & " ) "
            Else
                strSql = strSql & " AND A.SALES_GROUP_CDE " & IIf(InStr(vntSalesGroup, "%") > 0, "LIKE '", "= '") & vntSalesGroup & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Group:</strong> " & vntSalesGroup & ";"
        End If

        If vntSoldTo <> "" Then
            vntTemp2 = vntSoldTo
            intCountST = 0
            vntTemp = ""
            vntSoldTo = Replace(vntSoldTo, "-", "")
            If Len(vntSoldTo) < 8 Then
                For intCountST = 1 To 8 - Len(vntSoldTo)
                    vntTemp = "0" & vntTemp
                Next
                vntSoldTo = vntTemp & vntSoldTo
            End If
            If Len(vntSoldTo) > 8 Then
                Err.Raise(901, , "Sold To Number is invalid.  These numbers are required to have 8 characters")
            Else
                strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
            End If

            blnrc = objGetSoldToName.RetrieveName(vntCustOrg, vntSoldTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetSoldToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntProdMgr <> "" Then
            strSql = strSql & ParseProdMgr(vntProdMgr)
            vntDispCrit = vntDispCrit & " <strong>Product Mgr:</strong> " & vntProdMgr & ";"
        End If

        If GamAccount <> "" Then
            strSql = strSql & " AND G.PB_GBL_ACCT_CDE = '" & GamAccount & "'"
            strSql = strSql & " AND a.SOLD_TO_CUSTOMER_ID =  g.PB_ACCT_NBR_BASE "
            strSql = strSql & "AND A.ACCOUNTING_ORG_KEY_ID = C.ORGANIZATION_KEY_ID"
            vntDispCrit = vntDispCrit & " <strong>GAM Account:</strong> " & GamAccount & ";"
        End If

        If vntViewId = "3" And vntHostOrgID <> "" Then
            strSql = strSql & " AND glod.GLOD_LEGAL_ORG_ID IN ( " & QuoteStr(vntHostOrgID) & " ) "
            strSql = strSql & " AND gp.PROD_HOST_ORG_ID = glod.GLOD_DESCENDENT_LEGAL_ORG_ID "
            strSql = strSql & " AND a.PRODUCT_CODE = gp.PROD_CODE"
            vntDispCrit = vntDispCrit & " <strong>Product Host OrgID:</strong> " & vntHostOrgID & ";"
        End If

        strSql = strSql & " AND a.SHIP_TO_CUSTOMER_KEY_ID = shipto.CUSTOMER_KEY_ID "
        strSql = strSql & " ORDER BY "
        If vntCategoryId = "5" Then
            strSql = strSql & "Part_Number ASC, Days_Late DESC"
        ElseIf vntCategoryId = "6" Then
            strSql = strSql & "Part_Number ASC, computed_comparison_date"
        End If

        objList = objCallRS.CallRS_WithConn(objConnection, strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsResults.ListPstDueOpen call to CallRS for Main Results")
        End If

        If vntCount > 0 Then
            If vntGetTotal = "1" Then
                vntTempArray = objList.GetRows
                intCount = 0
                For intCount = 0 To UBound(vntTempArray, 2)
                    vntTBRTotal = vntTBRTotal + CDbl(vntTempArray(22, intCount))
                    vntExtTotal = vntExtTotal + CDbl(vntTempArray(15, intCount))
                    vntLocalTotal = vntLocalTotal + CDbl(vntTempArray(16, intCount))
                Next
                vntTBRTotal = VB6.Format(vntTBRTotal, "$#,####,##0.00")
                vntExtTotal = VB6.Format(vntExtTotal, "$#,####,##0.00")
                vntLocalTotal = VB6.Format(vntLocalTotal, "#,####,##0.00")
            End If
            
            If vntExport = "1" Then 'This would be true, process entire recordset
                'If vntCategoryId = "5" Then
                '    
                '    objList.Sort = "Part_Number ASC, Days_Late DESC"
                '    
                'ElseIf vntCategoryId = "6" Then
                '    
                '    objList.Sort = "Part_Number ASC, computed_comparison_date"
                'End If
                objList.MoveFirst()
                ListPstDueOpen = objList.GetRows
            Else
                'If vntCategoryId = "5" Then
                '    
                '    objList.Sort = "Part_Number ASC, Days_Late DESC"
                '    
                'ElseIf vntCategoryId = "6" Then
                '    
                '    objList.Sort = "Part_Number ASC, computed_comparison_date"
                'End If
                objList.PageSize = 100
                objList.AbsolutePage = CInt(vntPage)

                If vntCount > 100 Then
                    intRecsLeft = CInt(vntCount) - (CInt(vntPage - 1) * 100)
                    If intRecsLeft < 0 Then
                        intRecsLeft = CInt(vntCount) - (CInt(vntPage - 1) * 100)
                    End If
                    If intRecsLeft >= 100 Then
                        intPageCount = 100
                    Else
                        intPageCount = intRecsLeft
                    End If
                Else
                    intPageCount = vntCount
                End If
                
                vntRecsLeft = intRecsLeft
                
                ReDim vntArray(CInt(intPageCount) - 1, objList.Fields.Count)
                intCount = 0
                Do Until intCount = intPageCount
                    vntArray(intCount, 0) = objList.Fields.Item("ILC").Value
                    vntArray(intCount, 1) = objList.Fields.Item("Part_Number").Value
                    vntArray(intCount, 2) = objList.Fields.Item("AON").Value
                    vntArray(intCount, 3) = objList.Fields.Item("PCC").Value
                    vntArray(intCount, 4) = VB6.Format(objList.Fields.Item("RemainQty").Value, "#,###")

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("RD").Value) Then
                        vntArray(intCount, 5) = "&nbsp;"
                    ElseIf objList.Fields.Item("RD").Value = "0001-01-01" Then
                        vntArray(intCount, 5) = "9999-99-99"
                    Else
                        vntArray(intCount, 5) = objList.Fields.Item("RD").Value
                    End If

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("ReqDate").Value) Then
                        vntArray(intCount, 6) = "&nbsp;"
                    ElseIf objList.Fields.Item("ReqDate").Value = "0001-01-01" Then
                        vntArray(intCount, 6) = "9999-99-99"
                    Else
                        vntArray(intCount, 6) = objList.Fields.Item("ReqDate").Value
                    End If

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("computed_comparison_date").Value) Then
                        vntArray(intCount, 7) = "&nbsp;"
                    ElseIf objList.Fields.Item("computed_comparison_date").Value = "0001-01-01" Then
                        vntArray(intCount, 7) = "9999-99-99"
                    Else
                        vntArray(intCount, 7) = objList.Fields.Item("computed_comparison_date").Value
                    End If

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("Reserve_Level").Value) Then
                        vntArray(intCount, 8) = "&nbsp;"
                    Else
                        vntArray(intCount, 8) = objList.Fields.Item("Reserve_Level").Value
                    End If

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("THI").Value) Then
                        vntArray(intCount, 9) = "&nbsp;"
                    Else
                        vntArray(intCount, 9) = objList.Fields.Item("THI").Value
                    End If

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("Days_Late").Value) Then
                        vntArray(intCount, 10) = "&nbsp;"
                    Else
                        vntArray(intCount, 10) = objList.Fields.Item("Days_Late").Value
                    End If

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("CTC").Value) Then
                        vntArray(intCount, 11) = "&nbsp;"
                    Else
                        vntArray(intCount, 11) = objList.Fields.Item("CTC").Value
                    End If

                    vntArray(intCount, 12) = objList.Fields.Item("Doc_Ind").Value
                    vntArray(intCount, 13) = objList.Fields.Item("OIN").Value
                    vntArray(intCount, 14) = objList.Fields.Item("SI").Value
                    vntArray(intCount, 15) = VB6.Format(objList.Fields.Item("EBBA").Value, "$#,###.00")
                    vntArray(intCount, 16) = objList.Fields.Item("LCBA").Value
                    vntArray(intCount, 17) = objList.Fields.Item("part_desc").Value
                    vntArray(intCount, 18) = objList.Fields.Item("customer_account_nbr").Value
                    vntArray(intCount, 19) = objList.Fields.Item("OrgID").Value
                    vntArray(intCount, 20) = objList.Fields.Item("ICC").Value

                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(objList.Fields.Item("ORD").Value) Then
                        vntArray(intCount, 21) = "&nbsp;"
                    ElseIf objList.Fields.Item("ORD").Value = "0001-01-01" Then
                        vntArray(intCount, 21) = "9999-99-99"
                    Else
                        vntArray(intCount, 21) = objList.Fields.Item("ORD").Value
                    End If

                    vntArray(intCount, 22) = VB6.Format(objList.Fields.Item("TBRAmount").Value, "$#,###.00")
                    vntArray(intCount, 23) = objList.Fields.Item("ProdMgrName").Value
                    vntArray(intCount, 24) = VB6.Format(objList.Fields.Item("ItemQty").Value, "#,###")
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 25) = IIf(IsDBNull(objList.Fields.Item("CustPart").Value), "&nbsp;", objList.Fields.Item("CustPart").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 26) = IIf(IsDBNull(objList.Fields.Item("PONbr").Value), "&nbsp;", objList.Fields.Item("PONbr").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 27) = IIf(IsDBNull(objList.Fields.Item("PODate").Value), "&nbsp;", objList.Fields.Item("PODate").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 28) = IIf(IsDBNull(objList.Fields.Item("PPSOC").Value), "&nbsp;", objList.Fields.Item("PPSOC").Value)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    vntArray(intCount, 29) = IIf(IsDBNull(objList.Fields.Item("SbmtPart").Value), "&nbsp;", objList.Fields.Item("SbmtPart").Value)
                    vntArray(intCount, 30) = IIf(IsDBNull(objList.Fields.Item("ShiptoNm").Value), "&nbsp;", objList.Fields.Item("ShiptoNm").Value)

                    objList.MoveNext()
                    intCount = intCount + 1
                Loop

                ListPstDueOpen = vntArray
            End If
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListPstDueOpen = System.DBNull.Value
        End If

        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If
        objConnection = Nothing
        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        Exit Function

ErrorHandler:
        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If
        objConnection = Nothing
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListPstDueOpen = System.DBNull.Value
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        Exit Function
    End Function
	
	'##ModelId=3A8BF5660022
	Public Function ListLead(ByVal vntSessionID As Object, ByRef vntCustPercent As Object, ByRef vntAmpPercent As Object, ByRef vntCustCumu As Object, ByRef vntAmpCumu As Object, ByRef vntCount As Object, ByRef vntLeadTimeType As Object, ByRef vntDispCrit As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim objSearch As New clsSearch
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
		Dim vntArray As Object
        '      Dim intPageCount As Integer
        '      Dim intRecsLeft As Integer
        '      Dim intCount As Integer
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntWindowId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntSmryType As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgID As Object
        'Dim vntDaysEarly As Object
        'Dim vntDaysLate As Object
        'Dim vntMonthDailyInd As Object
        'Dim vntCustAcctTypeCde As Object
        'Dim vntPart As Object
        'Dim vntPlant As Object
        'Dim vntLocation As Object
        'Dim vntacctOrgKey As Object
        'Dim vntShipTo As Object
        'Dim vntSoldTo As Object
        'Dim vntWWCust As Object
        'Dim vntInvOrg As Object
        'Dim vntController As Object
        'Dim vntCntlrEmpNbr As Object
        'Dim vntStkMake As Object
        'Dim vntTeam As Object
        'Dim vntProdCde As Object
        'Dim vntProdLne As Object
        'Dim vntIBC As Object
        'Dim vntIC As Object
        'Dim vntMfgCampus As Object
        'Dim vntMfgBuilding As Object
        'Dim vntComparisonType As Object
        'Dim vntOpenShpOrder As Object
        'Dim vntProfit As Object
        'Dim vntCBC As Object
        'Dim vntSubCBC As Object
        'Dim vntOrgDate As Object
        'Dim vntLevel As Object
        'Dim vntKeyId As Object
        'Dim vntTempArray As Object
        'Dim vntOrgType As Object
        'Dim vntLength As Object
        'Dim vntOrgTypeDesc As Object
        'Dim intCountST As Short
        'Dim vntTemp As Object
        'Dim vntTempWW As Object
        'Dim vntTempWW2 As Object
        'Dim intCountWW As Short
        'Dim intFound As Short
        '      Dim objGetWWName As New clsWrldWide
        '      Dim objGetShipToName As New clsShipTo
        '      Dim objGetSoldToName As New clsSoldTo
        '      Dim vntName As Object
        'Dim vntTemp2 As Object
        'Dim vntCustOrg As Object
        'Dim vntProdMgr As Object
        'Dim vntSalesOffice As Object
        'Dim vntSalesGroup As Object
        'Dim vntMfgOrgType As Object
        'Dim vntMfgOrgId As Object
        'Dim GamAccount As Object
        'Dim vntPartKeyID As Object
        'Dim vntMrpGroupCde As Object
        'Dim vntHostOrgID As Object
        Dim intPageCount As Integer
        Dim intRecsLeft As Integer
        Dim intCount As Integer
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntWindowId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
        Dim vntSmryType As String = ""
        Dim vntCurrentHist As String = ""
        Dim vntOrgID As String = ""
        Dim vntOrgKeyId As String = ""
        Dim vntDaysEarly As String = ""
        Dim vntDaysLate As String = ""
        Dim vntMonthDailyInd As String = ""
        Dim vntCustAcctTypeCde As String = ""
        Dim vntPart As String = ""
        Dim vntPlant As String = ""
        Dim vntLocation As String = ""
        Dim vntacctOrgKey As String = ""
        Dim vntShipTo As String = ""
        Dim vntSoldTo As String = ""
        Dim vntWWCust As String = ""
        Dim vntInvOrg As String = ""
        Dim vntController As String = ""
        Dim vntCntlrEmpNbr As String = ""
        Dim vntStkMake As String = ""
        Dim vntTeam As String = ""
        Dim vntProdCde As String = ""
        Dim vntProdLne As String = ""
        Dim vntIBC As String = ""
        Dim vntIC As String = ""
        Dim vntMfgCampus As String = ""
        Dim vntMfgBuilding As String = ""
        Dim vntComparisonType As String = ""
        Dim vntOpenShpOrder As String = ""
        Dim vntProfit As String = ""
        Dim vntCBC As String = ""
        Dim vntSubCBC As String = ""
        Dim vntOrgDate As String = ""
        Dim vntLevel As String = ""
        Dim vntKeyId As Long
        Dim vntTempArray As Object
        Dim vntOrgType As String = ""
        Dim vntLength As Integer
        Dim vntOrgTypeDesc As String = ""
        Dim intCountST As Integer
        Dim vntTemp As String = ""
        Dim vntTempWW As String = ""
        Dim vntTempWW2 As String = ""
        Dim intCountWW As Integer
        Dim intFound As Integer
        Dim objGetWWName As New clsWrldWide
        Dim objGetShipToName As New clsShipTo
        Dim objGetSoldToName As New clsSoldTo
        Dim vntName As String = ""
        Dim vntTemp2 As String = ""
        Dim vntCustOrg As String = ""
        Dim vntProdMgr As String = ""
        'Dim vntLeadTimeType As String = ""
        Dim vntSalesOffice As String = ""
        Dim vntSalesGroup As String = ""
        Dim vntMfgOrgType As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgLevel As String = ""
        Dim GamAccount As String = ""
        Dim vntPartKeyID As String = ""
        Dim vntMrpGroupCde As String = ""
        Dim vntHostOrgID As String = ""

		On Error GoTo ErrorHandler
		
        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResults.ListConfNonConf")
        End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDate, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNumber, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsSearch.RetrieveSession")
        End If

        If vntOrgID <> "" Then
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If
            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"
            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDate, vntLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel")
            End If
            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org ID:</strong> " & vntacctOrgKey & ";"
            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDate, vntKeyId, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If
            vntacctOrgKey = vntKeyId
        End If

        If vntLeadTimeType = "1" Then
            strSql = " SELECT /*+ INDEX(A) */ NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, -999), LEAST(RECEIVED_TO_REQUEST_VARIANCE, -1),1)), 0) CUST_LT_ABN, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 0, 1)), 0) CUST_LT_0, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 1, 1)), 0) CUST_LT_1, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 2, 1)), 0) CUST_LT_2, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 3, 1)), 0) CUST_LT_3, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 4, 1)), 0) CUST_LT_4, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 5, 1)), 0) CUST_LT_5, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 6, 1)), 0) CUST_LT_6, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 7, 1)), 0) CUST_LT_7, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 8, 1)), 0) CUST_LT_8, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 9, 1)), 0) CUST_LT_9, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_REQUEST_VARIANCE, 10, 1)), 0) CUST_LT_10, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 11), LEAST(RECEIVED_TO_REQUEST_VARIANCE, 20),1)), 0) CUST_LT_11, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 21), LEAST(RECEIVED_TO_REQUEST_VARIANCE, 30),1)), 0) CUST_LT_12, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 31), LEAST(RECEIVED_TO_REQUEST_VARIANCE, 40),1)), 0) CUST_LT_13, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 41), LEAST(RECEIVED_TO_REQUEST_VARIANCE, 50),1)), 0) CUST_LT_14, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 51), LEAST(RECEIVED_TO_REQUEST_VARIANCE, 60),1)), 0) CUST_LT_15, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 61), LEAST(RECEIVED_TO_REQUEST_VARIANCE, 70),1)), 0) CUST_LT_16, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 71), LEAST(RECEIVED_TO_REQUEST_VARIANCE, 80),1)), 0) CUST_LT_17, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 81), LEAST(RECEIVED_TO_REQUEST_VARIANCE, 90),1)), 0) CUST_LT_18, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 91), LEAST(RECEIVED_TO_REQUEST_VARIANCE, 100),1)), 0) CUST_LT_19, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_REQUEST_VARIANCE, 101), LEAST(RECEIVeD_TO_REQUEST_VARIANCE, 999),1)), 0) CUST_LT_20, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, -999), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, -1),1)), 0) AMP_LT_ABN, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 0, 1)), 0) AMP_LT_0, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 1, 1)), 0) AMP_LT_1, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 2, 1)), 0) AMP_LT_2, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 3, 1)), 0) AMP_LT_3, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 4, 1)), 0) AMP_LT_4, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 5, 1)), 0) AMP_LT_5, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 6, 1)), 0) AMP_LT_6, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 7, 1)), 0) AMP_LT_7, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 8, 1)), 0) AMP_LT_8, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 9, 1)), 0) AMP_LT_9, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SCHEDULE_VARIANCE, 10, 1)), 0) AMP_LT_10, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 11), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 20),1)), 0) AMP_LT_11, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 21), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 30),1)), 0) AMP_LT_12, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 31), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 40),1)), 0) AMP_LT_13, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 41), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 50),1)), 0) AMP_LT_14, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 51), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 60),1)), 0) AMP_LT_15, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 61), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 70),1)), 0) AMP_LT_16, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 71), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 80),1)), 0) AMP_LT_17, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 81), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 90),1)), 0) AMP_LT_18, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 91), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 100),1)), 0) AMP_LT_19, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SCHEDULE_VARIANCE, 101), LEAST(RECEIVED_TO_SCHEDULE_VARIANCE, 999),1)), 0) AMP_LT_20, "
        Else
            strSql = " SELECT /*+ INDEX(A) */ NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, -999), LEAST(RECEIVED_TO_SHIP_VARIANCE, -1),1)), 0) CUST_LT_ABN, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 0, 1)), 0) CUST_LT_0, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 1, 1)), 0) CUST_LT_1, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 2, 1)), 0) CUST_LT_2, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 3, 1)), 0) CUST_LT_3, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 4, 1)), 0) CUST_LT_4, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 5, 1)), 0) CUST_LT_5, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 6, 1)), 0) CUST_LT_6, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 7, 1)), 0) CUST_LT_7, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 8, 1)), 0) CUST_LT_8, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 9, 1)), 0) CUST_LT_9, "
            strSql = strSql & " NVL(SUM(DECODE(RECEIVED_TO_SHIP_VARIANCE, 10, 1)), 0) CUST_LT_10, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 11), LEAST(RECEIVED_TO_SHIP_VARIANCE, 20),1)), 0) CUST_LT_11, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 21), LEAST(RECEIVED_TO_SHIP_VARIANCE, 30),1)), 0) CUST_LT_12, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 31), LEAST(RECEIVED_TO_SHIP_VARIANCE, 40),1)), 0) CUST_LT_13, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 41), LEAST(RECEIVED_TO_SHIP_VARIANCE, 50),1)), 0) CUST_LT_14, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 51), LEAST(RECEIVED_TO_SHIP_VARIANCE, 60),1)), 0) CUST_LT_15, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 61), LEAST(RECEIVED_TO_SHIP_VARIANCE, 70),1)), 0) CUST_LT_16, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 71), LEAST(RECEIVED_TO_SHIP_VARIANCE, 80),1)), 0) CUST_LT_17, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 81), LEAST(RECEIVED_TO_SHIP_VARIANCE, 90),1)), 0) CUST_LT_18, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 91), LEAST(RECEIVED_TO_SHIP_VARIANCE, 100),1)), 0) CUST_LT_19, "
            strSql = strSql & " NVL(SUM(DECODE(GREATEST(RECEIVED_TO_SHIP_VARIANCE, 101), LEAST(RECEIVeD_TO_SHIP_VARIANCE, 999),1)), 0) CUST_LT_20, "
            strSql = strSql & " 0 AMP_LT_ABN, "
            strSql = strSql & " 0 AMP_LT_0, "
            strSql = strSql & " 0 AMP_LT_1, "
            strSql = strSql & " 0 AMP_LT_2, "
            strSql = strSql & " 0 AMP_LT_3, "
            strSql = strSql & " 0 AMP_LT_4, "
            strSql = strSql & " 0 AMP_LT_5, "
            strSql = strSql & " 0 AMP_LT_6, "
            strSql = strSql & " 0 AMP_LT_7, "
            strSql = strSql & " 0 AMP_LT_8, "
            strSql = strSql & " 0 AMP_LT_9, "
            strSql = strSql & " 0 AMP_LT_10, "
            strSql = strSql & " 0 AMP_LT_11, "
            strSql = strSql & " 0 AMP_LT_12, "
            strSql = strSql & " 0 AMP_LT_13, "
            strSql = strSql & " 0 AMP_LT_14, "
            strSql = strSql & " 0 AMP_LT_15, "
            strSql = strSql & " 0 AMP_LT_16, "
            strSql = strSql & " 0 AMP_LT_17, "
            strSql = strSql & " 0 AMP_LT_18, "
            strSql = strSql & " 0 AMP_LT_19, "
            strSql = strSql & " 0 AMP_LT_20, "
        End If
        
        strSql = strSql & " COUNT(*) Total "

        If vntOpenShpOrder = "1" Or vntLeadTimeType = "2" Then
            strSql = strSql & " FROM ORDER_ITEM_SHIPMENT A "
            vntDispCrit = vntDispCrit & " <strong>Status:</strong> Shipped;"
        Else
            strSql = strSql & " FROM ORDER_ITEM_OPEN A "
            vntDispCrit = vntDispCrit & " <strong>Status:</strong> Open;"
        End If

        If vntOrgID <> "" Then
            strSql = strSql & ", ORGANIZATIONS_DMN C "
        End If

        If vntViewId = "3" And vntHostOrgID <> "" Then
            strSql = strSql & ", GBL_PRODUCT gp "
            strSql = strSql & ", GBL_LEGAL_ORG_DESCENDENTS glod "
        End If

        If vntLeadTimeType = "1" Then
            strSql = strSql & " WHERE ORDER_RECEIVED_DATE "
        Else
            strSql = strSql & " WHERE AMP_SHIPPED_DATE "
        End If

        strSql = strSql & " BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"

        vntDispCrit = vntDispCrit & " <strong>" & IIf(vntLeadTimeType = "1", "Received", "Shipped")

        vntDispCrit = vntDispCrit & " Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"
        
        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        If vntOrgID <> "" Then

            strSql = strSql & " AND  C.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID "
            
            If vntCurrentHist <> "" Then
                If vntCurrentHist = "C" Then
                    strSql = strSql & " AND RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                    vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
                Else
                    'strSql = strSql & " AND RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                    vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                    vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
                    'strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntEndDt & "', 'YYYY-MM-DD')"
                    'strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntEndDt & "', 'YYYY-MM-DD'))"
                End If
            Else
                strSql = strSql & " AND RECORD_STATUS_CDE = 'C' "
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
            End If
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If vntPart <> "" And Not IsDBNull(vntPartKeyID) Then
            '    intCountST = 0
            '    vntTemp = ""
            '    vntPart = Replace(vntPart, "-", "")
            '    If Len(vntPart) < 9 Then
            '        For intCountST = 1 To 9 - Len(vntPart)
            '            vntTemp = "0" & vntTemp
            '        Next
            '        vntPart = vntTemp & vntPart
            '    End If
            '    strSql = strSql & " AND A.Part_Nbr = '" & vntPart & "' "
            strSql = strSql & " AND A.PART_KEY_ID = " & vntPartKeyID
            vntDispCrit = vntDispCrit & " <strong>Part:</strong> " & vntPart & ";"
        End If

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        'If vntPlant <> "" Then
        '    strSql = strSql & " AND (INVENTORY_BUILDING_NBR = '" & vntPlant & "')"
        'End If

        'If vntLocation <> "" Then
        '    strSql = strSql & " AND INVENTORY_LOCATION_CODE = '" & vntLocation & "'"
        'End If

        If vntacctOrgKey <> "" Then
            strSql = strSql & " AND ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey
        End If

        If vntShipTo <> "" Then
            vntTemp2 = vntShipTo
            intCountST = 0
            vntTemp = ""
            vntShipTo = Replace(vntShipTo, "-", "")
            If Len(vntShipTo) < 10 Then
                For intCountST = 1 To 10 - Len(vntShipTo)
                    vntTemp = "0" & vntTemp
                Next
                vntShipTo = vntTemp & vntShipTo
            End If

            If Len(vntShipTo) > 10 Then
                Err.Raise(901, , "Ship To Number is invalid.  These numbers are required to have 10 characters")
            Else
                strSql = strSql & " AND PURCHASE_BY_ACCOUNT_BASE = '" & Left(vntShipTo, 8) & "'"
                strSql = strSql & " AND SHIP_TO_ACCOUNT_SUFFIX = '" & Right(vntShipTo, 2) & "'"
            End If

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntWWCust <> "" Then
            vntTemp2 = vntWWCust
            intFound = 0
            vntTempWW = ""
            vntTempWW2 = ""
            intCountWW = 0
            intFound = InStr(vntWWCust, "-")

            If intFound <> 0 Then
                vntTempWW = Left(vntWWCust, intFound - 1)
                vntTempWW2 = Right(vntWWCust, Len(vntWWCust) - intFound)
            Else
                If Len(vntWWCust) > 10 Then
                    Err.Raise(901, , "WorldWide Number is invalid.  These numbers are required to have a maximum of 10 characters")
                ElseIf Len(vntWWCust) <= 8 Then
                    vntTempWW = vntWWCust
                ElseIf Len(vntWWCust) = 9 Then
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 1)
                Else
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 2)
                End If
            End If

            If Len(vntTempWW) < 8 Then
                For intCountWW = 1 To 8 - Len(vntTempWW)
                    vntTemp = vntTemp & "0"
                Next
                vntWWCust = vntTemp & vntTempWW
            Else
                vntWWCust = vntTempWW
            End If

            If Len(vntTempWW2) = 1 Then
                vntTempWW2 = "0" & vntTempWW2
                vntWWCust = vntWWCust & vntTempWW2
            Else
                vntWWCust = vntWWCust & vntTempWW2
            End If

            If Len(vntWWCust) > 8 Then
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
                strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
            Else
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
            End If

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        'If vntWWCust <> "" Then
        '    If Len(vntWWCust) > 8 Then
        '        strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
        '        strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
        '    Else
        '        strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
        '    End If
        '    vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntWWCust & ";"
        'End If

        If vntInvOrg <> "" Then
            If InStr(vntInvOrg, ",") > 0 Then
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID IN ( " & QuoteStr(vntInvOrg) & " ) "
            Else
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID " & IIf(InStr(vntInvOrg, "%") > 0, "LIKE '", "= '") & vntInvOrg & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Inv Org/Plant:</strong> " & vntInvOrg & ";"
        End If

        If vntController <> "" Then
            If InStr(vntController, ",") > 0 Then
                strSql = strSql & " AND PRODCN_CNTRLR_CODE IN ( " & QuoteStr(vntController) & " ) "
            Else
                strSql = strSql & " AND PRODCN_CNTRLR_CODE " & IIf(InStr(vntController, "%") > 0, "LIKE '", "= '") & vntController & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Controller:</strong> " & vntController & ";"
        End If

        If vntStkMake <> "" Then
            vntLength = Len(vntStkMake)
            strSql = strSql & " AND substr(STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            vntDispCrit = vntDispCrit & " <strong>Make Stock:</strong> " & vntStkMake & ";"
        End If

        If vntMrpGroupCde <> "" Then
            If InStr(vntMrpGroupCde, ",") > 0 Then
                strSql = strSql & " AND MRP_GROUP_CDE IN ( " & QuoteStr(vntMrpGroupCde) & " ) "
            Else
                strSql = strSql & " AND MRP_GROUP_CDE " & IIf(InStr(vntMrpGroupCde, "%") > 0, "LIKE '", "= '") & vntMrpGroupCde & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>MRP Group:</strong> " & vntMrpGroupCde & ";"
        End If

        If vntTeam <> "" Then
            strSql = strSql & " AND TEAM_CODE = '" & vntTeam & "' "
            vntDispCrit = vntDispCrit & " <strong>Team:</strong> " & vntTeam & ";"
        End If

        If vntProdCde <> "" Then
            strSql = strSql & " AND PRODUCT_CODE = '" & vntProdCde & "' "
            vntDispCrit = vntDispCrit & " <strong>Product Code:</strong> " & vntProdCde & ";"
        End If

        If vntProdLne <> "" Then
            If InStr(vntProdLne, ",") > 0 Then
                strSql = strSql & " AND PRODUCT_LINE_CODE IN ( " & QuoteStr(vntProdLne) & " )"
            Else
                strSql = strSql & " AND PRODUCT_LINE_CODE = '" & vntProdLne & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Product Line:</strong> " & vntProdLne & ";"
        End If

        If vntIBC <> "" Then
            If InStr(vntIBC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE IN ( " & QuoteStr(vntIBC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE = '" & vntIBC & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry Business:</strong> " & vntIBC & ";"
        End If

        If vntIC <> "" Then
            If InStr(vntIC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_CODE IN ( " & QuoteStr(vntIC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_CODE LIKE '" & vntIC & "%' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry:</strong> " & vntIC & ";"
        End If

        If vntCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_ID = '" & vntCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Competency Business:</strong> " & vntCBC & ";"
        End If

        If vntSubCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_FNCTN_ID = '" & vntSubCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Sub-Competency Business:</strong> " & vntSubCBC & ";"
        End If

        If vntProfit <> "" Then
            strSql = strSql & " AND PROFIT_CENTER_ABBR_NM = '" & vntProfit & "' "
            vntDispCrit = vntDispCrit & " <strong>Profit Center:</strong> " & vntProfit & ";"
        End If

        'If vntSoldTo <> "" Then
        '    intCountST = 0
        '    vntTemp = ""
        '    vntSoldTo = Replace(vntSoldTo, "-", "")
        '    If Len(vntSoldTo) < 8 Then
        '        For intCountST = 1 To 8 - Len(vntSoldTo)
        '            vntTemp = "0" & vntTemp
        '        Next
        '        vntSoldTo = vntTemp & vntSoldTo
        '    End If
        '    If Len(vntSoldTo) > 8 Then
        '        Err.Raise 901, , "Sold To Number is invalid.  These numbers are required to have 8 characters"
        '    Else
        '        strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
        '    End If
        '    vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntSoldTo & ";"
        'End If

        If vntSoldTo <> "" Then
            vntTemp2 = vntSoldTo
            intCountST = 0
            vntTemp = ""
            vntSoldTo = Replace(vntSoldTo, "-", "")
            If Len(vntSoldTo) < 8 Then
                For intCountST = 1 To 8 - Len(vntSoldTo)
                    vntTemp = "0" & vntTemp
                Next
                vntSoldTo = vntTemp & vntSoldTo
            End If
            If Len(vntSoldTo) > 8 Then
                Err.Raise(901, , "Sold To Number is invalid.  These numbers are required to have 8 characters")
            Else
                strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
            End If

            blnrc = objGetSoldToName.RetrieveName(vntCustOrg, vntSoldTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetSoldToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        'If vntMfgCampus <> "" Then
        '    strSql = strSql & " AND MFG_CAMPUS_ID = '" & vntMfgCampus & "' "
        'End If
        '
        'If vntMfgBuilding <> "" Then
        '    strSql = strSql & " AND MFG_BUILDING_NBR = '" & vntMfgBuilding & "' "
        'End If

        If vntViewId = "3" And vntHostOrgID <> "" Then
            strSql = strSql & " AND glod.GLOD_LEGAL_ORG_ID IN ( " & QuoteStr(vntHostOrgID) & " ) "
            strSql = strSql & " AND gp.PROD_HOST_ORG_ID = glod.GLOD_DESCENDENT_LEGAL_ORG_ID "
            strSql = strSql & " AND a.PRODUCT_CODE = gp.PROD_CODE"
            vntDispCrit = vntDispCrit & " <strong>Product Host OrgID:</strong> " & vntHostOrgID & ";"
        End If

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)
        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsResults.ListLead call to CallRS for Main Results")
        End If

        If vntCount > 0 Then
            vntArray = objList
            'ReDim vntCustPercent(objList.Fields.Count - 1, 0)
            ReDim vntCustPercent(UBound(objList, 1) - 1, 0)
            'ReDim vntAmpPercent(objList.Fields.Count - 1, 0)
            ReDim vntAmpPercent(UBound(objList, 1) - 1, 0)
            'ReDim vntCustCumu(objList.Fields.Count - 1, 0)
            ReDim vntCustCumu(UBound(objList, 1) - 1, 0)
            'ReDim vntAmpCumu(objList.Fields.Count - 1, 0)
            ReDim vntAmpCumu(UBound(objList, 1) - 1, 0)
            
            If vntArray(44, 0) > 0 Then
                'Get the Customer Lead Time Percents
                vntCustPercent(0, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(0, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(1, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(1, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(2, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(2, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(3, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(3, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(4, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(4, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(5, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(5, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(6, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(6, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(7, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(7, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(8, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(8, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(9, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(9, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(10, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(10, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(11, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(11, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(12, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(12, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(13, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(13, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(14, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(14, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(15, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(15, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(16, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(16, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(17, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(17, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(18, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(18, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(19, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(19, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(20, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(20, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustPercent(21, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(21, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")

                'Get the Amp Lead Time Percents
                If vntLeadTimeType = "1" Then 'for amp/tyco percent only if
                    vntAmpPercent(0, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(22, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(1, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(23, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(2, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(24, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(3, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(25, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(4, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(26, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(5, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(27, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(6, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(28, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(7, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(29, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(8, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(30, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(9, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(31, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(10, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(32, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(11, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(33, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(12, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(34, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(13, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(35, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(14, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(36, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(15, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(37, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(16, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(38, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(17, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(39, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(18, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(40, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(19, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(41, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(20, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(42, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpPercent(21, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(42, 0)) / CDbl(vntArray(44, 0)), 3), "0.0%")
                End If 'for amp/tyco percent only endif

                'Get the cumulative for customer
                vntCustCumu(0, 0) = vntCustPercent(0, 0)
                vntCustCumu(1, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(2, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(3, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(4, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(5, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(6, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(7, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(8, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(9, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(10, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(11, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(12, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(13, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(13, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(14, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(13, 0)) + CDbl(vntArray(14, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(15, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(13, 0)) + CDbl(vntArray(14, 0)) + CDbl(vntArray(15, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(16, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(13, 0)) + CDbl(vntArray(14, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(16, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(17, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(13, 0)) + CDbl(vntArray(14, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(17, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(18, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(13, 0)) + CDbl(vntArray(14, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(18, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(19, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(13, 0)) + CDbl(vntArray(14, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(19, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(20, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(13, 0)) + CDbl(vntArray(14, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(20, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                vntCustCumu(21, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(6, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(13, 0)) + CDbl(vntArray(14, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(20, 0)) + CDbl(vntArray(21, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                
                If vntLeadTimeType = "1" Then 'amp/tyco cumu only if
                    'Get the cumulative for AMP, Tyco, whatever....
                    vntAmpCumu(0, 0) = vntAmpPercent(0, 0)
                    vntAmpCumu(1, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(2, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(3, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(4, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(5, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(6, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(7, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(8, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(9, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(10, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(11, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(12, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(13, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0)) + CDbl(vntArray(35, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(14, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0)) + CDbl(vntArray(35, 0)) + CDbl(vntArray(36, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(15, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0)) + CDbl(vntArray(35, 0)) + CDbl(vntArray(36, 0)) + CDbl(vntArray(37, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(16, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0)) + CDbl(vntArray(35, 0)) + CDbl(vntArray(36, 0)) + CDbl(vntArray(37, 0)) + CDbl(vntArray(38, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(17, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0)) + CDbl(vntArray(35, 0)) + CDbl(vntArray(36, 0)) + CDbl(vntArray(37, 0)) + CDbl(vntArray(38, 0)) + CDbl(vntArray(39, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(18, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0)) + CDbl(vntArray(35, 0)) + CDbl(vntArray(36, 0)) + CDbl(vntArray(37, 0)) + CDbl(vntArray(38, 0)) + CDbl(vntArray(39, 0)) + CDbl(vntArray(40, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(19, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0)) + CDbl(vntArray(35, 0)) + CDbl(vntArray(36, 0)) + CDbl(vntArray(37, 0)) + CDbl(vntArray(38, 0)) + CDbl(vntArray(39, 0)) + CDbl(vntArray(40, 0)) + CDbl(vntArray(41, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(20, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0)) + CDbl(vntArray(35, 0)) + CDbl(vntArray(36, 0)) + CDbl(vntArray(37, 0)) + CDbl(vntArray(38, 0)) + CDbl(vntArray(39, 0)) + CDbl(vntArray(40, 0)) + CDbl(vntArray(41, 0)) + CDbl(vntArray(42, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                    vntAmpCumu(21, 0) = VB6.Format(System.Math.Round((CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)) + CDbl(vntArray(27, 0)) + CDbl(vntArray(28, 0)) + CDbl(vntArray(29, 0)) + CDbl(vntArray(30, 0)) + CDbl(vntArray(31, 0)) + CDbl(vntArray(32, 0)) + CDbl(vntArray(33, 0)) + CDbl(vntArray(34, 0)) + CDbl(vntArray(35, 0)) + CDbl(vntArray(36, 0)) + CDbl(vntArray(37, 0)) + CDbl(vntArray(38, 0)) + CDbl(vntArray(39, 0)) + CDbl(vntArray(40, 0)) + CDbl(vntArray(41, 0)) + CDbl(vntArray(42, 0)) + CDbl(vntArray(43, 0))) / CDbl(vntArray(44, 0)), 3), "0.0%")
                End If 'amp/tyco cumu only endif

                ListLead = vntArray
            Else
                'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                ListLead = System.DBNull.Value
            End If
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListLead = System.DBNull.Value
        End If
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListLead = System.DBNull.Value
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        Exit Function
    End Function
	
	'##ModelId=3A929D5F02FE
	Protected Overrides Sub Activate()
		
		'UPGRADE_ISSUE: COMSVCSLib.AppServer  .GetObjectContext was not upgraded. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="CC4C7EC0-C903-48FC-ACCC-81861D12DA4A"'
        'ObjContext = GetObjectContext
		
	End Sub
	
	'##ModelId=3A929EB40055
	Protected Overrides Function CanBePooled() As Boolean
		
		CanBePooled = bPoolSetting
		
	End Function
	
	'##ModelId=3A92A18C03D4
	Protected Overrides Sub Deactivate()
		
		'UPGRADE_NOTE: Object ObjContext may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
		ObjContext = Nothing
	End Sub
	
	'##ModelId=3AC1DBB200F4
	Public Function ListSummMnthly(ByVal vntSessionID As Object, ByRef vntSumLate As Object, ByRef vntSumEarly As Object, ByRef vntSumEarlyPercnt As Object, ByRef vntSumLatePercnt As Object, ByRef vntOnTime As Object, ByRef vntCenter1 As Object, ByRef vntCenter3 As Object, ByRef vntCenter4 As Object, ByRef vntCenter5 As Object, ByRef vntCenter6 As Object, ByRef vntCenter7 As Object, ByRef vntCenter8 As Object, ByRef vnt6Early As Object, ByRef vnt5Early As Object, ByRef vnt4Early As Object, ByRef vnt3Early As Object, ByRef vnt2Early As Object, ByRef vnt1Early As Object, ByRef vnt1Late As Object, ByRef vnt2Late As Object, ByRef vnt3Late As Object, ByRef vnt4Late As Object, ByRef vnt5Late As Object, ByRef vnt6Late As Object, ByRef vntEStep1 As Object, ByRef vntEStep2 As Object, ByRef vntEStep3 As Object, ByRef vntEStep4 As Object, ByRef vntEStep5 As Object, ByRef vntEStep6 As Object, ByRef vntLStep1 As Object, ByRef vntLStep2 As Object, ByRef vntLStep3 As Object, ByRef vntLStep4 As Object, ByRef vntLStep5 As Object, ByRef vntLStep6 As Object, ByRef vntTotal As Object, ByRef vntJITEarly As Object, ByRef vntJITEarlyPercnt As Object, ByRef vntJITLate As Object, ByRef vntJITLatePercnt As Object, ByRef vntWindowId As Object, ByRef vntDaysEarly As Object, ByRef vntDaysLate As Object, ByRef vntInWindowPercnt As Object, ByRef vntInWindow As Object, ByRef vntSmryType As Object, ByRef vntDispCrit As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim objSearch As New clsSearch
        Dim objOrgs As New clsOrgs
        Dim vntCount As Integer
		Dim vntArray As Object
		Dim dblTemp1 As Double
		Dim dblTemp2 As Double
		Dim dblJITTempEarly As Double
		Dim dblJITTempLate As Double
		Dim blnrc As Boolean
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgID As Object
        'Dim vntMonthDailyInd As Object
        'Dim vntCustAcctTypeCde As Object
        'Dim vntPart As Object
        'Dim vntPlant As Object
        'Dim vntLocation As Object
        'Dim vntacctOrgKey As Object
        'Dim vntShipTo As Object
        'Dim vntSoldTo As Object
        'Dim vntWWCust As Object
        'Dim vntInvOrg As Object
        'Dim vntController As Object
        'Dim vntCntlrEmpNbr As Object
        'Dim vntStkMake As Object
        'Dim vntTeam As Object
        'Dim vntProdCde As Object
        'Dim vntProdLne As Object
        'Dim vntIBC As Object
        'Dim vntIC As Object
        'Dim vntMfgCampus As Object
        'Dim vntMfgBuilding As Object
        'Dim vntComparisonType As Object
        'Dim vntOpenShpOrder As Object
        'Dim vntProfit As Object
        'Dim vntCBC As Object
        'Dim vntSubCBC As Object
        'Dim vntOrgDate As Object
        'Dim vntLevel As Object
        'Dim vntLastDay As Object
        'Dim vntKeyId As Object
        'Dim vntOrgType As Object
        'Dim vntLength As Object
        'Dim vntOrgTypeDesc As Object
        'Dim vntTemp1 As Object
        'Dim intCountST As Short
        'Dim vntTemp As Object
        'Dim vntTempWW As Object
        'Dim vntTempWW2 As Object
        'Dim intCountWW As Short
        'Dim intFound As Short
        '      Dim objGetWWName As New clsWrldWide
        '      Dim objGetShipToName As New clsShipTo
        '      Dim objGetSoldToName As New clsSoldTo
        '      Dim vntName As Object
        'Dim vntTemp2 As Object
        'Dim vntCustOrg As Object
        'Dim vntProdMgr As Object
        'Dim vntLeadTimeType As Object
        'Dim vntSalesOffice As Object
        'Dim vntSalesGroup As Object
        'Dim vntMfgOrgType As Object
        'Dim vntMfgOrgId As Object
        'Dim vntMfgLevel As Object
        'Dim GamAccount As Object
        'Dim vntPartKeyID As Object
        'Dim vntMrpGroupCde As Object
        'Dim vntHostOrgID As Object
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
        Dim vntCurrentHist As String = ""
        Dim vntOrgID As String = ""
        Dim vntMonthDailyInd As String = ""
        Dim vntCustAcctTypeCde As String = ""
        Dim vntPart As String = ""
        Dim vntPlant As String = ""
        Dim vntLocation As String = ""
        Dim vntacctOrgKey As String = ""
        Dim vntShipTo As String = ""
        Dim vntSoldTo As String = ""
        Dim vntWWCust As String = ""
        Dim vntInvOrg As String = ""
        Dim vntController As String = ""
        Dim vntCntlrEmpNbr As String = ""
        Dim vntStkMake As String = ""
        Dim vntTeam As String = ""
        Dim vntProdCde As String = ""
        Dim vntProdLne As String = ""
        Dim vntIBC As String = ""
        Dim vntIC As String = ""
        Dim vntMfgCampus As String = ""
        Dim vntMfgBuilding As String = ""
        Dim vntComparisonType As String = ""
        Dim vntOpenShpOrder As String = ""
        Dim vntProfit As String = ""
        Dim vntCBC As String = ""
        Dim vntSubCBC As String = ""
        Dim vntOrgDate As String = ""
        Dim vntOrgType As String = ""
        Dim vntKeyId As Long
        Dim vntLevel As String = ""
        Dim vntLength As Integer
        Dim vntOrgTypeDesc As String = ""
        Dim intCountST As Integer
        Dim vntTemp As String = ""
        Dim vntTempWW As String = ""
        Dim vntTempWW2 As String = ""
        Dim intCountWW As Integer
        Dim intFound As Integer
        Dim objGetWWName As New clsWrldWide
        Dim objGetShipToName As New clsShipTo
        Dim objGetSoldToName As New clsSoldTo
        Dim vntName As String = ""
        Dim vntTemp2 As String = ""
        Dim vntCustOrg As String = ""
        Dim vntProdMgr As String = ""
        Dim vntLeadTimeType As String = ""
        Dim vntSalesOffice As String = ""
        Dim vntSalesGroup As String = ""
        Dim vntMfgOrgType As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgLevel As String = ""
        Dim GamAccount As String = ""
        Dim vntPartKeyID As String = ""
        Dim vntMrpGroupCde As String = ""
        Dim vntHostOrgID As String = ""

		On Error GoTo ErrorHandler
		
		dblTemp1 = 0
		dblTemp2 = 0
		
		If vntSessionID = "" Then
			Err.Raise(100,  , "Session Id not passed or found in component needed for retrieving search criteria in clsResults.ListSummMnthly")
		End If
		
        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDate, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNumber, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsSearch.RetrieveSession from clsResults.ListSummMnthly")
        End If

        If vntOrgID = "" And GamAccount = "" Then
            Err.Raise(100, , "ORG Id not found in search criteria in clsResults.ListSummMnthly" & " GamAccount=" & GamAccount)
        End If

        If vntOrgID <> "" Then
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"

            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDate, vntLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListSummMnthly")
            End If
            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
        End If

        If vntMfgOrgId <> "" Then
            blnrc = objOrgs.RetrieveType(vntMfgOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Mfg Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Mfg Org ID:</strong> " & vntMfgOrgId & ";"

            blnrc = objOrgs.RetrieveLevel(vntMfgOrgId, vntCurrentHist, vntOrgDate, vntMfgLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListSummMnthly")
            End If
            If Len(vntMfgLevel) > 6 Then
                vntMfgLevel = Right(vntMfgLevel, 2)
            Else
                vntMfgLevel = Right(vntMfgLevel, 1)
            End If
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org ID:</strong> " & vntacctOrgKey & ";"
            
            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDate, vntKeyId, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If
            vntacctOrgKey = vntKeyId
        End If

        If vntWindowId = "1" Then 'Customer Variable or Standard Default
            strSql = " SELECT   NVL(SUM(NBR_VARBL_OUT_RANGE_EARLY + NBR_VARBL_SIX_DAYS_EARLY), 0) var_six_plus_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_FIVE_DAYS_EARLY), 0) var_five_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_FOUR_DAYS_EARLY), 0) var_four_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_THREE_DAYS_EARLY), 0) var_three_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_TWO_DAYS_EARLY), 0) var_two_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_ONE_DAY_EARLY), 0) var_one_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_ON_TIME), 0) var_on_time,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_ONE_DAY_LATE), 0) var_one_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_TWO_DAYS_LATE), 0) var_two_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_THREE_DAYS_LATE), 0) var_three_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_FOUR_DAYS_LATE), 0) var_four_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_FIVE_DAYS_LATE), 0) var_five_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_SIX_DAYS_LATE + NBR_VARBL_OUT_RANGE_LATE), 0) var_six_plus_late,   "
            strSql = strSql & "       NVL(SUM(TOTAL_NBR_SHPMTS), 0) var_total,     "
        Else
            strSql = " SELECT NVL(SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY), 0) def_six_plus_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_FIVE_DAYS_EARLY), 0) def_five_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_FOUR_DAYS_EARLY), 0) def_four_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_THREE_DAYS_EARLY), 0) def_three_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_TWO_DAYS_EARLY), 0) def_two_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_ONE_DAY_EARLY), 0) def_one_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_ON_TIME), 0) def_on_time, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_ONE_DAY_LATE), 0) def_one_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_TWO_DAYS_LATE), 0) def_two_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_THREE_DAYS_LATE), 0) def_three_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_FOUR_DAYS_LATE), 0) def_four_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_FIVE_DAYS_LATE), 0) def_five_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE), 0) def_six_plus_late, "
            strSql = strSql & "     NVL(SUM(TOTAL_NBR_SHPMTS), 0) def_total, "
        End If
        
        strSql = strSql & "       NVL(SUM(NBR_JIT_OUT_RANGE_EARLY + NBR_JIT_SIX_DAYS_EARLY), 0) jit_six_plus_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_FIVE_DAYS_EARLY), 0) jit_five_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_FOUR_DAYS_EARLY), 0) jit_four_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_THREE_DAYS_EARLY), 0) jit_three_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_TWO_DAYS_EARLY), 0) jit_two_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_ONE_DAY_EARLY), 0) jit_one_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_ON_TIME), 0) jit_on_time,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_ONE_DAY_LATE), 0) jit_one_late,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_TWO_DAYS_LATE), 0) jit_two_late,  "
        strSql = strSql & "       NVL(SUM(NBR_JIT_THREE_DAYS_LATE), 0) jit_three_late,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_FOUR_DAYS_LATE), 0) jit_four_late,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_FIVE_DAYS_LATE), 0) jit_five_late,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_SIX_DAYS_LATE + NBR_JIT_OUT_RANGE_LATE), 0) jit_six_plus_late,   "
        strSql = strSql & "       NVL(SUM(TOTAL_NBR_JIT_SHPMTS), 0) jit_total,   "
        strSql = strSql & "       0 early_shpmts,   "
        strSql = strSql & "       0 on_time_shpmts,   "
        strSql = strSql & "       0 late_shpmts,   "
        strSql = strSql & "       0 jit_early_shpmts,   "
        strSql = strSql & "       0 jit_late_shpmts   "

        If vntViewId = "1" Then 'ORG
            strSql = strSql & " FROM      SCORECARD_ORG_SMRY A, "
        ElseIf vntViewId = "2" Or vntViewId = "12" Then  'Building or SAP Sales
            strSql = strSql & " FROM BUILDING_LOCATION_SMRY A, "
        ElseIf vntViewId = "3" Then  'Customer
            If vntSmryType = "1" Then
                strSql = strSql & " FROM CUSTOMER_ACCOUNT_SMRY_T1 A, "
            ElseIf vntSmryType = "2" Then
                strSql = strSql & " FROM CUSTOMER_ACCOUNT_SMRY_T2 A, "
            Else
                strSql = strSql & " FROM CUSTOMER_ACCOUNT_SMRY_T3 A, "
            End If
        ElseIf vntViewId = "4" Then  'Ship Facility NOT VALID FOR THIS VIEW

        ElseIf vntViewId = "5" Or vntViewId = "7" Then  'Team or Make Stock
            strSql = strSql & " FROM TEAM_ORG_SMRY A, "
        ElseIf vntViewId = "6" Then  'Controller
            'If vntStkMake <> "" Then
            strSql = strSql & " FROM TEAM_ORG_SMRY A, "
            'Else
            '    strSql = strSql & " FROM CNTRLR_PROD_LINE_SMRY A, "
            'End If
        ElseIf vntViewId = "8" Then
            If vntStkMake <> "" Then
                strSql = strSql & " FROM TEAM_ORG_SMRY A, "
            Else
                strSql = strSql & " FROM CNTRLR_PROD_LINE_SMRY A, "
                If vntProdMgr <> "" Then
                    strSql = strSql & " GED_PUBLIC_TABLE F, "
                End If
            End If
        ElseIf vntViewId = "9" Then
            strSql = strSql & " FROM INDUSTRY_CODE_SMRY A, "
        ElseIf vntViewId = "10" Then
            strSql = strSql & " FROM MFG_CAMPUS_BLDG_SMRY A, "
            strSql = strSql & " ORGANIZATIONS_DMN D, "
        ElseIf vntViewId = "11" Then
            strSql = strSql & " FROM PROFIT_CENTER_SMRY A, "
        End If
        strSql = strSql & " ORGANIZATIONS_DMN C "

        If GamAccount <> "" Then
            strSql = strSql & ", GBL_ALL_CUST_PURCH_BY G"
        End If

        'Added
        
        If GamAccount = "" Then
            'original statement
            strSql = strSql & " WHERE  C.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        Else
            strSql = strSql & " WHERE  C.ORGANIZATION_ID = g.PB_ACCT_ORG_ID "
            strSql = strSql & " AND a.SOLD_TO_CUSTOMER_ID =  g.PB_ACCT_NBR_BASE "
            strSql = strSql & " AND G.PB_GBL_ACCT_CDE = '" & GamAccount & "'"
            vntDispCrit = vntDispCrit & " <strong>GAM Account:</strong> " & GamAccount & ";"
        End If

        If vntViewId = "10" Then
            strSql = strSql & " AND  D.LAYER" & vntMfgLevel & "_ORGANIZATION_ID = '" & vntMfgOrgId & "' "
            strSql = strSql & " AND  A.MFR_ORG_KEY_ID = D.ORGANIZATION_KEY_ID "
        End If

        'added

        If GamAccount = "" Then
            'original statement
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID "
        Else
            strSql = strSql & " AND  A.ACCOUNTING_ORG_KEY_ID = C.ORGANIZATION_KEY_ID "
        End If

        If vntViewId = "8" And vntProdMgr <> "" And vntStkMake = "" Then
            strSql = strSql & " AND (F.ASOC_GLOBAL_ID(+) = A.PRODUCT_MANAGER_GLOBAL_ID) "
        End If

        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                Else
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                End If
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
            Else
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
            End If

            If vntViewId = "10" Then
                If vntCurrentHist = "C" Then
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
            End If
        Else
            strSql = strSql & " AND C.RECORD_STATUS_CDE = 'C' "
            vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
        End If

        'Check SummaryType

        If vntSmryType = "1" Then
            strSql = strSql & " AND   (DELIVERY_SMRY_TYPE = '1') "
            vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
        ElseIf vntSmryType = "2" Then
            strSql = strSql & " AND   (DELIVERY_SMRY_TYPE = '2') "
            vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
        Else
            strSql = strSql & " AND   (DELIVERY_SMRY_TYPE = '3') "
            vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request to Schedule;"
        End If

        strSql = strSql & " AND AMP_SHIPPED_MONTH BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"

        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        
        If vntPart <> "" And Not IsDBNull(vntPartKeyID) Then
            '    intCountST = 0
            '    vntTemp = ""
            '    vntPart = Replace(vntPart, "-", "")
            '    If Len(vntPart) < 9 Then
            '        For intCountST = 1 To 9 - Len(vntPart)
            '            vntTemp = "0" & vntTemp
            '        Next
            '        vntPart = vntTemp & vntPart
            '    End If
            '    strSql = strSql & " AND Part_Nbr = '" & vntPart & "' "
            strSql = strSql & " AND PART_KEY_ID = " & vntPartKeyID
            vntDispCrit = vntDispCrit & " <strong>Part:</strong> " & vntPart & ";"
        End If

        If vntPlant <> "" Then
            strSql = strSql & " AND (ACTUAL_SHIP_BUILDING_NBR = '" & vntPlant & "')"
            vntDispCrit = vntDispCrit & " <strong>Plant/Blg:</strong> " & vntPlant & ";"
        End If

        If vntLocation <> "" Then
            strSql = strSql & " AND ACTUAL_SHIP_LOCATION = '" & vntLocation & "'"
            vntDispCrit = vntDispCrit & " <strong>Location:</strong> " & vntLocation & ";"
        End If

        If vntController <> "" Then
            If InStr(vntController, ",") > 0 Then
                strSql = strSql & " AND PRODCN_CNTRLR_CODE IN ( " & QuoteStr(vntController) & " ) "
            Else
                strSql = strSql & " AND PRODCN_CNTRLR_CODE " & IIf(InStr(vntController, "%") > 0, "LIKE '", "= '") & vntController & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Controller:</strong> " & vntController & ";"
        End If

        If vntStkMake <> "" Then
            vntLength = Len(vntStkMake)
            strSql = strSql & " AND substr(STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            vntDispCrit = vntDispCrit & " <strong>Make Stock:</strong> " & vntStkMake & ";"
        End If

        If vntMrpGroupCde <> "" Then
            If InStr(vntMrpGroupCde, ",") > 0 Then
                strSql = strSql & " AND MRP_GROUP_CDE IN ( " & QuoteStr(vntMrpGroupCde) & " ) "
            Else
                strSql = strSql & " AND MRP_GROUP_CDE " & IIf(InStr(vntMrpGroupCde, "%") > 0, "LIKE '", "= '") & vntMrpGroupCde & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>MRP Group:</strong> " & vntMrpGroupCde & ";"
        End If

        If vntTeam <> "" Then
            strSql = strSql & " AND TEAM_CODE = '" & vntTeam & "' "
            vntDispCrit = vntDispCrit & " <strong>Team:</strong> " & vntTeam & ";"
        End If

        If vntProdLne <> "" Then
            If InStr(vntProdLne, ",") > 0 Then
                strSql = strSql & " AND PRODUCT_LINE_CODE IN ( " & QuoteStr(vntProdLne) & " )"
            Else
                strSql = strSql & " AND PRODUCT_LINE_CODE = '" & vntProdLne & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Product Line:</strong> " & vntProdLne & ";"
        End If

        If vntInvOrg <> "" Then
            If InStr(vntInvOrg, ",") > 0 Then
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID IN ( " & QuoteStr(vntInvOrg) & " ) "
            Else
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID " & IIf(InStr(vntInvOrg, "%") > 0, "LIKE '", "= '") & vntInvOrg & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Inv Org/Plant:</strong> " & vntInvOrg & ";"
        End If

        If vntProdCde <> "" Then
            strSql = strSql & " AND PRODUCT_CODE = '" & vntProdCde & "' "
            vntDispCrit = vntDispCrit & " <strong>Product Code:</strong> " & vntProdCde & ";"
        End If

        If vntIBC <> "" Then
            If InStr(vntIBC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_BUSINESS_CDE IN ( " & QuoteStr(vntIBC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_BUSINESS_CDE = '" & vntIBC & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry Business:</strong> " & vntIBC & ";"
        End If

        If vntIC <> "" Then
            If InStr(vntIC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_CODE IN ( " & QuoteStr(vntIC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_CODE LIKE '" & vntIC & "%' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry:</strong> " & vntIC & ";"
        End If

        If vntWWCust <> "" Then
            vntTemp2 = vntWWCust
            intFound = 0
            vntTempWW = ""
            vntTempWW2 = ""
            intCountWW = 0
            intFound = InStr(vntWWCust, "-")

            If intFound <> 0 Then
                vntTempWW = Left(vntWWCust, intFound - 1)
                vntTempWW2 = Right(vntWWCust, Len(vntWWCust) - intFound)
            Else
                If Len(vntWWCust) > 10 Then
                    Err.Raise(901, , "WorldWide Number is invalid.  These numbers are required to have a maximum of 10 characters")
                ElseIf Len(vntWWCust) <= 8 Then
                    vntTempWW = vntWWCust
                ElseIf Len(vntWWCust) = 9 Then
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 1)
                Else
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 2)
                End If
            End If

            If Len(vntTempWW) < 8 Then
                For intCountWW = 1 To 8 - Len(vntTempWW)
                    vntTemp = vntTemp & "0"
                Next
                vntWWCust = vntTemp & vntTempWW
            Else
                vntWWCust = vntTempWW
            End If

            If Len(vntTempWW2) = 1 Then
                vntTempWW2 = "0" & vntTempWW2
                vntWWCust = vntWWCust & vntTempWW2
            Else
                vntWWCust = vntWWCust & vntTempWW2
            End If

            If Len(vntWWCust) > 8 Then
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
                strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
            Else
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
            End If

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntShipTo <> "" Then
            vntTemp2 = vntShipTo
            intCountST = 0
            vntTemp = ""
            vntShipTo = Replace(vntShipTo, "-", "")

            If Len(vntShipTo) < 10 Then
                For intCountST = 1 To 10 - Len(vntShipTo)
                    vntTemp = "0" & vntTemp
                Next
                vntShipTo = vntTemp & vntShipTo
            End If

            If Len(vntShipTo) > 10 Then
                Err.Raise(901, , "Ship To Number is invalid.  These numbers are required to have 10 characters")
            Else
                strSql = strSql & " AND PURCHASE_BY_ACCOUNT_BASE = '" & Left(vntShipTo, 8) & "'"
                strSql = strSql & " AND SHIP_TO_ACCOUNT_SUFFIX = '" & Right(vntShipTo, 2) & "'"
            End If

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntacctOrgKey <> "" Then
            strSql = strSql & " AND ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey
        End If

        If vntMfgCampus <> "" Then
            strSql = strSql & " AND MFG_CAMPUS_ID = '" & vntMfgCampus & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Campus:</strong> " & vntMfgCampus & ";"
        End If

        If vntMfgBuilding <> "" Then
            strSql = strSql & " AND MFG_BUILDING_NBR = '" & vntMfgBuilding & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Building:</strong> " & vntMfgBuilding & ";"
        End If

        If vntCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_ID = '" & vntCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Competency Business:</strong> " & vntCBC & ";"
        End If

        If vntSubCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_FNCTN_ID = '" & vntSubCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Sub-Competency Business:</strong> " & vntSubCBC & ";"
        End If

        If vntProfit <> "" Then
            strSql = strSql & " AND PROFIT_CENTER_ABBR_NM = '" & vntProfit & "' "
            vntDispCrit = vntDispCrit & " <strong>Profit Center:</strong> " & vntProfit & ";"
        End If

        If vntSalesOffice <> "" Then
            If InStr(vntSalesOffice, ",") > 0 Then
                strSql = strSql & " AND A.SALES_OFFICE_CDE IN ( " & QuoteStr(vntSalesOffice) & " ) "
            Else
                strSql = strSql & " AND A.SALES_OFFICE_CDE " & IIf(InStr(vntSalesOffice, "%") > 0, "LIKE '", "= '") & vntSalesOffice & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Office:</strong> " & vntSalesOffice & ";"
        End If

        If vntSalesGroup <> "" Then
            If InStr(vntSalesGroup, ",") > 0 Then
                strSql = strSql & " AND A.SALES_GROUP_CDE IN ( " & QuoteStr(vntSalesGroup) & " ) "
            Else
                strSql = strSql & " AND A.SALES_GROUP_CDE " & IIf(InStr(vntSalesGroup, "%") > 0, "LIKE '", "= '") & vntSalesGroup & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Group:</strong> " & vntSalesGroup & ";"
        End If

        If vntSoldTo <> "" Then
            vntTemp2 = vntSoldTo
            intCountST = 0
            vntTemp = ""
            vntSoldTo = Replace(vntSoldTo, "-", "")

            If Len(vntSoldTo) < 8 Then
                For intCountST = 1 To 8 - Len(vntSoldTo)
                    vntTemp = "0" & vntTemp
                Next
                vntSoldTo = vntTemp & vntSoldTo
            End If

            If Len(vntSoldTo) > 8 Then
                Err.Raise(901, , "Sold To Number is invalid.  These numbers are required to have 8 characters")
            Else
                strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
            End If

            blnrc = objGetSoldToName.RetrieveName(vntCustOrg, vntSoldTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetSoldToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntProdMgr <> "" Then
            strSql = strSql & ParseProdMgr(vntProdMgr)
            vntDispCrit = vntDispCrit & " <strong>Product Mgr:</strong> " & vntProdMgr & ";"
        End If

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)
        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsResults.ListSummMnthly call to CallRS for Monthly Query")
        End If

        ListSummMnthly = Nothing
        vntArray = Nothing
        
        If vntCount > 0 Then
            'For any recordsets we will pass back to the web ASP pages variant arrays
            'ListSummMnthly = objList.GetRows
            vntArray = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListSummMnthly = System.DBNull.Value
        End If

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

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If Not IsDBNull(ListSummMnthly) Then
            If vntArray(13, 0) <> 0 Then
                vntOnTime = VB6.Format(CInt(vntArray(6, 0)), "#,##0")
                vntCenter1 = VB6.Format(System.Math.Round(CDbl(vntArray(6, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter3 = VB6.Format(System.Math.Round((CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter4 = VB6.Format(System.Math.Round((CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter5 = VB6.Format(System.Math.Round((CDbl(vntArray(3, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter6 = VB6.Format(System.Math.Round((CDbl(vntArray(2, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter7 = VB6.Format(System.Math.Round((CDbl(vntArray(1, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntCenter8 = VB6.Format(System.Math.Round((CDbl(vntArray(0, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(5, 0)) + CDbl(vntArray(7, 0)) + CDbl(vntArray(6, 0))) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt6Early = VB6.Format(System.Math.Round(CDbl(vntArray(0, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt5Early = VB6.Format(System.Math.Round(CDbl(vntArray(1, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt4Early = VB6.Format(System.Math.Round(CDbl(vntArray(2, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt3Early = VB6.Format(System.Math.Round(CDbl(vntArray(3, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt2Early = VB6.Format(System.Math.Round(CDbl(vntArray(4, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt1Early = VB6.Format(System.Math.Round(CDbl(vntArray(5, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt1Late = VB6.Format(System.Math.Round(CDbl(vntArray(7, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt2Late = VB6.Format(System.Math.Round(CDbl(vntArray(8, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt3Late = VB6.Format(System.Math.Round(CDbl(vntArray(9, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt4Late = VB6.Format(System.Math.Round(CDbl(vntArray(10, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt5Late = VB6.Format(System.Math.Round(CDbl(vntArray(11, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vnt6Late = VB6.Format(System.Math.Round(CDbl(vntArray(12, 0)) / CDbl(vntArray(13, 0)), 3), "0.0%")
                vntEStep1 = VB6.Format(vntArray(5, 0), "#,##0")
                vntEStep2 = VB6.Format(vntArray(4, 0), "#,##0")
                vntEStep3 = VB6.Format(vntArray(3, 0), "#,##0")
                vntEStep4 = VB6.Format(vntArray(2, 0), "#,##0")
                vntEStep5 = VB6.Format(vntArray(1, 0), "#,##0")
                vntEStep6 = VB6.Format(vntArray(0, 0), "#,##0")
                vntLStep1 = VB6.Format(vntArray(7, 0), "#,##0")
                vntLStep2 = VB6.Format(vntArray(8, 0), "#,##0")
                vntLStep3 = VB6.Format(vntArray(9, 0), "#,##0")
                vntLStep4 = VB6.Format(vntArray(10, 0), "#,##0")
                vntLStep5 = VB6.Format(vntArray(11, 0), "#,##0")
                vntLStep6 = VB6.Format(vntArray(12, 0), "#,##0")
                vntTotal = VB6.Format(vntArray(13, 0), "#,##0")

                If vntWindowId = "1" Then
                    vntSumLate = VB6.Format(CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                    vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)), "#,##0")
                    vntInWindowPercnt = vntCenter1
                    vntInWindow = vntOnTime

                ElseIf vntWindowId = 2 Then  ' Standard Default
                    'Figure out Days Early
                    If vntDaysEarly = "" Then
                        vntDaysEarly = "0"
                    End If
                    If vntSmryType = "1" Then 'all earlies are ontime except JIT for STS
                        vntSumEarly = 0
                    Else
                        Select Case vntDaysEarly
                            Case "0"
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)), "#,##0")
                            Case "1"
                                '                    vntSumEarly = Format((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(19, 0))), "#,##0")
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)), "#,##0")
                            Case "2"
                                '                    vntSumEarly = Format((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0))), "#,##0")
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)), "#,##0")
                            Case "3"
                                '                    vntSumEarly = Format((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0))), "#,##0")
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)), "#,##0")
                            Case "4"
                                '                    vntSumEarly = Format((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0))), "#,##0")
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)), "#,##0")
                            Case "5"
                                '                    vntSumEarly = Format((CDbl(vntArray(0, 0)) + CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(15, 0))), "#,##0")
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)), "#,##0")
                            Case Else
                                '                    vntSumEarly = Format((CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0))), "#,##0")
                                vntSumEarly = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(5, 0)), "#,##0")
                        End Select
                    End If

                    'Figure out Days Late
                    If vntDaysLate = "" Then
                        vntDaysLate = "0"
                    End If
                    Select Case vntDaysLate
                        Case "0"
                            vntSumLate = VB6.Format(CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                        Case "1"
                            '                    vntSumLate = Format((CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(21, 0))), "#,##0")
                            vntSumLate = VB6.Format(CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                        Case "2"
                            '                    vntSumLate = Format((CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0))), "#,##0")
                            vntSumLate = VB6.Format(CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                        Case "3"
                            '                    vntSumLate = Format((CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0))) + (CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0))), "#,##0")
                            vntSumLate = VB6.Format(CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                        Case "4"
                            '                    vntSumLate = Format((CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)) + CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0))), "#,##0")
                            vntSumLate = VB6.Format(CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                        Case "5"
                            '                    vntSumLate = Format((CDbl(vntArray(12, 0)) + CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0))), "#,##0")
                            vntSumLate = VB6.Format(CDbl(vntArray(12, 0)), "#,##0")
                        Case Else
                            vntSumLate = VB6.Format(CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0)) + CDbl(vntArray(12, 0)), "#,##0")
                    End Select

                    vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> "

                    'Figure out In Window

                    If vntSmryType = "1" Then 'all earlies are ontime except JIT for STS
                        vntDispCrit = vntDispCrit & "All;"
                        dblJITTempEarly = CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(14, 0))
                        dblTemp1 = CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(1, 0)) + CDbl(vntArray(0, 0))
                    Else
                        vntDispCrit = vntDispCrit & vntDaysEarly & ";"
                        Select Case vntDaysEarly
                            Case "0"
                                dblJITTempEarly = 0
                                dblTemp1 = 0
                            Case "1"
                                dblJITTempEarly = CDbl(vntArray(19, 0))
                                dblTemp1 = CDbl(vntArray(5, 0))
                            Case "2"
                                dblJITTempEarly = CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0))
                                dblTemp1 = CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0))
                            Case "3"
                                dblJITTempEarly = CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0))
                                dblTemp1 = CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(3, 0))
                            Case "4"
                                dblJITTempEarly = CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0))
                                dblTemp1 = CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(2, 0))
                            Case "5"
                                dblJITTempEarly = CDbl(vntArray(19, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(15, 0))
                                dblTemp1 = CDbl(vntArray(5, 0)) + CDbl(vntArray(4, 0)) + CDbl(vntArray(3, 0)) + CDbl(vntArray(2, 0)) + CDbl(vntArray(1, 0))
                            Case Else
                                dblJITTempEarly = 0
                                dblTemp1 = 0
                        End Select
                    End If

                    vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"

                    Select Case vntDaysLate
                        Case "0"
                            dblJITTempLate = 0
                            dblTemp2 = 0
                        Case "1"
                            dblJITTempLate = CDbl(vntArray(21, 0))
                            dblTemp2 = CDbl(vntArray(7, 0))
                        Case "2"
                            dblJITTempLate = CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0))
                            dblTemp2 = CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0))
                        Case "3"
                            dblJITTempLate = CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0))
                            dblTemp2 = (CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)))
                        Case "4"
                            dblJITTempLate = CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0))
                            dblTemp2 = CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0))
                        Case "5"
                            dblJITTempLate = CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0))
                            dblTemp2 = CDbl(vntArray(7, 0)) + CDbl(vntArray(8, 0)) + CDbl(vntArray(9, 0)) + CDbl(vntArray(10, 0)) + CDbl(vntArray(11, 0))
                        Case Else
                            dblJITTempLate = 0
                            dblTemp2 = 0
                    End Select

                    If vntSmryType = "1" Then
                        vntSumEarly = VB6.Format(CDbl(vntSumEarly) + dblJITTempEarly, "#,##0")
                        vntSumLate = VB6.Format(CDbl(vntSumLate) + dblJITTempLate, "#,##0")
                        vntInWindow = VB6.Format(dblTemp1 + dblTemp2 + vntOnTime - dblJITTempEarly - dblJITTempLate, "#,##0")
                    Else
                        vntInWindow = VB6.Format(dblTemp1 + dblTemp2 + vntOnTime, "#,##0")
                    End If

                    vntInWindowPercnt = VB6.Format(System.Math.Round(vntInWindow / CDbl(vntArray(13, 0)), 3), "0.0%")
                End If

                vntSumEarlyPercnt = VB6.Format(System.Math.Round(CInt(vntSumEarly) / CInt(vntArray(13, 0)), 3), "0.0%")
                vntSumLatePercnt = VB6.Format(System.Math.Round(CDbl(vntSumLate) / CDbl(vntArray(13, 0)), 3), "0.0%")

                If vntSmryType = "1" Then
                    vntJITLate = VB6.Format(CDbl(vntArray(21, 0)) + CDbl(vntArray(22, 0)) + CDbl(vntArray(23, 0)) + CDbl(vntArray(24, 0)) + CDbl(vntArray(25, 0)) + CDbl(vntArray(26, 0)), "#,##0")
                    vntJITEarly = VB6.Format(CDbl(vntArray(14, 0)) + CDbl(vntArray(15, 0)) + CDbl(vntArray(16, 0)) + CDbl(vntArray(17, 0)) + CDbl(vntArray(18, 0)) + CDbl(vntArray(19, 0)), "#,##0")
                    vntJITEarlyPercnt = VB6.Format(System.Math.Round(CInt(vntJITEarly) / CInt(vntArray(13, 0)), 3), "0.0%")
                    vntJITLatePercnt = VB6.Format(System.Math.Round(CDbl(vntJITLate) / CDbl(vntArray(13, 0)), 3), "0.0%")
                End If

                ListSummMnthly = vntArray
            Else
                Err.Raise(100, , "The divisor equaled 0 which means no results were found.(in clsResults.ListSummMnthly)")
            End If
        End If

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListSummMnthly = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function
	
	'##ModelId=3AC1DC0C0198
	Public Function ListGeneral(ByVal vntSessionID As Object, ByVal vntGetTotal As Object, ByVal vntPage As Object, ByVal vntExport As Object, ByRef vntCount As Object, ByRef vntRecsLeft As Object, ByRef vntExtTotal As Object, ByRef vntLocalTotal As Object, ByRef vntSmryType As Object, ByRef vntArray As Object, ByRef vntDispCrit As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim objSearch As New clsSearch
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
		Dim vntTempArray As Object
        'Dim intPageCount As Short
        'Dim intRecsLeft As Short
        'Dim intCount As Short
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntWindowId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgID As Object
        'Dim vntDaysEarly As Object
        'Dim vntDaysLate As Object
        'Dim vntMonthDailyInd As Object
        'Dim vntCustAcctTypeCde As Object
        'Dim vntPart As Object
        'Dim vntPlant As Object
        'Dim vntLocation As Object
        'Dim vntacctOrgKey As Object
        'Dim vntShipTo As Object
        'Dim vntSoldTo As Object
        'Dim vntWWCust As Object
        'Dim vntInvOrg As Object
        'Dim vntController As Object
        'Dim vntCntlrEmpNbr As Object
        'Dim vntStkMake As Object
        'Dim vntTeam As Object
        'Dim vntProdCde As Object
        'Dim vntProdLne As Object
        'Dim vntIBC As Object
        'Dim vntIC As Object
        'Dim vntMfgCampus As Object
        'Dim vntMfgBuilding As Object
        'Dim vntComparisonType As Object
        'Dim vntOpenShpOrder As Object
        'Dim vntProfit As Object
        'Dim vntCBC As Object
        'Dim vntSubCBC As Object
        'Dim vntOrgDate As Object
        'Dim vntLevel As Object
        'Dim vntKeyId As Object
        'Dim vntOrgType As Object
        'Dim vntLength As Object
        Dim strTemp1 As String = ""
        Dim strTemp2 As String = ""
        Dim strTemp3 As String = ""
        'Dim vntOrgTypeDesc As Object
        'Dim intCountST As Short
        'Dim vntTemp As Object
        'Dim vntTempWW As Object
        'Dim vntTempWW2 As Object
        'Dim intCountWW As Short
        'Dim intFound As Short
        '      Dim objGetWWName As New clsWrldWide
        '      Dim objGetShipToName As New clsShipTo
        '      Dim objGetSoldToName As New clsSoldTo
        '      Dim vntName As Object
        'Dim vntTemp2 As Object
        'Dim vntCustOrg As Object
        'Dim vntProdMgr As Object
        'Dim vntLeadTimeType As Object
        'Dim vntSalesOffice As Object
        'Dim vntSalesGroup As Object
        'Dim vntMfgOrgType As Object
        'Dim vntMfgOrgId As Object
        'Dim vntMfgLevel As Object
        'Dim GamAccount As Object
        'Dim vntPartKeyID As Object
        'Dim vntMrpGroupCde As Object
        'Dim vntHostOrgID As Object
        Dim intPageCount As Integer
        Dim intRecsLeft As Integer
        Dim intCount As Integer
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntWindowId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
        'Dim vntSmryType As String = ""
        Dim vntCurrentHist As String = ""
        Dim vntOrgID As String = ""
        Dim vntOrgKeyId As String = ""
        Dim vntDaysEarly As String = ""
        Dim vntDaysLate As String = ""
        Dim vntMonthDailyInd As String = ""
        Dim vntCustAcctTypeCde As String = ""
        Dim vntPart As String = ""
        Dim vntPlant As String = ""
        Dim vntLocation As String = ""
        Dim vntacctOrgKey As String = ""
        Dim vntShipTo As String = ""
        Dim vntSoldTo As String = ""
        Dim vntWWCust As String = ""
        Dim vntInvOrg As String = ""
        Dim vntController As String = ""
        Dim vntCntlrEmpNbr As String = ""
        Dim vntStkMake As String = ""
        Dim vntTeam As String = ""
        Dim vntProdCde As String = ""
        Dim vntProdLne As String = ""
        Dim vntIBC As String = ""
        Dim vntIC As String = ""
        Dim vntMfgCampus As String = ""
        Dim vntMfgBuilding As String = ""
        Dim vntComparisonType As String = ""
        Dim vntOpenShpOrder As String = ""
        Dim vntProfit As String = ""
        Dim vntCBC As String = ""
        Dim vntSubCBC As String = ""
        Dim vntOrgDate As String = ""
        Dim vntLevel As String = ""
        Dim vntKeyId As Long
        'Dim vntTempArray As Object
        Dim vntOrgType As String = ""
        Dim vntLength As Integer
        Dim vntOrgTypeDesc As String = ""
        Dim intCountST As Integer
        Dim vntTemp As String = ""
        Dim vntTempWW As String = ""
        Dim vntTempWW2 As String = ""
        Dim intCountWW As Integer
        Dim intFound As Integer
        Dim objGetWWName As New clsWrldWide
        Dim objGetShipToName As New clsShipTo
        Dim objGetSoldToName As New clsSoldTo
        Dim vntName As String = ""
        Dim vntTemp2 As String = ""
        Dim vntCustOrg As String = ""
        Dim vntProdMgr As String = ""
        Dim vntLeadTimeType As String = ""
        Dim vntSalesOffice As String = ""
        Dim vntSalesGroup As String = ""
        Dim vntMfgOrgType As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgLevel As String = ""
        Dim GamAccount As String = ""
        Dim vntPartKeyID As String = ""
        Dim vntMrpGroupCde As String = ""
        Dim vntHostOrgID As String = ""

		On Error GoTo ErrorHandler

		If vntSessionID = "" Then
			Err.Raise(100,  , "Session Id not passed or found in component needed for retrieving search criteria in clsResults.ListConfNonConf")
		End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDate, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNumber, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsSearch.RetrieveSession")
        End If

        If vntWindowId = 2 And vntSmryType <> 3 Then
            If vntDaysEarly = "" Then vntDaysEarly = 0
            If vntDaysEarly > 5 Or vntDaysLate > 5 Then
                Err.Raise(9921, , "Days Early or Days Late was entered greater than 5 in clsResults.ListGeneral")
            End If
        End If

        If vntOrgID <> "" Then
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If
            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"

            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDate, vntLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel")
            End If
            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
        End If

        If vntMfgOrgId <> "" Then
            blnrc = objOrgs.RetrieveType(vntMfgOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If
            vntDispCrit = vntDispCrit & "<strong> Mfg Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Mfg Org ID:</strong> " & vntMfgOrgId & ";"

            blnrc = objOrgs.RetrieveLevel(vntMfgOrgId, vntCurrentHist, vntOrgDate, vntMfgLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListGeneral")
            End If
            If Len(vntMfgLevel) > 6 Then
                vntMfgLevel = Right(vntMfgLevel, 2)
            Else
                vntMfgLevel = Right(vntMfgLevel, 1)
            End If
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org ID:</strong> " & vntacctOrgKey & ";"
            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDate, vntKeyId, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If
            vntacctOrgKey = vntKeyId
        End If

        If vntCategoryId = "9" And vntViewId = "2" Then
            strSql = " SELECT C.ORGANIZATION_ID ORGID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & " A.ACTUAL_SHIP_BUILDING_NBR VIEWDESC1, "
            strSql = strSql & " B.BUILDING_NM VIEWDESC2, "
        End If

        If vntCategoryId = "9" And vntViewId = "10" Then
            strSql = " SELECT D.ORGANIZATION_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & " A.MFG_BUILDING_NBR VIEWDESC1, "
            strSql = strSql & " B.BUILDING_NM VIEWDESC2, "
        End If

        If vntCategoryId = "10" Then
            strSql = " SELECT C.ORGANIZATION_ID ORGID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & "  A.ACTUAL_SHIP_LOCATION VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "13" And vntViewId = "3" Then 'Cust/WorldWide
            strSql = " SELECT C.ORGANIZATION_ID ORGID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & " NULL VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "13" And vntViewId = "6" Then 'Controller
            strSql = " SELECT  A.CONTROLLER_UNIQUENESS_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME, "
            strSql = strSql & " NULL VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "15" Then
            strSql = " SELECT C.ORGANIZATION_ID ORGID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & " A.TEAM_CODE VIEWDESC1, "
            strSql = strSql & " B.ABBRD_DESC VIEWDESC2, "
        End If

        If vntCategoryId = "16" Then
            strSql = " SELECT  A.CONTROLLER_UNIQUENESS_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME, "
            strSql = strSql & " A.PRODCN_CNTRLR_CODE VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "17" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.STOCK_MAKE_CODE VIEWDESC1, "
            strSql = strSql & " B.STOCK_MAKE_DSCRPTN VIEWDESC2, "
        End If

        If vntCategoryId = "18" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.PRODUCT_LINE_CODE VIEWDESC1, "
            strSql = strSql & " B.PRLN_SHORT_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "19" Then
            strSql = " SELECT  A.PRODUCT_LINE_CODE ORGID, "
            strSql = strSql & " F.FIRST_NAME||DECODE(F.MIDDLE_INITIAL,NULL,'',' '||F.MIDDLE_INITIAL)||' '||F.LAST_NAME PRODMGRNAME, "
            strSql = strSql & " A.PRODUCT_CODE VIEWDESC1, "
            strSql = strSql & " B.PROD_SHORT_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "20" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.INDUSTRY_CODE VIEWDESC1, "
            strSql = strSql & " B.INDUSTRY_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "21" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.INDUSTRY_BUSINESS_CDE VIEWDESC1, "
            strSql = strSql & " B.GIB_SHORT_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "22" Then
            strSql = " SELECT D.ORGANIZATION_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & "  A.MFG_CAMPUS_ID VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "23" Then
            strSql = " SELECT D.ORGANIZATION_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & "  A.MFG_CAMPUS_ID VIEWDESC1, "
            strSql = strSql & " A.MFG_BUILDING_NBR VIEWDESC2, "
        End If

        If vntCategoryId = "24" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.PROFIT_CENTER_ABBR_NM VIEWDESC1, "
            strSql = strSql & " B.MGE_PROFIT_CENTER_DESC VIEWDESC2, "
        End If

        If vntCategoryId = "25" Then
            strSql = " SELECT  A.PRODUCT_BUSNS_LINE_ID ORGID, "
            strSql = strSql & " E.BUSLN_DSCRPTN ORGNAME, "
            strSql = strSql & " A.PRODUCT_BUSNS_LINE_FNCTN_ID VIEWDESC1, "
            strSql = strSql & " B.BUSLN_FNCTN_SHORT_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "26" Then
            strSql = " SELECT  A.SALES_OFFICE_CDE ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " B.CODE_NM VIEWDESC1, "
            strSql = strSql & " A.ACTUAL_SHIP_BUILDING_NBR VIEWDESC2, "
        End If

        If vntCategoryId = "27" Then
            strSql = " SELECT  A.SALES_OFFICE_CDE ORGID, "
            strSql = strSql & " A.ACTUAL_SHIP_BUILDING_NBR ORGNAME, "
            strSql = strSql & " A.SALES_GROUP_CDE VIEWDESC1, "
            strSql = strSql & " B.CODE_NM VIEWDESC2, "
        End If

        Select Case vntSmryType
            Case "1"
                vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
            Case "2"
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
            Case "3"
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request to Schedule;"
        End Select

        If vntWindowId = 1 Then 'cust variable
            If vntSmryType = 2 Then 'STR
                strSql = strSql & " SUM(TOTAL_NBR_SHPMTS) computed_total_nbr_shipments, "
                strSql = strSql & " 0 computed_total_jit_shipments, "
                strSql = strSql & " SUM(NBR_VARBL_OUT_RANGE_EARLY + NBR_VARBL_SIX_DAYS_EARLY + NBR_VARBL_FIVE_DAYS_EARLY + NBR_VARBL_FOUR_DAYS_EARLY + NBR_VARBL_THREE_DAYS_EARLY + NBR_VARBL_TWO_DAYS_EARLY + NBR_VARBL_ONE_DAY_EARLY ) computed_total_early, "
                strSql = strSql & " 0 computed_total_early_jit, "
                strSql = strSql & " (SUM(NBR_VARBL_ON_TIME ) ) computed_total_on_time, "
                strSql = strSql & " 0 computed_total_on_time_jit, "
                strSql = strSql & " SUM(NBR_VARBL_ONE_DAY_LATE + NBR_VARBL_TWO_DAYS_LATE + NBR_VARBL_THREE_DAYS_LATE + NBR_VARBL_FOUR_DAYS_LATE + NBR_VARBL_FIVE_DAYS_LATE + NBR_VARBL_SIX_DAYS_LATE + NBR_VARBL_OUT_RANGE_LATE ) computed_total_late, "
                strSql = strSql & " 0 computed_total_late_jit  "
            Else 'STS
                strSql = strSql & " SUM(TOTAL_NBR_SHPMTS) computed_total_nbr_shipments, "
                strSql = strSql & " SUM(TOTAL_NBR_JIT_SHPMTS) computed_total_jit_shipments, "
                strSql = strSql & " SUM(NBR_VARBL_OUT_RANGE_EARLY + NBR_VARBL_SIX_DAYS_EARLY + NBR_VARBL_FIVE_DAYS_EARLY + NBR_VARBL_FOUR_DAYS_EARLY + NBR_VARBL_THREE_DAYS_EARLY + NBR_VARBL_TWO_DAYS_EARLY + NBR_VARBL_ONE_DAY_EARLY ) computed_total_early, "
                strSql = strSql & " SUM(NBR_JIT_OUT_RANGE_EARLY + NBR_JIT_SIX_DAYS_EARLY + NBR_JIT_FIVE_DAYS_EARLY + NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY ) computed_total_early_jit, "
                strSql = strSql & " (SUM(NBR_VARBL_ON_TIME ) ) computed_total_on_time, "
                strSql = strSql & " SUM(NBR_JIT_ON_TIME ) computed_total_on_time_jit, "
                strSql = strSql & " SUM(NBR_VARBL_ONE_DAY_LATE + NBR_VARBL_TWO_DAYS_LATE + NBR_VARBL_THREE_DAYS_LATE + NBR_VARBL_FOUR_DAYS_LATE + NBR_VARBL_FIVE_DAYS_LATE + NBR_VARBL_SIX_DAYS_LATE + NBR_VARBL_OUT_RANGE_LATE ) computed_total_late, "
                strSql = strSql & " SUM(NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE + NBR_JIT_THREE_DAYS_LATE + NBR_JIT_FOUR_DAYS_LATE + NBR_JIT_FIVE_DAYS_LATE + NBR_JIT_SIX_DAYS_LATE + NBR_JIT_OUT_RANGE_LATE ) computed_total_late_jit  "
            End If
        Else 'std default
            
            'vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
            'vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
            
            If vntSmryType = "1" Then 'STS
                vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> All;"
                vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
                strSql = strSql & " SUM(TOTAL_NBR_SHPMTS) computed_total_nbr_shipments, "
                strSql = strSql & " SUM(TOTAL_NBR_JIT_SHPMTS) computed_total_jit_shipments, "

                If vntDaysEarly = "" Then
                    vntDaysEarly = 0
                End If
                
                If vntDaysLate = "" Then
                    vntDaysLate = 0
                End If
                'vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
                'vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"

                'Select Case vntDaysEarly
                '    Case 0
                '        
                '        strSql = strSql & " SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY ) computed_total_early, "
                '        strTemp1 = "NBR_SHPMTS_ON_TIME"
                '        strTemp2 = ""
                '    Case 1
                '        
                '        strSql = strSql & " (SUM(NBR_JIT_ONE_DAY_EARLY ) + SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY )) computed_total_early, "
                '        strTemp1 = "NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                '        strTemp2 = "NBR_JIT_ONE_DAY_EARLY "
                '    Case 2
                '        
                '        strSql = strSql & " (SUM(NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY ) + SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY )) computed_total_early, "
                '        strTemp1 = "NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                '        strTemp2 = "NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY"
                '    Case 3
                '        
                '        strSql = strSql & " (SUM(NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY ) + SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY )) computed_total_early, "
                '        strTemp1 = "NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                '        strTemp2 = "NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY"
                '    Case 4
                '        
                '        strSql = strSql & " (SUM(NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY ) + SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY )) computed_total_early, "
                '        strTemp1 = "NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                '        strTemp2 = "NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY"
                '    Case 5
                '        
                '        strSql = strSql & " (SUM(NBR_JIT_FIVE_DAYS_EARLY + NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY ) + SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY )) computed_total_early, "
                '        strTemp1 = "NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                '        strTemp2 = "NBR_JIT_FIVE_DAYS_EARLY + NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY"
                'End Select
                
                strSql = strSql & " SUM(NBR_JIT_OUT_RANGE_EARLY + NBR_JIT_SIX_DAYS_EARLY + NBR_JIT_FIVE_DAYS_EARLY + NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY ) computed_total_early, "
                strTemp1 = "NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                strTemp2 = "NBR_JIT_OUT_RANGE_EARLY + NBR_JIT_SIX_DAYS_EARLY + NBR_JIT_FIVE_DAYS_EARLY + NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY"

                strSql = strSql & " SUM(NBR_JIT_OUT_RANGE_EARLY + NBR_JIT_SIX_DAYS_EARLY + NBR_JIT_FIVE_DAYS_EARLY + NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY ) computed_total_early_jit, "

                Select Case vntDaysLate
                    Case 0
                        strTemp3 = " SUM(NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE ) computed_total_late, "
                        strTemp1 = strTemp1
                        strTemp2 = strTemp2
                    Case 1
                        strTemp3 = " (SUM(NBR_JIT_ONE_DAY_LATE ) + SUM(NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE )) computed_total_late, "
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE"
                        strTemp2 = strTemp2 & " + NBR_JIT_ONE_DAY_LATE"
                    Case 2
                        strTemp3 = " (SUM(NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE ) + SUM(NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE )) computed_total_late, "
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE"
                        strTemp2 = strTemp2 & " + NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE"
                    Case 3
                        strTemp3 = " (SUM(NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE + NBR_JIT_THREE_DAYS_LATE ) + SUM(NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE )) computed_total_late,"
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE"
                        strTemp2 = strTemp2 & " + NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE + NBR_JIT_THREE_DAYS_LATE"
                    Case 4
                        strTemp3 = " (SUM(NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE + NBR_JIT_THREE_DAYS_LATE + NBR_JIT_FOUR_DAYS_LATE ) + SUM(NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE )) computed_total_late,"
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE"
                        strTemp2 = strTemp2 & " + NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE + NBR_JIT_THREE_DAYS_LATE + NBR_JIT_FOUR_DAYS_LATE"
                    Case 5
                        strTemp3 = " (SUM(NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE + NBR_JIT_THREE_DAYS_LATE + NBR_JIT_FOUR_DAYS_LATE + NBR_JIT_FIVE_DAYS_LATE ) + SUM(NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE )) computed_total_late, "
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE"
                        strTemp2 = strTemp2 & " + NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE + NBR_JIT_THREE_DAYS_LATE + NBR_JIT_FOUR_DAYS_LATE + NBR_JIT_FIVE_DAYS_LATE"
                End Select
                
                'If vntDaysEarly = 0 And vntDaysLate = 0 Then
                '    
                '    'strSql = strSql & " (SUM(NBR_SHPMTS_ON_TIME ) ) computed_total_on_time, "
                'Else
                '    
                '    strSql = strSql & " (SUM(" & strTemp1 & ") - SUM(" & strTemp2 & ")) computed_total_on_time, "
                'End If
                strSql = strSql & " (SUM(" & strTemp1 & ") - SUM(" & strTemp2 & ")) computed_total_on_time, "
                strSql = strSql & " SUM(NBR_JIT_ON_TIME ) computed_total_on_time_jit, "
                strSql = strSql & strTemp3
                strSql = strSql & " SUM(NBR_JIT_ONE_DAY_LATE + NBR_JIT_TWO_DAYS_LATE + NBR_JIT_THREE_DAYS_LATE + NBR_JIT_FOUR_DAYS_LATE + NBR_JIT_FIVE_DAYS_LATE + NBR_JIT_SIX_DAYS_LATE + NBR_JIT_OUT_RANGE_LATE ) computed_total_late_jit  "
            Else
                strSql = strSql & " SUM(TOTAL_NBR_SHPMTS) computed_total_nbr_shipments, "
                strSql = strSql & " 0 computed_total_jit_shipments, "

                If vntSmryType = 3 Then
                    vntDaysEarly = 0
                    vntDaysLate = 0
                Else
                    vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
                    vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
                End If

                If vntDaysEarly = "" Then
                    vntDaysEarly = 0
                End If

                If vntDaysLate = "" Then
                    vntDaysLate = 0
                End If

                Select Case vntDaysEarly
                    Case 0
                        strSql = strSql & " SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY ) computed_total_early, "
                        strTemp1 = "NBR_SHPMTS_ON_TIME"
                    Case 1
                        strSql = strSql & " SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY ) computed_total_early, "
                        strTemp1 = "NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                    Case 2
                        strSql = strSql & " SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY ) computed_total_early, "
                        strTemp1 = "NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                    Case 3
                        strSql = strSql & " SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY ) computed_total_early, "
                        strTemp1 = "NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                    Case 4
                        strSql = strSql & " SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY ) computed_total_early, "
                        strTemp1 = "NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                    Case 5
                        strSql = strSql & " SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY ) computed_total_early, "
                        strTemp1 = "NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_ON_TIME"
                End Select

                strSql = strSql & " 0 computed_total_early_jit, "

                Select Case vntDaysLate
                    Case 0
                        strTemp3 = " SUM(NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE ) computed_total_late, "
                        strTemp1 = strTemp1
                    Case 1
                        strTemp3 = " SUM(NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE ) computed_total_late, "
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE"
                    Case 2
                        strTemp3 = " SUM(NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE ) computed_total_late, "
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE"
                    Case 3
                        strTemp3 = " SUM(NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE ) computed_total_late,"
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE"
                    Case 4
                        strTemp3 = " SUM(NBR_SHPMTS_FIVE_DAYS_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE ) computed_total_late,"
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE"
                    Case 5
                        strTemp3 = " SUM(NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE ) computed_total_late, "
                        strTemp1 = strTemp1 & " + NBR_SHPMTS_ONE_DAY_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE"
                End Select

                strSql = strSql & " (SUM(" & strTemp1 & ") ) computed_total_on_time, "
                strSql = strSql & " 0 computed_total_on_time_jit, "
                strSql = strSql & strTemp3
                strSql = strSql & " 0 computed_total_late_jit  "
            End If
        End If

        If vntCategoryId = 23 Then
            strSql = strSql & ", A.PRODUCT_LINE_CODE VIEWDESC3 "
        End If

        strSql = strSql & " FROM ORGANIZATIONS_DMN C "

        If vntCategoryId = "9" And vntViewId = "2" Then
            strSql = strSql & ", SCD_BLDG_PLANT_V B, "
            strSql = strSql & " BUILDING_LOCATION_SMRY A  "
        End If

        If vntCategoryId = "9" And vntViewId = "10" Then
            strSql = strSql & ", SCD_BLDG_PLANT_V B, "
            strSql = strSql & " MFG_CAMPUS_BLDG_SMRY A  "
        End If

        If vntCategoryId = "10" Then
            strSql = strSql & ", BUILDING_LOCATION_SMRY A  "
        End If

        If vntCategoryId = "13" And vntViewId = "6" Then
            'If vntStkMake = "" Then
            '    strSql = strSql & ", CNTRLR_PROD_LINE_SMRY A,  "
            'Else
            strSql = strSql & ", TEAM_ORG_SMRY A,  "
            'End If
            strSql = strSql & " ORGANIZATIONS_DMN D  "
        End If

        If vntCategoryId = "13" And vntViewId = "3" Then
            If vntSmryType = "1" Then
                strSql = strSql & ", CUSTOMER_ACCOUNT_SMRY_T1 A  "
            ElseIf vntSmryType = "2" Then
                strSql = strSql & ", CUSTOMER_ACCOUNT_SMRY_T2 A  "
            ElseIf vntSmryType = "3" Then
                strSql = strSql & ", CUSTOMER_ACCOUNT_SMRY_T3 A  "
            End If
        End If

        If vntCategoryId = "15" Then
            strSql = strSql & ", SCORECARD_TEAM B, "
            strSql = strSql & " TEAM_ORG_SMRY A  "
        End If

        If vntCategoryId = "16" Then
            If vntCntlrEmpNbr <> "" Then
                strSql = strSql & ", CNTRLR_PROD_LINE_SMRY A,  "
            Else
                strSql = strSql & ", TEAM_ORG_SMRY A,  "
            End If
            strSql = strSql & " ORGANIZATIONS_DMN D  "
        End If

        If vntCategoryId = "17" Then
            strSql = strSql & ", GBL_STOCK_MAKE_CODE B, "
            strSql = strSql & " TEAM_ORG_SMRY A  "
        End If

        If vntCategoryId = "18" Then
            strSql = strSql & ", GBL_PRODUCT_LINE B, "
            If vntStkMake = "" Then
                strSql = strSql & " CNTRLR_PROD_LINE_SMRY A  "
            Else
                strSql = strSql & " TEAM_ORG_SMRY A  "
            End If
        End If

        If vntCategoryId = "19" Then
            strSql = strSql & ", GBL_PRODUCT B, "
            strSql = strSql & " GED_PUBLIC_TABLE F, "
            If vntStkMake = "" Then
                strSql = strSql & " CNTRLR_PROD_LINE_SMRY A  "
            Else
                strSql = strSql & " TEAM_ORG_SMRY A  "
            End If
        End If

        If vntCategoryId = "20" Then
            strSql = strSql & ", GBL_INDUSTRY B,  "
            strSql = strSql & " INDUSTRY_CODE_SMRY A "
        End If

        If vntCategoryId = "21" Then
            strSql = strSql & ", GBL_INDUSTRY_BUSINESS B,  "
            If vntViewId = "9" Then
                strSql = strSql & " INDUSTRY_CODE_SMRY A "
            Else
                strSql = strSql & " PROFIT_CENTER_SMRY A "
            End If
        End If

        If vntCategoryId = "22" Then
            strSql = strSql & ", MFG_CAMPUS_BLDG_SMRY A  "
        End If

        If vntCategoryId = "23" Then
            strSql = strSql & ", MFG_CAMPUS_BLDG_SMRY A  "
        End If

        If vntCategoryId = "24" Then
            strSql = strSql & ", GBL_MGE_PROFIT_CENTERS B,  "
            strSql = strSql & " PROFIT_CENTER_SMRY A"
        End If

        If vntCategoryId = "25" Then
            strSql = strSql & ", GBL_BUSINESS_LINE_FUNCTION B, GBL_BUSINESS_LINE E, "
            strSql = strSql & " PROFIT_CENTER_SMRY A"
        End If

        If vntCategoryId = "26" Or vntCategoryId = "27" Then
            strSql = strSql & ", CODE_LOOKUPS B, "
            strSql = strSql & " BUILDING_LOCATION_SMRY A"
        End If

        If vntViewId = "10" Then
            strSql = strSql & " , ORGANIZATIONS_DMN D"
        End If

        strSql = strSql & " WHERE AMP_SHIPPED_MONTH BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"

        vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"
        
        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        strSql = strSql & " AND  C.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        
        If vntViewId = "10" Then
            strSql = strSql & " AND  D.LAYER" & vntMfgLevel & "_ORGANIZATION_ID = '" & vntMfgOrgId & "' "
            strSql = strSql & " AND  A.MFR_ORG_KEY_ID = D.ORGANIZATION_KEY_ID(+) "
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID(+) "
        Else
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID(+) "
        End If

        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                Else
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                End If
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
            Else
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
            End If
            '    If vntViewId = "10" Then
            '        If vntCurrentHist = "C" Then
            '            'strSql = strSql & " AND D.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
            '            strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
            '            strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
            '            strSql = strSql & " WHERE Y.ORGANIZATION_ID = A.MFR_ORG_KEY_ID) "
            '        Else
            '            strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
            '            strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
            '            strSql = strSql & " WHERE Y.ORGANIZATION_ID = A.MFR_ORG_KEY_ID) "
            '            'strSql = strSql & " AND (D.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
            '            'strSql = strSql & " AND D.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
            '        End If
            '    End If
        Else
            strSql = strSql & " AND C.RECORD_STATUS_CDE = 'C' "
            vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
        End If

        strSql = strSql & " AND  (A.DELIVERY_SMRY_TYPE = '" & vntSmryType & "')  "

        If vntCategoryId = "9" And vntViewId = "2" Then
            strSql = strSql & " AND (A.ACTUAL_SHIP_BUILDING_NBR =  B.BUILDING_ID(+)) "
            strSql = strSql & " AND (A.SOURCE_SYSTEM_ID =  B.SOURCE_SYSTEM_ID(+)) "
        End If

        If vntCategoryId = "9" And vntViewId = "10" Then
            strSql = strSql & " AND A.MFG_BUILDING_NBR = B.BUILDING_ID(+) "
        End If

        If vntCategoryId = "15" Then
            strSql = strSql & " AND (A.TEAM_CODE = B.TEAM_CODE(+)) "
            strSql = strSql & " AND A.ORGANIZATION_KEY_ID = B.TEAM_DIV_ORG_KEY_ID(+) "
        End If

        If (vntCategoryId = "13" And vntViewId = "6") Or vntCategoryId = "16" Then
            strSql = strSql & " AND A.CONTROLLER_UNIQUENESS_ID = d.ORGANIZATION_ID(+) "
            If vntCurrentHist <> "" Then

                If vntCurrentHist = "C" Then
                    'If vntCategoryId = 16 Then
                    '    strSql = strSql & " AND (D.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                    '    strSql = strSql & " or A.CONTROLLER_UNIQUENESS_ID = '*') "
                    'Else
                    strSql = strSql & " AND D.RECORD_STATUS_CDE(+) = '" & vntCurrentHist & "' "
                    'End If
                Else
                    'If vntCategoryId = 16 Then
                    '    If vntCurrentHist = "C" Then
                    '        strSql = strSql & " AND (D.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                    '        strSql = strSql & " or A.CONTROLLER_UNIQUENESS_ID = '*') "
                    '    End If
                    'Else
                    '    strSql = strSql & " AND D.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                    'End If
                    strSql = strSql & " AND (D.EFFECTIVE_FROM_DT(+) <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND D.EFFECTIVE_TO_DT(+) >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
            Else
                strSql = strSql & " AND D.RECORD_STATUS_CDE(+) = 'C' "
            End If
        End If

        If vntCategoryId = "17" Then
            strSql = strSql & " AND (SUBSTR(A.STOCK_MAKE_CODE,1,1) = B.STOCK_MAKE_CODE(+)) "
        End If

        If vntCategoryId = "18" Then
            strSql = strSql & " AND (A.PRODUCT_LINE_CODE = B.PRLN_CODE(+)) "
        End If

        If vntCategoryId = "19" Then
            strSql = strSql & " AND (A.PRODUCT_LINE_CODE = B.PROD_GLOBAL_PRLN_CODE (+)) "
            strSql = strSql & " AND (A.PRODUCT_CODE = B.PROD_CODE (+)) "
            strSql = strSql & " AND (F.ASOC_GLOBAL_ID(+) = A.PRODUCT_MANAGER_GLOBAL_ID) "
        End If

        If vntCategoryId = "20" Then
            strSql = strSql & " AND  A.INDUSTRY_CODE = B.INDUSTRY_CODE(+) "
        End If

        If vntCategoryId = "21" Then
            strSql = strSql & " AND  A.INDUSTRY_BUSINESS_CDE = B.GIB_INDUSTRY_BUSINESS_CODE(+) "
        End If

        'If vntCategoryId = 22 Then
        '    strSql = strSql & " AND  A.INDUSTRY_BUSINESS_CDE = B.GIB_INDUSTRY_BUSINESS_CODE(+) "
        'End If

        If vntCategoryId = "24" Then
            strSql = strSql & " AND A.PROFIT_CENTER_ABBR_NM = B.MGE_PROFIT_CENTER_ABBR_NM(+) "
        End If

        If vntCategoryId = "25" Then
            strSql = strSql & " AND A.PRODUCT_BUSNS_LINE_FNCTN_ID = B.BUSLN_FNCTN_ID(+) "
            strSql = strSql & " AND A.PRODUCT_BUSNS_LINE_ID = E.BUSLN_ID(+) "
        End If

        If vntCategoryId = "26" Then 'sales office
            strSql = strSql & " AND A.SALES_OFFICE_CDE = B.GENERIC_CDE(+) "
            strSql = strSql & " AND A.SOURCE_SYSTEM_ID = B.SOURCE_SYSTEM_ID(+) "
            strSql = strSql & " AND B.CODE_TYPE_ID(+) = 9 "
        End If

        If vntCategoryId = "27" Then 'sales group
            strSql = strSql & " AND A.SALES_GROUP_CDE = B.GENERIC_CDE(+) "
            strSql = strSql & " AND A.SOURCE_SYSTEM_ID = B.SOURCE_SYSTEM_ID(+) "
            strSql = strSql & " AND B.CODE_TYPE_ID(+) = 10 "
        End If

        If vntPlant <> "" Then
            strSql = strSql & " AND (ACTUAL_SHIP_BUILDING_NBR = '" & vntPlant & "')"
            vntDispCrit = vntDispCrit & " <strong>Plant/Blg:</strong> " & vntPlant & ";"
        End If

        If vntTeam <> "" Then
            strSql = strSql & " AND TEAM_CODE = '" & vntTeam & "'"
            vntDispCrit = vntDispCrit & " <strong>Team:</strong> " & vntTeam & ";"
        End If

        If vntStkMake <> "" Then
            vntLength = Len(vntStkMake)
            If vntCategoryId = "17" Then
                strSql = strSql & " AND substr(A.STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            Else
                strSql = strSql & " AND substr(STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Make Stock:</strong> " & vntStkMake & ";"
        End If

        If vntMrpGroupCde <> "" Then
            If InStr(vntMrpGroupCde, ",") > 0 Then
                strSql = strSql & " AND MRP_GROUP_CDE IN ( " & QuoteStr(vntMrpGroupCde) & " ) "
            Else
                strSql = strSql & " AND MRP_GROUP_CDE " & IIf(InStr(vntMrpGroupCde, "%") > 0, "LIKE '", "= '") & vntMrpGroupCde & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>MRP Group:</strong> " & vntMrpGroupCde & ";"
        End If

        If vntProdCde <> "" Then
            strSql = strSql & " AND PRODUCT_CODE = '" & vntProdCde & "'"
            vntDispCrit = vntDispCrit & " <strong>Product Code:</strong> " & vntProdCde & ";"
        End If

        If vntProdLne <> "" Then
            If InStr(vntProdLne, ",") > 0 Then
                strSql = strSql & " AND PRODUCT_LINE_CODE IN ( " & QuoteStr(vntProdLne) & " )"
            Else
                strSql = strSql & " AND PRODUCT_LINE_CODE = '" & vntProdLne & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Product Line:</strong> " & vntProdLne & ";"
        End If

        If vntMfgCampus <> "" Then
            strSql = strSql & " AND MFG_CAMPUS_ID = '" & vntMfgCampus & "'"
            vntDispCrit = vntDispCrit & " <strong>Mfg Campus:</strong> " & vntMfgCampus & ";"
        End If

        If vntMfgBuilding <> "" Then
            strSql = strSql & " AND MFG_BUILDING_NBR = '" & vntMfgBuilding & "'"
            vntDispCrit = vntDispCrit & " <strong>Mfg Building:</strong> " & vntMfgBuilding & ";"
        End If

        If vntCntlrEmpNbr <> "" Then
            strSql = strSql & " AND PRODCN_CNTRLR_EMPLOYEE_NBR = '" & vntCntlrEmpNbr & "' "
            vntDispCrit = vntDispCrit & " <strong>Controller Emp Nbr:</strong> " & vntCntlrEmpNbr & ";"
        End If

        If vntInvOrg <> "" Then
            If InStr(vntInvOrg, ",") > 0 Then
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID IN ( " & QuoteStr(vntInvOrg) & " ) "
            Else
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID " & IIf(InStr(vntInvOrg, "%") > 0, "LIKE '", "= '") & vntInvOrg & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Inv Org/Plant:</strong> " & vntInvOrg & ";"
        End If

        If vntController <> "" Then
            If InStr(vntController, ",") > 0 Then
                strSql = strSql & " AND PRODCN_CNTRLR_CODE IN ( " & QuoteStr(vntController) & " ) "
            Else
                strSql = strSql & " AND PRODCN_CNTRLR_CODE " & IIf(InStr(vntController, "%") > 0, "LIKE '", "= '") & vntController & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Controller:</strong> " & vntController & ";"
        End If

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        If vntIC <> "" Then
            If InStr(vntIC, ",") > 0 Then
                strSql = strSql & " AND A.INDUSTRY_CODE IN ( " & QuoteStr(vntIC) & " ) "
            Else
                strSql = strSql & " AND A.INDUSTRY_CODE LIKE '" & vntIC & "%' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry:</strong> " & vntIC & ";"
        End If

        If vntIBC <> "" Then
            If InStr(vntIBC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_BUSINESS_CDE IN ( " & QuoteStr(vntIBC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_BUSINESS_CDE = '" & vntIBC & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry Business:</strong> " & vntIBC & ";"
        End If

        If vntShipTo <> "" Then
            vntTemp2 = vntShipTo
            intCountST = 0
            vntTemp = ""
            vntShipTo = Replace(vntShipTo, "-", "")

            If Len(vntShipTo) < 10 Then
                For intCountST = 1 To 10 - Len(vntShipTo)
                    vntTemp = "0" & vntTemp
                Next
                vntShipTo = vntTemp & vntShipTo
            End If

            If Len(vntShipTo) > 10 Then
                Err.Raise(901, , "Ship To Number is invalid.  These numbers are required to have 10 characters")
            Else
                strSql = strSql & " AND PURCHASE_BY_ACCOUNT_BASE = '" & Left(vntShipTo, 8) & "'"
                strSql = strSql & " AND SHIP_TO_ACCOUNT_SUFFIX = '" & Right(vntShipTo, 2) & "'"
            End If

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntWWCust <> "" Then
            vntTemp2 = vntWWCust
            intFound = 0
            vntTempWW = ""
            vntTempWW2 = ""
            intCountWW = 0

            intFound = InStr(vntWWCust, "-")
            If intFound <> 0 Then
                vntTempWW = Left(vntWWCust, intFound - 1)
                vntTempWW2 = Right(vntWWCust, Len(vntWWCust) - intFound)
            Else
                If Len(vntWWCust) > 10 Then
                    Err.Raise(901, , "WorldWide Number is invalid.  These numbers are required to have a maximum of 10 characters")
                ElseIf Len(vntWWCust) <= 8 Then
                    vntTempWW = vntWWCust
                ElseIf Len(vntWWCust) = 9 Then
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 1)
                Else
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 2)
                End If
            End If

            If Len(vntTempWW) < 8 Then
                For intCountWW = 1 To 8 - Len(vntTempWW)
                    vntTemp = vntTemp & "0"
                Next
                vntWWCust = vntTemp & vntTempWW
            Else
                vntWWCust = vntTempWW
            End If

            If Len(vntTempWW2) = 1 Then
                vntTempWW2 = "0" & vntTempWW2
                vntWWCust = vntWWCust & vntTempWW2
            Else
                vntWWCust = vntWWCust & vntTempWW2
            End If

            If Len(vntWWCust) > 8 Then
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
                strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
            Else
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
            End If

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        'If vntWWCust <> "" Then
        '    If Len(vntWWCust) > 8 Then
        '        strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
        '        strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
        '    Else
        '        strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
        '    End If
        '    vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntWWCust & ";"
        'End If

        If vntCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_ID = '" & vntCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Competency Business:</strong> " & vntCBC & ";"
        End If

        If vntSubCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_FNCTN_ID = '" & vntSubCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Sub-Competency Business:</strong> " & vntSubCBC & ";"
        End If

        If vntProfit <> "" Then
            strSql = strSql & " AND PROFIT_CENTER_ABBR_NM = '" & vntProfit & "' "
            vntDispCrit = vntDispCrit & " <strong>Profit Center:</strong> " & vntProfit & ";"
        End If

        If vntProdMgr <> "" Then
            strSql = strSql & ParseProdMgr(vntProdMgr)
            vntDispCrit = vntDispCrit & " <strong>Product Mgr:</strong> " & vntProdMgr & ";"
        End If

        If vntSalesOffice <> "" Then
            If InStr(vntSalesOffice, ",") > 0 Then
                strSql = strSql & " AND A.SALES_OFFICE_CDE IN ( " & QuoteStr(vntSalesOffice) & " ) "
            Else
                strSql = strSql & " AND A.SALES_OFFICE_CDE " & IIf(InStr(vntSalesOffice, "%") > 0, "LIKE '", "= '") & vntSalesOffice & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Office:</strong> " & vntSalesOffice & ";"
        End If

        If vntacctOrgKey <> "" Then
            strSql = strSql & " AND ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey
        End If

        If vntSoldTo <> "" Then
            vntTemp2 = vntSoldTo
            intCountST = 0
            vntTemp = ""
            
            vntSoldTo = Replace(vntSoldTo, "-", "")
            If Len(vntSoldTo) < 8 Then
                For intCountST = 1 To 8 - Len(vntSoldTo)
                    vntTemp = "0" & vntTemp
                Next
                vntSoldTo = vntTemp & vntSoldTo
            End If
            If Len(vntSoldTo) > 8 Then
                Err.Raise(901, , "Sold To Number is invalid.  These numbers are required to have 8 characters")
            Else
                strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
            End If

            blnrc = objGetSoldToName.RetrieveName(vntCustOrg, vntSoldTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetSoldToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        'If vntSoldTo <> "" Then
        '    vntSoldTo = Replace(vntSoldTo, "-", "")
        '    If Len(vntSoldTo) < 10 Then
        '        vntSoldTo = vntSoldTo & "00"
        '    End If
        '    strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
        '    vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntSoldTo & ";"
        'End If

        If vntCategoryId = "9" And vntViewId = "2" Then
            strSql = strSql & " GROUP BY  A.ACTUAL_SHIP_BUILDING_NBR, "
            strSql = strSql & " B.BUILDING_NM,  "
            strSql = strSql & " C.ORGANIZATION_ID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "9" And vntViewId = "10" Then
            strSql = strSql & " GROUP BY  A.MFG_BUILDING_NBR, "
            strSql = strSql & " B.BUILDING_NM,  "
            strSql = strSql & " D.ORGANIZATION_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "10" Then
            strSql = strSql & " GROUP BY  A.ACTUAL_SHIP_LOCATION, "
            strSql = strSql & " C.ORGANIZATION_ID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "13" And vntViewId = "3" Then
            strSql = strSql & " GROUP BY  C.ORGANIZATION_ID,  "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM "
        End If

        If vntCategoryId = "13" And vntViewId = "6" Then
            strSql = strSql & " GROUP BY  A.CONTROLLER_UNIQUENESS_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM "
        End If

        If vntCategoryId = "15" Then
            strSql = strSql & " GROUP BY  A.TEAM_CODE, "
            strSql = strSql & " B.ABBRD_DESC,  "
            strSql = strSql & " C.ORGANIZATION_ID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "16" Then
            strSql = strSql & " GROUP BY  A.CONTROLLER_UNIQUENESS_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM , "
            strSql = strSql & " A.PRODCN_CNTRLR_CODE  "
        End If

        If vntCategoryId = "17" Then
            strSql = strSql & " GROUP BY  A.STOCK_MAKE_CODE, "
            strSql = strSql & " B.STOCK_MAKE_DSCRPTN "
        End If

        If vntCategoryId = "18" Then
            strSql = strSql & " GROUP BY  A.PRODUCT_LINE_CODE, "
            strSql = strSql & " B.PRLN_SHORT_NAME  "
        End If

        If vntCategoryId = "19" Then
            strSql = strSql & " GROUP BY  A.PRODUCT_LINE_CODE, "
            strSql = strSql & " A.PRODUCT_CODE,  "
            strSql = strSql & " B.PROD_SHORT_NAME  "
            strSql = strSql & " ,F.FIRST_NAME||DECODE(F.MIDDLE_INITIAL,NULL,'',' '||F.MIDDLE_INITIAL)||' '||F.LAST_NAME "
        End If

        If vntCategoryId = "20" Then
            strSql = strSql & " GROUP BY  A.INDUSTRY_CODE, "
            strSql = strSql & " B.INDUSTRY_NAME "
        End If

        If vntCategoryId = "21" Then
            strSql = strSql & " GROUP BY  A.INDUSTRY_BUSINESS_CDE, "
            strSql = strSql & " B.GIB_SHORT_NAME "
        End If

        If vntCategoryId = "22" Then
            strSql = strSql & " GROUP BY  A.MFG_CAMPUS_ID, "
            strSql = strSql & " D.ORGANIZATION_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "23" Then
            strSql = strSql & " GROUP BY  A.MFG_CAMPUS_ID, "
            strSql = strSql & " A.MFG_BUILDING_NBR, "
            strSql = strSql & " A.PRODUCT_LINE_CODE, "
            strSql = strSql & " D.ORGANIZATION_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "24" Then
            strSql = strSql & " GROUP BY  A.PROFIT_CENTER_ABBR_NM, "
            strSql = strSql & " B.MGE_PROFIT_CENTER_DESC "
        End If

        If vntCategoryId = "25" Then
            strSql = strSql & " GROUP BY  A.PRODUCT_BUSNS_LINE_ID, E.BUSLN_DSCRPTN, "
            strSql = strSql & " A.PRODUCT_BUSNS_LINE_FNCTN_ID, B.BUSLN_FNCTN_SHORT_NAME "
        End If

        If vntCategoryId = "26" Then
            strSql = strSql & " GROUP BY A.SALES_OFFICE_CDE, B.CODE_NM, A.ACTUAL_SHIP_BUILDING_NBR "
        End If

        If vntCategoryId = "27" Then
            strSql = strSql & " GROUP BY A.SALES_OFFICE_CDE, A.SALES_GROUP_CDE, B.CODE_NM, A.ACTUAL_SHIP_BUILDING_NBR "
        End If

        strSql = strSql & " ORDER BY "
        
        If vntCategoryId = "17" Or vntCategoryId = "18" Or vntCategoryId = "20" Or vntCategoryId = "21" Then
            strSql = strSql & "VIEWDESC1 ASC"
        ElseIf vntCategoryId = "13" Then
            strSql = strSql & "ORGID ASC"
        ElseIf vntCategoryId = "19" Or vntCategoryId = "16" Or vntCategoryId = "25" Or vntCategoryId = "26" Or vntCategoryId = "27" Then
            strSql = strSql & "ORGID ASC, VIEWDESC1 ASC "
        ElseIf vntCategoryId = "23" Then
            strSql = strSql & "VIEWDESC1 ASC, VIEWDESC2 ASC, VIEWDESC3,ORGID ASC, ORGNAME ASC "
        ElseIf vntCategoryId = "24" Then  'Or vntCategoryId = 25 Then
            strSql = strSql & "VIEWDESC1 ASC, VIEWDESC2 ASC "
        ElseIf vntCategoryId = "15" Then
            strSql = strSql & "ORGID ASC,VIEWDESC1 ASC "
        Else
            strSql = strSql & "VIEWDESC1 ASC, ORGID ASC"
        End If

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsResults.ListGeneral call to CallRS for Main Results")
        End If

        If vntCount > 0 Then
            '
            'If vntCategoryId = "17" Or vntCategoryId = "18" Or vntCategoryId = "20" Or vntCategoryId = "21" Then
            '    
            '    objList.Sort = "VIEWDESC1 ASC"
            '    
            'ElseIf vntCategoryId = "13" Then
            '    
            '    objList.Sort = "ORGID ASC"
            '    
            'ElseIf vntCategoryId = "19" Or vntCategoryId = "16" Or vntCategoryId = "25" Or vntCategoryId = "26" Or vntCategoryId = "27" Then
            '    
            '    objList.Sort = "ORGID ASC, VIEWDESC1 ASC "
            '    
            'ElseIf vntCategoryId = "23" Then
            '    
            '    objList.Sort = "VIEWDESC1 ASC, VIEWDESC2 ASC, VIEWDESC3,ORGID ASC, ORGNAME ASC "
            '    
            'ElseIf vntCategoryId = "24" Then  'Or vntCategoryId = 25 Then
            '    
            '    objList.Sort = "VIEWDESC1 ASC, VIEWDESC2 ASC "
            '    
            'ElseIf vntCategoryId = "15" Then
            '    
            '    objList.Sort = "ORGID ASC,VIEWDESC1 ASC "
            'Else
            '    
            '    objList.Sort = "VIEWDESC1 ASC, ORGID ASC"
            'End If

            'ReDim vntArray(objList.Fields.Count + 1, 0)
            ReDim vntArray(UBound(objList, 1) + 2, 0)
            vntTempArray = objList

            For intCount = 0 To UBound(vntTempArray, 2)
                vntArray(0, 0) = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntTempArray(4, intCount)), "#,###,##0") 'Total Schds
                vntArray(1, 0) = VB6.Format(CDbl(vntArray(1, 0)) + CDbl(vntTempArray(6, intCount)), "#,###,##0") 'Total Early
                vntArray(3, 0) = VB6.Format(CDbl(vntArray(3, 0)) + CDbl(vntTempArray(8, intCount)), "#,###,##0") 'Total On Time
                vntArray(5, 0) = VB6.Format(CDbl(vntArray(5, 0)) + CDbl(vntTempArray(10, intCount)), "#,###,##0") 'Total Late
                vntArray(7, 0) = VB6.Format(CDbl(vntArray(7, 0)) + CDbl(vntTempArray(5, intCount)), "#,###,##0") 'Total JIT Schds
                vntArray(8, 0) = VB6.Format(CDbl(vntArray(8, 0)) + CDbl(vntTempArray(7, intCount)), "#,###,##0") 'Total JIT Early
                vntArray(10, 0) = VB6.Format(CDbl(vntArray(10, 0)) + CDbl(vntTempArray(9, intCount)), "#,###,##0") 'Total On Time
                vntArray(12, 0) = VB6.Format(CDbl(vntArray(12, 0)) + CDbl(vntTempArray(11, intCount)), "#,###,##0") 'Total Late
            Next
            
            If vntArray(0, 0) <> 0 Then
                vntArray(2, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(1, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'Early
                vntArray(4, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(3, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'On Time
                vntArray(6, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(5, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'Late
            Else
                vntArray(2, 0) = 0 'Early
                vntArray(4, 0) = 0 'On Time
                vntArray(6, 0) = 0 'Late
            End If

            If vntArray(0, 0) <> 0 Then
                vntArray(9, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(8, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'JIT Early
                vntArray(11, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(10, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'Jit On Time
                vntArray(13, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(12, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'JIT Late
            Else
                vntArray(9, 0) = 0 'JIT Early
                vntArray(11, 0) = 0 'Jit On Time
                vntArray(13, 0) = 0 'JIT Late
            End If
            ListGeneral = vntTempArray
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListGeneral = System.DBNull.Value
        End If
        
        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListGeneral = System.DBNull.Value
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        Exit Function
	End Function
	
	Public Function ListGeneralDly(ByVal vntSessionID As Object, ByVal vntGetTotal As Object, ByVal vntPage As Object, ByVal vntExport As Object, ByRef vntCount As Object, ByRef vntRecsLeft As Object, ByRef vntExtTotal As Object, ByRef vntLocalTotal As Object, ByRef vntSmryType As Object, ByRef vntArray As Object, ByRef vntDispCrit As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim objSearch As New clsSearch
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
		Dim vntTempArray As Object
        'Dim intPageCount As Short
        'Dim intRecsLeft As Short
        'Dim intCount As Short
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntWindowId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgID As Object
        'Dim vntDaysEarly As Object
        'Dim vntDaysLate As Object
        'Dim vntMonthDailyInd As Object
        'Dim vntCustAcctTypeCde As Object
        'Dim vntPart As Object
        'Dim vntPlant As Object
        'Dim vntLocation As Object
        'Dim vntacctOrgKey As Object
        'Dim vntShipTo As Object
        'Dim vntSoldTo As Object
        'Dim vntWWCust As Object
        'Dim vntInvOrg As Object
        'Dim vntController As Object
        'Dim vntCntlrEmpNbr As Object
        'Dim vntStkMake As Object
        'Dim vntTeam As Object
        'Dim vntProdCde As Object
        'Dim vntProdLne As Object
        'Dim vntIBC As Object
        'Dim vntIC As Object
        'Dim vntMfgCampus As Object
        'Dim vntMfgBuilding As Object
        'Dim vntComparisonType As Object
        'Dim vntOpenShpOrder As Object
        'Dim vntProfit As Object
        'Dim vntCBC As Object
        'Dim vntSubCBC As Object
        'Dim vntOrgDate As Object
        'Dim vntLevel As Object
        'Dim vntKeyId As Object
        'Dim vntOrgType As Object
        'Dim vntLength As Object
        Dim strTemp1 As String = ""
        Dim strTemp2 As String = ""
        Dim strTemp3 As String = ""
        'Dim vntOrgTypeDesc As Object
        'Dim intCountST As Short
        'Dim vntTemp As Object
        'Dim vntTempWW As Object
        'Dim vntTempWW2 As Object
        'Dim intCountWW As Short
        'Dim intFound As Short
        '      Dim objGetWWName As New clsWrldWide
        '      Dim objGetShipToName As New clsShipTo
        '      Dim objGetSoldToName As New clsSoldTo
        'Dim vntName As Object
        'Dim vntTemp2 As Object
        'Dim vntCustOrg As Object
        'Dim vntProdMgr As Object
        'Dim vntLeadTimeType As Object
        'Dim vntSalesOffice As Object
        'Dim vntSalesGroup As Object
        'Dim vntMfgOrgType As Object
        'Dim vntMfgOrgId As Object
        'Dim vntMfgLevel As Object
        'Dim GamAccount As Object
        'Dim vntPartKeyID As Object
        'Dim vntMrpGroupCde As Object
        'Dim vntHostOrgID As Object
        Dim intPageCount As Integer
        Dim intRecsLeft As Integer
        Dim intCount As Integer
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntWindowId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
        'Dim vntSmryType As String = ""
        Dim vntCurrentHist As String = ""
        Dim vntOrgID As String = ""
        Dim vntOrgKeyId As String = ""
        Dim vntDaysEarly As String = ""
        Dim vntDaysLate As String = ""
        Dim vntMonthDailyInd As String = ""
        Dim vntCustAcctTypeCde As String = ""
        Dim vntPart As String = ""
        Dim vntPlant As String = ""
        Dim vntLocation As String = ""
        Dim vntacctOrgKey As String = ""
        Dim vntShipTo As String = ""
        Dim vntSoldTo As String = ""
        Dim vntWWCust As String = ""
        Dim vntInvOrg As String = ""
        Dim vntController As String = ""
        Dim vntCntlrEmpNbr As String = ""
        Dim vntStkMake As String = ""
        Dim vntTeam As String = ""
        Dim vntProdCde As String = ""
        Dim vntProdLne As String = ""
        Dim vntIBC As String = ""
        Dim vntIC As String = ""
        Dim vntMfgCampus As String = ""
        Dim vntMfgBuilding As String = ""
        Dim vntComparisonType As String = ""
        Dim vntOpenShpOrder As String = ""
        Dim vntProfit As String = ""
        Dim vntCBC As String = ""
        Dim vntSubCBC As String = ""
        Dim vntOrgDate As String = ""
        Dim vntLevel As String = ""
        Dim vntKeyId As Long
        'Dim vntTempArray As Object
        Dim vntOrgType As String = ""
        Dim vntLength As Integer
        Dim vntOrgTypeDesc As String = ""
        Dim intCountST As Integer
        Dim vntTemp As String = ""
        Dim vntTempWW As String = ""
        Dim vntTempWW2 As String = ""
        Dim intCountWW As Integer
        Dim intFound As Integer
        Dim objGetWWName As New clsWrldWide
        Dim objGetShipToName As New clsShipTo
        Dim objGetSoldToName As New clsSoldTo
        Dim vntName As String = ""
        Dim vntTemp2 As String = ""
        Dim vntCustOrg As String = ""
        Dim vntProdMgr As String = ""
        Dim vntLeadTimeType As String = ""
        Dim vntSalesOffice As String = ""
        Dim vntSalesGroup As String = ""
        Dim vntMfgOrgType As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgLevel As String = ""
        Dim GamAccount As String = ""
        Dim vntPartKeyID As String = ""
        Dim vntMrpGroupCde As String = ""
        Dim vntHostOrgID As String = ""

		On Error GoTo ErrorHandler
		
        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResults.ListConfNonConf")
        End If
		
        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDate, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNumber, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        
        If Not blnrc Or vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsSearch.RetrieveSession")
        End If

        If vntWindowId = 2 And vntSmryType <> 3 Then
            If vntDaysEarly = "" Then vntDaysEarly = 0
            If vntDaysEarly > 5 Or vntDaysLate > 5 Then
                Err.Raise(9921, , "Days Early or Days Late was entered greater than 5 in clsResults.ListGeneral")
            End If
        End If

        If vntOrgID <> "" Then
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If
            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"

            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDate, vntLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel")
            End If
            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
        End If

        If vntMfgOrgId <> "" Then
            blnrc = objOrgs.RetrieveType(vntMfgOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If
            vntDispCrit = vntDispCrit & "<strong> Mfg Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Mfg Org ID:</strong> " & vntMfgOrgId & ";"

            blnrc = objOrgs.RetrieveLevel(vntMfgOrgId, vntCurrentHist, vntOrgDate, vntMfgLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListGeneralDly")
            End If
            If Len(vntMfgLevel) > 6 Then
                vntMfgLevel = Right(vntMfgLevel, 2)
            Else
                vntMfgLevel = Right(vntMfgLevel, 1)
            End If
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org ID:</strong> " & vntacctOrgKey & ";"
            
            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDate, vntKeyId, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If
            vntacctOrgKey = vntKeyId
        End If

        If vntCategoryId = 9 And vntViewId = 2 Then
            strSql = " SELECT C.ORGANIZATION_ID ORGID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & " A.ACTUAL_SHIP_BUILDING_NBR VIEWDESC1, "
            strSql = strSql & " B.BUILDING_NM VIEWDESC2, "
        End If

        If vntCategoryId = "9" And vntViewId = "10" Then
            strSql = " SELECT D.ORGANIZATION_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & " A.MFG_BUILDING_NBR VIEWDESC1, "
            strSql = strSql & " B.BUILDING_NM VIEWDESC2, "
        End If

        If vntCategoryId = "10" Then
            strSql = " SELECT C.ORGANIZATION_ID ORGID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & "  A.ACTUAL_SHIP_LOCATION VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "13" And vntViewId = "3" Then 'Cust/WorldWide
            strSql = " SELECT C.ORGANIZATION_ID ORGID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & " NULL VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "13" And vntViewId = "6" Then 'Controller
            strSql = " SELECT  A.CONTROLLER_UNIQUENESS_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME, "
            strSql = strSql & " NULL VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "15" Then
            strSql = " SELECT C.ORGANIZATION_ID ORGID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & " A.TEAM_CODE VIEWDESC1, "
            strSql = strSql & " B.ABBRD_DESC VIEWDESC2, "
        End If

        
        If vntCategoryId = "16" Then
            strSql = " SELECT  A.CONTROLLER_UNIQUENESS_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME, "
            strSql = strSql & " A.PRODCN_CNTRLR_CODE VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "17" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.STOCK_MAKE_CODE VIEWDESC1, "
            strSql = strSql & " B.STOCK_MAKE_DSCRPTN VIEWDESC2, "
        End If

        If vntCategoryId = "18" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.PRODUCT_LINE_CODE VIEWDESC1, "
            strSql = strSql & " B.PRLN_SHORT_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "19" Then
            strSql = " SELECT  A.PRODUCT_LINE_CODE ORGID, "
            strSql = strSql & " F.FIRST_NAME||DECODE(F.MIDDLE_INITIAL,NULL,'',' '||F.MIDDLE_INITIAL)||' '||F.LAST_NAME PRODMGRNAME, "
            strSql = strSql & " A.PRODUCT_CODE VIEWDESC1, "
            strSql = strSql & " B.PROD_SHORT_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "20" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.INDUSTRY_CODE VIEWDESC1, "
            strSql = strSql & " B.INDUSTRY_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "21" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.INDUSTRY_BUSINESS_CODE VIEWDESC1, "
            strSql = strSql & " B.GIB_SHORT_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "22" Then
            strSql = " SELECT D.ORGANIZATION_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & "  A.MFG_CAMPUS_ID VIEWDESC1, "
            strSql = strSql & " NULL VIEWDESC2, "
        End If

        If vntCategoryId = "23" Then
            strSql = " SELECT D.ORGANIZATION_ID ORGID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM ORGNAME,  "
            strSql = strSql & "  A.MFG_CAMPUS_ID VIEWDESC1, "
            strSql = strSql & " A.MFG_BUILDING_NBR VIEWDESC2, "
        End If

        If vntCategoryId = "24" Then
            strSql = " SELECT  NULL ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " A.PROFIT_CENTER_ABBR_NM VIEWDESC1, "
            strSql = strSql & " B.MGE_PROFIT_CENTER_DESC VIEWDESC2, "
        End If

        If vntCategoryId = "25" Then
            strSql = " SELECT  A.PRODUCT_BUSNS_LINE_ID ORGID, "
            strSql = strSql & " E.BUSLN_DSCRPTN ORGNAME, "
            strSql = strSql & " A.PRODUCT_BUSNS_LINE_FNCTN_ID VIEWDESC1, "
            strSql = strSql & " B.BUSLN_FNCTN_SHORT_NAME VIEWDESC2, "
        End If

        If vntCategoryId = "26" Then
            strSql = " SELECT  A.SALES_OFFICE_CDE ORGID, "
            strSql = strSql & " NULL ORGNAME, "
            strSql = strSql & " B.CODE_NM VIEWDESC1, "
            strSql = strSql & " A.ACTUAL_SHIP_BUILDING_NBR VIEWDESC2, "
        End If

        If vntCategoryId = "27" Then
            strSql = " SELECT  A.SALES_OFFICE_CDE ORGID, "
            strSql = strSql & " A.ACTUAL_SHIP_BUILDING_NBR ORGNAME, "
            strSql = strSql & " A.SALES_GROUP_CDE VIEWDESC1, "
            strSql = strSql & " B.CODE_NM VIEWDESC2, "
        End If

        Select Case vntSmryType
            Case "1"
                vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
            Case "2"
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
            Case "3"
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request to Schedule;"
        End Select

        If vntWindowId = "1" Then 'Customer variable
            If vntSmryType = "2" Then 'Request to Ship
                strSql = strSql & " NVL(COUNT(*), 0) computed_total_nbr_shipments, "
                strSql = strSql & " 0 computed_total_jit_shipments, "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(VARBL_REQUEST_SHIP_VARIANCE, -999), LEAST(VARBL_REQUEST_SHIP_VARIANCE, -1),1)), 0) computed_total_early, "
                strSql = strSql & " 0 computed_total_early_jit, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 0, 1)), 0) computed_total_on_time, "
                strSql = strSql & " 0 computed_total_on_time_jit, "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(VARBL_REQUEST_SHIP_VARIANCE, 1), LEAST(VARBL_REQUEST_SHIP_VARIANCE, 999),1)), 0) computed_total_late, "
                strSql = strSql & " 0 computed_total_late_jit  "
            Else 'Sched to Ship
                strSql = strSql & " NVL(COUNT(*), 0) computed_total_nbr_shipments, "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', 1)), 0) computed_total_jit_shipments, "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, -999), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, -1),1)), 0) computed_total_early, "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, -999), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, -1), 1))), 0) computed_total_early_jit, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 0, 1)), 0) computed_total_on_time, "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 0, 1))), 0) computed_total_on_time_jit, "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, 1), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, 999),1)), 0) computed_total_late, "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, 1), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, 999), 1))), 0) computed_total_late_jit  "
            End If
        Else 'Standard Default
            'vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
            'vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
            
            If vntSmryType = "1" Then 'Standard Default (3) Sched to Ship
                vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> All;"
                vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
                
                strSql = strSql & " NVL(COUNT(*), 0) computed_total_nbr_shipments, "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', 1)), 0) computed_total_jit_shipments, "

                If vntDaysEarly = "" Then
                    vntDaysEarly = 0
                End If
                
                If vntDaysLate = "" Then
                    vntDaysLate = 0
                End If

                'Select Case vntDaysEarly
                '    Case 0
                '        
                '        strSql = strSql & " NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -1),1)), 0) computed_total_early, "
                '        strTemp1 = "NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 0, 1)), 0)"
                '        strTemp2 = ""
                '    Case 1
                '        
                '        strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -1, 1))), 0) + NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -2),1)), 0) computed_total_early, "
                '        strTemp1 = "NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -1, 1)), 0) + NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 0, 1)), 0)"
                '        strTemp2 = "NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -1, 1))), 0) "
                '    Case Else
                '        
                '        
                '        strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE," & -vntDaysEarly & "), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -1), 1))), 0) + NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE," & -(vntDaysEarly + 1) & "),1)), 0) computed_total_early, "
                '        
                '        strTemp1 = "NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE," & -vntDaysEarly & "), LEAST(SCHEDULE_TO_SHIP_VARIANCE, 0),1)), 0)"
                '        
                '        strTemp2 = "NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE," & -vntDaysEarly & "), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -1), 1))), 0)"
                'End Select
                
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -1), 1))), 0) computed_total_early, "
                strTemp1 = " NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -1),1)), 0) + NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 0, 1)), 0) "
                strTemp2 = " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -1), 1))), 0) "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -1), 1))), 0) computed_total_early_jit, "

                Select Case vntDaysLate
                    Case 0
                        strTemp3 = " NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 1), LEAST(SCHEDULE_TO_SHIP_VARIANCE, 999),1)), 0) computed_total_late, "
                        strTemp1 = strTemp1
                        strTemp2 = strTemp2
                    Case 1
                        strTemp3 = " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 1, 1))), 0) + NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 2), LEAST(SCHEDULE_TO_SHIP_VARIANCE, 999),1)), 0) computed_total_late, "
                        strTemp1 = strTemp1 & " + NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 1, 1)), 0)"
                        strTemp2 = strTemp2 & " + NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 1, 1))), 0)"
                    Case Else
                        strTemp3 = " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 1), LEAST(SCHEDULE_TO_SHIP_VARIANCE," & vntDaysLate & "), 1))), 0) + NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE," & vntDaysLate + 1 & "), LEAST(SCHEDULE_TO_SHIP_VARIANCE, 999),1)), 0) computed_total_late, "
                        strTemp1 = strTemp1 & " + NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 1), LEAST(SCHEDULE_TO_SHIP_VARIANCE," & vntDaysLate & "),1)), 0)"
                        strTemp2 = strTemp2 & " + NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 1), LEAST(SCHEDULE_TO_SHIP_VARIANCE," & vntDaysLate & "), 1))), 0)"
                End Select

                'If vntDaysEarly = 0 And vntDaysLate = 0 Then
                '    
                '    strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 0, 1)), 0) computed_total_on_time, "
                'Else
                '    
                '    strSql = strSql & "(" & strTemp1 & ") - (" & strTemp2 & ") computed_total_on_time, "
                'End If

                strSql = strSql & "(" & strTemp1 & ") - (" & strTemp2 & ") computed_total_on_time, "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 0, 1))), 0) computed_total_on_time_jit, "
                strSql = strSql & strTemp3
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 1), LEAST(SCHEDULE_TO_SHIP_VARIANCE, 999), 1))), 0) computed_total_late_jit  "

            ElseIf vntSmryType = "2" Then  'Standard Default (2) Request To Ship
                vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
                vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
                
                strSql = strSql & " NVL(COUNT(*), 0) computed_total_nbr_shipments, "
                strSql = strSql & " 0 computed_total_jit_shipments, "

                If vntSmryType = "3" Then
                    vntDaysEarly = 0
                    vntDaysLate = 0
                End If
                
                If vntDaysEarly = "" Then
                    vntDaysEarly = 0
                End If
                
                If vntDaysLate = "" Then
                    vntDaysLate = 0
                End If

                strSql = strSql & " NVL(SUM(DECODE(GREATEST(REQUEST_TO_SHIP_VARIANCE, -999), LEAST(REQUEST_TO_SHIP_VARIANCE," & -(vntDaysEarly + 1) & "),1)), 0) computed_total_early, "

                Select Case vntDaysEarly
                    Case 0
                        strTemp1 = ""
                    Case 1
                        strTemp1 = "NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -1, 1)), 0) + "
                    Case Else
                        strTemp1 = "NVL(SUM(DECODE(GREATEST(REQUEST_TO_SHIP_VARIANCE," & -vntDaysEarly & "), LEAST(REQUEST_TO_SHIP_VARIANCE, -1),1)), 0) + "
                End Select

                strSql = strSql & " 0 computed_total_early_jit, "
                strTemp1 = strTemp1 & "NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 0, 1)), 0)"
                strTemp3 = " NVL(SUM(DECODE(GREATEST(REQUEST_TO_SHIP_VARIANCE," & vntDaysLate + 1 & "), LEAST(REQUEST_TO_SHIP_VARIANCE, 999),1)), 0) computed_total_late, "

                Select Case vntDaysLate
                    Case 0
                        strTemp1 = strTemp1
                    Case 1
                        strTemp1 = strTemp1 & " + NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 1, 1)), 0)"
                    Case Else
                        strTemp1 = strTemp1 & " + NVL(SUM(DECODE(GREATEST(REQUEST_TO_SHIP_VARIANCE, 1), LEAST(REQUEST_TO_SHIP_VARIANCE," & vntDaysLate & "),1)), 0)"
                End Select

                strSql = strSql & " (" & strTemp1 & ")  computed_total_on_time, "
                strSql = strSql & " 0 computed_total_on_time_jit, "
                strSql = strSql & strTemp3
                strSql = strSql & " 0 computed_total_late_jit  "

            ElseIf vntSmryType = "3" Then  'Standard Default (3) Request To Sched
                strSql = strSql & " NVL(COUNT(*), 0) computed_total_nbr_shipments, "
                strSql = strSql & " 0 computed_total_jit_shipments, "

                If vntSmryType = 3 Then
                    vntDaysEarly = 0
                    vntDaysLate = 0
                End If

                If vntDaysEarly = "" Then
                    vntDaysEarly = 0
                End If

                If vntDaysLate = "" Then
                    vntDaysLate = 0
                End If

                strSql = strSql & " NVL(SUM(DECODE(GREATEST(REQUEST_TO_SCHEDULE_VARIANCE, -999), LEAST(REQUEST_TO_SCHEDULE_VARIANCE," & -(vntDaysEarly + 1) & "),1)), 0) computed_total_early, "

                Select Case vntDaysEarly
                    Case 0
                        strTemp1 = ""
                    Case 1
                        strTemp1 = "NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -1, 1)), 0) + "
                    Case Else
                        strTemp1 = "NVL(SUM(DECODE(GREATEST(REQUEST_TO_SCHEDULE_VARIANCE," & -vntDaysEarly & "), LEAST(REQUEST_TO_SCHEDULE_VARIANCE, -1),1)), 0) + "
                End Select

                strSql = strSql & " 0 computed_total_early_jit, "
                strTemp1 = strTemp1 & "NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 0, 1)), 0)"
                strTemp3 = " NVL(SUM(DECODE(GREATEST(REQUEST_TO_SCHEDULE_VARIANCE," & vntDaysLate + 1 & "), LEAST(REQUEST_TO_SCHEDULE_VARIANCE, 999),1)), 0) computed_total_late, "

                Select Case vntDaysLate
                    Case 0
                        strTemp1 = strTemp1
                    Case 1
                        strTemp1 = strTemp1 & " + NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 1, 1)), 0)"
                    Case Else
                        strTemp1 = strTemp1 & " + NVL(SUM(DECODE(GREATEST(REQUEST_TO_SCHEDULE_VARIANCE, 1), LEAST(REQUEST_TO_SCHEDULE_VARIANCE," & vntDaysLate & "),1)), 0)"
                End Select

                strSql = strSql & " (" & strTemp1 & ")  computed_total_on_time, "
                strSql = strSql & " 0 computed_total_on_time_jit, "
                strSql = strSql & strTemp3
                strSql = strSql & " 0 computed_total_late_jit  "
            End If
        End If

        If vntCategoryId = "23" Then
            strSql = strSql & ", A.PRODUCT_LINE_CODE VIEWDESC3 "
        End If

        strSql = strSql & " FROM ORGANIZATIONS_DMN C "

        If vntCategoryId = "9" And vntViewId = "2" Then
            strSql = strSql & ", SCD_BLDG_PLANT_V B "
            '    strSql = strSql & " BUILDING_LOCATION_SMRY A  "
        End If

        If vntCategoryId = "9" And vntViewId = "10" Then
            strSql = strSql & ", SCD_BLDG_PLANT_V B "
            '    strSql = strSql & " MFG_CAMPUS_BLDG_SMRY A  "
        End If

        'If vntCategoryId = 10 Then
        '    strSql = strSql & ", BUILDING_LOCATION_SMRY A  "
        'End If

        If vntCategoryId = "13" And vntViewId = "6" Then
            '    If vntStkMake = "" Then
            '        strSql = strSql & ", CNTRLR_PROD_LINE_SMRY A,  "
            '    Else
            '        strSql = strSql & ", TEAM_ORG_SMRY A,  "
            '    End If
            strSql = strSql & ", ORGANIZATIONS_DMN D  "
        End If

        'If vntCategoryId = 13 And vntViewId = 3 Then
        '    If vntSmryType = 1 Then
        '        strSql = strSql & ", CUSTOMER_ACCOUNT_SMRY_T1 A  "
        '    ElseIf vntSmryType = 2 Then
        '        strSql = strSql & ", CUSTOMER_ACCOUNT_SMRY_T2 A  "
        '    ElseIf vntSmryType = 3 Then
        '        strSql = strSql & ", CUSTOMER_ACCOUNT_SMRY_T3 A  "
        '    End If
        'End If

        If vntCategoryId = "15" Then
            strSql = strSql & ", SCORECARD_TEAM B "
            '    strSql = strSql & " TEAM_ORG_SMRY A  "
        End If

        If vntCategoryId = "16" Then
            '    If vntStkMake = "" Then
            '        strSql = strSql & ", CNTRLR_PROD_LINE_SMRY A,  "
            '    Else
            '        strSql = strSql & ", ORDER_ITEM_SHIPMENT A,  "
            '    End If
            strSql = strSql & ", ORGANIZATIONS_DMN D  "
        End If

        If vntCategoryId = "17" Then
            strSql = strSql & ", GBL_STOCK_MAKE_CODE B "
            '    strSql = strSql & " ORDER_ITEM_SHIPMENT A  "
        End If

        If vntCategoryId = "18" Then
            strSql = strSql & ", GBL_PRODUCT_LINE B "
            '    If vntStkMake = "" Then
            '        strSql = strSql & " CNTRLR_PROD_LINE_SMRY A  "
            '    Else
            '        strSql = strSql & " TEAM_ORG_SMRY A  "
            '    End If
        End If

        If vntCategoryId = "19" Then
            strSql = strSql & ", GBL_PRODUCT B "
            strSql = strSql & ", GED_PUBLIC_TABLE F "
            '    If vntStkMake = "" Then
            '        strSql = strSql & " CNTRLR_PROD_LINE_SMRY A  "
            '    Else
            '        strSql = strSql & " TEAM_ORG_SMRY A  "
            '    End If
        End If

        If vntCategoryId = "20" Then
            strSql = strSql & ", GBL_INDUSTRY B  "
            '    strSql = strSql & " ORDER_ITEM_SHIPMENT A "
        End If

        If vntCategoryId = "21" Then
            strSql = strSql & ", GBL_INDUSTRY_BUSINESS B  "
            '    If vntViewId = 9 Then
            '        strSql = strSql & " INDUSTRY_CODE_SMRY A "
            '    Else
            '        strSql = strSql & " PROFIT_CENTER_SMRY A "
            '    End If
        End If

        'If vntCategoryId = 22 Then
        '    strSql = strSql & ", MFG_CAMPUS_BLDG_SMRY A  "
        'End If

        'If vntCategoryId = 23 Then
        '    strSql = strSql & ", MFG_CAMPUS_BLDG_SMRY A  "
        'End If

        If vntCategoryId = "24" Then
            strSql = strSql & ", GBL_MGE_PROFIT_CENTERS B  "
            '    strSql = strSql & " PROFIT_CENTER_SMRY A"
        End If

        If vntCategoryId = "25" Then
            strSql = strSql & ", GBL_BUSINESS_LINE_FUNCTION B  "
            strSql = strSql & ", GBL_BUSINESS_LINE E "
        End If

        If vntCategoryId = "26" Or vntCategoryId = "27" Then
            strSql = strSql & ", CODE_LOOKUPS B "
        End If

        If vntViewId = "10" Then
            strSql = strSql & " , ORGANIZATIONS_DMN D"
        End If

        strSql = strSql & ", ORDER_ITEM_SHIPMENT A"
        strSql = strSql & " WHERE AMP_SHIPPED_DATE BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"

        vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"
        
        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        strSql = strSql & " AND  C.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        
        If vntViewId = "10" Then
            strSql = strSql & " AND  D.LAYER" & vntMfgLevel & "_ORGANIZATION_ID = '" & vntMfgOrgId & "' "
            strSql = strSql & " AND  A.MFR_ORG_KEY_ID = D.ORGANIZATION_KEY_ID(+) "
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID(+) "
        Else
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID(+) "
        End If

        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                Else
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                End If
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
            Else
                If vntViewId = "10" Then
                    strSql = strSql & "AND D.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
            End If
        Else
            strSql = strSql & " AND C.RECORD_STATUS_CDE = 'C' "
            vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
        End If

        'strSql = strSql & " AND  (A.DELIVERY_SMRY_TYPE = '" & vntSmryType & "')  "

        If vntCategoryId = "9" And vntViewId = "2" Then
            strSql = strSql & " AND (A.ACTUAL_SHIP_BUILDING_NBR =  B.BUILDING_ID(+)) "
            strSql = strSql & " AND B.SOURCE_SYSTEM_ID(+) = scdCommonBatch.GetSourceSystemID(A.DATA_SOURCE_DESC) "
        End If

        If vntCategoryId = "9" And vntViewId = "10" Then
            strSql = strSql & " AND A.MFG_BUILDING_NBR = B.BUILDING_ID(+) "
        End If

        If vntCategoryId = "15" Then
            strSql = strSql & " AND (A.TEAM_CODE = B.TEAM_CODE(+)) "
            strSql = strSql & " AND A.ORGANIZATION_KEY_ID = B.TEAM_DIV_ORG_KEY_ID(+) "
        End If

        If (vntCategoryId = "13" And vntViewId = "6") Or vntCategoryId = "16" Then
            strSql = strSql & " AND A.CONTROLLER_UNIQUENESS_ID = d.ORGANIZATION_ID(+) "
            If vntCurrentHist <> "" Then
                If vntCurrentHist = "C" Then
                    strSql = strSql & " AND D.RECORD_STATUS_CDE(+) = '" & vntCurrentHist & "' "
                Else
                    strSql = strSql & " AND (D.EFFECTIVE_FROM_DT(+) <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND D.EFFECTIVE_TO_DT(+) >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
            Else
                strSql = strSql & " AND D.RECORD_STATUS_CDE(+) = 'C' "
            End If
        End If

        If vntCategoryId = "17" Then
            strSql = strSql & " AND (SUBSTR(A.STOCK_MAKE_CODE,1,1) = B.STOCK_MAKE_CODE(+)) "
        End If

        If vntCategoryId = "18" Then
            strSql = strSql & " AND (A.PRODUCT_LINE_CODE = B.PRLN_CODE(+)) "
        End If

        If vntCategoryId = "19" Then
            strSql = strSql & " AND (A.PRODUCT_LINE_CODE = B.PROD_GLOBAL_PRLN_CODE (+)) "
            strSql = strSql & " AND (A.PRODUCT_CODE = B.PROD_CODE (+)) "
            strSql = strSql & " AND (F.ASOC_GLOBAL_ID(+) = A.PRODUCT_MANAGER_GLOBAL_ID) "
        End If

        If vntCategoryId = "20" Then
            strSql = strSql & " AND  A.INDUSTRY_CODE = B.INDUSTRY_CODE(+) "
        End If

        If vntCategoryId = "21" Then
            strSql = strSql & " AND  A.INDUSTRY_BUSINESS_CODE = B.GIB_INDUSTRY_BUSINESS_CODE(+) "
        End If

        If vntCategoryId = "24" Then
            strSql = strSql & " AND A.PROFIT_CENTER_ABBR_NM = B.MGE_PROFIT_CENTER_ABBR_NM(+) "
        End If

        If vntCategoryId = "25" Then
            strSql = strSql & " AND A.PRODUCT_BUSNS_LINE_FNCTN_ID = B.BUSLN_FNCTN_ID(+) "
            strSql = strSql & " AND A.PRODUCT_BUSNS_LINE_ID = E.BUSLN_ID(+) "
        End If

        If vntCategoryId = "26" Then 'sales office
            strSql = strSql & " AND B.GENERIC_CDE(+) = A.SALES_OFFICE_CDE "
            strSql = strSql & " AND B.SOURCE_SYSTEM_ID(+) = scdCommonBatch.GetSourceSystemID(A.DATA_SOURCE_DESC) "
            strSql = strSql & " AND B.CODE_TYPE_ID(+) = 9 "
        End If

        If vntCategoryId = "27" Then 'sales group
            strSql = strSql & " AND B.GENERIC_CDE(+) = A.SALES_GROUP_CDE "
            strSql = strSql & " AND B.SOURCE_SYSTEM_ID(+) = scdCommonBatch.GetSourceSystemID(A.DATA_SOURCE_DESC) "
            strSql = strSql & " AND B.CODE_TYPE_ID(+) = 10 "
        End If

        If vntPlant <> "" Then
            strSql = strSql & " AND (ACTUAL_SHIP_BUILDING_NBR = '" & vntPlant & "')"
            vntDispCrit = vntDispCrit & " <strong>Plant/Blg:</strong> " & vntPlant & ";"
        End If

        If vntTeam <> "" Then
            strSql = strSql & " AND TEAM_CODE = '" & vntTeam & "'"
            vntDispCrit = vntDispCrit & " <strong>Team:</strong> " & vntTeam & ";"
        End If

        If vntStkMake <> "" Then
            vntLength = Len(vntStkMake)
            If vntCategoryId = 17 Then
                strSql = strSql & " AND substr(A.STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            Else
                strSql = strSql & " AND substr(STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Make Stock:</strong> " & vntStkMake & ";"
        End If

        If vntMrpGroupCde <> "" Then
            If InStr(vntMrpGroupCde, ",") > 0 Then
                strSql = strSql & " AND MRP_GROUP_CDE IN ( " & QuoteStr(vntMrpGroupCde) & " ) "
            Else
                strSql = strSql & " AND MRP_GROUP_CDE " & IIf(InStr(vntMrpGroupCde, "%") > 0, "LIKE '", "= '") & vntMrpGroupCde & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>MRP Group:</strong> " & vntMrpGroupCde & ";"
        End If

        If vntProdCde <> "" Then
            strSql = strSql & " AND PRODUCT_CODE = '" & vntProdCde & "'"
            vntDispCrit = vntDispCrit & " <strong>Product Code:</strong> " & vntProdCde & ";"
        End If

        If vntProdLne <> "" Then
            If InStr(vntProdLne, ",") > 0 Then
                strSql = strSql & " AND PRODUCT_LINE_CODE IN ( " & QuoteStr(vntProdLne) & " )"
            Else
                strSql = strSql & " AND PRODUCT_LINE_CODE = '" & vntProdLne & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Product Line:</strong> " & vntProdLne & ";"
        End If

        If vntMfgCampus <> "" Then
            strSql = strSql & " AND MFG_CAMPUS_ID = '" & vntMfgCampus & "'"
            vntDispCrit = vntDispCrit & " <strong>Mfg Campus:</strong> " & vntMfgCampus & ";"
        End If

        If vntMfgBuilding <> "" Then
            strSql = strSql & " AND MFG_BUILDING_NBR = '" & vntMfgBuilding & "'"
            vntDispCrit = vntDispCrit & " <strong>Mfg Building:</strong> " & vntMfgBuilding & ";"
        End If

        If vntCntlrEmpNbr <> "" Then
            strSql = strSql & " AND PRODCN_CNTLR_EMPLOYEE_NBR = '" & vntCntlrEmpNbr & "' "
            vntDispCrit = vntDispCrit & " <strong>Controller Emp Nbr:</strong> " & vntCntlrEmpNbr & ";"
        End If

        If vntInvOrg <> "" Then
            If InStr(vntInvOrg, ",") > 0 Then
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID IN ( " & QuoteStr(vntInvOrg) & " ) "
            Else
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID " & IIf(InStr(vntInvOrg, "%") > 0, "LIKE '", "= '") & vntInvOrg & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Inv Org/Plant:</strong> " & vntInvOrg & ";"
        End If

        If vntController <> "" Then
            If InStr(vntController, ",") > 0 Then
                strSql = strSql & " AND PRODCN_CNTRLR_CODE IN ( " & QuoteStr(vntController) & " ) "
            Else
                strSql = strSql & " AND PRODCN_CNTRLR_CODE " & IIf(InStr(vntController, "%") > 0, "LIKE '", "= '") & vntController & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Controller:</strong> " & vntController & ";"
        End If

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        If vntIC <> "" Then
            If InStr(vntIC, ",") > 0 Then
                strSql = strSql & " AND A.INDUSTRY_CODE IN ( " & QuoteStr(vntIC) & " ) "
            Else
                strSql = strSql & " AND A.INDUSTRY_CODE LIKE '" & vntIC & "%' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry:</strong> " & vntIC & ";"
        End If

        If vntIBC <> "" Then
            If InStr(vntIBC, ",") > 0 Then
                strSql = strSql & " AND A.INDUSTRY_BUSINESS_CODE IN ( " & QuoteStr(vntIBC) & " ) "
            Else
                strSql = strSql & " AND A.INDUSTRY_BUSINESS_CODE = '" & vntIBC & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry Business:</strong> " & vntIBC & ";"
        End If

        If vntShipTo <> "" Then
            vntTemp2 = vntShipTo
            intCountST = 0
            vntTemp = ""
            
            vntShipTo = Replace(vntShipTo, "-", "")
            If Len(vntShipTo) < 10 Then
                For intCountST = 1 To 10 - Len(vntShipTo)
                    vntTemp = "0" & vntTemp
                Next
                vntShipTo = vntTemp & vntShipTo
            End If

            If Len(vntShipTo) > 10 Then
                Err.Raise(901, , "Ship To Number is invalid.  These numbers are required to have 10 characters")
            Else
                strSql = strSql & " AND PURCHASE_BY_ACCOUNT_BASE = '" & Left(vntShipTo, 8) & "'"
                strSql = strSql & " AND SHIP_TO_ACCOUNT_SUFFIX = '" & Right(vntShipTo, 2) & "'"
            End If

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntWWCust <> "" Then
            vntTemp2 = vntWWCust
            intFound = 0
            vntTempWW = ""
            vntTempWW2 = ""
            intCountWW = 0
            
            intFound = InStr(vntWWCust, "-")
            If intFound <> 0 Then
                vntTempWW = Left(vntWWCust, intFound - 1)
                vntTempWW2 = Right(vntWWCust, Len(vntWWCust) - intFound)
            Else
                If Len(vntWWCust) > 10 Then
                    Err.Raise(901, , "WorldWide Number is invalid.  These numbers are required to have a maximum of 10 characters")
                ElseIf Len(vntWWCust) <= 8 Then
                    vntTempWW = vntWWCust
                ElseIf Len(vntWWCust) = 9 Then
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 1)
                Else
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 2)
                End If
            End If

            If Len(vntTempWW) < 8 Then
                For intCountWW = 1 To 8 - Len(vntTempWW)
                    vntTemp = vntTemp & "0"
                Next
                vntWWCust = vntTemp & vntTempWW
            Else
                vntWWCust = vntTempWW
            End If

            If Len(vntTempWW2) = 1 Then
                vntTempWW2 = "0" & vntTempWW2
                vntWWCust = vntWWCust & vntTempWW2
            Else
                vntWWCust = vntWWCust & vntTempWW2
            End If

            If Len(vntWWCust) > 8 Then
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
                strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
            Else
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
            End If

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_ID = '" & vntCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Competency Business:</strong> " & vntCBC & ";"
        End If

        If vntSubCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_FNCTN_ID = '" & vntSubCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Sub-Competency Business:</strong> " & vntSubCBC & ";"
        End If

        If vntProfit <> "" Then
            strSql = strSql & " AND PROFIT_CENTER_ABBR_NM = '" & vntProfit & "' "
            vntDispCrit = vntDispCrit & " <strong>Profit Center:</strong> " & vntProfit & ";"
        End If

        If vntProdMgr <> "" Then
            strSql = strSql & ParseProdMgr(vntProdMgr)
            vntDispCrit = vntDispCrit & " <strong>Product Mgr:</strong> " & vntProdMgr & ";"
        End If

        If vntSalesOffice <> "" Then
            If InStr(vntSalesOffice, ",") > 0 Then
                strSql = strSql & " AND A.SALES_OFFICE_CDE IN ( " & QuoteStr(vntSalesOffice) & " ) "
            Else
                strSql = strSql & " AND A.SALES_OFFICE_CDE " & IIf(InStr(vntSalesOffice, "%") > 0, "LIKE '", "= '") & vntSalesOffice & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Office:</strong> " & vntSalesOffice & ";"
        End If

        If vntacctOrgKey <> "" Then
            strSql = strSql & " AND ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey
        End If

        If vntSoldTo <> "" Then
            vntTemp2 = vntSoldTo
            intCountST = 0
            vntTemp = ""

            vntSoldTo = Replace(vntSoldTo, "-", "")
            If Len(vntSoldTo) < 8 Then
                For intCountST = 1 To 8 - Len(vntSoldTo)
                    vntTemp = "0" & vntTemp
                Next
                vntSoldTo = vntTemp & vntSoldTo
            End If

            If Len(vntSoldTo) > 8 Then
                Err.Raise(901, , "Sold To Number is invalid.  These numbers are required to have 8 characters")
            Else
                strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
            End If

            blnrc = objGetSoldToName.RetrieveName(vntCustOrg, vntSoldTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetSoldToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntCategoryId = "9" And vntViewId = "2" Then
            strSql = strSql & " GROUP BY  A.ACTUAL_SHIP_BUILDING_NBR, "
            strSql = strSql & " B.BUILDING_NM,  "
            strSql = strSql & " C.ORGANIZATION_ID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "9" And vntViewId = "10" Then
            strSql = strSql & " GROUP BY  A.MFG_BUILDING_NBR, "
            strSql = strSql & " B.BUILDING_NM,  "
            strSql = strSql & " D.ORGANIZATION_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "10" Then
            strSql = strSql & " GROUP BY  A.ACTUAL_SHIP_LOCATION, "
            strSql = strSql & " C.ORGANIZATION_ID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "13" And vntViewId = "3" Then
            strSql = strSql & " GROUP BY  C.ORGANIZATION_ID,  "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM "
        End If

        If vntCategoryId = "13" And vntViewId = "6" Then
            strSql = strSql & " GROUP BY  A.CONTROLLER_UNIQUENESS_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM "
        End If

        If vntCategoryId = "15" Then
            strSql = strSql & " GROUP BY  A.TEAM_CODE, "
            strSql = strSql & " B.ABBRD_DESC,  "
            strSql = strSql & " C.ORGANIZATION_ID, "
            strSql = strSql & " C.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "16" Then
            strSql = strSql & " GROUP BY  A.CONTROLLER_UNIQUENESS_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM , "
            strSql = strSql & " A.PRODCN_CNTRLR_CODE  "
        End If

        If vntCategoryId = "17" Then
            strSql = strSql & " GROUP BY  A.STOCK_MAKE_CODE, "
            strSql = strSql & " B.STOCK_MAKE_DSCRPTN "
        End If

        If vntCategoryId = "18" Then
            strSql = strSql & " GROUP BY  A.PRODUCT_LINE_CODE, "
            strSql = strSql & " B.PRLN_SHORT_NAME  "
        End If

        If vntCategoryId = "19" Then
            strSql = strSql & " GROUP BY  A.PRODUCT_LINE_CODE, "
            strSql = strSql & " A.PRODUCT_CODE,  "
            strSql = strSql & " B.PROD_SHORT_NAME  "
            strSql = strSql & " ,F.FIRST_NAME||DECODE(F.MIDDLE_INITIAL,NULL,'',' '||F.MIDDLE_INITIAL)||' '||F.LAST_NAME "
        End If

        If vntCategoryId = "20" Then
            strSql = strSql & " GROUP BY  A.INDUSTRY_CODE, "
            strSql = strSql & " B.INDUSTRY_NAME "
        End If

        If vntCategoryId = "21" Then
            strSql = strSql & " GROUP BY  A.INDUSTRY_BUSINESS_CODE, "
            strSql = strSql & " B.GIB_SHORT_NAME "
        End If

        If vntCategoryId = "22" Then
            strSql = strSql & " GROUP BY  A.MFG_CAMPUS_ID, "
            strSql = strSql & " D.ORGANIZATION_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "23" Then
            strSql = strSql & " GROUP BY  A.MFG_CAMPUS_ID, "
            strSql = strSql & " A.MFG_BUILDING_NBR, "
            strSql = strSql & " A.PRODUCT_LINE_CODE, "
            strSql = strSql & " D.ORGANIZATION_ID, "
            strSql = strSql & " D.ORGANIZATION_SHORT_NM  "
        End If

        If vntCategoryId = "24" Then
            strSql = strSql & " GROUP BY  A.PROFIT_CENTER_ABBR_NM, "
            strSql = strSql & " B.MGE_PROFIT_CENTER_DESC "
        End If

        If vntCategoryId = "25" Then
            strSql = strSql & " GROUP BY  A.PRODUCT_BUSNS_LINE_ID, E.BUSLN_DSCRPTN, "
            strSql = strSql & " A.PRODUCT_BUSNS_LINE_FNCTN_ID, B.BUSLN_FNCTN_SHORT_NAME "
        End If

        If vntCategoryId = "26" Then
            strSql = strSql & " GROUP BY A.SALES_OFFICE_CDE, B.CODE_NM, A.ACTUAL_SHIP_BUILDING_NBR "
        End If

        If vntCategoryId = "27" Then
            strSql = strSql & " GROUP BY A.SALES_OFFICE_CDE, A.SALES_GROUP_CDE, B.CODE_NM, A.ACTUAL_SHIP_BUILDING_NBR "
        End If

        strSql = strSql & " ORDER BY "
        
        If vntCategoryId = "17" Or vntCategoryId = "18" Or vntCategoryId = "20" Or vntCategoryId = "21" Then
            strSql = strSql & "VIEWDESC1 ASC"
        ElseIf vntCategoryId = 13 Then
            strSql = strSql & "ORGID ASC"
        ElseIf vntCategoryId = "19" Or vntCategoryId = "16" Or vntCategoryId = "25" Or vntCategoryId = "26" Or vntCategoryId = "27" Then
            strSql = strSql & "ORGID ASC, VIEWDESC1 ASC "
        ElseIf vntCategoryId = "23" Then
            strSql = strSql & "VIEWDESC1 ASC, VIEWDESC2 ASC, VIEWDESC3,ORGID ASC, ORGNAME ASC "
        ElseIf vntCategoryId = "24" Then  'Or vntCategoryId = 25 Then
            strSql = strSql & "VIEWDESC1 ASC, VIEWDESC2 ASC "
        ElseIf vntCategoryId = "15" Then
            strSql = strSql & "ORGID ASC,VIEWDESC1 ASC "
        Else
            strSql = strSql & "VIEWDESC1 ASC, ORGID ASC"
        End If

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsResults.ListGeneral call to CallRS for Main Results")
        End If

        If vntCount > 0 Then
            '
            'If vntCategoryId = "17" Or vntCategoryId = "18" Or vntCategoryId = "20" Or vntCategoryId = "21" Then
            '    
            '    objList.Sort = "VIEWDESC1 ASC"
            '    
            'ElseIf vntCategoryId = 13 Then
            '    
            '    objList.Sort = "ORGID ASC"
            '    
            'ElseIf vntCategoryId = "19" Or vntCategoryId = "16" Or vntCategoryId = "25" Or vntCategoryId = "26" Or vntCategoryId = "27" Then
            '    
            '    objList.Sort = "ORGID ASC, VIEWDESC1 ASC "
            '    
            'ElseIf vntCategoryId = "23" Then
            '    
            '    objList.Sort = "VIEWDESC1 ASC, VIEWDESC2 ASC, VIEWDESC3,ORGID ASC, ORGNAME ASC "
            '    
            'ElseIf vntCategoryId = "24" Then  'Or vntCategoryId = 25 Then
            '    
            '    objList.Sort = "VIEWDESC1 ASC, VIEWDESC2 ASC "
            '    
            'ElseIf vntCategoryId = "15" Then
            '    
            '    objList.Sort = "ORGID ASC,VIEWDESC1 ASC "
            'Else
            '    
            '    objList.Sort = "VIEWDESC1 ASC, ORGID ASC"
            'End If
            ReDim vntArray(UBound(objList, 1) + 2, 0)
            vntTempArray = objList

            For intCount = 0 To UBound(vntTempArray, 2)
                vntArray(0, 0) = VB6.Format(CDbl(vntArray(0, 0)) + CDbl(vntTempArray(4, intCount)), "#,###,##0") 'Total Schds
                vntArray(1, 0) = VB6.Format(CDbl(vntArray(1, 0)) + CDbl(vntTempArray(6, intCount)), "#,###,##0") 'Total Early
                vntArray(3, 0) = VB6.Format(CDbl(vntArray(3, 0)) + CDbl(vntTempArray(8, intCount)), "#,###,##0") 'Total On Time
                vntArray(5, 0) = VB6.Format(CDbl(vntArray(5, 0)) + CDbl(vntTempArray(10, intCount)), "#,###,##0") 'Total Late
                vntArray(7, 0) = VB6.Format(CDbl(vntArray(7, 0)) + CDbl(vntTempArray(5, intCount)), "#,###,##0") 'Total JIT Schds
                vntArray(8, 0) = VB6.Format(CDbl(vntArray(8, 0)) + CDbl(vntTempArray(7, intCount)), "#,###,##0") 'Total JIT Early
                vntArray(10, 0) = VB6.Format(CDbl(vntArray(10, 0)) + CDbl(vntTempArray(9, intCount)), "#,###,##0") 'Total On Time
                vntArray(12, 0) = VB6.Format(CDbl(vntArray(12, 0)) + CDbl(vntTempArray(11, intCount)), "#,###,##0") 'Total Late
            Next
            
            If vntArray(0, 0) <> 0 Then
                vntArray(2, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(1, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'Early
                vntArray(4, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(3, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'On Time
                vntArray(6, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(5, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'Late
            Else
                vntArray(2, 0) = 0 'Early
                vntArray(4, 0) = 0 'On Time
                vntArray(6, 0) = 0 'Late
            End If

            If vntArray(0, 0) <> 0 Then
                vntArray(9, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(8, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'JIT Early
                vntArray(11, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(10, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'Jit On Time
                vntArray(13, 0) = VB6.Format(System.Math.Round(CDbl(vntArray(12, 0)) / CDbl(vntArray(0, 0)), 3), "0.0%") 'JIT Late
            Else
                vntArray(9, 0) = 0 'JIT Early
                vntArray(11, 0) = 0 'Jit On Time
                vntArray(13, 0) = 0 'JIT Late
            End If

            ListGeneralDly = vntTempArray
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListGeneralDly = System.DBNull.Value
        End If
        
        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListGeneralDly = System.DBNull.Value
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        Exit Function
	End Function
	
	Public Function QuoteStr(ByVal vntInput As Object) As Object
        Dim vntTemp As Object
		Dim vntHold As Object
		Dim intFound As Short

		vntTemp = ""
		intFound = 0
		
		intFound = InStr(vntInput, ",")
		If intFound <> 0 Then
			Do While intFound <> 0
                intFound = InStr(vntInput, ",")
				If intFound = 0 Then
                    vntHold = Trim(vntInput)
				Else
                    vntHold = Trim(Left(vntInput, intFound - 1))
                    vntInput = Right(vntInput, Len(vntInput) - intFound)
				End If
                If vntHold <> "" Then
                    vntTemp = vntTemp & "'" & vntHold & "' ,"
                End If
			Loop 
            vntTemp = Left(vntTemp, Len(vntTemp) - 1)
		Else
            vntTemp = "'" & vntInput & "'"
		End If

        QuoteStr = vntTemp

    End Function
	
	Public Function ListSummMonByCntry(ByVal vntSessionID As Object, ByRef vntDispCrit As Object, ByRef vntSmryType As Object, ByRef vntWindowId As Object, ByRef vntDaysEarly As Object, ByRef vntDaysLate As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim objSearch As New clsSearch
        Dim objOrgs As New clsOrgs
        Dim vntArray As Object
		Dim vntTempArray As Object
		Dim dblTemp1 As Double
		Dim dblTemp2 As Double
		Dim blnrc As Boolean
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgID As Object
        'Dim vntMonthDailyInd As Object
        'Dim vntCustAcctTypeCde As Object
        'Dim vntPart As Object
        'Dim vntPlant As Object
        'Dim vntLocation As Object
        'Dim vntacctOrgKey As Object
        'Dim vntShipTo As Object
        'Dim vntSoldTo As Object
        'Dim vntWWCust As Object
        'Dim vntInvOrg As Object
        'Dim vntController As Object
        'Dim vntCntlrEmpNbr As Object
        'Dim vntStkMake As Object
        'Dim vntTeam As Object
        'Dim vntProdCde As Object
        'Dim vntProdLne As Object
        'Dim vntIBC As Object
        'Dim vntIC As Object
        'Dim vntMfgCampus As Object
        'Dim vntMfgBuilding As Object
        'Dim vntComparisonType As Object
        'Dim vntOpenShpOrder As Object
        'Dim vntProfit As Object
        'Dim vntCBC As Object
        'Dim vntSubCBC As Object
        'Dim vntOrgDate As Object
        'Dim vntLevel As Object
        'Dim vntLastDay As Object
        'Dim vntKeyId As Object
        'Dim vntOrgType As Object
        'Dim vntLength As Object
        'Dim vntOrgTypeDesc As Object
        'Dim vntTemp1 As Object
        'Dim intCountST As Short
        'Dim vntTemp As Object
        'Dim vntTempWW As Object
        'Dim vntTempWW2 As Object
        'Dim intCountWW As Short
        'Dim intFound As Short
        '      Dim objGetWWName As New clsWrldWide
        '      Dim objGetShipToName As New clsShipTo
        '      Dim objGetSoldToName As New clsSoldTo
        '      Dim vntName As Object
        'Dim vntTemp2 As Object
        'Dim vntCustOrg As Object
        Dim intCount As Integer
        Dim intCount2 As Integer
        Dim vntCount As Integer
        'Dim vntProdMgr As Object
        'Dim vntLeadTimeType As Object
        'Dim vntSalesOffice As Object
        'Dim vntSalesGroup As Object
        'Dim vntMfgOrgType As Object
        'Dim vntMfgOrgId As Object
        'Dim GamAccount As Object
        'Dim vntPartKeyID As Object
        'Dim vntMrpGroupCde As Object
        'Dim vntHostOrgID As Object
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
        Dim vntCurrentHist As String = ""
        Dim vntOrgID As String = ""
        Dim vntMonthDailyInd As String = ""
        Dim vntCustAcctTypeCde As String = ""
        Dim vntPart As String = ""
        Dim vntPlant As String = ""
        Dim vntLocation As String = ""
        Dim vntacctOrgKey As String = ""
        Dim vntShipTo As String = ""
        Dim vntSoldTo As String = ""
        Dim vntWWCust As String = ""
        Dim vntInvOrg As String = ""
        Dim vntController As String = ""
        Dim vntCntlrEmpNbr As String = ""
        Dim vntStkMake As String = ""
        Dim vntTeam As String = ""
        Dim vntProdCde As String = ""
        Dim vntProdLne As String = ""
        Dim vntIBC As String = ""
        Dim vntIC As String = ""
        Dim vntMfgCampus As String = ""
        Dim vntMfgBuilding As String = ""
        Dim vntComparisonType As String = ""
        Dim vntOpenShpOrder As String = ""
        Dim vntProfit As String = ""
        Dim vntCBC As String = ""
        Dim vntSubCBC As String = ""
        Dim vntOrgDate As String = ""
        Dim vntOrgType As String = ""
        Dim vntKeyId As Long
        Dim vntLevel As String = ""
        Dim vntLength As Integer
        Dim vntOrgTypeDesc As String = ""
        Dim intCountST As Integer
        Dim vntTemp As String = ""
        Dim vntTempWW As String = ""
        Dim vntTempWW2 As String = ""
        Dim intCountWW As Integer
        Dim intFound As Integer
        Dim objGetWWName As New clsWrldWide
        Dim objGetShipToName As New clsShipTo
        Dim objGetSoldToName As New clsSoldTo
        Dim vntName As String = ""
        Dim vntTemp2 As String = ""
        Dim vntCustOrg As String = ""
        Dim vntProdMgr As String = ""
        Dim vntLeadTimeType As String = ""
        Dim vntSalesOffice As String = ""
        Dim vntSalesGroup As String = ""
        Dim vntMfgOrgType As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgLevel As String = ""
        Dim GamAccount As String = ""
        Dim vntPartKeyID As String = ""
        Dim vntMrpGroupCde As String = ""
        Dim vntHostOrgID As String = ""
		On Error GoTo ErrorHandler
		
		dblTemp1 = 0
		dblTemp2 = 0
		
		If vntSessionID = "" Then
			Err.Raise(100,  , "Session Id not passed or found in component needed for retrieving search criteria in clsResults.ListSummMonByCntry")
		End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDate, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNumber, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsSearch.RetrieveSession from clsResults.ListSummMonByCntry")
        End If

        If vntOrgID = "" Then
            Err.Raise(100, , "ORG Id not found in search criteria in clsResults.ListSummMonByCntry")
        End If

        If vntOrgID <> "" Then
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"

            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDate, vntLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListSummMonByCntry")
            End If
            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org ID:</strong> " & vntacctOrgKey & ";"
            
            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDate, vntKeyId, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If
            vntacctOrgKey = vntKeyId
        End If

        If vntWindowId = 1 Then 'Customer Variable or Standard Default
            strSql = " SELECT   NVL(SUM(NBR_VARBL_OUT_RANGE_EARLY + NBR_VARBL_SIX_DAYS_EARLY), 0) var_six_plus_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_FIVE_DAYS_EARLY), 0) var_five_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_FOUR_DAYS_EARLY), 0) var_four_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_THREE_DAYS_EARLY), 0) var_three_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_TWO_DAYS_EARLY), 0) var_two_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_ONE_DAY_EARLY), 0) var_one_early,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_ON_TIME), 0) var_on_time,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_ONE_DAY_LATE), 0) var_one_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_TWO_DAYS_LATE), 0) var_two_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_THREE_DAYS_LATE), 0) var_three_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_FOUR_DAYS_LATE), 0) var_four_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_FIVE_DAYS_LATE), 0) var_five_late,   "
            strSql = strSql & "       NVL(SUM(NBR_VARBL_SIX_DAYS_LATE + NBR_VARBL_OUT_RANGE_LATE), 0) var_six_plus_late,   "
            strSql = strSql & "       NVL(SUM(TOTAL_NBR_SHPMTS), 0) var_total,     "
        Else
            strSql = " SELECT NVL(SUM(NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY), 0) def_six_plus_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_FIVE_DAYS_EARLY), 0) def_five_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_FOUR_DAYS_EARLY), 0) def_four_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_THREE_DAYS_EARLY), 0) def_three_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_TWO_DAYS_EARLY), 0) def_two_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_ONE_DAY_EARLY), 0) def_one_early, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_ON_TIME), 0) def_on_time, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_ONE_DAY_LATE), 0) def_one_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_TWO_DAYS_LATE), 0) def_two_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_THREE_DAYS_LATE), 0) def_three_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_FOUR_DAYS_LATE), 0) def_four_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_FIVE_DAYS_LATE), 0) def_five_late, "
            strSql = strSql & "     NVL(SUM(NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_OUT_RANGE_LATE), 0) def_six_plus_late, "
            strSql = strSql & "     NVL(SUM(TOTAL_NBR_SHPMTS), 0) def_total, "
        End If

        strSql = strSql & "       NVL(SUM(NBR_JIT_OUT_RANGE_EARLY + NBR_JIT_SIX_DAYS_EARLY), 0) jit_six_plus_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_FIVE_DAYS_EARLY), 0) jit_five_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_FOUR_DAYS_EARLY), 0) jit_four_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_THREE_DAYS_EARLY), 0) jit_three_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_TWO_DAYS_EARLY), 0) jit_two_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_ONE_DAY_EARLY), 0) jit_one_early,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_ON_TIME), 0) jit_on_time,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_ONE_DAY_LATE), 0) jit_one_late,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_TWO_DAYS_LATE), 0) jit_two_late,  "
        strSql = strSql & "       NVL(SUM(NBR_JIT_THREE_DAYS_LATE), 0) jit_three_late,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_FOUR_DAYS_LATE), 0) jit_four_late,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_FIVE_DAYS_LATE), 0) jit_five_late,   "
        strSql = strSql & "       NVL(SUM(NBR_JIT_SIX_DAYS_LATE + NBR_JIT_OUT_RANGE_LATE), 0) jit_six_plus_late,   "
        strSql = strSql & "       NVL(SUM(TOTAL_NBR_JIT_SHPMTS), 0) jit_total,   "
        strSql = strSql & "       0 early_shpmts,   "
        strSql = strSql & "       0 on_time_shpmts,   "
        strSql = strSql & "       0 late_shpmts,   "
        strSql = strSql & "       0 jit_early_shpmts,   "
        strSql = strSql & "       0 jit_late_shpmts,   "
        strSql = strSql & "       ISO_COUNTRY_NM   "

        If vntViewId = "1" Then 'ORG
            strSql = strSql & " FROM      SCORECARD_ORG_SMRY A, "
        ElseIf vntViewId = "2" Then  'Building
            strSql = strSql & " FROM BUILDING_LOCATION_SMRY A, "
        ElseIf vntViewId = "3" Then  'Customer
            If vntSmryType = "1" Then
                strSql = strSql & " FROM CUSTOMER_ACCOUNT_SMRY_T1 A, "
            ElseIf vntSmryType = "2" Then
                strSql = strSql & " FROM CUSTOMER_ACCOUNT_SMRY_T2 A, "
            Else
                strSql = strSql & " FROM CUSTOMER_ACCOUNT_SMRY_T3 A, "
            End If
        ElseIf vntViewId = "4" Then  'Ship Facility NOT VALID FOR THIS VIEW

        ElseIf vntViewId = "5" Or vntViewId = "7" Then  'Team or Make Stock
            strSql = strSql & " FROM TEAM_ORG_SMRY A, "
        ElseIf vntViewId = "6" Then  'Controller
            'If vntStkMake <> "" Then
            strSql = strSql & " FROM TEAM_ORG_SMRY A, "
            'Else
            '    strSql = strSql & " FROM CNTRLR_PROD_LINE_SMRY A, "
            'End If
        ElseIf vntViewId = "8" Then
            If vntStkMake <> "" Then
                strSql = strSql & " FROM TEAM_ORG_SMRY A, "
            Else
                strSql = strSql & " FROM CNTRLR_PROD_LINE_SMRY A, "
            End If
        ElseIf vntViewId = "9" Then
            strSql = strSql & " FROM INDUSTRY_CODE_SMRY A, "
        ElseIf vntViewId = "10" Then
            strSql = strSql & " FROM MFG_CAMPUS_BLDG_SMRY A, "
            'strSql = strSql & "  ORGANIZATIONS_DMN D, "
        ElseIf vntViewId = "11" Then
            strSql = strSql & " FROM PROFIT_CENTER_SMRY A, "
        End If

        strSql = strSql & " ORGANIZATIONS_DMN C "
        strSql = strSql & " WHERE  C.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        
        If vntViewId = "10" Then
            strSql = strSql & " AND  A.MFR_ORG_KEY_ID = C.ORGANIZATION_KEY_ID "
            'strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = D.ORGANIZATION_KEY_ID "
        Else
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID "
        End If

        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                If vntViewId = "10" Then
                    strSql = strSql & "AND C.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                Else
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                    vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
                End If
            Else
                strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
            End If
            
            If vntViewId = "10" Then
                '            If vntCurrentHist = "C" Then
                '                strSql = strSql & " AND D.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                '            Else
                '                strSql = strSql & " AND (D.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                '                strSql = strSql & " AND D.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                '            End If
            End If
        Else
            strSql = strSql & " AND C.RECORD_STATUS_CDE = 'C' "
            vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
        End If

        'Check SummaryType

        If vntSmryType = "1" Then
            strSql = strSql & " AND   (DELIVERY_SMRY_TYPE = '1') "
            vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
        ElseIf vntSmryType = "2" Then
            strSql = strSql & " AND   (DELIVERY_SMRY_TYPE = '2') "
            vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
        Else
            strSql = strSql & " AND   (DELIVERY_SMRY_TYPE = '3') "
            vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request to Schedule;"
        End If

        strSql = strSql & " AND AMP_SHIPPED_MONTH BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"

        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        
        If vntPart <> "" And Not IsDBNull(vntPartKeyID) Then
            '    intCountST = 0
            '    vntTemp = ""
            '    vntPart = Replace(vntPart, "-", "")
            '    If Len(vntPart) < 9 Then
            '        For intCountST = 1 To 9 - Len(vntPart)
            '            vntTemp = "0" & vntTemp
            '        Next
            '        vntPart = vntTemp & vntPart
            '    End If
            '    strSql = strSql & " AND Part_Nbr = '" & vntPart & "' "
            strSql = strSql & " AND PART_KEY_ID = " & vntPartKeyID
            vntDispCrit = vntDispCrit & " <strong>Part:</strong> " & vntPart & ";"
        End If

        If vntPlant <> "" Then
            strSql = strSql & " AND (ACTUAL_SHIP_BUILDING_NBR = '" & vntPlant & "')"
            vntDispCrit = vntDispCrit & " <strong>Plant/Blg:</strong> " & vntPlant & ";"
        End If

        If vntLocation <> "" Then
            strSql = strSql & " AND ACTUAL_SHIP_LOCATION = '" & vntLocation & "'"
            vntDispCrit = vntDispCrit & " <strong>Location:</strong> " & vntLocation & ";"
        End If

        If vntController <> "" Then
            If InStr(vntController, ",") > 0 Then
                strSql = strSql & " AND PRODCN_CNTRLR_CODE IN ( " & QuoteStr(vntController) & " ) "
            Else
                strSql = strSql & " AND PRODCN_CNTRLR_CODE " & IIf(InStr(vntController, "%") > 0, "LIKE '", "= '") & vntController & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Controller:</strong> " & vntController & ";"
        End If

        If vntStkMake <> "" Then
            vntLength = Len(vntStkMake)
            strSql = strSql & " AND substr(STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            vntDispCrit = vntDispCrit & " <strong>Make Stock:</strong> " & vntStkMake & ";"
        End If

        If vntMrpGroupCde <> "" Then
            If InStr(vntMrpGroupCde, ",") > 0 Then
                strSql = strSql & " AND MRP_GROUP_CDE IN ( " & QuoteStr(vntMrpGroupCde) & " ) "
            Else
                strSql = strSql & " AND MRP_GROUP_CDE " & IIf(InStr(vntMrpGroupCde, "%") > 0, "LIKE '", "= '") & vntMrpGroupCde & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>MRP Group:</strong> " & vntMrpGroupCde & ";"
        End If

        If vntTeam <> "" Then
            strSql = strSql & " AND TEAM_CODE = '" & vntTeam & "' "
            vntDispCrit = vntDispCrit & " <strong>Team:</strong> " & vntTeam & ";"
        End If

        If vntProdLne <> "" Then
            If InStr(vntProdLne, ",") > 0 Then
                strSql = strSql & " AND PRODUCT_LINE_CODE IN ( " & QuoteStr(vntProdLne) & " )"
            Else
                strSql = strSql & " AND PRODUCT_LINE_CODE = '" & vntProdLne & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Product Line:</strong> " & vntProdLne & ";"
        End If

        If vntInvOrg <> "" Then
            If InStr(vntInvOrg, ",") > 0 Then
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID IN ( " & QuoteStr(vntInvOrg) & " ) "
            Else
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID " & IIf(InStr(vntInvOrg, "%") > 0, "LIKE '", "= '") & vntInvOrg & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Inv Org/Plant:</strong> " & vntInvOrg & ";"
        End If

        If vntProdCde <> "" Then
            strSql = strSql & " AND PRODUCT_CODE = '" & vntProdCde & "' "
            vntDispCrit = vntDispCrit & " <strong>Product Code:</strong> " & vntProdCde & ";"
        End If

        If vntIBC <> "" Then
            If InStr(vntIBC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_BUSINESS_CDE IN ( " & QuoteStr(vntIBC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_BUSINESS_CDE = '" & vntIBC & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry Business:</strong> " & vntIBC & ";"
        End If

        If vntIC <> "" Then
            If InStr(vntIC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_CODE IN ( " & QuoteStr(vntIC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_CODE LIKE '" & vntIC & "%' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry:</strong> " & vntIC & ";"
        End If

        If vntWWCust <> "" Then
            vntTemp2 = vntWWCust
            intFound = 0
            vntTempWW = ""
            vntTempWW2 = ""
            intCountWW = 0
            
            intFound = InStr(vntWWCust, "-")
            If intFound <> 0 Then
                vntTempWW = Left(vntWWCust, intFound - 1)
                vntTempWW2 = Right(vntWWCust, Len(vntWWCust) - intFound)
            Else
                If Len(vntWWCust) > 10 Then
                    Err.Raise(901, , "WorldWide Number is invalid.  These numbers are required to have a maximum of 10 characters")
                ElseIf Len(vntWWCust) <= 8 Then
                    vntTempWW = vntWWCust
                ElseIf Len(vntWWCust) = 9 Then
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 1)
                Else
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 2)
                End If
            End If

            If Len(vntTempWW) < 8 Then
                For intCountWW = 1 To 8 - Len(vntTempWW)
                    vntTemp = vntTemp & "0"
                Next
                vntWWCust = vntTemp & vntTempWW
            Else
                vntWWCust = vntTempWW
            End If

            If Len(vntTempWW2) = 1 Then
                vntTempWW2 = "0" & vntTempWW2
                vntWWCust = vntWWCust & vntTempWW2
            Else
                vntWWCust = vntWWCust & vntTempWW2
            End If

            If Len(vntWWCust) > 8 Then
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
                strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
            Else
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
            End If

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntShipTo <> "" Then
            vntTemp2 = vntShipTo
            intCountST = 0
            vntTemp = ""
            
            vntShipTo = Replace(vntShipTo, "-", "")
            If Len(vntShipTo) < 10 Then
                For intCountST = 1 To 10 - Len(vntShipTo)
                    vntTemp = "0" & vntTemp
                Next
                vntShipTo = vntTemp & vntShipTo
            End If

            If Len(vntShipTo) > 10 Then
                Err.Raise(901, , "Ship To Number is invalid.  These numbers are required to have 10 characters")
            Else
                strSql = strSql & " AND PURCHASE_BY_ACCOUNT_BASE = '" & Left(vntShipTo, 8) & "'"
                strSql = strSql & " AND SHIP_TO_ACCOUNT_SUFFIX = '" & Right(vntShipTo, 2) & "'"
            End If

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing
            
            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntacctOrgKey <> "" Then
            strSql = strSql & " AND ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey
        End If

        If vntMfgCampus <> "" Then
            strSql = strSql & " AND MFG_CAMPUS_ID = '" & vntMfgCampus & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Campus:</strong> " & vntMfgCampus & ";"
        End If

        If vntMfgBuilding <> "" Then
            strSql = strSql & " AND MFG_BUILDING_NBR = '" & vntMfgBuilding & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Building:</strong> " & vntMfgBuilding & ";"
        End If

        If vntCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_ID = '" & vntCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Competency Business:</strong> " & vntCBC & ";"
        End If

        If vntSubCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_FNCTN_ID = '" & vntSubCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Sub-Competency Business:</strong> " & vntSubCBC & ";"
        End If

        If vntProfit <> "" Then
            strSql = strSql & " AND PROFIT_CENTER_ABBR_NM = '" & vntProfit & "' "
            vntDispCrit = vntDispCrit & " <strong>Profit Center:</strong> " & vntProfit & ";"
        End If

        If vntSalesOffice <> "" Then
            If InStr(vntSalesOffice, ",") > 0 Then
                strSql = strSql & " AND A.SALES_OFFICE_CDE IN ( " & QuoteStr(vntSalesOffice) & " ) "
            Else
                strSql = strSql & " AND A.SALES_OFFICE_CDE " & IIf(InStr(vntSalesOffice, "%") > 0, "LIKE '", "= '") & vntSalesOffice & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Office:</strong> " & vntSalesOffice & ";"
        End If

        If vntSoldTo <> "" Then
            vntTemp2 = vntSoldTo
            intCountST = 0
            vntTemp = ""
            
            vntSoldTo = Replace(vntSoldTo, "-", "")
            If Len(vntSoldTo) < 8 Then
                For intCountST = 1 To 8 - Len(vntSoldTo)
                    vntTemp = "0" & vntTemp
                Next
                vntSoldTo = vntTemp & vntSoldTo
            End If

            If Len(vntSoldTo) > 8 Then
                Err.Raise(901, , "Sold To Number is invalid.  These numbers are required to have 8 characters")
            Else
                strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
            End If

            blnrc = objGetSoldToName.RetrieveName(vntCustOrg, vntSoldTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetSoldToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        strSql = strSql & " GROUP BY ISO_COUNTRY_NM "
        strSql = strSql & " ORDER BY ISO_COUNTRY_NM "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)
        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsResults.ListSummMonByCntry call to CallRS for Monthly Query")
        End If

        ListSummMonByCntry = Nothing
        vntArray = Nothing
        
        If vntCount > 0 Then
            'For any recordsets we will pass back to the web ASP pages variant arrays
            'ListSummMnthly = objList.GetRows
            vntArray = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListSummMonByCntry = System.DBNull.Value
        End If

        '***********************vntArray Definition*************************************************
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
        '                               33   country_name

        '***********************vntTempArray Definition*************************************************
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

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If Not IsDBNull(ListSummMonByCntry) Then
            ReDim vntTempArray(38, CInt(vntCount))
            For intCount = 0 To UBound(vntArray, 2)
                intCount2 = intCount + 1
                '%6Early
                vntTempArray(0, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(0, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%5Early
                vntTempArray(1, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(1, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%4Early
                vntTempArray(2, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(2, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%3Early
                vntTempArray(3, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(3, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%2Early
                vntTempArray(4, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(4, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%1Early
                vntTempArray(5, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(5, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%ontime
                vntTempArray(6, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(6, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%1Late
                vntTempArray(7, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(7, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%2Late
                vntTempArray(8, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(8, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%3Late
                vntTempArray(9, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(9, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%4Late
                vntTempArray(10, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(10, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%5Late
                vntTempArray(11, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(11, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%6Late
                vntTempArray(12, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(12, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                'num6Early
                vntTempArray(18, intCount2) = VB6.Format(vntArray(5, intCount), "#,##0")
                vntTempArray(18, 0) = vntTempArray(18, 0) + vntArray(5, intCount)
                'num2Early
                vntTempArray(17, intCount2) = VB6.Format(vntArray(4, intCount), "#,##0")
                vntTempArray(17, 0) = vntTempArray(17, 0) + vntArray(4, intCount)
                'num3Early
                vntTempArray(16, intCount2) = VB6.Format(vntArray(3, intCount), "#,##0")
                vntTempArray(16, 0) = vntTempArray(16, 0) + vntArray(3, intCount)
                'num4Early
                vntTempArray(15, intCount2) = VB6.Format(vntArray(2, intCount), "#,##0")
                vntTempArray(15, 0) = vntTempArray(15, 0) + vntArray(2, intCount)
                'num5Early
                vntTempArray(14, intCount2) = VB6.Format(vntArray(1, intCount), "#,##0")
                vntTempArray(14, 0) = vntTempArray(14, 0) + vntArray(1, intCount)
                'num6Early
                vntTempArray(13, intCount2) = VB6.Format(vntArray(0, intCount), "#,##0")
                vntTempArray(13, 0) = vntTempArray(13, 0) + vntArray(0, intCount)
                'numontime
                vntTempArray(19, intCount2) = VB6.Format(CInt(vntArray(6, intCount)), "#,##0")
                vntTempArray(19, 0) = vntTempArray(19, 0) + vntArray(6, intCount)
                'num1Late
                vntTempArray(20, intCount2) = VB6.Format(vntArray(7, intCount), "#,##0")
                vntTempArray(20, 0) = vntTempArray(20, 0) + vntArray(7, intCount)
                'num2Late
                vntTempArray(21, intCount2) = VB6.Format(vntArray(8, intCount), "#,##0")
                vntTempArray(21, 0) = vntTempArray(21, 0) + vntArray(8, intCount)
                'num3Late
                vntTempArray(22, intCount2) = VB6.Format(vntArray(9, intCount), "#,##0")
                vntTempArray(22, 0) = vntTempArray(22, 0) + vntArray(9, intCount)
                'num4Late
                vntTempArray(23, intCount2) = VB6.Format(vntArray(10, intCount), "#,##0")
                vntTempArray(23, 0) = vntTempArray(23, 0) + vntArray(10, intCount)
                'num5Late
                vntTempArray(24, intCount2) = VB6.Format(vntArray(11, intCount), "#,##0")
                vntTempArray(24, 0) = vntTempArray(24, 0) + vntArray(11, intCount)
                'num6Late
                vntTempArray(25, intCount2) = VB6.Format(vntArray(12, intCount), "#,##0")
                vntTempArray(25, 0) = vntTempArray(25, 0) + vntArray(12, intCount)
                If vntWindowId = "1" Then
                    'SumEarly
                    vntTempArray(27, intCount2) = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(5, intCount))
                    vntTempArray(27, 0) = vntTempArray(27, 0) + vntTempArray(27, intCount2)
                    vntTempArray(27, intCount2) = VB6.Format(vntTempArray(27, intCount2), "#,##0")
                    'SumLate
                    vntTempArray(35, intCount2) = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                    vntTempArray(35, 0) = vntTempArray(35, 0) + vntTempArray(35, intCount2)
                    vntTempArray(35, intCount2) = VB6.Format(vntTempArray(35, intCount2), "#,##0")
                    'InWindowPercnt
                    vntTempArray(30, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(6, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                    'InWindowNum
                    vntTempArray(31, intCount2) = VB6.Format(CInt(vntArray(6, intCount)), "#,##0")
                    vntTempArray(31, 0) = vntTempArray(31, 0) + CInt(vntArray(6, intCount))
                ElseIf vntWindowId = "2" Then  ' Standard Default
                    'Figure out Days Early
                    If vntDaysEarly = "" Then
                        vntDaysEarly = "0"
                    End If
                    Select Case vntDaysEarly
                        Case "0"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(5, intCount))
                        Case "1"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(4, intCount))
                        Case "2"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount))
                        Case "3"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount))
                        Case "4"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount))
                        Case "5"
                            dblTemp1 = CDbl(vntArray(0, intCount))
                        Case Else
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(5, intCount))
                    End Select

                    vntTempArray(27, intCount2) = VB6.Format(dblTemp1, "#,##0")
                    vntTempArray(27, 0) = vntTempArray(27, 0) + dblTemp1

                    'Figure out Days Late

                    If vntDaysLate = "" Then
                        vntDaysLate = "0"
                    End If
                    Select Case vntDaysLate
                        Case "0"
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "1"
                            dblTemp2 = CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "2"
                            dblTemp2 = CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "3"
                            dblTemp2 = CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "4"
                            dblTemp2 = CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "5"
                            dblTemp2 = CDbl(vntArray(12, intCount))
                        Case Else
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                    End Select

                    vntTempArray(35, intCount2) = VB6.Format(dblTemp2, "#,##0")
                    vntTempArray(35, 0) = vntTempArray(35, 0) + dblTemp2

                    'Figure out In Window

                    Select Case vntDaysEarly
                        Case "0"
                            dblTemp1 = 0
                        Case "1"
                            dblTemp1 = CDbl(vntArray(5, intCount))
                        Case "2"
                            dblTemp1 = CDbl(vntArray(5, intCount)) + CDbl(vntArray(4, intCount))
                        Case "3"
                            dblTemp1 = CDbl(vntArray(5, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(3, intCount))
                        Case "4"
                            dblTemp1 = CDbl(vntArray(5, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(2, intCount))
                        Case "5"
                            dblTemp1 = CDbl(vntArray(5, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(1, intCount))
                        Case Else
                            dblTemp1 = 0
                    End Select

                    Select Case vntDaysLate
                        Case "0"
                            dblTemp2 = 0
                        Case "1"
                            dblTemp2 = CDbl(vntArray(7, intCount))
                        Case "2"
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount))
                        Case "3"
                            dblTemp2 = (CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)))
                        Case "4"
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount))
                        Case "5"
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount))
                        Case Else
                            dblTemp2 = 0
                    End Select

                    'InWindowNum

                    vntTempArray(31, intCount2) = VB6.Format(dblTemp1 + dblTemp2 + CInt(vntArray(6, intCount)), "#,##0")
                    vntTempArray(31, 0) = vntTempArray(31, 0) + dblTemp1 + dblTemp2 + CInt(vntArray(6, intCount))

                    'InWindowPercnt

                    vntTempArray(30, intCount2) = VB6.Format(System.Math.Round(vntTempArray(31, intCount2) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                End If

                'SumEarlyPercnt

                vntTempArray(26, intCount2) = VB6.Format(System.Math.Round(CInt(vntTempArray(27, intCount2)) / CInt(vntArray(13, intCount)), 3), "0.0%")

                'SumLatePercnt

                vntTempArray(34, intCount2) = VB6.Format(System.Math.Round(CDbl(vntTempArray(35, intCount2)) / CDbl(vntArray(13, intCount)), 3), "0.0%")

                If vntSmryType = "1" Then

                    'sumJITEarly

                    vntTempArray(29, intCount2) = CDbl(vntArray(14, intCount)) + CDbl(vntArray(15, intCount)) + CDbl(vntArray(16, intCount)) + CDbl(vntArray(17, intCount)) + CDbl(vntArray(18, intCount)) + CDbl(vntArray(19, intCount))
                    vntTempArray(29, 0) = vntTempArray(29, 0) + vntTempArray(29, intCount2)
                    vntTempArray(29, intCount2) = VB6.Format(vntTempArray(29, intCount2), "#,##0")

                    'sumJITLate

                    vntTempArray(33, intCount2) = CDbl(vntArray(21, intCount)) + CDbl(vntArray(22, intCount)) + CDbl(vntArray(23, intCount)) + CDbl(vntArray(24, intCount)) + CDbl(vntArray(25, intCount)) + CDbl(vntArray(26, intCount))
                    vntTempArray(33, 0) = vntTempArray(33, 0) + vntTempArray(33, intCount2)
                    vntTempArray(33, intCount2) = VB6.Format(vntTempArray(33, intCount2), "#,##0")

                    'JITEarlyPercnt

                    vntTempArray(28, intCount2) = VB6.Format(System.Math.Round(CInt(vntTempArray(29, intCount2)) / CInt(vntArray(13, intCount)), 3), "0.0%")

                    'JITLatePercnt

                    vntTempArray(32, intCount2) = VB6.Format(System.Math.Round(CDbl(vntTempArray(33, intCount2)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                End If

                'Total

                vntTempArray(37, intCount2) = VB6.Format(vntArray(13, intCount), "#,##0")
                vntTempArray(37, 0) = vntTempArray(37, 0) + vntArray(13, intCount)
                vntTempArray(36, intCount2) = VB6.Format(1, "0%")

                'country_name

                vntTempArray(38, intCount2) = vntArray(33, intCount)
            Next

            vntTempArray(38, 0) = "TOTAL"
            'calculate & format totals
            For intCount2 = 0 To 37
                If intCount2 <= 12 Then
                    vntTempArray(intCount2, 0) = VB6.Format(vntTempArray(intCount2 + 13, 0) / vntTempArray(37, 0), "0.0%")
                ElseIf intCount2 = 26 Or intCount2 = 28 Or intCount2 = 30 Or intCount2 = 32 Or intCount2 = 34 Then
                    vntTempArray(intCount2, 0) = VB6.Format(vntTempArray(intCount2 + 1, 0) / vntTempArray(37, 0), "0.0%")
                ElseIf intCount2 = 36 Then
                    vntTempArray(intCount2, 0) = VB6.Format(vntTempArray(intCount2 + 1, 0) / vntTempArray(37, 0), "0%")
                Else
                    vntTempArray(intCount2, 0) = VB6.Format(vntTempArray(intCount2, 0), "#,##0")
                End If
            Next
            vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
            vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
            ListSummMonByCntry = vntTempArray
        Else
            Err.Raise(100, , "No results were found.(in clsResults.ListSummMonByCntry)")
        End If

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListSummMonByCntry = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

	Public Function ListSummDlyByCntry(ByVal vntSessionID As Object, ByVal vntRptType As Object, ByRef vntDispCrit As Object, ByRef vntSmryType As Object, ByRef vntWindowId As Object, ByRef vntDaysEarly As Object, ByRef vntDaysLate As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim objSearch As New clsSearch
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
        Dim vntCount As Integer
		Dim vntArray As Object
		Dim vntTempArray As Object
		Dim dblTemp1 As Double
		Dim dblTemp2 As Double
		Dim blnCommon As Boolean
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgID As Object
        'Dim vntMonthDailyInd As Object
        'Dim vntCustAcctTypeCde As Object
        'Dim vntPart As Object
        'Dim vntPlant As Object
        'Dim vntLocation As Object
        'Dim vntacctOrgKey As Object
        'Dim vntShipTo As Object
        'Dim vntSoldTo As Object
        'Dim vntWWCust As Object
        'Dim vntInvOrg As Object
        'Dim vntController As Object
        'Dim vntCntlrEmpNbr As Object
        'Dim vntStkMake As Object
        'Dim vntTeam As Object
        'Dim vntProdCde As Object
        'Dim vntProdLne As Object
        'Dim vntIBC As Object
        'Dim vntIC As Object
        'Dim vntMfgCampus As Object
        'Dim vntMfgBuilding As Object
        'Dim vntComparisonType As Object
        'Dim vntOpenShpOrder As Object
        'Dim vntProfit As Object
        'Dim vntCBC As Object
        'Dim vntSubCBC As Object
        'Dim vntOrgDate As Object
        'Dim vntOrgType As Object
        'Dim vntKeyId As Object
        'Dim vntLevel As Object
        'Dim vntLength As Object
        'Dim vntOrgTypeDesc As Object
        'Dim intCountST As Short
        'Dim vntTemp As Object
        'Dim vntTempWW As Object
        'Dim vntTempWW2 As Object
        'Dim intCountWW As Short
        'Dim intFound As Short
        '      Dim objGetWWName As New clsWrldWide
        '      Dim objGetShipToName As New clsShipTo
        '      Dim objGetSoldToName As New clsSoldTo
        '      Dim vntName As Object
        'Dim vntTemp2 As Object
        'Dim vntCustOrg As Object
        Dim intCount As Integer
        Dim intCount2 As Integer
        'Dim vntProdMgr As Object
        'Dim vntLeadTimeType As Object
        'Dim vntSalesOffice As Object
        'Dim vntSalesGroup As Object
        'Dim vntMfgOrgType As Object
        'Dim vntMfgOrgId As Object
        'Dim GamAccount As Object
        'Dim vntPartKeyID As Object
        'Dim vntMrpGroupCde As Object
        'Dim vntHostOrgID As Object
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
        Dim vntCurrentHist As String = ""
        Dim vntOrgID As String = ""
        Dim vntMonthDailyInd As String = ""
        Dim vntCustAcctTypeCde As String = ""
        Dim vntPart As String = ""
        Dim vntPlant As String = ""
        Dim vntLocation As String = ""
        Dim vntacctOrgKey As String = ""
        Dim vntShipTo As String = ""
        Dim vntSoldTo As String = ""
        Dim vntWWCust As String = ""
        Dim vntInvOrg As String = ""
        Dim vntController As String = ""
        Dim vntCntlrEmpNbr As String = ""
        Dim vntStkMake As String = ""
        Dim vntTeam As String = ""
        Dim vntProdCde As String = ""
        Dim vntProdLne As String = ""
        Dim vntIBC As String = ""
        Dim vntIC As String = ""
        Dim vntMfgCampus As String = ""
        Dim vntMfgBuilding As String = ""
        Dim vntComparisonType As String = ""
        Dim vntOpenShpOrder As String = ""
        Dim vntProfit As String = ""
        Dim vntCBC As String = ""
        Dim vntSubCBC As String = ""
        Dim vntOrgDate As String = ""
        Dim vntOrgType As String = ""
        Dim vntKeyId As Long
        Dim vntLevel As String = ""
        Dim vntLength As Integer
        Dim vntOrgTypeDesc As String = ""
        Dim intCountST As Integer
        Dim vntTemp As String = ""
        Dim vntTempWW As String = ""
        Dim vntTempWW2 As String = ""
        Dim intCountWW As Integer
        Dim intFound As Integer
        Dim objGetWWName As New clsWrldWide
        Dim objGetShipToName As New clsShipTo
        Dim objGetSoldToName As New clsSoldTo
        Dim vntName As String = ""
        Dim vntTemp2 As String = ""
        Dim vntCustOrg As String = ""
        Dim vntProdMgr As String = ""
        Dim vntLeadTimeType As String = ""
        Dim vntSalesOffice As String = ""
        Dim vntSalesGroup As String = ""
        Dim vntMfgOrgType As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgLevel As String = ""
        Dim GamAccount As String = ""
        Dim vntPartKeyID As String = ""
        Dim vntMrpGroupCde As String = ""
        Dim vntHostOrgID As String = ""

		On Error GoTo ErrorHandler
		
		blnCommon = False
		dblTemp1 = 0
		dblTemp2 = 0

        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResults.ListSummDlyByCntry")
        End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDate, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNumber, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        
        If Not blnrc Or vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsSearch.RetrieveSession from clsResults.ListSummDlyByCntry")
        End If

        If vntOrgID <> "" Then
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If
            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"
            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDate, vntLevel, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel from clsResults.ListSummDlyByCntry")
            End If
            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org ID:</strong> " & vntacctOrgKey & ";"
            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDate, vntKeyId, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If
            vntacctOrgKey = vntKeyId
        End If
        
        If vntWindowId = "1" Then 'Customer Variable
            If vntSmryType = "1" Then 'STS
                strSql = " SELECT   NVL(SUM(DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, -999), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, -6),1)), 0) var_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -5, 1)), 0) var_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -4, 1)), 0) var_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -3, 1)), 0) var_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -2, 1)), 0) var_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -1, 1)), 0) var_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 0, 1)), 0) var_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 1, 1)), 0) var_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 2, 1)), 0) var_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 3, 1)), 0) var_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 4, 1)), 0) var_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 5, 1)), 0) var_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, 6), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, 999),1)), 0) var_six_plus_late,   "
                strSql = strSql & " NVL(COUNT(*), 0) var_total,    "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, -999), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, -6), 1))), 0) jit_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -5, 1))), 0) jit_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -4, 1))), 0) jit_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -3, 1))), 0) jit_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -2, 1))), 0) jit_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, -1, 1))), 0) jit_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 0, 1))), 0) jit_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 1, 1))), 0) jit_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 2, 1))), 0) jit_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 3, 1))), 0) jit_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 4, 1))), 0) jit_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(VARBL_SCHEDULE_SHIP_VARIANCE, 5, 1))), 0) jit_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(VARBL_SCHEDULE_SHIP_VARIANCE, 6), LEAST(VARBL_SCHEDULE_SHIP_VARIANCE, 999), 1))), 0) jit_six_plus_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', 1)), 0) jit_total "
                vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
            Else 'STR
                strSql = " SELECT NVL(SUM(DECODE(GREATEST(VARBL_REQUEST_SHIP_VARIANCE, -999), LEAST(VARBL_REQUEST_SHIP_VARIANCE, -6),1)), 0) var_six_plus_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -5, 1)), 0) var_five_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -4, 1)), 0) var_four_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -3, 1)), 0) var_three_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -2, 1)), 0) var_two_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, -1, 1)), 0) var_one_early, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 0, 1)), 0) var_on_time, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 1, 1)), 0) var_one_late, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 2, 1)), 0) var_two_late, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 3, 1)), 0) var_three_late, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 4, 1)), 0) var_four_late, "
                strSql = strSql & " NVL(SUM(DECODE(VARBL_REQUEST_SHIP_VARIANCE, 5, 1)), 0) var_five_late, "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(VARBL_REQUEST_SHIP_VARIANCE, 6), LEAST(VARBL_REQUEST_SHIP_VARIANCE, 999),1)), 0) var_six_plus_late, "
                strSql = strSql & " NVL(COUNT(*), 0) var_total,   "
                blnCommon = True
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
            End If

        Else 'std default
            If vntSmryType = "1" Then 'STS
                strSql = " SELECT NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -6),1)), 0) def_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -5, 1)), 0) def_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -4, 1)), 0) def_four_early,  "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -3, 1)), 0) def_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -2, 1)), 0) def_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, -1, 1)), 0) def_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 0, 1)), 0) def_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 1, 1)), 0) def_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 2, 1)), 0) def_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 3, 1)), 0) def_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 4, 1)), 0) def_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(SCHEDULE_TO_SHIP_VARIANCE, 5, 1)), 0) def_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 6), LEAST(SCHEDULE_TO_SHIP_VARIANCE, 999),1)), 0) def_six_plus_late,   "
                strSql = strSql & " NVL(COUNT(*), 0) def_total,  "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, -999), LEAST(SCHEDULE_TO_SHIP_VARIANCE, -6), 1))), 0) jit_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -5, 1))), 0) jit_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -4, 1))), 0) jit_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -3, 1))), 0) jit_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -2, 1))), 0) jit_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, -1, 1))), 0) jit_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 0, 1))), 0) jit_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 1, 1))), 0) jit_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 2, 1))), 0) jit_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 3, 1))), 0) jit_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 4, 1))), 0) jit_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(SCHEDULE_TO_SHIP_VARIANCE, 5, 1))), 0) jit_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', DECODE(GREATEST(SCHEDULE_TO_SHIP_VARIANCE, 6), LEAST(SCHEDULE_TO_SHIP_VARIANCE, 999), 1))), 0) jit_six_plus_late,   "
                strSql = strSql & " NVL(SUM(DECODE(CUSTOMER_TYPE_CODE,'J', 1)), 0) jit_total"
                vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
            ElseIf vntSmryType = "2" Then  'Standard Default (2) Request To Ship
                strSql = " SELECT NVL(SUM(DECODE(GREATEST(REQUEST_TO_SHIP_VARIANCE, -999), LEAST(REQUEST_TO_SHIP_VARIANCE, -6),1)), 0) def_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -5, 1)), 0) def_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -4, 1)), 0) def_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -3, 1)), 0) def_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -2, 1)), 0) def_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, -1, 1)), 0) def_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 0, 1)), 0) def_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 1, 1)), 0) def_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 2, 1)), 0) def_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 3, 1)), 0) def_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 4, 1)), 0) def_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SHIP_VARIANCE, 5, 1)), 0) def_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(REQUEST_TO_SHIP_VARIANCE, 6), LEAST(REQUEST_TO_SHIP_VARIANCE, 999),1)), 0) def_six_plus_late,  "
                strSql = strSql & " NVL(COUNT(*), 0) def_total,  "
                blnCommon = True
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
            Else ' Standard Default (3) Request to Schd
                strSql = " SELECT NVL(SUM(DECODE(GREATEST(REQUEST_TO_SCHEDULE_VARIANCE, -999), LEAST(REQUEST_TO_SCHEDULE_VARIANCE, -6),1)), 0) def_six_plus_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -5, 1)), 0) def_five_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -4, 1)), 0) def_four_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -3, 1)), 0) def_three_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -2, 1)), 0) def_two_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, -1, 1)), 0) def_one_early,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 0, 1)), 0) def_on_time,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 1, 1)), 0) def_one_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 2, 1)), 0) def_two_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 3, 1)), 0) def_three_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 4, 1)), 0) def_four_late,   "
                strSql = strSql & " NVL(SUM(DECODE(REQUEST_TO_SCHEDULE_VARIANCE, 5, 1)), 0) def_five_late,   "
                strSql = strSql & " NVL(SUM(DECODE(GREATEST(REQUEST_TO_SCHEDULE_VARIANCE, 6), LEAST(REQUEST_TO_SCHEDULE_VARIANCE, 999),1)), 0) def_six_plus_late,   "
                strSql = strSql & " NVL(COUNT(*), 0) def_total,   "
                blnCommon = True
                vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request to Schedule;"
            End If
        End If

        If blnCommon Then 'Common worthless code that keeps the array in sync
            strSql = strSql & " 0 jit_six_plus_early,   "
            strSql = strSql & " 0 jit_five_early,   "
            strSql = strSql & " 0 jit_four_early,   "
            strSql = strSql & " 0 jit_three_early,   "
            strSql = strSql & " 0 jit_two_early,   "
            strSql = strSql & " 0 jit_one_early,   "
            strSql = strSql & " 0 jit_on_time,   "
            strSql = strSql & " 0 jit_one_late,   "
            strSql = strSql & " 0 jit_two_late,   "
            strSql = strSql & " 0 jit_three_late,   "
            strSql = strSql & " 0 jit_four_late,   "
            strSql = strSql & " 0 jit_five_late,   "
            strSql = strSql & " 0 jit_six_plus_late,   "
            strSql = strSql & " 0 jit_total"
        End If

        If vntRptType = "1" Then
            strSql = strSql & " , ISO_COUNTRY_NM "
        ElseIf vntRptType = "2" Then
            strSql = strSql & " , ISO_CTRY_NAME "
        End If

        strSql = strSql & " FROM ORDER_ITEM_SHIPMENT A, "
        strSql = strSql & " ORGANIZATIONS_DMN C "

        If vntViewId = "10" Then
            strSql = strSql & " , ORGANIZATIONS_DMN D "
        End If

        If vntRptType = "2" Then
            strSql = strSql & " , GBL_ALL_CUST_SHIP_TO E, GBL_ISO_COUNTRY F "
        End If

        strSql = strSql & " WHERE  C.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        
        If vntViewId = "10" Then
            strSql = strSql & " AND  A.MFR_ORG_KEY_ID = C.ORGANIZATION_KEY_ID "
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = D.ORGANIZATION_KEY_ID "
        Else
            strSql = strSql & " AND  A.ORGANIZATION_KEY_ID = C.ORGANIZATION_KEY_ID "
        End If

        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                If vntViewId = "10" Then
                    strSql = strSql & "AND C.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                Else
                    strSql = strSql & " AND C.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                End If
            Else
                If vntViewId = "10" Then
                    strSql = strSql & "AND C.EFFECTIVE_FROM_DT = "
                    strSql = strSql & "(SELECT MAX(Y.EFFECTIVE_FROM_DT) FROM ORGANIZATIONS_DMN Y "
                    strSql = strSql & " WHERE Y.ORGANIZATION_KEY_ID = A.MFR_ORG_KEY_ID "
                    strSql = strSql & " AND Y.ORGANIZATION_STATUS_CDE = '1') "
                Else
                    strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
            End If
            If vntViewId = "10" Then
                If vntCurrentHist = "C" Then
                    strSql = strSql & " AND D.RECORD_STATUS_CDE = '" & vntCurrentHist & "' "
                Else
                    strSql = strSql & " AND (D.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDate & "', 'YYYY-MM-DD')"
                    strSql = strSql & " AND D.EFFECTIVE_TO_DT >= to_date('" & vntOrgDate & "', 'YYYY-MM-DD'))"
                End If
            End If
        Else
            strSql = strSql & " AND C.RECORD_STATUS_CDE = 'C' "
        End If

        strSql = strSql & " AND AMP_SHIPPED_DATE BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"

        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"

        If vntStkMake <> "" Then
            vntLength = Len(vntStkMake)
            strSql = strSql & " AND substr(STOCK_MAKE_CODE,1," & vntLength & ") = '" & vntStkMake & "' "
            vntDispCrit = vntDispCrit & " <strong>Make Stock:</strong> " & vntStkMake & ";"
        End If

        If vntMrpGroupCde <> "" Then
            If InStr(vntMrpGroupCde, ",") > 0 Then
                strSql = strSql & " AND MRP_GROUP_CDE IN ( " & QuoteStr(vntMrpGroupCde) & " ) "
            Else
                strSql = strSql & " AND MRP_GROUP_CDE " & IIf(InStr(vntMrpGroupCde, "%") > 0, "LIKE '", "= '") & vntMrpGroupCde & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>MRP Group:</strong> " & vntMrpGroupCde & ";"
        End If

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        If vntTeam <> "" Then
            strSql = strSql & " AND TEAM_CODE = '" & vntTeam & "' "
            vntDispCrit = vntDispCrit & " <strong>Team:</strong> " & vntTeam & ";"
        End If

        If vntProdLne <> "" Then
            If InStr(vntProdLne, ",") > 0 Then
                strSql = strSql & " AND PRODUCT_LINE_CODE IN ( " & QuoteStr(vntProdLne) & " )"
            Else
                strSql = strSql & " AND PRODUCT_LINE_CODE = '" & vntProdLne & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Product Line:</strong> " & vntProdLne & ";"
        End If

        If vntInvOrg <> "" Then
            If InStr(vntInvOrg, ",") > 0 Then
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID IN ( " & QuoteStr(vntInvOrg) & " ) "
            Else
                strSql = strSql & " AND CONTROLLER_UNIQUENESS_ID " & IIf(InStr(vntInvOrg, "%") > 0, "LIKE '", "= '") & vntInvOrg & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Inv Org/Plant:</strong> " & vntInvOrg & ";"
        End If

        If vntProdCde <> "" Then
            strSql = strSql & " AND PRODUCT_CODE = '" & vntProdCde & "' "
            vntDispCrit = vntDispCrit & " <strong>Product Code:</strong> " & vntProdCde & ";"
        End If

        If vntWWCust <> "" Then
            vntTemp2 = vntWWCust
            intFound = 0
            vntTempWW = ""
            vntTempWW2 = ""
            intCountWW = 0
            intFound = InStr(vntWWCust, "-")
            If intFound <> 0 Then
                vntTempWW = Left(vntWWCust, intFound - 1)
                vntTempWW2 = Right(vntWWCust, Len(vntWWCust) - intFound)
            Else
                If Len(vntWWCust) > 10 Then
                    Err.Raise(901, , "WorldWide Number is invalid.  These numbers are required to have a maximum of 10 characters")
                ElseIf Len(vntWWCust) <= 8 Then
                    vntTempWW = vntWWCust
                ElseIf Len(vntWWCust) = 9 Then
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 1)
                Else
                    vntTempWW = Left(vntWWCust, 8)
                    vntTempWW2 = Right(vntWWCust, 2)
                End If
            End If
            If Len(vntTempWW) < 8 Then
                For intCountWW = 1 To 8 - Len(vntTempWW)
                    vntTemp = vntTemp & "0"
                Next
                vntWWCust = vntTemp & vntTempWW
            Else
                vntWWCust = vntTempWW
            End If
            If Len(vntTempWW2) = 1 Then
                vntTempWW2 = "0" & vntTempWW2
                vntWWCust = vntWWCust & vntTempWW2
            Else
                vntWWCust = vntWWCust & vntTempWW2
            End If
            If Len(vntWWCust) > 8 Then
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & Left(vntWWCust, 8) & "'"
                strSql = strSql & " AND WW_ACCOUNT_NBR_SUFFIX = '" & Right(vntWWCust, 2) & "'"
            Else
                strSql = strSql & " AND WW_ACCOUNT_NBR_BASE = '" & vntWWCust & "'"
            End If

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntShipTo <> "" Then
            vntTemp2 = vntShipTo
            intCountST = 0
            vntTemp = ""
            vntShipTo = Replace(vntShipTo, "-", "")
            If Len(vntShipTo) < 10 Then
                For intCountST = 1 To 10 - Len(vntShipTo)
                    vntTemp = "0" & vntTemp
                Next
                vntShipTo = vntTemp & vntShipTo
            End If

            If Len(vntShipTo) > 10 Then
                Err.Raise(901, , "Ship To Number is invalid.  These numbers are required to have 10 characters")
            Else
                strSql = strSql & " AND PURCHASE_BY_ACCOUNT_BASE = '" & Left(vntShipTo, 8) & "'"
                strSql = strSql & " AND SHIP_TO_ACCOUNT_SUFFIX = '" & Right(vntShipTo, 2) & "'"
            End If

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntacctOrgKey <> "" Then
            strSql = strSql & " AND ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey
        End If

        If vntMfgCampus <> "" Then
            strSql = strSql & " AND MFG_CAMPUS_ID = '" & vntMfgCampus & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Campus:</strong> " & vntMfgCampus & ";"
        End If

        If vntMfgBuilding <> "" Then
            strSql = strSql & " AND MFG_BUILDING_NBR = '" & vntMfgBuilding & "' "
            vntDispCrit = vntDispCrit & " <strong>Mfg Building:</strong> " & vntMfgBuilding & ";"
        End If

        If vntIBC <> "" Then
            If InStr(vntIBC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE IN ( " & QuoteStr(vntIBC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_BUSINESS_CODE = '" & vntIBC & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry Business:</strong> " & vntIBC & ";"
        End If

        If vntIC <> "" Then
            If InStr(vntIC, ",") > 0 Then
                strSql = strSql & " AND INDUSTRY_CODE IN ( " & QuoteStr(vntIC) & " ) "
            Else
                strSql = strSql & " AND INDUSTRY_CODE LIKE '" & vntIC & "%' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Industry:</strong> " & vntIC & ";"
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If vntPart <> "" And Not IsDBNull(vntPartKeyID) Then
            '    intCountST = 0
            '    vntTemp = ""
            '    vntPart = Replace(vntPart, "-", "")
            '    If Len(vntPart) < 9 Then
            '        For intCountST = 1 To 9 - Len(vntPart)
            '            vntTemp = "0" & vntTemp
            '        Next
            '        vntPart = vntTemp & vntPart
            '    End If
            '    strSql = strSql & " AND Part_Nbr = '" & vntPart & "' "
            strSql = strSql & " AND PART_KEY_ID = " & vntPartKeyID
            vntDispCrit = vntDispCrit & " <strong>Part:</strong> " & vntPart & ";"
        End If

        If vntController <> "" Then
            If InStr(vntController, ",") > 0 Then
                strSql = strSql & " AND PRODCN_CNTRLR_CODE IN ( " & QuoteStr(vntController) & " ) "
            Else
                strSql = strSql & " AND PRODCN_CNTRLR_CODE " & IIf(InStr(vntController, "%") > 0, "LIKE '", "= '") & vntController & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Controller:</strong> " & vntController & ";"
        End If

        If vntPlant <> "" Then
            strSql = strSql & " AND (ACTUAL_SHIP_BUILDING_NBR = '" & vntPlant & "')"
            vntDispCrit = vntDispCrit & " <strong>Plant/Blg:</strong> " & vntPlant & ";"
        End If

        If vntLocation <> "" Then
            strSql = strSql & " AND ACTUAL_SHIP_LOCATION = '" & vntLocation & "'"
            vntDispCrit = vntDispCrit & " <strong>Location:</strong> " & vntLocation & ";"
        End If

        If vntCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_ID = '" & vntCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Competency Business:</strong> " & vntCBC & ";"
        End If

        If vntSubCBC <> "" Then
            strSql = strSql & " AND PRODUCT_BUSNS_LINE_FNCTN_ID = '" & vntSubCBC & "' "
            vntDispCrit = vntDispCrit & " <strong>Sub-Competency Business:</strong> " & vntSubCBC & ";"
        End If

        If vntProfit <> "" Then
            strSql = strSql & " AND PROFIT_CENTER_ABBR_NM = '" & vntProfit & "' "
            vntDispCrit = vntDispCrit & " <strong>Profit Center:</strong> " & vntProfit & ";"
        End If

        If vntSalesOffice <> "" Then
            If InStr(vntSalesOffice, ",") > 0 Then
                strSql = strSql & " AND A.SALES_OFFICE_CDE IN ( " & QuoteStr(vntSalesOffice) & " ) "
            Else
                strSql = strSql & " AND A.SALES_OFFICE_CDE " & IIf(InStr(vntSalesOffice, "%") > 0, "LIKE '", "= '") & vntSalesOffice & "' "
            End If
            vntDispCrit = vntDispCrit & " <strong>Sales Office:</strong> " & vntSalesOffice & ";"
        End If

        If vntSoldTo <> "" Then
            vntTemp2 = vntSoldTo
            intCountST = 0
            vntTemp = ""
            vntSoldTo = Replace(vntSoldTo, "-", "")
            If Len(vntSoldTo) < 8 Then
                For intCountST = 1 To 8 - Len(vntSoldTo)
                    vntTemp = "0" & vntTemp
                Next
                vntSoldTo = vntTemp & vntSoldTo
            End If
            If Len(vntSoldTo) > 8 Then
                Err.Raise(901, , "Sold To Number is invalid.  These numbers are required to have 8 characters")
            Else
                strSql = strSql & " AND SOLD_TO_CUSTOMER_ID = '" & vntSoldTo & "'"
            End If

            blnrc = objGetSoldToName.RetrieveName(vntCustOrg, vntSoldTo, vntName, vntErrorNumber, vntErrorDesc)
            If Not blnrc Then
                
                vntName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetSoldToName = Nothing

            vntDispCrit = vntDispCrit & " <strong>Sold To:</strong> " & vntTemp2 & " " & vntName & ";"
            vntTemp2 = ""
            vntName = ""
        End If

        If vntRptType = "2" Then
            strSql = strSql & " AND E.ST_ACCT_ORG_ID = (SELECT ORGANIZATION_ID "
            strSql = strSql & "                         FROM   ORGANIZATIONS_DMN "
            strSql = strSql & "                         WHERE  ORGANIZATION_KEY_ID = A.ACCOUNTING_ORG_KEY_ID "
            strSql = strSql & "                         AND    RECORD_STATUS_CDE = 'C') "
            strSql = strSql & " AND A.PURCHASE_BY_ACCOUNT_BASE = E.ST_ACCT_NBR_BASE "
            strSql = strSql & " AND A.SHIP_TO_ACCOUNT_SUFFIX = E.ST_ACCT_NBR_SUFX "
            strSql = strSql & " AND E.ST_ISO_CTRY_CODE = F.ISO_CTRY_CODE "
        End If

        If vntRptType = "1" Then
            strSql = strSql & " GROUP BY ISO_COUNTRY_NM "
            strSql = strSql & " ORDER BY ISO_COUNTRY_NM "
        ElseIf vntRptType = "2" Then
            strSql = strSql & " GROUP BY ISO_CTRY_NAME "
            strSql = strSql & " ORDER BY ISO_CTRY_NAME "
        End If

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)
        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsTemplate.ListExample call to CallRS for Public View Query")
        End If

        ListSummDlyByCntry = Nothing
        vntArray = Nothing
        
        If vntCount > 0 Then
            'For any recordsets we will pass back to the web ASP pages variant arrays
            vntArray = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListSummDlyByCntry = System.DBNull.Value
        End If

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

        '***********************vntTempArray Definition*************************************************
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

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If Not IsDBNull(ListSummDlyByCntry) Then
            ReDim vntTempArray(38, CInt(vntCount))
            For intCount = 0 To UBound(vntArray, 2)
                intCount2 = intCount + 1
                '%6Early
                vntTempArray(0, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(0, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%5Early
                vntTempArray(1, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(1, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%4Early
                vntTempArray(2, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(2, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%3Early
                vntTempArray(3, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(3, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%2Early
                vntTempArray(4, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(4, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%1Early
                vntTempArray(5, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(5, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%ontime
                vntTempArray(6, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(6, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%1Late
                vntTempArray(7, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(7, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%2Late
                vntTempArray(8, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(8, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%3Late
                vntTempArray(9, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(9, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%4Late
                vntTempArray(10, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(10, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%5Late
                vntTempArray(11, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(11, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                '%6Late
                vntTempArray(12, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(12, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                'num1Early
                vntTempArray(18, intCount2) = VB6.Format(vntArray(5, intCount), "#,##0")
                vntTempArray(18, 0) = vntTempArray(18, 0) + vntArray(5, intCount)
                'num2Early
                vntTempArray(17, intCount2) = VB6.Format(vntArray(4, intCount), "#,##0")
                vntTempArray(17, 0) = vntTempArray(17, 0) + vntArray(4, intCount)
                'num3Early
                vntTempArray(16, intCount2) = VB6.Format(vntArray(3, intCount), "#,##0")
                vntTempArray(16, 0) = vntTempArray(16, 0) + vntArray(3, intCount)
                'num4Early
                vntTempArray(15, intCount2) = VB6.Format(vntArray(2, intCount), "#,##0")
                vntTempArray(15, 0) = vntTempArray(15, 0) + vntArray(2, intCount)
                'num5Early
                vntTempArray(14, intCount2) = VB6.Format(vntArray(1, intCount), "#,##0")
                vntTempArray(14, 0) = vntTempArray(14, 0) + vntArray(1, intCount)
                'num6Early
                vntTempArray(13, intCount2) = VB6.Format(vntArray(0, intCount), "#,##0")
                vntTempArray(13, 0) = vntTempArray(13, 0) + vntArray(0, intCount)
                'numontime
                vntTempArray(19, intCount2) = VB6.Format(CInt(vntArray(6, intCount)), "#,##0")
                vntTempArray(19, 0) = vntTempArray(19, 0) + vntArray(6, intCount)
                'num1Late
                vntTempArray(20, intCount2) = VB6.Format(vntArray(7, intCount), "#,##0")
                vntTempArray(20, 0) = vntTempArray(20, 0) + vntArray(7, intCount)
                'num2Late
                vntTempArray(21, intCount2) = VB6.Format(vntArray(8, intCount), "#,##0")
                vntTempArray(21, 0) = vntTempArray(21, 0) + vntArray(8, intCount)
                'num3Late
                vntTempArray(22, intCount2) = VB6.Format(vntArray(9, intCount), "#,##0")
                vntTempArray(22, 0) = vntTempArray(22, 0) + vntArray(9, intCount)
                'num4Late
                vntTempArray(23, intCount2) = VB6.Format(vntArray(10, intCount), "#,##0")
                vntTempArray(23, 0) = vntTempArray(23, 0) + vntArray(10, intCount)
                'num5Late
                vntTempArray(24, intCount2) = VB6.Format(vntArray(11, intCount), "#,##0")
                vntTempArray(24, 0) = vntTempArray(24, 0) + vntArray(11, intCount)
                'num6Late
                vntTempArray(25, intCount2) = VB6.Format(vntArray(12, intCount), "#,##0")
                vntTempArray(25, 0) = vntTempArray(25, 0) + vntArray(12, intCount)
                If vntWindowId = "1" Then 'Customer Variable
                    'SumEarly
                    vntTempArray(27, intCount2) = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(5, intCount))
                    vntTempArray(27, 0) = vntTempArray(27, 0) + vntTempArray(27, intCount2)
                    vntTempArray(27, intCount2) = VB6.Format(vntTempArray(27, intCount2), "#,##0")
                    'SumLate
                    vntTempArray(35, intCount2) = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                    vntTempArray(35, 0) = vntTempArray(35, 0) + vntTempArray(35, intCount2)
                    vntTempArray(35, intCount2) = VB6.Format(vntTempArray(35, intCount2), "#,##0")
                    'InWindowPercnt
                    vntTempArray(30, intCount2) = VB6.Format(System.Math.Round(CDbl(vntArray(6, intCount)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                    'InWindowNum
                    vntTempArray(31, intCount2) = VB6.Format(CInt(vntArray(6, intCount)), "#,##0")
                    vntTempArray(31, 0) = vntTempArray(31, 0) + CInt(vntArray(6, intCount))
                ElseIf vntWindowId = "2" Then  ' Standard Default
                    'Figure out Days Early
                    If vntDaysEarly = "" Then
                        vntDaysEarly = "0"
                    End If
                    Select Case vntDaysEarly
                        Case "0"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(5, intCount))
                        Case "1"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(4, intCount))
                        Case "2"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount))
                        Case "3"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount))
                        Case "4"
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount))
                        Case "5"
                            dblTemp1 = CDbl(vntArray(0, intCount))
                        Case Else
                            dblTemp1 = CDbl(vntArray(0, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(5, intCount))
                    End Select

                    vntTempArray(27, intCount2) = VB6.Format(dblTemp1, "#,##0")
                    vntTempArray(27, 0) = vntTempArray(27, 0) + dblTemp1

                    'Figure out Days Late

                    If vntDaysLate = "" Then
                        vntDaysLate = "0"
                    End If
                    Select Case vntDaysLate
                        Case "0"
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "1"
                            dblTemp2 = CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "2"
                            dblTemp2 = CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "3"
                            dblTemp2 = CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "4"
                            dblTemp2 = CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                        Case "5"
                            dblTemp2 = CDbl(vntArray(12, intCount))
                        Case Else
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount)) + CDbl(vntArray(12, intCount))
                    End Select

                    vntTempArray(35, intCount2) = VB6.Format(dblTemp2, "#,##0")
                    vntTempArray(35, 0) = vntTempArray(35, 0) + dblTemp2

                    'Figure out In Window
                    'Select Case vntDaysEarly
                    '    Case "0"
                    '        dblTemp1 = 0
                    '    Case "1"
                    '        dblTemp1 = CDbl(vntArray(5, intCount))
                    '    Case "2"
                    '        dblTemp1 = CDbl(vntArray(5, intCount)) + CDbl(vntArray(4, intCount))
                    '    Case "3"
                    '        dblTemp1 = CDbl(vntArray(5, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(3, intCount))
                    '    Case "4"
                    '        dblTemp1 = CDbl(vntArray(5, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(2, intCount))
                    '    Case "5"
                    '        dblTemp1 = CDbl(vntArray(5, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(1, intCount))
                    '    Case Else
                    '        dblTemp1 = 0
                    'End Select

                    ' All Early Now In Window
                    dblTemp1 = CDbl(vntArray(5, intCount)) + CDbl(vntArray(4, intCount)) + CDbl(vntArray(3, intCount)) + CDbl(vntArray(2, intCount)) + CDbl(vntArray(1, intCount)) + CDbl(vntArray(0, intCount))
                    ' Subtact JIT Early
                    dblTemp1 = dblTemp1 - CDbl(vntArray(19, intCount)) - CDbl(vntArray(18, intCount)) - CDbl(vntArray(17, intCount)) - CDbl(vntArray(16, intCount)) - CDbl(vntArray(15, intCount)) - CDbl(vntArray(14, intCount))

                    Select Case vntDaysLate
                        Case "0"
                            dblTemp2 = 0
                        Case "1"
                            dblTemp2 = CDbl(vntArray(7, intCount))
                        Case "2"
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount))
                        Case "3"
                            dblTemp2 = (CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)))
                        Case "4"
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount))
                        Case "5"
                            dblTemp2 = CDbl(vntArray(7, intCount)) + CDbl(vntArray(8, intCount)) + CDbl(vntArray(9, intCount)) + CDbl(vntArray(10, intCount)) + CDbl(vntArray(11, intCount))
                        Case Else
                            dblTemp2 = 0
                    End Select

                    'InWindowNum
                    vntTempArray(31, intCount2) = VB6.Format(dblTemp1 + dblTemp2 + CInt(vntArray(6, intCount)), "#,##0")
                    vntTempArray(31, 0) = vntTempArray(31, 0) + dblTemp1 + dblTemp2 + CInt(vntArray(6, intCount))
                    'InWindowPercnt
                    vntTempArray(30, intCount2) = VB6.Format(System.Math.Round(vntTempArray(31, intCount2) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                End If

                'SumEarlyPercnt
                'vntTempArray(26, intCount2) = VB6.Format(System.Math.Round(CInt(vntTempArray(27, intCount2)) / CInt(vntArray(13, intCount)), 3), "0.0%")
                'SumLatePercnt
                vntTempArray(34, intCount2) = VB6.Format(System.Math.Round(CDbl(vntTempArray(35, intCount2)) / CDbl(vntArray(13, intCount)), 3), "0.0%")

                If vntSmryType = "1" Then 'STS
                    'sumJITEarly
                    vntTempArray(29, intCount2) = CDbl(vntArray(14, intCount)) + CDbl(vntArray(15, intCount)) + CDbl(vntArray(16, intCount)) + CDbl(vntArray(17, intCount)) + CDbl(vntArray(18, intCount)) + CDbl(vntArray(19, intCount))
                    vntTempArray(29, 0) = vntTempArray(29, 0) + vntTempArray(29, intCount2)
                    vntTempArray(29, intCount2) = VB6.Format(vntTempArray(29, intCount2), "#,##0")
                    vntTempArray(27, 0) = vntTempArray(29, 0)
                    vntTempArray(27, intCount2) = vntTempArray(29, intCount2)
                    'sumJITLate
                    vntTempArray(33, intCount2) = CDbl(vntArray(21, intCount)) + CDbl(vntArray(22, intCount)) + CDbl(vntArray(23, intCount)) + CDbl(vntArray(24, intCount)) + CDbl(vntArray(25, intCount)) + CDbl(vntArray(26, intCount))
                    vntTempArray(33, 0) = vntTempArray(33, 0) + vntTempArray(33, intCount2)
                    vntTempArray(33, intCount2) = VB6.Format(vntTempArray(33, intCount2), "#,##0")
                    'JITEarlyPercnt
                    vntTempArray(28, intCount2) = VB6.Format(System.Math.Round(CInt(vntTempArray(29, intCount2)) / CInt(vntArray(13, intCount)), 3), "0.0%")
                    'JITLatePercnt
                    vntTempArray(32, intCount2) = VB6.Format(System.Math.Round(CDbl(vntTempArray(33, intCount2)) / CDbl(vntArray(13, intCount)), 3), "0.0%")
                End If

                vntTempArray(26, intCount2) = VB6.Format(System.Math.Round(CInt(vntTempArray(27, intCount2)) / CInt(vntArray(13, intCount)), 3), "0.0%")
                'Total
                vntTempArray(37, intCount2) = VB6.Format(vntArray(13, intCount), "#,##0")
                vntTempArray(37, 0) = vntTempArray(37, 0) + vntArray(13, intCount)
                vntTempArray(36, intCount2) = VB6.Format(1, "0%")
                'country_name
                vntTempArray(38, intCount2) = vntArray(28, intCount)

            Next

            vntTempArray(38, 0) = "TOTAL"
            'calculate & format totals
            For intCount2 = 0 To 37
                If intCount2 <= 12 Then
                    vntTempArray(intCount2, 0) = VB6.Format(vntTempArray(intCount2 + 13, 0) / vntTempArray(37, 0), "0.0%")
                ElseIf intCount2 = 26 Or intCount2 = 28 Or intCount2 = 30 Or intCount2 = 32 Or intCount2 = 34 Then
                    vntTempArray(intCount2, 0) = VB6.Format(vntTempArray(intCount2 + 1, 0) / vntTempArray(37, 0), "0.0%")
                ElseIf intCount2 = 36 Then
                    vntTempArray(intCount2, 0) = VB6.Format(vntTempArray(intCount2 + 1, 0) / vntTempArray(37, 0), "0%")
                Else
                    vntTempArray(intCount2, 0) = VB6.Format(vntTempArray(intCount2, 0), "#,##0")
                End If
            Next

            If vntWindowId = "2" And vntSmryType = "1" Then  ' Standard Default & STS
                vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> All;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
            End If

            vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
            ListSummDlyByCntry = vntTempArray
        Else
            Err.Raise(100, , "No results were found.(in clsResults.ListSummDlyByCntry)")
        End If

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListSummDlyByCntry = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

	Public Function ParseProdMgr(ByVal vntProdMgr As Object) As Object
        Dim vntTemp As Object
		Dim intCommaPos As Short

		intCommaPos = InStr(vntProdMgr, ",")
		
		vntTemp = ""
		If intCommaPos = 0 Then
            If InStr(vntProdMgr, "%") > 0 Then
                vntTemp = " AND F.LAST_NAME LIKE '" & vntProdMgr & "' "
            Else
                vntTemp = " AND F.LAST_NAME = '" & vntProdMgr & "' "
            End If
		ElseIf intCommaPos >= 2 Then 
            If InStr(vntProdMgr, "%") > 0 Then
                vntTemp = " AND F.LAST_NAME LIKE '" & Left(vntProdMgr, intCommaPos - 1) & "' "
            Else
                vntTemp = " AND F.LAST_NAME = '" & Left(vntProdMgr, intCommaPos - 1) & "' "
            End If
		End If

		If intCommaPos > 0 And Mid(vntProdMgr, intCommaPos + 1) <> "" Then
            If InStr(Mid(vntProdMgr, intCommaPos + 1), "%") > 0 Then
                vntTemp = vntTemp & " AND F.FIRST_NAME LIKE '" & LTrim(Mid(vntProdMgr, intCommaPos + 1)) & "' "
            Else
                vntTemp = vntTemp & " AND F.FIRST_NAME = '" & LTrim(Mid(vntProdMgr, intCommaPos + 1)) & "' "
            End If
		End If

		ParseProdMgr = vntTemp
		
	End Function
End Class