Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsView
    Inherits ServicedComponent

    '##ModelId=3A9297E90019
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A929AA90192
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8BF92402A8
    Public Function ListViews(ByVal vntErrorNumber As Object, ByVal vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0

        On Error GoTo ErrorHandler

        strSql = "select SCORECARD_VIEW_ID as VIEWID, "
        strSql = strSql & "SCORECARD_VIEW_DESC as VIEWDESC "
        strSql = strSql & "from SCORECARD_VIEWS "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)
        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsView.ListViews call to CallRS for View Query")
        End If

        If vntCount > 0 Then
            ListViews = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListViews = System.DBNull.Value
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
        ListViews = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    '##ModelId=3A929E680065
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3A92A0CB01C5
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3A92A29203CD
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    Public Function RetrieveView(ByVal vntViewId As String, ByRef vntViewDesc As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        On Error GoTo ErrorHandler

        If vntViewId = "" Then
            Err.Raise(100, , "A View Id was not passed in clsView.RetrieveView")
        End If

        blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveView", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntViewId, "O", vntViewDesc)
        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetrieveView in clsOrgs.RetrieveView")
        End If

        vntViewDesc = arrOutVar(0)
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = ""
        RetrieveView = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveView = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    Public Function ListViewCategories(ByVal vntViewId As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0

        On Error GoTo ErrorHandler

        strSql = "select a.SCORECARD_VIEW_ID, "
        strSql = strSql & " a.SCORECARD_CATEGORY_ID, "
        strSql = strSql & " b.SCORECARD_CATEGORY_DESC "
        strSql = strSql & " FROM SCORECARD_VIEW_CATEGORIES a, "
        strSql = strSql & " SCORECARD_CATEGORIES b "
        strSql = strSql & " WHERE a.SCORECARD_CATEGORY_ID = b.SCORECARD_CATEGORY_ID "

        If vntViewId <> "" Then
            strSql = strSql & "AND a.SCORECARD_VIEW_ID = " & vntViewId
        End If

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)
        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsView.ListViewCategories call to CallRS for View Category Query")
        End If

        If vntCount > 0 Then
            ListViewCategories = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListViewCategories = System.DBNull.Value
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
        ListViewCategories = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function
End Class