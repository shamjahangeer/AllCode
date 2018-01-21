Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsSummaryType
    Inherits ServicedComponent

    '##ModelId=3A92978A0169
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A929A7E02F4
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8BF9030323
    Public Function ListSmryTypes(ByVal vntWindow As String, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As String) As Object
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        If vntWindow = 1 Then
            ReDim vntArray(1, 1)
        Else
            ReDim vntArray(1, 2)
        End If

        vntArray(0, 0) = 1
        vntArray(0, 1) = 2
        vntArray(1, 0) = "Schedule to Ship"
        vntArray(1, 1) = "Request to Ship"

        If vntWindow <> 1 Then
            vntArray(0, 2) = 3
            vntArray(1, 2) = "Request to Schedule"
        End If

        ListSmryTypes = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListSmryTypes = System.DBNull.Value
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    '##ModelId=3A929E310027
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3A929FD903BA
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3A92A26503D7
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub
End Class