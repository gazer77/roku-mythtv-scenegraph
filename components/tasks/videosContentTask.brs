Function Init()
	m.top.functionName = "getContent"
End Function

Function getContent()
    apiUrl = "http://" + m.top.host + "/Video/GetVideoList"
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

    videos = createObject("roArray", 0, true)
    
    for each video in jsonContent.VideoMetadataInfos
        videos.push(video)
    end for

    videos.SortBy("Title")

    row = { title: "", videos: []}
    lastTitle = ""
    index = 0
    for each video in videos
        stream = "http://" + m.top.host + "/Content/GetVideo?Id=" + video.Id

        item = {
            title: video.title,
            subTitle: video.SubTitle,
            releaseDate: video.ReleaseDate,
            length: video.Length,
            stream: {
                url : stream
            },
            url: stream,
            streamFormat: "mp4",
            description: video.Description,
            HDPosterUrl: "http://" + m.top.host + "/Content/GetVideoArtwork?Id=" + video.Id ',
            'HdBifUrl: "http://" + m.top.host + "/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(video.FileName, Len(video.FileName) - 4) + "_hd.bif",
            'SdBifUrl: "http://" + m.top.host + "/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(video.FileName, Len(video.FileName) - 4) + "_sd.bif"
        }

        'item.hdBackgroundImageUrl = mediaContentItem.getattributes().url
                
        if video.Title <> lastTitle And lastTitle <> "" then
            'row.videos.SortBy("recordedDate", "r")
            result.push(row)
            row = { title: video.Title, videos: []}
        end if
        row.videos.push(item)

        lastTitle = video.Title
    end for
    'row.videos.SortBy("recordedDate", "r")
    result.push(row)

    ? "[Content Task] Parsed"

    return result
End Function