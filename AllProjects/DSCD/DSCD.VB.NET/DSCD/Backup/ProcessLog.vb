Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsProcessLog
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
        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3AC09CF1010B
    Protected Overrides Sub Deactivate()

        '## your code goes here...
        ObjContext = Nothing

    End Sub

    '##ModelId=3AC09D1503AE
    Public Function ListJobId(ByRef vntCount As Object, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As String) As Object
        Dim objList As Object
        Dim objCallRS As New clsCallRS
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(2) As String
        Dim strSql As Object
        Dim blnrc As Boolean
        Dim vntJobId As String
        Dim vntParmId As String
        Dim vntSrcId As String = ""
        Dim vntDataSrcDesc As String = ""
        Dim intCount As Short
        Dim vntArray As Object
        Dim strErrorDesc As String = ""
        Dim lngErrorNbr As Integer

        On Error GoTo ErrorHandler

        strSql = " SELECT DISTINCT DML_ORACLE_ID Job "
        strSql = strSql & " FROM DELIVERY_PARAMETER_LOCAL "
        strSql = strSql & " WHERE PARAMETER_UPDATE_TYPE = '2' "
        strSql = strSql & " AND PARAMETER_ID LIKE '%UPD' "
        strSql = strSql & " ORDER BY Job ASC "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsProcessLog.ListJobId call to CallRS for Job Id List Query")
        End If

        If vntCount > 0 Then
            'objList.Sort = "Job ASC"
            ReDim vntArray(CShort(vntCount), 1)
            intCount = 0
            Do Until intCount = vntCount
                'vntJobId = objList.Fields.Item("Job").Value
                vntJobId = objList(0, intCount)
                vntParmId = Left(vntJobId, Len(vntJobId) - 2)
                vntParmId = Right(vntParmId, Len(vntParmId) - 4)
                If IsNumeric(vntParmId) Then
                    blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveDAFDataSrc", lngErrorNbr, strErrorDesc, arrOutVar, "I", vntParmId, "O", vntSrcId, "O", vntDataSrcDesc)
                    If Not blnrc Then
                        Err.Raise(lngErrorNbr, , strErrorDesc & " Call to procedure scdCommon.RetrieveDAFDataSrc in clsProcessLog.ListJobId")
                    End If
                    vntSrcId = arrOutVar(0)
                    vntDataSrcDesc = arrOutVar(1)
                    vntArray(intCount, 0) = vntJobId
                    vntArray(intCount, 1) = Left(vntSrcId, 4) & " - " & vntDataSrcDesc
                Else
                    If vntParmId = "0B" Or vntParmId = "0S" Then
                        vntParmId = "0"
                    End If
                    blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveOrgIdFromCde", lngErrorNbr, strErrorDesc, arrOutVar, "I", vntParmId, "O", vntSrcId, "O", vntDataSrcDesc)
                    If Not blnrc Then
                        Err.Raise(lngErrorNbr, , strErrorDesc & " Call to procedure scdCommon.RetrieveOrgIdFromCde in clsProcessLog.ListJobId")
                    End If
                    vntSrcId = arrOutVar(0)
                    vntDataSrcDesc = arrOutVar(1)
                    vntArray(intCount, 0) = vntJobId
                    vntArray(intCount, 1) = Left(vntSrcId, 4) & " - " & vntDataSrcDesc
                End If
                'objList.MoveNext()
                intCount = intCount + 1
            Loop
            ListJobId = vntArray
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListJobId = System.DBNull.Value
        End If

        vntErrorNbr = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListJobId = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function

    '##ModelId=3AC09D3A027B
    Public Function ListPrcsLog(ByVal vntJobId As String, ByVal vntJobDte As String, ByRef vntCount As Object, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As Object, ByRef strSql As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim vntTempArray As Object
        Dim vntArray As Object
        Dim lngCount As Integer
        Dim intRowCount As Short
        Dim lngErrCount As Short
        Dim strText As String
        Dim strNbr As String
        Dim strNbr2 As String

        On Error GoTo ErrorHandler

        If vntJobId = "" Then
            Err.Raise(100, , "Job Id not passed to retrieve Process Log in clsProcessLog.ListPrcLog")
        End If

        If vntJobDte = "" Then
            Err.Raise(100, , "Job Date not passed to retrieve Process Log in clsProcessLog.ListPrcLog")
        End If

        strSql = strSql & " SELECT SCD_PROCESS_LOG_SEQ Seq,  "
        strSql = strSql & "     SCD_PROCESS_NAME Name, "
        strSql = strSql & "     SCD_PROCESS_LINE Line,  "
        strSql = strSql & "     SCD_PROCESS_TEXT,  "
        strSql = strSql & "     DML_TMSTMP,  "
        strSql = strSql & "     DML_ORACLE_ID Job  "
        strSql = strSql & " FROM SCORECARD_PROCESS_LOG "
        strSql = strSql & " WHERE DML_ORACLE_ID = '" & vntJobId & "' "
        strSql = strSql & " AND  DATABASE_LOAD_DATE = TO_DATE('" & vntJobDte & "','YYYY-MM-DD') "
        strSql = strSql & " AND SCD_PROCESS_NAME IN ('P_COMPLETE_EDITS_1', 'P_COMPLETE_EDITS_2', 'P_PROCESS_TEMP_ORDER_ITEMS', 'P_EDIT_TEMP_ORDER_ITEM') "
        'strSql = strSql & " AND SUBSTR(SCD_PROCESS_TEXT, 1, 1) <> 'E' "
        strSql = strSql & " ORDER BY Job ASC, Name ASC, Seq ASC, Line ASC "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsProcess.ListPrcLog call to CallRS for Main Results")
        End If

        If vntCount > 0 Then
            'objList.Sort = "Job ASC, Name ASC, Seq ASC, Line ASC"
            ReDim vntArray(3, CInt(vntCount - 1))
            vntTempArray = objList
            lngCount = 0
            intRowCount = 0
            lngErrCount = 0

            Do Until lngCount = CInt(vntCount)
                If vntTempArray(1, lngCount) = "P_COMPLETE_EDITS_1" Then 'SCD_PROCESS_NAME
                    If Left(vntTempArray(3, lngCount), 1) <> "E" Then
                        vntArray(0, intRowCount) = vntTempArray(5, lngCount) 'DML_ORACLE_ID
                        vntArray(1, intRowCount) = "Bypass Errors"
                        strNbr = Right(vntTempArray(3, lngCount), 10) 'SCD_PROCESS_TEXT
                        strNbr = VB6.Format(strNbr, "#,###,###,##0")
                        strText = Right(Left(vntTempArray(3, lngCount), 5), 4) 'SCD_PROCESS_TEXT
                        vntArray(2, intRowCount) = strText & ":  " & strNbr
                        vntArray(3, intRowCount) = vntTempArray(4, lngCount) 'DML_TMSTMP
                        intRowCount = intRowCount + 1
                    End If
                ElseIf vntTempArray(1, lngCount) = "P_COMPLETE_EDITS_2" Then  'SCD_PROCESS_NAME
                    vntArray(0, intRowCount) = vntTempArray(5, lngCount) 'DML_ORACLE_ID
                    vntArray(1, intRowCount) = "Monthly Sent vs. Received Totals"
                    strNbr = Right(vntTempArray(3, lngCount), 10) 'SCD_PROCESS_TEXT
                    strNbr = VB6.Format(strNbr, "#,###,###,##0")
                    strNbr2 = Right(Left(vntTempArray(3, lngCount), 13), 10) 'SCD_PROCESS_TEXT
                    strNbr2 = VB6.Format(strNbr, "#,###,###,##0")
                    strText = Left(vntTempArray(3, lngCount), 2) 'SCD_PROCESS_TEXT
                    Select Case strText
                        Case "01"
                            vntArray(2, intRowCount) = "JAN -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "02"
                            vntArray(2, intRowCount) = "FEB -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "03"
                            vntArray(2, intRowCount) = "MAR -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "04"
                            vntArray(2, intRowCount) = "APR -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "05"
                            vntArray(2, intRowCount) = "MAY -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "06"
                            vntArray(2, intRowCount) = "JUN -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "07"
                            vntArray(2, intRowCount) = "JUL -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "08"
                            vntArray(2, intRowCount) = "AUG -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "09"
                            vntArray(2, intRowCount) = "SEP -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "10"
                            vntArray(2, intRowCount) = "OCT -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "11"
                            vntArray(2, intRowCount) = "NOV -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "12"
                            vntArray(2, intRowCount) = "DEC -- Sent:  " & strNbr & " Received:  " & strNbr2
                        Case "13"
                            vntArray(2, intRowCount) = "OPENS -- Sent:  " & strNbr & " Received:  " & strNbr2
                    End Select
                    vntArray(3, intRowCount) = vntTempArray(4, lngCount) 'DML_TMSTMP
                    intRowCount = intRowCount + 1
                ElseIf vntTempArray(1, lngCount) = "P_EDIT_TEMP_ORDER_ITEM" Then  'SCD_PROCESS_NAME
                    If lngErrCount < 25 Then
                        vntArray(0, intRowCount) = vntTempArray(5, lngCount) 'DML_ORACLE_ID
                        vntArray(1, intRowCount) = vntTempArray(1, lngCount) 'SCD_PROCESS_NAME
                        vntArray(2, intRowCount) = vntTempArray(3, lngCount) 'SCD_PROCESS_NAME
                        vntArray(3, intRowCount) = vntTempArray(4, lngCount) 'DML_TMSTMP
                        intRowCount = intRowCount + 1
                    End If
                    lngErrCount = lngErrCount + 1
                Else
                    vntArray(0, intRowCount) = vntTempArray(5, lngCount) 'DML_ORACLE_ID
                    vntArray(1, intRowCount) = vntTempArray(1, lngCount) 'SCD_PROCESS_NAME
                    vntArray(2, intRowCount) = vntTempArray(3, lngCount) 'SCD_PROCESS_NAME
                    vntArray(3, intRowCount) = vntTempArray(4, lngCount) 'DML_TMSTMP
                    intRowCount = intRowCount + 1
                End If
                lngCount = lngCount + 1
            Loop
            ReDim Preserve vntArray(3, (intRowCount - 1))
            ListPrcsLog = vntArray
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListPrcsLog = System.DBNull.Value
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
        ListPrcsLog = System.DBNull.Value
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function
    End Function

    '##ModelId=3AC09D3A027B
    Public Function ListSmryLog(ByVal vntJobDte As String, ByRef vntCount As Object, ByRef vntErrorNbr As Integer, ByRef vntErrorDesc As String, ByRef strSql As String) As Object
        Dim objCallFunc As New clsProcessLog
        Dim blnrc As Boolean
        Dim vntJobArray As Object
        Dim vntErrArray As Object
        Dim vntArray As Object
        Dim vntErrCount As Object = 0
        Dim vntStatCnt As Object = 0
        Dim vntAddCnt As Object = 0
        Dim vntChgCnt As Object = 0
        Dim vntDelCnt As Object = 0
        Dim vntDupErrCnt As Object = 0
        Dim vntShpErrCnt As Object = 0
        Dim vntOpnErrCnt As Object = 0
        Dim vntShipsSent As Object = 0
        Dim vntShipsRecv As Object = 0
        Dim vntOpensSent As Object = 0
        Dim vntOpensRecv As Object = 0
        Dim intCount As Short

        On Error GoTo ErrorHandler

        If vntJobDte = "" Then
            Err.Raise(100, , "Job Date not passed to retrieve Summary Log in clsProcessLog.ListSmryLog")
        End If

        vntJobArray = objCallFunc.ListJobId(vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsProcess.ListSmryLog call to clsProcessLog.ListJobId")
        End If

        If vntCount = 0 Then
            Err.Raise(100, , "No Jobs Found on DELIVERY_PARAMETER_LOCAL table in clsProcessLog.ListSmryLog/ListJobId")
        End If

        ReDim vntArray(CShort(vntCount - 1), 13)
        intCount = 0
        Do Until intCount = CShort(vntCount)
            vntArray(intCount, 0) = vntJobArray(intCount, 0)
            vntArray(intCount, 13) = vntJobArray(intCount, 1)
            vntDupErrCnt = 0

            blnrc = objCallFunc.RetrieveSmryLoad(vntArray(intCount, 0), vntJobDte, vntStatCnt, vntAddCnt, vntChgCnt, vntDelCnt, vntDupErrCnt, vntErrorNbr, vntErrorDesc)
            If vntErrorNbr <> 0 Then
                Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsProcess.ListSmryLog call to clsProcess.RetrieveSmryLoad ")
            End If

            If vntStatCnt <> 1 Then
                vntArray(intCount, 1) = "-"
                vntArray(intCount, 2) = "-"
                vntArray(intCount, 3) = "-"
                vntArray(intCount, 4) = "-"
                'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                vntArray(intCount, 5) = System.DBNull.Value
                'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                vntArray(intCount, 6) = System.DBNull.Value
                vntArray(intCount, 7) = "-"
                vntArray(intCount, 8) = "-"
                vntArray(intCount, 9) = "-"
                vntArray(intCount, 10) = "-"
                vntArray(intCount, 11) = vntStatCnt
                'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                vntArray(intCount, 12) = System.DBNull.Value
            Else
                vntArray(intCount, 1) = VB6.Format(CStr(vntAddCnt), "###,###,##0")
                vntArray(intCount, 2) = VB6.Format(CStr(vntChgCnt), "###,###,##0")
                vntArray(intCount, 3) = VB6.Format(CStr(vntDelCnt), "###,###,##0")
                vntArray(intCount, 4) = VB6.Format(CStr(vntDupErrCnt), "###,###,##0")
                vntErrArray = objCallFunc.ListSmryPrcs(vntArray(intCount, 0), vntJobDte, vntErrCount, vntShpErrCnt, vntOpnErrCnt, vntShipsSent, vntShipsRecv, vntOpensSent, vntOpensRecv, vntErrorNbr, vntErrorDesc)
                If vntErrorNbr <> 0 Then
                    Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsProcess.ListSmryLog call to clsProcess.ListSmryPrcs ")
                End If
                vntArray(intCount, 5) = VB6.Format(CStr(vntShpErrCnt), "#,###,###,##0")
                vntArray(intCount, 6) = VB6.Format(CStr(vntOpnErrCnt), "#,###,###,##0")
                vntArray(intCount, 7) = VB6.Format(CStr(vntShipsSent), "#,###,###,##0")
                vntArray(intCount, 8) = VB6.Format(CStr(vntShipsRecv), "#,###,###,##0")
                vntArray(intCount, 9) = VB6.Format(CStr(vntOpensSent), "#,###,###,##0")
                vntArray(intCount, 10) = VB6.Format(CStr(vntOpensRecv), "#,###,###,##0")
                vntArray(intCount, 11) = vntStatCnt
                vntArray(intCount, 12) = vntErrArray
            End If
            intCount = intCount + 1
        Loop

        ListSmryLog = vntArray
        vntErrorNbr = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallFunc may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallFunc = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListSmryLog = System.DBNull.Value
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallFunc may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallFunc = Nothing
        Exit Function
    End Function

    '##ModelId=3AC09D3A027B
    Public Function ListSmryPrcs(ByVal vntJobId As String, ByVal vntJobDte As String, ByRef vntErrCount As Object, ByRef vntShpErrCnt As Object, ByRef vntOpnErrCnt As Object, ByRef vntShipsSent As Object, ByRef vntShipsRecv As Object, ByRef vntOpensSent As Object, ByRef vntOpensRecv As Object, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim vntTempArray As Object
        Dim vntArray As Object = Nothing
        Dim vntCount As Object = 0
        Dim lngErrCount As Short
        Dim intArrCount As Short
        Dim lngCount As Integer
        Dim lngNbr As Integer
        Dim lngNbr2 As Integer
        Dim strSql As String = ""
        Dim strText As String
        Dim strNbr As String
        Dim strNbr2 As String

        On Error GoTo ErrorHandler

        If vntJobId = "" Then
            Err.Raise(100, , "Job Id not passed to retrieve Process Log in clsProcessLog.ListSmryPrcs")
        End If

        If vntJobDte = "" Then
            Err.Raise(100, , "Job Date not passed to retrieve Process Log in clsProcessLog.ListSmryPrcs")
        End If

        strSql = strSql & " SELECT SCD_PROCESS_LOG_SEQ Seq,  "
        strSql = strSql & "     SCD_PROCESS_NAME Name, "
        strSql = strSql & "     SCD_PROCESS_LINE Line,  "
        strSql = strSql & "     SCD_PROCESS_TEXT,  "
        strSql = strSql & "     DML_TMSTMP,  "
        strSql = strSql & "     DML_ORACLE_ID Job  "
        strSql = strSql & " FROM SCORECARD_PROCESS_LOG "
        strSql = strSql & " WHERE DML_ORACLE_ID = '" & vntJobId & "' "
        strSql = strSql & " AND  DATABASE_LOAD_DATE = TO_DATE('" & vntJobDte & "','YYYY-MM-DD') "
        strSql = strSql & " AND SCD_PROCESS_NAME IN ('P_COMPLETE_EDITS_1', 'P_COMPLETE_EDITS_2', 'P_EDIT_TEMP_ORDER_ITEM') "
        strSql = strSql & " ORDER BY Job ASC, Name ASC, Seq ASC, Line ASC "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsProcess.ListPrcLog call to CallRS for Main Results")
        End If

        vntShpErrCnt = 0
        vntOpnErrCnt = 0
        vntShipsSent = 0
        vntShipsRecv = 0
        vntOpensSent = 0
        vntOpensRecv = 0

        If vntCount > 0 Then
            'objList.Sort = "Job ASC, Name ASC, Seq ASC, Line ASC"
            vntTempArray = objList
            lngCount = 0
            lngErrCount = 0
            Do Until lngCount = CInt(vntCount)
                If vntTempArray(1, lngCount) = "P_COMPLETE_EDITS_1" Then 'SCD_PROCESS_NAME
                    strNbr = Right(vntTempArray(3, lngCount), 10) 'SCD_PROCESS_TEXT
                    strText = Right(Left(vntTempArray(3, lngCount), 5), 4) 'SCD_PROCESS_TEXT
                    If strText = "SHIP" Then
                        vntShpErrCnt = strNbr
                    ElseIf strText = "OPEN" Then
                        vntOpnErrCnt = strNbr
                    End If
                ElseIf vntTempArray(1, lngCount) = "P_COMPLETE_EDITS_2" Then  'SCD_PROCESS_NAME
                    strNbr = Right(vntTempArray(3, lngCount), 10) 'SCD_PROCESS_TEXT
                    strNbr2 = Right(Left(vntTempArray(3, lngCount), 13), 10) 'SCD_PROCESS_TEXT
                    strText = Left(vntTempArray(3, lngCount), 2) 'SCD_PROCESS_TEXT
                    If strText = "13" Then
                        vntOpensSent = strNbr
                        vntOpensRecv = strNbr2
                    Else
                        lngNbr = lngNbr + CInt(strNbr)
                        lngNbr2 = lngNbr2 + CInt(strNbr2)
                    End If
                Else 'SCD_PROCESS_NAME = P_EDIT_TEMP_ORDER_ITEM
                    If lngErrCount = 0 Then
                        intArrCount = 0 'only display Max 11 errors
                        ReDim vntArray(0, 11)
                    End If
                    If lngErrCount < 12 Then
                        vntArray(0, intArrCount) = vntTempArray(3, lngCount) 'SCD_PROCESS_TEXT
                        intArrCount = intArrCount + 1
                    End If
                    lngErrCount = lngErrCount + 1
                End If
                lngCount = lngCount + 1
            Loop
            vntShipsSent = lngNbr
            vntShipsRecv = lngNbr2
            vntErrCount = intArrCount
            If vntErrCount > 0 Then
                ReDim Preserve vntArray(0, (intArrCount - 1))
                ListSmryPrcs = vntArray
            Else
                'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                ListSmryPrcs = System.DBNull.Value
            End If
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListSmryPrcs = System.DBNull.Value
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
        ListSmryPrcs = System.DBNull.Value
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function
    End Function

    '##ModelId=3AC09D3A027B
    Public Function RetrieveSmryLoad(ByVal vntJobId As String, ByVal vntJobDte As String, ByRef vntStatCnt As Object, ByRef vntAddCnt As Object, ByRef vntChgCnt As Object, ByRef vntDelCnt As Object, ByRef vntErrCnt As Object, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As String) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim vntTempArray As Object
        Dim vntCount As Object = 0
        Dim intCount As Short
        Dim strSql As String = ""

        On Error GoTo ErrorHandler

        If vntJobId = "" Then
            Err.Raise(100, , "Job Id not passed to retrieve Load Msg in clsProcessLog.ListSmryLoad")
        End If

        If vntJobDte = "" Then
            Err.Raise(100, , "Job Date not passed to retrieve Load Msg in clsProcessLog.ListSmryLoad")
        End If

        strSql = strSql & " SELECT DML_ORACLE_ID Job,  "
        strSql = strSql & "     STATUS Stat, "
        strSql = strSql & "     COUNT(STATUS),  "
        strSql = strSql & "     SUM(NBR_DETAILS_INSERTED),  "
        strSql = strSql & "     SUM(NBR_DETAILS_MODIFIED),  "
        strSql = strSql & "     SUM(NBR_DETAILS_DELETED)  "
        strSql = strSql & " FROM LOAD_MSG "
        strSql = strSql & " WHERE DML_ORACLE_ID = '" & vntJobId & "' "
        strSql = strSql & " AND  DATABASE_LOAD_DATE = TO_DATE('" & vntJobDte & "','YYYY-MM-DD') "
        strSql = strSql & " GROUP BY DML_ORACLE_ID, STATUS "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsProcess.ListSmryLoad call to CallRS for Main Results")
        End If

        If vntCount > 0 Then
            vntTempArray = objList
            intCount = 0
            Do Until intCount = CShort(vntCount)
                If vntTempArray(1, intCount) = "DUPL" Then
                    vntErrCnt = vntTempArray(2, intCount) 'COUNT(STATUS)
                Else
                    vntStatCnt = vntTempArray(2, intCount) 'COUNT(STATUS)
                    vntAddCnt = vntTempArray(3, intCount) 'SUM(NBR_DETAILS_INSERTED)
                    vntChgCnt = vntTempArray(4, intCount) 'SUM(NBR_DETAILS_MODIFIED)
                    vntDelCnt = vntTempArray(5, intCount) 'SUM(NBR_DETAILS_DELETED)
                End If
                intCount = intCount + 1
            Loop
        Else
            vntStatCnt = 0
            vntAddCnt = 0
            vntChgCnt = 0
            vntDelCnt = 0
            vntErrCnt = 0
        End If

        RetrieveSmryLoad = True
        vntErrorNbr = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function

ErrorHandler:
        RetrieveSmryLoad = False
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function
    End Function

    '##ModelId=3AC09D3A027B
    Public Function ListLoadMsg(ByVal vntJobId As String, ByVal vntJobDte As String, ByRef vntCount As Object, ByRef vntErrorNbr As Object, ByRef vntErrorDesc As String, ByRef strSql As String) As Object
        Dim objCallRS As New clsCallRS
        Dim objList As Object
        Dim vntTempArray As Object
        Dim vntArray As Object
        Dim intCount As Short

        On Error GoTo ErrorHandler

        If vntJobId = "" Then
            Err.Raise(100, , "Job Id not passed to retrieve Process Log in clsProcessLog.ListLoadMsg")
        End If

        If vntJobDte = "" Then
            Err.Raise(100, , "Job Date not passed to retrieve Process Log in clsProcessLog.ListLoadMsg")
        End If

        strSql = strSql & " SELECT DML_ORACLE_ID, DML_TMSTMP, LOAD_MSG_SEQ,  "
        strSql = strSql & "     b.ORGANIZATION_ID, DATABASE_LOAD_DATE, TYCO_ELECTRONICS_CORP_PART_NBR, "
        strSql = strSql & "     STATUS, SQL_ERROR_CODE, SQL_ERROR_MSG, UPDATE_TYPE,  "
        strSql = strSql & "     NBR_DETAILS_INSERTED, NBR_DETAILS_MODIFIED,NBR_DETAILS_DELETED,  "
        strSql = strSql & "     NBR_SMRYS_INSERTED, NBR_SMRYS_MODIFIED, NBR_SMRYS_DELETED  "
        strSql = strSql & " FROM ORGANIZATIONS_DMN b, LOAD_MSG a, CORPORATE_PARTS c "
        strSql = strSql & " WHERE DML_ORACLE_ID = '" & vntJobId & "' "
        strSql = strSql & " AND  DATABASE_LOAD_DATE = TO_DATE('" & vntJobDte & "','YYYY-MM-DD') "
        strSql = strSql & " AND a.ORGANIZATION_KEY_ID = b.ORGANIZATION_KEY_ID (+) "
        strSql = strSql & " AND a.DATABASE_LOAD_DATE BETWEEN b.EFFECTIVE_FROM_DT (+) AND b.EFFECTIVE_TO_DT (+) "
        strSql = strSql & " AND a.PART_KEY_ID = c.PART_KEY_ID (+) "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNbr, vntErrorDesc)
        If vntErrorNbr <> 0 Then
            Err.Raise(CInt(vntErrorNbr), , vntErrorDesc & " in clsProcess.ListLoadMsg call to CallRS for Main Results")
        End If

        If vntCount > 0 Then
            ReDim vntArray(CShort(vntCount - 1), 13)
            vntTempArray = objList
            intCount = 0
            Do Until intCount = CShort(vntCount)
                vntArray(intCount, 0) = vntTempArray(0, intCount) 'DML_ORACLE_ID
                vntArray(intCount, 1) = vntTempArray(6, intCount) 'STATUS
                vntArray(intCount, 2) = VB6.Format(vntTempArray(10, intCount), "###,###,##0") 'NBR_DETAILS_INSERTED
                vntArray(intCount, 3) = VB6.Format(vntTempArray(11, intCount), "###,###,##0") 'NBR_DETAILS_MODIFIED
                vntArray(intCount, 4) = VB6.Format(vntTempArray(12, intCount), "###,###,##0") 'NBR_DETAILS_DELETED
                vntArray(intCount, 5) = VB6.Format(vntTempArray(13, intCount), "###,###,##0") 'NBR_SMRY_INSERTED
                vntArray(intCount, 6) = VB6.Format(vntTempArray(14, intCount), "###,###,##0") 'NBR_SMRY_MODIFIED
                vntArray(intCount, 7) = VB6.Format(vntTempArray(15, intCount), "###,###,##0") 'NBR_SMRY_DELETED
                vntArray(intCount, 8) = vntTempArray(9, intCount) 'UPDATE_TYPE
                vntArray(intCount, 9) = vntTempArray(3, intCount) 'ORGANIZATION_ID
                vntArray(intCount, 10) = vntTempArray(5, intCount) 'PART_NBR
                vntArray(intCount, 11) = vntTempArray(4, intCount) 'DATABASE_LOAD_DATE
                vntArray(intCount, 12) = vntTempArray(7, intCount) 'SQL_ERROR_CODE
                vntArray(intCount, 13) = vntTempArray(8, intCount) 'SQL_ERROR_MSG
                intCount = intCount + 1
            Loop
            ListLoadMsg = vntArray
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListLoadMsg = System.DBNull.Value
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
        ListLoadMsg = System.DBNull.Value
        vntErrorNbr = Err.Number
        vntErrorDesc = Err.Description
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function
    End Function
End Class