Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsWindow
    Inherits ServicedComponent

    '##ModelId=3A9297FA03C1
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A929AB8022A
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8BF93401B4
    Public Function ListWindows(ByVal vntErrorNumber As Object, ByVal vntErrorDesc As Object) As Object
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        ReDim vntArray(1, 1)

        vntArray(0, 0) = 1
        vntArray(0, 1) = 2
        vntArray(1, 0) = "Customer Variable"
        vntArray(1, 1) = "Standard Default"

        ListWindows = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListWindows = System.DBNull.Value
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    '##ModelId=3A929E7600D3
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3A92A0DC0135
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3A92A29E00D1
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub
End Class