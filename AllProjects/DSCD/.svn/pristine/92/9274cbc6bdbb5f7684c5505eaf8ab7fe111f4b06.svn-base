<%
Dim objFSO
Dim strFileName, dtMostRecent

Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
GetFolderDate Server.MapPath(".")

dtMostRecent = FormatDateTime(dtMostRecent,vbLongDate)
dtMostRecent = Split(dtMostRecent,",")(1) & ", " & Split(dtMostRecent,",")(2)

Set objFSO = Nothing


Sub GetFolderDate(ByVal strPath)
   Dim objFolder, objFile, objSubdirs, objLoopFolder
   Dim intDaysBetween
   
   Set objFolder = objFSO.GetFolder(strPath)
   
	'Check files in this directory
	For Each objFile in objFolder.Files
		intDaysBetween = DateDiff("d", cDate(objFile.DateLastModified), dtMostRecent)

		If (intDaysBetween < 0) Then
			'Current file is more recent
			dtMostRecent = objFile.DateLastModified
			strFileName = objFile.name
		End If
	Next
 
   'Loop through all subdirectories
   Set objSubdirs = objFolder.SubFolders
   For Each objLoopFolder In objSubdirs
      GetFolderDate objLoopFolder.Path
   Next 
   
   Set objSubdirs = Nothing
   Set objFolder = Nothing
   
End Sub

with response
	.write "<BR><BR>"
	.write "<Table border=0 width=100% align=center>"
	.write "<tr><td align=left>"
	.write "<A href=""profile.asp"">Site Profile</A></TD>"
	.write "<td align=right>Last Updated: " &  month(dtMostRecent) & "/" & day(dtMostRecent) & "/" & year(dtMostRecent) & "<td>"
	.write "<tr>"
	.write "</table>"

end with



%>
