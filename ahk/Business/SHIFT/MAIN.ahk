#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Release.ahk

myGui := GLGui.Create("Shift 控制")
text := myGui.AddText("w280 Center", "● 待机 | F6 开启")

running := false

glFile := A_ScriptDir "\\" A_ScriptName ".txt"
if FileExist(glFile)
    FileDelete(glFile)
FileAppend(myGui.Hwnd, glFile)

*F6::
{
    running := true
    Send("{Shift down}")
    text.Text := "● 运行中 | Shift 按住"
}

*F7::
{
    ReleaseKeys()
    text.Text := "● 待机 | F6 开启"
}

OnMessage(0xB001, GL_Exit)
OnExit(ReleaseKeys)

GL_Exit(*)
{
    ReleaseKeys()
    Sleep(100)
    ExitApp
}

ReleaseKeys(*)
{
    Send("{Shift up}")
    running := false
}
