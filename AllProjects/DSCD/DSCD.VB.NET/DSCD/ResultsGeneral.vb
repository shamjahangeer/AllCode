Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsResultsGeneral
    Inherits ServicedComponent

    '##ModelId=3AC098270317
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3AC09836039B
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3AC09CCF004B
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3AC09CE201E6
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3AC09CF1010B
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    '##ModelId=3AC09D1503AE
    Public Function ListCust(ByVal vntSessionID As Object, ByVal vntPage As Object, ByVal vntExport As Object, ByRef vntCount As Object, ByRef vntRecsLeft As Object, ByRef vntSmryType As Object, ByRef vntDispCrit As Object, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objConnection As New ADODB.Connection
        Dim objCallRS As New clsCallRS
        Dim objSearch As New clsSearch
        Dim objList As Object
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
        Dim vntArray As Object
        'Dim intPageCount As Short
        'Dim intRecsLeft As Short
        'Dim intCount As Short
        'Dim intFound As Short
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntWindowId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgType As Object
        'Dim vntOrgKeyId As Object
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
        'Dim vntOrgDt As Object
        'Dim vntLevel As Object
        'Dim vntKeyId As Object
        'Dim intCountST As Short
        'Dim vntTemp As Object
        'Dim vntTempWW As Object
        'Dim vntTempWW2 As Object
        'Dim intCountWW As Short
        Dim strWWDisplay As String = ""
        Dim vntWWName As String = ""
        'Dim objGetWWName As New clsWrldWide
        'Dim objGetShipToName As New clsShipTo
        'Dim objGetSoldToName As New clsSoldTo
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
        Dim vntOrgDt As String = ""
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
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResultsGeneral.ListCust")
        End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgKeyId, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDt, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNbr, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " In call to clsSearch.RetrieveSession in clsResultsGeneral.ListCust")
        End If

        strSql = " SELECT DISTINCT b.ORGANIZATION_ID Org, "
        strSql = strSql & " b.ORGANIZATION_SHORT_NM OrgNm, "
        strSql = strSql & " a.PURCHASE_BY_ACCOUNT_BASE||a.SHIP_TO_ACCOUNT_SUFFIX Customer,"
        strSql = strSql & " a.NBR_WINDOW_DAYS_EARLY Early, "
        strSql = strSql & " a.NBR_WINDOW_DAYS_LATE Late, "
        strSql = strSql & " MAX(TO_CHAR(a.AMP_SHIPPED_DATE, 'YYYY-MM-DD')) ShipDate"
        strSql = strSql & " FROM ORGANIZATIONS_DMN b, "
        strSql = strSql & " SCORECARD_CUSTOMER_WW_XREF a "
        strSql = strSql & " WHERE b.ORGANIZATION_KEY_ID = a.ACCOUNTING_ORG_KEY_ID "

        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                strSql = strSql & " AND b.RECORD_STATUS_CDE = 'C' "
                'vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
            Else
                strSql = strSql & " AND (b.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDt & "', 'YYYY-MM-DD')"
                strSql = strSql & " AND b.EFFECTIVE_TO_DT >= to_date('" & vntOrgDt & "', 'YYYY-MM-DD'))"
                'vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                'vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDate & ";"
            End If
        Else
            strSql = strSql & " AND b.RECORD_STATUS_CDE = 'C' "
            'vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
        End If

        If vntWWCust <> "" Then
            strWWDisplay = vntWWCust
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

            blnrc = objGetWWName.RetrieveName(vntWWCust, vntWWName, vntErrorNbr, vntErrorDesc)
            If Not blnrc Then

                vntWWName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetWWName = Nothing

            vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & strWWDisplay & " " & vntWWName & ";"
            'vntDispCrit = vntDispCrit & " <strong>World Wide:</strong> " & vntWWCust & ";"
        End If

        strSql = strSql & " GROUP BY b.ORGANIZATION_ID, "
        strSql = strSql & " b.ORGANIZATION_SHORT_NM, "
        strSql = strSql & " a.PURCHASE_BY_ACCOUNT_BASE||a.SHIP_TO_ACCOUNT_SUFFIX, "
        strSql = strSql & " a.NBR_WINDOW_DAYS_EARLY, "
        strSql = strSql & " a.NBR_WINDOW_DAYS_LATE "
        strSql = strSql & " ORDER BY Org ASC, Customer ASC, Early ASC, Late ASC "

        objList = objCallRS.CallRS_WithConn(objConnection, strSql, vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsResultsGeneral.ListCust call to CallRS for Customer List Query")
        End If

        If vntCount > 0 Then
            'objList.Sort = "Org ASC, Customer ASC, Early ASC, Late ASC"
            If vntExport = 1 Then 'This would be true, process entire recordset
                ListCust = objList.GetRows
            Else
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

                ReDim vntArray(CInt(intPageCount) - 1, (objList.Fields.Count - 1))
                intCount = 0
                Do Until intCount = intPageCount
                    vntArray(intCount, 0) = objList.Fields.Item("Org").Value & " - " & objList.Fields.Item("OrgNm").Value
                    vntArray(intCount, 1) = objList.Fields.Item("Customer").Value
                    If objList.Fields.Item("Customer").Value <> "" Then
                        blnrc = objGetShipToName.RetrieveName(objList.Fields.Item("Org").Value, objList.Fields.Item("Customer").Value, vntArray(intCount, 2), vntErrorNbr, vntErrorDesc)
                        If Not blnrc Then
                            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " In call to clsShipTo.RetrieveName in clsResultsGeneral.ListCust")
                        End If
                    End If

                    vntArray(intCount, 3) = objList.Fields.Item("Early").Value
                    vntArray(intCount, 4) = objList.Fields.Item("Late").Value

                    If IsDBNull(objList.Fields.Item("ShipDate").Value) Then
                        vntArray(intCount, 5) = "&nbsp;"
                    Else
                        vntArray(intCount, 5) = objList.Fields.Item("ShipDate").Value
                    End If

                    objList.MoveNext()
                    intCount = intCount + 1
                Loop
                ListCust = vntArray
            End If
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListCust = System.DBNull.Value
        End If

        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If
        objConnection = Nothing

        vntErrorNbr = 0
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
        ListCust = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    '##ModelId=3AC09D1D01CF
    Public Function ListWW(ByVal vntSessionID As String, ByVal vntPage As Object, ByVal vntExport As Object, ByRef vntCount As Object, ByRef vntRecsLeft As Object, ByRef vntSmryType As Object, ByRef vntDispCrit As Object, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        'ByVal vntSessionID As String, ByVal vntGetTotal As Object, ByVal vntPage As Object, ByVal vntExport As Object, ByRef vntCount As Object, ByRef vntRecsLeft As Object, ByRef vntTBRTotal As Object, ByRef vntExtTotal As Object, ByRef vntLocalTotal As Object, ByRef vntSmryType As Object, ByRef vntDispCrit As Object, ByRef vntShpQtyTotal As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objConnection As New ADODB.Connection
        Dim objCallRS As New clsCallRS
        Dim objSearch As New clsSearch
        Dim objList As Object
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
        Dim vntArray As Object
        Dim strWhere As String
        'Dim intPageCount As Short
        'Dim intRecsLeft As Short
        'Dim intCount As Short
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntWindowId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgType As Object
        'Dim vntOrgKeyId As Object
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
        'Dim vntOrgDt As Object
        'Dim vntLevel As Object
        'Dim vntKeyId As Object
        'Dim intCountST As Short
        'Dim vntTemp As Object
        'Dim vntTempWW As Object
        'Dim vntTempWW2 As Object
        'Dim intCountWW As Short
        'Dim intFound As Short
        Dim strSTDisplay As String
        'Dim vntCustOrg As Object
        Dim vntSTName As Object
        'Dim objGetWWName As New clsWrldWide
        'Dim objGetShipToName As New clsShipTo
        'Dim objGetSoldToName As New clsSoldTo
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
        Dim vntOrgDt As String = ""
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

        strSTDisplay = vbNullString
        vntCustOrg = vbNullString
        vntSTName = vbNullString

        If vntSessionID = "" Then
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResultsGeneral.ListWW")
        End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgKeyId, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntInvOrg, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfit, vntCBC, vntOrgDt, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNbr, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " In call to clsSearch.RetrieveSession in clsResultsGeneral.ListWW")
        End If

        If vntacctOrgKey <> "" Then
            vntCustOrg = vntacctOrgKey
            vntDispCrit = vntDispCrit & "<strong> Cust Org ID:</strong> " & vntacctOrgKey & ";"

            blnrc = objOrgs.RetrieveOrgKeyId(vntacctOrgKey, vntCurrentHist, vntOrgDt, vntKeyId, vntErrorNbr, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " In call to clsOrgs.RetrieveOrgKeyId for accounting org")
            End If

            vntacctOrgKey = vntKeyId
            'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objOrgs = Nothing
        End If

        strSql = " SELECT DISTINCT a.WW_ACCOUNT_NBR_BASE||a.WW_ACCOUNT_NBR_SUFFIX WWNbr, "
        strSql = strSql & " b.WW_CSTMR_NAME WWName "
        strSql = strSql & " FROM GBL_CUSTOMER_WORLDWIDE b, "
        strSql = strSql & " SCORECARD_CUSTOMER_WW_XREF a "
        strSql = strSql & " WHERE a.WW_ACCOUNT_NBR_BASE||a.WW_ACCOUNT_NBR_SUFFIX = b.WW_CSTMR_ACCT_NBR "
        strSql = strSql & " AND a.ACCOUNTING_ORG_KEY_ID = " & vntacctOrgKey

        If vntShipTo <> "" Then
            strSTDisplay = vntShipTo
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

            blnrc = objGetShipToName.RetrieveName(vntCustOrg, vntShipTo, vntSTName, vntErrorNbr, vntErrorDesc)
            If Not blnrc Then
                vntSTName = "Name Not Found"
            End If
            'UPGRADE_NOTE: Object objGetName may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objGetShipToName = Nothing
            vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & strSTDisplay & " " & vntSTName & ";"
            'vntDispCrit = vntDispCrit & " <strong>Ship To:</strong> " & vntShipTo & ";"
        End If

        strSql = strSql & " ORDER BY WWNbr ASC"

        objList = objCallRS.CallRS_WithConn(objConnection, strSql, vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsResultsGeneral.ListCust call to CallRS for Customer List Query")
        End If

        If vntCount > 0 Then
            'objList.Sort = "WWNbr ASC"
            If vntExport = 1 Then 'This would be true, process entire recordset
                ListWW = objList.GetRows
            Else
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

                ReDim vntArray(CInt(intPageCount) - 1, (objList.Fields.Count - 1))
                intCount = 0
                Do Until intCount = intPageCount
                    vntArray(intCount, 0) = objList.Fields.Item("WWNbr").Value
                    vntArray(intCount, 1) = objList.Fields.Item("WWName").Value
                    objList.MoveNext()
                    intCount = intCount + 1
                Loop
                ListWW = vntArray
            End If
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListWW = System.DBNull.Value
        End If

        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If
        objConnection = Nothing

        vntErrorNbr = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function

ErrorHandler:
        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If
        objConnection = Nothing
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListWW = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description & strWhere
        Exit Function
    End Function

    '##ModelId=3AC09D260019
    Public Function ListShpFclty(ByVal vntSessionID As String, ByVal vntExport As Object, ByRef vntCount As Object, ByRef vntDispCrit As Object, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objSearch As New clsSearch
        Dim objList As Object
        Dim objOrgs As New clsOrgs
        Dim blnrc As Boolean
        Dim vntTempArray As Object
        Dim vntArray As Object
        Dim intTempCount As Short
        'Dim intCount As Short
        Dim intDetailCnt As Integer
        'Dim vntViewId As Object
        'Dim vntCategoryId As Object
        'Dim vntWindowId As Object
        'Dim vntStartDt As Object
        'Dim vntEndDt As Object
        'Dim vntSmryType As Object
        'Dim vntCurrentHist As Object
        'Dim vntOrgType As Object
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
        Dim vntCntrlrKey As String = ""
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
        Dim vntProfitCtr As String = ""
        'Dim vntCBC As Object
        'Dim vntSubCBC As Object
        'Dim vntOrgDt As Object
        'Dim vntLevel As Object
        'Dim vntOrgTypeDesc As Object
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
        Dim vntOrgDt As String = ""
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
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResultsGeneral.ListShpFclty")
        End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntCntrlrKey, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfitCtr, vntCBC, vntOrgDt, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNbr, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " In call to clsSearch.RetrieveSession in clsResultsGeneral.ListShpFclty")
        End If

        If vntOrgID <> "" Then
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNbr, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"

            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDt, vntLevel, vntErrorNbr, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel in clsResultsGeneral.ListShpFclty")
            End If
            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
            'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objOrgs = Nothing
        End If

        strSql = strSql & " SELECT a.ACTUAL_SHIP_LOCATION Loc,  "
        strSql = strSql & " c.ORGANIZATION_ID OrgId,  "
        strSql = strSql & " c.ORGANIZATION_SHORT_NM OrgName,  "
        strSql = strSql & " SUM(TOTAL_NBR_SHPMTS) TotalShip,  "
        strSql = strSql & " SUM(NBR_SHPMTS_ON_TIME + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY "
        strSql = strSql & "     - NBR_JIT_ONE_DAY_EARLY - NBR_JIT_TWO_DAYS_EARLY - NBR_JIT_THREE_DAYS_EARLY) OnTime, "
        strSql = strSql & " ROUND((SUM(NBR_SHPMTS_ON_TIME + NBR_SHPMTS_ONE_DAY_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY "
        strSql = strSql & "     - NBR_JIT_ONE_DAY_EARLY - NBR_JIT_TWO_DAYS_EARLY - NBR_JIT_THREE_DAYS_EARLY) / "
        strSql = strSql & "     SUM(TOTAL_NBR_SHPMTS) * 100), 1) PctOnTime, "
        strSql = strSql & " SUM(NBR_SHPMTS_OUT_RANGE_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + "
        strSql = strSql & "     NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_ONE_DAY_LATE) Late, "
        strSql = strSql & " ROUND((SUM(NBR_SHPMTS_OUT_RANGE_LATE + NBR_SHPMTS_SIX_DAYS_LATE + NBR_SHPMTS_FIVE_DAYS_LATE + "
        strSql = strSql & "     NBR_SHPMTS_FOUR_DAYS_LATE + NBR_SHPMTS_THREE_DAYS_LATE + NBR_SHPMTS_TWO_DAYS_LATE + NBR_SHPMTS_ONE_DAY_LATE) / "
        strSql = strSql & "     SUM(TOTAL_NBR_SHPMTS) * 100), 1) PctLate "
        strSql = strSql & " FROM ORGANIZATIONS_DMN c, "
        strSql = strSql & " BUILDING_LOCATION_SMRY a  "
        strSql = strSql & " WHERE AMP_SHIPPED_MONTH BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"
        strSql = strSql & " AND c.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        strSql = strSql & " AND a.ORGANIZATION_KEY_ID = c.ORGANIZATION_KEY_ID "

        vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"

        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                strSql = strSql & " AND c.RECORD_STATUS_CDE = 'C' "
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
            Else
                strSql = strSql & " AND (c.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDt & "', 'YYYY-MM-DD')"
                strSql = strSql & " AND c.EFFECTIVE_TO_DT >= to_date('" & vntOrgDt & "', 'YYYY-MM-DD'))"
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDt & ";"
            End If
        Else
            strSql = strSql & " AND c.RECORD_STATUS_CDE = 'C' "
            vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
        End If

        strSql = strSql & " AND a.DELIVERY_SMRY_TYPE = '4'"
        strSql = strSql & " AND a.ACTUAL_SHIP_BUILDING_NBR = '" & vntPlant & "'"
        strSql = strSql & " GROUP BY ROLLUP (a.ACTUAL_SHIP_LOCATION, c.ORGANIZATION_ID, "
        strSql = strSql & " c.ORGANIZATION_SHORT_NM)  "

        vntDispCrit = vntDispCrit & " <strong>Plant/Blg:</strong> " & vntPlant & ";"

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsResultsGeneral.ListShipFclty call to CallRS for Main Results")
        End If

        If vntCount > 0 Then
            ReDim vntArray(6, CInt(vntCount))
            vntTempArray = objList
            intDetailCnt = 0
            intCount = 0
            For intTempCount = 0 To UBound(vntTempArray, 2)
                'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                If Not IsDBNull(vntTempArray(2, intTempCount)) Then
                    vntArray(0, intCount) = vntTempArray(0, intTempCount) 'Location
                    vntArray(1, intCount) = vntTempArray(1, intTempCount) & " - " & vntTempArray(2, intTempCount) 'Org
                    vntArray(2, intCount) = vntTempArray(3, intTempCount) 'Total Schedules
                    vntArray(3, intCount) = vntTempArray(4, intTempCount) 'Total On-Time
                    vntArray(4, intCount) = vntTempArray(5, intTempCount) 'Percent On-Time
                    vntArray(5, intCount) = vntTempArray(6, intTempCount) 'Total Late
                    vntArray(6, intCount) = vntTempArray(7, intTempCount) 'Percent Late
                    intCount = intCount + 1
                    intDetailCnt = intDetailCnt + 1
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                ElseIf IsDBNull(vntTempArray(0, intTempCount)) Then
                    vntArray(0, intCount) = ""
                    vntArray(1, intCount) = "Total:"
                    vntArray(2, intCount) = VB6.Format(CDbl(vntTempArray(3, intTempCount)), "#,###,##0")
                    vntArray(3, intCount) = VB6.Format(CDbl(vntTempArray(4, intTempCount)), "#,###,##0")
                    vntArray(4, intCount) = vntTempArray(5, intTempCount) 'Percent On-Time
                    vntArray(5, intCount) = VB6.Format(CDbl(vntTempArray(6, intTempCount)), "#,###,##0")
                    vntArray(6, intCount) = vntTempArray(7, intTempCount) 'Percent Late
                    intCount = intCount + 1
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                ElseIf IsDBNull(vntTempArray(1, intTempCount)) Then
                    vntArray(0, intCount) = vntTempArray(0, intTempCount) 'Location
                    vntArray(1, intCount) = ""
                    vntArray(2, intCount) = vntTempArray(3, intTempCount) 'Total Schedules
                    vntArray(3, intCount) = vntTempArray(4, intTempCount) 'Total On-Time
                    vntArray(4, intCount) = vntTempArray(5, intTempCount) 'Percent On-Time
                    vntArray(5, intCount) = vntTempArray(6, intTempCount) 'Total Late
                    vntArray(6, intCount) = vntTempArray(7, intTempCount) 'Percent Late
                    intCount = intCount + 1
                End If
            Next
            ReDim Preserve vntArray(6, (intCount - 1))
            vntCount = intDetailCnt
            ListShpFclty = vntArray
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListShpFclty = System.DBNull.Value
        End If

        vntErrorNbr = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListShpFclty = System.DBNull.Value
        vntErrorNbr = Err.Number
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

    '##ModelId=3AC09D3A027B
    Public Function ListOrgYTD(ByVal vntSessionID As String, ByRef vntCount As Object, ByRef vntSmryType As String, ByRef vntCurrMth As String, ByRef vntPrevMth As String, ByRef vntDispCrit As String, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As String, ByRef strSql As String) As Object
        Dim objCallRS As New clsCallRS
        Dim objCallSP As New clsCallSP
        Dim objSearch As New clsSearch
        Dim objList As Object
        Dim objOrgs As New clsOrgs
        Dim arrOutVar(3) As String
        Dim blnrc As Boolean
        Dim strErrorDesc As String = ""
        Dim lngErrorNbr As Integer
        Dim vntTempArray As Object
        Dim vntArray As Object
        Dim intColumn As Short
        Dim intRow As Integer
        'Dim intCount As Short
        'Dim vntViewId As String = ""
        'Dim vntCategoryId As String = ""
        'Dim vntWindowId As String = ""
        'Dim vntStartDt As String = ""
        'Dim vntEndDt As String = ""
        'Dim vntCurrentHist As Object
        'Dim vntOrgType As Object
        'Dim vntOrgID As Object
        'Dim vntDaysEarly As String = ""
        'Dim vntDaysLate As String = ""
        'Dim vntMonthDailyInd As Object
        'Dim vntCustAcctTypeCde As Object
        'Dim vntPart As Object
        'Dim vntPlant As Object
        'Dim vntLocation As Object
        'Dim vntacctOrgKey As Object
        'Dim vntShipTo As Object
        'Dim vntSoldTo As Object
        'Dim vntWWCust As Object
        Dim vntCntrlrKey As String = ""
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
        Dim vntProfitCtr As String = ""
        'Dim vntCBC As Object
        'Dim vntSubCBC As Object
        'Dim vntOrgDt As Object
        'Dim vntLevel As Object
        Dim vntVBDt As Object
        Dim vntPrevYear As Object
        Dim vntCurrYear As Object
        Dim vntOrgLevel As String = ""
        Dim vntOrgName As String = ""
        Dim vntWindowText As Object
        Dim vntSubTotal As Object
        Dim vntCompany As Object
        'Dim vntOrgTypeDesc As Object
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

        Dim intCount As Integer
        Dim vntViewId As String = ""
        Dim vntCategoryId As String = ""
        Dim vntWindowId As String = ""
        Dim vntStartDt As String = ""
        Dim vntEndDt As String = ""
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
        Dim vntOrgDt As String = ""
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
            Err.Raise(100, , "Session Id not passed or found in component needed for retrieving search criteria in clsResultsGeneral.ListOrgYTD")
        End If

        blnrc = objSearch.RetrieveSession(vntSessionID, vntViewId, vntCategoryId, vntWindowId, vntStartDt, vntEndDt, vntDaysEarly, vntDaysLate, vntMonthDailyInd, vntSmryType, vntCurrentHist, vntOrgType, vntOrgID, vntCustAcctTypeCde, vntPart, vntPlant, vntLocation, vntacctOrgKey, vntShipTo, vntSoldTo, vntWWCust, vntCntrlrKey, vntController, vntCntlrEmpNbr, vntStkMake, vntTeam, vntProdCde, vntProdLne, vntIBC, vntIC, vntMfgCampus, vntMfgBuilding, vntComparisonType, vntOpenShpOrder, vntProfitCtr, vntCBC, vntOrgDt, vntSubCBC, vntProdMgr, vntLeadTimeType, vntSalesOffice, vntSalesGroup, vntMfgOrgType, vntMfgOrgId, GamAccount, vntPartKeyID, vntMrpGroupCde, vntHostOrgID, vntErrorNbr, vntErrorDesc)
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        If Not blnrc Or vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " In call to clsSearch.RetrieveSession in clsResultsGeneral.ListOrgYTD")
        End If

        If vntOrgID <> "" Then
            blnrc = objOrgs.RetrieveType(vntOrgType, vntOrgTypeDesc, vntErrorNbr, vntErrorDesc)
            If Not blnrc Then
                vntOrgTypeDesc = "Desc Not Found"
            End If

            vntDispCrit = vntDispCrit & "<strong> Org Type:</strong> " & vntOrgTypeDesc & ";"
            vntDispCrit = vntDispCrit & "<strong> Org ID:</strong> " & vntOrgID & ";"

            blnrc = objOrgs.RetrieveLevel(vntOrgID, vntCurrentHist, vntOrgDt, vntLevel, vntErrorNbr, vntErrorDesc)
            If Not blnrc Then
                Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " In call to clsOrgs.RetrieveLevel in clsResultsGeneral.ListOrgYTD")
            End If

            If Len(vntLevel) > 6 Then
                vntLevel = Right(vntLevel, 2)
            Else
                vntLevel = Right(vntLevel, 1)
            End If
            'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objOrgs = Nothing
        End If

        If vntDaysEarly = "" Then
            vntDaysEarly = 0
        End If

        If vntDaysLate = "" Then
            vntDaysLate = "0"
        End If

        If vntSmryType = "3" Then
            vntDaysEarly = "0"
            vntDaysLate = "0"
        End If

        'Format Current Month Date

        'UPGRADE_WARNING: DateValue has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        vntVBDt = DateValue(vntStartDt)
        vntCurrYear = Year(vntVBDt).ToString
        vntCurrMth = Month(vntVBDt).ToString
        If Len(vntCurrMth) = 1 Then
            vntCurrMth = "0" & vntCurrMth
        End If
        vntCurrMth = vntCurrYear & "-" & vntCurrMth

        'Format Previous Month Date

        vntVBDt = DateAdd(Microsoft.VisualBasic.DateInterval.Month, -1, vntVBDt)
        vntPrevYear = Year(vntVBDt).ToString
        vntPrevMth = Month(vntVBDt).ToString
        If Len(vntPrevMth) = 1 Then
            vntPrevMth = "0" & vntPrevMth
        End If
        vntPrevMth = vntPrevYear & "-" & vntPrevMth

        'If previous month is December start date must be Dec 1
        'Otherwise start date is Jan 1 of the current year

        If vntPrevYear < vntCurrYear Then
            vntStartDt = vntPrevMth & "-01"
        Else
            vntStartDt = vntCurrYear & "-01-01"
        End If

        strSql = strSql & " SELECT c.COMPANY_ORGANIZATION_ID,  "
        strSql = strSql & " c.LAYER10_ORGANIZATION_ID Org10,  "
        strSql = strSql & " c.LAYER9_ORGANIZATION_ID Org9,  "
        strSql = strSql & " c.LAYER8_ORGANIZATION_ID Org8,  "
        strSql = strSql & " c.LAYER7_ORGANIZATION_ID Org7,  "
        strSql = strSql & " c.LAYER6_ORGANIZATION_ID Org6,  "
        strSql = strSql & " c.LAYER5_ORGANIZATION_ID Org5,  "
        strSql = strSql & " c.LAYER4_ORGANIZATION_ID Org4,  "
        strSql = strSql & " c.LAYER3_ORGANIZATION_ID Org3,  "
        strSql = strSql & " c.LAYER2_ORGANIZATION_ID Org2,  "
        strSql = strSql & " c.LAYER1_ORGANIZATION_ID Org1, "
        strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY-MM'), '" & vntCurrMth & "', TOTAL_NBR_SHPMTS, 0)) CurrTotal,  "
        strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY-MM'), '" & vntPrevMth & "', TOTAL_NBR_SHPMTS, 0)) PrevTotal,  "
        strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY'), '" & vntCurrYear & "', TOTAL_NBR_SHPMTS, 0)) YTDTotal,  "

        If vntWindowId = "1" Then 'Customer Variable
            vntWindowText = "VARBL"
        Else
            vntWindowText = "SHPMTS"
            If vntDaysEarly <> "" Then
                If vntWindowId = "2" And vntSmryType = "1" Then 'Std default & Schedule to Ship
                    vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> All;"
                Else
                    vntDispCrit = vntDispCrit & " <strong>Days Early:</strong> " & vntDaysEarly & ";"
                End If
                vntDispCrit = vntDispCrit & " <strong>Days Late:</strong> " & vntDaysLate & ";"
            End If
        End If

        If vntSmryType = "1" Then
            vntDispCrit = vntDispCrit & "<strong> Summary Type:</strong> Schedule To Ship;"
        ElseIf vntSmryType = "2" Then
            vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request To Ship;"
        Else
            vntDispCrit = vntDispCrit & " <strong>Summary Type:</strong> Request to Schedule;"
        End If

        'Current On Time

        strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY-MM'), '" & vntCurrMth & "', (NBR_" & vntWindowText & "_ON_TIME + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 4), 4, 0, (NBR_" & vntWindowText & "_FIVE_DAYS_LATE - NBR_JIT_FIVE_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 3), 3, 0, (NBR_" & vntWindowText & "_FOUR_DAYS_LATE - NBR_JIT_FOUR_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 2), 2, 0, (NBR_" & vntWindowText & "_THREE_DAYS_LATE - NBR_JIT_THREE_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 1), 1, 0, (NBR_" & vntWindowText & "_TWO_DAYS_LATE - NBR_JIT_TWO_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 0), 0, 0, (NBR_" & vntWindowText & "_ONE_DAY_LATE - NBR_JIT_ONE_DAY_LATE)) + "

        If vntWindowId = "2" And vntSmryType = "1" Then 'Std default & Schedule to Ship
            strSql = strSql & "((NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY) -"
            strSql = strSql & " (NBR_JIT_OUT_RANGE_EARLY + NBR_JIT_SIX_DAYS_EARLY + NBR_JIT_FIVE_DAYS_EARLY + NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY)) ), 0)) CurrOntime, "
        Else
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 4), 4, 0, (NBR_" & vntWindowText & "_FIVE_DAYS_EARLY - NBR_JIT_FIVE_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 3), 3, 0, (NBR_" & vntWindowText & "_FOUR_DAYS_EARLY - NBR_JIT_FOUR_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 2), 2, 0, (NBR_" & vntWindowText & "_THREE_DAYS_EARLY - NBR_JIT_THREE_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 1), 1, 0, (NBR_" & vntWindowText & "_TWO_DAYS_EARLY - NBR_JIT_TWO_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 0), 0, 0, (NBR_" & vntWindowText & "_ONE_DAY_EARLY - NBR_JIT_ONE_DAY_EARLY)) ), 0)) CurrOntime, "
        End If

        'Previous On Time

        strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY-MM'), '" & vntPrevMth & "', (NBR_" & vntWindowText & "_ON_TIME + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 4), 4, 0, (NBR_" & vntWindowText & "_FIVE_DAYS_LATE - NBR_JIT_FIVE_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 3), 3, 0, (NBR_" & vntWindowText & "_FOUR_DAYS_LATE - NBR_JIT_FOUR_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 2), 2, 0, (NBR_" & vntWindowText & "_THREE_DAYS_LATE - NBR_JIT_THREE_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 1), 1, 0, (NBR_" & vntWindowText & "_TWO_DAYS_LATE - NBR_JIT_TWO_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 0), 0, 0, (NBR_" & vntWindowText & "_ONE_DAY_LATE - NBR_JIT_ONE_DAY_LATE)) + "

        If vntWindowId = "2" And vntSmryType = "1" Then 'Std default & Schedule to Ship
            strSql = strSql & "((NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY) -"
            strSql = strSql & " (NBR_JIT_OUT_RANGE_EARLY + NBR_JIT_SIX_DAYS_EARLY + NBR_JIT_FIVE_DAYS_EARLY + NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY)) ), 0)) PrevOntime, "
        Else
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 4), 4, 0, (NBR_" & vntWindowText & "_FIVE_DAYS_EARLY - NBR_JIT_FIVE_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 3), 3, 0, (NBR_" & vntWindowText & "_FOUR_DAYS_EARLY - NBR_JIT_FOUR_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 2), 2, 0, (NBR_" & vntWindowText & "_THREE_DAYS_EARLY - NBR_JIT_THREE_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 1), 1, 0, (NBR_" & vntWindowText & "_TWO_DAYS_EARLY - NBR_JIT_TWO_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 0), 0, 0, (NBR_" & vntWindowText & "_ONE_DAY_EARLY - NBR_JIT_ONE_DAY_EARLY)) ), 0)) PrevOntime, "
        End If

        'YTD On Time

        strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY'), '" & vntCurrYear & "', (NBR_" & vntWindowText & "_ON_TIME + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 4), 4, 0, (NBR_" & vntWindowText & "_FIVE_DAYS_LATE - NBR_JIT_FIVE_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 3), 3, 0, (NBR_" & vntWindowText & "_FOUR_DAYS_LATE - NBR_JIT_FOUR_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 2), 2, 0, (NBR_" & vntWindowText & "_THREE_DAYS_LATE - NBR_JIT_THREE_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 1), 1, 0, (NBR_" & vntWindowText & "_TWO_DAYS_LATE - NBR_JIT_TWO_DAYS_LATE)) + "
        strSql = strSql & " DECODE(GREATEST(" & vntDaysLate & ", 0), 0, 0, (NBR_" & vntWindowText & "_ONE_DAY_LATE - NBR_JIT_ONE_DAY_LATE)) + "

        If vntWindowId = "2" And vntSmryType = "1" Then 'Std default & Schedule to Ship
            strSql = strSql & "((NBR_SHPMTS_OUT_RANGE_EARLY + NBR_SHPMTS_SIX_DAYS_EARLY + NBR_SHPMTS_FIVE_DAYS_EARLY + NBR_SHPMTS_FOUR_DAYS_EARLY + NBR_SHPMTS_THREE_DAYS_EARLY + NBR_SHPMTS_TWO_DAYS_EARLY + NBR_SHPMTS_ONE_DAY_EARLY) -"
            strSql = strSql & " (NBR_JIT_OUT_RANGE_EARLY + NBR_JIT_SIX_DAYS_EARLY + NBR_JIT_FIVE_DAYS_EARLY + NBR_JIT_FOUR_DAYS_EARLY + NBR_JIT_THREE_DAYS_EARLY + NBR_JIT_TWO_DAYS_EARLY + NBR_JIT_ONE_DAY_EARLY)) ), 0)) YTDOntime "
        Else
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 4), 4, 0, (NBR_" & vntWindowText & "_FIVE_DAYS_EARLY - NBR_JIT_FIVE_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 3), 3, 0, (NBR_" & vntWindowText & "_FOUR_DAYS_EARLY - NBR_JIT_FOUR_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 2), 2, 0, (NBR_" & vntWindowText & "_THREE_DAYS_EARLY - NBR_JIT_THREE_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 1), 1, 0, (NBR_" & vntWindowText & "_TWO_DAYS_EARLY - NBR_JIT_TWO_DAYS_EARLY)) + "
            strSql = strSql & " DECODE(GREATEST(" & vntDaysEarly & ", 0), 0, 0, (NBR_" & vntWindowText & "_ONE_DAY_EARLY - NBR_JIT_ONE_DAY_EARLY)) ), 0)) YTDOntime "
        End If

        If vntSmryType = "1" Then 'Schedule to Ship
            'JIT Totals
            strSql = strSql & ", SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY-MM'), '" & vntCurrMth & "',TOTAL_NBR_JIT_SHPMTS, 0)) CurrJitTotal, "
            strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY-MM'), '" & vntPrevMth & "',TOTAL_NBR_JIT_SHPMTS, 0)) PrevJitTotal, "
            strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY'), '" & vntCurrYear & "',TOTAL_NBR_JIT_SHPMTS, 0)) YTDJitTotal,  "
            strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY-MM'), '" & vntCurrMth & "', (NBR_JIT_ON_TIME), 0)) CurrJitOntime, "
            strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY-MM'), '" & vntPrevMth & "', (NBR_JIT_ON_TIME), 0)) PrevJitOntime, "
            strSql = strSql & " SUM(DECODE(TO_CHAR(AMP_SHIPPED_MONTH, 'YYYY'), '" & vntCurrYear & "', (NBR_JIT_ON_TIME), 0)) YTDJitOntime "
        End If

        strSql = strSql & " FROM ORGANIZATIONS_DMN c, "
        strSql = strSql & " SCORECARD_ORG_SMRY a  "
        strSql = strSql & " WHERE AMP_SHIPPED_MONTH BETWEEN to_date('" & vntStartDt & "', 'YYYY-MM-DD') AND to_date('" & vntEndDt & "', 'YYYY-MM-DD')"
        strSql = strSql & " AND DELIVERY_SMRY_TYPE = '" & vntSmryType & "' "
        strSql = strSql & " AND c.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        strSql = strSql & " AND a.ORGANIZATION_KEY_ID = c.ORGANIZATION_KEY_ID "

        vntDispCrit = vntDispCrit & " <strong>Date Range:</strong> " & vntStartDt & " To " & vntEndDt & ";"

        If vntMonthDailyInd <> "" Then
            If vntMonthDailyInd = "1" Then
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Monthly;"
            Else
                vntDispCrit = vntDispCrit & " <strong>Monthly/Daily:</strong> Daily;"
            End If
        End If

        If vntCurrentHist <> "" Then
            If vntCurrentHist = "C" Then
                strSql = strSql & " AND RECORD_STATUS_CDE = 'C' "
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
            Else
                strSql = strSql & " AND (C.EFFECTIVE_FROM_DT <= to_date('" & vntOrgDt & "', 'YYYY-MM-DD')"
                strSql = strSql & " AND C.EFFECTIVE_TO_DT >= to_date('" & vntOrgDt & "', 'YYYY-MM-DD'))"
                vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> History;"
                vntDispCrit = vntDispCrit & "<strong> Org Date:</strong> " & vntOrgDt & ";"
            End If
        Else
            strSql = strSql & " AND C.RECORD_STATUS_CDE = 'C' "
            vntDispCrit = vntDispCrit & " <strong>Org Hierarchy:</strong> Current;"
        End If

        If vntCustAcctTypeCde <> "0" Then
            If vntCustAcctTypeCde <> "" Then
                strSql = strSql & " AND CUSTOMER_ACCT_TYPE_CDE = '" & vntCustAcctTypeCde & "' "
                vntDispCrit = vntDispCrit & " <strong>Cust Acct Type:</strong> " & vntCustAcctTypeCde & ";"
            End If
        End If

        strSql = strSql & " GROUP BY ROLLUP (c.LAYER1_ORGANIZATION_ID, "
        strSql = strSql & " c.LAYER2_ORGANIZATION_ID,  "
        strSql = strSql & " c.LAYER3_ORGANIZATION_ID,  "
        strSql = strSql & " c.LAYER4_ORGANIZATION_ID,  "
        strSql = strSql & " c.LAYER5_ORGANIZATION_ID,  "
        strSql = strSql & " c.LAYER6_ORGANIZATION_ID,  "
        strSql = strSql & " c.LAYER7_ORGANIZATION_ID,  "
        strSql = strSql & " c.LAYER8_ORGANIZATION_ID,  "
        strSql = strSql & " c.LAYER9_ORGANIZATION_ID,  "
        strSql = strSql & " c.LAYER10_ORGANIZATION_ID,  "
        strSql = strSql & " c.COMPANY_ORGANIZATION_ID)  "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsResultsGeneral.ListOrgYTD call to CallRS for Main Results")
        End If

        If vntCount > 0 Then
            ReDim vntArray(19, 0 To CInt(vntCount - 1))
            intColumn = 1
            intRow = 1
            vntTempArray = objList
            vntCompany = vntTempArray(0, 0)
            Do Until intRow = CInt(vntCount) - 1
                If vntTempArray(intColumn + 2, intRow) = vntCompany And vntTempArray(intColumn + 3, intRow) <> vntCompany Then
                    vntSubTotal = "N"
                ElseIf vntTempArray(intColumn + 1, intRow) = vntCompany And vntTempArray(intColumn + 2, intRow) <> vntCompany Then
                    If vntTempArray(intColumn, intRow) = vntCompany Then
                        vntSubTotal = ""
                        intColumn = intColumn + 1
                        intRow = intRow + 1
                    Else
                        vntSubTotal = "Y"
                    End If
                ElseIf vntTempArray(intColumn, intRow) = vntCompany And vntTempArray(intColumn + 1, intRow) <> vntCompany Then
                    vntSubTotal = "T"
                Else
                    vntSubTotal = ""
                    intColumn = intColumn + 1
                    intRow = intRow + 1
                End If
                If vntSubTotal <> "" Then
                    vntOrgID = vntTempArray(intColumn, intRow) 'Org

                    blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveOrgInfo", lngErrorNbr, strErrorDesc, arrOutVar, "I", vntOrgID, "I", vntCurrentHist, "I", vntOrgDt, "O", vntOrgLevel, "O", vntOrgType, "O", vntOrgName)
                    If Not blnrc Then
                        Err.Raise(lngErrorNbr, , strErrorDesc & " Call to procedure scdCommom.RetrieveOrgInfo in clsResultsGeneral.ListOrgYTD")
                    End If

                    vntOrgLevel = arrOutVar(0)
                    vntOrgType = arrOutVar(1)
                    vntOrgName = arrOutVar(2)

                    vntArray(0, intCount) = vntOrgType & ":  " & vntOrgID & " - " & vntOrgName
                    vntArray(1, intCount) = vntSubTotal
                    vntArray(2, intCount) = vntTempArray(11, intRow) 'CurrTotal
                    vntArray(3, intCount) = vntTempArray(14, intRow) 'CurrOnTime

                    If vntTempArray(11, intRow) > 0 Then
                        vntArray(4, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(14, intRow)) / CDbl(vntTempArray(11, intRow)) * 100, 3), "0.0") 'CurrOnTime%
                    Else
                        vntArray(4, intCount) = VB6.Format(0, "0.0")
                    End If

                    vntArray(5, intCount) = vntTempArray(12, intRow) 'PrevTotal
                    vntArray(6, intCount) = vntTempArray(15, intRow) 'PrevOnTime

                    If vntTempArray(12, intRow) > 0 Then
                        vntArray(7, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(15, intRow)) / CDbl(vntTempArray(12, intRow)) * 100, 3), "0.0") 'PrevOnTime%
                    Else
                        vntArray(7, intCount) = VB6.Format(0, "0.0")
                    End If

                    vntArray(8, intCount) = vntTempArray(13, intRow) 'YTDTotal
                    vntArray(9, intCount) = vntTempArray(16, intRow) 'YTDOnTime

                    If vntTempArray(13, intRow) > 0 Then
                        vntArray(10, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(16, intRow)) / CDbl(vntTempArray(13, intRow)) * 100, 3), "0.0") 'YTDOnTime%
                    Else
                        vntArray(10, intCount) = VB6.Format(0, "0.0")
                    End If

                    If vntSmryType = 1 Then 'Schedule to Ship
                        vntArray(11, intCount) = vntTempArray(17, intRow) 'CurrJITTotal
                        vntArray(12, intCount) = vntTempArray(20, intRow) 'CurrJITOnTime

                        If vntTempArray(17, intRow) > 0 Then
                            vntArray(13, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(20, intRow)) / CDbl(vntTempArray(17, intRow)) * 100, 3), "0.0") 'CurrJITOnTime%
                        Else
                            vntArray(13, intCount) = VB6.Format(0, "0.0")
                        End If

                        vntArray(14, intCount) = vntTempArray(18, intRow) 'PrevJITTotal
                        vntArray(15, intCount) = vntTempArray(21, intRow) 'PrevJITOnTime

                        If vntTempArray(18, intRow) > 0 Then
                            vntArray(16, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(21, intRow)) / CDbl(vntTempArray(18, intRow)) * 100, 3), "0.0") 'PrevJITOnTime%
                        Else
                            vntArray(16, intCount) = VB6.Format(0, "0.0")
                        End If

                        vntArray(17, intCount) = vntTempArray(19, intRow) 'YTDJITTotal
                        vntArray(18, intCount) = vntTempArray(22, intRow) 'YTDJITOnTime

                        If vntTempArray(19, intRow) > 0 Then
                            vntArray(19, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(22, intRow)) / CDbl(vntTempArray(19, intRow)) * 100, 3), "0.0") 'YTDJITOnTime%
                        Else
                            vntArray(19, intCount) = VB6.Format(0, "0.0")
                        End If
                    End If

                    If vntSubTotal = "T" Then 'Company Total
                        intRow = intRow + 1
                        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                        Do Until intRow = CInt(vntCount) - 1 Or Not IsDBNull(vntTempArray(0, intRow))
                            intRow = intRow + 1
                        Loop
                        vntCompany = vntTempArray(0, intRow)
                        intColumn = 1
                        If intRow <> CInt(vntCount) - 1 Then
                            intRow = intRow + 1
                        End If
                        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    ElseIf IsDBNull(vntTempArray(intColumn, intRow + 1)) Then
                        intColumn = intColumn + 1
                        intRow = intRow + 1
                    Else
                        intColumn = 1
                        intRow = intRow + 2
                    End If
                    intCount = intCount + 1
                End If
            Loop

            intRow = CInt(vntCount) - 1

            vntArray(0, intCount) = "Grand Total:"
            vntArray(1, intCount) = "Y"
            vntArray(2, intCount) = VB6.Format(CDbl(vntTempArray(11, intRow)), "#,###,##0") 'CurrTotal
            vntArray(3, intCount) = VB6.Format(CDbl(vntTempArray(14, intRow)), "#,###,##0") 'CurrOnTime

            If vntTempArray(11, intRow) > 0 Then
                vntArray(4, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(14, intRow)) / CDbl(vntTempArray(11, intRow)) * 100, 3), "0.0") 'CurrOnTime%
            Else
                vntArray(4, intCount) = VB6.Format(0, "0.0")
            End If

            vntArray(5, intCount) = VB6.Format(CDbl(vntTempArray(12, intRow)), "#,###,##0") 'PrevTotal
            vntArray(6, intCount) = VB6.Format(CDbl(vntTempArray(15, intRow)), "#,###,##0") 'PrevOnTime

            If vntTempArray(12, intRow) > 0 Then
                vntArray(7, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(15, intRow)) / CDbl(vntTempArray(12, intRow)) * 100, 3), "0.0") 'PrevOnTime%
            Else
                vntArray(7, intCount) = VB6.Format(0, "0.0")
            End If

            vntArray(8, intCount) = VB6.Format(CDbl(vntTempArray(13, intRow)), "#,###,##0") 'YTDTotal
            vntArray(9, intCount) = VB6.Format(CDbl(vntTempArray(16, intRow)), "#,###,##0") 'YTDOnTime

            If vntTempArray(13, intRow) > 0 Then
                vntArray(10, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(16, intRow)) / CDbl(vntTempArray(13, intRow)) * 100, 3), "0.0") 'YTDOnTime%
            Else
                vntArray(10, intCount) = VB6.Format(0, "0.0")
            End If

            If vntSmryType = "1" Then 'Schedule to Ship
                vntArray(11, intCount) = VB6.Format(CDbl(vntTempArray(17, intRow)), "#,###,##0") 'CurrJITTotal
                vntArray(12, intCount) = VB6.Format(CDbl(vntTempArray(20, intRow)), "#,###,##0") 'CurrJITOnTime

                If vntTempArray(17, intRow) > 0 Then
                    vntArray(13, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(20, intRow)) / CDbl(vntTempArray(17, intRow)) * 100, 3), "0.0") 'CurrJITOnTime%
                Else
                    vntArray(13, intCount) = VB6.Format(0, "0.0")
                End If

                vntArray(14, intCount) = VB6.Format(CDbl(vntTempArray(18, intRow)), "#,###,##0") 'PrevJITTotal
                vntArray(15, intCount) = VB6.Format(CDbl(vntTempArray(21, intRow)), "#,###,##0") 'PrevJITOnTime

                If vntTempArray(18, intRow) > 0 Then
                    vntArray(16, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(21, intRow)) / CDbl(vntTempArray(18, intRow)) * 100, 3), "0.0") 'PrevJITOnTime%
                Else
                    vntArray(16, intCount) = VB6.Format(0, "0.0")
                End If

                vntArray(17, intCount) = VB6.Format(CDbl(vntTempArray(19, intRow)), "#,###,##0") 'YTDJITTotal
                vntArray(18, intCount) = VB6.Format(CDbl(vntTempArray(22, intRow)), "#,###,##0") 'YTDJITOnTime

                If vntTempArray(19, intRow) > 0 Then
                    vntArray(19, intCount) = VB6.Format(System.Math.Round(CDbl(vntTempArray(22, intRow)) / CDbl(vntTempArray(19, intRow)) * 100, 3), "0.0") 'YTDJITOnTime%
                Else
                    vntArray(19, intCount) = VB6.Format(0, "0.0")
                End If
            End If
            ReDim Preserve vntArray(19, (intCount))

            vntCount = intCount
            ListOrgYTD = vntArray
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListOrgYTD = System.DBNull.Value
        End If

        vntErrorNbr = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListOrgYTD = System.DBNull.Value
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing
        'UPGRADE_NOTE: Object objSearch may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objSearch = Nothing
        Exit Function
    End Function
End Class