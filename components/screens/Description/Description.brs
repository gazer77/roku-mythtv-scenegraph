' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 
 'setting top interfaces
Sub Init()
    m.top.Title = m.top.findNode("Title")
    m.top.SubTitle = m.top.findNode("SubTitle")
    m.top.Description = m.top.findNode("Description")
    m.top.RecordedDate = m.top.findNode("RecordedDate")
    m.top.AirDate = m.top.findNode("AirDate")
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
    
    recordedDate = item.recordeddate
    if recordedDate <> invalid then
        if recordedDate <> ""

            m.top.RecordedDate.text = FormatDate(recordedDate.toStr())
        else
            m.top.RecordedDate.text = "No release date"
        end if
    end if

    airDate = item.airdate
    if airDate <> invalid then
        if airDate <> ""
            m.top.AirDate.text = airDate.toStr()
        else
            m.top.AirDate.text = "No air date"
        end if
    end if
End Sub

Function FormatDate(value)
    date = CreateObject("roDateTime")
    date.FromISO8601String(value)
    date.ToLocalTime()

    year = date.GetYear()
    month = date.GetMonth()
    day = date.GetDayOfMonth()

    hour = date.GetHours()
    minutes = date.GetMinutes()

    hourString = FormateIntger(hour)

    minuteString = FormateIntger(minutes)

    return FormateIntger(year) + "-" + FormateIntger(month) + "-" + FormateIntger(day) + " " + hourString + ":" + minuteString
End Function

Function FormateIntger(value)
    stringValue = StrI(value)
    stringValue = Right(stringValue, Len(stringValue) - 1)
    if value < 10 then
        stringValue = "0" + stringValue
    end if

    return stringValue
End Function