Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsTop20Cust
    Inherits ServicedComponent
    'This class is for the Holiday parameter maint. screen.  It contains a list, insert, update and delete methods.

    '##ModelId=3A92962301BD
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A92992E01BF
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8C35F80014
    Public Function List(ByVal strBusiUnit As String, ByRef lngErrorNum As Object, ByRef strErrorDesc As Object) As Object
        On Error GoTo ErrorHandler
        List = vbNullString

        Dim objCallRS As New clsCallRS
        Dim lngErrorNumber As Long
        Dim objRS As Object
        Dim vntCount As Integer
        Dim strSql As String
        strSql = vbNullString
        Dim strErrWhere As String
        strErrWhere = " (clsTop20Cust.List)"

        strSql = " SELECT * FROM ( "

        ' for WW
        strSql = strSql & " SELECT tc.CUSTOMER_ORGANIZATION_KEY_ID"
        strSql = strSql & "       ,od.ORGANIZATION_ID"
        strSql = strSql & "       ,tc.CUSTOMER_ACCOUNT_ID"
        strSql = strSql & "       ,tc.REGION_ORGANIZATION_ID"
        strSql = strSql & "       ,od.ORGANIZATION_ID || ' - ' || od.ORGANIZATION_SHORT_NM org_nm"
        strSql = strSql & "       ,tc.CUSTOMER_ACCOUNT_ID || ' - ' || gcw.WW_CSTMR_NAME cust_nm"
        strSql = strSql & "       ,tc.ACCOUNT_TYPE_CDE"
        strSql = strSql & "       ,tc.DML_USER_ID"
        strSql = strSql & "       ,tc.DML_TS"
        strSql = strSql & " FROM   TOP_20_CUSTOMERS tc"
        strSql = strSql & "       ,ORGANIZATIONS_DMN od"
        strSql = strSql & "       ,GBL_CUSTOMER_WORLDWIDE_V gcw"
        strSql = strSql & " WHERE  tc.ACCOUNT_TYPE_CDE = 'WW'"
        strSql = strSql & " AND    tc.CUSTOMER_ACCOUNT_ID = gcw.WW_CSTMR_ACCT_NBR"
        strSql = strSql & " AND    od.ORGANIZATION_KEY_ID = tc.CUSTOMER_ORGANIZATION_KEY_ID"
        strSql = strSql & " AND    od.RECORD_STATUS_CDE   = 'C'"
        If strBusiUnit <> vbNullString Then
            strSql = strSql & " AND tc.PROFIT_CENTER_ABBR_NM = '" & strBusiUnit & "'"
        End If

        strSql = strSql & " UNION "

        ' for ship to
        strSql = strSql & " SELECT tc.CUSTOMER_ORGANIZATION_KEY_ID"
        strSql = strSql & "       ,od.ORGANIZATION_ID"
        strSql = strSql & "       ,tc.CUSTOMER_ACCOUNT_ID"
        strSql = strSql & "       ,tc.REGION_ORGANIZATION_ID"
        strSql = strSql & "       ,od.ORGANIZATION_ID || ' - ' || od.ORGANIZATION_SHORT_NM org_nm"
        strSql = strSql & "       ,tc.CUSTOMER_ACCOUNT_ID || ' - ' || shto.ST_NAME cust_nm"
        strSql = strSql & "       ,tc.ACCOUNT_TYPE_CDE"
        strSql = strSql & "       ,tc.DML_USER_ID"
        strSql = strSql & "       ,tc.DML_TS"
        strSql = strSql & " FROM   TOP_20_CUSTOMERS tc"
        strSql = strSql & "       ,ORGANIZATIONS_DMN od"
        strSql = strSql & "       ,GBL_CUSTOMER_SHIP_TO shto"
        strSql = strSql & " WHERE  tc.ACCOUNT_TYPE_CDE = 'SHIP TO'"
        strSql = strSql & " AND    tc.CUSTOMER_ACCOUNT_ID = shto.ST_ACCT_NBR_BASE||shto.ST_ACCT_NBR_SUFX "
        strSql = strSql & " AND    od.ORGANIZATION_ID     = shto.ST_ACCT_ORG_ID"
        strSql = strSql & " AND    od.ORGANIZATION_KEY_ID = tc.CUSTOMER_ORGANIZATION_KEY_ID"
        strSql = strSql & " AND    od.RECORD_STATUS_CDE   = 'C'"
        If strBusiUnit <> vbNullString Then
            strSql = strSql & " AND tc.PROFIT_CENTER_ABBR_NM = '" & strBusiUnit & "'"
        End If

        strSql = strSql & " UNION "

        ' for sold to
        strSql = strSql & " SELECT tc.CUSTOMER_ORGANIZATION_KEY_ID"
        strSql = strSql & "       ,od.ORGANIZATION_ID"
        strSql = strSql & "       ,tc.CUSTOMER_ACCOUNT_ID"
        strSql = strSql & "       ,tc.REGION_ORGANIZATION_ID"
        strSql = strSql & "       ,od.ORGANIZATION_ID || ' - ' || od.ORGANIZATION_SHORT_NM org_nm"
        strSql = strSql & "       ,tc.CUSTOMER_ACCOUNT_ID || ' - ' || sdto.PB_CSTMR_NAME cust_nm"
        strSql = strSql & "       ,tc.ACCOUNT_TYPE_CDE"
        strSql = strSql & "       ,tc.DML_USER_ID"
        strSql = strSql & "       ,tc.DML_TS"
        strSql = strSql & " FROM   TOP_20_CUSTOMERS tc"
        strSql = strSql & "       ,ORGANIZATIONS_DMN od"
        strSql = strSql & "       ,GBL_CUSTOMER_PURCHASED_BY sdto"
        strSql = strSql & " WHERE  tc.ACCOUNT_TYPE_CDE = 'SOLD TO'"
        strSql = strSql & " AND    tc.CUSTOMER_ACCOUNT_ID = sdto.PB_ACCT_NBR_BASE"
        strSql = strSql & " AND    od.ORGANIZATION_ID     = sdto.PB_ACCT_ORG_ID"
        strSql = strSql & " AND    od.ORGANIZATION_KEY_ID = tc.CUSTOMER_ORGANIZATION_KEY_ID"
        strSql = strSql & " AND    od.RECORD_STATUS_CDE   = 'C'"
        If strBusiUnit <> vbNullString Then
            strSql = strSql & " AND tc.PROFIT_CENTER_ABBR_NM = '" & strBusiUnit & "'"
        End If

        strSql = strSql & ") ORDER BY REGION_ORGANIZATION_ID, CUSTOMER_ACCOUNT_ID"

        objRS = objCallRS.CallRS_NoConn(strSql, vntCount, lngErrorNumber, strErrorDesc)

        If lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDesc)
        ElseIf vntCount > 0 Then
            List = objRS
        End If

        lngErrorNum = 0
        strErrorDesc = vbNullString
        Exit Function
