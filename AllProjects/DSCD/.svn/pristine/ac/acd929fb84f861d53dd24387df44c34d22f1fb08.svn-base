Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsCategory
    Inherits ServicedComponent
    'This class generates the category selections that can be made from the search criteria screen.  The selections should be derived from a database table.

    '##ModelId=3A929435001B
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A9298A801A1
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8BF5150071
    Public Function ListCategories(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0

        On Error GoTo ErrorHandler

        strSql = "select SCORECARD_CATEGORY_ID, "
        strSql = strSql & "SCORECARD_CATEGORY_DESC "
        strSql = strSql & "FROM SCORECARD_CATEGORIES "

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsCategory.ListCategories call to CallRS for Category Query")
        End If

        If vntCount > 0 Then
            ListCategories = objList
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            ListCategories = System.DBNull.Value
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
        ListCategories = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    '##ModelId=3A929D46012C
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3A929EA400B6
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3A92A18300A6
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    Public Function RetrieveCategory(ByVal vntCatId As Object, ByRef vntCatDesc As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        On Error GoTo ErrorHandler

        If vntCatId = "" Then
            Err.Raise(100, , "A Category Id was not passed in clsCategory.RetrieveCategory")
        End If

        blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveCategory", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntCatId, "O", vntCatDesc)
        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetrieveCategory in clsOrgs.RetrieveCategory")
        End If
        vntCatDesc = arrOutVar(0)

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = ""
        RetrieveCategory = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveCategory = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function
End Class