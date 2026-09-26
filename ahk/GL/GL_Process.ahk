#Requires AutoHotkey v2.0

GL_LoadScripts(glLoadScriptsFolder) {
    glLoadScriptsList := []

    if !DirExist(glLoadScriptsFolder)
        return glLoadScriptsList

    Loop Files glLoadScriptsFolder "\*", "D" {
        glLoadScriptsMainFile := A_LoopFileFullPath "\MAIN.ahk"

        if FileExist(glLoadScriptsMainFile) {
            glLoadScriptsScriptName := A_LoopFileName
            glLoadScriptsList.Push({
                name: glLoadScriptsScriptName,
                path: glLoadScriptsMainFile
            })
        }
    }

    return GL_SortScripts(glLoadScriptsList)
}

GL_SortScripts(glSortScriptsList) {
    Loop glSortScriptsList.Length {
        Loop glSortScriptsList.Length - 1 {
            if (glSortScriptsList[A_Index].name > glSortScriptsList[A_Index + 1].name) {
                glSortScriptsTemp := glSortScriptsList[A_Index]
                glSortScriptsList[A_Index] := glSortScriptsList[A_Index + 1]
                glSortScriptsList[A_Index + 1] := glSortScriptsTemp
            }
        }
    }

    return glSortScriptsList
}
