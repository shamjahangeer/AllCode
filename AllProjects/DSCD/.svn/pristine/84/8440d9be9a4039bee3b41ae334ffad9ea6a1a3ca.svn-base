Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsSoldTo
    Inherits ServicedComponent

    '##ModelId=3ABF63C3000F
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3ABF63D202CE
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3ABF63F801E6
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF640500F6
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3ABF641E0160
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF642A03CA
    Public Function RetrieveName(ByVal vntOrgId As String, ByVal vntSoldTo As String, ByRef vntCustName As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean
        Dim strCustId As String

        On Error GoTo ErrorHandler

        If vntOrgId = "" Then
            Err.Raise(100, , "An Org Id was not passed in clsSoldTo.RetrieveName")
        End If

        If vntSoldTo = "" Then
            Err.Raise(100, , "A Sold To Nbr was not passed in clsSoldTo.RetrieveName")
        End If

        strCustId = vntOrgId & vntSoldTo

        blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveCustName", lngErrorNumber, strErrorDescription, arrOutVar, "I", "P", "I", strCustId, "O", vntCustName)
        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetrieveCustName in clsSoldTo.RetrieveName")
        End If

        vntCustName = arrOutVar(0)

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = ""
        RetrieveName = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        RetrieveName = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function
End Class