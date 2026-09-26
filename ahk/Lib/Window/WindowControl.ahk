#Requires AutoHotkey v2.0

; Window_GetActive - 获取当前活动窗口句柄；参数：无。
Window_GetActive() {
    windowGetActiveHwnd := WinExist("A")
    return windowGetActiveHwnd
}

; Window_SetTop - 设置窗口置顶状态；参数：hwnd=目标窗口句柄。
Window_SetTop(windowSetTopHwnd) {
    WinSetAlwaysOnTop true,, "ahk_id " windowSetTopHwnd
    return true
}

; Window_SendMessage - 向指定窗口发送消息；参数：hwnd=目标窗口句柄，msg=消息编号。
Window_SendMessage(windowSendMessageHwnd, windowSendMessageMsg) {
    windowSendMessageResult := SendMessage(
        windowSendMessageMsg,
        0,
        0,,
        "ahk_id " windowSendMessageHwnd
    )
    return windowSendMessageResult
}
