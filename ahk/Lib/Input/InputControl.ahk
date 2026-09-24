#Requires AutoHotkey v2.0

;================================
; Input_RegisterKey
; 注册需要统一释放的按键
;
; 参数:
; keys 当前按键列表
; key  按键名称
;
; 返回:
; 更新后的按键列表
;================================
Input_RegisterKey(keys, key)
{
    keys.Push(key)

    return keys
}


;================================
; Input_KeyDown
; 按下指定按键
;
; 参数:
; key 按键名称
;
; 返回:
; true 执行成功
;================================
Input_KeyDown(key)
{
    SendEvent "{" key " down}"

    return true
}


;================================
; Input_KeyUp
; 释放指定按键
;
; 参数:
; key 按键名称
;
; 返回:
; true 执行成功
;================================
Input_KeyUp(key)
{
    SendEvent "{" key " up}"

    return true
}


;================================
; Input_ReleaseKeys
; 释放按键列表中的所有按键
;
; 参数:
; keys 按键列表
;
; 返回:
; true 执行完成
;================================
Input_ReleaseKeys(keys)
{
    for key in keys
        Input_KeyUp(key)

    return true
}
