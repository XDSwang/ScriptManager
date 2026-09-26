#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

myGui := GLGui.Create("Shift 控制")
statusText := myGui.AddText("x10 y7 w280 h20 Center", "● 待机 | F6 开启")

shiftHeld := false

glFile := A_ScriptDir "\" A_ScriptName ".txt"
SHIFT_WriteHwnd()

*F6::
{
    SHIFT_Start()
}

*F7::
{
    SHIFT_Stop()
}

OnMessage(0xB001, GL_Exit)
OnExit(SHIFT_ReleaseKeys)

GL_Exit(*)
{
    global glFile

    SHIFT_ReleaseKeys()

    if FileExist(glFile)
        FileDelete(glFile)

    Sleep 100
    ExitApp
}