ErrorHandler:

        objCallRS = Nothing
        List = vbNullString
        lngErrorNum = Err.Number
        strErrorDesc = Err.Description & strErrWhere
    End Function

    '##ModelId=3A8C36010224
    Public Function Insert(ByVal vntCustOrgKeyID As Object, ByVal vntCustAccntNbr As Object, ByVal vntCustType As Object, ByVal vntBusiUnit As Object, ByVal vntRegion As Object, ByVal vntUserID As Object, ByRef lngErrorNum As Object, ByRef strErrorDesc As Object) As Object

        On Error GoTo ErrorHandler
        Insert = False

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Long
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsTop20Cust.Insert)"

        blnrc = objCallSP.CallSP("scdTop20Cust.Insert_Top20Cust", _
            lngErrorNumber, strErrorDescription, _
            "I", vntCustAccntNbr, "I", vntCustType, "I", vntCustOrgKeyID, "I", vntBusiUnit, "I", vntRegion, "I", vntUserID)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        objCallSP = Nothing

        lngErrorNum = 0
        strErrorDesc = vbNullString
        Insert = blnrc

        Exit Function
ErrorHandler:
        objCallSP = Nothing
        Insert = False
        lngErrorNum = Err.Number
        strErrorDesc = Err.Description & strErrWhere
    End Function

    '##ModelId=3A8C361002DA
    Public Function Delete(ByVal vntCustOrgKeyID As Object, ByVal vntCustAccntNbr As Object, ByVal vntCustType As Object, ByVal vntBusiUnit As Object, ByVal vntRegion As Object, ByRef lngErrorNum As Object, ByRef strErrorDesc As Object) As Object
        On Error GoTo ErrorHandler
        Delete = False

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Long
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (scdTop20Cust.Delete)"

        blnrc = objCallSP.CallSP("scdTop20Cust.Delete_Top20Cust", lngErrorNumber, strErrorDescription, _
                    "I", vntCustAccntNbr, "I", vntCustType, "I", vntCustOrgKeyID, "I", vntBusiUnit, "I", vntRegion)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        objCallSP = Nothing

        lngErrorNum = 0
        strErrorDesc = vbNullString
        Delete = blnrc

        Exit Function
