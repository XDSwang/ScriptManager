#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook


; ============================================================
; 加载公共库
; ============================================================

#Include ..\Lib\GUI\GuiTemplate.ahk
#Include ..\Lib\Input\InputControl.ahk
#Include ..\Lib\SubScript\SubScriptTemplate.ahk



; ============================================================
; 当前副脚本参数
; ============================================================

wqf_title := "W Q F 公共库测试控制"

wqf_width := 300
wqf_height := 35


wqf_running := false


wqf_interval := 100



; ============================================================
; 当前脚本按键数组
; 自己保存
; 公共库只接收
; ============================================================

wqf_pressed_keys := []


wqf_pressed_keys :=
Input_RegisterKey(
    wqf_pressed_keys,
    "w"
)


wqf_pressed_keys :=
Input_RegisterKey(
    wqf_pressed_keys,
    "q"
)


wqf_pressed_keys :=
Input_RegisterKey(
    wqf_pressed_keys,
    "f"
)



; ============================================================
; 创建GUI
; ============================================================

wqf_gui_data :=
Gui_Create(
    wqf_title,
    wqf_width,
    wqf_height,
    "● 待机 | F6 开启"
)



wqf_status :=
wqf_gui_data.status



; ============================================================
; 注册自己的窗口句柄
; ============================================================

wqf_hwnd_file :=
SubScript_RegisterHwnd(
    wqf_gui_data.gui.Hwnd
)



; ============================================================
; 注册退出监听
; ============================================================

SubScript_InitExit(
    wqf_pressed_keys,
    wqf_hwnd_file
)



; ============================================================
; Timer
; ============================================================

wqf_press_timer :=
WQF_PressF.Bind()



; ============================================================
; F6 开启
; ============================================================

*F6::
{
    global wqf_running
    global wqf_interval
    global wqf_press_timer


    if wqf_running
        return


    wqf_running := true



    SendEvent "{w down}"

    SendEvent "{q down}"



    SetTimer(
        wqf_press_timer,
        wqf_interval
    )


    WQF_Update(
        "运行-WQ按住中F循环中/释放-按F7暂停"
    )
}



; ============================================================
; F7暂停
; ============================================================

*F7::
{
    global wqf_running
    global wqf_press_timer


    if !wqf_running
        return


    wqf_running := false



    SetTimer(
        wqf_press_timer,
        0
    )



    SendEvent "{w up}"

    SendEvent "{q up}"



    WQF_Update(
        "● 待机 | F6 开启"
    )
}



; ============================================================
; F循环
; ============================================================

WQF_PressF()
{
    global wqf_running


    if !wqf_running
        return


    SendEvent "{f down}"

    SendEvent "{f up}"
}



; ============================================================
; 状态更新
; 当前脚本自己的函数
; ============================================================

WQF_Update(text)
{
    global wqf_status

    wqf_status.Text := text
}