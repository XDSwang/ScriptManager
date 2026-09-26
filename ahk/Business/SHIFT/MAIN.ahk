#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include ../../Lib/Common/Release.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

myGui := GLGui.Create("Shift 控制")
text := myGui.AddText("w280 Center", "● 待机 | F6 开启")

running := false

glFile := A_ScriptDir "\" A_ScriptName ".txt"
SHIFT_WriteHwnd()

*F6::
{
    global text
    SHIFT_Start()
    text.Text := "● 运行中 | Shift 按住"
}

*F7::
{
    global text
    SHIFT_Stop()
    text.Text := "● 待机 | F6 开启"
}

OnMessage(0xB001, GL_Exit)
OnExit(ReleaseShift)

GL_Exit(*)
{
    ReleaseShift()
    Sleep(100)
    ExitApp
}
