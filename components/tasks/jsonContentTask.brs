Function Init()
	m.top.functionName = "getContent"
End Function

Function getContent()
    jsonContent = GetApiData(m.top.apiUrl)
    m.top.content = jsonContent
End Function

Function GetApiData(apiUrl)
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(apiUrl)
    urlTransfer.AddHeader("accept", "application/json")
    response = urlTransfer.GetToString()

    return ParseJSON(response)
End Function