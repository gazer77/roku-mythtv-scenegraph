' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
    m.isInitialized = false

    m.top.observeField("visible", "onVisibleChange")
End Function

Function onVisibleChange()
    if m.top.visible and m.isInitialized = false then
        m.isInitialized = true
    end if
End Function