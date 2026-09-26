#Requires AutoHotkey v2.0

SHIFT_Start() {
    global shiftHeld

    if shiftHeld
        return

    SHIFT_Down()
    shiftHeld := true
    SHIFT_UpdateStatus("运行-Shift按住中/释放-按F7暂停")
}

SHIFT_Stop() {
    global shiftHeld

    if !shiftHeld
        return

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
