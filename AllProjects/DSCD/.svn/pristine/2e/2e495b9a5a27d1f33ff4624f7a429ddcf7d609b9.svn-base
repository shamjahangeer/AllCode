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
		lsUID = "434535"
		lsAmpID = "AMP51727"
	Else
		Response.Redirect Application("Login")
		Response.End
    End If
End If

Dim strMode
	strMode = "Input"

' buttons vars
Dim strReturnBtn, strUpdateBtn, strRestoreBtn
	strReturnBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Return"">"
	strUpdateBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Update"" onclick=""return(IsValidEntry(document.forms[0]));"">"
	strRestoreBtn	= "<input type=""submit"" name=""smtSubmit"" id=""smtSubmit"" value=""Restore Default Values"">"

' field vars
Dim vntCommand, vntUDaysEarly, vntUDaysLate, vntCDaysEarly, vntCDaysLate, vntUSmryType, vntCSmryType
Dim vntUSmryTypeDef, vntOrgTypeDef, vntOrgIdDef, vntCSmryTypeDef, vntOrgType, vntOrgID
	vntCommand		= Trim(Request.Form("smtSubmit"))
	vntUDaysEarly	= Trim(Request.Form("txtUDaysEarly"))	
	vntUDaysLate	= Trim(Request.Form("txtUDaysLate"))	
	vntUSmryType	= Trim(Request.Form("selUSmryType"))	
	vntCDaysEarly	= Trim(Request.Form("txtCDaysEarly"))	
	vntCDaysLate	= Trim(Request.Form("txtCDaysLate"))	
	vntCSmryType	= Trim(Request.Form("txtCSmryType"))	
	vntUSmryType	= Trim(Request.Form("selUSmryType"))				
	vntOrgType		= Trim(Request.Form("selOrgType"))	
	vntOrgID		= Trim(Request.Form("selOrgID"))		

Dim selUSmryType, selCSmryType, selOrgType, selOrgID 
Dim arrOrgIDs, arrOrgIDOpts, arrOrgIDVals 
Dim vntUser, objUser, vntErrorNum, vntErrorDesc


