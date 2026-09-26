#Requires AutoHotkey v2.0

SHIFT_Down() {
    SendEvent "{LShift down}"
}

SHIFT_Up() {
    SendEvent "{LShift up}"
}

SHIFT_UpdateStatus(text) {
    global statusText
    statusText.Text := text
}

SHIFT_ReleaseKeys(*) {
    global shiftHeld
    SendEvent "{LShift up}"
    shiftHeld := false
}
