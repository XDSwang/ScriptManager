 ; Window action helpers
#Requires AutoHotkey v2.0

; GL_WindowActivate - 激活指定窗口；参数：hwnd=目标窗口句柄。
GL_WindowActivate(hwnd) {
    if hwnd
        WinActivate("ahk_id " hwnd)
}

; GL_WindowExists - 检查指定窗口是否存在；参数：hwnd=目标窗口句柄。
GL_WindowExists(hwnd) {
    return hwnd && WinExist("ahk_id " hwnd)
}