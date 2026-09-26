#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../Lib/Common/GUI.ahk
#Include ../Lib/Common/Message.ahk

scriptFolder := A_ScriptDir "\..\Business"
scripts := []
current := 0
glGui := 0

LoadScripts()
SortScripts()
ShowGL()

^Up::SwitchScript(1)
^Down::SwitchScript(-1)

LoadScripts(){
    global scripts, scriptFolder
    scripts := []

    Loop Files scriptFolder "\*\MAIN.ahk"
        scripts.Push(A_LoopFileFullPath)
}

SortScripts(){
    global scripts

    Loop scripts.Length
        Loop scripts.Length - 1
            if (scripts[A_Index] > scripts[A_Index + 1]){
                temp := scripts[A_Index]
                scripts[A_Index] := scripts[A_Index + 1]
                scripts[A_Index + 1] := temp
            }
}

SwitchScript(step){
    global scripts, current

    if scripts.Length = 0
        return

    if current > 0
        StopCurrent()

    current += step
    if current < 1
        current := scripts.Length
    if current > scripts.Length
        current := 1

    Run scripts[current]
    RefreshGL()
}

StopCurrent(){
    global scripts, current

    SplitPath scripts[current], &fileName, &dir
    hwndFile := dir "\" fileName ".txt"

    if FileExist(hwndFile){
        hwnd := Trim(FileRead(hwndFile))
        if hwnd
            SendMessage 0xB001, 0, 0,, "ahk_id " hwnd
        FileDelete hwndFile
    }

    SendEvent "{F7}"
    Sleep 300
}

ShowGL(){
    global glGui

    glGui := GLGui.Create("GL管理器", 300, 35)
    RefreshGL()
}

RefreshGL(){
    global scripts, current, glGui

    if !glGui
        return

    GLGui.UpdateList(glGui, scripts, current)
}
