Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsHolidaySchd
    Inherits ServicedComponent
    'This class is for the Holiday parameter maint. screen.  It contains a list, insert, update and delete methods.

    '##ModelId=3A92962301BD
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A92992E01BF
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8C35F80014
    Public Function List(ByVal vntCoOrgKeyID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
        'Public Function List(ByRef vntErrorNumber As Variant, ByRef vntErrorDesc As Variant) As Variant

        On Error GoTo ErrorHandler

        List = vbNullString

        Dim objCallRS As New clsCallRS
        Dim objRS As Object
        Dim vntCount As Object = 0
        Dim strSql As String
        strSql = vbNullString
        Dim strErrWhere As String
        strErrWhere = " (clsHolidaySchd.List)"

        strSql = "SELECT SH.COMPANY_ORG_KEY_ID, SO.ORGANIZATION_ID, SO.ORGANIZATION_SHORT_NM, SH.BUILDING_NBR, SH.LOCATION_CODE, TO_CHAR(SH.CO_HOLIDAY_DATE, 'YYYY-MM-DD'), SH.DML_ORACLE_ID, TO_CHAR(SH.DML_TMSTMP, 'YYYY-MM-DD') FROM SCORECARD_HOLIDAY SH, SCORECARD_ORGANIZATIONS SO"
        strSql = strSql & " WHERE SH.COMPANY_ORG_KEY_ID = SO.ORGANIZATION_KEY_ID(+)"

        If vntCoOrgKeyID <> vbNullString Then
            strSql = strSql & " AND SH.COMPANY_ORG_KEY_ID = " & vntCoOrgKeyID
        End If

        strSql = strSql & " ORDER BY SO.ORGANIZATION_ID, SH.CO_HOLIDAY_DATE"
        objRS = objCallRS.CallRS_NoConn(strSql, vntCount, vntErrorNumber, vntErrorDesc)

        If vntErrorNumber <> 0 Then
            Err.Raise(vntErrorNumber, , vntErrorDesc)
        ElseIf vntCount > 0 Then
            List = objRS
        End If

        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        List = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    '##ModelId=3A8C36010224
    Public Function Insert(ByVal vntReportingOrg As Object, ByVal vntBldgNbr As Object, ByVal vntLocationCde As Object, ByVal vntHolidayDt As Object, ByVal vntAmpID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        Insert = False

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer = 0
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsHolidaySchd.Insert)"

        blnrc = objCallSP.CallSP("scdHoliday.Insert_Holiday_Parm", lngErrorNumber, strErrorDescription, "I", vntReportingOrg, "I", vntBldgNbr, "I", vntLocationCde, "I", vntHolidayDt, "I", vntAmpID)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        Insert = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Insert = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    '##ModelId=3A8C360903A2
    Public Function Update(ByVal vntReportingOrg As Object, ByVal vntBldgNbr As Object, ByVal vntLocationCde As Object, ByVal vntHolidayDt As Object, ByVal vntKeyBldgNbr As Object, ByVal vntKeyLocationCde As Object, ByVal vntKeyHolidayDt As Object, ByVal lsAmpID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        Update = False

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer = 0
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsHolidaySchd.Update)"

        blnrc = objCallSP.CallSP("scdHoliday.Update_Holiday_Parm", lngErrorNumber, strErrorDescription, "I", vntReportingOrg, "I", vntBldgNbr, "I", vntLocationCde, "I", vntHolidayDt, "I", vntKeyBldgNbr, "I", vntKeyLocationCde, "I", vntKeyHolidayDt, "I", lsAmpID)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        Update = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Update = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    '##ModelId=3A8C361002DA
    Public Function Delete(ByVal vntReportingOrg As Object, ByVal vntBldgNbr As Object, ByVal vntLocationCde As Object, ByVal vntHolidayDt As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        Delete = False

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer = 0
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsHolidaySchd.Delete)"

        blnrc = objCallSP.CallSP("scdHoliday.Delete_Holiday_Parm", lngErrorNumber, strErrorDescription, "I", vntReportingOrg, "I", vntBldgNbr, "I", vntLocationCde, "I", vntHolidayDt)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        Delete = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Delete = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    '##ModelId=3A929D8F0244
    Protected Overrides Sub Activate()

        '## your code goes here...

    End Sub

    '##ModelId=3A929F0800F8
    Protected Overrides Function CanBePooled() As Boolean

        '## your code goes here...

    End Function

    '##ModelId=3A92A1BC00DE
    Protected Overrides Sub Deactivate()

        '## your code goes here...

    End Sub

    '##ModelId=3AC1F5910344
    Public Sub Retrieve()
        On Error GoTo ErrorHandler

        '## your code goes here...

        Exit Sub
ErrorHandler:

    End Sub

    'Public Function Validate(ByVal vntReportingOrg As Object, ByVal vntBldgNbr As Object, ByVal vntLocationCde As Object, ByVal vntHolidayDt As Object, ByVal lsAmpID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object
    Public Function Validate(ByVal vntReportingOrg As String, ByVal vntBldgNbr As String, ByVal vntLocationCde As String, ByVal vntHolidayDt As String, ByVal lsAmpID As String, ByRef vntErrorNumber As Integer, ByRef vntErrorDesc As String) As Object

        On Error GoTo ErrorHandler

        Validate = False

        Dim strValid As String = ""
        Dim objCallSP As New clsCallSP
        Dim arrOutVar(1) As String
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer = 0
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsHolidaySchd.Validate)"

        blnrc = objCallSP.CallSP_Out("scdHoliday.Validate_Holiday_Parm", lngErrorNumber, strErrorDescription, arrOutVar, "I", vntReportingOrg, "I", vntBldgNbr, "I", vntLocationCde, "I", vntHolidayDt, "I", lsAmpID, "O", strValid)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        strValid = arrOutVar(0)

        If strValid = "F" Then
            vntErrorNumber = lngErrorNumber
            vntErrorDesc = strErrorDescription
            Validate = False
        Else
            vntErrorNumber = 0
            vntErrorDesc = vbNullString
            Validate = blnrc
        End If
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        Validate = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function GetLatestOrgKeyID(ByVal vntGlobalID As Object, ByRef vntCoOrgKID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ErrorHandler

        GetLatestOrgKeyID = False

        Dim objCallSP As New clsCallSP
        Dim strErrorDescription As String = ""
        Dim lngErrorNumber As Integer = 0
        Dim blnrc As Boolean
        Dim strErrWhere As String
        strErrWhere = " (clsHolidaySchd.GetLatestOrgKeyID)"

        blnrc = objCallSP.CallSP("scdHoliday.GetLatestOrgKeyID", lngErrorNumber, strErrorDescription, "I", vntGlobalID, "O", vntCoOrgKID)

        If Not blnrc Then
            Err.Raise(lngErrorNumber, , strErrorDescription)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = 0
        vntErrorDesc = vbNullString
        GetLatestOrgKeyID = blnrc
        Exit Function

ErrorHandler:
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        GetLatestOrgKeyID = False
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function
End Class