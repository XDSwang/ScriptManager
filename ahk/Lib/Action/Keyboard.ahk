#Requires AutoHotkey v2.0

; KeyDown - 按下指定按键；参数：key=按键名称。
KeyDown(key) {
    Send "{" key " down}"
}

; KeyUp - 释放指定按键；参数：key=按键名称。
KeyUp(key) {
    Send "{" key " up}"
}