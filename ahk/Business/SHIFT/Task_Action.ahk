#Requires AutoHotkey v2.0

SHIFT_Down() {
    SendEvent "{LShift down}"
}

SHIFT_Up() {
    SendEvent "{LShift up}"
}

SHIFT_UpdateStatus(shiftUpdateStatusText, shiftUpdateStatusValue) {
    shiftUpdateStatusText.Text := shiftUpdateStatusValue
}

SHIFT_ReleaseKeys(&shiftReleaseHeld, shiftReleaseInputGuard) {
    Input_StopGuard(shiftReleaseInputGuard)
    SendEvent "{LShift up}"
    shiftReleaseHeld := false
}
