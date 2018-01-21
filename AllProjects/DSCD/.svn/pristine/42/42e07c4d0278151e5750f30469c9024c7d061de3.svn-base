Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsCodeApplXref
    Inherits ServicedComponent

    '##ModelId=3ABF4E3203BB
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3ABF4E55038D
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3ABF4E740037
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF4E8900D7
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3ABF4EA2020B
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF4EB30205
    Public Function Retrieve() As Boolean
        On Error GoTo ErrorHandler

        '## your code goes here...

        Exit Function
ErrorHandler:

    End Function

    Public Function InvOrgPlantList(ByVal vntOrgID As String, ByVal vntInvOrgPlant As Object, ByVal vntDescription As Object, ByVal vntExactMatch As Object, ByRef vntSQL As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objRecordset As Object
        Dim strSql As String
        Dim strWhere As String
        Dim strWhere2 As String = ""
        Dim strInvOrgPlant As String
        Dim strDescription As String
        Dim vntCount As Object = 0
        Dim blnrc As Object
        Dim objOrgs As New clsOrgs
        Dim vntLevel As String = ""

        On Error GoTo List_Error

        If vntOrgID = "" Then
            Err.Raise(100, , "Org ID is not passed in clsCodeAppXref.InvOrgPlantList")
        End If

        blnrc = objOrgs.RetrieveLevel(vntOrgID, "C", "", vntLevel, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing

        If Not blnrc Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " In call to clsOrgs.RetrieveLevel from clsCodeAppXref.InvOrgPlantList")
        End If

        If Len(vntLevel) > 6 Then
            vntLevel = Right(vntLevel, 2)
        Else
            vntLevel = Right(vntLevel, 1)
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntInvOrgPlant) Then
            strInvOrgPlant = ""
        Else
            strInvOrgPlant = Trim(CStr(vntInvOrgPlant))
        End If
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntDescription) Then
            strDescription = ""
        Else
            strDescription = Trim(CStr(vntDescription))
        End If

        'build SQL for SAP sourced data
        strSql = "SELECT DISTINCT cax.GENERIC_CDE_1 As InvOrgPlant , "
        strSql = strSql & " p.PLANT_NM As Description, "
        strSql = strSql & " 'Plant' As InvOrgOrPlant "
        strSql = strSql & " FROM SCD_CODE_APPL_XREF cax, "
        strSql = strSql & " ORGANIZATIONS_DMN od, "
        strSql = strSql & " PLANTS p"
        strWhere = " WHERE cax.SOURCE_SYSTEM_ID IN (1,3) " 'SAP sourced data
        strWhere = strWhere & " AND cax.CODE_TYPE_SHORT_NM = 'CONTROLLER' "
        strWhere = strWhere & " AND od.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        strWhere = strWhere & " AND od.ORGANIZATION_KEY_ID = cax.ORGANIZATION_KEY_ID "
        strWhere = strWhere & " AND od.RECORD_STATUS_CDE = 'C' "
        strWhere = strWhere & " AND p.PLANT_ID (+) = cax.GENERIC_CDE_1 "

        If Len(strInvOrgPlant) > 0 Then
            If vntExactMatch = "0" Then
                strWhere2 = " AND cax.GENERIC_CDE_1 Like '" & strInvOrgPlant & "%'"
            Else
                strWhere2 = " AND cax.GENERIC_CDE_1 = '" & strInvOrgPlant & "'"
            End If
        End If

        If Len(strDescription) > 0 Then
            If vntExactMatch = "0" Then
                strWhere2 = strWhere2 & " AND Upper(p.PLANT_NM) Like upper('%" & strDescription & "%')"
            Else
                strWhere2 = strWhere2 & " AND Upper(p.PLANT_NM) = upper('" & strDescription & "')"
            End If
        End If

        strSql = strSql & strWhere & strWhere2

        vntSQL = strSql & " UNION "

        'build SQL for non-SAP sourced data
        strSql = "SELECT DISTINCT cax.GENERIC_CDE_1 As InvOrgPlant , "
        strSql = strSql & " g.GO_SHORT_NAME As Description, "
        strSql = strSql & " 'Org' As InvOrgOrPlant "
        strSql = strSql & " FROM SCD_CODE_APPL_XREF cax, "
        strSql = strSql & " ORGANIZATIONS_DMN od, "
        strSql = strSql & " GBL_ORGS g"
        strWhere = " WHERE cax.SOURCE_SYSTEM_ID NOT IN (1,3) " 'non-SAP sourced data
        strWhere = strWhere & " AND cax.CODE_TYPE_SHORT_NM = 'CONTROLLER' "
        strWhere = strWhere & " AND od.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        strWhere = strWhere & " AND od.ORGANIZATION_KEY_ID = cax.ORGANIZATION_KEY_ID "
        strWhere = strWhere & " AND od.RECORD_STATUS_CDE = 'C' "
        strWhere = strWhere & " AND g.GO_ORG_ID (+) = cax.GENERIC_CDE_1 "

        strWhere2 = ""
        If Len(strInvOrgPlant) > 0 Then
            If vntExactMatch = "0" Then
                strWhere2 = " AND cax.GENERIC_CDE_1 Like '" & strInvOrgPlant & "%'"
            Else
                strWhere2 = " AND cax.GENERIC_CDE_1 = '" & strInvOrgPlant & "'"
            End If
        End If

        If Len(strDescription) > 0 Then
            If vntExactMatch = "0" Then
                strWhere2 = strWhere2 & " AND Upper(g.GO_SHORT_NAME) Like upper('%" & strDescription & "%')"
            Else
                strWhere2 = strWhere2 & " AND Upper(g.GO_SHORT_NAME) = upper('" & strDescription & "')"
            End If
        End If

        strSql = strSql & strWhere & strWhere2

        vntSQL = vntSQL & strSql

        objRecordset = objCallRS.CallRS_NoConn(vntSQL, vntCount, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " in clsCodeApplXref.InvOrgPlantList call to CallRS for Inv Org/Plant Query")
        End If

        If vntCount > 0 Then
            InvOrgPlantList = objRecordset
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            InvOrgPlantList = System.DBNull.Value
        End If

        vntErrorNumber = 0
        vntErrorDescription = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRecordset may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRecordset = Nothing
        Exit Function

