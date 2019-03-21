Function Init()
	m.top.functionName = "deleteContent"
End Function

Function deleteContent()
    host = m.top.host
    'host = "172.16.254.103:6544"
    deleteUrl = "http://" + host + "/Dvr/DeleteRecording?RecordedId=" + m.top.recordingId + "&ForceDelete=1"
    'json = DeleteRecordingApi(deleteUrl, m.top.recordingId)

    'jsonReponse = ParseJSON(json)

	m.top.success = DeleteRecordingApi(deleteUrl, m.top.recordingId) 'jsonReponse.bool
End Function

Function DeleteRecordingApi(apiUrl, recordingId)
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(apiUrl)
    'urlTransfer.AddHeader("accept", "application/json")
    'urlTransfer.AddHeader("application", "x-www-form-urlencoded")
    response = urlTransfer.PostFromString("") '"RecordedId=" + recordingId + "&ForceDelete=1")
    
    ? "Delete Response: " ; apiUrl ; " " ; response
    if response = 200 then
        return true
    else
        return false
    end if
End Function