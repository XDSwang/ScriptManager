#Requires AutoHotkey v2.0

SHIFT_Start() {
    global shiftHeld

    ; 每次 F6 都按当前状态重新建立运行态。
    SHIFT_Down()
    shiftHeld := true
    SHIFT_UpdateStatus("运行-Shift按住中/释放-按F7暂停")
}

SHIFT_Stop() {
    global shiftHeld

    ; F7 无条件释放 Shift，避免残留状态影响下一次 F6。
    SHIFT_Up()
    shiftHeld := false
    SHIFT_UpdateStatus("● 待机 | F6 开启")
}

SHIFT_WriteHwnd() {
    global glFile, myGui

    if FileExist(glFile)
        FileDelete glFile

    FileAppend(myGui.Hwnd, glFile)
}
