#Requires AutoHotkey v2.0

; Common_Message_Exit - 保存 GL 管理器与子脚本通信所使用的消息编号和退出原因；参数：无。
class Common_Message_Exit {
    static ExitMessage := 0xB001
    static ExitReasonSwitch := 1
    static ExitReasonManager := 2
}

; Common_Message_SendExit - 向指定 hwnd 发送统一退出消息；参数：hwnd=目标窗口句柄，reason=退出原因，可省略。
Common_Message_SendExit(commonMessageSendExitHwnd, commonMessageSendExitReason := Common_Message_Exit.ExitReasonSwitch) {
    if commonMessageSendExitHwnd
        PostMessage(Common_Message_Exit.ExitMessage, commonMessageSendExitReason, 0, , "ahk_id " commonMessageSendExitHwnd)

    return true
}