Function GenGetValues()
	Dim	objLoad, vntArray, inxRow

	' get user defaults
	Set objLoad = Server.CreateObject("DSCD.clsUser")
	vntUser = objLoad.GetPreference(lsUID, vntUDaysEarly, vntUDaysLate, vntUSmryTypeDef, _
									vntOrgTypeDef, vntOrgIdDef, vntErrorNum, vntErrorDesc)
	If vntErrorNum <> 0 then
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "getting User Default values"
		exit function
	End If
	If vntUDaysEarly <> vbNullString Then vntUDaysEarly = Int(vntUDaysEarly)
	If vntUDaysLate  <> vbNullString Then vntUDaysLate  = Int(vntUDaysLate)			
	If vntUSmryTypeDef<> vbNullString Then vntUSmryTypeDef = Int(vntUSmryTypeDef)

	' get corporate defaults
	vntUser = objLoad.GetCorpDefault(vntCDaysEarly, vntCDaysLate, vntCSmryTypeDef, _
									 vntErrorNum, vntErrorDesc)
	If vntErrorNum <> 0 then
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "getting Corporate Default values"
		exit function
	End If
	vntCDaysEarly   = Int(vntCDaysEarly)
	vntCDaysLate    = Int(vntCDaysLate)	
	vntCSmryTypeDef = Int(vntCSmryTypeDef)							 
	
	Set objLoad = Nothing

	' user summary type select
	selUSmryType = "<select name=selUSmryType id=selUSmryType>" & vbCrLf
	Set objLoad = Server.CreateObject("DSCD.clsSummaryType")
	vntArray = objLoad.ListSmryTypes(vbNullString, vntErrorNum, vntErrorDesc)
	If vntErrorNum <> 0 then
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "getting Summary Type values"
		exit function
	End If
	If IsArray(vntArray) Then
		selUSmryType = selUSmryType & " <option value=>" & "&nbsp;&nbsp;" & "</option>" & vbCrLf	
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			If vntArray(0, inxRow) = vntUSmryTypeDef Then
				selUSmryType = selUSmryType & " <option value=" & vntArray(0, inxRow) & " selected>" & vntArray(1, inxRow) & "</option>" & vbCrLf
			Else
				selUSmryType = selUSmryType & " <option value=" & vntArray(0, inxRow) & ">" & vntArray(1, inxRow) & "</option>" & vbCrLf
			End if
		Next
	Else	
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "getting Summary Type values"
		exit function
	End If
	selUSmryType = selUSmryType & "</select>"
	
	' corporate summary type select
	selCSmryType = "<select name=selCSmryType id=selCSmryType disabled>" & vbCrLf
	If IsArray(vntArray) Then
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			If vntArray(0, inxRow) = vntCSmryTypeDef Then
				selCSmryType = selCSmryType & " <option value=" & vntArray(0, inxRow) & " selected>" & vntArray(1, inxRow) & "</option>" & vbCrLf
			Else
				selCSmryType = selCSmryType & " <option value=" & vntArray(0, inxRow) & ">" & vntArray(1, inxRow) & "</option>" & vbCrLf
			End if
		Next
		Erase vntArray
	Else	
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "getting Summary Type values"
		exit function
	End If
	selCSmryType = selCSmryType & "</select>"

	' org type select
	selOrgType = "<select name=selOrgType id=selOrgType onchange=rebuild_org_ids();>" & vbCrLf
	Set objLoad = Server.CreateObject("DSCD.clsOrgs")
	vntArray = objLoad.ListType(vntErrorNum, vntErrorDesc)
	If IsArray(vntArray) Then
		selOrgType = selOrgType & " <option value=>" & "&nbsp;&nbsp;" & "</option>" & vbCrLf	
		For inxRow = LBound(vntArray, 2) To UBound(vntArray, 2)
			If cstr(vntArray(0, inxRow)) = vntOrgTypeDef Then
				selOrgType = selOrgType & " <option value=" & cstr(vntArray(0, inxRow)) & " selected>" & FormatWords(vntArray(1, inxRow)) & "</option>" & vbCrLf
			Else
				selOrgType = selOrgType & " <option value=" & cstr(vntArray(0, inxRow)) & ">" & FormatWords(vntArray(1, inxRow)) & "</option>" & vbCrLf
			End if
		Next
		Erase vntArray
	Else	
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "getting Org Type values"
		exit function
	End If
	selOrgType = selOrgType & "</select>"

	' org id select
	selOrgID = "<select name=selOrgID id=selOrgID>" & vbCrLf
	arrOrgIDs = objLoad.ListOrgIds(vbNullString, vntErrorNum, vntErrorDesc)
	If IsArray(arrOrgIDs) Then
		For inxRow = LBound(arrOrgIDs, 2) To UBound(arrOrgIDs, 2)
			If cstr(arrOrgIDs(1, inxRow)) = vntOrgTypeDef Then
				If cstr(arrOrgIDs(2, inxRow)) = vntOrgIDDef Then
					selOrgID = selOrgID & " <option value=" & cstr(arrOrgIDs(2, inxRow)) & " selected>" & FormatWords(arrOrgIDs(3, inxRow)) & "</option>" & vbCrLf
				Else
					selOrgID = selOrgID & " <option value=" & cstr(arrOrgIDs(2, inxRow)) & ">" & FormatWords(arrOrgIDs(3, inxRow)) & "</option>" & vbCrLf
				End If
			End if
		Next
	Else	
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "getting Org Id values"
		exit function
	End If
	selOrgID = selOrgID & "</select>"
	
	Set objLoad = Nothing	
End Function	

Function GenHtmlHead()
	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>" & Application("AppAbrv") & " - " & "Preferences</title>"

	If strMode = "Input" Then
		GenJS_refresh_screen()
		GenValidateEntry
	End If

	RwLf "</head>"
	RwLf "<body bgcolor=""#FFFFFF"""
	RwLf " topmargin=""1"""
	RwLf " alink=""lime"""
	RwLf " vlink=""red"""
	RwLf " link=""red"""
	RwLf " style=""font-family: Times New Roman, sans-serif"" onload=""ErrHandler();"">"
	RwLf "<form name=""frmMain"" id=""frmMain"" method=""post"" action=""preferences.asp"">"

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
	RwLf "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Preferences</b></font></td>"
