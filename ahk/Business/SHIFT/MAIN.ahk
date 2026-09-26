#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

SHIFT_Main() {
    shiftMainGui := GLGui.Create("Shift 控制", 300, 35, 0, 0)
    shiftMainStatusText := shiftMainGui.AddText("x10 y7 w280 h20 Center", "● 待机 | F6 开启")
    shiftMainHeld := false
    shiftMainHwndFile := A_ScriptDir "\" A_ScriptName ".txt"

    SHIFT_WriteHwnd(shiftMainHwndFile, shiftMainGui)

    Hotkey("*F6", (*) => SHIFT_Start(&shiftMainHeld, shiftMainStatusText))
    Hotkey("*F7", (*) => SHIFT_Stop(&shiftMainHeld, shiftMainStatusText))
    OnMessage(0xB001, (*) => SHIFT_Exit(shiftMainHwndFile, &shiftMainHeld))
    OnExit((*) => SHIFT_ReleaseKeys(&shiftMainHeld))
}

SHIFT_Main()
