#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

WQFFF_Main() {
    wqfffMainGuiState := GLGui.Create("W Q F 控制", 300, 35, 0, 0)
    wqfffMainGui := wqfffMainGuiState.gui
    wqfffMainStatusText := wqfffMainGui.AddText("x10 y7 w280 h20 Center", "● 待机 | F6 开启")
    wqfffMainRunning := false
    wqfffMainFInterval := 100
    wqfffMainHwndFile := A_ScriptDir "\" A_ScriptName ".txt"
    wqfffMainPressTimer := (*) => WQFFF_PressFTimer(&wqfffMainRunning)

    WQFFF_WriteHwnd(wqfffMainHwndFile, wqfffMainGui)

    Hotkey("*F6", (*) => WQFFF_Start(&wqfffMainRunning, wqfffMainFInterval, wqfffMainPressTimer, wqfffMainStatusText))
    Hotkey("*F7", (*) => WQFFF_Stop(&wqfffMainRunning, wqfffMainPressTimer, wqfffMainStatusText))
    OnMessage(0xB001, (*) => WQFFF_Exit(wqfffMainHwndFile, &wqfffMainRunning, wqfffMainPressTimer))
    OnExit((*) => WQFFF_ReleaseKeys(&wqfffMainRunning, wqfffMainPressTimer))
}

WQFFF_Main()
