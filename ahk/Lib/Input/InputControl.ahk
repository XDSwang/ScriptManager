#Requires AutoHotkey v2.0

; Input_RegisterKey - 注册需要统一释放的按键；参数：keys=按键数组，key=按键名称。
Input_RegisterKey(inputRegisterKeyKeys, inputRegisterKeyKey) {
    inputRegisterKeyKeys.Push(inputRegisterKeyKey)
    return inputRegisterKeyKeys
}

; Input_KeyDown - 按下指定按键；参数：key=按键名称。
Input_KeyDown(inputKeyDownKey) {
    SendEvent "{" inputKeyDownKey " down}"
    return true
}

; Input_KeyUp - 释放指定按键；参数：key=按键名称。
Input_KeyUp(inputKeyUpKey) {
    SendEvent "{" inputKeyUpKey " up}"
    return true
}

; Input_ReleaseKeys - 释放按键数组中的所有按键；参数：keys=按键数组。
Input_ReleaseKeys(inputReleaseKeysList) {
    for inputReleaseKeysKey in inputReleaseKeysList
        Input_KeyUp(inputReleaseKeysKey)

    return true
}
