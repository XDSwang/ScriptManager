#Requires AutoHotkey v2.0

; ★ GL 通信流程：
; ★ 子脚本启动 → 把自己的 GUI HWND 写入 MAIN.ahk.txt
; ★ GL 切换/F8 → 读取这个 HWND
; ★ → PostMessage(0xB001, 退出原因)
; ★ → 子脚本 OnMessage 收到消息
; ★ → 执行自己的停止/清理流程
; ★ → 删除 MAIN.ahk.txt
; ★ → GL 看到文件消失后，才认为子脚本已经退出完成。
;
; ★ 退出原因：
; ★ 1 = 切换脚本
; ★ 2 = 管理器 F8 主动退出
class GLMessage {
    static ExitMessage := 0xB001
    static ExitReasonSwitch := 1
    static ExitReasonManager := 2
}

; ★ SendExitMessage：这里只负责“发消息”，不负责等待、不负责释放按键。
; ★ 真正的清理必须由子脚本自己的 Process/Action 完成。
SendExitMessage(glSendExitMessageHwnd, glSendExitMessageReason := GLMessage.ExitReasonSwitch) {
    if glSendExitMessageHwnd
        PostMessage(GLMessage.ExitMessage, glSendExitMessageReason, 0, , "ahk_id " glSendExitMessageHwnd)

    return true
}
