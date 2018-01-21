<%
dim appPath, appHelp, strServerUrl, vntDomainFound

appPath = Application("AspPath")
appHelp = Application("HelpPath")
strServerUrl = "http://" + Request.ServerVariables("Server_Name")
vntDomainFound = instr(strServerUrl, ".")
if vntDomainFound = 0 then
	'strServerUrl = strServerUrl & ".amp.com"
	strServerUrl = strServerUrl & ".us.tycoelectronics.com"	
end if
%>
