#Requires AutoHotkey v2.0

; ★ WQFFF_Start：F6 的完整业务流程。
; ★ ① 防止重复启动
; ★ ② 启动输入保护
; ★ ③ 标记 running
; ★ ④ 按住 W/Q
; ★ ⑤ 启动 F 定时器
; ★ ⑥ 更新 GUI
WQFFF_Start(&wqfffStartRunning, &wqfffStartFInterval, &wqfffStartPressTimer, wqfffStartStatusText, wqfffStartInputGuard) {
    if wqfffStartRunning
        return

    Input_InputControl_StartGuard(
        wqfffStartInputGuard,
        (*) => WQFFF_PauseForInput(&wqfffStartRunning, wqfffStartPressTimer, wqfffStartStatusText),
        (*) => WQFFF_Start(&wqfffStartRunning, wqfffStartFInterval, wqfffStartPressTimer, wqfffStartStatusText, wqfffStartInputGuard)
    )

    wqfffStartRunning := true
    WQFFF_Down()
    SetTimer(wqfffStartPressTimer, wqfffStartFInterval)
    WQFFF_UpdateStatus(wqfffStartStatusText, "运行-WQ按住中F循环中/释放-按F7暂停")
}

; ★ WQFFF_Stop：F7、GL 切换、GL F8 共用的停止流程。
WQFFF_Stop(&wqfffStopRunning, wqfffStopPressTimer, wqfffStopStatusText, wqfffStopInputGuard) {
    Input_InputControl_StopGuard(wqfffStopInputGuard)
    WQFFF_ReleaseKeys(&wqfffStopRunning, wqfffStopPressTimer, wqfffStopInputGuard)
    WQFFF_UpdateStatus(wqfffStopStatusText, "● 待机 | F6 开启")
}

; ★ 输入保护发现用户操作后的暂停流程：
; ★ 停止 F Timer → 释放 W/Q/F → 更新状态 → 等待干扰按键全部释放后自动重新 WQFFF_Start。
WQFFF_PauseForInput(&wqfffPauseRunning, wqfffPausePressTimer, wqfffPauseStatusText) {
    wqfffPauseRunning := false
    SetTimer(wqfffPausePressTimer, 0)
    WQFFF_Up()
    WQFFF_UpdateStatus(wqfffPauseStatusText, "● 检测到用户操作，已暂停 | 松开后自动继续")
}

; ★ Timer 到时进入这里，再调用 Action 中真正的 F 按键动作。
WQFFF_PressFTimer(&wqfffTimerRunning) {
    if !wqfffTimerRunning
        return

    WQFFF_PressF()
}

; ★ 启动时写入 HWND，供 GL 管理器定位当前子脚本。
WQFFF_WriteHwnd(wqfffWriteHwndFile, wqfffWriteHwndGui) {
    if FileExist(wqfffWriteHwndFile)
        FileDelete wqfffWriteHwndFile

    FileAppend(wqfffWriteHwndGui.Hwnd, wqfffWriteHwndFile)
}

; ★ GL 退出流程：
; ★ 0xB001 → WQFFF_Exit → WQFFF_Stop → 删除 HWND 文件 → ExitApp。
WQFFF_Exit(wqfffExitReason, wqfffExitHwndFile, &wqfffExitRunning, wqfffExitPressTimer, wqfffExitInputGuard, wqfffExitStatusText) {
    WQFFF_Stop(&wqfffExitRunning, wqfffExitPressTimer, wqfffExitStatusText, wqfffExitInputGuard)

    if wqfffExitReason = Common_Message_Exit.ExitReasonManager
        Common_Log_Error("GL F8 子脚本退出", "WQFFF 收到管理器退出通知")

    if FileExist(wqfffExitHwndFile)
        FileDelete wqfffExitHwndFile

    Sleep 100
    ExitApp
}
