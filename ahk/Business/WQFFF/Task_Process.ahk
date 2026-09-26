#Requires AutoHotkey v2.0

WQFFF_Start() {
    global running, PressFTimer, fInterval

    if running
        return

    running := true
    WQFFF_Down()
    SetTimer(PressFTimer, fInterval)
    WQFFF_UpdateStatus("运行-WQ按住中F循环中/释放-按F7暂停")
}

WQFFF_Stop() {
    global running, PressFTimer

    if !running
        return

    running := false
    SetTimer(PressFTimer, 0)
    WQFFF_Up()
    WQFFF_UpdateStatus("● 待机 | F6 开启")
}

WQFFF_PressFTimer(*) {
    global running

    if !running
        return

    WQFFF_PressF()
}

WQFFF_WriteHwnd() {
    global glFile, myGui

    if FileExist(glFile)
        FileDelete glFile

    FileAppend(myGui.Hwnd, glFile)
}
