#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include ../../Lib/Common/Release.ahk
#Include ../../Lib/Action/Keyboard.ahk
#Include ../../Lib/Action/Timer.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

myGui := GLGui.Create("W Q F 控制")
status := myGui.AddText("w280 h25", "● 待机 | F6 开启")

running := false
fInterval := 100

glFile := A_ScriptDir "\" A_ScriptName ".txt"
WQFFF_WriteHwnd()

OnMessage(0xB001, GL_Exit)
OnExit(ReleaseWQ)

*F6::
{
    global status, running
    if running
        return
    WQFFF_Start()
    status.Text := "● 运行中 | W+Q 按住 | F 连按"
}

*F7::
{
    global status
    WQFFF_Stop()
    status.Text := "● 待机 | F6 开启"
}

GL_Exit(*)
{
    WQFFF_Stop()
    Sleep 100
    ExitApp
}
