#Requires AutoHotkey v2.0

; ★ SHIFT_Start：F6 的核心流程。
; ★ ① 防止重复启动
; ★ ② 开启输入保护，并指定“检测到用户操作时暂停、全部释放后重新启动”
; ★ ③ 调用 Action 按下 Shift
; ★ ④ 修改运行状态
; ★ ⑤ 更新 GUI
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

; ★ SHIFT_Stop：F7、GL 切换、GL F8 都使用同一套停止流程。
SHIFT_Stop(&shiftStopHeld, shiftStopStatusText, shiftStopInputGuard) {
    Input_StopGuard(shiftStopInputGuard)
    SHIFT_ReleaseKeys(&shiftStopHeld, shiftStopInputGuard)
    SHIFT_UpdateStatus(shiftStopStatusText, "● 待机 | F6 开启")
}

; ★ 输入保护发现用户操作时的暂停流程。
; ★ 这里只负责流程：释放业务动作、更新状态；输入保护本身由公共库负责。
SHIFT_PauseForInput(&shiftPauseHeld, shiftPauseStatusText) {
    SHIFT_Up()
    shiftPauseHeld := false
    SHIFT_UpdateStatus(shiftPauseStatusText, "● 检测到用户操作，已暂停 | 松开后自动继续")
}

; ★ 启动时把 GUI HWND 写入与 MAIN.ahk 同名的 .txt 文件。
; ★ GL 管理器靠这个文件找到当前子脚本窗口。
SHIFT_WriteHwnd(shiftWriteHwndFile, shiftWriteHwndGui) {
    if FileExist(shiftWriteHwndFile)
        FileDelete shiftWriteHwndFile

    FileAppend(shiftWriteHwndGui.Hwnd, shiftWriteHwndFile)
}

; ★ GL 退出流程：
; ★ 0xB001 → SHIFT_Exit → SHIFT_Stop → 删除 HWND 文件 → ExitApp。
; ★ GL 正是通过等待这个文件消失来确认“子脚本已经完成退出”。
SHIFT_Exit(shiftExitReason, shiftExitHwndFile, &shiftExitHeld, shiftExitInputGuard, shiftExitStatusText) {
    SHIFT_Stop(&shiftExitHeld, shiftExitStatusText, shiftExitInputGuard)

    if shiftExitReason = GLMessage.ExitReasonManager
        GL_LogError("GL F8 子脚本退出", "SHIFT 收到管理器退出通知")

    if FileExist(shiftExitHwndFile)
        FileDelete shiftExitHwndFile

    Sleep 100
    ExitApp
}
