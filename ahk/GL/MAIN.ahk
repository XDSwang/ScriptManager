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
ShowGL()

^Up::SwitchScript(1)
^Down::SwitchScript(-1)

LoadScripts(){
    global scripts, scriptFolder
    scripts := []
    Loop Files scriptFolder "\*.ahk", "R"
        scripts.Push(A_LoopFileFullPath)
}

SwitchScript(step){
    global scripts,current
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
    global scripts,current
    SplitPath scripts[current], &dir, &name
    hwndFile := dir "\" name ".txt"
    if FileExist(hwndFile){
        hwnd := FileRead(hwndFile)
        if hwnd
            SendMessage 0xB001,0,0,,"ahk_id " hwnd
        FileDelete hwndFile
    }
    SendEvent "{F7}"
    Sleep 300
}

ShowGL(){
    global glGui
    glGui := Gui("+AlwaysOnTop", "GL管理器")
    glGui.BackColor := "000000"
    glGui.SetFont("s9 cFFFFFF", "Microsoft YaHei")
    glGui.AddText("vList", "")
    glGui.Show("w300 h35")
    WinSetTransparent(220, glGui)
    RefreshGL()
}

RefreshGL(){
    global scripts,current,glGui
    if !glGui
        return
    text := ""
    Loop scripts.Length
    {
        SplitPath scripts[A_Index],,,&name
        if A_Index=current
            text .= "当前:" name " "
        else
            text .= name " "
    }
    glGui["List"].Text := text
}
