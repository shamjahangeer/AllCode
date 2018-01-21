Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsOrgs
    Inherits ServicedComponent

    '##ModelId=3A9296A70119
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A929A2F0329
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8BF8CD02FA
    Public Function ListType(ByVal vntErrorNumber As Object, ByVal vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0

        On Error GoTo ErrorHandler

        strSql = "select ORGANIZATION_TYPE_ID as TYPEID, "
        strSql = strSql & "ORGANIZATION_TYPE_DESC TYPEDESC  "
        strSql = strSql & "FROM SCORECARD_ORG_TYPES "
        strSql = strSql & "ORDER BY TYPEDESC ASC "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsTemplate.ListOrgs call to CallRS for Org Types Query")
        End If

        If vntCount > 0 Then
            'objList.Sort = "TYPEDESC ASC"
            ListType = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListType = System.DBNull.Value
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
        ListType = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    '##ModelId=3A8BF8D60235
    Public Function ListOrgIds(ByVal vntOrgType As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        strSql = "select ORGANIZATION_KEY_ID as KEYID, "
        strSql = strSql & "ORGANIZATION_TYPE_ID TYPEID, "
        strSql = strSql & "ORGANIZATION_ID ORGID, "
        strSql = strSql & "ORGANIZATION_SHORT_NM ORGNAME "
        strSql = strSql & "FROM SCORECARD_ORGANIZATIONS "

        If vntOrgType <> "" Then

            strSql = strSql & "WHERE ORGANIZATION_TYPE_ID = " & vntOrgType
        End If
        strSql = strSql & "ORDER BY ORGID ASC "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsOrgs.ListOrgIds call to CallRS for Org Ids Query")
        End If

        If vntCount > 0 Then
            'objList.Sort = "ORGID ASC"
            vntArray = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            vntArray = System.DBNull.Value
        End If

        Dim inxRow As Integer
        Dim inxOrgID As Short
        inxOrgID = 2
        Dim inxDesc As Short
        inxDesc = 3

        If IsArray(vntArray) Then
            'Put Org ID in Description
            For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
                vntArray(inxDesc, inxRow) = vntArray(inxOrgID, inxRow) & " - " & vntArray(inxDesc, inxRow)
            Next
        End If

        ListOrgIds = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListOrgIds = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & "from err handler="
        Exit Function
    End Function

    '##ModelId=3A8BF8D60235
    Public Function ListOrgCodes(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        strSql = "select b.ISO_LEGACY_PREFERRED_ORG_CDE OrgCde, "
        strSql = strSql & "b.ORGANIZATION_TYPE_DESC OrgType, "
        strSql = strSql & "b.ORGANIZATION_ID OrgId, "
        strSql = strSql & "b.ORGANIZATION_SHORT_NM OrgName, "
        strSql = strSql & "a.ORGANIZATION_TYPE_ID OrgTypeID "
        strSql = strSql & "FROM ORGANIZATIONS_DMN b, SCORECARD_ORGANIZATIONS a "
        strSql = strSql & "WHERE b.ORGANIZATION_ID = a.ORGANIZATION_ID "
        strSql = strSql & "AND b.EFFECTIVE_TO_DT = (SELECT MAX(EFFECTIVE_TO_DT) "
        strSql = strSql & "                         FROM ORGANIZATIONS_DMN c "
        strSql = strSql & "                         WHERE b.ORGANIZATION_ID = c.ORGANIZATION_ID "
        strSql = strSql & "                         AND c.ORGANIZATION_STATUS_CDE = '1') "
        strSql = strSql & "ORDER BY nvl(OrgCde,' '),3 "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsOrgs.ListOrgCodes call to CallRS for Org Codes Query")
        End If

        If vntCount > 0 Then
            'objList.Sort = "OrgCde ASC"
            ListOrgCodes = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListOrgCodes = System.DBNull.Value
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
        ListOrgCodes = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    '##ModelId=3A929DE2007B
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3A929F6E00DF
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...
        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3A92A2140096
    Protected Overrides Sub Deactivate()

        '## your code goes here...
        ObjContext = Nothing

    End Sub

    Public Function RetrieveLevel(ByVal vntOrgID As String, ByVal vntCurrHistInd As String, ByVal vntOrgDt As String, ByRef vntLevel As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        On Error GoTo ErrorHandler

        If vntOrgID = "" Or vntCurrHistInd = "" Then
            Err.Raise(100, , "All Variables were not passed in clsOrgs.RetrieveLevel")
        End If

        If vntCurrHistInd = "H" And vntOrgDt = "" Then
            Err.Raise(100, , "Org Date was not passed in clsOrgs.RetrieveLevel")
        End If

        blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveOrgLevel", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntOrgID, "I", vntCurrHistInd, "I", vntOrgDt, "O", vntLevel)
        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetrieveOrgLevel in clsOrgs.RetrieveLevel")
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntLevel = arrOutVar(0)
        vntErrorNumber = 0
        vntErrorDesc = ""
        RetrieveLevel = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveLevel = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    Public Function RetrieveOrgKeyId(ByVal vntOrgID As String, ByVal vntCurrHistInd As String, ByVal vntOrgDt As String, ByRef vntOrgKeyId As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        On Error GoTo ErrorHandler

        If vntOrgID = "" Or vntCurrHistInd = "" Then
            Err.Raise(100, , "All variable were not passed in clsOrgs.RetrieveOrgKeyId")
        End If

        If vntCurrHistInd = "H" And vntOrgDt = "" Then
            Err.Raise(100, , "Org Date was not passed in clsOrgs.RetrieveOrgKeyId")
        End If

        blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveOrgKeyId", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntOrgID, "I", vntCurrHistInd, "I", vntOrgDt, "O", vntOrgKeyId)
        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetrieveOrgKeyId in clsOrgs.RetrieveOrgKeyId")
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntOrgKeyId = arrOutVar(0)
        vntErrorNumber = 0
        vntErrorDesc = ""
        RetrieveOrgKeyId = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveOrgKeyId = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    Public Function ListAcctOrgIds(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        strSql = "select distinct a.ORGANIZATION_KEY_ID, "
        strSql = strSql & "a.ORGANIZATION_ID, "
        strSql = strSql & "a.ORGANIZATION_SHORT_NM "
        strSql = strSql & "from GBL_SHIP_TO_ACCT_ORG b, "
        strSql = strSql & " SCORECARD_ORGANIZATIONS a "
        strSql = strSql & "where a.ORGANIZATION_ID = b.ORG_ID"
        strSql = strSql & " ORDER BY ORGANIZATION_ID ASC "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsOrgs.ListAcctOrgIds call to CallRS for Acct Org Query")
        End If

        If vntCount > 0 Then
            'objList.Sort = "ORGANIZATION_ID ASC"
            vntArray = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            vntArray = System.DBNull.Value
        End If

        Dim inxRow As Integer
        Dim inxOrgID As Short
        inxOrgID = 1
        Dim inxDesc As Short
        inxDesc = 2

        If IsArray(vntArray) Then
            'Put Org ID in Description
            For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
                vntArray(inxDesc, inxRow) = vntArray(inxOrgID, inxRow) & " - " & vntArray(inxDesc, inxRow)
            Next
        End If

        ListAcctOrgIds = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListAcctOrgIds = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    Public Function RetrieveNameAbbrn(ByVal vntOrgKeyId As Object, ByVal vntCurrHistInd As Object, ByVal vntOrgDt As Object, ByRef vntNameAbbrn As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        On Error GoTo ErrorHandler

        If vntOrgKeyId = "" Or vntCurrHistInd = "" Then
            Err.Raise(100, , "All variables were not passed in clsOrgs.RetrieveNameAbbrn")
        End If

        If vntCurrHistInd = "H" And vntOrgDt = "" Then
            Err.Raise(100, , "Org Date was not passed in clsOrgs.RetrieveNameAbbrn")
        End If

        blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveOrgNameAbbrn", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntOrgKeyId, "I", vntCurrHistInd, "I", vntOrgDt, "O", vntNameAbbrn)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetrieveOrgNameAbbrn in clsOrgs.RetrieveNameAbbrn")
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntNameAbbrn = arrOutVar(0)
        vntErrorNumber = 0
        vntErrorDesc = ""
        RetrieveNameAbbrn = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveNameAbbrn = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    Public Function RetrieveType(ByVal vntOrgType As Object, ByRef vntOrgTypeDesc As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        On Error GoTo ErrorHandler

        If vntOrgType = "" Then
            Err.Raise(100, , "An Org Type Id was not passed to clsOrgs.RetrieveType")
        End If

        blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveOrgType", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntOrgType, "O", vntOrgTypeDesc)
        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetrieveOrgType in clsOrgs.RetrieveType")
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntOrgTypeDesc = arrOutVar(0)
        vntErrorNumber = 0
        vntErrorDesc = ""
        RetrieveType = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveType = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    Public Function ListHostOrgIDs(ByVal vntErrorNumber As Object, ByVal vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0

        On Error GoTo ErrorHandler

        strSql = ""
        strSql = strSql & " SELECT * FROM ("
        strSql = strSql & " SELECT ORGANIZATION_ID"
        strSql = strSql & "       ,d.ORGANIZATION_SHORT_NM||' ('||e.GO_PREFERRED_ACCT_ORG_CODE||')' Org_Name"
        strSql = strSql & "   FROM (SELECT DISTINCT PROD_HOST_ORG_ID"
        strSql = strSql & "           FROM GBL_PRODUCT) a"
        strSql = strSql & "       ,ORGANIZATIONS_DMN d"
        strSql = strSql & "       ,GBL_ORGS e"
        strSql = strSql & "  WHERE a.PROD_HOST_ORG_ID = d.ORGANIZATION_ID"
        strSql = strSql & "    AND d.RECORD_STATUS_CDE = 'C'"
        strSql = strSql & "    AND d.ORGANIZATION_ID   = e.GO_ORG_ID"
        strSql = strSql & "    AND LENGTH(RTRIM(e.GO_PREFERRED_ACCT_ORG_CODE)) < 4"
        strSql = strSql & " UNION"
        strSql = strSql & " SELECT PARENT_ORGANIZATION_ID"
        strSql = strSql & "       ,d.PARENT_ORGANIZATION_NM||' ('||e.GO_PREFERRED_ACCT_ORG_CODE||')' Org_Name"
        strSql = strSql & "   FROM (SELECT DISTINCT PROD_HOST_ORG_ID"
        strSql = strSql & "           FROM GBL_PRODUCT) a"
        strSql = strSql & "       ,ORGANIZATIONS_DMN d"
        strSql = strSql & "       ,GBL_ORGS e"
        strSql = strSql & "  WHERE a.PROD_HOST_ORG_ID = d.ORGANIZATION_ID"
        strSql = strSql & "    AND d.RECORD_STATUS_CDE = 'C'"
        strSql = strSql & "    AND d.PARENT_ORGANIZATION_ID = e.GO_ORG_ID"
        strSql = strSql & "    AND EXISTS (SELECT 1"
        strSql = strSql & "                  FROM GBL_PRODUCT b"
        strSql = strSql & "                      ,GBL_ORGS f"
        strSql = strSql & "                 WHERE b.PROD_HOST_ORG_ID = f.GO_ORG_ID"
        strSql = strSql & "                   AND a.PROD_HOST_ORG_ID = f.GO_ORG_ID"
        strSql = strSql & "                   AND LENGTH(RTRIM(f.GO_PREFERRED_ACCT_ORG_CODE)) = 4)"
        strSql = strSql & " ) ORDER BY Org_Name ASC "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsOrgs.ListHostOrgIDs call to clsCallRS")
        End If

        If vntCount > 0 Then
            'objList.Sort = "Org_Name ASC"
            ListHostOrgIDs = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListHostOrgIDs = System.DBNull.Value
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
        ListHostOrgIDs = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    Public Function ProdHostOrgIDList(ByRef vntSQL As Object, ByVal vntErrorNumber As Object, ByVal vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0

        On Error GoTo ErrorHandler

        strSql = ""
        strSql = strSql & " SELECT * FROM ("
        strSql = strSql & " SELECT go1.GO_ORG_ID org_id"
        strSql = strSql & "       ,go1.GO_SHORT_NAME org_nm"
        strSql = strSql & "       ,go1.GO_PREFERRED_ACCT_ORG_CODE org_cde"
        strSql = strSql & " FROM   GBL_ORGS go1"
        strSql = strSql & "       ,(SELECT GO_ORG_ID"
        strSql = strSql & "         FROM   (SELECT DISTINCT PROD_HOST_ORG_ID"
        strSql = strSql & "                 FROM   GBL_PRODUCT) gp1"
        strSql = strSql & "               ,GBL_ORGS go2"
        strSql = strSql & "         WHERE  gp1.PROD_HOST_ORG_ID = go2.GO_ORG_ID"
        strSql = strSql & "         AND    LENGTH(RTRIM(go2.GO_PREFERRED_ACCT_ORG_CODE)) < 4"
        strSql = strSql & "         UNION"
        strSql = strSql & "         SELECT PARENT_ORGANIZATION_ID"
        strSql = strSql & "         FROM   (SELECT DISTINCT PROD_HOST_ORG_ID"
        strSql = strSql & "                 FROM   GBL_PRODUCT) gp2"
        strSql = strSql & "               ,ORGANIZATIONS_DMN od"
        strSql = strSql & "         WHERE  gp2.PROD_HOST_ORG_ID = od.ORGANIZATION_ID"
        strSql = strSql & "         AND    od.RECORD_STATUS_CDE = 'C'"
        strSql = strSql & "         AND EXISTS (SELECT 1"
        strSql = strSql & "                     FROM   GBL_PRODUCT gp3"
        strSql = strSql & "                           ,GBL_ORGS go3"
        strSql = strSql & "                     WHERE  gp2.PROD_HOST_ORG_ID = go3.GO_ORG_ID"
        strSql = strSql & "                     AND    gp3.PROD_HOST_ORG_ID = go3.GO_ORG_ID"
        strSql = strSql & "                     AND    LENGTH(RTRIM(go3.GO_PREFERRED_ACCT_ORG_CODE)) = 4)"
        strSql = strSql & "        ) go4"
        strSql = strSql & " WHERE  go1.GO_ORG_ID = go4.GO_ORG_ID"
        strSql = strSql & " ) ORDER BY org_cde ASC "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        vntSQL = strSql

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsOrgs.ProdHostOrgIDList call to clsCallRS")
        End If

        If vntCount > 0 Then
            'objList.Sort = "org_cde ASC"
            ProdHostOrgIDList = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ProdHostOrgIDList = System.DBNull.Value
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
        ProdHostOrgIDList = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function
End Class