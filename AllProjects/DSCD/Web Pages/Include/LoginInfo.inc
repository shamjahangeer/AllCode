<%
Dim DSCD_Port,ServerPath,HomeUrl,DSCD_Schema,CSS_Schema,CSS_AppName
Dim vntServer
Dim vntDomain
dim vntExist

vntServer = Request.ServerVariables("Server_Name")
vntExist = instr(vntServer, ".")
if vntExist <> 0 then
	vntDomain = right(vntserver, len(vntServer) - (vntExist -1))
else
	'vntDomain = ".amp.com"
	vntDomain = ".us.tycoelectronics.com"
end if
'Development and Integration
'DSCD_Port = "gator" & vntDomain & ":3000"
'ServerPath = "http://" + Request.ServerVariables("Server_Name") + appPath
'HomeUrl = Application("Home")
'DSCD_Schema = "GATOR_GDWD1"
'CSS_Schema = "/css_web/owa/css_login"
'CSS_AppName = "SCD"

'Training
'DSCD_Port = "scorpion" & vntDomain & ":6666"
'ServerPath = "http://" + Request.ServerVariables("Server_Name") + appPath
'HomeUrl = Application("Home")
'DSCD_Schema = "Gator_GDWTR"
'CSS_Schema = "/css_web_trn/owa/css_login"
'CSS_AppName = "DSCD"

'Volume Test
'DSCD_Port = "buzzard" & vntDomain & ":7777" machine is removed 
'DSCD_Port = "us038ap41.us.tycoelectronics.com:7779"
'ServerPath = "http://" + Request.ServerVariables("Server_Name") + appPath
'HomeUrl = Application("Home")
'DSCD_Schema = "Scorpion_GDWV2"
'CSS_Schema = "/css_web/owa/css_login"
'CSS_AppName = "SCD"

'Production
'DSCD_Port = "eclipse" & vntDomain & ":3000"
'DSCD_Port = "css" & vntDomain & ":7779"
'DSCD_Port = "us038ap41.us.tycoelectronics.com:7779"
'DSCD_Port = "css.us.tycoelectronics.com:7779"
ServerPath = "http://" + Request.ServerVariables("Server_Name") + appPath
HomeUrl = Application("Home")
'DSCD_Schema = "eclipse_gdwp3"
DSCD_Schema = "TEDWEB_PRD"
'CSS_Schema = "/css_web/owa/css_login"
CSS_AppName = "SCD"

DSCD_Port = "https://gs3.tycoelectronics.com/Login/Authenicate.aspx"
CSS_ENV = "PROD"
CSS_AUTHTYPE = "OID"
CSS_INSTANCE = "SOLAR_GDWP2"
%>
