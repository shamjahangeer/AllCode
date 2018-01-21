Option Strict Off
Option Explicit On
Module basMain

    Public Const CONNECT_USERID As String = "scd_web"

    ' Old Fixed Password
    '    Public Const CONNECT_PASSWORD As String = "scd_delivery"

    'QA Configuration - Uncomment either QA or PROD CONNECT_PASSWORD
    'Web Site:   http://usy90wb46.us.tycoelectronics.com/dscd/ 
    'Web Folder: \\usy90wb46\dscd
    'DLL Folder: \\usy90wb46\MTSPackages
    'DLL Admin:  http://usy90wb46/WebSiteAdmin/
    'Scorpion
    'Public Const CONNECT_PASSWORD As String = "Scdbmw2011"

    'PROD Configuration - Uncomment either QA or PROD CONNECT_PASSWORD
    'Web Site:   http://us194wb06.us.tycoelectronics.com/dscd/login.asp
    'Web Folder: \\us194wb06\dscd
    'DLL Folder: \\us194wb06\MTSPackages
    'DLL Admin:  http://us194wb06/WebSiteAdmin/
    'Solar
    Public Const CONNECT_PASSWORD As String = "Scdporche2011"

    Public CONNECTION_ESTABLISHED As Boolean = False
    Public CONNECT_DSN As String = ""

    Public objConnectionGbl As New ADODB.Connection

	' Keep a global object on the thread to
	' keep the project from unloading when
	' the last reference to it goes away
	' It has to be public to trick VB into
	' thinking that the thread is not done
	
    Public gt_objDummy As New ThreadDummy
	'UPGRADE_NOTE: Main was upgraded to Main_Renamed. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
    Public Sub Main_Renamed()

        ' First line of code should be to instantiate
        ' the dummy class. Be sure to set the Sun Main
        ' as the Startup Object in the project properties.

        gt_objDummy = New ThreadDummy

    End Sub
End Module