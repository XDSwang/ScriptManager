#Requires AutoHotkey v2.0

WQFFF_Down() {
    SendEvent "{w down}"
    SendEvent "{q down}"
}

WQFFF_Up() {
    SendEvent "{w up}"
    SendEvent "{q up}"
}

WQFFF_PressF() {
    SendEvent "{f down}"
    SendEvent "{f up}"
}

WQFFF_UpdateStatus(text) {
    global statusText
    statusText.Text := text
}
