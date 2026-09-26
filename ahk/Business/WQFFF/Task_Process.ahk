#Requires AutoHotkey v2.0

WQFFF_Start() {
    global running, fInterval

    ; 每次 F6 都重新建立定时器，确保 F7 后可以再次启动。
    running := true
    WQFFF_Down()
    SetTimer(WQFFF_PressFTimer, fInterval)
    WQFFF_UpdateStatus("运行-WQ按住中F循环中/释放-按F7暂停")
}

WQFFF_Stop() {
    global running

    ; F7 无条件停止定时器并释放按键，避免残留状态影响下一次 F6。
    running := false
    SetTimer(WQFFF_PressFTimer, 0)
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
