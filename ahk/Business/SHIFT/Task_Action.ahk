#Requires AutoHotkey v2.0

; ★ SHIFT_Action 只放“实际动作”，不决定什么时候执行。
; ★ Process 决定流程，Action 负责真正按键。

SHIFT_Down() {
    SendEvent "{LShift down}"
}

SHIFT_Up() {
    SendEvent "{LShift up}"
}

; ★ GUI 状态更新也是具体动作，因此放在 Action 层。
SHIFT_UpdateStatus(shiftUpdateStatusText, shiftUpdateStatusValue) {
    shiftUpdateStatusText.Text := shiftUpdateStatusValue
}

; ★ 统一释放出口。
; ★ F7、GL 切换、GL F8、OnExit 最终都必须保证 Shift 被释放。
SHIFT_ReleaseKeys(&shiftReleaseHeld, shiftReleaseInputGuard) {
    Input_StopGuard(shiftReleaseInputGuard)
    SendEvent "{LShift up}"
    shiftReleaseHeld := false
}
