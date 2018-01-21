<%@ Language=VBScript %>
<%Response.expires = 0%>
<%
	on error resume next
'*********************************************************
'Enter the following information
'*********************************************************
    strTableName = "SCORECARD_VIEWS"
    strObjectName = "DSCD.clsCallRS"
'*********************************************************
    
    strSql = "select 1 from " & strTableName
    
    Set objRS = Server.CreateObject(strObjectName)
    loRecSet = objRS.CallRS_NoConn(strSQL, _
		   vntCount, vntErrorNumber, vntErrorDescription)
	
    'loRecSet.MoveFirst
	
    Response.Write("<H3>Number of records: " & vntCount & "</H3><BR>")   

    'Set loRecSet = Nothing
    Set objRS = Nothing

    if err.number = 0 then
        Response.Write("hey there")   
    else
        response.redirect("404notfound")
    end if
     
%>

