' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    m.description = m.top.findNode("Description")
    m.background = m.top.findNode("Background")
    m.top.observeField("focusedChild", "OnFocusedChildChange")

    InitializeRowList()

    m.isInitialized = false

    m.top.observeField("visible", "onVisibleChange")

    InitializeVideoPlayer()
    InitializeContentOptionsDialog()
    InitializeRegistry()
End Function

Function InitializeRowList()
    m.rowList = m.top.findNode("RowList")
    m.rowList.observeField("rowItemFocused", "OnItemFocused")
    m.rowList.observeField("rowItemSelected", "OnItemSelected")
End Function

Function InitializeVideoPlayer()
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
End Function

Function InitializeContentOptionsDialog()
    m.contentOptionsDialog = m.top.findNode("contentOptionsDialog")
End Function

Function InitializeRegistry()
    m.videoPositions = CreateObject("roRegistrySection", "VideoPositions")
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

    positionKeys = m.videoPositions.GetKeyList()

    ? "Position Keys: " ; positionKeys

    positions = m.videoPositions.ReadMulti(positionKeys)

    transformedContent = TransFormJson(json, m.top.host, positions)
	m.rowList.content  = ObjectToContentNode(transformedContent)   
End Function

' handler of focused item in RowList
Sub OnItemFocused()
    itemFocused = m.rowList.rowItemFocused

    'When an item gains the key focus, set to a 2-element array, 
    'where element 0 contains the index of the focused row, 
    'and element 1 contains the index of the focused item in that row.
    If itemFocused.Count() = 2 then
        focusedContent = m.top.content.getChild(itemFocused[0]).getChild(itemFocused[1])
        ? "Focused: " ; focusedContent.title
        if focusedContent <> invalid then
            m.focusedContent = focusedContent
            m.description.content = focusedContent
            'm.background.uri = focusedContent.hdBackgroundImageUrl
        end if
    end if
End Sub

Function OnItemSelected()
    ? "Item Selected" ; m.focusedContent.title
    if m.focusedContent <> invalid then
        ? "Focused: " ; m.focusedContent.title
        if (m.focusedContent.position = 0)
            PlaySelected(false)
        else
            ? "Show Options"
            m.contentOptionsDialog.visible = true
            m.top.getParent().dialog = m.contentOptionsDialog
        end if
        result = true
    end if
End Function

' set proper focus to RowList in case if return from Details Screen
Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.rowList.hasFocus() then
        m.rowList.setFocus(true)
    end if
End Sub

Function OnContentOptionsDialogButtonSelected()
    buttonIndex = m.contentOptionsDialog.buttonSelected

    HandleOptionsDialogButton(m.contentOptionsDialog.buttons[buttonIndex])
End Function

Function HandleOptionsDialogButton(button as string)
    if button = "Resume" then
        PlaySelected(false)
    else
        PlaySelected(true)
    end if

    m.contentOptionsDialog.close = true
End Function

Function OnVideoPlayerStateChange()
    ? "Player State: " ; m.videoPlayer.state
    if m.videoPlayer.state = "error"
        ' error handling
        m.videoPlayer.visible = false
        HandleVideoStop(false)
    else if m.videoPlayer.state = "playing"
        ' playback handling
    else if m.videoPlayer.state = "finished"
        m.videoPlayer.visible = false
        HandleVideoStop(true)
    else if m.videoPlayer.state = "stopped"
        m.videoPlayer.visible = false
        HandleVideoStop(false)
    end if
End Function

Function onVideoVisibleChange()
    if m.videoPlayer.visible = false and m.top.visible = true
        StopVideo()
    end if
End Function

Function HandleVideoStop(isFinished as boolean)
    id = m.focusedContent.id
    position = m.videoPlayer.position

    if isFinished then
        position = 0
    end if

    m.focusedContent.position = position

    if isFinished then
        DeletePosition(id)
    else
        SaveTimeStamp(id, position)
    end if
End Function

Function StopVideo()
    m.top.setFocus(true)
    m.videoPlayer.control = "stop"
end Function

Function PlaySelected(startOver as boolean)
    m.videoPlayer.content = m.focusedContent
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
    m.videoPlayer.control = "play"

    if not startOver then
       m.videoPlayer.seek = m.focusedContent.position
    end if    
End Function

Function SaveTimeStamp(id as string, seconds as float)
    value = Str(seconds)

    m.videoPositions.Write(id, value)
    m.videoPositions.Flush()
End Function

Function DeletePosition(id as string)
    if m.videoPositions.exists(id) then
        m.videoPositions.delete(id)
        m.videoPositions.flush()
    end if
End Function