<% @ Language=VBScript %>
<% Option Explicit

Response.Buffer = True
Session.Timeout = 240
Response.Expires = 0

%>
<!--#include file=include/security.inc-->
<!--#include file=include/constants.inc-->
<%
Dim blnDebug
	blnDebug = False
'	blnDebug = True

If Not MrSecurity Then
	If blnDebug Then
		'TESTING
		lsUID = "12345"
		lsAmpID = "TESTING"
	Else
		Response.Redirect Application("Login")
		Response.End
	End If
End If
%>
<!--#include file=include/colors.inc-->
<!--#include file=include/ArrayFunctions.inc-->
<%

'***********************************************************************
'*********	Housekeeping
'***********************************************************************

Dim vntErrorNumber, vntErrorDesc
	vntErrorNumber = 0
	vntErrorDesc = vbNullString
Dim blnError, blnContinue
	blnError = False
	blnContinue = True
Dim objError
	objError = 0
Dim errWhere
	errWhere = vbNullString
Dim errDesc
	errDesc = vbNullString


	Dim strMode
		strMode = "SEARCH"

	Dim strDeleteList, arrDeleteList, inx
	Dim arrList, blnRC
		arrList = vbNullString

	Dim strSearchBtn, strEditBtn, strDeleteBtn, strShowBtn, strNewBtn
		strSearchBtn	= "<input type=""submit"" name=""smtSubmit"" id=""smtSubmit"" value=""Search"">"
        strEditBtn		= "<input type=""submit"" name=""smtSubmit"" id=""smtSubmit"" value=""Edit"" onclick=""return(IsMsgSelected(theForm.txtEffectiveDt, 'Edit'));"">"
        strDeleteBtn	= "<input type=""submit"" name=""smtSubmit"" id=""smtSubmit"" value=""Delete"" onclick=""return((IsMsgSelected(theForm.chkDelete, 'Delete')) && (confirm('Permanently Delete All Selected Announcements?')));"">"
		strShowBtn		= "<input type=""submit"" name=""smtSubmit"" id=""smtSubmit"" value=""Show Announcements"" onclick=""return(check_search_dates());"">"
		strNewBtn		= "<input type=""submit"" name=""smtSubmit"" id=""smtSubmit"" value=""Make New Announcement"">"

	Dim vntFromDt, vntToDt
		vntFromDt	= Trim(Request.Form("txtFromDt"))
		vntToDt		= Trim(Request.Form("txtToDt"))

	Dim vntEffectiveDt, vntActive, vntMsgText, vntEnteredByAmpID, vntEnteredDt, vntNewEffectiveDt,vntPlanned
		vntEffectiveDt		= Trim(Request.Form("txtEffectiveDt"))
		vntNewEffectiveDt	= Trim(Request.Form("txtNewEffectiveDt"))
		vntMsgText			= Request.Form("txaEdit")
		vntActive			= UCase(Request.Form("chkActive"))
		vntPlanned			= UCase(Request.Form("chkPlanned"))		
		If vntActive <> "Y" Then vntActive = "N"
		If vntPlanned <> "Y" Then vntPlanned = "N"		

		vntEnteredByAmpID	= vbNullString
		vntEnteredDt		= vbNullString

	Dim vntCommand
		vntCommand	= UCase(Trim(Request.Form("smtSubmit")))

	Dim objAnncmnt
	If vntCommand <> vbNullString And vntCommand <> "MAKE NEW ANNOUNCEMENT" Then Set objAnncmnt = Server.CreateObject("Dscd.clsAnnounce")

	If vntCommand = "SHOW ANNOUNCEMENTS" Then
		strMode = "LIST"
	ElseIf vntCommand = "SUBMIT ANNOUNCEMENT" Then
		blnRC = objAnncmnt.AddNew(lsAmpID, vntEFfectiveDt, "Y",vntPlanned, vntMsgText, vntErrorNumber, vntErrorDesc)
		If blnRC Then
			strMode = "LIST"
		Else
			strMode		= "ERROR"
			errWhere	= "Adding New Announcement"
		End If
	ElseIf vntCommand = "SUBMIT CHANGES" Then
		If vntEffectiveDt = vntNewEffectiveDt Then
			blnRC = objAnncmnt.UpdateMsg(lsAmpID, vntEffectiveDt, vntActive,vntPlanned, vntMsgText, vntErrorNumber, vntErrorDesc)
			If blnRC Then
				strMode = "LIST"
			Else
				strMode		= "ERROR"
				errWhere	= "Updating Announcement"
			End If
		Else
			blnRC = objAnncmnt.AddNew(lsAmpID, vntNewEFfectiveDt, "Y",vntPlanned, vntMsgText, vntErrorNumber, vntErrorDesc)
			If blnRC Then
				blnRC = objAnncmnt.DeleteMsg(vntEFfectiveDt, vntErrorNumber, vntErrorDesc)
				If blnRC Then
					strMode = "LIST"
				Else
					strMode		= "ERROR"
					errWhere	= "Deleting Announcement For " & vntEffectiveDt
				End If
			Else
				strMode		= "ERROR"
				errWhere	= "Adding Announcement To New Effective Date: " & vntNewEffectiveDt
			End If
		End If
	ElseIf vntCommand = "MAKE NEW ANNOUNCEMENT" Then	strMode = "NEW"
		vntPlanned = "Y"
	ElseIf vntCommand = "EDIT" Then
		If vntEffectiveDt = vbNullString Then
			strMode = "LIST"
		Else
			blnRC = objAnncmnt.RetrieveByDate(vntEffectiveDt, vntActive,vntPlanned, vntMsgText, vntEnteredByAmpID, vntEnteredDt, vntErrorNumber, vntErrorDesc)
			If blnRC Then
				strMode = "EDIT"
			Else
				strMode		= "ERROR"
				errWhere	= "Retrieving Announcement"
			End If
		End If
	ElseIf vntCommand = "DELETE" Then
		strDeleteList = Replace(Request.Form("chkDelete"), " ", vbNullString)
		arrDeleteList = split(strDeleteList, ",")

		If IsArray(arrDeleteList) Then

			For inx = LBound(arrDeleteList) To UBound(arrDeleteList)
				blnRC = objAnncmnt.DeleteMsg(arrDeleteList(inx), vntErrorNumber, vntErrorDesc)
				If blnRC Then
					strMode = "LIST"
				Else
					strMode		= "ERROR"
					errWhere	= "Deleting Announcement For " & arrDeleteList(inx)
					Exit For
				End If
			Next
		Else
			strMode = "LIST"
		End If
	End If

	If strMode = "LIST" Then
		arrList = objAnncmnt.List(vntFromDt, vntToDt, vntErrorNumber, vntErrorDesc)
		'RwLf IsArray(arrList)
		'RwLf "vntErrorNumber = " & vntErrorNumber
		'RwLf "vntErrorDesc = " & vntErrorDesc
		If vntErrorNumber <> 0 Then
			strMode		= "ERROR"
			errWhere	= "Retrieving Announcement List"
		End If
	End If

	If IsObject(objAnncmnt) Then Set objAnncmnt = Nothing

    Select Case strMode
	Case "LIST":
		DisplayList arrList
	Case "EDIT", "NEW":
		DisplayDetail
	Case "ERROR":
		DisplayError
	Case Else:
		DisplaySearch
	End Select



