#Requires AutoHotkey v2.0

;================================
; Window_GetActive
; 获取当前活动窗口句柄
;
; 参数:
; 无
;
; 返回:
; 当前窗口 hwnd
;================================
Window_GetActive()
{
    hwnd := WinExist("A")

    return hwnd
}


;================================
; Window_SetTop
; 设置窗口置顶状态
;
; 参数:
; hwnd 目标窗口句柄
;
; 返回:
; true 成功
;================================
Window_SetTop(hwnd)
{
    WinSetAlwaysOnTop true,, "ahk_id " hwnd

    return true
}


;================================
; Window_SendMessage
; 向指定窗口发送消息
;
; 参数:
; hwnd 目标窗口句柄
; msg  消息编号
;
; 返回:
; SendMessage结果
;================================
Window_SendMessage(hwnd, msg)
{
    result := SendMessage(
        msg,
        0,
        0,,
        "ahk_id " hwnd
    )

    return result
}
