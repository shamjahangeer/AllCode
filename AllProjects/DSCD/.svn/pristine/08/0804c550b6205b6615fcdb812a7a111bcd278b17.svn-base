<SCRIPT LANGUAGE="VBScript" RUNAT="Server">

	' Get NTLM Authenticated User ID
	StrUser = ucase(request.servervariables("AUTH_USER"))

	if len(StrUser) > 0 then

		' Strip Domain Prefix
		lngPos = InStr(1, StrUser, "\", 1)
		If lngPos > 0 Then
			StrUser = Mid(StrUser, lngPos + 1)
		end if

		Session("Username_ASP") = StrUser

		' Set Username_ASP to skip Authentication
		Response.Cookies("Username_ASP") = StrUser

		' GED_AGI = GUID_NOT_FOUND triggers call for Authorization
		Response.Cookies("GED_AGI") = "GUID_NOT_FOUND"

	end if

	Response.Redirect(Session("OriginalRequestURL") & "?" & Session("OriginalRequestQuery"))

</SCRIPT>