'####################################################
'#
'#             Functions and Subroutines
'#
'####################################################

Function SendHiddenVars()
	If strMode <> "SEARCH" And strMode <> "LIST" Then
		RwLf "<input type=""hidden"" name=""txtFromDt"" id=""txtFromDt"" value=""" & vntFromDt & """>"
		RwLf "<input type=""hidden"" name=""txtToDt"" id=""txtToDt"" value=""" & vntToDt & """>"
	End If
	If strMode = "EDIT" Then
		RwLf "<input type=""hidden"" name=""txtEffectiveDt"" id=""txtEffectiveDt"" value=""" & vntEffectiveDt & """>"
	End If

End Function

Function DisplaySearch()
	GenHTMLHead

	SearchControls

	GenHTMLFoot
End Function

Function SearchControls()
	RwLf "<table border=""0"">"
	RwLf "<tr bgcolor=""#EEEEEE"">"
	RwLf "<td align=""left"" colspan=""4"">"
	RwLf "<font size=""2"">Both fields are optional.</font>"
	RwLf "</td>"
	RwLf "</tr>"
	RwLf "<tr>"
	RwLf "<td align=""right""><font size=""2"">From Date:&nbsp;&nbsp;</font></td>"
	RwLf "<td align=""left""><input type=""text"" name=""txtFromDt"" id=""txtFromDt"" value=""" & vntFromDt & """></td>"
	RwLf "<td align=""right""><font size=""2"">To Date:&nbsp;&nbsp;</font></td>"
	RwLf "<td align=""left""><input type=""text"" name=""txtToDt"" id=""txtToDt"" value=""" & vntToDt & """><font size=""2"">(YYYY-MM-DD)</font></td>"
	RwLf "</tr>"
	RwLf "<tr>"
	RwLf "<td align=""center"" colspan=""4"">"
	RwLf strShowBtn
	RwLf strNewBtn
	RwLf "</td></tr></table>"
End Function

Function DisplayError()

	objError	= vntErrorNumber
	errDesc		= vntErrorDesc
	If errWhere = vbNullString Then errWhere = "the application"

	GenHTMLHead
	RwLf "<font size=""2""><table border=""0"">"
	RwLf "<tr bgcolor=""#EEEEEE"">"
	RwLf "<td>"
	RwLf "There has been an error in " & errWhere & ":<br>Number:&nbsp;&nbsp;" & vntErrorNumber & "<br>Description:&nbsp;&nbsp;" & vntErrorDesc
	RwLf "</td>"
	RwLf "</tr>"
	RwLf "<td align=""center"" colspan=""4"">"
	RwLf strSearchBtn & "&nbsp;" & strShowBtn
	RwLf "</td></tr></table></font>"
	GenHTMLFoot
End Function

Function DisplayList(arrArray)

	Dim inxActive, inxEffDate, inxText, inxTS, inxAmpID, inxPlanned
	Dim inxRow, inxCol, arrColHeaders

	inxEffDate	= 0
	inxActive	= 1
	inxPlanned	= 2
	inxText		= 3
	inxTS		= 4
	inxAmpID	= 5

	arrColHeaders = Array("Edit", "Delete", "Effective Date", "Active","Planned", "Announcement", "Entered Date", "Entered By")

    Dim strButtons
    	strButtons = "<br>" & strEditBtn & "&nbsp;" & strDeleteBtn & "<br>"

	GenHTMLHead
	SearchControls
	RwLf "<h3>Results:</h3>"
	If IsArray(arrArray) Then

		RwLf strButtons
		RwLf "<br><table border=""1"" width=""100%"" bordercolor=""navy"">"

		'Column Headers
		RwLf "<tr>"
		For inx = LBound(arrColHeaders) To UBound(arrColHeaders)
			RwLf "<th><font size=""2"">" & arrColHeaders(inx) & "</font></td>"
		Next
		RwLf "</tr>"

		For inxRow = LBound(arrArray, 2) To UBound(arrArray, 2)
			RwLf "<tr>"
			RwLf "<td><input type=""radio"" name=""txtEffectiveDt"" id=""txtEffectiveDt"" value=""" & arrArray(inxEffDate, inxRow) & """></td>"
			RwLf "<td><input type=""checkbox"" name=""chkDelete"" id=""chkDelete"" value=""" & arrArray(inxEffDate, inxRow) & """></td>"
			For inxCol = LBound(arrArray, 1) To UBound(arrArray, 1)
				If inxCol <> inxText Then
					RwLf "<td><font size=""2"">" & arrArray(inxCol, inxRow) & "</font></td>"
				Else
					RwLf "<td>" & arrArray(inxCol, inxRow) & "</td>"
				End If
			Next
		    RwLf "</tr>"
		Next
		RwLf "</table>"
		RwLf strButtons
	Else
		RwLf "<center><h2>No Announcements</h3></center><br><br>"
	End If
	GenHTMLFoot

End Function

Sub GenHTMLHead()

	Dim strTemp
		strTemp = vbNullString

	RwLf "<html>"
	RwLf "<head>"
	RwLf "<title>DSCD - Announcement Manager</title>"
	GenJSCommon
	If strMode = "EDIT" Or strMode = "NEW" Then
		GenJSDetailScreen
		strTemp = " onkeyup=""catch_ctrl();"""
	Else
		GenJSCheckSearchDates
		if strMode = "LIST" Then GenIsMsgSelected
	End If
	RwLf "</head>"
	RwLf "<body bgcolor=""#FFFFFF"""
	RwLf " TOPMARGIN=""1"""
	RwLf " ALINK=""Lime"""
	RwLf " VLINK=""Red"""
	RwLf " LINK=""Red"""
	RwLf " style=""font-family: Times New Roman, sans-serif"" onload=""start_up();""" & strTemp & ">"
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
	RwLf "	<td colspan=""5"" valign=""middle"" align=""center""><font size=""5""" & sTitleColor & "><b>Delivery Scorecard Announcement Manager</b></font></td>"
