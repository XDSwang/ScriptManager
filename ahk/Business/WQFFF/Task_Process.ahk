#Requires AutoHotkey v2.0

WQFFF_Start() {
    global running, fInterval

    running := true
    WQFFF_Down()
    SetTimer(WQFFF_PressF_Timer, fInterval)
}

WQFFF_Stop() {
    global running

    running := false
    SetTimer(WQFFF_PressF_Timer, 0)
    WQFFF_Up()
}

WQFFF_PressF_Timer(*) {
    WQFFF_PressF()
}

WQFFF_WriteHwnd() {
    global glFile, myGui

    if FileExist(glFile)
        FileDelete glFile

    FileAppend(myGui.Hwnd, glFile)
}
