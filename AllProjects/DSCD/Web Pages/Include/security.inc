<%
Dim MrSecurity,lsUID,lsAMPId, security_objUser, security_vntErrorNumber, security_vntErrorDesc, security_blnRC

MrSecurity = False

if request.cookies("Username_ASP") <> "" then
	if request.cookies("GED_AGI") <> "GUID_NOT_FOUND"  then
		lsAMPId = request.cookies("Username_ASP")
		lsUID = request.cookies("GED_AGI")
		MrSecurity = True
	else
		lsAMPId = request.cookies("Username_ASP")
		Set security_objUser = Server.CreateObject("dscd.clsUser")
		security_blnRC = security_objUser.GetGlobalID(lsAmpId, lsUID, security_vntErrorNumber, security_vntErrorDesc)
		Set security_objUser = Nothing
		If security_blnRC And security_vntErrorNumber = 0 Then
			Response.Cookies("GED_AGI") = lsUID
			MrSecurity = True
		Else
			MrSecurity = False
		End If
	end if
end if

'If (MrSecurity=False) Then
'  Response.Redirect Application("Login")
'End If
%>