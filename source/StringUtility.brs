Function Split(character as String, value as String)
    startIndex = 1
    endIndex = 0

    parts = []
    while true and len(value) > 0
        endIndex = Instr(startIndex, value, character)

        if endIndex = 0 then
            totalLength = len(value)
            length = (len(value) - startIndex) + 1
            part = Mid(value, startIndex)
            parts.push(part)
            exit while
        end if

        parts.push(Mid(value, startIndex, endIndex - startIndex))
        startIndex = endIndex + 1
    end while

    return parts
End Function

Function ProperCase(value as String) As String
    properCased = ""

    For i = 1 To Len(value) Step 1
        if i = 1 Or (i > 1 and Mid(value, i - 1, 1) = " ") then
            properCased = properCased + Ucase(Mid(value, i, 1))
        else
            properCased = properCased + Lcase(Mid(value, i, 1))
        end if
    End For

    return properCased
End Function

'Replace function by Roku as part of a utility of theirs from one of the examples
Function Replace(basestr As String, oldsub As String, newsub As String) As String
    newstr = ""

    i = 1
    while i <= Len(basestr)
        x = Instr(i, basestr, oldsub)
        if x = 0 then
            newstr = newstr + Mid(basestr, i)
            exit while
        endif

        if x > i then
            newstr = newstr + Mid(basestr, i, x-i)
            i = x
        endif

        newstr = newstr + newsub
        i = i + Len(oldsub)
    end while

    return newstr
End Function