<%
Function ServerStats(vntViewID, vntCatID)
	'on error resume next

    Dim vntAmpID, vntUID, vntUrl, vntExist, vntServer, vntReferer, vntAgent, vntRemoteAddr, vntRemoteHost, objAddStats, blnrc, vntErrorNumber, vntErrorDesc
	vntUrl =  Request.ServerVariables("URL")
	vntExist = 0
	vntExist = instr(vntUrl, "?")
	if vntExist <> 0 then
		vntUrl = left(vntUrl, vntExist - 1)
	end if
	vntExist = 0
	vntExist = instrRev(vntUrl,"/")
	if vntExist <> 0 then
		vntUrl = right(vntUrl, len(vntUrl) - vntExist)
		'Response.Write vntUrl
	end if

	vntServer = Request.ServerVariables("Server_Name")
	vntReferer = Request.ServerVariables("HTTP_REFERER")
	vntAgent = Request.ServerVariables("HTTP_USER_AGENT")
	vntRemoteAddr = Request.ServerVariables("REMOTE_ADDR")
	vntRemoteHost = Request.ServerVariables("REMOTE_HOST")
	'Response.Write vntServer & "<br>"
	'Response.Write vntReferer & "<br>"
	'Response.Write vntAgent & "<br>"
	'Response.Write vntURL & "<br>"
	'Response.Write vntRemoteAddr & "<br>"
	'Response.Write vntRemoteHost & "<br>"

	If vntUID = vbNullString Then vntUID = request.cookies("GED_AGI")
	If vntAmpID = vbNullString Then vntAmpID = request.cookies("Username_ASP")

	vntExist = 0
	vntExist = instr(vntServer, ".")
	if vntExist <> 0 then
		vntServer = left(vntServer, vntExist - 1)
	end if
	vntExist = instr(vntReferer, "?")
	if vntExist <> 0 then
		vntReferer = left(vntReferer, vntExist - 1)
	end if
	vntExist = 0
	vntExist = instrRev(vntReferer,"/")
	if vntExist <> 0 then
		vntReferer = right(vntReferer, len(vntReferer) - vntExist)
		'Response.Write vntReferer & "<br>"
	end if

	set objAddStats = server.CreateObject ("DSCD.clsAdHoc")
	blnrc = objAddStats.InsertStats(vntUID, vntServer, vntReferer, vntAgent, vntUrl, vntRemoteAddr, vntRemoteHost, vntAmpID, vntViewID, vntCatID, vntErrorNumber, vntErrorDesc)

	'If not blnrc then Response.write vntErrorNumber & "<BR>" & vntErrorDesc
End Function
%>
