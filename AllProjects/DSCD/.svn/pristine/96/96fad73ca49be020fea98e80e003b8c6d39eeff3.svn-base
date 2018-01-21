Option Strict Off
Option Explicit On
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
 Public Class ThreadDummy
    '// this class is public not creatable so to
    '// trick VB, but not show up in MTS.
    '// It has no member functions or variables so
    '// overhead is minimal
    'UPGRADE_NOTE: Class_Initialize was upgraded to Class_Initialize_Renamed. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
    Private Sub Class_Initialize_Renamed()

    End Sub
    Public Sub New()
        MyBase.New()
        Class_Initialize_Renamed()
    End Sub
End Class