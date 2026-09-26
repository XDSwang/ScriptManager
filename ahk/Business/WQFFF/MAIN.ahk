#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Release.ahk

myGui := GLGui.Create("W Q F 控制")
status := myGui.AddText("w280 h25", "● 待机 | F6 开启")

running := false
fInterval := 100

glFile := A_ScriptDir "\" A_ScriptName ".txt"
if FileExist(glFile)
    FileDelete(glFile)
FileAppend(myGui.Hwnd, glFile)

OnMessage(0xB001, GL_Exit)
OnExit(ReleaseKeys)

*F6::
{
    global running
    if running
        return
    running := true
    Send "{w down}{q down}"
    SetTimer(PressF, fInterval)
    status.Text := "● 运行中 | W+Q 按住 | F 连按"
}

*F7::
{
    ReleaseKeys()
    status.Text := "● 待机 | F6 开启"
}

PressF()
{
    global running
    if !running
        return
    Send "f"
}

ReleaseKeys(*)
{
    global running
    running := false
    SetTimer(PressF, 0)
    Send "{w up}{q up}"
}

GL_Exit(*)
{
    ReleaseKeys()
    Sleep 100
    ExitApp
}
