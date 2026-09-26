#Requires AutoHotkey v2.0

SHIFT_Start() {
    global running
    running := true
    SHIFT_Down()
}

SHIFT_Stop() {
    global running
    running := false
    SHIFT_Up()
}

SHIFT_WriteHwnd() {
    global glFile, myGui

    if FileExist(glFile)
        FileDelete glFile

    FileAppend(myGui.Hwnd, glFile)
}
