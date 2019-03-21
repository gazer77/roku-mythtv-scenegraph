Function ObjectToContentNode(rows As Object)
    RowItems = createObject("RoSGNode","ContentNode")

    for each rowAA in rows
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.title

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
        end for
        RowItems.appendChild(row)
    end for

    return RowItems
End Function

Function TransFormJson(json as String, host as String)
    result = []

    jsonContent = ParseJSON(json)

    videos = [] 'createObject("roArray", 0, true)
    
    for each video in jsonContent.VideoMetadataInfoList.VideoMetadataInfos
        parts = Split("/", video.FileName)
        folder = "Other"
        if parts.Count() > 1 then
            folder = ProcessFolderName(parts[0])
        end if

        stream = "http://" + host + "/Content/GetVideo?Id=" + video.Id
        v = {
            Id: video.Id,
            Folder: folder,
            title: video.title,
            subTitle: video.SubTitle,
            releaseDate: video.ReleaseDate,
            stream: {
                url : stream
            },
            url: stream,
            length: video.Length,
            streamFormat: "mp4",
            description: video.Description,
            HDPosterUrl: "http://" + host + "/Content/GetVideoArtwork?Id=" + video.Id + "&width=147"
        }
        videos.push(v)
    end for

    videos.SortBy("Folder")

    row = { title: videos[0].Folder, videos: []}
    lastFolder = ""

    for each video in videos              
        if video.Folder <> lastFolder And lastFolder <> "" then
            row.videos.SortBy("Title")
            result.push(row)
            row = { title: video.Folder, videos: []}
        end if
        row.videos.push(video)

        lastFolder = video.Folder
    end for
    row.videos.SortBy("Title")
    result.push(row)

    return result
End Function

Function ProcessFolderName(folderName as string)
    return ProperCase(Replace(folderName, "_", " "))
End Function