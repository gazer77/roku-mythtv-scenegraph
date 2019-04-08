' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    IniitializeRowList()
    m.description = m.top.findNode("Description")
    m.background = m.top.findNode("Background")
    
    m.isInitialized = false

    m.top.observeField("visible", "onVisibleChange")

    InitializeVideoPlayer()
    InitializeDialogs()
    InitializeRegistry()
End Function

Function IniitializeRowList()
    m.rowList = m.top.findNode("RowList")
    m.rowList.observeField("rowItemFocused", "OnItemFocused")
    m.rowList.observeField("rowItemSelected", "OnItemSelected")
End Function

Function InitializeDialogs()
    m.contentOptionsDialog = m.top.findNode("contentOptionsDialog")
    m.deleteDialog = m.top.findNode("deleteDialog")
End Function

Function InitializeVideoPlayer()
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
End Function

Function InitializeRegistry()
    m.recordingPositions = CreateObject("roRegistrySection", "RecordingPositions")
End Function

Function OnItemSelected()
    m.contentOptionsDialog.message = m.top.focusedContent.title + ": " + m.top.focusedContent.subTitle
    m.contentOptionsDialog.visible = true

    if m.top.focusedContent.position > 0 then
        m.contentOptionsDialog.buttons = ["Resume","Restart","Delete"]
    else
        m.contentOptionsDialog.buttons = ["Play","Delete"]
    end if

    m.top.getParent().dialog = m.contentOptionsDialog
End Function

Function onVisibleChange()
    if m.top.visible then
        if m.isInitialized = false then
            GetContent()
            m.isInitialized = true
        end if
        m.RowList.setFocus(true)
    end if
End Function

Function OnVideoPlayerStateChange()
    ? "Player State: " ; m.videoPlayer.state
    if m.videoPlayer.state = "error"
        HandleVideoStop()
        m.videoPlayer.visible = false
    else if m.videoPlayer.state = "playing"
        ' playback handling
    else if m.videoPlayer.state = "finished"
        HandleVideoStop()
    else if m.videoPlayer.state = "stopped"
        HandleVideoStop()
    end if
End Function

Function onVideoVisibleChange()
    if m.videoPlayer.visible = false and m.top.visible = true
        StopVideo()
    end if
End Function

Function HandleVideoStop()
    m.videoPlayer.visible = false

    id = m.top.focusedContent.id
    position = m.videoPlayer.position

    m.top.focusedContent.position = position

    SaveTimeStamp(id, position)

    m.RowList.setFocus(true)
End Function

Function StopVideo()
    m.top.setFocus(true)
    m.videoPlayer.control = "stop"
end Function

Function GetContent()
    m.contentTask = createObject("roSGNode", "recordingsContentTask")
    m.contentTask.observeField("content","LoadContent")
    m.contentTask.host = m.top.host
    m.contentTask.Control = "RUN"
End Function

Function LoadContent()
    json = m.contentTask.content

    positionKeys = m.recordingPositions.GetKeyList()

    positions = m.recordingPositions.ReadMulti(positionKeys)

    m.rowList.content = TransformJson(json, m.top.host, positions)
End Function

' handler of focused item in RowList
Sub OnItemFocused()
    itemFocused = m.rowList.rowItemFocused

    'When an item gains the key focus, set to a 2-element array, 
    'where element 0 contains the index of the focused row, 
    'and element 1 contains the index of the focused item in that row.
    If itemFocused.Count() = 2 then
        row = m.top.content.getChild(itemFocused[0])
        focusedContent = row.getChild(itemFocused[1])
        
        ? "Row: " ; focusedContent.rowIndex ; " Column: " ; focusedContent.columnIndex

        if focusedContent <> invalid then
            m.top.focusedContent = focusedContent
            m.description.content = focusedContent
            'm.background.uri = focusedContent.hdBackgroundImageUrl
        end if
    end if
End Sub

' set proper focus to RowList in case if return from Details Screen
Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.rowList.hasFocus() and NoDialogVisible() then
        m.rowList.setFocus(true)
    end if
End Sub

Function NoDialogVisible()
    return not (m.contentOptionsDialog.visible Or m.deleteDialog.visible)
