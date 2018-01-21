<%
'========================== Array Functions =============================
'	Author:  James Thomas - CAI
'
'
'	Push adds an element to the end of an array
'	Pop removes and returns the last element of an array
'	Unshift adds an element to the beginning of an array
'	Shift removes and returns the last element of an array
'
'	Push and Unshift also accept another array in place of
'	the element argument and will add the entire array,
'	in the same order as the added array.
'
'	Examples of use:
'
'		Dim an_array
'			an_array = Array()
'
'		Push an_array, "Bobby"
'		Push an_array, "Billy"
'		Push an_array, "Jimmy"
'
'		an_array will contain "Bobby", "Billy", "Jimmy"
'
'		varHisName = Pop(an_array)
'
'		varHisName will equal "Jimmy"
'		an_array will contain "Bobby", "Billy"
'
'		Dim another_array
'			another_array = Array()
'
'		Unshift another_array, an_array
'		Unshift another_array, "Lori"
'       Unshift another_array, "Shelly"
'
'		another_array will contain "Shelly", "Lori", "Bobby", "Billy"
'
'		varHerName = Shift(another_array)
'
'		varHerName will equal "Shelly"
'		another_array will contains "Lori", "Bobby", "Billy"
'
'===============================================
Function TrimArrayData(TAD_vntArrayIO)
	Dim TAD_iLoopy
	For TAD_iLoopy = 0 To UBound(TAD_vntArrayIO)
		TAD_vntArrayIO(TAD_iLoopy) = Trim(CStr(TAD_vntArrayIO(TAD_iLoopy)))
	Next
End Function

Function Swap(Swap_vntArrayIO, Swap_inxIndex1, Swap_inxIndex2)
	Dim Swap_vntTemp
	Swap_vntTemp = Swap_vntArrayIO(Swap_inxIndex1)
	Swap_vntArrayIO(Swap_inxIndex1) = Swap_vntArrayIO(Swap_inxIndex2)
	Swap_vntArrayIO(Swap_inxIndex2) = Swap_vntTemp
End Function

Function SortListAsc(SL_vntArrayIn)

	Dim SL_blnUnSorted, SL_inx
		SL_blnUnSorted = True

	Do While(SL_blnUnSorted)
		SL_blnUnSorted = False
		For SL_inx = 0 To (UBound(SL_vntArrayIn) - 1)
			If CStr(SL_vntArrayIn(SL_inx)) > CStr(SL_vntArrayIn(SL_inx + 1)) Then
				'Swap them
				Swap SL_vntArrayIn, SL_inx, SL_inx + 1
				SL_blnUnSorted = True
			End If
		Next
    Loop
End Function

Function SortListDesc(SL_vntArrayIn)

	Dim SL_blnUnSorted, SL_inx
		SL_blnUnSorted = True

	Do While(SL_blnUnSorted)
		SL_blnUnSorted = False
		For SL_inx = 0 To (UBound(SL_vntArrayIn) - 1)
			If CStr(SL_vntArrayIn(SL_inx)) < CStr(SL_vntArrayIn(SL_inx + 1)) Then
				'Swap them
				Swap SL_vntArrayIn, SL_inx, SL_inx + 1
				SL_blnUnSorted = True
			End If
		Next
    Loop
End Function

Function Push(Push_vntArrayIO, Push_vntIncoming)
'This function adds an element (or an array of elements)
'onto the end of an existing list array.

	If Not IsArray(Push_vntArrayIO) Then Push_vntArrayIO = Array()

	Dim Push_vntUBound_vntArrayIO

	If IsArray(Push_vntIncoming) Then
		Dim Push_Index_For_Add, Push_vntUBound_vntIncoming, Push_inx
			Push_Index_For_Add = UBound(Push_vntArrayIO) + 1
			Push_vntUBound_vntIncoming = UBound(Push_vntIncoming)
			Push_vntUBound_vntArrayIO = UBound(Push_vntArrayIO) + Push_vntUBound_vntIncoming + 1
		ReDim Preserve Push_vntArrayIO(Push_vntUBound_vntArrayIO)
		For Push_inx = 0 To Push_vntUBound_vntIncoming
			Push_vntArrayIO(Push_Index_For_Add + Push_inx) = Push_vntIncoming(Push_inx)
		Next
	Else
		Push_vntUBound_vntArrayIO = UBound(Push_vntArrayIO) + 1
		ReDim Preserve Push_vntArrayIO(Push_vntUBound_vntArrayIO)
		Push_vntArrayIO(Push_vntUBound_vntArrayIO) = Push_vntIncoming
	End if