%>
<!--#include file=include/NavEnd.inc-->
<%
	RwLf "<br>"
	RwLf "<br>"
End Sub

Sub GenHTMLFoot()
	SendHiddenVars
	RwLf "</form></body></html>"
End Sub


Sub GenJSCommon()
%>
<!--#include file=include/JSFunctions.inc-->
<script language="javascript">
<!--
	var theForm;
<%  IF blnDebug THEN
		RwLf "	var blnDebug = true;"
	ELSE
		RwLf "	var blnDebug = false;"
	END IF

	IF strMode = "EDIT" OR strMode = "NEW" THEN
%>	var ascEnter = 13;
	var ascSpace = 32;
	var ascY	= 89;
	var ascZ	= 90;

	var inxUndo = 0;
	var intUndoMax = 50;
	var arrUndo = new Array();
<%	END IF	%>

	function start_up(){

		theForm = document.forms[0];
<%	IF strMode = "EDIT" OR strMode = "NEW" THEN %>
		update_undo_array(theForm.txaEdit.innerText);
		update_span();
		theForm.txaEdit.focus();
<%	END IF	%>
	}

//	-->
</script>
<%
End Sub

Sub GenIsMsgSelected()
%>
<script language="javascript">
<!--
	function IsMsgSelected(theControl, strAction){

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

		if(!(blnChecked))	alert('You Must Select An Announcement To ' + strAction);
		return blnChecked;
	}

