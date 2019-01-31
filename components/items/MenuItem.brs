Function Init()
    m.top.observeField("focusedChild", "OnFocused")
End Function

Function OnFocused()
    if m.uri = invalid then
        m.uri = m.top.uri
        m.focusedUri = m.top.focusedUri
    end if

    if m.top.hasFocus() then
        m.top.uri = m.focusedUri
    else
        m.top.uri = m.uri
    end if
End Function