ErrorHandler:
        objCallSP = Nothing
        Delete = False
        lngErrorNum = Err.Number
        strErrorDesc = Err.Description & strErrWhere

    End Function

    '##ModelId=3A929D8F0244
    Protected Overrides Sub Activate()


        '## your code goes here...

    End Sub

    '##ModelId=3A929F0800F8
    Protected Overrides Function CanBePooled() As Boolean


        '## your code goes here...

    End Function

    '##ModelId=3A92A1BC00DE
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    '##ModelId=3AC1F5910344
    Public Sub Retrieve()
        On Error GoTo ErrorHandler

        '## your code goes here...

        Exit Sub
ErrorHandler:

    End Sub


    Public Function Validate(ByVal vntCustOrgKeyID As String, ByVal vntCustAccntNbr As String, ByVal vntCustType As String, ByVal vntBusiUnit As String, ByVal vntRegion As String, ByRef vntCustName As String, ByRef vntErrorNumber As Integer, ByRef vntErrorDesc As String) As Object
        'Public Function Validate(ByVal vntReportingOrg As String, ByVal vntBldgNbr As String, ByVal vntLocationCde As String, ByVal vntHolidayDt As String, ByVal lsAmpID As String, ByRef vntErrorNumber As Integer, ByRef vntErrorDesc As String) As Object
        On Error GoTo ErrorHandler
        Validate = False

        Dim strValid As String = ""
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(2) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Long
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsTop20Cust.Validate)"

        blnrc = objCallSP.CallSP_Out("scdTop20Cust.Validate_Top20Cust", _
            lngErrorNumber, strErrorDescription, _
            arrOutVar, "I", vntCustOrgKeyID, "I", vntCustAccntNbr, "I", vntCustType, "I", vntBusiUnit, _
            "I", vntRegion, "O", vntCustName, "O", strValid)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        objCallSP = Nothing
        vntCustName = arrOutVar(0)
        strValid = arrOutVar(1)

        If strValid = "F" Then
            vntErrorNumber = lngErrorNumber
            vntErrorDesc = strErrorDescription
            Validate = False
        Else
            vntErrorNumber = 0
            vntErrorDesc = vbNullString
            Validate = blnrc
        End If

        Exit Function
ErrorHandler:
        objCallSP = Nothing
        Validate = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function ListProfitCtr(ByVal strBusiUnit As String, ByRef lngErrorNum As Object, ByRef strErrorDesc As Object) As Object
        On Error GoTo ErrorHandler
        ListProfitCtr = vbNullString

        Dim lngErrorNumber As Long
        Dim objCallRS As New clsCallRS
        Dim objRS As Object
        'Dim objCallRS   As New clsCallRS
        'Dim objRS       As New clsCallRS
        Dim vntCount As Integer
        Dim strSql As String
        strSql = vbNullString
        Dim strErrWhere As String
        strErrWhere = " (clsTop20Cust.ListProfitCtr)"

        strSql = "          SELECT DISTINCT"
        strSql = strSql & "        pc.MGE_PROFIT_CENTER_ABBR_NM"
        strSql = strSql & "       ,pc.MGE_PROFIT_CENTER_DESC"
        strSql = strSql & " FROM   GBL_MGE_PROFIT_CENTERS pc"
        If strBusiUnit <> vbNullString Then
            strSql = strSql & " WHERE  pc.MGE_PROFIT_CENTER_ABBR_NM IN (" & strBusiUnit & ")"
        End If
        strSql = strSql & " ORDER BY pc.MGE_PROFIT_CENTER_DESC"

        objRS = objCallRS.CallRS_NoConn(strSql, vntCount, lngErrorNumber, strErrorDesc)

        If lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDesc)
        ElseIf vntCount > 0 Then
            ListProfitCtr = objRS
        End If

        lngErrorNum = 0
        strErrorDesc = vbNullString
        Exit Function
ErrorHandler:

        objCallRS = Nothing
        ListProfitCtr = vbNullString
        lngErrorNum = Err.Number
        strErrorDesc = Err.Description & strErrWhere

    End Function

    Public Function GetRowRestrictions(ByVal vntUserID As Object, ByRef vntBusiUnits As Object, ByRef lngErrorNum As Object, ByRef strErrorDesc As Object) As Object

        On Error GoTo ErrorHandler
        GetRowRestrictions = False

        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Long
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsTop20Cust.GetRowRestrictions)"

        blnrc = objCallSP.CallSP_Out("scdTop20Cust.GetRowRestrictions", _
            lngErrorNumber, strErrorDescription, _
            arrOutVar, "I", vntUserID, "O", vntBusiUnits)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        objCallSP = Nothing
        vntBusiUnits = arrOutVar(0)

        lngErrorNum = 0
        strErrorDesc = vbNullString
        GetRowRestrictions = blnrc

        Exit Function
