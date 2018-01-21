Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsPart
    Inherits ServicedComponent

    '##ModelId=3ABF4E3203BB
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3ABF4E55038D
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3ABF4E740037
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF4E8900D7
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3ABF4EA2020B
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    '##ModelId=3ABF4EB30205
    Public Function Retrieve() As Boolean
        On Error GoTo ErrorHandler

        '## your code goes here...

        Exit Function
ErrorHandler:

    End Function

    '##ModelId=3ABF5DE80110
    Public Function ConvertToDisplay(ByVal vntPartIn As Object, ByRef vntPartOut As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim strPrefix As String
        Dim strBase As String
        Dim strSuffix As String
        Dim strErrWhere As String
        strErrWhere = " (clsPart.ConvertToDisplay)"

        On Error GoTo ConvertToDisplay_Error

        If Len(vntPartIn) <> 9 Then
            Err.Raise(-1, , "Stored Part Number Wrong Length")
        Else
            If IsNumeric(vntPartIn) Then
                If Val(vntPartIn) = 0 Then
                    vntPartOut = "0-0000000-0"
                Else
                    strPrefix = Mid(vntPartIn, 8, 1) & "-"
                    strBase = Left(vntPartIn, 7)
                    strSuffix = "-" & Mid(vntPartIn, 9, 1)
                    vntPartOut = strPrefix & strBase & strSuffix
                End If
            Else
                strPrefix = Mid(vntPartIn, 8, 1) & "-"
                strBase = Left(vntPartIn, 7)
                strSuffix = "-" & Mid(vntPartIn, 9, 1)
                vntPartOut = strPrefix & strBase & strSuffix
            End If
        End If

        ConvertToDisplay = True
        vntErrorNumber = 0
        vntErrorDescription = ""
        Exit Function

ConvertToDisplay_Error:
        ConvertToDisplay = False
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description & strErrWhere
        Exit Function
    End Function

    '##ModelId=3ABF5DF203AC
    Public Function ConvertToStorage(ByVal vntPartIn As Object, ByRef vntPartOut As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim strConverted As String = ""
        Dim strErrorText As String
        Dim strErrWhere As String
        strErrWhere = " (clsPart.ConvertToStorage)"

        Dim intDashCount As Short
        Dim intFound As Short
        Dim intDash1 As Short
        Dim intDash2 As Short

        On Error GoTo ConvertToStorage_Error

        strErrorText = "Error in ConvertPartStorage"

        intDashCount = 0

        intFound = InStr(vntPartIn, "-")
        Do Until intFound = 0
            intDashCount = intDashCount + 1
            intFound = InStr(intFound + 1, vntPartIn, "-")
        Loop

        If intDashCount = 2 Then
            intDash1 = InStr(vntPartIn, "-")
            intDash2 = InStr(intDash1 + 1, vntPartIn, "-")
            If (intDash1 - 1) <> 1 Or (intDash2 - intDash1 - 1) > 7 Or (Len(vntPartIn) - intDash2) <> 1 Then
                Err.Raise(-1, , "Part Number is Formatted Incorrectly")
            End If
            strConverted = VB6.Format(Mid(vntPartIn, intDash1 + 1, Len(vntPartIn) - 4), "0000000") & Mid(vntPartIn, intDash1 - 1, 1) & Mid(vntPartIn, intDash2 + 1, 1)
        Else
            If intDashCount = 1 Then
                intDash1 = InStr(vntPartIn, "-")
                If (intDash1 - 1) > 7 Or Len(Mid(vntPartIn, intDash1 + 1, Len(vntPartIn) - intDash1)) <> 1 Then
                    Err.Raise(-1, , "Part Number is Formatted Incorrectly")
                End If
                strConverted = VB6.Format(Mid(vntPartIn, 1, intDash1 - 1), "0000000") & "0" & Mid(vntPartIn, intDash1 + 1, 1)
            Else
                If intDashCount = 0 Then
                    If Len(vntPartIn) > 7 Then
                        Err.Raise(-1, , "Part Number is Missing Dashes or Too Long")
                    End If
                    strConverted = VB6.Format(vntPartIn, "0000000") & "00"
                Else
                    Err.Raise(-1, , "Part Number has Too Many Dashes")
                End If
            End If
        End If

        vntPartOut = strConverted
        ConvertToStorage = True
        vntErrorNumber = 0
        vntErrorDescription = ""
        Exit Function

ConvertToStorage_Error:
        ConvertToStorage = False
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description & strErrWhere
        Exit Function
    End Function

    Public Function List(ByVal vntPartNumber As String, ByVal vntDescription As String, ByVal vntExactMatch As String, ByRef vntSQL As String, ByRef vntErrorNumber As Object, ByRef vntErrorDescription As Object) As Object
        Dim objCallRS As New clsCallRS
        Dim objRecordset As Object
        Dim strSql As String
        Dim strWhere As String
        Dim strProductCode As String
        Dim strPartNumber As String
        Dim strPartOut As String
        Dim strDescription As String
        Dim strOutput As String
        Dim intCount As Integer
        Dim vntCount As Object = 0
        Dim vntTempArray As Object
        Dim blnrc As Object
        Dim strTable As String
        Dim blnXref As Boolean

        On Error GoTo List_Error

        blnXref = False

        If vntPartNumber = "" And vntDescription = "" Then
            Err.Raise(100, , "Required input parameter Part Number and/or Part Desc is missing for retrieving search criteria in clsPart.List")
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntPartNumber) Then
            strPartNumber = ""
        Else
            strPartNumber = UCase(Trim(CStr(vntPartNumber)))
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        If IsDBNull(vntDescription) Then
            strDescription = ""
        Else
            strDescription = UCase(Trim(CStr(vntDescription)))
        End If

        strSql = "Select PART_NBR As PartNumber , "
        strSql = strSql & " PART_DESC As Description, "
        strSql = strSql & " ca.PART_KEY_ID As PartKeyId, "
        strSql = strSql & " b.BRAND_SHORT_NM BrandDesc "
        strSql = strSql & " FROM CORPORATE_PARTS cp,"
        strSql = strSql & " CORPORATE_PART_ALIASES ca, "
        strSql = strSql & "  brands b"
        strWhere = " WHERE cp.PART_KEY_ID = ca.PART_KEY_ID "
        strWhere = strWhere & " AND ca.ACQUIRED_FORMAT_ID = b.BRAND_ID "

        If Len(strPartNumber) > 0 Then
            If vntExactMatch = "0" Then
                strWhere = strWhere & " AND PART_NBR Like '" & strPartNumber & "%'"
            Else
                strWhere = strWhere & " AND PART_NBR = '" & strPartNumber & "'"
            End If
        End If

        If Len(strDescription) > 0 Then
            If vntExactMatch = "0" Then
                strWhere = strWhere & " AND Upper(PART_DESC) Like upper('" & strDescription & "%')"
            Else
                strWhere = strWhere & " AND Upper(PART_DESC) = upper('" & strDescription & "')"
            End If
        End If

        strSql = strSql & strWhere & " Order By PART_NBR, PART_DESC"

        vntSQL = strSql

        objRecordset = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDescription)
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing

        If vntErrorNumber <> 0 Then
            Err.Raise(CInt(vntErrorNumber), , vntErrorDescription & " in clsPart.List call to CallRS for Parts Query")
        End If

        If vntCount > 0 Then
            List = objRecordset
        Else
            'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
            List = System.DBNull.Value
        End If

        vntErrorNumber = 0
        vntErrorDescription = ""
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRecordset may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRecordset = Nothing
        Exit Function

List_Error:
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        List = System.DBNull.Value
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        vntErrorNumber = Err.Number
        vntErrorDescription = Err.Description
        Exit Function
    End Function
End Class