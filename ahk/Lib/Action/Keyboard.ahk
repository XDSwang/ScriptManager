#Requires AutoHotkey v2.0

; KeyDown - 按下指定按键；参数：key=按键名称。
KeyDown(keyDownKey) {
    Send "{" keyDownKey " down}"
}

; KeyUp - 释放指定按键；参数：key=按键名称。
KeyUp(keyUpKey) {
    Send "{" keyUpKey " up}"
}
