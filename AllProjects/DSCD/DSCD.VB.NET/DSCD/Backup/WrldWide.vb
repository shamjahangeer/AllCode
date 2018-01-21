Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsWrldWide
    Inherits ServicedComponent

    '##ModelId=3ABF684B03C7
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3ABF6864010C
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3ABF689A033A
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF68AC008D
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3ABF68C50025
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF68CE01EF
    Public Function RetrieveName(ByVal vntWWNbr As String, ByRef vntCustName As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Boolean
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer
        Dim blnrc As Boolean

        On Error GoTo ErrorHandler


        If vntWWNbr = "" Then
            Err.Raise(100, , "A WorldWide Nbr was not passed in clsWrldWide.RetrieveName")
        End If

        blnrc = objCallSP.CallSP_Out("scdCommon.RetrieveCustName", lngErrorNumber, strErrorDescription, arrOutVar, "I", "W", "I", vntWWNbr, "O", vntCustName)
        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription & " Call to procedure scdCommon.RetrieveCustName in clsWrldWide.RetrieveName")
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