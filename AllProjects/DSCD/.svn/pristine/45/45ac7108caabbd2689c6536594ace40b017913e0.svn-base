Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsCompetencyBus
    Inherits ServicedComponent

    '##ModelId=3ABFAF6C022B
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3ABFAFEC022C
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3ABFB0020328
    Protected Overrides Sub Activate()

        'UPGRADE_ISSUE: COMSVCSLib.AppServer  .GetObjectContext was not upgraded. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="CC4C7EC0-C903-48FC-ACCC-81861D12DA4A"'
        'ObjContext = GetObjectContext

    End Sub

    '##ModelId=3ABFB010023A
    Protected Overrides Function CanBePooled() As Boolean

        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3ABFB05A03DC
    Protected Overrides Sub Deactivate()

        'UPGRADE_NOTE: Object ObjContext may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        ObjContext = Nothing

    End Sub

    Public Function ListCBCs(ByVal vntErrorNumber As Object, ByVal vntErrorDesc As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim strSql As String
        Dim objList As Object
        Dim vntCount As Object = 0
        Dim vntArray As Object
        Dim intCount As Short

        On Error GoTo ErrorHandler

        strSql = "select BUSLN_ID as TYPEID, "
        strSql = strSql & "BUSLN_DSCRPTN TYPEDESC  "
        strSql = strSql & "FROM GBL_BUSINESS_LINE "
        strSql = strSql & "ORDER BY BUSLN_DSCRPTN "

        'Once the object is created, make a call to get a result set

        objList = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        'Test error numbers

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDesc & " in clsCompetencyBus.ListCBCs call to CallRS for Public View Query")
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

        ListCBCs = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListCBCs = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objList may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objList = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
        Exit Function
    End Function
End Class