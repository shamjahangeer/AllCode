<%@ Language=VBScript %>
<% Option Explicit %>
<% Response.Buffer = True %>
<% Session.Timeout = 360 
   Response.Expires = 0	%>
<!--#include file=include/colors.inc-->
<!--#include file=include/security.inc-->
<!--#include file=include/constants.inc-->
<%
'Declare your variables
Dim objError
Dim errWhere
Dim errDesc

'Initialize your variables
objError = 0
errDesc = vbNullString
errWhere = vbNullString

Dim blnDebug
	blnDebug = False
'	blnDebug = True

'Uncomment when security matters
If Not MrSecurity Then
	If blnDebug Then
		'Testing
		lsUID = "51727"
		lsAmpID = "AMP51727"
	Else
		Response.Redirect Application("Login")
		Response.End
    End If
End If

Dim strMode
	strMode = "List"

' buttons vars
Dim strReturnBtn, strUpdateBtn, strUpdSubmitBtn, strAddSubmitBtn, strCancelBtn, strAddBtn
	strReturnBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Return"">"
	strUpdateBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Update"" onclick=""return(IsParamIDSelected(document.forms[0].RowSelected, 'Update'));"">"
	strUpdSubmitBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Submit"">"
	strAddSubmitBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Submit"" onclick=""return(CheckNull(document.forms[0]));"">"
	strCancelBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Cancel"">"
	strAddBtn		= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Add"">"

' field vars
Dim vntCommand, vntParamValue, vntParamID, vntParamDesc, vntButton
	vntCommand		= Trim(Request.Form("smtSubmit"))
	vntParamValue	= Trim(Request.Form("txtParamValue"))	
	vntParamID		= Trim(Request.Form("txtParamID"))	
	vntParamDesc	= Trim(Request.Form("txtParamDesc"))	
	vntButton		= Trim(Request.Form("txtButton"))		

' object vars
Dim	objReqParms, vntErrorNum, vntErrorDesc, vntReqParms

' array vars
Dim arrList, arrParam, intParamID, intParamValue, intParamDesc, strSelectedValue
	strSelectedValue = Request.Form("RowSelected")
	intParamID		= 0
	intParamValue	= 1
	intParamDesc	= 2


