Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsCallSP
    Inherits ServicedComponent
    'This class is used in the creation of all interaction between the COM components and stored procedures.  Stored procedures should not be passing back cursors but only handle single record retrieval, inserts, updates and deletes.
    '
    'Parameters are dipicted by an I, O , IL, and OL.
    '
    'IL and OL should be used for return items that are greater than a varchar2(250).

    '##ModelId=3A9293610099
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A9293820368
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8BF4CD029B
    'UPGRADE_WARNING: ParamArray vntArgs was changed from ByRef to ByVal. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="93C6A0DC-8C99-429A-8696-35FC4DCEFCCC"'
    Public Function CallSP(ByVal strProcedureName As String, ByRef lngErrorNumber As Integer, ByRef strErrorDescription As String, ByVal ParamArray vntArgs() As Object) As Boolean

        Dim objConnection As New ADODB.Connection
        Dim objCommand As New ADODB.Command
        Dim objServer As New clsServerInfo
        Dim strDSN As String = ""
        Dim strUserID As String = ""
        Dim strPassword As String = ""
        Dim intCount As Short
        Dim intCount2 As Short
        Dim intInputParams As Short
        Dim intOutputParams As Short
        Dim intAllParams As Short
        Dim strErrNum As String
        Dim strErrWhere As String
        strErrWhere = " (clsCallSP.CallSP)"

        On Error GoTo ErrorHandler_ConnectionClosed

        'If objConnectionGbl.State = ConnectionState.Closed Then

        If Not objServer.Get_Connection_Info(strDSN, strUserID, strPassword) Then
            'UPGRADE_NOTE: Object objServer may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
            objServer = Nothing
            Err.Raise(0)
        End If
        'UPGRADE_NOTE: Object objServer may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objServer = Nothing

        'objConnection = CreateObject("ADODB.Connection")
        'objConnection.Open(strDSN, strUserID, strPassword)
        On Error GoTo ErrorHandler_ConnectionOpen
        'objConnectionGbl.Open(strDSN, strUserID, strPassword)
        objConnection.Open(strDSN, strUserID, strPassword)
        'End If
        'objCommand = CreateObject("ADODB.Command")

        With objCommand
            '.ActiveConnection = objConnectionGbl
            .ActiveConnection = objConnection
            .CommandType = ADODB.CommandTypeEnum.adCmdStoredProc
            .CommandText = Trim(strProcedureName)
            intInputParams = 0
            intOutputParams = 0
            intAllParams = (UBound(vntArgs, 1) + 1) \ 2
            For intCount = 0 To intAllParams - 1
                If UCase(vntArgs(intCount * 2)) = "I" Or UCase(vntArgs(intCount * 2)) = "IL" Then
                    intInputParams = intInputParams + 1
                    If UCase(vntArgs(intCount * 2)) = "I" Then
                        If vntArgs(intCount * 2 + 1) = Nothing Then
                            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamInput, 2000, ""))
                        Else
                            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamInput, 2000, CStr(vntArgs(intCount * 2 + 1))))
                        End If
                    Else
                        If vntArgs(intCount * 2 + 1) = Nothing Then
                            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adLongVarChar, ADODB.ParameterDirectionEnum.adParamInput, 4000, ""))
                        Else
                            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adLongVarChar, ADODB.ParameterDirectionEnum.adParamInput, 4000, CStr(vntArgs(intCount * 2 + 1))))
                        End If
                    End If
                Else
                    intOutputParams = intOutputParams + 1
                    If UCase(vntArgs(intCount * 2)) = "O" Then
                        .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamOutput, 2000))
                    Else
                        .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adLongVarChar, ADODB.ParameterDirectionEnum.adParamOutput, 4000))
                    End If
                End If
            Next
            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamOutput, 2000))
            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamOutput, 2000))
            .Execute()

            If Trim(.Parameters(intAllParams).Value) = "0" Then
                CallSP = True
                lngErrorNumber = 0
                strErrorDescription = ""
                intCount2 = intAllParams - intOutputParams
                For intCount = 0 To intOutputParams - 1
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(.Parameters(intCount2).Value) Then
                        vntArgs((intInputParams * 2 + 1) + (intCount * 2)) = ""
                    Else
                        vntArgs((intInputParams * 2 + 1) + (intCount * 2)) = Trim(.Parameters(intCount2).Value)
                    End If
                    intCount2 = intCount2 + 1
                Next
            Else
                CallSP = False
                lngErrorNumber = CInt(Trim(.Parameters(intAllParams).Value))
                strErrorDescription = Trim(.Parameters(intAllParams + 1).Value)
                For intCount = 0 To intOutputParams - 1
                    vntArgs((intInputParams * 2 + 1) + (intCount * 2)) = ""
                Next
            End If
        End With

        'UPGRADE_NOTE: Object objCommand may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCommand = Nothing
        On Error GoTo ErrorHandler_ConnectionClosed
        objConnection.Close()
        'UPGRADE_NOTE: Object objConnection may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objConnection = Nothing
        Exit Function

ErrorHandler_ConnectionOpen:
        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If

