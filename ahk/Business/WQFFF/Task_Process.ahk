#Requires AutoHotkey v2.0

; ★ Task_Process_Start：F6 的完整业务流程。
; ★ ① 防止重复启动
; ★ ② 启动输入保护
; ★ ③ 标记 running
; ★ ④ 按住 W/Q
; ★ ⑤ 启动 F 定时器
; ★ ⑥ 更新 GUI
Task_Process_Start(&wqfffStartRunning, &wqfffStartFInterval, &wqfffStartPressTimer, wqfffStartStatusText, wqfffStartInputGuard) {
    if wqfffStartRunning
        return

    Input_InputControl_StartGuard(
        wqfffStartInputGuard,
        (*) => Task_Process_PauseForInput(&wqfffStartRunning, wqfffStartPressTimer, wqfffStartStatusText),
        (*) => Task_Process_Start(&wqfffStartRunning, wqfffStartFInterval, wqfffStartPressTimer, wqfffStartStatusText, wqfffStartInputGuard)
    )

    wqfffStartRunning := true
    Task_Action_Down()
    SetTimer(wqfffStartPressTimer, wqfffStartFInterval)
    Task_Action_UpdateStatus(wqfffStartStatusText, "运行-WQ按住中F循环中/释放-按F7暂停")
}

; ★ Task_Process_Stop：F7、GL 切换、GL F8 共用的停止流程。
Task_Process_Stop(&wqfffStopRunning, wqfffStopPressTimer, wqfffStopStatusText, wqfffStopInputGuard) {
    Input_InputControl_StopGuard(wqfffStopInputGuard)
    Task_Action_ReleaseKeys(&wqfffStopRunning, wqfffStopPressTimer, wqfffStopInputGuard)
    Task_Action_UpdateStatus(wqfffStopStatusText, "● 待机 | F6 开启")
}

; ★ 输入保护发现用户操作后的暂停流程：
; ★ 停止 F Timer → 释放 W/Q/F → 更新状态 → 等待干扰按键全部释放后自动重新 Task_Process_Start。
Task_Process_PauseForInput(&wqfffPauseRunning, wqfffPausePressTimer, wqfffPauseStatusText) {
    wqfffPauseRunning := false
    SetTimer(wqfffPausePressTimer, 0)
    Task_Action_Up()
    Task_Action_UpdateStatus(wqfffPauseStatusText, "● 检测到用户操作，已暂停 | 松开后自动继续")
}

; ★ Timer 到时进入这里，再调用 Action 中真正的 F 按键动作。
Task_Action_PressFTimer(&wqfffTimerRunning) {
    if !wqfffTimerRunning
        return

    Task_Action_PressF()
}

; ★ 启动时写入 HWND，供 GL 管理器定位当前子脚本。
Task_Process_WriteHwnd(wqfffWriteHwndFile, wqfffWriteHwndGui) {
    if FileExist(wqfffWriteHwndFile)
        FileDelete wqfffWriteHwndFile

    FileAppend(wqfffWriteHwndGui.Hwnd, wqfffWriteHwndFile)
}

; ★ GL 退出流程：
; ★ 0xB001 → Task_Process_Exit → Task_Process_Stop → 删除 HWND 文件 → ExitApp。
Task_Process_Exit(wqfffExitReason, wqfffExitHwndFile, &wqfffExitRunning, wqfffExitPressTimer, wqfffExitInputGuard, wqfffExitStatusText) {
    Task_Process_Stop(&wqfffExitRunning, wqfffExitPressTimer, wqfffExitStatusText, wqfffExitInputGuard)

    if wqfffExitReason = Common_Message_Exit.ExitReasonManager
        Common_Log_Error("GL F8 子脚本退出", "WQFFF 收到管理器退出通知")

    if FileExist(wqfffExitHwndFile)
        FileDelete wqfffExitHwndFile

    Sleep 100
    ExitApp
}
