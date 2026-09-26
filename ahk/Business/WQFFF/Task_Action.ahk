#Requires AutoHotkey v2.0

WQFFF_Down() {
    SendEvent "{w down}"
    SendEvent "{q down}"
}

WQFFF_Up() {
    SendEvent "{w up}"
    SendEvent "{q up}"
    SendEvent "{f up}"
}

WQFFF_PressF() {
    SendEvent "{f down}"
    SendEvent "{f up}"
}

WQFFF_UpdateStatus(wqfffUpdateStatusText, wqfffUpdateStatusValue) {
    wqfffUpdateStatusText.Text := wqfffUpdateStatusValue
}

WQFFF_ReleaseKeys(&wqfffReleaseRunning, wqfffReleasePressTimer) {
    SetTimer(wqfffReleasePressTimer, 0)
    SendEvent "{w up}"
    SendEvent "{q up}"
    SendEvent "{f up}"
    wqfffReleaseRunning := false
}
