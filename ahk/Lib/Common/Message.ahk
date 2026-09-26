; AHK Common Message Library

class GLMessage {
    static ExitMessage := 0xB001
}

; SendExitMessage - 向指定脚本窗口发送GL退出消息；参数：hwnd=目标窗口句柄。
SendExitMessage(glSendExitMessageHwnd) {
    if glSendExitMessageHwnd
        PostMessage(GLMessage.ExitMessage, 0, 0, , "ahk_id " glSendExitMessageHwnd)
}
