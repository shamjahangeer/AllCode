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
Dim strReturnBtn, strUpdateBtn, strSubmitBtn, strDeleteBtn, strCancelBtn, strAddBtn
	strReturnBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Return"">"
	strUpdateBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Update"" onclick=""return(IsRowSelected(document.forms[0].RowSelected,'Update',false));"">"
	strDeleteBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Delete"" onclick=""return(IsRowSelected(document.forms[0].RowSelected,'Delete',true));"">"
	strSubmitBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Submit"" onclick=""return(IsValidEntry(document.forms[0]));"">"
	strCancelBtn	= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Cancel"">"
	strAddBtn		= "<input type=""submit"" style=""width: 65px"" name=""smtSubmit"" id=""smtSubmit"" value=""Add"">"

' field vars
Dim vntCommand, vntBldgNbr, vntLocCode, vntSatInd, vntSunInd, vntButton, vntKeyBldgNbr, vntKeyLocCode
	vntCommand		= Trim(Request.Form("smtSubmit"))
	vntBldgNbr		= Trim(Request.Form("txtBldgNbr"))	
	vntLocCode		= Trim(Request.Form("txtLocCode"))	
	vntSatInd		= Trim(Request.Form("txtSatInd"))	
	vntSunInd		= Trim(Request.Form("txtSunInd"))		
	vntButton		= Trim(Request.Form("txtButton"))	
	vntKeyBldgNbr	= Trim(Request.Form("txtKeyBldgNbr"))	
	vntKeyLocCode	= Trim(Request.Form("txtKeyLocCode"))			

' object vars
Dim	objWkendSchd, vntErrorNum, vntErrorDesc, vntWkendSchd

' array vars
Dim arrList, arrSelectedRow, intBldgNbr, intLocCode, intSatInd, intSunInd, strSelectedValue
	strSelectedValue = Request.Form("RowSelected")
	intBldgNbr		= 0
	intLocCode		= 1
	intSatInd		= 2
	intSunInd		= 3


Function GenHtmlHead()
	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>" & Application("AppAbrv") & " - " & "Weekend Parameter Maintenance</title>"

	If strMode = "List" Then
		GenRowSelected
	ElseIf strMode = "Add" OR strMode = "Update" Then
		GenValidateEntry
	End If

	RwLf "</head>"
	RwLf "<body bgcolor=""#FFFFFF"""
	RwLf " topmargin=""1"""
	RwLf " alink=""lime"""
	RwLf " vlink=""red"""
	RwLf " link=""red"""
	RwLf " style=""font-family: Times New Roman, sans-serif"" onload=""ErrHandler();"">"
	RwLf "<form name=""frmMain"" id=""frmMain"" method=""post"" action=""wkndsched.asp"">"

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
	RwLf "<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Weekend Parameter Maintenance</b></font></td>"
%>
	<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
End Function

