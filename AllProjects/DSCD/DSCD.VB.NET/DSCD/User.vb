Option Strict Off
Option Explicit On
Imports System.EnterpriseServices
Imports DSCD
<Transaction(TransactionOption.Disabled)> _
Public Class clsUser
    Inherits ServicedComponent


    '###############################################
    '              Variable Declarations
    '###############################################

    '##ModelId=3A9297D8014B
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A929AA00117
    Private ObjContext As System.EnterpriseServices.ContextUtil

    Private G_ROLES_ARRAY As Object

    '###############################################
    '              Class Methods
    '###############################################
    'UPGRADE_NOTE: Class_Initialize was upgraded to Class_Initialize_Renamed. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
    Private Sub Class_Initialize_Renamed()
        Dim vntErrorNumber As Object = ""
        Dim vntErrorDesc As Object = ""
        ReDim G_ROLES_ARRAY(1, 1)
        GenRolesArray(G_ROLES_ARRAY, vntErrorNumber, vntErrorDesc)
    End Sub
    Public Sub New()
        MyBase.New()
        Class_Initialize_Renamed()
    End Sub


    'UPGRADE_NOTE: Class_Terminate was upgraded to Class_Terminate_Renamed. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
    Private Sub Class_Terminate_Renamed()

        Erase G_ROLES_ARRAY

    End Sub
    Protected Overrides Sub Finalize()
        Class_Terminate_Renamed()
        MyBase.Finalize()
    End Sub


    Private Function GenRolesArray(ByRef vntTempArray As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        On Error GoTo GenRolesArray_Error

        GenRolesArray = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim strErrWhere As Object
        strErrWhere = " (clsUser.GenRolesArray)"

        'This is the default list of current DSCD Roles
        'This is maintained in CSS Security

        vntTempArray(0, 0) = "SCORECARD_INQUIRY_ROLE"
        vntTempArray(0, 1) = "Inquiry"
        vntTempArray(1, 0) = "SCORECARD_LOCAL_UPDATE_ROLE"
        vntTempArray(1, 1) = "LocalUpdate"

        GenRolesArray = True
        Exit Function

GenRolesArray_Error:
        GenRolesArray = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function


    Private Function GetCSSRoleName(ByVal vntDSCDRole As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        On Error GoTo GetCSSRoleName_Error

        GetCSSRoleName = vbNullString
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim vntCSSRole As Object = ""
        Dim intLoopy As Short
        Dim strErrWhere As String
        strErrWhere = " (clsUser.GetCSSRoleName)"

        If IsArray(G_ROLES_ARRAY) Then
            For intLoopy = LBound(G_ROLES_ARRAY) To UBound(G_ROLES_ARRAY)
                If vntDSCDRole = G_ROLES_ARRAY(intLoopy, 1) Then vntCSSRole = G_ROLES_ARRAY(intLoopy, 0)
            Next
            GetCSSRoleName = vntCSSRole
        Else
            Err.Raise(-1, , "Roles Array Not Available")
        End If
        Exit Function

GetCSSRoleName_Error:
        GetCSSRoleName = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Private Function GetDSCDRoleName(ByVal vntCSSRole As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        On Error GoTo GetDSCDRoleName_Error

        GetDSCDRoleName = vbNullString
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim vntDSCDRole As Object = ""
        Dim intLoopy As Short
        Dim strErrWhere As String
        strErrWhere = " (clsUser.GetDSCDRoleName)"

        If IsArray(G_ROLES_ARRAY) Then
            For intLoopy = LBound(G_ROLES_ARRAY) To UBound(G_ROLES_ARRAY)
                If vntCSSRole = G_ROLES_ARRAY(intLoopy, 0) Then vntDSCDRole = G_ROLES_ARRAY(intLoopy, 1)
            Next
            GetDSCDRoleName = vntDSCDRole
        Else
            Err.Raise(-1, , "Roles Array Not Available")
        End If
        Exit Function

GetDSCDRoleName_Error:
        GetDSCDRoleName = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function VerifyUserRole(ByVal lsUserID As String, ByVal lsRoleType As String) As Boolean
        Dim loConnection As New ADODB.Connection
        Dim loCommand As New ADODB.Command
        Dim loServer As New clsServerInfo
        Dim lsDSN As String = ""
        Dim lsLogonID As String = ""
        Dim lsPassword As String = ""

        On Error GoTo VerifyUserRole_Error

        If Not loServer.Get_Connection_Info(lsDSN, lsLogonID, lsPassword) Then
            'UPGRADE_NOTE: Object loServer may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            loServer = Nothing
            Err.Raise(0)
        End If
        'UPGRADE_NOTE: Object loServer may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        loServer = Nothing

        'loConnection = CreateObject("ADODB.Connection")
        loConnection.Open(lsDSN, lsLogonID, lsPassword)
        'loCommand = CreateObject("ADODB.Command")
        With loCommand
            .ActiveConnection = loConnection
            .CommandType = ADODB.CommandTypeEnum.adCmdStoredProc
            .CommandText = "verify_user_role"
            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamInput, 2000, Trim(lsUserID)))
            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamInput, 2000, Trim(UCase(lsRoleType))))
            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamOutput, 2000))
            .Execute()
            If UCase(Trim(.Parameters(2).Value)) = "AUTHORIZED" Then
                VerifyUserRole = True
            Else
                VerifyUserRole = False
            End If
        End With

        'UPGRADE_NOTE: Object loCommand may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        loCommand = Nothing
        loConnection.Close()
        'UPGRADE_NOTE: Object loConnection may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        loConnection = Nothing
        Exit Function

