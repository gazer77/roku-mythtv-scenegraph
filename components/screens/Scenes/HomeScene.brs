Function Init()
    ' listen on port 8089
    ? "[HomeScene] Init"
    
    ' loading indicator starts at initializatio of channel
    'm.loadingIndicator = m.top.findNode("loadingIndicator")
    GetSettings()
    InitializeVideoPlayer()
    InitializeMenu()
    InitializeDialogs()
    InitializeScreens()  
End Function

Function GetSettings()
    m.host = "172.16.254.20:6544"
End Function

Function InitializeVideoPlayer()
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
End Function

Function InitializeMenu()
    m.buttonMenu = m.top.findNode("buttonMenu")
    m.buttonMenu.setFocus(true)
    m.menuItemFocused = false
    m.top.observeField("selectedMenu", "OnSelectedMenuChanged")
End Function

Function InitializeDialogs()
    m.contentOptionsDialog = m.top.findNode("contentOptionsDialog")
    m.deleteDialog = m.top.findNode("deleteDialog")
End Function

Function InitializeScreens()
    ? "Screens Init"
    InitializeRecordingsScreen()
    InitializeVideosScreen()
    InitializeMusicScreen()
    InitializeSchedulesScreen()
    InitializeSettingsScreen()

    m.currentScreen = m.recordingsScreen
    m.currentScreen.visible = true
End Function

Function InitializeRecordingsScreen()
    m.recordingsScreen = m.top.findNode("recordingsScreen")
    m.recordingsScreen.host = m.host
    'm.recordingsScreen.observeField("rowItemSelected", "OnItemSelected")
End Function

Function InitializeVideosScreen()
    m.videosScreen = m.top.findNode("videosScreen")
    m.videosScreen.host = m.host
    'm.videosScreen.observeField("rowItemSelected", "OnItemSelected")
End Function

Function InitializeMusicScreen()
End Function

Function InitializeSchedulesScreen()
End Function

Function InitializeSettingsScreen()
    m.settingsScreen = m.top.findNode("settingsScreen")
End Function

Function OnSelectedMenuChanged()
    menuName = m.top.selectedMenu

    m.currentScreen.visible = false
    if menuName = "buttonRecordings"
        m.recordingsScreen.visible = true
        m.currentScreen = m.recordingsScreen
    else if menuName = "buttonVideo"
        ? "Vid: " ; m.videosScreen
        m.videosScreen.visible = true
        m.currentScreen = m.videosScreen
    else if menuName = "buttonMusic"
        
    else if menuName = "buttonSchedule"
        
    else if menuName = "buttonSettings"
        m.settingsScreen.visible = true
        m.currentScreen = m.settingsScreen        
    end if
End Function

' Row item selected handler
Function OnItemSelected()
    HandleOptions()
End Function

' Main Remote keypress event loop
Function OnKeyEvent(key, press) as Boolean
    result = false
    if press then
        if key = "right"
            ? "Selected Menu "; m.top.selectedMenu
            HandleMenuItem(m.top.selectedMenu)
        end if
        if key = "options"

        end if
        if key = "back"
            m.buttonMenu.setFocus(true)
            m.menuItemFocused = false
            result = true
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
    m.videosScreen.setFocus(true)

    m.menuItemFocused = true
End Function

Function HandleOptions()
    m.contentOptionsDialog.message = m.currentScreen.focusedContent.title + ": " + m.currentScreen.focusedContent.subTitle
    m.contentOptionsDialog.visible = true
    m.contentOptionsDialog.setFocus(true)
End Function