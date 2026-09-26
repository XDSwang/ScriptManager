#Requires AutoHotkey v2.0

; GL_WindowActivate - 激活指定窗口；参数：hwnd=目标窗口句柄。
GL_WindowActivate(glWindowActivateHwnd) {
    if glWindowActivateHwnd
        WinActivate("ahk_id " glWindowActivateHwnd)
}

; GL_WindowExists - 检查指定窗口是否存在；参数：hwnd=目标窗口句柄。
GL_WindowExists(glWindowExistsHwnd) {
    return glWindowExistsHwnd && WinExist("ahk_id " glWindowExistsHwnd)
}
