<%@ Language=VBScript %>
<% Response.Expires = 0 %>
<!--#include file=include/colors.inc-->
<!--#include file=include/constants.inc-->
<!--#include file=include/LoginInfo.inc-->
<!--#include file=include/security.inc-->
<%
goUrl = Request.QueryString("goUrl")
goToUrl = strServerUrl & appPath & "home.asp"
helpUrl = strServerUrl & appPath & "help/dscdhelp.htm"
'if goUrl <> "" then goToUrl = goToUrl & "?goUrl=" & server.URLencode(goUrl)

dim found
dim DomainChange
DomainChange = false
found = instr(Ucase(goToUrl),"AMP.COM")
if found > 0 then
	goToUrl = replace(UCASE(goToUrl),"AMP.COM","us.tycoelectronics.com")
	DomainChange = true
end if
found = 0
found = instr(Ucase(goUrl),"AMP.COM")
if found > 0 then
	goUrl = replace(ucase(goUrl),"AMP.COM","us.tycoelectronics.com")
	DomainChange = true
	'response.write "In GOURL :" & goUrl & "<br>"
end if

if DomainChange then
	goToUrl = replace(lcase(goToUrl),"home.asp","login.asp") & "?goUrl=" & server.URLencode(goUrl) 'goUrl
	'gourl = server.URLencode(goUrl)
	'response.write "DomainChange " & gotoUrl & "<br> "
	Response.Redirect goToUrl
else
	goToUrl = goToUrl & "?goUrl=" & server.URLencode(goUrl)
'else
'	if goUrl <> "" then goToUrl = goToUrl & "?goUrl=" & server.URLencode(goUrl)
end if

if mrSecurity then
	if goUrl <> "" then
		Response.Redirect goUrl
	else
		'goToUrl = strServerUrl & appPath & Application("Home")
		Response.Redirect goToUrl
	end if
else
	if goUrl = "" then
		'goToUrl = strServerUrl & appPath & Application("Home")
	else
		goToUrl = goUrl
	end if
end if
Response.Write "<HTML>"
Response.Write "<HEAD>"
Response.Write "<META NAME=""GENERATOR"" Content=""Microsoft Visual Studio 6.0"">"
Response.Write "</HEAD>"
Response.Write "<body bgcolor=""#FFFFFF"""
Response.Write "ALINK=Lime"
Response.Write "VLINK=Fuchsia"
Response.Write "LINK=Silver"
Response.Write "style=""font-family: Times New Roman, sans-serif"" onLoad=SetDefault()>" & vbcrlf
Response.Write "<form method = ""Post"" action=" & DSCD_Port & CSS_Schema & ">" & vbcrlf

Response.Write "<TABLE WIDTH=75% BORDER=0 CELLSPACING=1 CELLPADDING=1>"
Response.Write "<TR>"
Response.Write "<TD width=20% align=left><IMG SRC=""images/login3.gif"" ALIGN=Left ALT=""DSCD Login""></TD>"
Response.Write "<TD><font size=5><STRONG>Tyco Electronics</STRONG><br>"
Response.Write "<font size=3 color=Navy><STRONG>Global Delivery Scorecard</STRONG></TD>"
Response.Write "</TR>"
Response.Write "</TABLE>"
Response.Write sHr
Response.Write "<br>"
Response.Write "Please enter Your User Id and Password Below"
Response.Write "<br>"
Response.Write "<br>"
Response.Write "<TABLE WIDTH=75% BORDER=0 CELLSPACING=1 CELLPADDING=1>"
Response.Write "<TR>"
Response.Write "<TD align=right width=10% valign=bottom ><b>User:</TD>"
Response.Write "<TD align=left><INPUT type=""text"" id=vntUserId name=user_id_in size=8></TD>"
Response.Write "</TR>"
Response.Write "<TR>"
Response.Write "<TD align=right valign=bottom><b>Password:</TD>"
Response.Write "<TD align=left><INPUT type=""password"" id=vntPassword name=password_in size=8></TD>"
Response.Write "</TR>"
Response.Write "</TABLE>"
Response.Write "<br>"
Response.Write "<font size=3 color=Red><EM>This is a private network that belongs to Tyco Electronics.</EM>"
Response.Write "<br>"
Response.Write "<font size=3 color=Red><EM>Access is <b>RESTRICTED</b> to authorized users only.</EM>"
Response.Write sHr
Response.Write "<TABLE WIDTH=35% BORDER=0 CELLSPACING=1 CELLPADDING=1>"
Response.Write "<TR>"
Response.Write "<TD><INPUT type=""submit"" value=""Login"" id=""cmdLogin"" name=""SUBMIT""></TD>"
Response.Write "<TD><INPUT type=""submit"" value=""Change Password"" id=ChangePass name=""SUBMIT""></TD>"
Response.Write "<TD><INPUT type=""submit"" value=""Cancel"" id=Cancel name=""SUBMIT""></TD>"
'Response.Write "<TD><INPUT type=""submit"" value=""Help"" id=Help name=""SUBMIT""></TD>"
Response.Write "<TD><INPUT type=""submit"" value=""DSCD Help"" id=Help name=""SUBMIT"" onClick=""return(onHelp_Click());""></TD>"
Response.Write "</TR>"
Response.Write "<TR>"
Response.Write "<TD colspan=2><INPUT type=""button"" value=""Request Access"" id=Access name=Access></TD>"
Response.Write "<TD></TD>"
Response.Write "<TD></TD>"
Response.Write "<TD></TD>"
Response.Write "</TR>"
Response.Write "</TABLE>" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""launcher_name_IN"" VALUE="""">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""number_of_tries_IN"" VALUE=""1"">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""aplctn_name_IN"" VALUE=" & """" & CSS_AppName & """" &">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""GIF_name_IN"" VALUE="""">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""start_name_IN"" VALUE=" & """" & gotoUrl & """" & ">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""request_msg_IN"" VALUE="""">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""role_prefix_IN"" VALUE=""SCD"">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""logged_in_flag_IN"" VALUE=""NO"">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""other_domains_IN"" VALUE="""">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""authenication_type"" VALUE=" & """" & CSS_AUTHTYPE & """" &">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""environment"" VALUE=" & """" & CSS_ENV & """" &">" & vbcrlf
Response.Write "<INPUT TYPE=""hidden"" NAME=""instance"" VALUE=" & """" & CSS_INSTANCE & """" &">" & vbcrlf
Response.Write "</form>"
'Response.Write "</BODY>"
'Response.Write "</HTML>"
%>

<SCRIPT language="vbscript">
sub Access_OnClick
resp = "http://csa.us.tycoelectronics.com:7779/csa_web/owa/css_cover_page"
window.navigate resp
end sub
</script>

<script language = "JavaScript">
<!--
function SetDefault(){
	document.forms[0].user_id_in.focus()
}

function onHelp_Click(){
	var newwindow = '';
	newwindow = window.open('<%=helpUrl%>','SCDHelp','width=1000,height=800,menubar=1,resizable=1,location=1,status=1,scrollbars=1');
	newwindow.focus();
	return false;
}

// -->
</script>
<!--#include file=include/cert.inc-->
</BODY>
</HTML>
