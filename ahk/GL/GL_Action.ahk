#Requires AutoHotkey v2.0

GL_SwitchScript(glSwitchStep, glSwitchScripts, &glSwitchCurrentIndex, glSwitchManagerGuiState) {
    if glSwitchScripts.Length = 0
        return

    if glSwitchCurrentIndex > 0
        GL_StopCurrent(glSwitchScripts, glSwitchCurrentIndex)

    glSwitchCurrentIndex += glSwitchStep
    if glSwitchCurrentIndex < 1
        glSwitchCurrentIndex := glSwitchScripts.Length
    if glSwitchCurrentIndex > glSwitchScripts.Length
        glSwitchCurrentIndex := 1

    Run(glSwitchScripts[glSwitchCurrentIndex].path)
    Sleep 100
    GL_Refresh(glSwitchManagerGuiState, glSwitchScripts, glSwitchCurrentIndex)
}

GL_StartFirst(glStartScripts, &glStartCurrentIndex, glStartManagerGuiState) {
    if glStartScripts.Length = 0
        return

    glStartCurrentIndex := 1
    Run(glStartScripts[glStartCurrentIndex].path)
    Sleep 100
    GL_Refresh(glStartManagerGuiState, glStartScripts, glStartCurrentIndex)
}

GL_StopCurrent(glStopScripts, glStopCurrentIndex) {
    SplitPath glStopScripts[glStopCurrentIndex].path, &glStopFileName, &glStopDir
    glStopHwndFile := glStopDir "\" glStopFileName ".txt"

    if !FileExist(glStopHwndFile)
        return

    glStopHwnd := Trim(FileRead(glStopHwndFile))
    if glStopHwnd
        SendExitMessage(glStopHwnd)

    Loop {
        Sleep 50
        if !FileExist(glStopHwndFile)
            break
    }
}

GL_Show() {
    return GLGui.Create("GL管理器", 300, 35)
}

GL_Refresh(glRefreshManagerGuiState, glRefreshScripts, glRefreshCurrentIndex) {
    if !glRefreshManagerGuiState
        return

    GLGui.UpdateList(glRefreshManagerGuiState, glRefreshScripts, glRefreshCurrentIndex)
}
