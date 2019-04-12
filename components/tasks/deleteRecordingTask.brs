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
    response = 200
    
    urlTransfer.PostFromString("RecordedId=" + recordingId + "&ForceDelete=1")
    
    if response = 200 then
        return true
    else
        return false
    end if
End Function