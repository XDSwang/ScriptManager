#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

; GL 管理器

#Include ../Lib/Common/GUI.ahk
#Include ../Lib/Common/Message.ahk

scriptFolder := A_ScriptDir "\..\Business"
scripts := []
current := 0

LoadScripts()
ShowGL()

^Up::SwitchScript(1)
^Down::SwitchScript(-1)

LoadScripts(){
    global scripts, scriptFolder
    Loop Files scriptFolder "\*.ahk", "R"
        scripts.Push(A_LoopFileFullPath)
}

SwitchScript(step){
    global scripts,current
    if scripts.Length=0
        return
    current += step
    if current<1
        current:=scripts.Length
    if current>scripts.Length
        current:=1
    Run scripts[current]
}

ShowGL(){
    global
    gui := Gui("+AlwaysOnTop", "GL管理器")
    gui.BackColor := "000000"
    gui.SetFont("s9 cFFFFFF", "Microsoft YaHei")
    gui.AddText(,"GL 管理器 | Ctrl+Up/Down 切换")
    gui.Show("w300 h35")
    WinSetTransparent(220, gui)
}
