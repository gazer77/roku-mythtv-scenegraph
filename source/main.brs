' ********** Copyright 2015 Roku Corp.  All Rights Reserved. ********** 

Sub RunUserInterface()
    homeScreen = CreateObject("roSGScreen")
    homeScene = homeScreen.CreateScene("HomeScene")
    messagePort = CreateObject("roMessagePort")
    homeScreen.SetMessagePort(messagePort)
    homeScreen.Show()
    
    'recordings = GetApiRecordings("172.16.254.20")

    'homeScene.gridContent = ObjectToContentNode(recordings)

    while true
        msg = wait(0, messagePort)
        print "------------------"
        print "msg = "; msg
    end while
    
    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
End Sub