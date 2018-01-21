Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsCallRS
    Inherits ServicedComponent
    'This class is used in the creation of all recordsets.
    'This class should only be used for queries that create more than one record.
    'The sql needed should be generated in the calling class and the sql string should be passed to it.  Database connectivity will be handled by this class.

    '##ModelId=3A9292B4029B
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A9292D9028C
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8BF47200AB
    Public Function CallRS(ByVal strSql As Object, ByRef vntCount As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim objConnection As New ADODB.Connection
        Dim objRecordset As ADODB.Recordset
        Dim objServer As New DSCD.clsServerInfo
        Dim strDSN As String = ""
        Dim strUserID As String = ""
        Dim strPassword As String = ""
        Dim testsql As String
        Dim testcount As Integer

        On Error GoTo ErrorHandler

        If objConnectionGbl.State = ConnectionState.Closed Then
            If Not objServer.Get_Connection_Info(strDSN, strUserID, strPassword) Then
                'UPGRADE_NOTE: Object objServer may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
                objServer = Nothing
                Err.Raise(-1, , "Error retrieving Server Info")
            End If
            'UPGRADE_NOTE: Object objServer may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objServer = Nothing
            objConnectionGbl.Open(strDSN, strUserID, strPassword)
        End If

        objRecordset = CreateObject("ADODB.Recordset")

        objRecordset.CursorLocation = ADODB.CursorLocationEnum.adUseClient

        objRecordset.Open(strSql, objConnectionGbl, ADODB.CursorTypeEnum.adOpenStatic)

        CallRS = objRecordset

        vntCount = objRecordset.RecordCount

        If objRecordset.RecordCount > 0 Then
            objRecordset.MoveLast()
            objRecordset.MoveFirst()
        End If

        'UPGRADE_NOTE: Object objRecordset may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRecordset = Nothing
        'UPGRADE_NOTE: Object objConnection may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objConnection = Nothing
        vntErrorNumber = 0
        vntErrorDescription = ""
        Exit Function

ErrorHandler:
        If objConnectionGbl.State = ConnectionState.Open Then
            objConnectionGbl.Close()
        End If
        'UPGRADE_NOTE: Object CallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        CallRS = Nothing
        'UPGRADE_NOTE: Object objRecordset may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRecordset = Nothing
        'UPGRADE_NOTE: Object objConnection may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objConnection = Nothing
        objServer = Nothing
        vntCount = -1
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description
        Exit Function
    End Function

    '##ModelId=3A9292F9033D
    Protected Overrides Sub Activate()

        'UPGRADE_ISSUE: COMSVCSLib.AppServer  .GetObjectContext was not upgraded. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="CC4C7EC0-C903-48FC-ACCC-81861D12DA4A"'
        'ObjContext = GetObjectContext

    End Sub

    '##ModelId=3A92930D03AE
    Protected Overrides Function CanBePooled() As Boolean

        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3A92932D02AF
    Protected Overrides Sub Deactivate()

        'UPGRADE_NOTE: Object ObjContext may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        ObjContext = Nothing

    End Sub

    Public Function CallRS_NoConn(ByVal strSql As Object, ByRef vntCount As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim objConnection As New ADODB.Connection
        Dim objRecordset As ADODB.Recordset
        Dim objServer As New DSCD.clsServerInfo
        Dim strDSN As String = ""
        Dim strUserID As String = ""
        Dim strPassword As String = ""
        Dim testsql As String
        Dim testcount As Integer
        Dim strwhere As String = ""

        On Error GoTo ErrorHandler

        If Not objServer.Get_Connection_Info(strDSN, strUserID, strPassword) Then
            objServer = Nothing
            Err.Raise(-1, , "Error retrieving Server Info")
        End If
        objServer = Nothing

        objConnection = CreateObject("ADODB.Connection")
        objConnection.Open(strDSN, strUserID, strPassword)

        objRecordset = CreateObject("ADODB.Recordset")
        objRecordset.CursorLocation = ADODB.CursorLocationEnum.adUseClient
        objRecordset.Open(strSql, objConnection, ADODB.CursorTypeEnum.adOpenStatic)

        vntCount = objRecordset.RecordCount
        If vntCount > 0 Then
            CallRS_NoConn = objRecordset.GetRows()
        Else
            CallRS_NoConn = System.DBNull.Value
        End If

        objConnection.Close()

        objRecordset = Nothing
        objConnection = Nothing

        vntErrorNumber = 0
        vntErrorDescription = ""

        Exit Function

ErrorHandler:
        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If

        CallRS_NoConn = Nothing
        objRecordset = Nothing
        objConnection = Nothing
        objServer = Nothing

        vntCount = -1
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description & strwhere

        Exit Function
    End Function

    Public Function CallRS_WithConn(ByRef objConnection As Object, ByVal strSql As Object, ByRef vntCount As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim objRecordset As ADODB.Recordset
        Dim objServer As New DSCD.clsServerInfo
        Dim strDSN As String = ""
        Dim strUserID As String = ""
        Dim strPassword As String = ""
        Dim testsql As String
        Dim testcount As Integer
        Dim strwhere As String = ""

        On Error GoTo ErrorHandler

        If Not objServer.Get_Connection_Info(strDSN, strUserID, strPassword) Then
            objServer = Nothing
            Err.Raise(-1, , "Error retrieving Server Info")
        End If
        objServer = Nothing

        objConnection = CreateObject("ADODB.Connection")
        objConnection.Open(strDSN, strUserID, strPassword)

        objRecordset = CreateObject("ADODB.Recordset")
        objRecordset.CursorLocation = ADODB.CursorLocationEnum.adUseClient
        objRecordset.Open(strSql, objConnection, ADODB.CursorTypeEnum.adOpenStatic)

        CallRS_WithConn = objRecordset

        vntCount = CallRS_WithConn.RecordCount
        If vntCount > 0 Then
            CallRS_WithConn.MoveLast()
            CallRS_WithConn.MoveFirst()
        End If

        vntErrorNumber = 0
        vntErrorDescription = ""

        objRecordset = Nothing
        Exit Function

ErrorHandler:
        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If

        CallRS_WithConn = Nothing
        objRecordset = Nothing
        objServer = Nothing

        vntCount = -1
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description & strwhere

        Exit Function
    End Function
End Class