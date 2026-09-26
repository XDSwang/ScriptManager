#Requires AutoHotkey v2.0

; Action_Window_Activate - 激活指定窗口；参数：hwnd=目标窗口句柄。
Action_Window_Activate(commonWindowActivateHwnd) {
    if commonWindowActivateHwnd
        WinActivate("ahk_id " commonWindowActivateHwnd)

    return true
}

; Action_Window_Exists - 检查指定窗口是否存在；参数：hwnd=目标窗口句柄。
Action_Window_Exists(commonWindowExistsHwnd) {
    return commonWindowExistsHwnd && WinExist("ahk_id " commonWindowExistsHwnd)
}