List_Error:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        InvOrgPlantList = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description
        Exit Function
    End Function

    Public Function ControllerList(ByVal vntOrgID As String, ByVal vntInvOrgPlant As String, ByVal vntController As String, ByVal vntDescription As String, ByVal vntExactMatch As String, ByRef vntSQL As String, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objRecordset As Object
        Dim strSql As String
        Dim strWhere As String = ""
        Dim strWhere2 As String = ""
        Dim strController As String
        Dim strDescription As String
        Dim vntCount As Long = 0
        Dim blnrc As Object
        Dim objOrgs As New clsOrgs
        Dim objResults As Object
        Dim vntLevel As String = ""

        On Error GoTo List_Error

        If vntOrgID = "" Then
            Err.Raise(100, , "Org ID is not passed in clsCodeAppXref.ControllerList")
        End If

        If vntInvOrgPlant = "" Then
            Err.Raise(100, , "Inv Org/Plant is not passed in clsCodeAppXref.ControllerList")
        End If

        blnrc = objOrgs.RetrieveLevel(vntOrgID, "C", "", vntLevel, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing

        If Not blnrc Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " In call to clsOrgs.RetrieveLevel from clsCodeAppXref.ControllerList")
        End If

        If Len(vntLevel) > 6 Then
            vntLevel = Right(vntLevel, 2)
        Else

            vntLevel = Right(vntLevel, 1)
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntController) Then
            strController = ""
        Else
            strController = Trim(CStr(vntController))
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntDescription) Then
            strDescription = ""
        Else

            strDescription = Trim(CStr(vntDescription))
        End If

        'build SQL
        strSql = "SELECT DISTINCT cax.GENERIC_CDE_2 As Controller "
        strSql = strSql & " ,cax.GENERIC_CDE_1 As InvOrgPlant "
        strSql = strSql & " FROM SCD_CODE_APPL_XREF cax, "
        strSql = strSql & " ORGANIZATIONS_DMN od "
        strWhere = " WHERE cax.GENERIC_CDE_2 != '*' " 'exclude asterisk
        strWhere = strWhere & " AND cax.GENERIC_CDE_1 IN ( " & QuoteStr(vntInvOrgPlant) & " ) "
        strWhere = strWhere & " AND cax.CODE_TYPE_SHORT_NM = 'CONTROLLER' "
        strWhere = strWhere & " AND od.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        strWhere = strWhere & " AND od.ORGANIZATION_KEY_ID = cax.ORGANIZATION_KEY_ID "
        strWhere = strWhere & " AND od.RECORD_STATUS_CDE = 'C' "

        If Len(strController) > 0 Then
            If vntExactMatch = "0" Then
                strWhere2 = " AND cax.GENERIC_CDE_2 Like '" & strController & "%'"
            Else
                strWhere2 = " AND cax.GENERIC_CDE_2 = '" & strController & "'"
            End If
        End If

        vntSQL = strSql & strWhere & strWhere2 & " ORDER BY 2,1 "

        objRecordset = objCallRS.CallRS_NoConn(vntSQL, vntCount, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " in clsCodeApplXref.ControllerList call to CallRS for Controller Query")
        End If

        If vntCount > 0 Then
            ControllerList = objRecordset
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ControllerList = System.DBNull.Value
        End If

        vntErrorNumber = 0
        vntErrorDescription = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRecordset may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRecordset = Nothing
        Exit Function

