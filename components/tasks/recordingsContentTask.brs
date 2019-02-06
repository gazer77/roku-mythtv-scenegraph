Function Init()
	m.top.functionName = "getContent"
End Function

Function getContent()
    apiUrl = "http://" + m.top.host + "/Dvr/GetRecordedList"
    json = GetApiData(apiUrl)

	m.top.content = json
End Function