#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include ../../Lib/Common/Log.ahk
#Include ../../Lib/Input/InputControl.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

SHIFT_Main() {
    shiftMainGuiState := GLGui.Create("Shift 控制", 300, 35, 0, 0)
    shiftMainGui := shiftMainGuiState.gui
    shiftMainStatusText := shiftMainGui.AddText("x10 y7 w280 h20 Center", "● 待机 | F6 开启")
    shiftMainHeld := false
    shiftMainHwndFile := A_ScriptDir "\" A_ScriptName ".txt"

    ; 控制键可按需修改；启动/暂停/退出等控制热键都应加入此数组，否则输入保护可能把控制键本身当成用户干扰。
    ; 提醒：控制键会被输入保护忽略，因此不要把同时承担游戏技能/业务输入的按键作为控制键。
    shiftMainControlKeys := ["F6", "F7"]
    shiftMainInputGuard := Input_CreateGuard(shiftMainControlKeys)

    SHIFT_WriteHwnd(shiftMainHwndFile, shiftMainGui)

    Hotkey("*F6", (*) => SHIFT_Start(&shiftMainHeld, shiftMainStatusText, shiftMainInputGuard))
    Hotkey("*F7", (*) => SHIFT_Stop(&shiftMainHeld, shiftMainStatusText, shiftMainInputGuard))
    OnMessage(0xB001, (wParam, lParam, msg, hwnd) => SHIFT_Exit(wParam, shiftMainHwndFile, &shiftMainHeld, shiftMainInputGuard, shiftMainStatusText))
    OnExit((*) => SHIFT_ReleaseKeys(&shiftMainHeld, shiftMainInputGuard))
}

SHIFT_Main()