List_Error:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ControllerList = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description
        Exit Function
    End Function

    Public Function MrpGroupList(ByVal vntOrgID As String, ByVal vntMrpGroup As String, ByVal vntDescription As String, ByVal vntExactMatch As String, ByRef vntSQL As String, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objRecordset As Object
        Dim strSql As String = ""
        Dim strWhere As String = ""
        Dim strWhere2 As String = ""
        Dim strMrpGroup As String
        Dim strDescription As String
        Dim vntCount As Object = 0
        Dim blnrc As Object
        Dim objOrgs As New clsOrgs
        Dim vntLevel As String = ""

        On Error GoTo List_Error

        If vntOrgID = "" Then
            Err.Raise(100, , "Org ID is not passed in clsCodeAppXref.MrpGroupList")
        End If

        blnrc = objOrgs.RetrieveLevel(vntOrgID, "C", "", vntLevel, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing

        If Not blnrc Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " In call to clsOrgs.RetrieveLevel from clsCodeAppXref.MrpGroupList")
        End If

        If Len(vntLevel) > 6 Then
            vntLevel = Right(vntLevel, 2)
        Else
            vntLevel = Right(vntLevel, 1)
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntMrpGroup) Then
            strMrpGroup = ""
        Else
            strMrpGroup = Trim(CStr(vntMrpGroup))
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntDescription) Then
            strDescription = ""
        Else
            strDescription = Trim(CStr(vntDescription))
        End If

        'build SQL
        strSql = "SELECT DISTINCT cax.GENERIC_CDE_1 As MrpGroup "
        strSql = strSql & " ,mc.CODE_NM As Description "
        strSql = strSql & " FROM SCD_CODE_APPL_XREF cax "
        strSql = strSql & " ,ORGANIZATIONS_DMN od "
        strSql = strSql & " ,MASTER_CODEs mc "
        strWhere = " WHERE cax.CODE_TYPE_SHORT_NM = 'MRPGROUP' "
        strWhere = strWhere & " AND cax.GENERIC_CDE_1 Like 'Z%' "
        strWhere = strWhere & " AND od.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        strWhere = strWhere & " AND od.ORGANIZATION_KEY_ID = cax.ORGANIZATION_KEY_ID "
        strWhere = strWhere & " AND od.RECORD_STATUS_CDE = 'C' "
        strWhere = strWhere & " AND mc.SOURCE_SYSTEM_ID (+) = 1 "
        strWhere = strWhere & " AND mc.GENERAL_CDE (+) = cax.GENERIC_CDE_1 "
        strWhere = strWhere & " AND mc.CODE_TYPE_ID (+) = 4 "

        If Len(strMrpGroup) > 0 Then
            If vntExactMatch = "0" Then
                strWhere2 = " AND cax.GENERIC_CDE_1 Like '" & strMrpGroup & "%'"
            Else
                strWhere2 = " AND cax.GENERIC_CDE_1 = '" & strMrpGroup & "'"
            End If
        End If

        If Len(strDescription) > 0 Then
            If vntExactMatch = "0" Then
                strWhere2 = strWhere2 & " AND Upper(mc.CODE_NM) Like upper('%" & strDescription & "%')"
            Else
                strWhere2 = strWhere2 & " AND Upper(mc.CODE_NM) = upper('" & strDescription & "')"
            End If
        End If

        vntSQL = strSql & strWhere & strWhere2

        objRecordset = objCallRS.CallRS_NoConn(vntSQL, vntCount, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " in clsCodeApplXref.MrpGroupList call to CallRS for Mrp Group Query")
        End If

        If vntCount > 0 Then
            MrpGroupList = objRecordset
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            MrpGroupList = System.DBNull.Value
        End If

        vntErrorNumber = 0
        vntErrorDescription = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRecordset may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRecordset = Nothing
        Exit Function

