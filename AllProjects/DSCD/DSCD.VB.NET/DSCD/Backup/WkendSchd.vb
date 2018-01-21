Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsWkendSchd
    Inherits ServicedComponent

    '##ModelId=3A92980D0300
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A929AC1001A
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8C36A5008E
    Public Function List(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        List = vbNullString

        Dim objCallRS As New clsCallRS
        Dim objRS As Object
        Dim vntCount As Object = 0

        Dim strErrWhere As String
        strErrWhere = " (clsReqParms.List)"

        Dim strSql As String
        strSql = "SELECT BUILDING_NBR, LOCATION_CODE, SAT_SHIP_IND, SUN_SHIP_IND, DML_ORACLE_ID" & ", TO_CHAR(DML_TMSTMP, 'YYYY-MM-DD') " & "FROM   SCORECARD_WEEKEND_SHIP " & "ORDER BY BUILDING_NBR, LOCATION_CODE"

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

    '##ModelId=3A8C36BC029B
    Public Function Insert(ByVal vntBldgNbr As Object, ByVal vntLocCode As Object, ByVal vntSatShipInd As Object, ByVal vntSunShipInd As Object, ByVal vntUserID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        Insert = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer = 0
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsWkendSchd.Insert)"

        On Error GoTo Insert_ErrorHandler

        If vntBldgNbr = "" Then
            Err.Raise(100, , "Building Nbr can not be null in clsWkendSchd.Insert (in parameter check)")
        End If

        If vntLocCode = "" Then
            Err.Raise(100, , "Location Code can not be null in clsWkendSchd.Insert (in parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdParameter.InsertWeekendShip", lngErrorNumber, strErrorDescription, "I", vntBldgNbr, "I", vntLocCode, "I", vntSatShipInd, "I", vntSunShipInd, "I", vntUserID)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Insert = blnrc
        Exit Function

Insert_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Insert = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    '##ModelId=3A8C36C30115
    Public Function Update(ByVal vntKeyBldgNbr As Object, ByVal vntKeyLocCode As Object, ByVal vntBldgNbr As Object, ByVal vntLocCode As Object, ByVal vntSatShipInd As Object, ByVal vntSunShipInd As Object, ByVal vntUserID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        Update = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer = 0
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsWkendSchd.Update)"

        On Error GoTo Update_ErrorHandler

        If vntBldgNbr = "" Then
            Err.Raise(100, , "Building Nbr can not be null in clsWkendSchd.Update (in parameter check)")
        End If

        If vntLocCode = "" Then
            Err.Raise(100, , "Location Code can not be null in clsWkendSchd.Update (in parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdParameter.UpdateWeekendShip", lngErrorNumber, strErrorDescription, "I", vntKeyBldgNbr, "I", vntKeyLocCode, "I", vntBldgNbr, "I", vntLocCode, "I", vntSatShipInd, "I", vntSunShipInd, "I", vntUserID)
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

    '##ModelId=3A8C36C90073
    Public Function Delete(ByVal vntBldgNbr As Object, ByVal vntLocCode As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean

        Delete = False
        vntErrorNumber = 0
        vntErrorDesc = vbNullString

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer = 0
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsWkendSchd.Delete)"

        On Error GoTo Delete_ErrorHandler

        If vntBldgNbr = "" Then
            Err.Raise(100, , "Building Nbr can not be null in clsWkendSchd.Delete (in parameter check)")
        End If

        If vntLocCode = "" Then
            Err.Raise(100, , "Location Code can not be null in clsWkendSchd.Delete (in parameter check)")
        End If

        blnrc = objCallSP.CallSP("scdParameter.DeleteWeekendShip", lngErrorNumber, strErrorDescription, "I", vntBldgNbr, "I", vntLocCode)
        If Not blnrc Or lngErrorNumber <> 0 Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Delete = blnrc
        Exit Function

Delete_ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Delete = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
        Exit Function
    End Function

    '##ModelId=3A929E860195
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3A92A0EF03DB
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...
        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3A92A2A801A7
    Protected Overrides Sub Deactivate()

        '## your code goes here...
        ObjContext = Nothing

    End Sub

    '##ModelId=3AC1F5BD03C2
    Public Function Retrieve() As Boolean

        On Error GoTo ErrorHandler

        '## your code goes here...

        Exit Function
ErrorHandler:

    End Function
End Class