ErrorHandler_ConnectionClosed:
        'UPGRADE_NOTE: Object objCommand may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCommand = Nothing
        'UPGRADE_NOTE: Object objConnection may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objConnection = Nothing
        For intCount = 0 To intOutputParams - 1
            vntArgs((intInputParams * 2 + 1) + (intCount * 2)) = ""
        Next
        CallSP = False
        lngErrorNumber = Err.Number
        strErrorDescription = Err.Description & strErrWhere
        Exit Function
    End Function

    '##ModelId=3A92939D0248
    Protected Overrides Sub Activate()

        'UPGRADE_ISSUE: COMSVCSLib.AppServer  .GetObjectContext was not upgraded. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="CC4C7EC0-C903-48FC-ACCC-81861D12DA4A"'
        'ObjContext = GetObjectContext

    End Sub

    '##ModelId=3A9293BA006A
    Protected Overrides Function CanBePooled() As Boolean

        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3A9293E6019A
    Protected Overrides Sub Deactivate()

        'UPGRADE_NOTE: Object ObjContext may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        ObjContext = Nothing

    End Sub

    Public Function CallSP_Out(ByVal strProcedureName As String, ByRef lngErrorNumber As Integer, ByRef strErrorDescription As String, ByRef arrOutVar() As String, _
                                ByVal ParamArray vntArgs() As Object) As Boolean
        '                                ByRef objOut1 As Object, ByRef objOut2 As Object, ByRef objOut3 As Object, ByRef objOut4 As Object, ByRef objOut5 As Object, _
        Dim objConnection As New ADODB.Connection
        Dim objCommand As New ADODB.Command
        Dim objServer As New clsServerInfo
        Dim strDSN As String = ""
        Dim strUserID As String = ""
        Dim strPassword As String = ""
        Dim intCount As Short
        Dim intCount2 As Short
        Dim intInputParams As Short
        Dim intOutputParams As Short
        Dim intAllParams As Short
        Dim strErrWhere As String
        strErrWhere = " (clsCallSP.CallSP_Out)"

        On Error GoTo ErrorHandler_ConnectionClosed

        'If objConnectionGbl.State = ConnectionState.Closed Then
        If Not objServer.Get_Connection_Info(strDSN, strUserID, strPassword) Then
            objServer = Nothing
            Err.Raise(0)
        End If
        objServer = Nothing

        'objConnection.Open(strDSN, strUserID, strPassword)
        On Error GoTo ErrorHandler_ConnectionOpen

        objConnection.Open(strDSN, strUserID, strPassword)
        'End If

        With objCommand
            .ActiveConnection = objConnection
            .CommandType = ADODB.CommandTypeEnum.adCmdStoredProc
            .CommandText = Trim(strProcedureName)
            intInputParams = 0
            intOutputParams = 0
            intAllParams = (UBound(vntArgs, 1) + 1) \ 2
            For intCount = 0 To intAllParams - 1
                If UCase(vntArgs(intCount * 2)) = "I" Or UCase(vntArgs(intCount * 2)) = "IL" Then
                    intInputParams = intInputParams + 1
                    If UCase(vntArgs(intCount * 2)) = "I" Then
                        If vntArgs(intCount * 2 + 1) = Nothing Then
                            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamInput, 2000, ""))
                        Else
                            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamInput, 2000, CStr(vntArgs(intCount * 2 + 1))))
                        End If
                    Else
                        If vntArgs(intCount * 2 + 1) = Nothing Then
                            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adLongVarChar, ADODB.ParameterDirectionEnum.adParamInput, 4000, ""))
                        Else
                            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adLongVarChar, ADODB.ParameterDirectionEnum.adParamInput, 4000, CStr(vntArgs(intCount * 2 + 1))))
                        End If
                    End If
                Else
                    intOutputParams = intOutputParams + 1
                    If UCase(vntArgs(intCount * 2)) = "O" Then
                        .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamOutput, 2000))
                    Else
                        .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adLongVarChar, ADODB.ParameterDirectionEnum.adParamOutput, 4000))
                    End If
                End If
            Next
            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamOutput, 2000))
            .Parameters.Append(.CreateParameter(, ADODB.DataTypeEnum.adChar, ADODB.ParameterDirectionEnum.adParamOutput, 2000))
            .Execute()
            If Trim(.Parameters(intAllParams).Value) = "0" Then
                CallSP_Out = True
                lngErrorNumber = 0
                strErrorDescription = ""

                intCount2 = intAllParams - intOutputParams
                For intCount = 0 To intOutputParams - 1
                    If IsDBNull(.Parameters(intCount2).Value) Then
                        arrOutVar(intCount) = ""
                    Else
                        arrOutVar(intCount) = Trim(.Parameters(intCount2).Value)
                    End If
                    intCount2 = intCount2 + 1
                Next
            Else
                CallSP_Out = False
                lngErrorNumber = CInt(Trim(.Parameters(intAllParams).Value))
                strErrorDescription = Trim(.Parameters(intAllParams + 1).Value)

                For intCount = 0 To intOutputParams - 1
                    arrOutVar(intCount) = ""
                Next
            End If
        End With

        objCommand = Nothing
        On Error GoTo ErrorHandler_ConnectionClosed
        objConnection.Close()
        objConnection = Nothing
        Exit Function

ErrorHandler_ConnectionOpen:
        If objConnection.State = ConnectionState.Open Then
            objConnection.Close()
        End If

ErrorHandler_ConnectionClosed:
        objCommand = Nothing
        objConnection = Nothing
        For intCount = 0 To intOutputParams - 1
            arrOutVar(intCount) = ""
        Next
        CallSP_Out = False
        lngErrorNumber = Err.Number
        strErrorDescription = Err.Description & strErrWhere
        Exit Function
    End Function

End Class