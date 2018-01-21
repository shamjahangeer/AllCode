Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsDetail
    Inherits ServicedComponent

    '##ModelId=3A9294480365
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A9298BC000F
    Private ObjContext As System.EnterpriseServices.ContextUtil

    Public Function ListDetail(ByVal vntOpenShipInd As String, ByVal vntOrgKeyId As String, ByVal vntOrdNbr As String, ByVal vntOrdItem As String, ByVal vntSchedId As String, ByRef vntFldCnt As Object, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As Object, ByRef strSql As String) As Object
        Dim objConnection As New ADODB.Connection
        Dim objCallRS As New clsCallRS
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(9) As String
        Dim objList As Object
        Dim blnrc As Boolean
        Dim vntTempArray As Object
        Dim vntArray As Object
        Dim intCount As Short
        Dim strErrorDesc As String = ""
        Dim lngErrorNbr As Integer

        Dim vntOrgDt As String = ""
        Dim vntAcctOrg As String = ""
        Dim vntCustNbr As String = ""
        Dim vntIBC As String = ""
        Dim vntMfgOrg As String = ""
        Dim vntCustName As String = ""
        Dim vntIBCName As String = ""
        Dim vntMfgOrgLvl As String = ""
        Dim vntMfgOrgId As String = ""
        Dim vntMfgOrgAbbrn As String = ""
        Dim vntMfgPrntOrgLvl As String = ""
        Dim vntMfgPrntOrgId As String = ""
        Dim vntMfgPrntOrgAbbrn As String = ""
        Dim vntCount As Object = 0
        Dim vntSoldToNbr As String = ""
        Dim vntSoldToName As String = ""

        On Error GoTo ErrorHandler

        If vntOpenShipInd = "" Or vntOrgKeyId = "" Or vntOrdNbr = "" Or vntOrdItem = "" Or vntSchedId = "" Then
            Err.Raise(100, , "Required Parms not passed in clsDetail.ListDetail")
        End If

        strSql = " SELECT TYCO_ELECTRONICS_CORP_PART_NBR, "
        strSql = strSql & " PURCHASE_BY_ACCOUNT_BASE||SHIP_TO_ACCOUNT_SUFFIX, "
        strSql = strSql & " PRODCN_CNTRLR_CODE, "
        strSql = strSql & " ITEM_QUANTITY, "
        strSql = strSql & " RESRVN_LEVEL_1, "
        strSql = strSql & " RESRVN_LEVEL_5, "
        strSql = strSql & " RESRVN_LEVEL_9, "
        strSql = strSql & " QUANTITY_RELEASED, "
        strSql = strSql & " QUANTITY_SHIPPED, "
        strSql = strSql & " ISO_CURRENCY_CODE_1, "
        strSql = strSql & " LOCAL_CURRENCY_BILLED_AMOUNT, "
        strSql = strSql & " EXTENDED_BOOK_BILL_AMOUNT, "
        strSql = strSql & " DECODE(TO_CHAR(CUSTOMER_REQUEST_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(CUSTOMER_REQUEST_DATE, 'YYYY-MM-DD')), "
        strSql = strSql & " DECODE(TO_CHAR(AMP_SCHEDULE_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(AMP_SCHEDULE_DATE, 'YYYY-MM-DD')), "
        strSql = strSql & " DECODE(TO_CHAR(RELEASE_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(RELEASE_DATE, 'YYYY-MM-DD')), "
        'strSql = strSql & " DECODE(TO_CHAR(ACTUAL_ON_DOCK_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(ACTUAL_ON_DOCK_DATE, 'YYYY-MM-DD')), "
        'strSql = strSql & " DECODE(TO_CHAR(SCHEDULE_ON_CUSTOMER_DOCK_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(SCHEDULE_ON_CUSTOMER_DOCK_DATE, 'YYYY-MM-DD')), "
        'strSql = strSql & " DECODE(TO_CHAR(ACTUAL_ON_CUSTOMER_DOCK_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(ACTUAL_ON_CUSTOMER_DOCK_DATE, 'YYYY-MM-DD')), "
        strSql = strSql & " NULL, NULL, NULL, "

        If vntOpenShipInd = "S" Then
            strSql = strSql & " DECODE(TO_CHAR(AMP_SHIPPED_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(AMP_SHIPPED_DATE, 'YYYY-MM-DD')), "
            strSql = strSql & " NBR_WINDOW_DAYS_EARLY, "
            strSql = strSql & " NBR_WINDOW_DAYS_LATE, "
            'strSql = strSql & " INVENTORY_LOCATION_CODE, "
            strSql = strSql & " TRSP_MGE_TRANSIT_TIME_DAYS_QTY, "
            'strSql = strSql & " INVENTORY_BUILDING_NBR, "
            strSql = strSql & " ACTUAL_SHIP_FROM_BUILDING_ID, "
        Else
            'backlog does not have the fields
            strSql = strSql & " NULL, NULL, NULL, NULL, NULL, "
        End If

        'strSql = strSql & " ACTUAL_SHIP_LOCATION, "
        strSql = strSql & " ACTUAL_SHIP_BUILDING_NBR, "
        strSql = strSql & " STORAGE_LOCATION_ID, "
        strSql = strSql & " DECODE(TO_CHAR(ORDER_BOOKING_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(ORDER_BOOKING_DATE, 'YYYY-MM-DD')), "
        strSql = strSql & " DECODE(TO_CHAR(ORDER_RECEIVED_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(ORDER_RECEIVED_DATE, 'YYYY-MM-DD')), "
        strSql = strSql & " ORDER_TYPE_ID, "
        strSql = strSql & " DECODE(TO_CHAR(REGTRD_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(REGTRD_DATE, 'YYYY-MM-DD')), "
        strSql = strSql & " TO_CHAR(PURCHASE_ORDER_DATE, 'YYYY-MM-DD'), "
        strSql = strSql & " PURCHASE_ORDER_NBR, "
        strSql = strSql & " NULL, " 'strSql = strSql & " SCHLG_METHOD_CODE, "
        'strSql = strSql & " TEAM_CODE, "
        strSql = strSql & " INVENTORY_LOCATION_CODE, "
        strSql = strSql & " STOCK_MAKE_CODE, "
        strSql = strSql & " PRODUCT_CODE, "
        strSql = strSql & " WW_ACCOUNT_NBR_BASE||'-'||WW_ACCOUNT_NBR_SUFFIX, "

        If vntOpenShipInd = "S" Then
            strSql = strSql & " CUSTOMER_FORECAST_CODE, "
        Else
            'backlog does not have the field
            strSql = strSql & " NULL, "
        End If

        strSql = strSql & " CUSTOMER_REFERENCE_PART_NBR, "

        If vntOpenShipInd = "S" Then
            strSql = strSql & " DECODE(TO_CHAR(CUSTOMER_EXPEDITE_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(CUSTOMER_EXPEDITE_DATE, 'YYYY-MM-DD')), "
            strSql = strSql & " NBR_OF_EXPEDITES, "
            strSql = strSql & " DECODE(TO_CHAR(ORIGINAL_EXPEDITE_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(ORIGINAL_EXPEDITE_DATE, 'YYYY-MM-DD')), "
            strSql = strSql & " DECODE(TO_CHAR(CURRENT_EXPEDITE_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(CURRENT_EXPEDITE_DATE, 'YYYY-MM-DD')), "
            strSql = strSql & " DECODE(TO_CHAR(EARLIEST_EXPEDITE_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(EARLIEST_EXPEDITE_DATE, 'YYYY-MM-DD')), "
        Else
            'backlog does not have the fields
            strSql = strSql & " NULL, NULL, NULL, NULL, NULL, "
        End If

        strSql = strSql & " DECODE(TO_CHAR(SCHEDULE_OFF_CREDIT_HOLD_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(SCHEDULE_OFF_CREDIT_HOLD_DATE, 'YYYY-MM-DD')), "
        strSql = strSql & " DECODE(TO_CHAR(TEMP_HOLD_ON_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(TEMP_HOLD_ON_DATE, 'YYYY-MM-DD')), "
        strSql = strSql & " DECODE(TO_CHAR(TEMP_HOLD_OFF_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(TEMP_HOLD_OFF_DATE, 'YYYY-MM-DD')), "
        strSql = strSql & " BUDGET_RATE_BOOK_BILL_AMT, "
        strSql = strSql & " NULL, " 'strSql = strSql & " FORCED_BILL_IND, "
        strSql = strSql & " CUSTOMER_TYPE_CODE, "
        strSql = strSql & " INDUSTRY_CODE, "
        strSql = strSql & " PRODUCT_BUSNS_LINE_FNCTN_ID, "
        strSql = strSql & " MFG_CAMPUS_ID, "
        strSql = strSql & " MFG_BUILDING_NBR, "
        strSql = strSql & " INDUSTRY_BUSINESS_CODE, "
        strSql = strSql & " PROFIT_CENTER_ABBR_NM, "
        'strSql = strSql & " CONTROLLER_UNIQUENESS_ID, "
        strSql = strSql & " INVENTORY_BUILDING_NBR, "
        strSql = strSql & " MFR_ORG_KEY_ID, "
        strSql = strSql & " PRODUCT_LINE_CODE, "
        strSql = strSql & " ACCOUNTING_ORG_KEY_ID "
        strSql = strSql & ",TO_CHAR(TYCO_CTRL_DELIVERY_HOLD_ON_DT, 'YYYY-MM-DD') "
        strSql = strSql & ",TO_CHAR(TYCO_CTRL_DELIVERY_HOLD_OFF_DT, 'YYYY-MM-DD') "
        strSql = strSql & ",DELIVERY_BLOCK_CDE "
        strSql = strSql & ",TYCO_CTRL_DELIVERY_BLOCK_CDE "
        strSql = strSql & ",PICK_PACK_WORK_DAYS_QTY "
        strSql = strSql & ",LOADING_NBR_OF_WORK_DAYS_QTY "
        strSql = strSql & ",TRSP_LEAD_TIME_DAYS_QTY "
        strSql = strSql & ",TRANSIT_TIME_DAYS_QTY "
        strSql = strSql & ",DECODE(TO_CHAR(SCHEDULE_ON_CREDIT_HOLD_DATE, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(SCHEDULE_ON_CREDIT_HOLD_DATE, 'YYYY-MM-DD')) "
        strSql = strSql & ",SOLD_TO_CUSTOMER_ID "
        strSql = strSql & ",NULL " 'strSql = strSql & ",DECODE(TO_CHAR(ITEM_BOOKED_DT, 'YYYY-MM-DD'),'0001-01-01','9999-99-99',TO_CHAR(ITEM_BOOKED_DT, 'YYYY-MM-DD')) "
        strSql = strSql & ",MRP_GROUP_CDE "
        strSql = strSql & ",COMPLETE_DELIVERY_IND "
        strSql = strSql & ",SBMT_PART_NBR "
        strSql = strSql & ",CREDIT_CHECK_STATUS_CDE "
        strSql = strSql & ",CUSTOMER_CREDIT_HOLD_IND "
        strSql = strSql & ",TO_CHAR(CUSTOMER_ON_CREDIT_HOLD_DATE, 'YYYY-MM-DD') CUSTOMER_ON_CREDIT_HOLD_DATE "
        strSql = strSql & ",TO_CHAR(CUSTOMER_OFF_CREDIT_HOLD_DATE, 'YYYY-MM-DD') CUSTOMER_OFF_CREDIT_HOLD_DATE "
        strSql = strSql & ",TO_CHAR(REQUESTED_ON_DOCK_DT, 'YYYY-MM-DD') REQUESTED_ON_DOCK_DT "
        strSql = strSql & ",TO_CHAR(SCHEDULED_ON_DOCK_DT, 'YYYY-MM-DD') SCHEDULED_ON_DOCK_DT "

        If vntOpenShipInd = "S" Then
            strSql = strSql & " FROM ORDER_ITEM_SHIPMENT a "
        Else
            strSql = strSql & " FROM ORDER_ITEM_OPEN a "
        End If

        strSql = strSql & " ,CORPORATE_PARTS b "
        strSql = strSql & " WHERE ORGANIZATION_KEY_ID = " & vntOrgKeyId
        strSql = strSql & " AND AMP_ORDER_NBR = '" & vntOrdNbr & "'"
        strSql = strSql & " AND ORDER_ITEM_NBR = '" & vntOrdItem & "'"
        strSql = strSql & " AND SHIPMENT_ID = '" & vntSchedId & "'"
        strSql = strSql & " AND a.PART_KEY_ID = b.PART_KEY_ID "

        objList = objCallRS.CallRS_WithConn(objConnection, strSql, vntCount, vntErrorNbr, vntErrorDesc)

        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsDetail.ListDetail call to CallRS for Schedule Detail Query")
        End If

        If vntCount = 1 Then
            vntTempArray = objList.GetRows

            ReDim vntArray(objList.Fields.Count + 10, 0)
            intCount = 0

            Do Until intCount = CShort(objList.Fields.Count)
                vntArray(intCount, 0) = vntTempArray(intCount, 0)
                intCount = intCount + 1
            Loop

            vntFldCnt = intCount

            If vntOpenShipInd = "S" Then
                vntOrgDt = vntArray(18, 0) 'Shipped Date
            Else
                vntOrgDt = vntArray(13, 0) 'Schedule Date
                If vntOrgDt = "9999-99-99" Then
                    vntOrgDt = "0001-01-01" 'revert to a valid unschedule date
                End If
            End If

            vntAcctOrg = vntArray(58, 0)
            vntCustNbr = vntArray(1, 0)
            vntIBC = vntArray(53, 0)
            vntMfgOrg = vntArray(56, 0)
            vntSoldToNbr = vntArray(68, 0)

            blnrc = objCallSP.CallSP_Out("scdDetail.procGetDetailData", lngErrorNbr, strErrorDesc, arrOutVar, "I", vntAcctOrg, "I", vntCustNbr, "I", vntOrgDt, "I", vntIBC, "I", vntMfgOrg, "I", vntSoldToNbr, "O", vntCustName, "O", vntIBCName, "O", vntMfgOrgLvl, "O", vntMfgOrgId, "O", vntMfgOrgAbbrn, "O", vntMfgPrntOrgLvl, "O", vntMfgPrntOrgId, "O", vntMfgPrntOrgAbbrn, "O", vntSoldToName)
            If Not blnrc Then
                Err.Raise(lngErrorNbr, , strErrorDesc & " Call to procedure scdDetail.procGetDetailData in clsDetail.ListDetail")
            End If

            vntCustName = arrOutVar(0)
            vntIBCName = arrOutVar(1)
            vntMfgOrgLvl = arrOutVar(2)
            vntMfgOrgId = arrOutVar(3)
            vntMfgOrgAbbrn = arrOutVar(4)
            vntMfgPrntOrgLvl = arrOutVar(5)
            vntMfgPrntOrgId = arrOutVar(6)
            vntMfgPrntOrgAbbrn = arrOutVar(7)
            vntSoldToName = arrOutVar(8)

            vntArray(intCount, 0) = vntCustName
            vntArray(intCount + 1, 0) = vntIBCName
            vntArray(intCount + 4, 0) = vntMfgOrgLvl
            vntArray(intCount + 5, 0) = vntMfgOrgId
            vntArray(intCount + 6, 0) = vntMfgOrgAbbrn
            vntArray(intCount + 7, 0) = vntMfgPrntOrgLvl
            vntArray(intCount + 8, 0) = vntMfgPrntOrgId
            vntArray(intCount + 9, 0) = vntMfgPrntOrgAbbrn
            vntArray(intCount + 10, 0) = vntSoldToName

            'Get Org Hierarchy

            strSql = " SELECT ORGANIZATION_TYPE_DESC, "
            strSql = strSql & " ORGANIZATION_ID, "
            strSql = strSql & " ORGANIZATION_ABBREVIATED_NM "
            strSql = strSql & " FROM ORGANIZATIONS_DMN "
            strSql = strSql & " START WITH ORGANIZATION_KEY_ID = " & vntOrgKeyId
            strSql = strSql & " AND TO_DATE('" & vntOrgDt & "','YYYY-MM-DD') BETWEEN EFFECTIVE_FROM_DT AND EFFECTIVE_TO_DT "
            strSql = strSql & " CONNECT BY ORGANIZATION_ID = PRIOR PARENT_ORGANIZATION_ID "
            strSql = strSql & " AND TO_DATE('" & vntOrgDt & "','YYYY-MM-DD') BETWEEN EFFECTIVE_FROM_DT AND EFFECTIVE_TO_DT "

            objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNbr, vntErrorDesc)

            If vntErrorNbr <> 0 Then
                Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsDetail.ListDetail call to CallRS for Org Hierarchy Query")
            End If

            If vntCount > 0 Then
                vntTempArray = objList
            Else
                'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                vntTempArray = System.DBNull.Value
            End If
            vntArray(intCount + 2, 0) = vntCount
            vntArray(intCount + 3, 0) = vntTempArray
            ListDetail = vntArray
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListDetail = System.DBNull.Value
        End If

        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If
        objConnection = Nothing

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
        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If
        objConnection = Nothing

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListDetail = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing

        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
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
End Class