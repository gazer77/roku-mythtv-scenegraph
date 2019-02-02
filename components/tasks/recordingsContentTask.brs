Function Init()
	m.top.functionName = "getContent"
End Function

Function getContent()
    apiUrl = "http://" + m.top.host + "/Dvr/GetRecordedList"
    json = GetApiData(apiUrl)
    transformedContent = TransFormJson(json)
	m.top.content = ObjectToContentNode(transformedContent)    
End Function

Function ObjectToContentNode(rows As Object)
    ? "[Content Task] Building Content"
    RowItems = createObject("RoSGNode","ContentNode")

    for each rowAA in rows
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.title

        index = 0
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

            index = index + 1
            if index > 5 then
                exit for
            end if
        end for
        RowItems.appendChild(row)
    end for

    ? "[Content Task] Content Built"

    return RowItems
End Function


Function TransFormJson(jsonContent)
	? "[Content Task] Parsing"
    result = []

    programs = createObject("roArray", 0, true)
    
    for each program in jsonContent.ProgramList.Programs
        programs.push(program)
    end for

    programs.SortBy("Title")

    row = { title: "", videos: []}
    lastTitle = ""
    index = 0
    for each program in programs
        stream = "http://" + m.top.host + "/Content/GetRecording?RecordedId=" + program.Recording.RecordedId

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
            HDPosterUrl: "http://" + m.top.host + "/Content/GetPreviewImage?RecordedId=" + program.Recording.RecordedId,
            HdBifUrl: "http://" + m.top.host + "/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(program.FileName, Len(program.FileName) - 4) + "_hd.bif",
            SdBifUrl: "http://" + m.top.host + "/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(program.FileName, Len(program.FileName) - 4) + "_sd.bif" '1621_20180410020000_hd.bif
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

    ? "[Content Task] Parsed"

    return result
End Function