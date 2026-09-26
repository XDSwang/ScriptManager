#Requires AutoHotkey v2.0

WQFFF_Start(&wqfffStartRunning, wqfffStartFInterval, wqfffStartPressTimer, wqfffStartStatusText) {
    wqfffStartRunning := true
    WQFFF_Down()
    SetTimer(wqfffStartPressTimer, wqfffStartFInterval)
    WQFFF_UpdateStatus(wqfffStartStatusText, "运行-WQ按住中F循环中/释放-按F7暂停")
}

WQFFF_Stop(&wqfffStopRunning, wqfffStopPressTimer, wqfffStopStatusText) {
    wqfffStopRunning := false
    SetTimer(wqfffStopPressTimer, 0)
    WQFFF_Up()
    WQFFF_UpdateStatus(wqfffStopStatusText, "● 待机 | F6 开启")
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

WQFFF_Exit(wqfffExitHwndFile, &wqfffExitRunning, wqfffExitPressTimer) {
    WQFFF_ReleaseKeys(&wqfffExitRunning, wqfffExitPressTimer)

    if FileExist(wqfffExitHwndFile)
        FileDelete wqfffExitHwndFile

    Sleep 100
    ExitApp
}
