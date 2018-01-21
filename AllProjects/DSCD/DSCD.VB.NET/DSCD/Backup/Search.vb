Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsSearch
    Inherits ServicedComponent

    '##ModelId=3AB74F0A01D5
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3AB74F3B03D0
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3AB74F5901DF
    Protected Overrides Sub Activate()

        'Set ObjContext = GetObjectContext()

    End Sub

    '##ModelId=3AB74F6D003A
    Protected Overrides Function CanBePooled() As Boolean

        'ObjectControl_CanBePooled = bPoolSetting
        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3AB74F94029B
    Protected Overrides Sub Deactivate()

        ObjContext = Nothing

    End Sub

    '##ModelId=3AB750400106
    'Public Function RetrieveLastSession() As Object
    '    On Error GoTo ErrorHandler

    '## your code goes here...

    'Exit Function
    'ErrorHandler:

    'End Function

    '##ModelId=3AB75051017B
    Public Function RetrieveSession(ByVal vntSessionID As String, ByRef vntViewId As String, ByRef vntCategoryId As String, ByRef vntWindowId As String, ByRef vntStartDt As String, ByRef vntEndDt As String, ByRef vntDaysEarly As String, ByRef vntDaysLate As String, ByRef vntMonthDailyInd As String, ByRef vntSmryType As String, ByRef vntCurrentHist As String, ByRef vntOrgType As String, ByRef vntOrgKeyId As String, ByRef vntCustAcctTypeCde As String, ByRef vntPart As String, ByRef vntPlant As String, ByRef vntLocation As String, ByRef vntacctOrgKey As String, ByRef vntShipTo As String, ByRef vntSoldTo As String, ByRef vntWWCust As String, ByRef vntInvOrgKey As String, ByRef vntController As String, ByRef vntCntlrEmpNbr As String, ByRef vntStkMake As String, ByRef vntTeam As String, ByRef vntProdCde As String, ByRef vntProdLne As String, ByRef vntIBC As String, ByRef vntIC As String, ByRef vntMfgCampus As String, ByRef vntMfgBuilding As String, ByRef vntComparisonType As String, ByRef vntOpenShpOrder As String, ByRef vntProfitCtr As String, ByRef vntCompetencyBusCde As String, ByRef vntOrgDt As String, ByRef vntSubCompetencyBusCde As String, ByRef vntProdMgr As String, ByRef vntLeadTimeType As String, ByRef vntSalesOffice As String, ByRef vntSalesGroup As String, ByRef vntMfgOrgType As String, ByRef vntMfgOrgId As String, ByRef GamAccount As String, ByRef vntPartKeyID As String, ByRef vntMrpGroupCde As String, ByRef vntHostOrgID As String, ByRef vntErrorNumber As String, Optional ByRef vntErrorDesc As String = Nothing) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(48) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsSearch.RetrieveSession)"

        On Error GoTo ErrorHandler

        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not found in clsSearch.RetrieveSession (In parameter check)")
        End If

        blnrc = objCallSP.CallSP_Out("scdSearch.RetrieveSession", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntSessionID, "O", vntViewId, "O", vntCategoryId, "O", vntWindowId, "O", vntStartDt, "O", vntEndDt, "O", vntDaysEarly, "O", vntDaysLate, "O", vntMonthDailyInd, "O", vntSmryType, "O", vntCurrentHist, "O", vntOrgType, "O", vntOrgKeyId, "O", vntCustAcctTypeCde, "O", vntPart, "O", vntPlant, "O", vntLocation, "O", vntacctOrgKey, "O", vntShipTo, "O", vntSoldTo, "O", vntWWCust, "O", vntInvOrgKey, "O", vntController, "O", vntCntlrEmpNbr, "O", vntStkMake, "O", vntTeam, "O", vntProdCde, "O", vntProdLne, "O", vntIBC, "O", vntIC, "O", vntMfgCampus, "O", vntMfgBuilding, "O", vntComparisonType, "O", vntOpenShpOrder, "O", vntProfitCtr, "O", vntCompetencyBusCde, "O", vntOrgDt, "O", vntSubCompetencyBusCde, "O", vntProdMgr, "O", vntLeadTimeType, "O", vntSalesOffice, "O", vntSalesGroup, "O", vntMfgOrgType, "O", vntMfgOrgId, "O", GamAccount, "O", vntPartKeyID, "O", vntMrpGroupCde, "O", vntHostOrgID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        vntViewId = arrOutVar(0)
        vntCategoryId = arrOutVar(1)
        vntWindowId = arrOutVar(2)
        vntStartDt = arrOutVar(3)
        vntEndDt = arrOutVar(4)
        vntDaysEarly = arrOutVar(5)
        vntDaysLate = arrOutVar(6)
        vntMonthDailyInd = arrOutVar(7)
        vntSmryType = arrOutVar(8)
        vntCurrentHist = arrOutVar(9)
        vntOrgType = arrOutVar(10)
        vntOrgKeyId = arrOutVar(11)
        vntCustAcctTypeCde = arrOutVar(12)
        vntPart = arrOutVar(13)
        vntPlant = arrOutVar(14)
        vntLocation = arrOutVar(15)
        vntacctOrgKey = arrOutVar(16)
        vntShipTo = arrOutVar(17)
        vntSoldTo = arrOutVar(18)
        vntWWCust = arrOutVar(19)
        vntInvOrgKey = arrOutVar(20)
        vntController = arrOutVar(21)
        vntCntlrEmpNbr = arrOutVar(22)
        vntStkMake = arrOutVar(23)
        vntTeam = arrOutVar(24)
        vntProdCde = arrOutVar(25)
        vntProdLne = arrOutVar(26)
        vntIBC = arrOutVar(27)
        vntIC = arrOutVar(28)
        vntMfgCampus = arrOutVar(29)
        vntMfgBuilding = arrOutVar(30)
        vntComparisonType = arrOutVar(31)
        vntOpenShpOrder = arrOutVar(32)
        vntProfitCtr = arrOutVar(33)
        vntCompetencyBusCde = arrOutVar(34)
        vntOrgDt = arrOutVar(35)
        vntSubCompetencyBusCde = arrOutVar(36)
        vntProdMgr = arrOutVar(37)
        vntLeadTimeType = arrOutVar(38)
        vntSalesOffice = arrOutVar(39)
        vntSalesGroup = arrOutVar(40)
        vntMfgOrgType = arrOutVar(41)
        vntMfgOrgId = arrOutVar(42)
        GamAccount = arrOutVar(43)
        vntPartKeyID = arrOutVar(44)
        vntMrpGroupCde = arrOutVar(45)
        vntHostOrgID = arrOutVar(46)

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveSession = True
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveSession = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    Public Function RetrieveSessionASP(ByVal vntSessionID As String, ByRef vntViewId As String, ByRef vntCategoryId As String, ByRef vntWindowId As String, ByRef vntStartDt As String, ByRef vntEndDt As String, ByRef vntDaysEarly As String, ByRef vntDaysLate As String, ByRef vntMonthDailyInd As String, ByRef vntSmryType As String, ByRef vntCurrentHist As String, ByRef vntOrgType As String, ByRef vntOrgKeyId As String, ByRef vntCustAcctTypeCde As String, ByRef vntPart As String, ByRef vntPlant As String, ByRef vntLocation As String, ByRef vntacctOrgKey As String, ByRef vntShipTo As String, ByRef vntSoldTo As String, ByRef vntWWCust As String, ByRef vntInvOrgKey As String, ByRef vntController As String, ByRef vntCntlrEmpNbr As String, ByRef vntStkMake As String, ByRef vntTeam As String, ByRef vntProdCde As String, ByRef vntProdLne As String, ByRef vntIBC As String, ByRef vntIC As String, ByRef vntMfgCampus As String, ByRef vntMfgBuilding As String, ByRef vntComparisonType As String, ByRef vntOpenShpOrder As String, ByRef vntProfitCtr As String, ByRef vntCompetencyBusCde As String, ByRef vntOrgDt As String, ByRef vntSubCompetencyBusCde As String, ByRef vntProdMgr As String, ByRef vntLeadTimeType As String, ByRef vntSalesOffice As String, ByRef vntSalesGroup As String, ByRef vntMfgOrgType As String, ByRef vntMfgOrgId As String, ByRef GamAccount As String, ByRef vntPartKeyID As String, ByRef vntMrpGroupCde As String, ByRef vntHostOrgID As String, ByRef vntErrorNumber As String, ByRef vntErrorDesc As String) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(48) As String
        Dim objPartNbr As Object
        Dim strPNStorage As String
        Dim strPNDisplay As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsSearch.RetrieveSessionASP)"

        On Error GoTo ErrorHandler

        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not found in clsSearch.RetrieveSessionASP (In parameter check)")
        End If

        blnrc = objCallSP.CallSP_Out("scdSearch.RetrieveSession", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntSessionID, "O", vntViewId, "O", vntCategoryId, "O", vntWindowId, "O", vntStartDt, "O", vntEndDt, "O", vntDaysEarly, "O", vntDaysLate, "O", vntMonthDailyInd, "O", vntSmryType, "O", vntCurrentHist, "O", vntOrgType, "O", vntOrgKeyId, "O", vntCustAcctTypeCde, "O", vntPart, "O", vntPlant, "O", vntLocation, "O", vntacctOrgKey, "O", vntShipTo, "O", vntSoldTo, "O", vntWWCust, "O", vntInvOrgKey, "O", vntController, "O", vntCntlrEmpNbr, "O", vntStkMake, "O", vntTeam, "O", vntProdCde, "O", vntProdLne, "O", vntIBC, "O", vntIC, "O", vntMfgCampus, "O", vntMfgBuilding, "O", vntComparisonType, "O", vntOpenShpOrder, "O", vntProfitCtr, "O", vntCompetencyBusCde, "O", vntOrgDt, "O", vntSubCompetencyBusCde, "O", vntProdMgr, "O", vntLeadTimeType, "O", vntSalesOffice, "O", vntSalesGroup, "O", vntMfgOrgType, "O", vntMfgOrgId, "O", GamAccount, "O", vntPartKeyID, "O", vntMrpGroupCde, "O", vntHostOrgID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        vntViewId = arrOutVar(0)
        vntCategoryId = arrOutVar(1)
        vntWindowId = arrOutVar(2)
        vntStartDt = arrOutVar(3)
        vntEndDt = arrOutVar(4)
        vntDaysEarly = arrOutVar(5)
        vntDaysLate = arrOutVar(6)
        vntMonthDailyInd = arrOutVar(7)
        vntSmryType = arrOutVar(8)
        vntCurrentHist = arrOutVar(9)
        vntOrgType = arrOutVar(10)
        vntOrgKeyId = arrOutVar(11)
        vntCustAcctTypeCde = arrOutVar(12)
        vntPart = arrOutVar(13)
        vntPlant = arrOutVar(14)
        vntLocation = arrOutVar(15)
        vntacctOrgKey = arrOutVar(16)
        vntShipTo = arrOutVar(17)
        vntSoldTo = arrOutVar(18)
        vntWWCust = arrOutVar(19)
        vntInvOrgKey = arrOutVar(20)
        vntController = arrOutVar(21)
        vntCntlrEmpNbr = arrOutVar(22)
        vntStkMake = arrOutVar(23)
        vntTeam = arrOutVar(24)
        vntProdCde = arrOutVar(25)
        vntProdLne = arrOutVar(26)
        vntIBC = arrOutVar(27)
        vntIC = arrOutVar(28)
        vntMfgCampus = arrOutVar(29)
        vntMfgBuilding = arrOutVar(30)
        vntComparisonType = arrOutVar(31)
        vntOpenShpOrder = arrOutVar(32)
        vntProfitCtr = arrOutVar(33)
        vntCompetencyBusCde = arrOutVar(34)
        vntOrgDt = arrOutVar(35)
        vntSubCompetencyBusCde = arrOutVar(36)
        vntProdMgr = arrOutVar(37)
        vntLeadTimeType = arrOutVar(38)
        vntSalesOffice = arrOutVar(39)
        vntSalesGroup = arrOutVar(40)
        vntMfgOrgType = arrOutVar(41)
        vntMfgOrgId = arrOutVar(42)
        GamAccount = arrOutVar(43)
        vntPartKeyID = arrOutVar(44)
        vntMrpGroupCde = arrOutVar(45)
        vntHostOrgID = arrOutVar(46)

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveSessionASP = True
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        'UPGRADE_NOTE: Object objPartNbr may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objPartNbr = Nothing
        RetrieveSessionASP = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    '##ModelId=3AB7505E0328
    Public Function UpdateSession(ByVal vntAmpID As String, ByVal vntSessionID As String, ByVal vntViewId As String, ByVal vntCategoryId As String, ByVal vntWindowId As String, ByVal vntStartDt As String, ByVal vntEndDt As String, ByVal vntDaysEarly As String, ByVal vntDaysLate As String, ByVal vntMonthDailyInd As String, ByVal vntSmryType As String, ByVal vntCurrentHist As String, ByVal vntOrgType As String, ByVal vntOrgKeyId As String, ByVal vntCustAcctTypeCde As String, ByVal vntPart As String, ByVal vntPlant As String, ByVal vntLocation As String, ByVal vntacctOrgKey As String, ByVal vntShipTo As String, ByVal vntSoldTo As String, ByVal vntWWCust As String, ByVal vntInvOrgKey As String, ByVal vntController As String, ByVal vntCntlrEmpNbr As String, ByVal vntStkMake As String, ByVal vntTeam As String, ByVal vntProdCde As String, ByVal vntProdLne As String, ByVal vntIBC As String, ByVal vntIC As String, ByVal vntMfgCampus As String, ByVal vntMfgBuilding As String, ByVal vntComparisonType As String, ByVal vntOpenShpOrder As String, ByVal vntProfitCtr As String, ByVal vntCompetencyBusCde As String, ByVal vntOrgDt As String, ByVal vntSubCompetencyBusCde As String, ByVal vntProdMgr As String, ByVal vntLeadTimeType As String, ByVal vntSalesOffice As String, ByVal vntSalesGroup As String, ByVal vntMfgOrgType As String, ByVal vntMfgOrgId As String, ByVal GamAccount As String, ByVal vntPartKeyID As String, ByVal vntMrpGroupCde As String, ByVal vntHostOrgID As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String) As Boolean

        UpdateSession = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim objPartNbr As Object
        Dim strPNStorage As String
        Dim strPNDisplay As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsSearch.UpdateSession)"

        On Error GoTo UpdateSession_ErrorHandler

        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not found in clsSearch.UpdateSession (In parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdSearch.UpdateSession", lngErrorNumber, strErrorDescription, "I", vntAmpID, "I", vntSessionID, "I", vntViewId, "I", vntCategoryId, "I", vntWindowId, "I", vntStartDt, "I", vntEndDt, "I", vntDaysEarly, "I", vntDaysLate, "I", vntMonthDailyInd, "I", vntSmryType, "I", vntCurrentHist, "I", vntOrgType, "I", vntOrgKeyId, "I", vntCustAcctTypeCde, "I", vntPart, "I", vntPlant, "I", vntLocation, "I", vntacctOrgKey, "I", vntShipTo, "I", vntSoldTo, "I", vntWWCust, "I", vntInvOrgKey, "I", vntController, "I", vntCntlrEmpNbr, "I", vntStkMake, "I", vntTeam, "I", vntProdCde, "I", vntProdLne, "I", vntIBC, "I", vntIC, "I", vntMfgCampus, "I", vntMfgBuilding, "I", vntComparisonType, "I", vntOpenShpOrder, "I", vntProfitCtr, "I", vntCompetencyBusCde, "I", vntOrgDt, "I", vntSubCompetencyBusCde, "I", vntProdMgr, "I", vntLeadTimeType, "I", vntSalesOffice, "I", vntSalesGroup, "I", vntMfgOrgType, "I", vntMfgOrgId, "I", GamAccount, "I", vntPartKeyID, "I", vntMrpGroupCde, "I", vntHostOrgID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        UpdateSession = blnrc
        Exit Function

UpdateSession_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        UpdateSession = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    '##ModelId=3AB750320015
    Public Function CreateCurrentSession(ByVal vntGlobalID As String, ByRef vntSessionID As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String) As Object

        CreateCurrentSession = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsSearch.CreateCurrentSession)"

        On Error GoTo CreateCurrentSession_ErrorHandler

        If vntGlobalID = "" Then
            Err.Raise(100, , "Employee ID not found in clsSearch.CreateCurrentSession (In parameter check)")
        End If

        blnrc = objCallSP.CallSP_Out("scdSearch.CreateCurrentSession", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntGlobalID, "O", vntSessionID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        vntSessionID = arrOutVar(0)

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        CreateCurrentSession = blnrc
        Exit Function

CreateCurrentSession_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        CreateCurrentSession = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    '##ModelId=3AB74FB8027F
    Public Function ClearSession(ByVal vntGlobalID As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String) As Object

        ClearSession = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsSearch.ClearSession)"

        On Error GoTo ClearSession_ErrorHandler

        If vntGlobalID = "" Then
            Err.Raise(100, , "Employee ID not found in clsSearch.ClearSession (In parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdSearch.Purge_Sessions", lngErrorNumber, strErrorDescription, "I", vntGlobalID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        ClearSession = blnrc
        Exit Function

ClearSession_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        ClearSession = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    Public Function ResetSession(ByVal vntGlobalID As String, ByRef vntSessionID As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String) As Object

        ResetSession = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsSearch.ResetSession)"

        On Error GoTo ResetSession_ErrorHandler

        If vntGlobalID = "" Then
            Err.Raise(100, , "Employee ID not found in clsSearch.ResetSession (In parameter check)")
        End If

        blnrc = objCallSP.CallSP_Out("scdSearch.ResetToDefaults", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntGlobalID, "O", vntSessionID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        vntSessionID = arrOutVar(0)

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        ResetSession = blnrc
        Exit Function

ResetSession_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        ResetSession = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    Public Function SaveUserLog(ByVal vntAmpID As String, ByVal vntViewId As String, ByVal vntCategoryId As String, ByVal vntWindowId As String, ByVal vntStartDt As String, ByVal vntEndDt As String, ByVal vntDaysEarly As String, ByVal vntDaysLate As String, ByVal vntMonthDailyInd As String, ByVal vntSmryType As String, ByVal vntCurrentHist As String, ByVal vntOrgType As String, ByVal vntOrgKeyId As String, ByVal vntCustAcctTypeCde As String, ByVal vntPart As String, ByVal vntPlant As String, ByVal vntLocation As String, ByVal vntacctOrgKey As String, ByVal vntShipTo As String, ByVal vntSoldTo As String, ByVal vntWWCust As String, ByVal vntInvOrgKey As String, ByVal vntController As String, ByVal vntCntlrEmpNbr As String, ByVal vntStkMake As String, ByVal vntTeam As String, ByVal vntProdCde As String, ByVal vntProdLne As String, ByVal vntIBC As String, ByVal vntIC As String, ByVal vntMfgCampus As String, ByVal vntMfgBuilding As String, ByVal vntComparisonType As String, ByVal vntOpenShpOrder As String, ByVal vntProfitCtr As String, ByVal vntCompetencyBusCde As String, ByVal vntOrgDt As String, ByVal vntSubCompetencyBusCde As String, ByVal vntProdMgr As String, ByVal vntLeadTimeType As String, ByVal vntSalesOffice As String, ByVal vntSalesGroup As String, ByVal vntMfgOrgType As String, ByVal vntMfgOrgId As String, ByVal GamAccount As String, ByVal vntPartKeyID As String, ByVal vntMrpGroupCde As String, ByVal vntHostOrgID As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String) As Boolean

        SaveUserLog = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim objPartNbr As Object
        Dim strPNStorage As String
        Dim strPNDisplay As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsSearch.UpdateSession)"

        On Error GoTo UpdateSession_ErrorHandler

        blnrc = objCallSP.CallSP("scdSearch.SaveUserLog", lngErrorNumber, strErrorDescription, "I", vntAmpID, "I", vntViewId, "I", vntCategoryId, "I", vntWindowId, "I", vntStartDt, "I", vntEndDt, "I", vntDaysEarly, "I", vntDaysLate, "I", vntMonthDailyInd, "I", vntSmryType, "I", vntCurrentHist, "I", vntOrgType, "I", vntOrgKeyId, "I", vntCustAcctTypeCde, "I", vntPart, "I", vntPlant, "I", vntLocation, "I", vntacctOrgKey, "I", vntShipTo, "I", vntSoldTo, "I", vntWWCust, "I", vntInvOrgKey, "I", vntController, "I", vntCntlrEmpNbr, "I", vntStkMake, "I", vntTeam, "I", vntProdCde, "I", vntProdLne, "I", vntIBC, "I", vntIC, "I", vntMfgCampus, "I", vntMfgBuilding, "I", vntComparisonType, "I", vntOpenShpOrder, "I", vntProfitCtr, "I", vntCompetencyBusCde, "I", vntOrgDt, "I", vntSubCompetencyBusCde, "I", vntProdMgr, "I", vntLeadTimeType, "I", vntSalesOffice, "I", vntSalesGroup, "I", vntMfgOrgType, "I", vntMfgOrgId, "I", GamAccount, "I", vntPartKeyID, "I", vntMrpGroupCde, "I", vntHostOrgID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        SaveUserLog = blnrc
        Exit Function

UpdateSession_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        SaveUserLog = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

End Class