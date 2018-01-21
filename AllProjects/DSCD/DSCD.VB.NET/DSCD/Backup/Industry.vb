Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsIndustry
    Inherits ServicedComponent
    'This class will retrieve the Industry description and the Industry Business Code description.


    '##ModelId=3ABF65F502C4
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3ABF663F0196
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3ABF66590363
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF667200C0
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3ABF668500B4
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF668E021F
    Public Function RetrieveIndustry() As Boolean
        On Error GoTo ErrorHandler

        '## your code goes here...

        Exit Function
ErrorHandler:

    End Function

    '##ModelId=3ABF89B50333
    Public Function RetrieveIndBusCde() As Boolean
        On Error GoTo ErrorHandler

        '## your code goes here...

        Exit Function
ErrorHandler:

    End Function

    Public Function RetrieveIBCName(ByVal vntIBC As String, ByRef vntIBCName As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        On Error GoTo ErrorHandler

        If vntIBC = "" Then
            Err.Raise(100, , "An IBC was not passed in clsIndustry.RetrieveIBCName")
        End If

        blnrc = objCallSP.CallSP("scdCommon.RetrieveIBCName", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntIBC, "O", vntIBCName)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetrieveIBCName in clsIndustry.RetrieveIBCName")
        End If

        vntIBCName = arrOutVar(0)

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = ""
        RetrieveIBCName = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveIBCName = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    Public Function ListIBCs(ByVal vntErrorNumber As Object, ByVal vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0
        Dim vntArray As Object
        Dim intCount As Short

        On Error GoTo ErrorHandler

        strSql = "select GIB_INDUSTRY_BUSINESS_CODE as TYPEID, "
        strSql = strSql & "GIB_SHORT_NAME TYPEDESC  "
        strSql = strSql & "FROM GBL_INDUSTRY_BUSINESS "
        strSql = strSql & "ORDER BY GIB_SHORT_NAME"

        'Once the object is created, make a call to get a result set

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        'Test error numbers

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsIndustry.ListIBCs call to CallRS for Public View Query")
        End If

        'Test to see if we have any records

        If vntCount > 0 Then
            'For any recordsets we will pass back to the web ASP pages variant arrays
            vntArray = objList
            For intCount = LBound(vntArray, 2) To UBound(vntArray, 2)
                vntArray(1, intCount) = vntArray(1, intCount) & " (" & vntArray(0, intCount) & ")"
            Next
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            vntArray = System.DBNull.Value
        End If

        ListIBCs = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListIBCs = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function
End Class