; AHK Common Message Library

GL_MESSAGE_EXIT := 0xB001 ; GL退出消息编号。

; SendExitMessage - 向指定脚本窗口发送GL退出消息；参数：hwnd=目标窗口句柄。
SendExitMessage(hwnd) {
    if hwnd
        PostMessage(GL_MESSAGE_EXIT, 0, 0, , "ahk_id " hwnd)
}