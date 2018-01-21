Option Strict Off
Option Explicit On
Imports DSCD
Imports System.EnterpriseServices
<Transaction(TransactionOption.Disabled)> _
Public Class clsAdHoc
    Inherits ServicedComponent

    '##ModelId=3AC1F8630389
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3AC1F896018F
    Private ObjContext As Object

    '##ModelId=3AC1F8A20205
    Protected Overrides Sub Activate()

        'UPGRADE_ISSUE: COMSVCSLib.AppServer  .GetObjectContext was not upgraded. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="CC4C7EC0-C903-48FC-ACCC-81861D12DA4A"'
        'ObjContext = GetObjectContext

    End Sub

    '##ModelId=3AC1F8B102EF
    Protected Overrides Function CanBePooled() As Boolean

        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3AC1F8C9004B
    Protected Overrides Sub Deactivate()

        'UPGRADE_NOTE: Object ObjContext may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        ObjContext = Nothing

    End Sub

    '##ModelId=3AC1F8DB0252
    Public Function InsertStats(ByVal vntGblId As Object, ByVal vntServer As Object, ByVal vntReferer As Object, ByVal vntAgent As Object, ByVal vntPage As Object, ByVal vntIPAddr As Object, ByVal vntHost As Object, ByVal vntUserID As Object, ByVal vntViewID As Object, ByVal vntCategoryID As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        InsertStats = False

        On Error GoTo Error_Handler

        Dim objCallSP As New clsCallSP
        Dim blnRC As Boolean
        Dim lngErrorNumber As Integer
        Dim strErrorDesc As String = ""
        Dim strErrWhere As String

        strErrWhere = " (clsAdhoc.InsertStats)"

        'Set Defaults

        If vntGblId = vbNullString Then vntGblId = 0
        If vntServer = vbNullString Then vntServer = "UNKNOWN"
        If vntReferer = vbNullString Then vntReferer = "START"
        If vntAgent = vbNullString Then vntAgent = "UNKNOWN"
        If vntPage = vbNullString Then vntPage = "UNKNOWN"
        If vntIPAddr = vbNullString Then vntIPAddr = "UNKNOWN"
        If vntHost = vbNullString Then vntHost = vntIPAddr
        If vntUserID = vbNullString Then vntUserID = "UNKNOWN"
        If Not IsNumeric(vntViewID) Then vntViewID = vbNullString
        If Not IsNumeric(vntCategoryID) Then vntCategoryID = vbNullString

        blnRC = objCallSP.CallSP("scdAdHoc.InsertStats", lngErrorNumber, strErrorDesc, "I", vntGblId, "I", vntServer, "I", vntReferer, "I", vntAgent, "I", vntPage, "I", vntIPAddr, "I", vntHost, "I", vntUserID, "I", vntViewID, "I", vntCategoryID)
        If Not blnRC Then
            Err.Raise(lngErrorNumber, , strErrorDesc)
        End If

        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        InsertStats = blnRC
        Exit Function

Error_Handler:
        InsertStats = False
        'UPGRADE_NOTE: Object objCallSP may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallSP = Nothing
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    '##ModelId=3AC1F8E40042
    'Public Function ListStats() As Object
    '    On Error GoTo ErrorHandler

    '## your code goes here...

    'The Table Columns
    'SCD_APPLICATION_USAGES_ID,
    'ASOC_GLOBAL_ID,
    'SERVER_NM,
    'HTTP_BACK_URL_TXT,
    'HTTP_USER_AGENT_TXT,
    'URL_TXT,
    'REMOTE_IP_ADDR,
    'REMOTE_HOST_NM,
    'SCORECARD_VIEW_ID,
    'SCORECARD_CATEGORY_ID,
    'DML_TS,
    'DML_USER_ID

    'Exit Function
    'ErrorHandler:

    'End Function

    Public Function GetServerStatScreens(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo GetServerStatScreens_Err

        GetServerStatScreens = vbNullString

        Dim strErrWhere As Object

        strErrWhere = " (clsAdhoc.GetServerStatScreens)"

        Dim strSQL As String
        strSQL = "SELECT DISTINCT URL_TXT FROM SCD_APPLICATION_USAGES ORDER BY URL_TXT"

        Dim objCallRS As New clsCallRS
        Dim arrTemp As Object
        Dim vntCount As Object = 0
        Dim objRS As Object

        objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

        Dim inxRow As Short
        Dim inxCol As Short
        If vntErrorNumber = 0 Then
            If vntCount > 0 Then
                arrTemp = objRS
                For inxRow = LBound(arrTemp, 2) To UBound(arrTemp, 2)
                    For inxCol = LBound(arrTemp, 1) To UBound(arrTemp, 1)
                        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                        If IsDBNull(arrTemp(inxCol, inxRow)) Or arrTemp(inxCol, inxRow) = vbNullString Then arrTemp(inxCol, inxRow) = "UNKNOWN"
                    Next
                Next
                GetServerStatScreens = arrTemp
            End If
        Else
            Err.Raise(vntErrorNumber, , vntErrorDesc)
        End If

        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        Exit Function

GetServerStatScreens_Err:
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        GetServerStatScreens = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function GetServerStatUsers(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo GetServerStatUsers_Err

        GetServerStatUsers = vbNullString

        Dim strErrWhere As Object

        strErrWhere = " (clsAdhoc.GetServerStatUsers)"

        Dim strSQL As String
        strSQL = "SELECT DISTINCT ASOC_GLOBAL_ID, DML_USER_ID FROM SCD_APPLICATION_USAGES ORDER BY DML_USER_ID"

        Dim objCallRS As New clsCallRS
        Dim arrTemp As Object
        Dim vntCount As Object = 0
        Dim objRS As Object

        objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

        Dim inxRow As Short
        Dim inxCol As Short

        If vntErrorNumber = 0 Then
            If vntCount > 0 Then
                arrTemp = objRS
                For inxRow = LBound(arrTemp, 2) To UBound(arrTemp, 2)
                    'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                    If IsDBNull(arrTemp(1, inxRow)) Or arrTemp(1, inxRow) = vbNullString Then
                        arrTemp(1, inxRow) = "UNKNOWN"
                        Exit For
                    End If
                Next
                If inxRow < UBound(arrTemp, 2) Then
                    ReDim Preserve arrTemp(UBound(arrTemp, 1), inxRow)
                    arrTemp(0, inxRow) = 0
                End If
                GetServerStatUsers = arrTemp
            End If
        Else
            Err.Raise(vntErrorNumber, , vntErrorDesc)
        End If

        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        Exit Function

GetServerStatUsers_Err:
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        GetServerStatUsers = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function GetServerStatViews(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo GetServerStatViews_Err

        GetServerStatViews = vbNullString

        Dim strErrWhere As Object

        strErrWhere = " (clsAdhoc.GetServerStatViews)"

        Dim strSQL As String

        strSQL = "SELECT DISTINCT SAU.SCORECARD_VIEW_ID, DECODE(SV.SCORECARD_VIEW_DESC, NULL, 'UNKNOWN', SV.SCORECARD_VIEW_DESC) FROM SCD_APPLICATION_USAGES SAU, SCORECARD_VIEWS SV WHERE NOT SAU.SCORECARD_VIEW_ID IS NULL AND SAU.SCORECARD_VIEW_ID = SV.SCORECARD_VIEW_ID(+) ORDER BY SAU.SCORECARD_VIEW_ID"

        Dim objCallRS As New clsCallRS
        Dim arrTemp As Object
        Dim vntCount As Object = 0
        Dim objRS As Object

        objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

        If vntCount > 0 Then GetServerStatViews = objRS

        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        Exit Function

GetServerStatViews_Err:
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        GetServerStatViews = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function GetServerStatCategories(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo GetServerStatCategories_Err

        GetServerStatCategories = vbNullString

        Dim strErrWhere As Object

        strErrWhere = " (clsAdhoc.GetServerStatCategories)"

        Dim strSQL As String
        strSQL = "SELECT DISTINCT SAU.SCORECARD_CATEGORY_ID, DECODE(SC.SCORECARD_CATEGORY_DESC, NULL, 'UNKNOWN', SC.SCORECARD_CATEGORY_DESC) FROM SCD_APPLICATION_USAGES SAU, SCORECARD_CATEGORIES SC WHERE NOT SAU.SCORECARD_CATEGORY_ID IS NULL AND SAU.SCORECARD_CATEGORY_ID = SC.SCORECARD_CATEGORY_ID(+) ORDER BY SAU.SCORECARD_CATEGORY_ID"

        Dim objCallRS As New clsCallRS
        Dim arrTemp As Object
        Dim vntCount As Object = 0
        Dim objRS As Object

        objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

        If vntCount > 0 Then GetServerStatCategories = objRS

        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        Exit Function

GetServerStatCategories_Err:
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        GetServerStatCategories = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function GetServerStatServers(ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo GetServerStatServers_Err

        GetServerStatServers = vbNullString

        Dim strErrWhere As Object

        strErrWhere = " (clsAdhoc.GetServerStatServers)"

        Dim strSQL As String
        strSQL = "SELECT DISTINCT SERVER_NM FROM SCD_APPLICATION_USAGES ORDER BY SERVER_NM"

        Dim objCallRS As New clsCallRS
        Dim arrTemp As Object
        Dim vntCount As Object = 0
        Dim objRS As Object

        objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

        Dim inxRow As Short
        Dim inxCol As Short
        If vntErrorNumber = 0 Then
            If vntCount > 0 Then
                arrTemp = objRS
                For inxRow = LBound(arrTemp, 2) To UBound(arrTemp, 2)
                    For inxCol = LBound(arrTemp, 1) To UBound(arrTemp, 1)
                        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
                        If IsDBNull(arrTemp(inxCol, inxRow)) Or arrTemp(inxCol, inxRow) = vbNullString Then arrTemp(inxCol, inxRow) = "UNKNOWN"
                    Next
                Next
                GetServerStatServers = arrTemp
            End If
        Else
            Err.Raise(vntErrorNumber, , vntErrorDesc)
        End If

        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        Exit Function

GetServerStatServers_Err:
        'UPGRADE_NOTE: Object objCallRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objCallRS = Nothing
        'UPGRADE_NOTE: Object objRS may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        objRS = Nothing
        GetServerStatServers = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function

    Public Function ServerStatReport(ByVal vntDimension1 As Object, ByVal vntDimension2 As Object, ByVal vntFromDate As Object, ByVal vntFromTime As Object, ByVal vntToDate As Object, ByVal vntToTime As Object, ByVal vntScreens As Object, ByVal vntAssociates As Object, ByVal vntViews As Object, ByVal vntCategories As Object, ByVal vntServers As Object, ByRef vntSQL As Object, ByRef vntErrorNumber As Object, ByRef vntErrorDesc As Object) As Object

        On Error GoTo ServerStatReport_Err

        ServerStatReport = vbNullString

        Dim strErrWhere As Object

        strErrWhere = " (clsAdhoc.ServerStatReport)"

        Dim strDimension1 As String
        Dim strDimension2 As String
        Dim strFromDate As String
        Dim strFromTime As String
        Dim strToDate As String
        Dim strToTime As String
        Dim strScreens As String
        Dim strAssociates As String
        Dim strViews As String
        Dim strCategories As String
        Dim strServers As String

        'Init Vars
        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntDimension1) Or IsDBNull(vntDimension1) Then
            strDimension1 = "SCREEN"
        Else
            strDimension1 = UCase(vntDimension1)
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntDimension2) Or IsDBNull(vntDimension2) Then
            strDimension2 = vbNullString
        Else
            strDimension2 = UCase(vntDimension2)
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntFromDate) Or IsDBNull(vntFromDate) Or vntFromDate = vbNullString Then
            strFromDate = vbNullString
        Else
            strFromDate = VB6.Format(vntFromDate, "yyyy-mm-dd")
            If Not IsDate(strFromDate) Then Err.Raise(-1, , "Invalid ""From"" Date")
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntFromTime) Or IsDBNull(vntFromTime) Or vntFromTime = vbNullString Then
            strFromTime = vbNullString
        Else
            strFromTime = VB6.Format(vntFromTime, "hh:nn")
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntToDate) Or IsDBNull(vntToDate) Or vntToDate = vbNullString Then
            strToDate = vbNullString
        Else
            strToDate = VB6.Format(vntToDate, "yyyy-mm-dd")
            If Not IsDate(strToDate) Then Err.Raise(-1, , "Invalid ""To"" Date")
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntToTime) Or IsDBNull(vntToTime) Or vntToTime = vbNullString Then
            strToTime = vbNullString
        Else
            strToTime = VB6.Format(vntToTime, "hh:nn")
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntScreens) Or IsDBNull(vntScreens) Then
            strScreens = vbNullString
        Else
            strScreens = UCase(vntScreens)
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntAssociates) Or IsDBNull(vntAssociates) Then
            strAssociates = vbNullString
        Else
            strAssociates = vntAssociates
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntViews) Or IsDBNull(vntViews) Then
            strViews = vbNullString
        Else
            strViews = vntViews
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntCategories) Or IsDBNull(vntCategories) Then
            strCategories = vbNullString
        Else
            strCategories = vntCategories
        End If

        'UPGRADE_WARNING: Use of Null/IsNull() detected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="2EED02CB-5C0E-4DC1-AE94-4FAA3A30F51A"'
        'UPGRADE_WARNING: IsEmpty was upgraded to IsNothing and has a new behavior. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
        If IsNothing(vntServers) Or IsDBNull(vntServers) Then
            strServers = vbNullString
        Else
            strServers = UCase(vntServers)
        End If

        Dim objCallRS As New clsCallRS
        If ObjContext Is Nothing Then
            objCallRS = CreateObject("DSCD.clsCallRS")
        Else
            objCallRS = ObjContext.CreateInstance("DSCD.clsCallRS")
        End If

        Dim arrTemp As Object

        arrTemp = vbNullString

        Dim inxRow As Integer
        Dim inxCol As Integer
        Dim inx As Integer
        Dim arrColumnNames As Object

        arrColumnNames = vbNullString
        Dim arrReturnArray As Object

        arrReturnArray = vbNullString
        Dim vntCount As Object = 0
        Dim objRS As Object

        'Build SQL
        Dim strQuote As String
        Dim strSQL As String
        Dim strSQLDimension1 As String
        Dim strSQLDimension2 As String
        Dim strSQLCriteria As String
        Dim strSQLWhere As String
        strSQLWhere = vbNullString

        If strFromDate <> vbNullString Then
            If strSQLWhere <> vbNullString Then
                strSQLWhere = strSQLWhere & " AND sau.dml_ts >= TO_DATE('" & strFromDate
            Else
                strSQLWhere = strSQLWhere & "sau.dml_ts >= TO_DATE('" & strFromDate
            End If
            If strFromTime = vbNullString Then
                strSQLWhere = strSQLWhere & "', 'YYYY-MM-DD')" & vbCrLf
            Else
                strSQLWhere = strSQLWhere & " " & strFromTime & "', 'YYYY-MM-DD HH24:MI:SS')" & vbCrLf
            End If
        End If
        If strToDate <> vbNullString Then
            If strSQLWhere <> vbNullString Then
                strSQLWhere = strSQLWhere & " AND sau.dml_ts <= TO_DATE('" & strToDate
            Else
                strSQLWhere = strSQLWhere & "sau.dml_ts <= TO_DATE('" & strToDate
            End If
            If strToTime = vbNullString Then
                strSQLWhere = strSQLWhere & "', 'YYYY-MM-DD')" & vbCrLf
            Else
                strSQLWhere = strSQLWhere & " " & strToTime & "', 'YYYY-MM-DD HH24:MI:SS')" & vbCrLf
            End If
        End If
        If strScreens <> vbNullString Then
            If strSQLWhere <> vbNullString Then
                strSQLWhere = strSQLWhere & " AND "
            End If
            strSQLWhere = strSQLWhere & "sau.url_txt IN ('" & Join(Split(strScreens, ","), "' , '") & "')" & vbCrLf
        End If
        If strAssociates <> vbNullString Then
            If strSQLWhere <> vbNullString Then
                strSQLWhere = strSQLWhere & " AND "
            End If
            strSQLWhere = strSQLWhere & "sau.asoc_global_id IN (" & strAssociates & ")" & vbCrLf
        End If
        If strViews <> vbNullString Then
            If strSQLWhere <> vbNullString Then
                strSQLWhere = strSQLWhere & " AND "
            End If
            strSQLWhere = strSQLWhere & "sau.scorecard_view_id IN (" & strViews & ")" & vbCrLf
        End If
        If strCategories <> vbNullString Then
            If strSQLWhere <> vbNullString Then
                strSQLWhere = strSQLWhere & " AND "
            End If
            strSQLWhere = strSQLWhere & "sau.scorecard_category_id IN (" & strCategories & ")" & vbCrLf
        End If
        If strServers <> vbNullString Then
            If strSQLWhere <> vbNullString Then
                strSQLWhere = strSQLWhere & " AND "
            End If
            strSQLWhere = strSQLWhere & "sau.server_nm IN ('" & Join(Split(strServers, ","), "' , '") & "')" & vbCrLf
        End If
        If strSQLWhere <> vbNullString Then strSQLWhere = "WHERE " & strSQLWhere

        If strDimension2 = vbNullString Then

            '1 dimension report
            Select Case strDimension1
                Case "ASSOCIATE"
                    strSQL = " SELECT sau.dml_user_id, Count(sau.dml_user_id)" & vbCrLf
                    strSQL = strSQL & " FROM" & vbCrLf
                    strSQL = strSQL & " scd_application_usages sau" & vbCrLf
                    strSQL = strSQL & strSQLWhere
                    strSQL = strSQL & " GROUP BY" & vbCrLf
                    strSQL = strSQL & " sau.dml_user_id" & vbCrLf
                    strSQL = strSQL & " ORDER BY" & vbCrLf
                    strSQL = strSQL & " Count(sau.dml_user_id) desc, sau.dml_user_id" & vbCrLf
                Case "VIEW", "CATEGORY"
                    strSQLDimension1 = LCase(strDimension1)
                    strSQL = " SELECT" & vbCrLf
                    strSQL = strSQL & " decode(ss.scorecard_" & strSQLDimension1 & "_desc, null, null, ss.scorecard_" & strSQLDimension1 & "_desc)" & vbCrLf
                    strSQL = strSQL & " ,Count(sau.scorecard_" & strSQLDimension1 & "_id)" & vbCrLf
                    strSQL = strSQL & " FROM" & vbCrLf
                    strSQL = strSQL & " scd_application_usages sau," & vbCrLf
                    If strSQLDimension1 = "view" Then
                        strSQL = strSQL & " scorecard_views ss " & vbCrLf
                    Else
                        strSQL = strSQL & " scorecard_categories ss " & vbCrLf
                    End If
                    If strSQLWhere <> vbNullString Then
                        strSQL = strSQL & strSQLWhere
                        strSQL = strSQL & " and "
                    Else
                        strSQL = strSQL & " WHERE"
                    End If
                    strSQL = strSQL & " sau.scorecard_" & strSQLDimension1 & "_id = ss.scorecard_" & strSQLDimension1 & "_id(+)" & vbCrLf
                    strSQL = strSQL & " and (sau.url_txt = 'RESULTS.ASP' OR sau.url_txt = 'SMRESULTS.ASP')" & vbCrLf
                    strSQL = strSQL & " GROUP BY" & vbCrLf
                    strSQL = strSQL & " decode(ss.scorecard_" & strSQLDimension1 & "_desc, null, null, ss.scorecard_" & strSQLDimension1 & "_desc)" & vbCrLf
                    strSQL = strSQL & " ORDER BY" & vbCrLf
                    strSQL = strSQL & " Count(sau.scorecard_" & strSQLDimension1 & "_id) desc" & vbCrLf
                    strSQL = strSQL & " ,decode(ss.scorecard_" & strSQLDimension1 & "_desc, null, null, ss.scorecard_" & strSQLDimension1 & "_desc)" & vbCrLf
                Case Else
                    If strDimension1 = "SERVER" Then
                        strSQLDimension1 = "server_nm"
                    Else
                        strSQLDimension1 = "url_txt"
                    End If

                    strSQL = " SELECT DISTINCT" & vbCrLf
                    strSQL = strSQL & "       sau." & strSQLDimension1 & " As Dimension," & vbCrLf
                    strSQL = strSQL & "       (select count(*) from scd_application_usages sau2 where sau2." & strSQLDimension1 & " = sau." & strSQLDimension1 & ") As Total      " & vbCrLf
                    strSQL = strSQL & " FROM" & vbCrLf
                    strSQL = strSQL & "     scd_application_usages sau" & vbCrLf
                    'If strSQLWhere <> vbNullString Then strSQL = strSQL & " WHERE " & Mid(strSQLWhere, 5)
                    If strSQLWhere <> vbNullString Then strSQL = strSQL & strSQLWhere
                    strSQL = strSQL & " ORDER BY" & vbCrLf
                    strSQL = strSQL & " (select count(*) from scd_application_usages sau2 where sau2." & strSQLDimension1 & " = sau." & strSQLDimension1 & ") desc, sau." & strSQLDimension1 & " asc" & vbCrLf
            End Select

            vntSQL = strSQL

            objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

            If vntErrorNumber = 0 Then
                If vntCount > 0 Then
                    ServerStatReport = objRS
                End If
            Else
                Err.Raise(vntErrorNumber, , vntErrorDesc)
            End If
        Else
            '2 dimension report
            If strDimension1 = strDimension2 Then Err.Raise(-1, , "Dimensions Must Be Different")

            'Get Column Names
            Select Case strDimension2
                Case "ASSOCIATE"
                    strSQLDimension2 = "asoc_global_id"
                    strSQLCriteria = strAssociates
                    strSQL = " SELECT DISTINCT"
                    strSQL = strSQL & " sau.asoc_global_id As GUID," & vbCrLf
                    strSQL = strSQL & " sau.dml_user_id As Dimension2 " & vbCrLf
                    strSQL = strSQL & " FROM" & vbCrLf
                    strSQL = strSQL & " scd_application_usages sau" & vbCrLf
                    'If strSQLCriteria <> vbNullString Then strSQL = strSQL & " WHERE sau.asoc_global_id IN (" & strSQLCriteria & ")" & vbCrLf
                    If strSQLWhere <> vbNullString Then strSQL = strSQL & strSQLWhere
                    strSQL = strSQL & " ORDER BY" & vbCrLf
                    strSQL = strSQL & " dml_user_id" & vbCrLf
                Case "VIEW", "CATEGORY"
                    strSQLDimension2 = LCase(strDimension2)
                    If strDimension2 = "VIEW" Then
                        strSQLCriteria = strViews
                    Else
                        strSQLCriteria = strCategories
                    End If
                    strSQL = " SELECT DISTINCT" & vbCrLf
                    strSQL = strSQL & "       sau.scorecard_" & strSQLDimension2 & "_id as ID," & vbCrLf
                    strSQL = strSQL & "       DECODE(ss.scorecard_" & strSQLDimension2 & "_desc, NULL, NULL, ss.scorecard_" & strSQLDimension2 & "_desc) as Dimension2" & vbCrLf
                    strSQL = strSQL & " FROM" & vbCrLf
                    strSQL = strSQL & " 	scd_application_usages sau," & vbCrLf
                    If strSQLDimension2 = "view" Then
                        strSQL = strSQL & " 	scorecard_views ss " & vbCrLf
                    Else
                        strSQL = strSQL & " 	scorecard_categories ss " & vbCrLf
                    End If
                    'strSQL = strSQL &  " WHERE" & vbCrLf
                    'strSQL = strSQL &  "      NOT sau.scorecard_" & strSQLDimension2 & "_id IS NULL" & vbCrLf
                    'If strSQLCriteria <> vbNullString Then strSQL = strSQL &  "  and sau.scorecard_" & strSQLDimension2 & "_id IN (" & strSQLCriteria & ")" & vbCrLf
                    If strSQLWhere = vbNullString Then
                        strSQL = strSQL & " WHERE" & vbCrLf
                    Else
                        strSQL = strSQL & strSQLWhere & " AND "
                    End If
                    strSQL = strSQL & "      NOT sau.scorecard_" & strSQLDimension2 & "_id IS NULL" & vbCrLf
                    strSQL = strSQL & "  and sau.scorecard_" & strSQLDimension2 & "_id = ss.scorecard_" & strSQLDimension2 & "_id(+) " & vbCrLf
                    If strDimension2 = "VIEW" Then
                        strSQLDimension2 = "scorecard_view_id"
                    Else
                        strSQLDimension2 = "scorecard_category_id"
                    End If
                Case Else
                    strSQLCriteria = vbNullString
                    If strDimension2 = "SCREEN" Then
                        strSQLDimension2 = "url_txt"
                        strSQLCriteria = Join(Split(strScreens, ","), "' , '")
                    Else
                        strSQLDimension2 = "server_nm"
                        strSQLCriteria = Join(Split(strServers, ","), "' , '")
                    End If
                    strSQL = " SELECT DISTINCT"
                    strSQL = strSQL & " sau." & strSQLDimension2 & " As Dimension2" & vbCrLf
                    strSQL = strSQL & " FROM" & vbCrLf
                    strSQL = strSQL & " scd_application_usages sau" & vbCrLf
                    'If strSQLCriteria <> vbNullString Then strSQL = strSQL & " WHERE sau." & strSQLDimension2 & " IN ('" & strSQLCriteria & "')" & vbCrLf
                    If strSQLWhere <> vbNullString Then strSQL = strSQL & strSQLWhere
                    strSQL = strSQL & " ORDER BY" & vbCrLf
                    strSQL = strSQL & " sau." & strSQLDimension2 & vbCrLf
            End Select

            vntSQL = strSQL & vbCrLf & vbCrLf

            objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

            If vntErrorNumber = 0 Then
                If vntCount > 0 Then
                    arrColumnNames = objRS
                End If
            Else
                Err.Raise(vntErrorNumber, , vntErrorDesc)
            End If

            If IsArray(arrColumnNames) Then
                Select Case strDimension1

                    Case "ASSOCIATE"
                        strSQLDimension1 = "asoc_global_id"
                        strSQL = " select distinct"
                        strSQL = strSQL & " sau." & strSQLDimension1 & " As GUID," & vbCrLf
                        strSQL = strSQL & " sau.dml_user_id As Dimension2," & vbCrLf
                        Select Case strDimension2
                            Case "SCREEN", "SERVER"
                                strQuote = "'"
                                inxCol = 0
                            Case Else
                                strQuote = vbNullString
                                inxCol = 1
                        End Select
                        ReDim arrReturnArray(UBound(arrColumnNames, 2) + 1, 0)
                        arrReturnArray(0, 0) = vbNullString
                        For inx = LBound(arrColumnNames, 2) To UBound(arrColumnNames, 2)
                            arrReturnArray(inx + 1, 0) = arrColumnNames(inxCol, inx)
                            'strSQL = strSQL &  " (select count(*) from scd_application_usages sau2 where sau2." & strSQLDimension1 & " = sau." & strSQLDimension1 & " and sau2." & strSQLDimension2 & " = " & strQuote & arrColumnNames(0, inx) & strQuote & ") As Total" & inx + 1 & vbCrLf
                            strSQL = strSQL & " (select count(*) from scd_application_usages sau2 "
                            If strSQLWhere = vbNullString Then
                                strSQL = strSQL & " where "
                            Else
                                strSQL = strSQL & Replace(strSQLWhere, "sau.", "sau2.") & " and "
                            End If
                            strSQL = strSQL & "sau2." & strSQLDimension1 & " = sau." & strSQLDimension1 & " and sau2." & strSQLDimension2 & " = " & strQuote & arrColumnNames(0, inx) & strQuote & ") As Total" & inx + 1 & vbCrLf
                            If inx < UBound(arrColumnNames, 2) Then strSQL = strSQL & ", "
                        Next
                        strSQL = strSQL & " FROM" & vbCrLf
                        strSQL = strSQL & " scd_application_usages sau" & vbCrLf
                        'If strSQLWhere <> vbNullString Then strSQL = strSQL & " WHERE" & strSQLWhere
                        If strSQLWhere <> vbNullString Then strSQL = strSQL & strSQLWhere
                        strSQL = strSQL & " ORDER BY" & vbCrLf
                        strSQL = strSQL & " sau.dml_user_id" & vbCrLf
                        vntSQL = vntSQL & strSQL

                        objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

                        If vntErrorNumber = 0 Then
                            If vntCount > 0 Then
                                arrTemp = objRS
                                If IsArray(arrTemp) Then
                                    ReDim Preserve arrReturnArray(UBound(arrColumnNames, 2) + 1, UBound(arrTemp, 2) + 1)
                                    For inxRow = LBound(arrTemp, 2) To UBound(arrTemp, 2)
                                        For inxCol = 1 To UBound(arrTemp, 1)
                                            arrReturnArray(inxCol - 1, inxRow + 1) = arrTemp(inxCol, inxRow)
                                        Next
                                    Next
                                End If
                                ServerStatReport = arrReturnArray
                            End If
                        Else
                            Err.Raise(vntErrorNumber, , vntErrorDesc)
                        End If

                    Case "VIEW", "CATEGORY"
                        strSQLDimension1 = LCase(strDimension1)
                        strSQL = " select distinct"
                        strSQL = strSQL & " sau.scorecard_" & strSQLDimension1 & "_id As ID," & vbCrLf
                        strSQL = strSQL & " ss.scorecard_" & strSQLDimension1 & "_desc As Dimension2," & vbCrLf
                        Select Case strDimension2
                            Case "SCREEN", "SERVER"
                                strQuote = "'"
                                inxCol = 0
                            Case Else
                                strQuote = vbNullString
                                inxCol = 1
                        End Select
                        ReDim arrReturnArray(UBound(arrColumnNames, 2) + 1, 0)
                        arrReturnArray(0, 0) = vbNullString
                        For inx = LBound(arrColumnNames, 2) To UBound(arrColumnNames, 2)
                            arrReturnArray(inx + 1, 0) = arrColumnNames(inxCol, inx)
                            'strSQL = strSQL &  " (select count(*) from scd_application_usages sau2 where sau2.scorecard_" & strSQLDimension1 & "_id = sau.scorecard_" & strSQLDimension1 & "_id and sau2." & strSQLDimension2 & " = " & strQuote & arrColumnNames(0, inx) & strQuote & ") As Total" & inx + 1 & vbCrLf
                            strSQL = strSQL & " (select count(*) from scd_application_usages sau2 "
                            If strSQLWhere = vbNullString Then
                                strSQL = strSQL & " where "
                            Else
                                strSQL = strSQL & Replace(strSQLWhere, "sau.", "sau2.") & " and "
                            End If
                            strSQL = strSQL & " sau2.scorecard_" & strSQLDimension1 & "_id = sau.scorecard_" & strSQLDimension1 & "_id and sau2." & strSQLDimension2 & " = " & strQuote & arrColumnNames(0, inx) & strQuote & ") As Total" & inx + 1 & vbCrLf
                            If inx < UBound(arrColumnNames, 2) Then strSQL = strSQL & ", "
                        Next
                        strSQL = strSQL & " FROM" & vbCrLf
                        strSQL = strSQL & " scd_application_usages sau, " & vbCrLf
                        If strDimension1 = "VIEW" Then
                            strSQL = strSQL & " scorecard_views ss " & vbCrLf
                        Else
                            strSQL = strSQL & " scorecard_categories ss " & vbCrLf
                        End If
                        'If strSQLWhere <> vbNullString Then strSQL = strSQL & " WHERE" & strSQLWhere
                        If strSQLWhere = vbNullString Then
                            strSQL = strSQL & " WHERE "
                        Else
                            strSQL = strSQL & strSQLWhere & " and "
                        End If
                        strSQL = strSQL & "  sau.scorecard_" & strSQLDimension1 & "_id = ss.scorecard_" & strSQLDimension1 & "_id(+)"
                        strSQL = strSQL & "  and Not sau.scorecard_" & strSQLDimension1 & "_id IS NULL"
                        strSQL = strSQL & " ORDER BY" & vbCrLf
                        strSQL = strSQL & " sau.scorecard_" & strSQLDimension1 & "_id" & vbCrLf
                        vntSQL = vntSQL & strSQL

                        objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

                        If vntErrorNumber = 0 Then
                            If vntCount > 0 Then
                                arrTemp = objRS
                                If IsArray(arrTemp) Then
                                    ReDim Preserve arrReturnArray(UBound(arrColumnNames, 2) + 1, UBound(arrTemp, 2) + 1)
                                    For inxRow = LBound(arrTemp, 2) To UBound(arrTemp, 2)
                                        For inxCol = 1 To UBound(arrTemp, 1)
                                            arrReturnArray(inxCol - 1, inxRow + 1) = arrTemp(inxCol, inxRow)
                                        Next
                                    Next
                                End If
                                ServerStatReport = arrReturnArray
                            End If
                        Else
                            Err.Raise(vntErrorNumber, , vntErrorDesc)
                        End If

                    Case Else
                        If strDimension1 = "SERVER" Then
                            strSQLDimension1 = "server_nm"
                        Else
                            strSQLDimension1 = "url_txt"
                        End If
                        strSQL = " select distinct"
                        strSQL = strSQL & " sau." & strSQLDimension1 & " As Dimension1," & vbCrLf
                        Select Case strDimension2
                            Case "SCREEN", "SERVER"
                                strQuote = "'"
                                inxCol = 0
                            Case Else
                                strQuote = vbNullString
                                inxCol = 1
                        End Select
                        ReDim arrReturnArray(UBound(arrColumnNames, 2) + 1, 0)
                        arrReturnArray(0, 0) = vbNullString
                        For inx = LBound(arrColumnNames, 2) To UBound(arrColumnNames, 2)
                            arrReturnArray(inx + 1, 0) = arrColumnNames(inxCol, inx)
                            'strSQL = strSQL &  " (select count(*) from scd_application_usages sau2 where sau2." & strSQLDimension1 & " = sau." & strSQLDimension1 & " and sau2." & strSQLDimension2 & " = " & strQuote & arrColumnNames(0, inx) & strQuote & ") As Total" & inx + 1 & vbCrLf
                            strSQL = strSQL & " (select count(*) from scd_application_usages sau2 "
                            If strSQLWhere = vbNullString Then
                                strSQL = strSQL & " where "
                            Else
                                strSQL = strSQL & Replace(strSQLWhere, "sau.", "sau2.") & " and "
                            End If
                            strSQL = strSQL & "sau2." & strSQLDimension1 & " = sau." & strSQLDimension1 & " and sau2." & strSQLDimension2 & " = " & strQuote & arrColumnNames(0, inx) & strQuote & ") As Total" & inx + 1 & vbCrLf
                            If inx < UBound(arrColumnNames, 2) Then strSQL = strSQL & ", "
                        Next
                        strSQL = strSQL & " From" & vbCrLf
                        strSQL = strSQL & " scd_application_usages sau" & vbCrLf
                        'If strSQLWhere <> vbNullString Then strSQL = strSQL & " WHERE " & Mid(strSQLWhere, 5)
                        If strSQLWhere <> vbNullString Then strSQL = strSQL & strSQLWhere
                        strSQL = strSQL & " Order by" & vbCrLf
                        strSQL = strSQL & " " & strSQLDimension1 & vbCrLf
                        vntSQL = vntSQL & strSQL

                        objRS = objCallRS.CallRS_NoConn(strSQL, vntCount, vntErrorNumber, vntErrorDesc)

                        If vntErrorNumber = 0 Then
                            If vntCount > 0 Then
                                arrTemp = objRS
                                If IsArray(arrTemp) Then
                                    ReDim Preserve arrReturnArray(UBound(arrTemp, 1), UBound(arrTemp, 2) + 1)
                                    For inxRow = LBound(arrTemp, 2) To UBound(arrTemp, 2)
                                        For inxCol = LBound(arrTemp, 1) To UBound(arrTemp, 1)
                                            arrReturnArray(inxCol, inxRow + 1) = arrTemp(inxCol, inxRow)
                                        Next
                                    Next
                                End If
                                ServerStatReport = arrReturnArray
                            End If
                        Else
                            Err.Raise(vntErrorNumber, , vntErrorDesc)
                        End If
                End Select
            Else
                ServerStatReport = vbNullString
            End If
        End If
        Exit Function

ServerStatReport_Err:
        ServerStatReport = vbNullString
        vntErrorNumber = Err.Number
        vntErrorDesc = Err.Description & strErrWhere
    End Function
End Class