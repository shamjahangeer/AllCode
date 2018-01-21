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
dim	arrParam
dim strSelectedValue
dim strMode

'Initialize your variables	
objError = 0
errWhere = ""
errDesc = ""
strSelectedValue = Request.Form("RowSelected")

'Uncomment when security matters
Dim blnDebug
	blnDebug = False
'	blnDebug = True

'Uncomment when security matters
If Not MrSecurity Then
	If blnDebug Then
		'Testing
		lsUID = "434535"
		lsAmpID = "AMP51727"
	Else
		Response.Redirect Application("Login")
		Response.End
    End If
End If

GetBrowserVersion strBrowser, strVer, strOS
strMode = Request.Form("Submit")
Select Case strMode
Case "Return"
	Response.Redirect strServerUrl & appPath & Application("Home")
Case "Select"
	arrParam = Split(strSelectedValue, "|")
	set objList = server.CreateObject ("DSCD.clsUser")
	vntArray = objList.UpdateOrgIDPref(lsUID,lsAmpID,arrParam(1),arrParam(0),vntErrorNumber,vntErrorDesc)
	Set objList = nothing
	If vntArray Then
		Response.Redirect strServerUrl & appPath & "search.asp"
	Else
		strMode = "UpdError"
	End If
Case Else
	strMode = "Display"	
end select

Function GenHtmlHead()
	response.write "<html>"
	response.write "<head>"
	response.write "<meta NAME=""GENERATOR"" Content=""Microsoft Visual InterDev 1.0"">"
	response.write "<title>" & Application("AppAbrv") & " - " & "Org Code to Org Id Cross Reference</title>"
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
	response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Org Code to Org Id Cross Reference</b></font></td>"
%>
	<!--#include file=include/NavEnd.inc-->
<%

end function

Function GenNavButtons()
	Response.Write "<form name=""frmOrgCdeXref"" ACTION=""OrgCodeXref.asp"" method=""POST"">"
	Response.Write "<table width=""100%"" border=""0"">" & vbcrlf
	Response.Write "<tr>" & vbcrlf
	Response.Write "    <td ALIGN=""left"" width=""5%"">" & vbcrlf
	Response.Write "    <input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Return""></td>" & vbcrlf
	if strMode = "Display" then
		Response.Write "    <td ALIGN=""left"" width=""5%"">" & vbcrlf
		Response.Write "    <input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Select"" onclick=""return(IsOrgIDSelected(document.forms[0].RowSelected));""></td>" & vbcrlf	
	end if
	Response.Write "    <td ALIGN=""right"" width=""45%"">" & vbcrlf
	Response.Write "    <td ALIGN=""right"" width=""45%"">" & vbcrlf
	Response.Write "</tr>" & vbcrlf	
	Response.Write "</TABLE>"
	Response.Write sHr
End Function
'*********************************************************************************************************
'Here are the values of vntArray Function GetCustomerList()
'*********************************************************************************************************
'Org Code			vntArray(0)	
'Org Type			vntArray(1)	
'Org ID				vntArray(2)	
'Org Short Nm		vntArray(3)	
'*********************************************************************************************************
Function GetOrgCodes()
	set objList = server.CreateObject ("DSCD.clsOrgs")
	vntArray = objList.ListOrgCodes(vntErrorNumber,vntErrorDesc)
	Set objList = nothing
end function

Function PaintOrgCodes()
	vntColorNow = sRow1Color
	intcount = 0
	With Response
		.Write "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"
  			.Write "<tr" & sTableHeadBg & ">"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>&nbsp;</th>"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>Org Code</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Org Type</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Org Id</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Org Name</th>"
			.Write "</tr>"
		For intCount = 0 to Ubound(vntArray, 2)
			.Write "<tr" & vntColornow & ">"
		     	.Write "<td ALIGN=""center""><input type=""radio"" name=""RowSelected"" id=""RowSelected"" value=""" & _
						vntArray(2, intCount) & "|" & vntArray(4, intCount) & """></td>"
		     	.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(0, intCount) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(1, intCount) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(2, intCount) & "&nbsp;</td>"
       			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(3, intCount) & "&nbsp;</td>"
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
	Response.Write "&nbsp;&nbsp;&nbsp;Org Code to Org ID Xref is not available at this time. <br><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;Please click on the " & """" & "Return Button" & """" & "<BR>"
	Response.Write "to go back to the Home Screen.<br>"
	Response.Write "Error Number: " & vntErrorNumber & "<br>"
	Response.Write "Error Desc: " & vntErrorDesc & "<br>"
End Function

Function PaintUpdateError()
	GenHtmlHead()
	GenNavButtons()
	Response.Write "<br><strong><font size=6 color=red>Sorry...</font></strong><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;Error was encountered when updating user preference table. <br><br>"
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
If strMode = "Display" then
	GenHtmlHead()
	GetOrgCodes()	
	if isNull(vntArray) then
		strMode = "LoadError"	
		GenNavButtons()
		PaintNoResults()
	else
		GenNavButtons()
		PaintOrgCodes()
		GenIsOrgIDSelected
		GenNavButtons()		
	End If
Elseif strMode = "UpdError" then
	PaintUpdateError
end if
CloseTags()
%>
<!--#include file=include/errHandler.inc-->
<%
Sub GenIsOrgIDSelected()
%>
<script language="javascript">
<!--
	function IsOrgIDSelected(theControl){

		var blnChecked = false;

		if(theControl.length){
			for(var i=0; i < theControl.length;i++){
				if(theControl[i].checked){
					blnChecked = true;
					break;
			}	}
		}
		else{
			blnChecked = theControl.checked;
		}

		if(!(blnChecked))	alert('Please select a row');
		return blnChecked;
	}

//	-->
</script>
<%
End Sub
%>