//	-->
</script>
<%
End Sub

Sub GenJSCheckSearchDates()
%>
<script language="javascript">
<!--
	function check_search_dates(){
		if(	(theForm.txtFromDt.value)					&&
			(!(IsValidDate(theForm.txtFromDt.value)))	){

			alert('The From Date Is Invalid');
			theForm.txtFromDt.focus();
			theForm.txtFromDt.select();
			return false;
		}
		else if(	(theForm.txtToDt.value)					&&
					(!(IsValidDate(theForm.txtToDt.value)))	){

			alert('The To Date Is Invalid');
			theForm.txtToDt.focus();
			theForm.txtToDt.select();
			return false;
		}
		else{
			return true;
		}
	}

//	-->
</script>
<%
End Sub

Sub GenJSDetailScreen()
%>
<script language="javascript">
<!--

	function catch_ctrl(){
		var intAsc		= event.keyCode;
		var blnShift	= event.shiftKey;
		var blnAlt		= event.altKey;
		var blnCtrl		= event.ctrlKey;
		var intMsBtn	= event.button;

		if(	(blnCtrl)		&&
			(!(blnShift))	&&
			(!(blnAlt))		){

			if(intAsc == ascZ){
				undo();
			}
			else if(intAsc == ascY){
				redo();
			}
		}
	}


	function capture_key(txaElement){

		var strTxaEdit = theForm.txaEdit.innerText;

		var intAsc		= event.keyCode;
		var blnShift	= event.shiftKey;
		var blnAlt		= event.altKey;
		var blnCtrl		= event.ctrlKey;
		var intMsBtn	= event.button;

		//alert(intAsc);
		//alert(blnCtrl + '\n' + (intAsc == ascY) + '\n' + (intAsc == ascZ));

		if(	(intAsc == ascEnter)	||
			(intAsc >= ascSpace)	){

			if(intAsc == ascEnter){
				theForm.txaEdit.caretPos.text =	'<br>\n';
			}

			if(	(blnCtrl)		&&
				(!(blnShift))	&&
				(!(blnAlt))		){

				if(intAsc == ascZ){
					undo();
				}
				else if(intAsc == ascY){
					redo();
				}
			}
			else{
				update_undo_array(strTxaEdit);
				storeCaret(txaElement);
		  		update_span();
			}
		}
	}


	function write_span(strIn){

		if (document.getElementById) {
			if (window.HTMLElement) {
				spanNode = document.getElementById('spnSpan');
				while (spanNode.hasChildNodes()) spanNode.removeChild(spanNode.lastChild);
				var range = document.createRange();
				range.selectNodeContents(spanNode);
				spanNode.appendChild(range.createContextualFragment(strIn));
			}
			else {
				document.all('spnSpan').innerHTML = strIn;
			}
		}
		else if (document.all){
			document.all('spnSpan').innerHTML = strIn;
		}

	}


	function clear_text(){
		write_txa('');
		update_span();
	}


	function clear_HTML(){

		var strText	= theForm.txaEdit.innerText;
		var intLen	= strText.length;
		var strChar	= '';
		var strKeep	= '';

		var blnInHTML	= false;

		for(i=0; i < intLen; i++){

			strChar = strText.charAt(i);
			if(!(blnInHTML)){
				blnInHTML = (	(strChar == '<')	&&
								(!(strText.charAt(i+1).toLowerCase() + strText.charAt(i+2).toLowerCase() + strText.charAt(i+3) == 'br>')));
			}
			if(!(blnInHTML))	strKeep += strChar;
			if(blnInHTML)		blnInHTML = (!(strChar == '>'));
		}

		write_txa(strKeep);
		update_span();
	}


	function reset_undo_inx(){	inxUndo = arrUndo.length - 1;}

	function update_undo_array(strIn){

		var inxLastEntry = arrUndo.length - 1;
		if(inxUndo < inxLastEntry){
			for(var i = inxLastEntry; i > inxUndo; i--){
				pop(arrUndo);
			}
		}
		push(arrUndo, strIn);
		if(arrUndo.length > intUndoMax){
			shift(arrUndo);
		}
		reset_undo_inx();
	}

	function undo(){
		//alert('inxUndo:  ' + inxUndo);
		if(inxUndo > 0)	inxUndo--;
		//alert('inxUndo:  ' + inxUndo);
		array_to_screen(inxUndo);
	}


	function redo(){
		//alert('inxUndo:  ' + inxUndo);
		if(inxUndo < arrUndo.length - 1)	inxUndo++;
		//alert('inxUndo:  ' + inxUndo);
		array_to_screen(inxUndo);
	}

	function array_to_screen(inxUndo){
		if(	(inxUndo > -1) &&
			(inxUndo < arrUndo.length)	){
			theForm.txaEdit.innerText = arrUndo[inxUndo];
			write_span(theForm.txaEdit.innerText);
		}
	}

	function debug_undo_array(){

		alert('inxUndo:  ' + inxUndo);
		var  str = '';
		if(arrUndo.length > 0){
			for(var i = 0; i < arrUndo.length; i++){
				str = str + i + ':  ' + arrUndo[i] + '\n';
			}
			alert(str);
		}
	}



	function write_txa(strIn){
		theForm.txaEdit.innerText = strIn;
		update_undo_array(strIn);
	}

	function update_span(){
		write_span(theForm.txaEdit.innerText);
		theForm.txaEdit.focus();
	}


	function storeCaret (textEl) {
		if (textEl.createTextRange)
			textEl.caretPos = document.selection.createRange().duplicate();
	}


	function insertAtCaret (textEl, textBeg, textEnd) {
		if (textEl.createTextRange && textEl.caretPos) {
			var caretPos = textEl.caretPos;
			var theText = caretPos.text;
			//alert('caretPos.text = ' + caretPos.text);
			//alert('caretPos.text.length = ' + caretPos.text.length);
			//alert('caretPos.text.charAt(caretPos.text.length - 1) = ' + caretPos.text.charAt(caretPos.text.length - 1));

			if(caretPos.text.charAt(caretPos.text.length - 1) == '')
				alert('Please select the text you would like to format and try again');
				//caretPos.text =	textBeg + textEnd;
			else
				caretPos.text =	textBeg + theText + textEnd;
		}
		//else textEl.innerText = text;

		update_undo_array(theForm.txaEdit.innerText);
		storeCaret(textEl);
	}


	function makeBold(){

		insertAtCaret(theForm.txaEdit,'<b>', '</b>');
		update_span();
	}


	function makeItalics(){

		insertAtCaret(theForm.txaEdit,'<i>', '</i>');
		update_span();
	}


	function makeUnderline(){

		insertAtCaret(theForm.txaEdit,'<u>', '</u>');
		update_span();
	}


	function makeLink(){

		if(theForm.txtLink.value == theForm.txtLink.defaultValue){
			alert('Please enter the URL to which this link should point and try again');
			theForm.txtLink.focus();
		}
		else{
			insertAtCaret(theForm.txaEdit,'<a href="http://' + theForm.txtLink.value + '">', '</a>');
			update_span();
		}
	}


	function makeStyle(){

		var strSize		= theForm.selFSize.options[theForm.selFSize.selectedIndex].value == '' ? '' : ' size="' + theForm.selFSize.options[theForm.selFSize.selectedIndex].value + '"';
		var strColor	= theForm.selFColor.options[theForm.selFColor.selectedIndex].value == '' ? '' : ' color="' + theForm.selFColor.options[theForm.selFColor.selectedIndex].value + '"';
		insertAtCaret(theForm.txaEdit,'<font' + strSize + strColor + '>', '</font>');
		update_span();
	}
