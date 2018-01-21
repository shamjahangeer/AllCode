<%@ Language=VBScript %>
<% Option Explicit %>
<% Response.Buffer = True %>
<% Session.Timeout = 240 
   Server.ScriptTimeout = 600
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
dim strPartNumber
dim strDescription
dim strSQL
dim strExactMatch
dim vntSessionID

'Initialize your variables	
objError = 0
errWhere = ""
errDesc = ""
strSelectedValue = Request.Form("RowSelected")
strExactMatch = "0"

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

vntSessionID = Request.QueryString ("s")

GetBrowserVersion strBrowser, strVer, strOS

if Session("PartLookupMode") <> "" then
	strMode = Session("PartLookupMode")
	Session("PartLookupMode") = ""	
	strMode = "Display" 
else
	strMode = Request.Form("Submit")
end if
Select Case strMode
Case "Return"
	Session("PartDescription") = null
	Session("PartNumber") = "S"
	Response.Redirect strServerUrl & appPath & "search.asp?s=" & vntSessionID
Case "Select"
	arrParam = Split(strSelectedValue, "|")
	Session("PartPartNumber") = arrParam(0)
	Session("PartPartKeyID") = arrParam(1)
	Session("PartDescription") = null
	Session("PartNumber") = "R"
	Response.Redirect strServerUrl & appPath & "search.asp?s=" & vntSessionID
Case "Submit"
	Session("PartPartNumber")  = Request.Form("PartNumber")
	Session("PartDescription") = Request.Form("Description")
	strPartNumber	= Request.Form("PartNumber")
	strDescription	= Request.Form("Description")
	strMode = "Display"		
Case "Display"
	strExactMatch = "1"
	strPartNumber  = Session("PartPartNumber")
Case Else
	strPartNumber  = Session("PartPartNumber")
	strDescription = Session("PartDescription")	
	strMode = "Input"	
end select

Function GenHtmlHead()
	Dim lsHdr
	response.write "<html>"
	response.write "<head>"
	response.write "<meta NAME=""GENERATOR"" Content=""Microsoft Visual InterDev 1.0"">"
	response.write "<title>" & Application("AppAbrv") & " - " & "Part Number Lookup</title>"
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
	lsHdr = "Part Number Lookup "
	if strMode = "Display" then
		lsHdr = lsHdr + "Results"
	else
		lsHdr = lsHdr + "Criteria"	
	end if
	response.write "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>" & lsHdr & "</b></font></td>"
%>
	<!--#include file=include/NavEnd.inc-->
<%

end function

Function GenNavButtons()
	Response.Write "<form name=""PartNumber"" ACTION=""PartNumber.asp"" method=""POST"">"
	Response.Write "<table width=""75%"" border=""0"" align=""center"">" & vbcrlf
	Response.Write "<tr>" & vbcrlf
	Response.Write "    <td ALIGN=""right"" width=""50%"">" & vbcrlf
	Response.Write "    <input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Return ""></td>" & vbcrlf
	Response.Write "    <td ALIGN=""left"" width=""50%"">" & vbcrlf
	Response.Write "    <input TYPE=""submit"" NAME=""SUBMIT"" VALUE=""Select"" onclick=""return(IsPartSelected(document.forms[0].RowSelected));""></td>" & vbcrlf	
	Response.Write "    <td ALIGN=""right"" width=""45%"">" & vbcrlf
	Response.Write "    <td ALIGN=""right"" width=""45%"">" & vbcrlf
	Response.Write "</tr>" & vbcrlf	
	Response.Write "</TABLE>"
	Response.Write sHr
End Function
'*********************************************************************************************************
'Here are the values of vntArray Function List()
'*********************************************************************************************************
'Part Nbr			vntArray(0)	
'Part Desc			vntArray(1)	
'Part Key ID		vntArray(2)	
'Brand Name			vntArray(3)	
'*********************************************************************************************************
Function GetParts()
	set objList = server.CreateObject ("DSCD.clsPart")
	vntArray = objList.List(strPartNumber,strDescription,strExactMatch,strSQL,vntErrorNumber,vntErrorDesc)

	If Err.Number <> 0 Then
		objError = Err.Number
		errWhere = "GetResults Create Object"
		errDesc = err.description
	elseIf vntErrorNumber <> 0 Then
		objError = vntErrorNumber
		errDesc	= vntErrorDesc
		errWhere = "GetResults Variant Array"
	End If

	If err.number = 0 And objError = 0 Then	
		strMode = "NoRetrieveError"
	end if
	Set objList = nothing
end function

