Function Init()
    m.focusedIndex = 0
    m.buttonCount = m.top.getChildCount()

    FocusMenuItem()
End Function

Function OnKeyEvent(key, press) as Boolean
    children = m.top.getChildCount()

    result = false
    if press then
        if key = "down"
            result = HandleDown()
        else if key = "up"
            result = HandleUp()
        end if
    end if

    return result
End Function

Function HandleUp()
    if(m.focusedIndex > 0) then
        m.focusedIndex--
    else
        m.focusedIndex = m.buttonCount
    end if

    FocusMenuItem()

    return true
End Function

Function HandleDown()
    if(m.focusedIndex < m.buttonCount - 1) then
        m.focusedIndex++
    else
        m.focusedIndex = 0
    end if

    FocusMenuItem()

    return true
End Function

Function OnFocused()
    FocusMenuItem()
End Function

Function FocusMenuItem()
    menuItem = m.top.getChild(m.focusedIndex)

    if menuItem <> invalid then
        menuItem.setFocus(true)

        m.top.selectedMenu = menuItem.id
    end if
End Function