// -->
</script>
<%
End Sub


Sub DisplayDetail()
	GenHTMLHead
	Dim vntButtonName

	If strMode = "NEW" Then
		vntButtonName = "Submit Announcement"
	ElseIf strMode = "EDIT" Then
		vntButtonName = "Submit Changes"
	Else
		vntButtonName = vbNullString
	End If
%>
<table border="0">
<tr>
	<td valign="top" align="right" colspan="2">Effective Date:&nbsp;&nbsp;</td>
	<td valign="top" align="left" colspan="2">
<%
	If strMode = "NEW" Then
		RwLf "		<font size=""2""><input type=""text"" name=""txtEffectiveDt"" id=""txtEffectiveDt"" value=""" & vntEffectiveDt & """  maxlength=""10"" size=""12"">&nbsp;&nbsp;YYYY-MM-DD</font>"
	Else
		RwLf "		<font size=""2""><input type=""text"" name=""txtNewEffectiveDt"" id=""txtNewEffectiveDt"" value=""" & vntEffectiveDt & """  maxlength=""10"" size=""12"">&nbsp;&nbsp;YYYY-MM-DD</font>"
		'RwLf "		" & vntEffectiveDt
	End If
%>	</td>
	<td valign="top" align="right">
<%
	If strMode = "EDIT" Then
		RwLf "Active:&nbsp;&nbsp;"
		Rw "<input type=""checkbox"" name=""chkActive"" id=""chkActive"" value=""Y"""

		If vntActive = "Y" Then	Rw "CHECKED"
		Rw ">"
	Else
		Rw "Active:&nbsp;&nbsp;&nbsp;Y&nbsp;&nbsp"
	End If