End Function

Function PlaySelected(startOver as boolean)
    ' first button is Play
    ? "Playing "; m.top.focusedContent.title

    m.videoPlayer.content = m.top.focusedContent
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
    m.videoPlayer.control = "play"

    if not startOver then
       m.videoPlayer.seek = m.top.focusedContent.position
    end if
End Function

Function OnContentOptionsDialogButtonSelected()
    buttonIndex = m.contentOptionsDialog.buttonSelected

    m.contentOptionsDialog.close = true

    HandleOptionsDialogButton(m.contentOptionsDialog.buttons[buttonIndex])
End Function

Function HandleOptionsDialogButton(button as string)
    if button = "Play" or button = "Resume" then
        PlaySelected(false)
    else if button = "Restart"
        PlaySelected(true)
    else if button = "Delete" then
        HandleDelete()
    end if
End Function

Function HandleDelete()
    m.deleteDialog.title = "Delete " + m.top.focusedContent.title + "?"
    m.deleteDialog.message = m.top.focusedContent.subTitle
    m.deleteDialog.visible = true

    m.top.getParent().dialog = m.deleteDialog
End Function

Function OnDeleteDialogButtonSelected()
    ? "Button Selected " ; m.deleteDialog.buttonSelected
    if m.deleteDialog.buttonSelected = 0
        Delete()
    end if

    m.deleteDialog.close = true
    'm.RowList.setFocus(true)
End Function

Function Delete()
    m.deleteRecordingTask = createObject("roSGNode", "deleteRecordingTask")
    m.deleteRecordingTask.observeField("success","DeleteComplete")
    m.deleteRecordingTask.host = m.host
    m.deleteRecordingTask.recordingId = m.top.focusedContent.id
    m.deleteRecordingTask.Control = "RUN"
End Function

Function DeleteComplete()
    if m.deleteRecordingTask.success then
        isRecentItem = false
        itemRow = m.rowList.rowItemSelected[0]
        itemColumn = m.rowList.rowItemSelected[1]

        if itemRow = 0 then
            isRecentItem = true

            itemRow = itemColumn + 1
            itemColumn = 0
        end if

        ? "Recent: " ; isRecentItem ; "  " ; itemRow ; ", " ; itemColumn

        if isRecentItem or itemColumn = 0 then
            'there are more items in the origin row to replace the recent
            if m.top.content.getChild(itemRow).getChildCount() > 1 then
                ReplaceRecentItem(itemRow, itemColumn)
                RemoveFromRow(itemRow, 0)
            else
                'remove the row
                m.top.content.removeChildIndex(itemRow)

                'the recent item corresponds to the row - 1
                'converting what amounts to a 1 based array to a 0 based
                RemoveFromRow(0, itemRow - 1)
            end if
        else
            RemoveFromRow(itemRow, itemColumn)
        end if
    end if
End Function

Function ReplaceRecentItem(originRowIndex, originColumnIndex)
    replacementCanidate = m.top.content.getChild(originRowIndex).getChild(originColumnIndex + 1)
    replacementJson = replacementCanidate.json
    replacement = CreateContentNode(replacementJson, m.top.host, replacementCanidate.position)

    m.top.content.getChild(0).replaceChild(replacement, originRowIndex - 1)
End Function

Function RemoveFromRow(rowIndex as integer, columnIndex as integer)
    DeletePosition(m.top.focusedContent.id)

    m.top.content.getChild(rowIndex).removeChildIndex(columnIndex)
End Function

'Move a child to the end of the row by getting it and appending it
Function MoveToEndOfRow(rowIndex as integer, columnIndex as integer)
    item = m.top.content.getChild(rowIndex).getChild(columnIndex)
    m.top.content.getChild(rowIndex).appendChild(item)
End Function

Function DeletePosition(id as string)
    if m.recordingPositions.exists(id) then
        m.recordingPositions.delete(id)
        m.recordingPositions.flush()
    end if
End Function

Function SaveTimeStamp(id as string, seconds as float)
    value = Str(seconds)

    m.recordingPositions.Write(id, value)
    m.recordingPositions.Flush()
End Function