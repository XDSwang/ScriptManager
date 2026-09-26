#Requires AutoHotkey v2.0

WQFFF_Start(&wqfffStartRunning, wqfffStartFInterval, wqfffStartPressTimer, wqfffStartStatusText, wqfffStartInputGuard) {
    if wqfffStartRunning
        return

    Input_StartGuard(
        wqfffStartInputGuard,
        (*) => WQFFF_PauseForInput(&wqfffStartRunning, wqfffStartPressTimer, wqfffStartStatusText),
        (*) => WQFFF_Start(&wqfffStartRunning, wqfffStartFInterval, wqfffStartPressTimer, wqfffStartStatusText, wqfffStartInputGuard)
    )

    wqfffStartRunning := true
    WQFFF_Down()
    SetTimer(wqfffStartPressTimer, wqfffStartFInterval)
    WQFFF_UpdateStatus(wqfffStartStatusText, "运行-WQ按住中F循环中/释放-按F7暂停")
}

WQFFF_Stop(&wqfffStopRunning, wqfffStopPressTimer, wqfffStopStatusText, wqfffStopInputGuard) {
    Input_StopGuard(wqfffStopInputGuard)
    WQFFF_ReleaseKeys(&wqfffStopRunning, wqfffStopPressTimer, wqfffStopInputGuard)
    Input_WaitPhysicalRelease()
    WQFFF_UpdateStatus(wqfffStopStatusText, "● 待机 | F6 开启")
}

WQFFF_PauseForInput(&wqfffPauseRunning, &wqfffPausePressTimer, wqfffPauseStatusText) {
    wqfffPauseRunning := false
    SetTimer(wqfffPausePressTimer, 0)
    WQFFF_Up()
    WQFFF_UpdateStatus(wqfffPauseStatusText, "● 检测到用户操作，已暂停 | 松开后自动继续")
}

WQFFF_PressFTimer(&wqfffTimerRunning) {
    if !wqfffTimerRunning
        return

    WQFFF_PressF()
}

WQFFF_WriteHwnd(wqfffWriteHwndFile, wqfffWriteHwndGui) {
    if FileExist(wqfffWriteHwndFile)
        FileDelete wqfffWriteHwndFile

    FileAppend(wqfffWriteHwndGui.Hwnd, wqfffWriteHwndFile)
}

WQFFF_Exit(wqfffExitHwndFile, &wqfffExitRunning, wqfffExitPressTimer, wqfffExitInputGuard, wqfffExitStatusText) {
    WQFFF_Stop(&wqfffExitRunning, wqfffExitPressTimer, wqfffExitStatusText, wqfffExitInputGuard)

    if FileExist(wqfffExitHwndFile)
        FileDelete wqfffExitHwndFile

    Sleep 100
    ExitApp
}
