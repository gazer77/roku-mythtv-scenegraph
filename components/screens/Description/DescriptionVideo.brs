' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 'setting top interfaces
Sub Init()
    m.top.Title = m.top.findNode("Title")
    m.top.SubTitle = m.top.findNode("SubTitle")
    m.top.Description = m.top.findNode("Description")
    m.top.releaseDate = m.top.findNode("ReleaseDate")
End Sub

' Content change handler
' All fields population
Sub OnContentChanged()
    item = m.top.content

    title = item.title.toStr()
    if title <> invalid then
        m.top.Title.text = title.toStr()
    end if

    subTitle = item.subtitle.toStr()
    if subTitle <> invalid then
        m.top.SubTitle.text = subTitle.toStr()
    end if
    
    description = item.description
    if description <> invalid then
        if description.toStr() <> "" then
            m.top.Description.text = description.toStr()
        else
            m.top.Description.text = "No description"
        end if
    end if
    
    releaseDate = item.releaseDate
    if releaseDate <> invalid then
        if releaseDate <> ""

            m.top.releaseDate.text = FormatDate(releaseDate.toStr())
        else
            m.top.releaseDate.text = "No release date"
        end if
    end if
End Sub