%>	</td>
	<td valign="top" align="center">
		<input type="submit" name="smtSubmit" id="smtSubmit" value="<%=vntButtonName%>" onclick="if(IsValidDate(theForm.txtEffectiveDt.value)){return true;}else{alert('Please Enter a Valid Date');theForm.txtEffectiveDt.focus();theForm.txtEffectiveDt.select();return false;}">
	</td>
</tr>
<tr>
	<td valign="top" align="right" colspan="5">
<%
		RwLf "Planned:&nbsp;&nbsp;"
		Rw "<input type=""checkbox"" name=""chkPlanned"" id=""chkPlanned"" value=""Y"""

		If vntPlanned = "Y" Then	Rw "CHECKED"

		Rw ">"
%>	</td>
	<td valign="top" align="center">
		<%=strSearchBtn%>
	</td>
</tr>
<tr>
	<td colspan="5">
		<textarea name="txaEdit" id="txaEdit" rows="15" cols="80"
				onselect="storeCaret(theForm.txaEdit);"
				ondblclick="storeCaret(theForm.txaEdit);"
				onclick="storeCaret(theForm.txaEdit);"
				onkeyup="capture_key(theForm.txaEdit);"
				onmouseup="update_span();"><%=vntMsgText%></textarea>
	</td>
	<td align="center">
		<font size="2">
		<input type="button" name="btnClearHTML" id="btnClearHTML" value = "Clear All Formatting" onclick="clear_HTML();"><br><br>
		<input type="button" name="btnClear" id="btnClear" value = "Clear All Text" onclick="clear_text();"><br><br>
		<input type="button" name="btnUndo" id="btnUndo" value="Undo" onclick="undo();">&nbsp;(Ctrl-Z)<br>
		<input type="button" name="btnRedo" id="btnRedo" value="Redo" onclick="redo();">&nbsp;(Ctrl-Y)
		<!-- <input type="button" name="btnTest" id="btnTest" value="Debug" onclick="debug_undo_array();"> -->
		</font>
	</td>
