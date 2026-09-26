#Requires AutoHotkey v2.0

GL_LoadScripts() {
    global scripts, scriptFolder
    scripts := []

    Loop Files scriptFolder "\*\MAIN.ahk"
        scripts.Push(A_LoopFileFullPath)

    GL_SortScripts()
}

GL_SortScripts() {
    global scripts

    Loop scripts.Length {
        Loop scripts.Length - 1 {
            if (scripts[A_Index] > scripts[A_Index + 1]) {
                temp := scripts[A_Index]
                scripts[A_Index] := scripts[A_Index + 1]
                scripts[A_Index + 1] := temp
            }
        }
    }
}
