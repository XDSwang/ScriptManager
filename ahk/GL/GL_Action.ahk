#Requires AutoHotkey v2.0

GL_SwitchScript(step) {
    global scripts, current

    if scripts.Length = 0
        return

    if current > 0
        GL_StopCurrent()

    current += step
    if current < 1
        current := scripts.Length
    if current > scripts.Length
        current := 1

    Run scripts[current]
    Sleep 100
    GL_Refresh()
}

GL_StopCurrent() {
    global scripts, current

    SplitPath scripts[current], &fileName, &dir
    hwndFile := dir "\" fileName ".txt"

    SendEvent "{F7}"
    Sleep 100

    if FileExist(hwndFile) {
        hwnd := Trim(FileRead(hwndFile))
        if hwnd
            SendExitMessage(hwnd)
        FileDelete hwndFile
    }

    Sleep 300
}

GL_Show() {
    global glGui
    glGui := GLGui.Create("GL管理器", 300, 35)
    GL_Refresh()
}

GL_Refresh() {
    global scripts, current, glGui

    if !glGui
        return

    GLGui.UpdateList(glGui, scripts, current)
}