List_Error:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        MrpGroupList = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description
        Exit Function
    End Function

    Public Function SalesOfficeList(ByVal vntOrgID As String, ByVal vntSalesOffice As String, ByVal vntDescription As String, ByVal vntExactMatch As String, ByRef vntSQL As String, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objRecordset As Object
        Dim strSql As String
        Dim strWhere As String
        Dim strWhere2 As String = ""
        Dim strSalesOffice As String
        Dim strDescription As String
        Dim vntCount As Object = 0
        Dim blnrc As Object
        Dim objOrgs As New clsOrgs
        Dim vntLevel As String = ""

        On Error GoTo List_Error

        If vntOrgID = "" Then
            Err.Raise(100, , "Org ID is not passed in clsCodeAppXref.SalesOfficeList")
        End If

        blnrc = objOrgs.RetrieveLevel(vntOrgID, "C", "", vntLevel, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing

        If Not blnrc Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " In call to clsOrgs.RetrieveLevel from clsCodeAppXref.SalesOfficeList")
        End If

        If Len(vntLevel) > 6 Then
            vntLevel = Right(vntLevel, 2)
        Else
            vntLevel = Right(vntLevel, 1)
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntSalesOffice) Then
            strSalesOffice = ""
        Else
            strSalesOffice = Trim(CStr(vntSalesOffice))
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntDescription) Then
            strDescription = ""
        Else

            strDescription = Trim(CStr(vntDescription))
        End If

        'build SQL
        strSql = "SELECT DISTINCT cax.GENERIC_CDE_1 As SalesOffice "
        strSql = strSql & " ,mc.CODE_NM As Description "
        strSql = strSql & " FROM SCD_CODE_APPL_XREF cax "
        strSql = strSql & " ,ORGANIZATIONS_DMN od "
        strSql = strSql & " ,MASTER_CODES mc "
        strWhere = " WHERE cax.CODE_TYPE_SHORT_NM = 'SALESGROUP' "

        If InStr(strSalesOffice, "*") = 0 Then
            ' don't include if not entered as actual param
            strWhere = strWhere & " AND cax.GENERIC_CDE_1 != '*' "
        End If

        strWhere = strWhere & " AND od.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        strWhere = strWhere & " AND od.ORGANIZATION_KEY_ID = cax.ORGANIZATION_KEY_ID "
        strWhere = strWhere & " AND od.RECORD_STATUS_CDE = 'C' "
        strWhere = strWhere & " AND mc.SOURCE_SYSTEM_ID (+) = 1 "
        strWhere = strWhere & " AND mc.GENERAL_CDE (+) = cax.GENERIC_CDE_1 "
        strWhere = strWhere & " AND mc.CODE_TYPE_ID (+) = 9 "

        If Len(strSalesOffice) > 0 Then

            If vntExactMatch = "0" Then
                strWhere2 = " AND cax.GENERIC_CDE_1 Like '" & strSalesOffice & "%'"
            Else
                strWhere2 = " AND cax.GENERIC_CDE_1 = '" & strSalesOffice & "'"
            End If
        End If

        If Len(strDescription) > 0 Then

            If vntExactMatch = "0" Then
                strWhere2 = strWhere2 & " AND Upper(mc.CODE_NM) Like upper('%" & strDescription & "%')"
            Else
                strWhere2 = strWhere2 & " AND Upper(mc.CODE_NM) = upper('" & strDescription & "')"
            End If
        End If

        vntSQL = strSql & strWhere & strWhere2

        objRecordset = objCallRS.CallRS_NoConn(vntSQL, vntCount, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " in clsCodeApplXref.SalesOfficeList call to CallRS for Sales Office Query")
        End If

        If vntCount > 0 Then
            SalesOfficeList = objRecordset
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            SalesOfficeList = System.DBNull.Value
        End If

        vntErrorNumber = 0
        vntErrorDescription = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRecordset may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRecordset = Nothing
        Exit Function

