#Requires AutoHotkey v2.0

; ★ WQFFF_Action 只负责真正的按键和状态更新。
; ★ Process 决定什么时候执行，Action 决定具体执行什么。

Task_Action_Down() {
    SendEvent "{w down}"
    SendEvent "{q down}"
}

Task_Action_Up() {
    SendEvent "{w up}"
    SendEvent "{q up}"
    SendEvent "{f up}"
}

Task_Action_PressF() {
    SendEvent "{f down}"
    SendEvent "{f up}"
}

Task_Action_UpdateStatus(wqfffUpdateStatusText, wqfffUpdateStatusValue) {
    wqfffUpdateStatusText.Text := wqfffUpdateStatusValue
}

; ★ 统一释放出口。
; ★ F7、输入保护暂停、GL 切换、GL F8、OnExit 都最终要保证 W/Q/F 和 Timer 被清理。
Task_Action_ReleaseKeys(&wqfffReleaseRunning, wqfffReleasePressTimer, wqfffReleaseInputGuard) {
    Input_InputControl_StopGuard(wqfffReleaseInputGuard)
    SetTimer(wqfffReleasePressTimer, 0)
    SendEvent "{w up}"
    SendEvent "{q up}"
    SendEvent "{f up}"
    wqfffReleaseRunning := false
}