</tr>

<tr>
	<td valign="top" align="center">
		<input type="button" name="btnBold" id="btnBold" value= "Bold" onclick="makeBold();">
	</td>
	<td valign="top" align="center">
		<input type="button" name="btnItal" id="btnItal" value= "Italics" onclick="makeItalics();">
	</td>
	<td valign="top" align="center">
		<input type="button" name="btnUnderline" id="btnUnderline" value= "Underline" onclick="makeUnderline();">
	</td>
	<td valign="top" align="center">
		<input type="button" name="btnLink" id="btnLink" value= "Make A HyperLink" onclick="makeLink();"><br>
		http://&nbsp;<input type="text" name="txtLink" id="txtLink" value="" size="30">
	</td>
	<td valign="top" align="center">
		<input type="button" name="btnFont" id="btnFont" value= "Apply Style" onclick="makeStyle();"><br>
		<select name="selFColor" id="selFColor">
			<option></option>
			<option value="red">Red</option>
			<option value="blue">Blue</option>
			<option value="green">Green</option>
			<option value="yellow">Yellow</option>
		</select>
		<select name="selFSize" id="selFSize">
			<option></option>
			<option value="-2">-2</option>
			<option value="-1">-1</option>
			<option value="0">0</option>
			<option value="1">1</option>
			<option value="2" selected>2</option>
			<option value="3">3</option>
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>
			<option value="7">7</option>
		</select>
	</td>
	<td valign="top" align="center">
		&nbsp;
	</td>
</tr>
</table>
<h2>Sample Display</h2>
<span id="spnSpan" style="position:absolute"></span>
<%
	GenHTMLFoot
End Sub

Sub Rw(strIn)
	Response.Write strIn
End Sub

Sub RwLf(strIn)
	Response.Write strIn
	Response.Write vbCrLf
End Sub
%>                      