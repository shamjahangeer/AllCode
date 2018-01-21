Option Strict Off
Option Explicit On

Imports System.EnterpriseServices
<Assembly: ApplicationActivation(ActivationOption.Library)> 

<Transaction(TransactionOption.Disabled)> _
Public Class clsServerInfo
    Inherits ServicedComponent


    '##ModelId=3A92975303AC
    Private Const bPoolSetting As Boolean = False

    '##ModelId=3A929A5F0169
    Private ObjContext As System.EnterpriseServices.ContextUtil

    '##ModelId=3A8BF8EE0052
    Public Function Get_Connection_Info(ByRef strDSN As String, ByRef strUserID As String, ByRef strPassword As String) As Boolean

        Dim intFile As Short
        Dim strServer As String

        On Error GoTo ErrorHandler

        strUserID = CONNECT_USERID
        strPassword = CONNECT_PASSWORD

        If Not CONNECTION_ESTABLISHED Then

            intFile = FreeFile()
            FileOpen(intFile, My.Application.Info.DirectoryPath & "\DSN.txt", OpenMode.Input)

            If Not EOF(intFile) Then
                strServer = LineInput(intFile)
            Else
                strServer = ""
                FileClose(intFile)
                Err.Raise(-1, , "Invalid File Format")
            End If

            FileClose(intFile)

            Select Case UCase(strServer)
                Case "DEV"
                    strDSN = "SCD_Development"
                    'strDSN = "gator_gdwd1"
                Case "PROD"
                    strDSN = "SCD_Production"
                Case "INT"
                    strDSN = "SCD_Integration"
                Case "TRAIN"
                    strDSN = "SCD_Training"
                Case "VOL"
                    strDSN = "SCD_VolumeTest"
                    'strDSN = "scorpion_gdwv2"
                Case "PRODHP"
                    strDSN = "SCD_Eclipse"
                Case Else
                    strDSN = "DSCD_Application"
            End Select

            CONNECTION_ESTABLISHED = True
            CONNECT_DSN = strDSN
        Else
            strDSN = CONNECT_DSN
        End If

        Get_Connection_Info = True

        'ContextUtil.SetComplete()
        Exit Function

ErrorHandler:
        strDSN = ""
        strUserID = ""
        strPassword = ""

        Get_Connection_Info = False

        'If Not ObjContext Is Nothing Then
        'ContextUtil.SetAbort()
        Throw New System.Exception(Err.Description) '"Error occurred while getting DB Env in Get_Connection_Info.")
        'End If

        Exit Function
    End Function

    '##ModelId=3A929E1000D4
    Protected Overrides Sub Activate()

        'UPGRADE_ISSUE: COMSVCSLib.AppServer  .GetObjectContext was not upgraded. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="CC4C7EC0-C903-48FC-ACCC-81861D12DA4A"'
        'ObjContext = GetObjectContext

    End Sub

    '##ModelId=3A929FB002A8
    Protected Overrides Function CanBePooled() As Boolean

        CanBePooled = bPoolSetting

    End Function

    '##ModelId=3A92A23B03AD
    Protected Overrides Sub Deactivate()

        'UPGRADE_NOTE: Object ObjContext may not be destroyed until it is garbage collected. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6E35BFF6-CD74-4B09-9689-3E1A43DF8969"'
        ObjContext = Nothing

    End Sub

    Public Sub Close_Connection()
        If objConnectionGbl.State = ConnectionState.Open Then
            objConnectionGbl.Close()
        End If
    End Sub
End Class