Function GetApiData(apiUrl)
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(apiUrl)
    urlTransfer.AddHeader("accept", "application/json")
    response = urlTransfer.GetToString()

    return ParseJSON(response)
End Function