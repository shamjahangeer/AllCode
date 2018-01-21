Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
 Public Class clsComparison
    Inherits ServicedComponent

    Public Function ListComparisonTypes(ByVal vntErrorNumber As Object, ByVal vntErrorDesc As Object) As Object
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        ReDim vntArray(1, 1)

        vntArray(0, 0) = "1"
        vntArray(0, 1) = "2"
        vntArray(1, 0) = "Compare To Schedule"
        vntArray(1, 1) = "Compare to Request"

        ListComparisonTypes = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListComparisonTypes = System.DBNull.Value
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function
End Class