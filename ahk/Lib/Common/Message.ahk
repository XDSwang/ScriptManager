#Requires AutoHotkey v2.0

; GLMessage - 定义 GL 管理器与子脚本通信使用的消息编号和退出原因常量；参数：无。
class GLMessage {
    static ExitMessage := 0xB001
    static ExitReasonSwitch := 1
    static ExitReasonManager := 2
}

; SendExitMessage - 向指定脚本窗口发送统一的 GL 退出消息；参数：hwnd=目标窗口句柄，reason=退出原因，默认使用切换脚本原因。
SendExitMessage(glSendExitMessageHwnd, glSendExitMessageReason := GLMessage.ExitReasonSwitch) {
    if glSendExitMessageHwnd
        PostMessage(GLMessage.ExitMessage, glSendExitMessageReason, 0, , "ahk_id " glSendExitMessageHwnd)

    return true
}
