' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 ' inits details screen
 ' sets all observers 
 ' configures buttons for Details screen
Function Init()
    ? "[DetailsScreen] init"

    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")

    m.buttons           =   m.top.findNode("Buttons")
    m.poster            =   m.top.findNode("Poster")
    m.description       =   m.top.findNode("Description")
    m.background        =   m.top.findNode("Background")


    ' create buttons
    result = []
    for each button in ["Play", "Delete"]
        result.push({title : button})
    end for
    m.buttons.content = ContentList2SimpleNode(result)
End Function

' set proper focus to buttons if Details opened and stops Video if Details closed
Sub onVisibleChange()
    ? "[DetailsScreen] onVisibleChange"
    if m.top.visible = true then
        m.buttons.jumpToItem = 0
        m.buttons.setFocus(true)
    else
        'm.videoPlayer.visible = false
        'm.videoPlayer.control = "stop"
        m.poster.uri=""
        m.background.uri=""
    end if
End Sub

' set proper focus to Buttons in case if return from Video PLayer
Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.buttons.hasFocus() then
        m.buttons.setFocus(true)
    end if
End Sub

' Content change handler
Sub OnContentChange()
    m.description.content   = m.top.content
    m.description.Description.width = "770"
    'm.top.streamUrl         = m.top.content.url
    'm.top.HdBifUrl          = m.top.content.HdBifUrl
    m.poster.uri            = m.top.content.hdBackgroundImageUrl
    m.background.uri        = m.top.content.hdBackgroundImageUrl
End Sub

'///////////////////////////////////////////'
' Helper function convert AA to Node
Function ContentList2SimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
    result = createObject("roSGNode",nodeType)
    if result <> invalid
        for each itemAA in contentList
            item = createObject("roSGNode", nodeType)
            item.setFields(itemAA)
            result.appendChild(item)
        end for
    end if
    return result
End Function

Function onItemSelected(event)
    ? "Item Selected "; m.buttons.itemSelected
    
    if m.buttons.itemSelected = 0
        ? "Play"
    else if m.buttons.itemSelected = 1
        ? "Delete"
    else
        ? "Unkown!"
    end if
End Function