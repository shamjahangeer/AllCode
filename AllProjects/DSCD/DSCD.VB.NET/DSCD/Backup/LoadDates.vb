Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsLoadDates
    Inherits ServicedComponent
    'This class only contains a method to list the load dates in which data was added to the database.  It will list all the load dates on the LoadDates web screen.


    '##ModelId=3A929DA70253
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A929F230066
    Private ObjContext As System.EnterpriseServices.ContextUtil


    '##ModelId=3A92A1E001DB
    Public Function ListDates(ByRef vntErrorNbr As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objConnection As New ADODB.Connection
        Dim objCallRS As New clsCallRS
        Dim objCallSP As New clsCallSP
        Dim objList As Object
        Dim arrOutVar(2) As String
        Dim blnrc As Boolean
        Dim vntParmId As Object
        Dim vntSrcId As Object = ""
        Dim vntDataSrcDesc As Object = ""
        Dim vntArray As Object
        Dim vntWorkArray As Object
        Dim vntCount As Object = 0
        Dim intCount As Short
        Dim intRow As Short
        Dim intNewRow As Short
        Dim intSwapRow As Short
        Dim vntStartKey As Object
        Dim vntStartOrg As Object
        Dim vntStartDesc As Object
        Dim vntStartTimeStamp As Object
        Dim vntNewKey As Object
        Dim vntNewOrg As Object
        Dim vntNewDesc As Object
        Dim vntNewTimeStamp As Object
        Dim strErrorDesc As String = ""
        Dim lngErrorNbr As Integer

        On Error GoTo ErrorHandler

        strSql = " SELECT PARAMETER_ID ParmId, "
        strSql = strSql & " PARAMETER_FIELD LastLoad "
        strSql = strSql & " ,to_char(DML_TMSTMP,'DD-MON-YYYY  HH:MI AM') TimeStamp "
        strSql = strSql & " FROM DELIVERY_PARAMETER_LOCAL "
        strSql = strSql & " WHERE PARAMETER_UPDATE_TYPE = '2' "
        strSql = strSql & " AND PARAMETER_DESCRIPTION = 'GDSCD LAST UPDATE' "

        objList = objCallRS.CallRS_WithConn(objConnection, strSql, vntCount, vntErrorNbr, vntErrorDesc)

        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsResultsGeneral.ListDates call to CallRS for Last Load Date")
        End If

        If vntCount > 0 Then
            ReDim vntArray(CShort(vntCount) - 1, 2)
            intCount = 0
            Do Until intCount = vntCount
                'vntParmId = objList("ParmId")
                vntParmId = objList.Fields.Item("ParmId").Value
                vntParmId = Left(vntParmId, Len(vntParmId) - 4)
                vntParmId = Right(vntParmId, Len(vntParmId) - 3)
                If IsNumeric(vntParmId) Then
                    blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveDAFDataSrc", lngErrorNbr, strErrorDesc, arrOutVar, "I", vntParmId, "O", vntSrcId, "O", vntDataSrcDesc)
                    If Not blnrc Then
                        Err.Raise(lngErrorNbr, , strErrorDesc & " Call to procedure scdCommon.RetrieveDAFDataSrc in clsLoadDates.ListDates")
                    End If
                    vntSrcId = arrOutVar(0)
                    vntDataSrcDesc = arrOutVar(1)
                    vntArray(intCount, 0) = Left(vntSrcId, 4) & " - " & vntDataSrcDesc
                Else
                    If vntParmId = "US" Then
                        vntParmId = "0"
                    End If
                    blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveOrgIdFromCde", lngErrorNbr, strErrorDesc, arrOutVar, "I", vntParmId, "O", vntSrcId, "O", vntDataSrcDesc)
                    If Not blnrc Then
                        Err.Raise(lngErrorNbr, , strErrorDesc & " Call to procedure scdCommon.RetrieveDAFDataSrc in clsLoadDates.ListDates")
                    End If
                    vntSrcId = arrOutVar(0)
                    vntDataSrcDesc = arrOutVar(1)
                    vntArray(intCount, 0) = Left(vntSrcId, 4) & " - " & vntDataSrcDesc
                    If vntArray(intCount, 0) = " - " Then
                        vntArray(intCount, 0) = vntParmId
                    End If
                End If
                'vntArray(intCount, 1) = objList("LastLoad")
                vntArray(intCount, 1) = objList.Fields.Item("LastLoad").Value
                'vntArray(intCount, 2) = objList("TimeStamp")
                vntArray(intCount, 2) = objList.Fields.Item("TimeStamp").Value
                objList.MoveNext()
                intCount = intCount + 1
            Loop
            'Sort the array
            For intRow = 0 To UBound(vntArray) - 1
                'Take a snapshot of the first element
                'in the array because if there is a
                'smaller value elsewhere in the array
                'we'll need to do a swap.
                vntStartKey = Left(vntArray(intRow, 0), 4)
                vntStartOrg = vntArray(intRow, 0)
                vntStartDesc = vntArray(intRow, 1)
                vntStartTimeStamp = vntArray(intRow, 2)
                vntNewKey = Left(vntArray(intRow, 0), 4)
                vntNewOrg = vntArray(intRow, 0)
                vntNewDesc = vntArray(intRow, 1)
                vntNewTimeStamp = vntArray(intRow, 2)
                intSwapRow = intRow
                For intNewRow = intRow + 1 To UBound(vntArray)
                    'Start inner loop.
                    If Left(vntArray(intNewRow, 0), 4) < vntNewKey Then
                        'This is now the lowest number -
                        'remember it's position.
                        intSwapRow = intNewRow
                        vntNewKey = Left(vntArray(intNewRow, 0), 4)
                        vntNewOrg = vntArray(intNewRow, 0)
                        vntNewDesc = vntArray(intNewRow, 1)
                        vntNewTimeStamp = vntArray(intNewRow, 2)
                    End If
                Next
                If intSwapRow <> intRow Then
                    'If we get here then we are about to do a swap
                    'within the array.
                    vntArray(intSwapRow, 0) = vntStartOrg
                    vntArray(intSwapRow, 1) = vntStartDesc
                    vntArray(intSwapRow, 2) = vntStartTimeStamp
                    vntArray(intRow, 0) = vntNewOrg
                    vntArray(intRow, 1) = vntNewDesc
                    vntArray(intRow, 2) = vntNewTimeStamp
                End If
            Next
            ListDates = vntArray
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListDates = System.DBNull.Value
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
        ListDates = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    Protected Overrides Sub Activate()

    End Sub


    Protected Overrides Function CanBePooled() As Boolean
        CanBePooled = bPoolSetting
    End Function


    Protected Overrides Sub Deactivate()
        ObjContext = Nothing
    End Sub
End Class