ErrorHandler:
        objCallSP = Nothing
        GetRowRestrictions = False
        lngErrorNum = Err.Number
        strErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function ListRegOrgIds(ByVal vntRegOrgID As String, ByVal vntOrgType As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        strSql = "select so.ORGANIZATION_KEY_ID as KEYID, "
        strSql = strSql & "so.ORGANIZATION_TYPE_ID TYPEID, "
        strSql = strSql & "so.ORGANIZATION_ID ORGID, "
        strSql = strSql & "so.ORGANIZATION_SHORT_NM ORGNAME "
        strSql = strSql & "FROM  SCORECARD_ORGANIZATIONS so "
        strSql = strSql & "     ,ORGANIZATIONS_DMN od "
        strSql = strSql & " WHERE so.ORGANIZATION_KEY_ID = od.ORGANIZATION_KEY_ID "
        strSql = strSql & " AND   od.RECORD_STATUS_CDE = 'C'"
        If vntRegOrgID <> "" Then
            strSql = strSql & " AND   od.REGION_ORGANIZATION_ID = '" & vntRegOrgID & "'"
        End If
        If vntOrgType <> "" Then
            strSql = strSql & " AND ORGANIZATION_TYPE_ID = " & vntOrgType
        End If
        strSql = strSql & " ORDER BY so.ORGANIZATION_ID "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CLng(vntErrorNumber), , vntErrorDesc & " in clsTop20Cust.ListRegOrgIds call to CallRS for Org Ids Query")
        End If

        If vntCount > 0 Then
            'objList.Sort = "ORGID ASC"
            vntArray = objList
        Else
            vntArray = System.DBNull.Value
        End If

        Dim inxRow As Long
        Dim inxOrgID As Integer
        inxOrgID = 2
        Dim inxDesc As Integer
        inxDesc = 3

        If IsArray(vntArray) Then
            'Put Org ID in Description
            For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
                vntArray(inxDesc, inxRow) = vntArray(inxOrgID, inxRow) & " - " & vntArray(inxDesc, inxRow)
            Next
        End If

        ListRegOrgIds = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""

        objCallRS = Nothing
        objList = Nothing

        Exit Function
ErrorHandler:
        ListRegOrgIds = Nothing
        objCallRS = Nothing
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    Public Function ListRegOrgIds2(ByVal vntRegOrgID As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        strSql = "select DISTINCT so.ORGANIZATION_KEY_ID as KEYID, "
        strSql = strSql & "so.ORGANIZATION_TYPE_ID TYPEID, "
        strSql = strSql & "so.ORGANIZATION_ID ORGID, "
        strSql = strSql & "so.ORGANIZATION_SHORT_NM ORGNAME "
        strSql = strSql & "FROM  SCORECARD_ORGANIZATIONS so "
        strSql = strSql & "     ,ORGANIZATIONS_DMN od "
        strSql = strSql & "     ,GBL_SHIP_TO_ACCT_ORG st "
        strSql = strSql & " WHERE so.ORGANIZATION_KEY_ID = od.ORGANIZATION_KEY_ID "
        strSql = strSql & " AND   od.RECORD_STATUS_CDE = 'C'"
        strSql = strSql & " AND    od.ORGANIZATION_ID =st.ORG_ID "
        If vntRegOrgID <> "" Then
            strSql = strSql & " AND   od.REGION_ORGANIZATION_ID = '" & vntRegOrgID & "'"
        End If
        strSql = strSql & " ORDER BY so.ORGANIZATION_ID "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CLng(vntErrorNumber), , vntErrorDesc & " in clsTop20Cust.ListRegOrgIds call to CallRS for Org Ids Query")
        End If

        If vntCount > 0 Then
            vntArray = objList
        Else
            vntArray = System.DBNull.Value
        End If

        Dim inxRow As Long
        Dim inxOrgID As Integer
        inxOrgID = 2
        Dim inxDesc As Integer
        inxDesc = 3

        If IsArray(vntArray) Then
            'Put Org ID in Description
            For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
                vntArray(inxDesc, inxRow) = vntArray(inxOrgID, inxRow) & " - " & vntArray(inxDesc, inxRow)
            Next
        End If

        ListRegOrgIds2 = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""

        objCallRS = Nothing
        objList = Nothing

        Exit Function
ErrorHandler:
        ListRegOrgIds2 = Nothing
        objCallRS = Nothing
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function
End Class