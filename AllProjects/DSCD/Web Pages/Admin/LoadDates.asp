<%@ Language=VBScript %>
<% Option Explicit %>
<% Response.Buffer = True %>
<% Session.Timeout = 240 
   Response.Expires = 0	%>
<!--#include file=include/colors.inc-->
<!--#include file=include/security.inc-->
<!--#include file=include/constants.inc-->
<!--#include file=include/ServerStats.inc-->
<!--#include file=include/GetBrowserVersion.inc-->
<%
'Declare your variables
dim objError
dim objRet
Dim errWhere
dim errDesc
dim objList			
dim vntArray		
dim vntErrorNumber	
dim vntErrorDesc	
dim vntSql			
dim intCount		
dim vntColorNow		
dim strBrowser	
dim strVer		
dim strOS		

'Initialize your variables	
objError = 0
errWhere = ""
errDesc = ""

'Uncomment when security matters
If Not MrSecurity Then
  Response.Redirect Application("Login")
End If
GetBrowserVersion strBrowser, strVer, strOS
Select Case Request.Form("Submit")
Case "Return"
	Response.Redirect strServerUrl & appPath & Application("Home")
end select

Function GenHtmlHead()
	response.write "<html>"
	response.write "<head>"
	response.write "<meta NAME=""GENERATOR"" Content=""Microsoft Visual InterDev 1.0"">"
	response.write "<title>" & Application("AppAbrv") & " - " & "Last Database Load Dates</title>"
	response.write "</head>"
%>
	<!--#include file=include/NavBegin.inc-->
<%
	response.write "<td width=""5%"" align=center><a href=" & strServerUrl & appPath & Application("Home") & ">Home</a></td>"
	response.write "<td width=""20%"">&nbsp;</td>"
	response.write "<td width=""20%"">&nbsp;</td>"
	response.write "<td width=""20%"">&nbsp;</td>"
	response.write "<td width=""5%"" align=""center"">"
	response.write "<a href=" & strServerUrl & appHelp & Application("Help") & " target=""Help Window"">Help</a>"
	response.write "</td>"
%>
	<!--#include file=include/NavMiddle.inc-->
<%
	response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Last Database Load Dates</b></font></td>"
%>
	<!--#include file=include/NavEnd.inc-->
<%

end function

Function GenNavButtons()
Response.Write "<form name=""frmLoadDates"" ACTION=""LoadDates.asp"" method=""POST"">"
	Response.Write "<table width=""100%"" border=""0"">" & vbcrlf
	Response.Write "<tr>" & vbcrlf
	Response.Write "    <td ALIGN=""left"" width=""10%"">" & vbcrlf
	Response.Write "    <input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Return""></td>" & vbcrlf
	Response.Write "    <td ALIGN=""right"" width=""40%"">" & vbcrlf
	Response.Write "    <td ALIGN=""right"" width=""40%"">" & vbcrlf
	Response.Write "</tr>" & vbcrlf	
	Response.Write "</TABLE>"
	Response.Write sHr
End Function
'*********************************************************************************************************
'Here are the values of vntArray Function GetCustomerList()
'*********************************************************************************************************
'Org ID - Org Desc			vntArray(0)	
'Database Load Date			vntArray(1)	
'*********************************************************************************************************
Function GetLoadDates()
	set objList = server.CreateObject ("DSCD.clsLoadDates")
	vntArray = objList.ListDates(vntErrorNumber,vntErrorDesc,vntSql)
	Set objList = nothing
end function

Function PaintLoadDates()
	vntColorNow = sRow1Color
	intcount = 0
	With Response
		.Write "<table border=""1"" cellspacing=""0"" width=""100%"">"
  			.Write "<tr" & sTableHeadBg & ">"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>Reporting Organization</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Lastest Data Loaded</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Date/Time Processed (US EST)</th>"          		
			.Write "</tr>"
		For intCount = 0 to Ubound(vntArray)
			.Write "<tr" & vntColornow & ">"
		     	.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,0) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,1) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(intCount,2) & "&nbsp;</td>"      			
   			.Write "</tr>"
   			if vntColorNow= srow1color then
				vntColorNow = srow2color
			else
				vntColorNow = srow1color
			end if
   		next	
   		Response.Write "</table>"
	end with
end Function

Function PaintNoResults()
	Response.Write "<br><strong><font size=6 color=red>Sorry...</font></strong><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;Database Load Dates are not available at this time. <br><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;Please click on the " & """" & "Return Button" & """" & "<BR>"
	Response.Write "to go back to the Home Screen.<br>"
	Response.Write "Error Number: " & vntErrorNumber & "<br>"
	Response.Write "Error Desc: " & vntErrorDesc & "<br>"
End Function 

Function CloseTags()
	Response.Write "</form>"
	Response.Write "</html>"
end function

'**********************************************************************************************************
'************************** DRIVER FUNCTIONS BASED UPON CATEGORY ******************************************
'**********************************************************************************************************
GenHtmlHead()
GenNavButtons()
GetLoadDates()
if isNull(vntArray) then
	PaintNoResults()
else
	PaintLoadDates()
end if
GenNavButtons()
if Session("AdminUser") = "true" then
	Response.Write "Sql: " & vntSql & "<br>"
end if
CloseTags()
%>
<!--#include file=include/errHandler.inc-->
