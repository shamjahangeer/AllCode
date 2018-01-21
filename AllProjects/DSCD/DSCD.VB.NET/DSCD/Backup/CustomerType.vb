Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsCustomerType
    Inherits ServicedComponent
    'This class generates the selection for customer account type on the search criteria screen.

    '##ModelId=3A92945C009D
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A9299010025
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8BF5DD0000
    Public Function ListCustTypes(ByVal vntErrorNumber As Object, ByVal vntErrorDesc As Object) As Object
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        ReDim vntArray(1, 2)

        vntArray(0, 0) = "0"
        vntArray(0, 1) = "T"
        vntArray(0, 2) = "I"
        vntArray(1, 0) = "All"
        vntArray(1, 1) = "Trade"
        vntArray(1, 2) = "IntraCompany"

        ListCustTypes = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListCustTypes = System.DBNull.Value
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function

    '##ModelId=3A929D6B0374
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3A929EC1013C
    Protected Overrides Function CanBePooled() As Boolean


        '## your code goes here...

    End Function

    '##ModelId=3A92A1990228
    Protected Overrides Sub Deactivate()


        '## your code goes here...

    End Sub
End Class