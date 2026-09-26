#Requires AutoHotkey v2.0

GL_LoadScripts(glLoadScriptsFolder) {
    glLoadScriptsList := []

    Loop Files glLoadScriptsFolder "\*\MAIN.ahk"
        glLoadScriptsList.Push(A_LoopFileFullPath)

    return GL_SortScripts(glLoadScriptsList)
}

GL_SortScripts(glSortScriptsList) {
    Loop glSortScriptsList.Length {
        Loop glSortScriptsList.Length - 1 {
            if (glSortScriptsList[A_Index] > glSortScriptsList[A_Index + 1]) {
                glSortScriptsTemp := glSortScriptsList[A_Index]
                glSortScriptsList[A_Index] := glSortScriptsList[A_Index + 1]
                glSortScriptsList[A_Index + 1] := glSortScriptsTemp
            }
        }
    }

    return glSortScriptsList
}
