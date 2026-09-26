#Requires AutoHotkey v2.0

SHIFT_Start(&shiftStartHeld, shiftStartStatusText) {
    SHIFT_Down()
    shiftStartHeld := true
    SHIFT_UpdateStatus(shiftStartStatusText, "运行-Shift按住中/释放-按F7暂停")
}

SHIFT_Stop(&shiftStopHeld, shiftStopStatusText) {
    SHIFT_Up()
    shiftStopHeld := false
    SHIFT_UpdateStatus(shiftStopStatusText, "● 待机 | F6 开启")
}

SHIFT_WriteHwnd(shiftWriteHwndFile, shiftWriteHwndGui) {
    if FileExist(shiftWriteHwndFile)
        FileDelete shiftWriteHwndFile

    FileAppend(shiftWriteHwndGui.Hwnd, shiftWriteHwndFile)
}

SHIFT_Exit(shiftExitHwndFile, &shiftExitHeld) {
    SHIFT_ReleaseKeys(&shiftExitHeld)

    if FileExist(shiftExitHwndFile)
        FileDelete shiftExitHwndFile

    Sleep 100
    ExitApp
}
