<%
Function GetBrowserVersion(strBrowserNameOut, strVersionOut, strOSOut)

	Dim SvrVarCollection
	Set SvrVarCollection = Request.ServerVariables
	Dim ua, os
	Dim AnyIE, AnyNetscape, BetaVer
	Dim SC1, SC2, MB, MP
	Dim intPos

	''''''''''''''''''''
	' Server Variables '
	''''''''''''''''''''

		ua  = SvrVarCollection("HTTP_USER_AGENT")
		os  = SvrVarCollection("HTTP_UA_OS")


	'''''''''''''''''''''''''
	' Determine the Browser '
	'''''''''''''''''''''''''

		AnyIE = False
		AnyNetscape = False

		Dim i, strChar

		intPos = Instr(ua, "MSIE")
		If intPos > 0 Then

			AnyIE = True

			For i = intPos + 5 to Len(ua)
				strChar = Mid(ua, i, 1)
				If strChar = ";" Then Exit For
				strVersionOut = strVersionOut & strChar
			Next
		Else

			intPos = Instr(ua, "Mozilla")
			If intPos > 0 And Instr(ua, "compatible") = 0 Then

				AnyNetscape = True

				For i = intPos + 8 to Len(ua)
					strChar = Mid(ua, i, 1)
					If strChar <> "." And Not IsNumeric(strChar) Then Exit For
					strVersionOut = strVersionOut & strChar
				Next
			End If
		End If

	'''''''''''''''''''''
	' Determine if Beta '
	'''''''''''''''''''''
		BetaVer = False

		SC1 = Instr(ua, ";")
		SC2 = Instr(SC1 + 1, ua, ";")
		MB = Instr(SC1 + 1, ua, "b")
		MP = Instr(SC1 + 1, ua, "p")

		If (AnyIE And ((MB > SC1 And MB < SC2) Or (MP > SC1 And MP < SC2))) Or (AnyNetscape And Instr(ua, "b") < SC1) Then
		BetaVer = True
		End If


		If AnyIE Then
			strBrowserNameOut = "Microsoft Internet Explorer"
			If BetaVer Then strBrowserNameOut = strBrowserNameOut & " Beta"
		ElseIf AnyNetscape Then
			strBrowserNameOut = "Netscape Navigator"
		Else
			strBrowserNameOut = "Unknown"
		End If

	''''''''''''''''''''
	' Determine the OS '
	''''''''''''''''''''

		If InStr(ua, "Windows 95") > 0 Or InStr(ua, "Win95") > 0 Then
			strOSOut = "Windows 95"
		ElseIf InStr(ua, "Windows 98") > 0 Or InStr(ua, "Win98") > 0 Then
			strOSOut = "Windows 98"
		ElseIf InStr(ua, "Windows 3.1") > 0 Or InStr(os, "Win16") > 0 Then
			strOSOut = "Windows 3.1 or Windows 3.51"
		ElseIf InStr(ua, "NT") > 0 Or InStr(os, "NT") > 0 Then
			strOSOut = "Windows NT"
		ElseIf InStr(ua, "Mac") > 0 Then
			If InStr(ua, "PowerPC") > 0 Or InStr(ua, "PPC") > 0 Or _
			   InStr(ua, "68000") > 0 Or InStr(ua, "68K") > 0 Then

				strOSOut = "Macintosh"
			End If
		ElseIf InStr(ua, "X11") > 0 Then
			strOSOut = "Unix"
		Else
			strOSOut = "Unknown"
		End If

End Function
%>