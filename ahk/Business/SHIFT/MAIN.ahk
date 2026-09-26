#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include ../../Lib/Input/InputControl.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

SHIFT_Main() {
    shiftMainGuiState := GLGui.Create("Shift 控制", 300, 35, 0, 0)
    shiftMainGui := shiftMainGuiState.gui
    shiftMainStatusText := shiftMainGui.AddText("x10 y7 w280 h20 Center", "● 待机 | F6 开启")
    shiftMainHeld := false
    shiftMainHwndFile := A_ScriptDir "\" A_ScriptName ".txt"
    shiftMainInputGuard := Input_CreateGuard()

    SHIFT_WriteHwnd(shiftMainHwndFile, shiftMainGui)

    Hotkey("*F6", (*) => SHIFT_Start(&shiftMainHeld, shiftMainStatusText, shiftMainInputGuard))
    Hotkey("*F7", (*) => SHIFT_Stop(&shiftMainHeld, shiftMainStatusText, shiftMainInputGuard))
    OnMessage(0xB001, (*) => SHIFT_Exit(shiftMainHwndFile, &shiftMainHeld, shiftMainInputGuard))
    OnExit((*) => SHIFT_ReleaseKeys(&shiftMainHeld, shiftMainInputGuard))
}

SHIFT_Main()
