#Requires AutoHotkey v2.0

;================================
; SubScript_RegisterHwnd
; 注册子脚本窗口句柄文件
;
; 参数:
; gui_hwnd  GUI窗口句柄
;
; 返回:
; hwnd文件路径
;================================
SubScript_RegisterHwnd(gui_hwnd)
{
    hwnd_file := A_ScriptDir "\\" A_ScriptName ".txt"

    if FileExist(hwnd_file)
        FileDelete(hwnd_file)

    FileAppend(gui_hwnd, hwnd_file)

    return hwnd_file
}


;================================
; SubScript_InitExit
; 初始化GL退出消息和退出清理
;
; 参数:
; pressed_keys 已注册按键列表
; hwnd_file    状态文件路径
;
; 返回:
; true
;================================
SubScript_InitExit(pressed_keys, hwnd_file)
{
    OnMessage(0xB001, SubScript_Exit.Bind(pressed_keys, hwnd_file))

    OnExit(
        SubScript_Cleanup.Bind(pressed_keys, hwnd_file)
    )

    return true
}


;================================
; SubScript_Exit
; 接收GL退出请求并关闭子脚本
;
; 参数:
; pressed_keys 已注册按键列表
; hwnd_file    状态文件路径
;
; 返回:
; 无
;================================
SubScript_Exit(pressed_keys, hwnd_file, *)
{
    SubScript_Cleanup(pressed_keys, hwnd_file)

    ExitApp
}


;================================
; SubScript_Cleanup
; 清理按键和状态文件
;
; 参数:
; pressed_keys 已注册按键列表
; hwnd_file    状态文件路径
;
; 返回:
; true
;================================
SubScript_Cleanup(pressed_keys, hwnd_file, *)
{
    Input_ReleaseKeys(pressed_keys)

    if FileExist(hwnd_file)
        FileDelete(hwnd_file)

    return true
}
