#Requires AutoHotkey v2.0

SHIFT_Start(&shiftStartHeld, shiftStartStatusText, shiftStartInputGuard) {
    if shiftStartHeld
        return

    Input_StartGuard(
        shiftStartInputGuard,
        (*) => SHIFT_PauseForInput(&shiftStartHeld, shiftStartStatusText),
        (*) => SHIFT_Start(&shiftStartHeld, shiftStartStatusText, shiftStartInputGuard)
    )

    SHIFT_Down()
    shiftStartHeld := true
    SHIFT_UpdateStatus(shiftStartStatusText, "运行-Shift按住中/释放-按F7暂停")
}

SHIFT_Stop(&shiftStopHeld, shiftStopStatusText, shiftStopInputGuard) {
    Input_StopGuard(shiftStopInputGuard)
    SHIFT_ReleaseKeys(&shiftStopHeld, shiftStopInputGuard)
    SHIFT_UpdateStatus(shiftStopStatusText, "● 待机 | F6 开启")
}

SHIFT_PauseForInput(&shiftPauseHeld, shiftPauseStatusText) {
    SHIFT_Up()
    shiftPauseHeld := false
    SHIFT_UpdateStatus(shiftPauseStatusText, "● 检测到用户操作，已暂停 | 松开后自动继续")
}

SHIFT_WriteHwnd(shiftWriteHwndFile, shiftWriteHwndGui) {
    if FileExist(shiftWriteHwndFile)
        FileDelete shiftWriteHwndFile

    FileAppend(shiftWriteHwndGui.Hwnd, shiftWriteHwndFile)
}

SHIFT_Exit(shiftExitReason, shiftExitHwndFile, &shiftExitHeld, shiftExitInputGuard, shiftExitStatusText) {
    SHIFT_Stop(&shiftExitHeld, shiftExitStatusText, shiftExitInputGuard)

    if shiftExitReason = GLMessage.ExitReasonManager
        GL_LogError("GL F8 子脚本退出", "SHIFT 收到管理器退出通知")

    if FileExist(shiftExitHwndFile)
        FileDelete shiftExitHwndFile

    Sleep 100
    ExitApp
}