End Function

Function Pop(Pop_vntArrayIO)
'This function removes and returns the last element of a list array
	Dim Pop_vntUBound_vntArrayIO
		Pop_vntUBound_vntArrayIO = UBound(Pop_vntArrayIO)
	Pop = Pop_vntArrayIO(Pop_vntUBound_vntArrayIO)
	If Pop_vntUBound_vntArrayIO - 1 < 0 Then
		erase Pop_vntArrayIO
		Pop_vntArrayIO = Array()
	Else
		ReDim Preserve Pop_vntArrayIO(Pop_vntUBound_vntArrayIO - 1)
	End If
End Function

Function Shift(Shift_vntArrayIO)
'This function removes and returns the first element of a list array
	Dim Shift_vntUBound_vntArrayIO, Shift_New_vntUBound_vntArrayIO
		Shift_vntUBound_vntArrayIO = UBound(Shift_vntArrayIO)
		Shift_New_vntUBound_vntArrayIO = Shift_vntUBound_vntArrayIO - 1

	Shift = Shift_vntArrayIO(0)
	If Shift_vntUBound_vntArrayIO - 1 < 0 Then
		erase Shift_vntArrayIO
		Shift_vntArrayIO = Array()
	Else
		For Shift_inx = 0 To Shift_New_vntUBound_vntArrayIO
			Shift_vntArrayIO(Shift_inx) = Shift_vntArrayIO(Shift_inx + 1)
		Next
        ReDim Preserve Shift_vntArrayIO (Shift_New_vntUBound_vntArrayIO)
	End If
End Function

Function Unshift(Unshift_vntArrayIO, Unshift_vntIncoming)
'This function adds an element (or an array of elements)
'onto the beginning of an existing list array.

	If Not IsArray(Unshift_vntArrayIO) Then Unshift_vntArrayIO = Array()

	Dim Unshift_vntUBound_vntArrayIO, Unshift_New_UBound, Unshift_inx
		Unshift_vntUBound_vntArrayIO = UBound(Unshift_vntArrayIO)

	If IsArray(Unshift_vntIncoming) Then
		Dim Unshift_vntUBound_vntIncoming, Unshift_UBound_span
		Unshift_vntUBound_vntIncoming = UBound(Unshift_vntIncoming)
		Unshift_New_UBound = ((Unshift_vntUBound_vntArrayIO + 1) + (Unshift_vntUBound_vntIncoming + 1)) - 1
		Unshift_UBound_span = Unshift_vntUBound_vntIncoming + 1
		ReDim Preserve Unshift_vntArrayIO(Unshift_New_UBound)
		'Shift existing element data over
		For Unshift_inx = Unshift_New_UBound To Unshift_UBound_span Step -1
			'Response.write "Unshift_vntArrayIO(" & Unshift_inx & ") = Unshift_vntArrayIO(" & Unshift_inx - Unshift_UBound_span & ") = " & Unshift_vntArrayIO(Unshift_inx - Unshift_UBound_span) & "<BR>"
			Unshift_vntArrayIO(Unshift_inx) = Unshift_vntArrayIO(Unshift_inx - Unshift_UBound_span)
		Next
		'Insert the new element data
		For Unshift_inx = 0 To Unshift_vntUBound_vntIncoming
			Unshift_vntArrayIO(Unshift_inx) = Unshift_vntIncoming(Unshift_inx)
		Next
	Else
		Unshift_New_UBound = Unshift_vntUBound_vntArrayIO + 1
		ReDim Preserve Unshift_vntArrayIO(Unshift_New_UBound)
		If Unshift_New_UBound > 0 Then
			For Unshift_inx = Unshift_New_UBound To 1 Step -1
				Unshift_vntArrayIO(Unshift_inx) = Unshift_vntArrayIO(Unshift_inx - 1)
			Next
		End If
		Unshift_vntArrayIO(0) = Unshift_vntIncoming
	End If
End Function
%>