%>
	<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
End Function

Sub GenInputScreen()
	GenHtmlHead
	GenGetValues
	GenJS_Constants

	RwLf "<td align=""center"" colspan=""2"">"
	RwLf strReturnBtn & "&nbsp;&nbsp;" & strRestoreBtn & "&nbsp;&nbsp;" & strUpdateBtn
	RwLf "</td>"

	RwLf "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""2"" align=""center"" name=""tblMain"" id=""tblMain"">"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"
	RwLf "</table>"	

	RwLf "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "	<td align=""left"" colspan=""3"" bgcolor=""lightgrey"">"
	RwLf "	<font size=""4"" color=""navy""><b>Default Parameters</b></font></td>"
	RwLf "</tr>"

	RwLf "<tr" & sRow1Color & ">"
	RwLf "  <th align=""left"" colspan=""2"" width=""45%"">"
	RwLf "  <font size=""2"">User defaults:</font>"	
	RwLf "  </th>"	
	RwLf "  <th align=""left"" width=""55%"">"
	RwLf "  <font size=""2"">Corporate defaults:</font>"	
	RwLf "  </th>"		
	RwLf "</tr>"			
	RwLf "</table>"
	
	RwLf "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "  <th align=""right"" width=""15%"">"
	RwLf "  <font size=""2"">Days Early:&nbsp;&nbsp;</font>"
	RwLf "  </th>"	
	RwLf "	<td align=left width=40>"	
	RwLf "	<input type=""text"" size=2 maxlength=2 name=""txtUDaysEarly"" id=""txtUDaysEarly"" value=""" & vntUDaysEarly & """>"		
	RwLf "  </td>"

	RwLf "  <th align=""right"" width=""30%"">"
	RwLf "  <font size=""2"">Days Early:&nbsp;&nbsp;</font>"
	RwLf "  </th>"	
	RwLf "	<td align=left>"	
	RwLf "	<input type=""text"" disabled size=2 maxlength=2 name=""txtCDaysEarly"" id=""txtCDaysEarly"" value=""" & vntCDaysEarly & """>"		
	RwLf "  </td>"
	RwLf "</tr>"	
	
	RwLf "<tr>"
	RwLf "  <th align=""right"" width=""15%"">"
	RwLf "  <font size=""2"">Days Late:&nbsp;&nbsp;</font>"
	RwLf "  </th>"	
	RwLf "	<td align=left width=40>"	
	RwLf "	<input type=""text"" size=2 maxlength=2 name=""txtUDaysLate"" id=""txtUDaysLate"" value=""" & vntUDaysLate & """>"		
	RwLf "  </td>"

	RwLf "  <th align=""right"" width=""30%"">"
	RwLf "  <font size=""2"">Days Late:&nbsp;&nbsp;</font>"
	RwLf "  </th>"	
	RwLf "	<td align=left>"	
	RwLf "	<input type=""text"" disabled size=2 maxlength=2 name=""txtCDaysLate"" id=""txtCDaysLate"" value=""" & vntCDaysLate & """>"		
	RwLf "  </td>"
	RwLf "</tr>"		
	
	RwLf "<tr>"
	RwLf "  <th align=""right"" width=""15%"">"
	RwLf "  <font size=""2"">Summary Type:&nbsp;&nbsp;</font>"
	RwLf "  </th>"	
	RwLf "	<td align=left width=40>" & selUSmryType & "</td>"

	RwLf "  <th align=""right"" width=""30%"">"
	RwLf "  <font size=""2"">Summary Type:&nbsp;&nbsp;</font>"
	RwLf "  </th>"	
	RwLf "	<td align=left>" & selCSmryType & "</td>"
	RwLf "</tr>"		
	RwLf "</table>"

	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"
	
	RwLf "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "	<td align=""left"" colspan=""3"" bgcolor=""lightgrey"">"
	RwLf "	<font size=""4"" color=""navy""><b>Organization Default Preferences</b></font></td>"
	RwLf "</tr>"
	RwLf "</table>"	

	RwLf "<table border=""0"" cellpadding=""0"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "  <th align=""right"" width=""15%"">"
	RwLf "  <font size=""2"">Org Type:&nbsp;&nbsp;</font>"
	RwLf "  </th>"	
	RwLf "	<td align=left width=40>" & selOrgType & "</td>"

	RwLf "  <th align=""right"" width=""37%"">"
	RwLf "  <font size=""2"">Org ID:&nbsp;&nbsp;</font>"
	RwLf "  </th>"	
	RwLf "	<td align=left>" & selOrgID & "</td>"
	RwLf "</tr>"		
	RwLf "</table>"
		
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<td align=""center"" colspan=""2"">"
	RwLf strReturnBtn & "&nbsp;&nbsp;" & strRestoreBtn & "&nbsp;&nbsp;" & strUpdateBtn
	RwLf "</td>"

	GenSetFocus
	GenFooter
End Sub	

Function GenDisplayError()
	objError	= vntErrorNum
	errDesc		= vntErrorDesc
	If errWhere = vbNullString Then errWhere = "the application"
	GenHTMLHead
	GenFooter
End Function

Sub GenFooter()
	RwLf "</table>"
	RwLf "</form></body></html>"	
End Sub

Sub Cleanup_Objects()
	If IsObject(objUser) then Set objUser = Nothing
End Sub

Sub Rw(strIn)
	Response.Write strIn
End Sub

Sub RwLf(strIn)
	Response.Write strIn
	Response.Write vbCrLf
End Sub

Function FormatJSstring(strIn)
	FormatJSstring = Replace(Replace(Trim(strIn), "/", "\/"), "'", "\'")
End Function

Function FormatWords(strIn)
	FormatWords = vbNullString

	Dim inxChar, inx, strOut

	If Len(strIn) > 1 Then
		strOut = Trim(strIn)
		strOut = FormatJSstring(UCase(Left(strOut, 1)) & LCase(Mid(strOut, 2)))
		strOut = CapAfterChar(strOut, " ")
		strOut = CapAfterChar(strOut, "/")
		strOut = CapAfterChar(strOut, "-")
		strOut = CapAfterChar(strOut, ",")
		strOut = CapAfterChar(strOut, ".")
	Else
		strOut = UCase(FormatJSstring(strIn))
	End If

	FormatWords = strOut

End Function

Function CapAfterChar(strIn, strChar)

	Dim inxChar, inx, strOut, intLen
		strOut = strIn
		intLen = Len(strOut)

	If intLen > 1 Then
		For inxChar = 1 To intLen - 1
			inx = InStr(inxChar, strIn, strChar)
			If inx > 0 Then
				strOut = Left(strOut, inx) & UCase(Mid(strOut, inx + 1, 1)) & Mid(strOut, inx + 2)
				inxChar = inx
			End If
			If inxChar > intLen Then Exit For
		Next
	End If

	CapAfterChar = strOut
End Function

' main process
If vntCommand = "Input" Then	
	strMode = "Input"
ElseIf vntCommand = "Restore Default Values" or vntCommand = "Update" Then
	If Not IsObject(objUser) Then Set objUser = Server.CreateObject("DSCD.clsUser")	
	If vntCommand = "Restore Default Values" Then
		vntUDaysEarly = vbNullString
		vntUDaysLate  = vbNullString
		vntUSmryType  = vbNullString
		vntOrgType	  = vbNullString
		vntOrgID	  = vbNullString
	End If
	vntUser = objUser.UpdatePreference(lsUID,lsAmpID,vntUDaysEarly,vntUDaysLate,vntUSmryType,vntOrgType,vntOrgID,vntErrorNum,vntErrorDesc)			
	If Not vntUser Then	
		errWhere = "updating User Preference table"
		strMode = "Error"
	Else 
		strMode = "Input"
	End If	
ElseIf vntCommand = "Return" Then	
	strMode = "Return" 
End If

Select Case strMode
Case "Return"
	Cleanup_Objects()
	Response.Redirect Application("Home")
	Response.End
Case "Error"
	GenDisplayError()
	strMode = "Input"	
Case "Input", "Update":
	GenInputScreen()
End Select

%>
<!--#include file=include/errHandler.inc-->
<%

Sub GenJS_Constants()
	Dim inx, inxRow, inxCol
%>
<!--#include file=include/JSFunctions.inc-->
	<script language="javascript">
	<!--
		var oidTypeID	= 1;
		var oidOrgID	= 2;
		var oidShortNm	= 3;
		var arrOrgIDs	= new Array();
<%
'-----------------------------------------------------------
	IF IsArray(arrOrgIDs) THEN
		FOR inx = LBound(arrOrgIDs, 1) To UBound(arrOrgIDs, 1)

			RwLf "		arrOrgIDs[" & inx & "] = new Array();"
		NEXT

		FOR inxRow = LBound(arrOrgIDs, 2) To UBound(arrOrgIDs, 2)
			FOR inxCol = LBound(arrOrgIDs, 1) To UBound(arrOrgIDs, 1)

				RwLf "		push(arrOrgIDs[" & inxCol & "], '" & arrOrgIDs(inxCol, inxRow) & "');"
			NEXT
		NEXT
	END IF
'-----------------------------------------------------------
%>
		var arrOrgIDOpts	= new Array();
		var arrOrgIDVals	= new Array();
		var arrLoadingMsg	= new Array('~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~', '~~~~~ Loading... ~~~~~');
		var strOrgIDDef		= '<%=vntOrgIDDef%>';
	// -->
	</script>
<%
End Sub		

'************************** JS Function refresh_screen ******************
Sub GenJS_refresh_screen()
%>
<!--#include file=include/errHandler.inc-->
	<script language="javascript">
	<!--
	function rebuild_org_ids(){

		var theForm = document.forms[0];

		while(arrOrgIDOpts.length > 0){
			pop(arrOrgIDOpts);
			pop(arrOrgIDVals);
		}

		for(i=0;i < arrOrgIDs[0].length;i++){

			if(theForm.selOrgType.options[theForm.selOrgType.selectedIndex].value == arrOrgIDs[oidTypeID][i]){
				push(arrOrgIDOpts, arrOrgIDs[oidShortNm][i]);
				push(arrOrgIDVals, arrOrgIDs[oidOrgID][i]);
		}	}

		if(arrOrgIDOpts.length == 0){
			push(arrOrgIDOpts, '');
			push(arrOrgIDVals, '');
		}

		clear_select(theForm.selOrgID);
		for(i=0;i < arrOrgIDOpts.length;i++){
			blnDefSelected = ((arrOrgIDVals[i] == frmMain.selOrgID.value)||(i==0));
			blnSelected = ((arrOrgIDVals[i] == frmMain.selOrgID.value)||(i==0));
			add_option(theForm.selOrgID, theForm.selOrgID.length, arrOrgIDOpts[i], arrOrgIDVals[i], blnDefSelected, blnSelected);
			theForm.selOrgID.options[i].selected = ((arrOrgIDVals[i] == frmMain.selOrgID.value)||(i==0));
		}
	}
	// -->
	</script>
<%
End Sub

Sub GenValidateEntry()
%>
<script language="javascript">
<!--
	function IsValidEntry(theControl){
	
		if(theControl.txtUDaysEarly.value) {	
			if(theControl.txtUDaysEarly.value < 0 || theControl.txtUDaysEarly.value > 5) {
				alert('Please enter valid value between 0 and 5.');
				theControl.txtUDaysEarly.focus();
				return false;
			}
		}

		if(theControl.txtUDaysLate.value) {	
			if(theControl.txtUDaysLate.value < 0 || theControl.txtUDaysLate.value > 5) {
				alert('Please enter valid value between 0 and 5.');
				theControl.txtUDaysLate.focus();
				return false;
			}
		}			

		return true;
	}

//	-->
</script>
<%
End Sub

Sub GenSetFocus()
%>
<script language="javascript">
<!--
	document.forms[0].txtUDaysEarly.focus();
//	-->
</script>
<%
End Sub
%>