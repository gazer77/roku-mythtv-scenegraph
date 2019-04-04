Function Init()
	m.top.functionName = "deleteContent"
End Function

Function deleteContent()
    host = m.top.host
    
    deleteUrl = "http://" + host + "/Dvr/DeleteRecording?RecordedId=" + m.top.recordingId + "&ForceDelete=1"

	m.top.success = DeleteRecordingApi(deleteUrl, m.top.recordingId)
End Function

Function DeleteRecordingApi(apiUrl, recordingId)
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(apiUrl)
    'urlTransfer.AddHeader("accept", "application/json")
    'urlTransfer.AddHeader("application", "x-www-form-urlencoded")
    response = 200
    
    'urlTransfer.PostFromString("") '"RecordedId=" + recordingId + "&ForceDelete=1")
    
    ? "Delete Response: " ; apiUrl ; " " ; response
    if response = 200 then
        return true
    else
        return false
    end if
End Function