Function GenHtmlHead()
	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>" & Application("AppAbrv") & " - " & "Required System Parameter Maintenance</title>"
	RwLf "</head>"
	RwLf "<form name=""frmMain"" id=""frmMain"" method=""post"">"	
	RwLf "<body bgcolor=""#FFFFFF"" onLoad=ErrHandler()"
	RwLf " TOPMARGIN=""1"""
	RwLf " ALINK=""Lime"""
	RwLf " VLINK=""Red"""	
	RwLf " LINK=""Red"""
	RwLf "<form name=""frmMain"" id=""frmMain"" method=""post"">"	

	RwLf "<table border=""1"" bordercolor=""" & sNavBorder & """ cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "<td>"
	RwLf "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "	<tr " & sNavTopHeader & ">"
	RwLf "		<td width=""20%"" align=""center""><a href=""home.asp"">Home</a></td>"
	RwLf "		<td width=""20%"">&nbsp;</td>"
	RwLf "		<td width=""20%"">&nbsp;</td>"
	RwLf "		<td width=""20%"">&nbsp;</td>"
	RwLf "		<td width=""20%"" align=""center"">"
	RwLf "		<a href=" & strServerUrl & appHelp & Application("Help") & " target=""Help Window"">Help</a></td>"
%>
	<!--#include file=include/NavMiddle.inc-->
<%
	RwLf "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Required System Parameter Maintenance</b></font></td>"
%>
	<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
End Function

Function GenList()
	Dim intSelect, strColorNow'
	Dim intRow, intCol, arrColHeaders 

	arrColHeaders = Array("Sel", "Parameter ID", "Parameter Value", "Parameter Description", "User ID", "Date Changed")

	If Not IsObject(objReqParms) Then
		Set objReqParms = Server.CreateObject("DSCD.clsReqParms")
		If err.number <> 0 Then
			objError = Err.number
			errDesc = Err.description
			errWhere = "Create Object objReqParms"
			exit function		
		End If
	end if
	
	arrList = objReqParms.List(vntErrorNum, vntErrorDesc)
	If vntErrorNum <> 0 Then
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "retrieving required parameter list"
		exit function
	End If

	RwLf "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"

	'column headers
	RwLf "<tr" & sTableHeadBg & ">"
	For intCol = LBound(arrColHeaders) To UBound(arrColHeaders)
		RwLf "<th align=""center"" valign=""bottom""><font size=""2""" & sTableHeadFont & "><strong>" & arrColHeaders(intCol) & "</strong></font></th>"
	Next
	RwLf "</tr>"
	
	'record details
	strColorNow = sRow1Color
	For intRow = LBound(arrList, 2) To UBound(arrList, 2)
		RwLf "<tr" & strColorNow & ">"	
		RwLf "<td align=""center""><input type=""radio"" name=""RowSelected"" id=""RowSelected"" value=""" & _
					arrList(intParamID, intRow) & "|" & arrList(intParamValue, intRow) & _
					"|" & arrList(intParamDesc, intRow) & """></td>"
		For intCol = LBound(arrList, 1) To UBound(arrList, 1)	
			If isnull(arrList(intCol, intRow)) then 
				RwLf "<td><font size=""2"">" & "&nbsp;" & "</font></td>"						
			else	
				RwLf "<td><font size=""2"">" & arrList(intCol, intRow) & "</font></td>"			
			end if
		Next
	    RwLf "</tr>"
   		if strColorNow= srow1color then
			strColorNow = srow2color
		else
			strColorNow = srow1color
		end if	    
	Next

	RwLf "</table>"
	GenIsParamIDSelected
End Function

Sub GenListScreen()
	GenHtmlHead

	RwLf "<td align=""center"" colspan=""4"">"
	RwLf strReturnBtn & "&nbsp;&nbsp;" & strUpdateBtn& "&nbsp;&nbsp;" & strAddBtn
	RwLf "</td>"

	RwLf "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""2"" align=""center"" name=""tblMain"" id=""tblMain"">"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	GenList

	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<td align=""center"" colspan=""4"">"
	RwLf strReturnBtn & "&nbsp;&nbsp;" & strUpdateBtn& "&nbsp;&nbsp;" & strAddBtn
	RwLf "</td>"
	
	GenFooter
End Sub

Sub GenUpdateScreen()
	GenHtmlHead

	RwLf "<td align=""center"" colspan=""2"">"
	RwLf strUpdSubmitBtn & "&nbsp;&nbsp;" & strCancelBtn
	RwLf "</td>"

	RwLf "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""2"" align=""center"" name=""tblMain"" id=""tblMain"">"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<table border=""0"" cellpadding=""2"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "	<td align=""left"" colspan=""3"" bgcolor=""lightgrey"">"
	RwLf "	<font size=""4"" color=""navy""><b>System Parameter</b></font></td>"
	RwLf "</tr>"
	
	RwLf "<tr" & sRow1Color & ">"
	RwLf "	<td font size=2 align=left>"	
	RwLf "	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>ID:</b>"
	RwLf "	&nbsp;&nbsp" & vntParamID & "</td>"
	RwLf "</tr>"	

	RwLf "<tr>"	
	RwLf "	<td font size=2 align=left>"			
	RwLf "	&nbsp;&nbsp;&nbsp;<b>Desc:</b>"	
	RwLf "	&nbsp;&nbsp;" & vntParamDesc & "</td>"
	RwLf "</tr>"	

	RwLf "<tr>"
	RwLf "	<td font size=2 align=left>"		
	RwLf "	&nbsp;&nbsp;<b>Value:&nbsp;&nbsp;</b>"
	RwLf "	<input type=""text"" size=20 name=""txtParamValue"" id=""txtParamValue"" value=""" & vntParamValue & """>"		
	RwLf "</tr>"	
	
	RwLf "</table>"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<td align=""center"" colspan=""2"">"
	RwLf strUpdSubmitBtn & "&nbsp;&nbsp;" & strCancelBtn
	RwLf "</td>"

	GenCheckNull
	GenFooter
End Sub	

Sub GenAddScreen()
	GenHtmlHead

	RwLf "<td align=""center"" colspan=""2"">"
	RwLf strAddSubmitBtn & "&nbsp;&nbsp;" & strCancelBtn
	RwLf "</td>"

	RwLf "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""2"" align=""center"" name=""tblMain"" id=""tblMain"">"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<table border=""0"" cellpadding=""2"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "	<td align=""left"" colspan=""3"" bgcolor=""lightgrey"">"
	RwLf "	<font size=""4"" color=""navy""><b>System Parameter</b></font></td>"
	RwLf "</tr>"
	
	RwLf "<tr" & sRow1Color & ">"
	RwLf "	<td font size=2 align=left>"	
	RwLf "	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>ID:&nbsp;&nbsp;</b>"
	RwLf "	<input type=""text"" size=15 maxlength=15 name=""txtParamID"" id=""txtParamID"" value=""" & vntParamID & """>"		
	RwLf "</tr>"	

	RwLf "<tr>"	
	RwLf "	<td font size=2 align=left>"			
	RwLf "	&nbsp;&nbsp;&nbsp;<b>Desc:&nbsp;&nbsp;</b>"	
	RwLf "	<input type=""text"" size=20 maxlength=20 name=""txtParamDesc"" id=""txtParamDesc"" value=""" & vntParamDesc & """>"		
	RwLf "</tr>"	

	RwLf "<tr>"
	RwLf "	<td font size=2 align=left>"		
	RwLf "	&nbsp;&nbsp;<b>Value:&nbsp;&nbsp;</b>"
	RwLf "	<input type=""text"" size=20 name=""txtParamValue"" id=""txtParamValue"" value=""" & vntParamValue & """>"		
	RwLf "</tr>"	
	
	RwLf "</table>"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<td align=""center"" colspan=""2"">"
	RwLf strAddSubmitBtn & "&nbsp;&nbsp;" & strCancelBtn
	RwLf "</td>"

	GenCheckNull
	GenFooter
End Sub	

Function GenDisplayError()
	objError	= vntErrorNum
	errDesc		= vntErrorDesc
	If errWhere = vbNullString Then errWhere = "the application"
	GenHTMLHead
	GenFooter
End Function

Function SendHiddenVars()
	If strMode = "Update" Then	
		RwLf "<input type=""hidden"" name=""txtParamID"" id=""txtParamID"" value=""" & vntParamID & """>"	
	End If		
	If strMode = "Add" Then	
		RwLf "<input type=""hidden"" name=""txtParamID"" id=""txtParamID"" value=""" & vntParamID & """>"	
		RwLf "<input type=""hidden"" name=""txtParamDesc"" id=""txtParamDesc"" value=""" & vntParamDesc & """>"			
	End If	
	If strMode = "Update"  or strMode = "Add" Then	
		RwLf "<input type=""hidden"" name=""txtButton"" id=""txtButton"" value=""" & strMode & """>"		
	End If			
End Function

Sub GenFooter()
	SendHiddenVars()
	RwLf "</table>"
	RwLf "</form></body></html>"	
End Sub

Sub Cleanup_Objects()
	If IsObject(objReqParms) then Set objReqParms = Nothing
End Sub

Sub Rw(strIn)
	Response.Write strIn
End Sub

Sub RwLf(strIn)
	Response.Write strIn
	Response.Write vbCrLf
End Sub

' main process
If vntCommand = "List" Then
	strMode = "List"
ElseIf vntCommand = "Submit" Then
	If Not IsObject(objReqParms) Then Set objReqParms = Server.CreateObject("DSCD.clsReqParms")
	If vntButton = "Update" then
		vntReqParms = objReqParms.Update(vntParamID,vntParamValue,lsAmpID,vntErrorNum,vntErrorDesc)
	ElseIf vntButton = "Add" then
		If Right(vntParamID,1) = "," Then vntParamID = Mid(vntParamID,1,Len(vntParamID)-1) 	
		If Right(vntParamDesc,1) = "," Then vntParamDesc = Mid(vntParamDesc,1,Len(vntParamDesc)-1) 	
		vntReqParms = objReqParms.Add(vntParamID,vntParamDesc,vntParamValue,"2",lsAmpID,vntErrorNum,vntErrorDesc)	
	End If
	If Not vntReqParms Then	
		strMode = "Error"
	Else 
		strMode = "List"
	End If
ElseIf vntCommand = "Update" Then 
	arrParam = Split(strSelectedValue, "|")
	vntParamID = arrParam(0)
	vntParamValue = arrParam(1)	
	vntParamDesc = arrParam(2)
	strMode = "Update"
ElseIf vntCommand = "Return" Then strMode = "Return"
ElseIf vntCommand = "Add" Then strMode = "Add"
End If

Select Case strMode
Case "Update"
	GenUpdateScreen()
Case "Return"
	Cleanup_Objects()
	Response.Redirect Application("Home")
Case "Error"
	GenDisplayError()
Case "List"
	GenListScreen()
Case "Add"
	GenAddScreen()	
End Select

%>
<!--#include file=include/errHandler.inc-->
<%
Sub GenIsParamIDSelected()
%>
<script language="javascript">
<!--
	function IsParamIDSelected(theControl, strAction){

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

		if(!(blnChecked))	alert('You must select a row to ' + strAction);
		return blnChecked;
	}

//	-->
</script>
<%
End Sub

Sub GenCheckNull()
%>
<script language="javascript">
<!--
	function CheckNull(theControl){
		if(theControl.txtParamID[0].value == "") {	
			alert('You must enter a Parameter ID.');
			theControl.txtParamID[0].focus();
			return false;
		}

		if(theControl.txtParamDesc[0].value == "") {	
			alert('You must enter a Parameter Description.');
			theControl.txtParamDesc[0].focus();
			return false;
		}			
		return true;
	}

//	-->
</script>
<%
End Sub
%>
