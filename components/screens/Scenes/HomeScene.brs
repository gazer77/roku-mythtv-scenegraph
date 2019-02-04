' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    ' listen on port 8089
    ? "[HomeScene] Init"
    
    ' loading indicator starts at initializatio of channel
    'm.loadingIndicator = m.top.findNode("loadingIndicator")
    m.videoPlayer = m.top.findNode("videoPlayer")

    m.buttonMenu = m.top.findNode("buttonMenu")

    m.buttonMenu.setFocus(true)

    m.menuItemFocused = false

    m.contentOptionsDialog = m.top.findNode("contentOptionsDialog")
    m.deleteDialog = m.top.findNode("deleteDialog")

    m.currentScreen = m.top.findNode("recordingsScreen")

    m.top.observeField("selectedMenu", "OnSelectedMenuChanged")
End Function

Function OnSelectedMenuChanged()
    menuName = m.top.selectedMenu

    m.currentScreen.visible = false
    if menuName = "buttonRecordings"
        if m.recordingsScreen = invalid
            m.recordingsScreen = m.top.findNode("recordingsScreen")
            m.recordingsScreen.observeField("rowItemSelected", "OnItemSelected")
        end if
        
        m.recordingsScreen.visible = true
        m.currentScreen = m.recordingsScreen
    else if menuName = "buttonVideo"
        if m.videosScreen = invalid
            m.videosScreen = m.top.findNode("videosScreen")
            m.videosScreen.observeField("rowItemSelected", "OnItemSelected")
        end if

        m.videosScreen.visible = true
        m.currentScreen = m.videosScreen
    else if menuName = "buttonMusic"
        
    else if menuName = "buttonSchedule"
        
    else if menuName = "buttonSettings"
        
    end if
End Function

' Row item selected handler
Function OnItemSelected()
    HandleOptions()
End Function

' Main Remote keypress event loop
Function OnKeyEvent(key, press) as Boolean
    ? ">>> HomeScene >> OnkeyEvent " ; key ; " " ; press
    result = false
    if press then
        if key = "right"
            ? "Selected Menu "; m.top.selectedMenu
            HandleMenuItem(m.top.selectedMenu)
        end if
        if key = "options"

        end if
        if key = "back"
            if m.currentScreen.visible = false and m.videoPlayer.visible = true
                ? "Back From Player"
                m.videoPlayer.visible = false
                result = true

            else if m.videoPlayer.visible = false and m.menuItemFocused
                m.buttonMenu.setFocus(true)
                m.menuItemFocused = false
                result = true
            else
                if m.videoPlayer.visible
                    StopVideo()
                    m.videoPlayer.visible = false
                    result = true
                end if
            end if
        else if key = "OK"
            ? "[Home] Enter "; m.currentScreen.focusedContent.title

            PlaySelected()
        else if key = "play"
            if m.currentScreen.focusedContent <> invalid
                PlaySelected()
            end if
        end if

    end if
    return result
End Function

Function HandleMenuItem(menuName)
    if menuName = "buttonRecordings"
        HandleRecording()
    else if menuName = "buttonVideo"
        HandleVideo()
    else if menuName = "buttonMusic"
        HandleMusic()
    else if menuName = "buttonSchedule"
        HandleSchedule()
    else if menuName = "buttonSettings"
        HandleSettings()
    end if
end Function

Function HandleRecording()
    m.recordingsScreen.setFocus(true)

    m.menuItemFocused = true
End Function

Function HandleVideo()
    m.videosScreen.setFocus(true)

    m.menuItemFocused = true
End Function

Function HandleMusic()
    ? "Music"
End Function

Function HandleSchedule()
    ? "Schedule"
End Function

Function HandleSettings()
    ? "Settings"
End Function

Function HandleOptions()
    m.contentOptionsDialog.message = m.currentScreen.focusedContent.title + ": " + m.currentScreen.focusedContent.subTitle
    m.contentOptionsDialog.visible = true
    m.contentOptionsDialog.setFocus(true)
End Function

Function HandleDelete()
    m.deleteDialog.title = "Delete " + m.currentScreen.focusedContent.title + "?"
    m.deleteDialog.message = m.currentScreen.focusedContent.subTitle
    m.deleteDialog.visible = true
    m.deleteDialog.setFocus(true)
End Function

' event handler of Video player msg
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

Function StopVideo()
    m.currentScreen.setFocus(true)
    m.videoPlayer.control = "stop"
end Function

' on Button press handler
Function PlaySelected()
    ' first button is Play
    ? "Playing "; m.currentScreen.focusedContent.title
    m.videoPlayer.content = m.currentScreen.focusedContent
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
    m.videoPlayer.control = "play"
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
End Function

Function OnContentOptionsDialogButtonSelected()
    ? "Button Selected " ; m.contentOptionsDialog.buttonSelected

    m.contentOptionsDialog.visible = false
    if m.contentOptionsDialog.buttonSelected = 0
        PlaySelected()
    end if   
    if m.contentOptionsDialog.buttonSelected = 1
        HandleDelete()
    end if
End Function

Function OnDeleteDialogButtonSelected()
    ? "Button Selected " ; m.deleteDialog.buttonSelected
    if m.deleteDialog.buttonSelected = 0
        Delete()
    end if

    m.deleteDialog.visible = false
    m.currentScreen.setFocus(true)
End Function

Function HandleVideoStop()
End Function

Function Delete()
End Function