VerifyUserRole_Error:
        'UPGRADE_NOTE: Object loCommand may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        loCommand = Nothing
        If loConnection.State = ConnectionState.Open Then
            loConnection.Close()
        End If
        'UPGRADE_NOTE: Object loConnection may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        loConnection = Nothing
        VerifyUserRole = False
        Exit Function

    End Function

    '##ModelId=3A8BF91500B2
    Public Function ListUserRoles(ByVal vntLoginID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        On Error GoTo ListUserRoles_Error

        ListUserRoles = vbNullString
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim lngErrorNumber As Integer
        Dim strErrorDesc As String = ""
        Dim blnrc As Boolean
        Dim intLoopy As Short
        Dim strLoginID As String
        Dim strRolesList As String = ""
        Dim vntRolesArray As Object
        Dim vntTempArray As Object
        Dim strErrWhere As String
        strErrWhere = " (clsUser.ListUserRoles)"

        strLoginID = Trim(vntLoginID)
        If strLoginID = vbNullString Then
            Err.Raise(-1, , "Invalid Login ID")
        End If

        blnrc = objCallSP.CallSP_Out("scdUser.List_User_Roles", lngErrorNumber, strErrorDesc, arrOutVar, "I", strLoginID, "O", strRolesList)
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        If lngErrorNumber <> 0 Then Err.Raise(lngErrorNumber, , strErrorDesc)

        strRolesList = arrOutVar(0)
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If Not IsDBNull(strRolesList) Then
            vntRolesArray = Split(strRolesList, ",")
            If UBound(vntRolesArray) >= 0 Then
                ReDim vntTempArray(UBound(vntRolesArray), 2)
                For intLoopy = LBound(vntRolesArray) To UBound(vntRolesArray)
                    vntTempArray(intLoopy, 0) = vntRolesArray(intLoopy)
                    vntTempArray(intLoopy, 1) = GetDSCDRoleName(vntRolesArray(intLoopy), vntErrorNumber, vntErrorDesc)
                    vntTempArray(intLoopy, 2) = True
                Next
                ListUserRoles = vntTempArray
            End If
        End If
        Exit Function

ListUserRoles_Error:
        ListUserRoles = vbNullString
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    '##ModelId=3A929E5F001C
    Protected Overrides Sub Activate()

        ' Figure out what our current transaction context (contained) is.

        'UPGRADE_ISSUE: COMSVCSLib.AppServer  .GetObjectContext was not upgraded. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="CC4C7EC0-C903-48FC-ACCC-81861D12DA4A"'
        'ObjContext = GetObjectContext

    End Sub

    '##ModelId=3A92A09D00B0
    Protected Overrides Function CanBePooled() As Boolean

        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3A92A2870188
    Protected Overrides Sub Deactivate()

        ' here, we clean up the AMP standard global context instance
        'UPGRADE_NOTE: Object ObjContext may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        ObjContext = Nothing

    End Sub

    '##ModelId=3A94225002D8
    Public Function UpdateProfile(ByVal vntGlobalID As String, ByVal vntAmpID As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        UpdateProfile = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsUser.UpdateProfile)"

        On Error GoTo UpdateProfile_ErrorHandler

        If vntGlobalID = "" Then
            Err.Raise(100, , "Assoc global ID can not be null in clsUser.UpdateProfile (In parameter check)")
        End If

        If vntAmpID = "" Then
            Err.Raise(100, , "Network user ID can not be null in clsUser.UpdateProfile (In parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdUser.UpdateProfile", lngErrorNumber, strErrorDescription, "I", vntGlobalID, "I", vntAmpID)

        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        UpdateProfile = blnrc
        Exit Function

UpdateProfile_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        UpdateProfile = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    Public Function GetExcelSeq(ByRef vntSeqId As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        On Error GoTo ErrorHandler

        blnrc = objCallSP.CallSP_Out("scdCommon.RetExcelSeq", lngErrorNumber, strErrorDescription, arrOutVar, "O", vntSeqId)
        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetExcelSeq in clsUser.GetExcelSeq")
        End If
        vntSeqId = arrOutVar(0)

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = ""
        GetExcelSeq = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        GetExcelSeq = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    Public Function UpdatePreference(ByVal vntGlobalID As Object, ByVal vntAmpID As Object, ByVal vntDaysEarly As Object, ByVal vntDaysLate As Object, ByVal vntSmryType As Object, ByVal vntOrgTypeId As Object, ByVal vntOrgId As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        UpdatePreference = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsUser.UpdatePreference)"

        On Error GoTo UpdatePreference_ErrorHandler

        If vntGlobalID = "" Then
            Err.Raise(100, , "Assoc global ID can not be null in clsUser.UpdatePreference (In parameter check)")
        End If

        If vntAmpID = "" Then
            Err.Raise(100, , "Network user ID can not be null in clsUser.UpdatePreference (In parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdUser.UpdatePreference", lngErrorNumber, strErrorDescription, "I", vntGlobalID, "I", vntAmpID, "I", vntDaysEarly, "I", vntDaysLate, "I", vntSmryType, "I", vntOrgTypeId, "I", vntOrgId)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        UpdatePreference = blnrc
        Exit Function

UpdatePreference_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        UpdatePreference = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    Public Function GetPreference(ByVal vntGlobalID As Object, ByRef vntDaysEarly As Object, ByRef vntDaysLate As Object, ByRef vntSmryType As Object, ByRef vntOrgTypeId As Object, ByRef vntOrgId As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        GetPreference = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim arrOutVar(5) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsUser.GetPreference)"

        On Error GoTo GetPreference_ErrorHandler

        If vntGlobalID = "" Then
            Err.Raise(100, , "Assoc global ID can not be null in clsUser.GetPreference (In parameter check)")
        End If

        blnrc = objCallSP.CallSP_Out("scdUser.GetPreference", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntGlobalID, "O", vntDaysEarly, "O", vntDaysLate, "O", vntSmryType, "O", vntOrgTypeId, "O", vntOrgId)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        vntDaysEarly = arrOutVar(0)
        vntDaysLate = arrOutVar(1)
        vntSmryType = arrOutVar(2)
        vntOrgTypeId = arrOutVar(3)
        vntOrgId = arrOutVar(4)

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        GetPreference = blnrc
        Exit Function

GetPreference_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        GetPreference = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    Public Function GetCorpDefault(ByRef vntDaysEarly As Object, ByRef vntDaysLate As Object, ByRef vntSmryType As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        GetCorpDefault = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim arrOutVar(3) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsUser.GetCorpDefault)"

        On Error GoTo GetCorpDefault_ErrorHandler

        blnrc = objCallSP.CallSP_Out("scdUser.GetCorpDefault", lngErrorNumber, strErrorDescription, arrOutVar, "O", vntDaysEarly, "O", vntDaysLate, "O", vntSmryType)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        vntDaysEarly = arrOutVar(0)
        vntDaysLate = arrOutVar(1)
        vntSmryType = arrOutVar(2)

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        GetCorpDefault = blnrc
        Exit Function

GetCorpDefault_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        GetCorpDefault = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    Public Function GetGlobalID(ByVal vntNetworkID As Object, ByRef vntAppGlobalID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        On Error GoTo GetGlobalID_Err

        GetGlobalID = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsUser.GetGlobalID)"

        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntNetworkID) Or vntNetworkID = vbNullString Then
            Err.Raise(-1, , "Missing Network ID")
        End If

        blnrc = objCallSP.CallSP_Out("scdUser.GetGlobalID", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntNetworkID, "O", vntAppGlobalID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        vntAppGlobalID = arrOutVar(0)

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        GetGlobalID = True
        Exit Function

GetGlobalID_Err:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        GetGlobalID = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    Public Function UpdateOrgIDPref(ByVal vntGlobalID As Object, ByVal vntAmpID As Object, ByVal vntOrgTypeId As Object, ByVal vntOrgId As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        UpdateOrgIDPref = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsUser.UpdateOrgIDPref)"

        On Error GoTo UpdateOrgIDPref_ErrorHandler

        If vntGlobalID = "" Then
            Err.Raise(100, , "Assoc global ID can not be null in clsUser.UpdateOrgIDPref (In parameter check)")
        End If

        If vntAmpID = "" Then
            Err.Raise(100, , "Network user ID can not be null in clsUser.UpdateOrgIDPref (In parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdUser.UpdateOrgIDPref", lngErrorNumber, strErrorDescription, "I", vntGlobalID, "I", vntAmpID, "I", vntOrgTypeId, "I", vntOrgId)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        UpdateOrgIDPref = blnrc
        Exit Function

UpdateOrgIDPref_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        UpdateOrgIDPref = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function
End Class