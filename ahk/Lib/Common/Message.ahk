; AHK Common Message Library

GL_MESSAGE_EXIT := 0xB001

SendExitMessage(hwnd) {
    if hwnd
        PostMessage(GL_MESSAGE_EXIT, 0, 0, , "ahk_id " hwnd)
}
