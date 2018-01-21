Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsLeadtime
    Inherits ServicedComponent

    Public Function ListLeadtimeTypes(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        Dim vntArray As Object

        On Error GoTo ErrorHandler

        ReDim vntArray(1, 1)

        vntArray(0, 0) = "1"
        vntArray(0, 1) = "2"
        vntArray(1, 0) = "Customer/Tyco"
        vntArray(1, 1) = "Shipping"

        ListLeadtimeTypes = vntArray

        vntErrorNumber = 0
        vntErrorDesc = ""
        Exit Function

ErrorHandler:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        ListLeadtimeTypes = System.DBNull.Value
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description
    End Function
End Class