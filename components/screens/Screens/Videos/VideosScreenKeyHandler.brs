Function OnKeyEvent(key, press) as Boolean
    result = false
    if press then
        if key = "back"
            if m.videoPlayer.visible
                StopVideo()
                m.videoPlayer.visible = false
                result = true
            end if
        else if key = "play"
            if m.top.focusedContent <> invalid
                PlaySelected()
                result = true
            end if
        end if
    end if
    return result
End Function