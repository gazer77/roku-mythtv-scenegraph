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
                ReleasedDate: "",
                Folder: ""
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


Function TransFormJson(json as String, host as String)
	? "[Content Task] Parsing"
    result = []

    jsonContent = ParseJSON(json)

    videos = createObject("roArray", 0, true)
    
    for each video in jsonContent.VideoMetadataInfoList.VideoMetadataInfos
        parts = Split("/", video.FileName)
        if parts.Count() > 1 then
            video.Folder = parts[0]
        else
            video.Folder = "Other"
        end if
        videos.push(video)
    end for

    videos.SortBy("Folder")

    row = { title: "", videos: []}
    lastFolder = ""
    index = 0
    for each video in videos
        stream = "http://" + host + "/Content/GetVideo?Id=" + video.Id

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
            HDPosterUrl: "http://" + host + "/Content/GetVideoArtwork?Id=" + video.Id ',
            'HdBifUrl: "http://" + m.top.host + "/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(video.FileName, Len(video.FileName) - 4) + "_hd.bif",
            'SdBifUrl: "http://" + m.top.host + "/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(video.FileName, Len(video.FileName) - 4) + "_sd.bif"
        }

        'item.hdBackgroundImageUrl = mediaContentItem.getattributes().url
                
        if video.Folder <> lastFolder And lastFolder <> "" then
            row.videos.SortBy("Title")
            result.push(row)
            row = { title: video.Title, videos: []}
        end if
        row.videos.push(item)

        lastFolder = video.Folder
    end for
    row.videos.SortBy("Title")
    result.push(row)

    ? "[Content Task] Parsed"

    return result
End Function

Function ProcessFolderName(folderName as string)
    return ProperCase(Replace(folderName, "_", " "))
End Function