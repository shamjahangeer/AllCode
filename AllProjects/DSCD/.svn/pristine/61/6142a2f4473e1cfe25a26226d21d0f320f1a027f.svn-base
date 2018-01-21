Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsReqParms
    Inherits ServicedComponent

    '##ModelId=3A9297000055
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A929A53022A
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8C34BB0358
    Public Function List(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        List = vbNullString

        Dim objCallRS As New clsCallRS
        Dim objRS As Object
        Dim vntCount As Object = 0

        Dim strErrWhere As String
        strErrWhere = " (clsReqParms.List)"

        Dim strSql As String
        strSql = "SELECT PARAMETER_ID, PARAMETER_FIELD, PARAMETER_DESCRIPTION, DML_ORACLE_ID" & ", TO_CHAR(DML_TMSTMP, 'YYYY-MM-DD') " & "FROM   DELIVERY_PARAMETER_LOCAL " & "WHERE  PARAMETER_UPDATE_TYPE = '2' AND PARAMETER_ID NOT LIKE '%UPD' " & "ORDER BY PARAMETER_ID"

        objRS = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)
        If vntErrorNumber <> 0 Then
            Err.Raise(vntErrorNumber, , vntErrorDesc)
        ElseIf vntCount > 0 Then
            List = objRS
        End If

        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        List = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    '##ModelId=3A8C34C302B9
    Public Function Update(ByVal vntParamID As String, ByVal vntParamValue As String, ByVal vntUserID As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean
        Update = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsReqParms.Update)"

        On Error GoTo Update_ErrorHandler

        If vntParamID = "" Then
            Err.Raise(100, , "Parameter ID can not be null in clsReqParms.Update (in parameter check)")
        End If

        If vntUserID = "" Then
            Err.Raise(100, , "User ID can not be null in clsReqParms.Update (in parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdParameter.UpdateParamLocal", lngErrorNumber, strErrorDescription, "I", vntParamID, "I", vntParamValue, "I", vntUserID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Update = blnrc
        Exit Function

Update_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Update = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    'UPGRADE_NOTE: Class_Initialize was upgraded to Class_Initialize_Renamed. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
    Private Sub Class_Initialize_Renamed()

    End Sub

    Public Sub New()
        MyBase.New()
        Class_Initialize_Renamed()
    End Sub

    '##ModelId=3A929E070212
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3A929FA20045
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3A92A231018C
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    '##ModelId=3AC1F54A02D2
    Public Function Add(ByVal vntParamID As String, ByVal vntParamDesc As String, ByVal vntParamValue As String, ByVal vntParamType As String, ByVal vntUserID As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        Add = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsReqParms.Add)"

        On Error GoTo Add_ErrorHandler

        If vntParamID = "" Then
            Err.Raise(100, , "Parameter ID can not be null in clsReqParms.Add (in parameter check)")
        End If

        If vntParamDesc = "" Then
            Err.Raise(100, , "Parameter Desc can not be null in clsReqParms.Add (in parameter check)")
        End If

        If vntParamType = "" Then
            Err.Raise(100, , "Parameter Type can not be null in clsReqParms.Add (in parameter check)")
        End If

        If vntUserID = "" Then
            Err.Raise(100, , "User ID can not be null in clsReqParms.Add (in parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdParameter.AddParamLocal", lngErrorNumber, strErrorDescription, "I", vntParamID, "I", vntParamDesc, "I", vntParamValue, "I", vntParamType, "I", vntUserID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Add = blnrc
        Exit Function

Add_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Add = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function
End Class