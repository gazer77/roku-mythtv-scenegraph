' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    m.rowList = m.top.findNode("RowList")
    m.description = m.top.findNode("Description")
    m.background = m.top.findNode("Background")

    m.top.observeField("focusedChild", "OnFocusedChildChange")

    m.isInitialized = false

    m.top.observeField("visible", "onVisibleChange")

    InitializeVideoPlayer()
End Function

Function InitializeVideoPlayer()
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
End Function

Function onVisibleChange()
    if m.top.visible and m.isInitialized = false then
        GetContent()
        m.isInitialized = true
    end if
End Function

Function GetContent()
    m.contentTask = createObject("roSGNode", "videosContentTask")
    m.contentTask.observeField("content","LoadContent")
    m.contentTask.host = m.top.host
    m.contentTask.Control = "RUN"
End Function

Function LoadContent()
    json = m.contentTask.content

    transformedContent = TransFormJson(json, m.top.host)
	m.rowList.content  = ObjectToContentNode(transformedContent)   
End Function

' handler of focused item in RowList
Sub OnItemFocused()
    itemFocused = m.top.itemFocused

    'When an item gains the key focus, set to a 2-element array, 
    'where element 0 contains the index of the focused row, 
    'and element 1 contains the index of the focused item in that row.
    If itemFocused.Count() = 2 then
        focusedContent = m.top.content.getChild(itemFocused[0]).getChild(itemFocused[1])
        if focusedContent <> invalid then
            m.top.focusedContent = focusedContent
            m.description.content = focusedContent
            'm.background.uri = focusedContent.hdBackgroundImageUrl
        end if
    end if
End Sub

' set proper focus to RowList in case if return from Details Screen
Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.rowList.hasFocus() then
        m.rowList.setFocus(true)
    end if
End Sub

Function OnVideoPlayerStateChange()
    ? "Player State: " ; m.videoPlayer.state
    if m.videoPlayer.state = "error"
        ' error handling
        m.videoPlayer.visible = false
    else if m.videoPlayer.state = "playing"
        ' playback handling
    else if m.videoPlayer.state = "finished"
        m.videoPlayer.visible = false
    else if m.videoPlayer.state = "stop"
        m.videoPlayer.visible = false
        HandleVideoStop()
    end if
End Function

Function onVideoVisibleChange()
    if m.videoPlayer.visible = false and m.top.visible = true
        StopVideo()
    end if
End Function

Function HandleVideoStop()
End Function

Function StopVideo()
    m.top.setFocus(true)
    m.videoPlayer.control = "stop"
end Function

Function PlaySelected()
    ' first button is Play
    ? "Playing "; m.top.focusedContent.title
    m.videoPlayer.content = m.top.focusedContent
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
    m.videoPlayer.control = "play"
End Function