List_Error:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        SalesOfficeList = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description
        Exit Function
    End Function

    Public Function SalesGroupList(ByVal vntOrgID As String, ByVal vntSalesOffice As String, ByVal vntSalesGroup As String, ByVal vntDescription As String, ByVal vntExactMatch As String, ByRef vntSQL As String, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objRecordset As Object
        Dim strSql As String
        Dim strWhere As String
        Dim strWhere2 As String = ""
        Dim strSalesGroup As String
        Dim strDescription As String
        Dim vntCount As Object = 0
        Dim blnrc As Object
        Dim objOrgs As New clsOrgs
        Dim objResults As Object
        Dim vntLevel As String = ""
        Dim strTemp As String

        On Error GoTo List_Error

        If vntOrgID = "" Then
            Err.Raise(100, , "Org ID is not passed in clsCodeAppXref.SalesGroupList")
        End If

        If vntSalesOffice = "" Then
            Err.Raise(100, , "Sales Office is not passed in clsCodeAppXref.SalesGroupList")
        End If

        blnrc = objOrgs.RetrieveLevel(vntOrgID, "C", "", vntLevel, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objOrgs may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objOrgs = Nothing

        If Not blnrc Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " In call to clsOrgs.RetrieveLevel from clsCodeAppXref.SalesGroupList")
        End If

        If Len(vntLevel) > 6 Then
            vntLevel = Right(vntLevel, 2)
        Else
            vntLevel = Right(vntLevel, 1)
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntSalesGroup) Then
            strSalesGroup = ""
        Else

            strSalesGroup = Trim(CStr(vntSalesGroup))
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntDescription) Then
            strDescription = ""
        Else
            strDescription = Trim(CStr(vntDescription))
        End If

        'build SQL
        strSql = "SELECT DISTINCT cax.GENERIC_CDE_1 SalesOffice, cax.GENERIC_CDE_2 As SalesGroup "
        strSql = strSql & " ,mc.CODE_NM As Description "
        strSql = strSql & " FROM SCD_CODE_APPL_XREF cax "
        strSql = strSql & " ,ORGANIZATIONS_DMN od "
        strSql = strSql & " ,MASTER_CODES mc "
        strWhere = " WHERE cax.CODE_TYPE_SHORT_NM = 'SALESGROUP' "
        strWhere = strWhere & " AND cax.GENERIC_CDE_1 IN ( " & QuoteStr(vntSalesOffice) & " ) "
        strWhere = strWhere & " AND cax.GENERIC_CDE_2 != '*' " 'exclude asterisk
        strWhere = strWhere & " AND od.LAYER" & vntLevel & "_ORGANIZATION_ID = '" & vntOrgID & "' "
        strWhere = strWhere & " AND od.ORGANIZATION_KEY_ID = cax.ORGANIZATION_KEY_ID "
        strWhere = strWhere & " AND od.RECORD_STATUS_CDE = 'C' "
        strWhere = strWhere & " AND mc.SOURCE_SYSTEM_ID (+) = 1 "
        strWhere = strWhere & " AND mc.GENERAL_CDE (+) = cax.GENERIC_CDE_2 "
        strWhere = strWhere & " AND mc.CODE_TYPE_ID (+) = 10 "

        If Len(strSalesGroup) > 0 Then
            If vntExactMatch = "0" Then
                strWhere2 = " AND cax.GENERIC_CDE_2 Like '" & strSalesGroup & "%'"
            Else
                strWhere2 = " AND cax.GENERIC_CDE_2 = '" & strSalesGroup & "'"
            End If
        End If

        If Len(strDescription) > 0 Then
            If vntExactMatch = "0" Then
                strWhere2 = strWhere2 & " AND Upper(mc.CODE_NM) Like upper('%" & strDescription & "%')"
            Else
                strWhere2 = strWhere2 & " AND Upper(mc.CODE_NM) = upper('" & strDescription & "')"
            End If
        End If

        vntSQL = strSql & strWhere & strWhere2 & " ORDER BY 1,2 "

        objRecordset = objCallRS.CallRS_NoConn(vntSQL, vntCount, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " in clsCodeApplXref.SalesGroupList call to CallRS for Sales Group Query")
        End If

        If vntCount > 0 Then
            SalesGroupList = objRecordset
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            SalesGroupList = System.DBNull.Value
        End If

        vntErrorNumber = 0
        vntErrorDescription = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRecordset may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRecordset = Nothing
        Exit Function

List_Error:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        SalesGroupList = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description
        Exit Function
    End Function

    Private Function QuoteStr(ByVal vntInput As Object) As Object

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
End Class