; Window action helpers
#Requires AutoHotkey v2.0

GL_WindowActivate(hwnd) {
    if hwnd
        WinActivate("ahk_id " hwnd)
}

GL_WindowExists(hwnd) {
    return hwnd && WinExist("ahk_id " hwnd)
}
