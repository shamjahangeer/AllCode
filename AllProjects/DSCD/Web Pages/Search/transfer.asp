<%@ Language=VBScript %>
<%Response.Buffer = true
Response.Expires = 0
%>
<!--#include file=include/GetBrowserVersion.inc-->

<%
vntFileName = Request.QueryString("file")

GetBrowserVersion strBrowserNameOut, strVersionOut, strOSOut

'If the user has Netscape then there will be a problem with the excel opening up automatically.
'Therefore we will provide a link.
'vntIE = Request.ServerVariables ("HTTP_USER_AGENT")
if instr(strBrowserNameOut, "Explorer") = 0 then
	Response.Write "<br>"
	Response.Write "<B>Netscape Users Click to download EXCEL file<B> <a href=" & """" & strserverurl & appPath & "export/" & vntFileName & """" & ">DownLoad</a>"
end if

%>