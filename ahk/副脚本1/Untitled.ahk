#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook


; ============================================================
; Shift 按住控制
; ============================================================


; ============================================================
; GUI模板
; 后期修改窗口只改这里
; ============================================================

guiTitle := "Shift 控制"

guiWidth := 300
guiHeight := 35



; ============================================================
; 状态
; ============================================================

shiftHeld := false



; ============================================================
; 创建窗口
; ============================================================

myGui := Gui(
    "+AlwaysOnTop",
    guiTitle
)



myGui.SetFont(
    "s9 cFFFFFF",
    "Microsoft YaHei"
)



statusText := myGui.AddText(
    "x10 y7 w" (guiWidth-20) " h20 Center",
    "● 待机 | F6 开启"
)



myGui.BackColor := "000000"



; ============================================================
; 默认左上角显示
; 后期可以直接拖动
; ============================================================

myGui.Show(
    "x0 y0 w" guiWidth " h" guiHeight
)



; ============================================================
; 写入自己的 GUI 句柄
; ============================================================

glFile := A_ScriptDir "\" A_ScriptName ".txt"



if FileExist(glFile)
{
    FileDelete(glFile)
}



FileAppend(
    myGui.Hwnd,
    glFile
)



WinSetTransparent(
    220,
    myGui
)



; ============================================================
; F6 开启 Shift
; ============================================================

*F6::
{
    global shiftHeld


    if shiftHeld
        return


    SendEvent "{LShift down}"


    shiftHeld := true


    UpdateStatus(
        "运行-Shift按住中/释放-按F7暂停"
    )
}



; ============================================================
; F7 暂停 Shift
; ============================================================

*F7::
{
    global shiftHeld


    if !shiftHeld
        return


    SendEvent "{LShift up}"


    shiftHeld := false


    UpdateStatus(
        "● 待机 | F6 开启"
    )
}



; ============================================================
; 更新窗口
; ============================================================

UpdateStatus(text)
{
    global statusText

    statusText.Text := text
}



; ============================================================
; 退出保险
; ============================================================

OnExit(ReleaseShift)



ReleaseShift(*)
{
    global shiftHeld


    SendEvent "{LShift up}"


    shiftHeld := false
}

; ============================================================
; GL管理器退出通信
; ============================================================

OnMessage(0xB001, GL_Exit)



GL_Exit(*)
{
    global glFile

    if FileExist(glFile)
    {
        FileDelete(glFile)
    }

    ExitApp
}