Function Init()
	m.top.functionName = "getContent"
End Function

Function getContent()
    apiUrl = "http://" + m.top.host + "/Video/GetVideoList"
    m.top.content = GetApiData(apiUrl) 
End Function