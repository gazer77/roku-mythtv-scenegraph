' ********** Copyright 2015 Roku Corp.  All Rights Reserved. ********** 

Sub RunUserInterface()
    screen = CreateObject("roSGScreen")
    scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.Show()
    
    rows = GetApiArray("172.16.254.20")

    scene.gridContent = ParseXMLContent(rows)

    while true
        msg = wait(0, port)
        print "------------------"
        print "msg = "; msg
    end while
    
    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
End Sub


Function ParseXMLContent(rows As Object)
    print("Parsing")
    RowItems = createObject("RoSGNode","ContentNode")
    index = 0
    for each rowAA in rows
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.title

        for each video in rowAA.videos
            item = createObject("RoSGNode","ContentNode")

            'create fields that ContentNode doesn't have
            item.addFields({
                SubTitle: "",
                RecordedDate: "",
                AirDate: ""
            })
            
            ' We don't use item.setFields(video) as doesn't cast streamFormat to proper value
            for each key in video
                item[key] = video[key]
            end for
            row.appendChild(item)
        end for
        RowItems.appendChild(row)
    end for

    print("Parsed")

    return RowItems
End Function


Function GetApiArray(host)
    url = CreateObject("roUrlTransfer")
    url.SetUrl("http://" + host + ":6544/Dvr/GetRecordedList")
    url.AddHeader("accept", "application/json")
    rsp = url.GetToString()

    jsonObject = ParseJSON(rsp)

    result = []

    programs = createObject("roArray", 0, true)
    
    for each program in jsonObject.ProgramList.Programs
        programs.push(program)
    end for

    programs.SortBy("Title")

    row = { title: "", videos: []}
    lastTitle = ""
    index = 0
    for each program in programs
        stream = "http://" + host + ":6544/Content/GetRecording?RecordedId=" + program.Recording.RecordedId

        item = {
            title: program.title,
            subTitle: program.SubTitle,
            airDate: program.Airdate,
            recordedDate: program.Recording.StartTs,
            stream: {
                url : stream
            },
            url: stream,
            streamFormat: "mp4",
            description: program.Description,
            HDPosterUrl: "http://" + host + ":6544/Content/GetPreviewImage?RecordedId=" + program.Recording.RecordedId,
            HdBifUrl: "http://" + host + ":6544/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(program.FileName, Len(program.FileName) - 4) + "_hd.bif",
            SdBifUrl: "http://" + host + ":6544/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(program.FileName, Len(program.FileName) - 4) + "_sd.bif" '1621_20180410020000_hd.bif
        }

        'item.hdBackgroundImageUrl = mediaContentItem.getattributes().url
                
        if program.Title <> lastTitle And lastTitle <> "" then
            row.videos.SortBy("recordedDate", "r")
            result.push(row)
            row = { title: program.Title, videos: []}
        end if
        row.videos.push(item)

        lastTitle = program.Title
    end for
    row.videos.SortBy("recordedDate", "r")
    result.push(row)

    print("Got List")

    return result
End Function


Function ParseXML(str As String) As dynamic
    if str = invalid return invalid
    xml=CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function