Function PaintParts()
	vntColorNow = sRow1Color
	intcount = 0
	With Response
		.Write "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""75%"" align=""center"">"
  			.Write "<tr" & sTableHeadBg & ">"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>&nbsp;</th>"
     			.Write "<th ALIGN=""center""><font size=""2"" color = White>Part Number</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Part Description</th>"
          		.Write "<th ALIGN=""center""><font size=""2"" color = White>Brand</th>"
			.Write "</tr>"
		For intCount = 0 to Ubound(vntArray, 2)
			.Write "<tr" & vntColornow & ">"
		     	.Write "<td ALIGN=""center""><input type=""radio"" name=""RowSelected"" id=""RowSelected"" value=""" & _
						vntArray(0, intCount) & "|" & vntArray(2, intCount) & """></td>"
		     	.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(0, intCount) & "&nbsp;</td>"
      			.Write "<td ALIGN=""left""><font size=""2"">" & vntArray(1, intCount) & "&nbsp;</td>"
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
	response.write "No records could be found to match the information you entered.<br>"
	response.write "Please use the Continue button to re-enter your information.<br>"
	response.write "<form method=""POST"" id=form1 name=form1>"
	response.write "<input type=""Submit"" name=""Submit"" value=""Continue"">"
	response.write "</form>"
End Function

Function PaintError()
	GenHtmlHead()
	GenNavButtons()
	Response.Write "<br><strong><font size=6 color=red>Sorry...</font></strong><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;Error was encountered when updating user preference table. <br><br>"
	Response.Write "&nbsp;&nbsp;&nbsp;Please click on the " & """" & "Return Button" & """" & "<BR>"
	Response.Write "to go back to the Previous Screen.<br>"
	Response.Write "Error Number: " & vntErrorNumber & "<br>"
	Response.Write "Error Desc: " & vntErrorDesc & "<br>"
End Function  

Function CloseTags()
	Response.Write "</form>"
	Response.Write "</html>"
end function

Function Criteria()
	response.write "<form method=""POST"" action=""PartNumber.asp"" id=form1 name=form1>" & vbcrlf
	response.write "<center>" & vbcrlf
	response.write "<table border=""0"" cellspacing=""1"" width=""100%"">" & vbcrlf
	response.write "<td align=""right"" width=""50%"">" & vbCrLf
    response.write "</tr><tr>" & vbCrLf
    response.write "<td align=""right"" width=""50%""><font size=""2""><b>Part Number:&nbsp;</b></font></td>" & vbCrLf
    response.write "<td align=""left"" width=""50%"">" & vbCrLf
	response.write "<input type=""text"" size=""14"" maxlength=""14"" name=""PartNumber"" value=""" & strPartNumber & """></td>" & vbCrLf
    response.write "</tr><tr>" & vbCrLf
    response.write "<td align=""right"" width=""50%""><font size=""2""><b>Description:&nbsp;</b></font></td>" & vbCrLf
    response.write "<td align=""left"" width=""50%""><input type=""text"" size=""35"" maxlength=""30"" name=""Description"" value=""" & strDescription & """></td>" & vbCrLf
	response.write "</tr></table>"
	response.write sHR

	response.write "<table border=""0"" cellspacing=""1"" width=""100%"">" & vbcrlf
	response.write "<tr>" & vbcrlf
	response.write "<td align=""right"" width=""50%"">" & vbcrlf
	response.write "<input type=""submit"" name=""Submit"" value=""Return"">&nbsp;" & vbcrlf
	response.write "</td><td align=""left"" width=""50%"">" & vbcrlf
	response.write "<input type=""submit"" name=""Submit"" value=""Submit"">" & vbcrlf
	response.write "</td></tr>" & vbcrlf
	response.write "</table>" & vbcrlf
	response.write "</form>" & vbcrlf
	response.write "</center>" & vbcrlf
	response.write "</body>"
	response.write "</head>"		
End Function


'**********************************************************************************************************
'************************** DRIVER FUNCTIONS BASED UPON CATEGORY ******************************************
'**********************************************************************************************************
If strMode = "Display" then
	GenHtmlHead()
	GetParts()	
	if isNull(vntArray) then
		if strMode = "NoRetrieveError" then
			PaintNoResults()
		end if
	else
		if strExactMatch = "1" then
			Response.Write "<strong><font color=red>Found multiple brand for the part number entered, please choose one ...</font></strong>" 
		end if
		GenNavButtons()
		PaintParts()
		GenIsPartSelected
		GenNavButtons()		
	End If
Elseif strMode = "Input" then
	GenHtmlHead()
	Criteria()
end if
CloseTags()
%>
<!--#include file=include/errHandler.inc-->
<%
Sub GenIsPartSelected()
%>
<script language="javascript">
<!--
	function IsPartSelected(theControl){

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

		if(!(blnChecked))	alert('Please select a row!');
		return blnChecked;
	}

//	-->
</script>
<%
End Sub
%>