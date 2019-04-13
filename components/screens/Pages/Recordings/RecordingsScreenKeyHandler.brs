Function OnKeyEvent(key, press) as Boolean
    result = false
    if press then
        if key = "back" then
            if m.videoPlayer.visible then
                StopVideo()
                m.videoPlayer.visible = false
                result = true
            end if
        else if key = "play" then
            if m.focusedContent <> invalid
                PlaySelected(false)
                result = true
            end if
        end if
    end if
    return result
End Function