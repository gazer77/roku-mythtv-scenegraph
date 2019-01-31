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

    m.detailsScreen = m.top.findNode("detailsScreen")

    m.buttonMenu = m.top.findNode("buttonMenu")

    m.buttonMenu.setFocus(true)

    m.menuItemFocused = false
End Function

' Row item selected handler
Function OnItemSelected()
    ' On select any item on home scene, show Details node and hide Grid
    ? "Selected "; m.currentScreen.focusedContent.title

    m.currentScreen.visible = false
    m.detailsScreen.content = m.currentScreen.focusedContent
    m.detailsScreen.setFocus(true)
    m.detailsScreen.visible = true
End Function

' Main Remote keypress event loop
Function OnKeyEvent(key, press) as Boolean
    '? ">>> HomeScene >> OnkeyEvent " ; key ; " " ; press
    result = false
    if press then
        if key = "right"
            ? "Selected Menu "; m.top.selectedMenu
            HandleMenuItem(m.top.selectedMenu)
        end if
        if key = "options"
            ' option key handler
        else if key = "back"
            ? "Back"
            ' if Details opened
            if m.currentScreen.visible = false and m.videoPlayer.visible = false
                ? "Back From Details"
                m.currentScreen.visible = true
                m.detailsScreen.visible = false
                m.currentScreen.setFocus(true)
                result = true

            ' if video player opened
            else if m.currentScreen.visible = false and m.videoPlayer.visible = true
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
    if m.recordingsScreen = invalid
        m.recordingsScreen = m.top.findNode("recordingsScreen")
        m.recordingsScreen.observeField("rowItemSelected", "OnItemSelected")
    end if

    m.currentScreen = m.recordingsScreen

    m.recordingsScreen.setFocus(true)

    m.menuItemFocused = true
End Function

Function HandleVideo()
    ? "Video"
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

Sub onVideoVisibleChange()
    if m.videoPlayer.visible = false and m.top.visible = true
        StopVideo()
    end if
End Sub

Function StopVideo()
    m.currentScreen.setFocus(true)
    m.videoPlayer.control = "stop"
end Function

' event handler of Video player msg
Sub OnVideoPlayerStateChange()
    ? "Player State: " ; m.videoPlayer.state
    if m.videoPlayer.state = "error"
        ' error handling
        m.videoPlayer.visible = false
    else if m.videoPlayer.state = "playing"
        ' playback handling
    else if m.videoPlayer.state = "finished"
        m.videoPlayer.visible = false
    end if
End Sub

' on Button press handler
Sub PlaySelected()
    ' first button is Play
    ? "Playing "; m.currentScreen.focusedContent.title
    m.videoPlayer.content = m.currentScreen.focusedContent
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
    m.videoPlayer.control = "play"
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
End Sub