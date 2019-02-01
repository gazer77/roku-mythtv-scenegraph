Function Init()
	m.top.functionName = "getContent"
End Function

Function getContent()
    json = GetApiData(m.top.apiUrl)
    m.top.json = json
End Function

Function GetApiData(apiUrl)
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(apiUrl)
    urlTransfer.AddHeader("accept", "application/json")
    response = urlTransfer.GetToString()

    return ParseJSON(response)
End Function