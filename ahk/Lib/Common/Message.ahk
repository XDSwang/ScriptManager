; AHK Common Message Library

class GLMessage {
    static ExitMessage := 0xB001
    static ExitReasonSwitch := 1
    static ExitReasonManager := 2
}

; SendExitMessage - 向指定脚本窗口发送GL退出消息；参数：hwnd=目标窗口句柄，reason=退出原因。
SendExitMessage(glSendExitMessageHwnd, glSendExitMessageReason := GLMessage.ExitReasonSwitch) {
    if glSendExitMessageHwnd
        PostMessage(GLMessage.ExitMessage, glSendExitMessageReason, 0, , "ahk_id " glSendExitMessageHwnd)
}
