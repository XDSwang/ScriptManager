#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

myGui := GLGui.Create("W Q F 控制", 300, 35, 0, 0)
statusText := myGui.AddText("x10 y7 w280 h20 Center", "● 待机 | F6 开启")

running := false
fInterval := 100

glFile := A_ScriptDir "\" A_ScriptName ".txt"
WQFFF_WriteHwnd()

OnMessage(0xB001, GL_Exit)
OnExit(WQFFF_ReleaseKeys)

*F6::
{
    WQFFF_Start()
}

*F7::
{
    WQFFF_Stop()
}

WQFFF_ReleaseKeys(*)
{
    global running

    SetTimer(WQFFF_PressFTimer, 0)
    SendEvent "{w up}"
    SendEvent "{q up}"
    SendEvent "{f up}"
    running := false
}

GL_Exit(*)
{
    global glFile

    WQFFF_ReleaseKeys()

    if FileExist(glFile)
        FileDelete(glFile)

    Sleep 100
    ExitApp
}