Function GenList()
	Dim intSelect, strColorNow'
	Dim intRow, intCol, arrColHeaders 

	arrColHeaders = Array("Sel", "Plant/Bldg Nbr", "Loc Code", "Sat Ship Ind", "Sun Ship Ind", "User ID", "Date Changed")

	If Not IsObject(objWkendSchd) Then
		Set objWkendSchd = Server.CreateObject("DSCD.clsWkendSchd")
		If err.number <> 0 Then
			objError = Err.number
			errDesc = Err.description
			errWhere = "Create Object objWkendSchd"
			exit function		
		End If
	end if
	
	arrList = objWkendSchd.List(vntErrorNum, vntErrorDesc)
	If vntErrorNum <> 0 Then
		objError = vntErrorNum
		errDesc = vntErrorDesc
		errWhere = "retrieving weekend parameter list"
		exit function
	End If

	RwLf "<table border=""1"" cellpadding=""0"" cellspacing=""0"" width=""60%"">"

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
					arrList(intBldgNbr, intRow) & "|" & arrList(intLocCode, intRow) & _
					"|" & arrList(intSatInd, intRow) & "|" & arrList(intSunInd, intRow) & """></td>"
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
	GenRowSelected
End Function

Sub GenListScreen()
	GenHtmlHead

	RwLf "<td align=""center"" colspan=""4"">"
	RwLf strReturnBtn & "&nbsp;&nbsp;" & strAddBtn & "&nbsp;&nbsp;" & strUpdateBtn & "&nbsp;&nbsp;" & strDeleteBtn
	RwLf "</td>"

	RwLf "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""2"" align=""center"" name=""tblMain"" id=""tblMain"">"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	GenList

	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<td align=""center"" colspan=""4"">"
	RwLf strReturnBtn & "&nbsp;&nbsp;" & strAddBtn & "&nbsp;&nbsp;" & strUpdateBtn & "&nbsp;&nbsp;" & strDeleteBtn
	RwLf "</td>"
	
	GenFooter
End Sub

Sub GenInputScreen()
	GenHtmlHead

	RwLf "<td align=""center"" colspan=""2"">"
	RwLf strSubmitBtn & "&nbsp;&nbsp;" & strCancelBtn
	RwLf "</td>"

	RwLf "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""2"" align=""center"" name=""tblMain"" id=""tblMain"">"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<table border=""0"" cellpadding=""2"" cellspacing=""0"" width=""100%"">"
	RwLf "<tr>"
	RwLf "	<td align=""left"" colspan=""3"" bgcolor=""lightgrey"">"
	RwLf "	<font size=""4"" color=""navy""><b>System Parameter</b></font></td>"
	RwLf "</tr>"
	
	RwLf "<tr" & sRow1Color & ">"
	RwLf "  <th align=""right"" width=""15%"">"
	RwLf "  <font size=""2"">Plant/Building Nbr:&nbsp;&nbsp;</font>"
	RwLf "  </th>"	
	RwLf "	<td align=left>"	
	RwLf "	<input type=""text"" size=4 maxlength=4 name=""txtBldgNbr"" id=""txtBldgNbr"" value=""" & vntBldgNbr & """>"		
	RwLf "  </td>"
	RwLf "</tr>"	

	RwLf "<tr>"	
	RwLf "  <th align=""right"" width=""15%"">"
	RwLf "  <font size=""2"">Location Code:&nbsp;&nbsp;</font>"
	RwLf "  </th>"		
	RwLf "	<td font size=2 align=left>"			
	RwLf "	<input type=""text"" size=4 maxlength=4 name=""txtLocCode"" id=""txtLocCode"" value=""" & vntLocCode & """>"		
	RwLf "  </td>"
	RwLf "</tr>"	

	RwLf "<tr>"	
	RwLf "  <th align=""right"" width=""15%"">"
	RwLf "  <font size=""2"">Saturday Ship Ind:&nbsp;&nbsp;</font>"
	RwLf "  </th>"		
	RwLf "	<td font size=2 align=left>"			
	RwLf "	<input type=""text"" size=1 maxlength=1 name=""txtSatInd"" id=""txtSatInd"" value=""" & vntSatInd & """>"		
	RwLf "  </td>"
	RwLf "</tr>"	

	RwLf "<tr>"	
	RwLf "  <th align=""right"" width=""15%"">"
	RwLf "  <font size=""2"">Sunday Ship Ind:&nbsp;&nbsp;</font>"
	RwLf "  </th>"		
	RwLf "	<td font size=2 align=left>"			
	RwLf "	<input type=""text"" size=1 maxlength=1 name=""txtSunInd"" id=""txtSunInd"" value=""" & vntSunInd & """>"		
	RwLf "  </td>"
	RwLf "</tr>"	
	
	RwLf "</table>"
	RwLf "<tr><td colspan=""3"">" & sHR & "</td></tr>"

	RwLf "<td align=""center"" colspan=""2"">"
	RwLf strSubmitBtn & "&nbsp;&nbsp;" & strCancelBtn
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

Function SendHiddenVars()
	If strMode = "Update"  or strMode = "Add" Then	
		RwLf "<input type=""hidden"" name=""txtButton"" id=""txtButton"" value=""" & strMode & """>"		
	End If	
	If strMode = "Update" Then	
		RwLf "<input type=""hidden"" name=""txtKeyBldgNbr"" id=""txtKeyBldgNbr"" value=""" & vntKeyBldgNbr & """>"	
		RwLf "<input type=""hidden"" name=""txtKeyLocCode"" id=""txtKeyLocCode"" value=""" & vntKeyLocCode & """>"			
	End If				
End Function

Sub GenFooter()
	SendHiddenVars()
	RwLf "</table>"
	RwLf "</form></body></html>"	
End Sub

Sub Cleanup_Objects()
	If IsObject(objWkendSchd) then Set objWkendSchd = Nothing
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
	If Not IsObject(objWkendSchd) Then Set objWkendSchd = Server.CreateObject("DSCD.clsWkendSchd")
	If vntButton = "Update" then
		vntWkendSchd = objWkendSchd.Update(vntKeyBldgNbr,vntKeyLocCode,vntBldgNbr,vntLocCode,vntSatInd,vntSunInd,lsAmpID,vntErrorNum,vntErrorDesc)
	ElseIf vntButton = "Add" then
		vntWkendSchd = objWkendSchd.Insert(vntBldgNbr,vntLocCode,vntSatInd,vntSunInd,lsAmpID,vntErrorNum,vntErrorDesc)	
	End If
	If Not vntWkendSchd Then	
		strMode = "Error"
	Else 
		strMode = "List"
	End If
ElseIf vntCommand = "Update" Then 
	arrSelectedRow = Split(strSelectedValue, "|")
	vntKeyBldgNbr = arrSelectedRow(0)
	vntKeyLocCode = arrSelectedRow(1)	
	vntBldgNbr = arrSelectedRow(0)
	vntLocCode = arrSelectedRow(1)		
	vntSatInd = arrSelectedRow(2)
	vntSunInd = arrSelectedRow(3)
	strMode = "Update"
ElseIf vntCommand = "Delete" Then
	arrSelectedRow = Split(strSelectedValue, "|")
	vntKeyBldgNbr = arrSelectedRow(0)
	vntKeyLocCode = arrSelectedRow(1)	
	If Not IsObject(objWkendSchd) Then Set objWkendSchd = Server.CreateObject("DSCD.clsWkendSchd")
	vntWkendSchd = objWkendSchd.Delete(vntKeyBldgNbr,vntKeyLocCode,vntErrorNum,vntErrorDesc)
	If Not vntWkendSchd Then	
		strMode = "Error"
	Else 
		strMode = "List"
	End If	
ElseIf vntCommand = "Return" Then strMode = "Return"
ElseIf vntCommand = "Add" Then strMode = "Add"
End If

Select Case strMode
Case "Return"
	Cleanup_Objects()
	Response.Redirect Application("Home")
	Response.End
Case "Error"
	GenDisplayError()
Case "List"
	GenListScreen()
Case "Add", "Update":
	GenInputScreen()	
End Select

%>
<!--#include file=include/errHandler.inc-->
<%
Sub GenRowSelected()
%>
<script language="javascript">
<!--
	function IsRowSelected(theControl, strAction, blnConfirm){

		var blnChecked = false;

		if(theControl.length){
			for(var i=0; i < theControl.length;i++){
				if(theControl[i].checked){
					blnChecked = true;
					break;
				}
			}
		}
		else{
			blnChecked = theControl.checked;
		}

		if(!blnChecked) {
			alert('You must select a row to ' + strAction +  '.');
			return blnChecked;
		}

		if(blnConfirm) {
			blnChecked = confirm(strAction + ' selected record?');
		}		

		return blnChecked;
	}

//	-->
</script>
<%
End Sub

Sub GenValidateEntry()
%>
<script language="javascript">
<!--
	function IsValidEntry(theControl){
	
		if(!theControl.txtBldgNbr.value) {	
			alert('Please enter a Plant/Building Nbr.');
			theControl.txtBldgNbr.focus();
			return false;
		}

		if(theControl.txtLocCode.value == "") {	
			alert('Please enter a Location Code.');
			theControl.txtLocCode.focus();
			return false;
		}			

		theControl.txtSatInd.value = theControl.txtSatInd.value.toUpperCase();
		if(theControl.txtSatInd.value != "Y" && 
			theControl.txtSatInd.value != "N") {	
			alert('Please enter a valid (Y/N) Shipment Indicator.');
			theControl.txtSatInd.focus();
			return false;
		}			

		theControl.txtSunInd.value = theControl.txtSunInd.value.toUpperCase();
		if(theControl.txtSunInd.value != "Y" && 
			theControl.txtSunInd.value != "N") {	
			alert('Please enter a valid (Y/N) Shipment Indicator.');
			theControl.txtSunInd.focus();
			return false;
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
	document.forms[0].txtBldgNbr.focus();
//	-->
</script>
<%
End Sub
%>