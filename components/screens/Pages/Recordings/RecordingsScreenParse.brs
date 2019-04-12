Function TransformJson(json as String, host as String, positions as object)
    list = createObject("RoSGNode","ContentNode")

    jsonContent = ParseJSON(json)

    programs = createObject("roArray", 0, true)
    
    for each program in jsonContent.ProgramList.Programs
        programs.push(program)
    end for

    programs.SortBy("Title")

    recentRow = CreateContentRow("Latest")
    row = createObject("roArray", 0, true)
    
    lastTitle = ""

    rowIndex = 1
    for each program in programs

        position = 0.0
        if positions[program.Recording.RecordedId] <> invalid then
            position = positions[program.Recording.RecordedId].tofloat()
            positions.delete(program.Recording.RecordedId)
        end if

        item = CreateContentNode(program, host, position)

        if(rowIndex = 1) then
            recentRow.appendChild(item)
        end if
                
        if program.Title <> lastTitle And lastTitle <> "" then
            '? "Title: " ; lastTitle ; " " ; rowIndex
            HandleNewRow(host, list, lastTitle, row, recentRow)

            row = createObject("roArray", 0, true)
            rowIndex++
        end if
        row.push(item)

        lastTitle = program.Title
    end for
    HandleNewRow(host, list, lastTitle, row, recentRow)

    list.insertChild(recentRow, 0)

    for each id in positions
        ? "Deleting Recoring Position For " ; id
        DeletePosition(id)
    end for

    return list
End Function

Function HandleNewRow(host as string, list as object, rowTitle as string, row as object, recentRow as object)
    row.SortBy("recordedDate", "r")

    contentRow = CreateContentRow(rowTitle)
    contentRow.appendChildren(row)
    list.appendChild(contentRow)

    recentItem = CreateContentNode(row[0].json, host, row[0].position)
    recentRow.appendChild(recentItem)
End Function

Function CreateContentRow(title as string)
    row = createObject("RoSGNode","ContentNode")

    row.Title = title

    return row
End Function

Function CreateContentNode(program as object, host as string, position as float)
    contentNode = createObject("RoSGNode","ContentNode")

    'create fields that ContentNode doesn't have
    'Row & Column indexes are only set on the
    'Latest row items
    contentNode.addFields({
            subTitle: program.SubTitle,
            airDate: program.Airdate,
            recordedDate: program.Recording.StartTs,
            json: program,
            position: position
    })

    contentNode.id = program.Recording.RecordedId
    contentNode.Title = program.title
    contentNode.stream = {
                url : "http://" + host + "/Content/GetRecording?RecordedId=" + program.Recording.RecordedId
            }
    contentNode.url = "http://" + host + "/Content/GetRecording?RecordedId=" + program.Recording.RecordedId
    contentNode.streamFormat = "mp4"
    contentNode.description = program.Description
    contentNode.HdPosterUrl = "http://" + host + "/Content/GetPreviewImage?RecordedId=" + program.Recording.RecordedId + "&width=262"
    contentNode.HdBifUrl = "http://" + host + "/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(program.FileName, Len(program.FileName) - 4) + "_hd.bif"
    contentNode.SdBifUrl = "http://" + host + "/Content/GetFile?StorageGroup=Recordings&FileName=" + Left(program.FileName, Len(program.FileName) - 4) + "_sd.bif" '1621_20180410020000_hd.bif

    return contentNode
End Function