' ********** Copyright 2015 Roku Corp.  All Rights Reserved. ********** 

Sub RunUserInterface()
    homeScreen = CreateObject("roSGScreen")
    homeScene = homeScreen.CreateScene("HomeScene")
    messagePort = CreateObject("roMessagePort")
    homeScreen.SetMessagePort(messagePort)
    homeScreen.Show()

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