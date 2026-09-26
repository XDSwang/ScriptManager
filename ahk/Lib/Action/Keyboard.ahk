#Requires AutoHotkey v2.0

; Action_Keyboard_KeyDown - 使用 Send 按下指定按键；参数：key=AHK 按键名称。
Action_Keyboard_KeyDown(actionKeyboardKeyDownKey) {
    Send "{" actionKeyboardKeyDownKey " down}"
    return true
}

; Action_Keyboard_KeyUp - 使用 Send 释放指定按键；参数：key=AHK 按键名称。
Action_Keyboard_KeyUp(actionKeyboardKeyUpKey) {
    Send "{" actionKeyboardKeyUpKey " up}"
    return true
}
