Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsAnnounce
    Inherits ServicedComponent
    'This class is used for the generation of announcements that will be displayed on the home screen.  The retrieve method should only display the latest message.
    '
    'The list method will display all announcements.

    '##ModelId=3ABF4F0A00C6
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3ABF546E0133
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3ABF548400E5
    Protected Overrides Sub Activate()

        'UPGRADE_ISSUE: COMSVCSLib.AppServer  .GetObjectContext was not upgraded. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="CC4C7EC0-C903-48FC-ACCC-81861D12DA4A"'
        'ObjContext = GetObjectContext

    End Sub

    '##ModelId=3ABF549500AD
    Protected Overrides Function CanBePooled() As Boolean

        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3ABF54A50244
    Protected Overrides Sub Deactivate()

        'UPGRADE_NOTE: Object ObjContext may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        ObjContext = Nothing

    End Sub

    '##ModelId=3ABF54BB0386
    Public Function List(ByVal vntFromDt As Object, ByVal vntToDt As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        List = vbNullString

        Dim objCallRS As New clsCallRS
        Dim objRS As Object
        Dim vntCount As Object = 0
        Dim strSql As String
        strSql = vbNullString
        Dim strErrWhere As String
        strErrWhere = " (clsAnnounce.List)"

        If vntFromDt <> vbNullString Then
            strSql = " WHERE EFFECTIVE_DT >= TO_DATE('" & vntFromDt & "', 'YYYY-MM-DD')"
        End If

        If vntToDt <> vbNullString Then
            If strSql = vbNullString Then
                strSql = strSql & " WHERE "
            Else
                strSql = strSql & " AND "
            End If
            strSql = strSql & "EFFECTIVE_DT <= TO_DATE('" & vntToDt & "', 'YYYY-MM-DD')"
        End If

        strSql = "SELECT TO_CHAR(EFFECTIVE_DT, 'YYYY-MM-DD'), ACTIVE_INACTIVE_IND,PLANNED_IND, MESSAGE_TXT, TO_CHAR(DML_TS, 'YYYY-MM-DD HH:MI:SS AM'), DML_USER_ID FROM SCD.SCORECARD_ANNOUNCEMENTS" & strSql & " ORDER BY EFFECTIVE_DT DESC, ACTIVE_INACTIVE_IND DESC"

        objRS = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(vntErrorNumber, , vntErrorDesc)
        ElseIf vntCount > 0 Then
            List = objRS
        End If

        objCallRS = Nothing
        objRS = Nothing
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

    '##ModelId=3ABF54CD002F
    Public Function RetrieveMsg(ByRef vntTxtDate As Object, ByRef vntTxtMsg As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        On Error GoTo ErrorHandler

        Dim objCallSP As New clsCallSP
        Dim arrOutVar(2) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        blnrc = objCallSP.CallSP_Out("scdAnnounce.RetrieveMsg", lngErrorNumber, strErrorDescription, arrOutVar, "O", vntTxtDate, "OL", vntTxtMsg)
        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " in call to procedure scdAnnounce.RetrieveMsg in clsAnnounce.Retrieve")
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing

        vntTxtDate = arrOutVar(0)
        vntTxtMsg = arrOutVar(1)

        vntErrorNumber = 0
        vntErrorDesc = ""
        RetrieveMsg = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveMsg = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    Public Function AddNew(ByVal vntAmpID As Object, ByVal vntEffectiveDt As Object, ByVal vntActive As Object, ByVal vntPlanned As Object, ByVal vntMsg As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        AddNew = False

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsAnnounce.AddNew)"

        blnrc = objCallSP.CallSP("scdAnnounce.InsertMsg", lngErrorNumber, strErrorDescription, "I", vntAmpID, "I", vntEffectiveDt, "I", vntActive, "I", vntPlanned, "IL", vntMsg)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        AddNew = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        AddNew = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function RetrieveByDate(ByRef vntTxtDate As Object, ByRef vntActive As Object, ByRef vntPlanned As Object, ByRef vntTxtMsg As Object, ByRef vntEnteredByAmpID As Object, ByRef vntDateEntered As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        RetrieveByDate = False

        Dim objCallSP As New clsCallSP
        Dim arrOutVar(5) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsAnnounce.RetrieveByDate)"

        blnrc = objCallSP.CallSP_Out("scdAnnounce.RetrieveByDate", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntTxtDate, "O", vntActive, "O", vntPlanned, "OL", vntTxtMsg, "O", vntEnteredByAmpID, "O", vntDateEntered)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing

        vntActive = arrOutVar(0)
        vntPlanned = arrOutVar(1)
        vntTxtMsg = arrOutVar(2)
        vntEnteredByAmpID = arrOutVar(3)
        vntDateEntered = arrOutVar(4)

        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        RetrieveByDate = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveByDate = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    Public Function DeleteMsg(ByRef vntTxtDate As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        DeleteMsg = False

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsAnnounce.DeleteMsg)"

        blnrc = objCallSP.CallSP("scdAnnounce.DeleteMsg", lngErrorNumber, strErrorDescription, "I", vntTxtDate)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        DeleteMsg = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        DeleteMsg = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    Public Function UpdateMsg(ByVal vntAmpID As Object, ByVal vntEffectiveDt As Object, ByVal vntActive As Object, ByVal vntPlanned As Object, ByVal vntTxtMsg As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        UpdateMsg = False

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsAnnounce.UpdateMsg)"

        blnrc = objCallSP.CallSP("scdAnnounce.UpdateMsg", lngErrorNumber, strErrorDescription, "I", vntAmpID, "I", vntEffectiveDt, "I", vntActive, "I", vntPlanned, "IL", vntTxtMsg)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        UpdateMsg = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        UpdateMsg = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    Public Function List2(ByVal vntHistInd As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        List2 = Nothing

        Dim objCallRS As New clsCallRS
        Dim objRS As Object
        Dim vntCount As Object = 0
        Dim strSql As String
        strSql = vbNullString
        Dim strErrWhere As String
        strErrWhere = " (clsAnnounce.List2a)"

        strSql = "SELECT TO_CHAR(EFFECTIVE_DT, 'YYYY-MM-DD'), ACTIVE_INACTIVE_IND, MESSAGE_TXT, PLANNED_IND"
        strSql = strSql & " FROM SCD.SCORECARD_ANNOUNCEMENTS a"
        strSql = strSql & "     ,(SELECT TO_NUMBER(PARAMETER_FIELD) planned_days "
        strSql = strSql & "       FROM   DELIVERY_PARAMETER_LOCAL"
        strSql = strSql & "       WHERE  PARAMETER_ID = 'SCDPLANDISPDAYS') b"
        strSql = strSql & "     ,(SELECT TO_NUMBER(PARAMETER_FIELD) unplanned_days"
        strSql = strSql & "       FROM DELIVERY_PARAMETER_LOCAL"
        strSql = strSql & "       WHERE  PARAMETER_ID = 'SCDUNPLANDISPDAYS') c"
        strSql = strSql & " WHERE ACTIVE_INACTIVE_IND = 'Y'"
        strSql = strSql & "       AND  ((PLANNED_IND = 'Y'"

        If vntHistInd = "Y" Then
            strSql = strSql & "          AND EFFECTIVE_DT <= (TRUNC(SYSDATE) - b.planned_days ))"
        Else
            strSql = strSql & "          AND EFFECTIVE_DT <= TRUNC(SYSDATE)"
            strSql = strSql & "          AND EFFECTIVE_DT > (TRUNC(SYSDATE) - b.planned_days ))"
        End If
        strSql = strSql & "            OR"
        strSql = strSql & "             (PLANNED_IND = 'N'"

        If vntHistInd = "Y" Then
            strSql = strSql & "          AND EFFECTIVE_DT <= (TRUNC(SYSDATE) - c.unplanned_days ))"
        Else
            strSql = strSql & "          AND EFFECTIVE_DT <= TRUNC(SYSDATE)"
            strSql = strSql & "          AND EFFECTIVE_DT > (TRUNC(SYSDATE) - c.unplanned_days ))"
        End If
        strSql = strSql & "            )"
        strSql = strSql & " ORDER BY EFFECTIVE_DT DESC"

        objRS = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(vntErrorNumber, , vntErrorDesc)
        ElseIf vntCount > 0 Then
            List2 = objRS
        End If

        objCallRS = Nothing
        objRS = Nothing
        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        objRS = Nothing
        List2 = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function
End Class