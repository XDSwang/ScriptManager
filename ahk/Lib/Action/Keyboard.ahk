#Requires AutoHotkey v2.0

; KeyDown - 使用 Send 按下指定按键；参数：key=AHK 按键名称。
KeyDown(keyDownKey) {
    Send "{" keyDownKey " down}"
    return true
}

; KeyUp - 使用 Send 释放指定按键；参数：key=AHK 按键名称。
KeyUp(keyUpKey) {
    Send "{" keyUpKey " up}"
    return true
}
