#Requires AutoHotkey v2.0

GL_SwitchScript(glSwitchStep, glSwitchScripts, &glSwitchCurrentIndex, glSwitchManagerGui) {
    if glSwitchScripts.Length = 0
        return

    if glSwitchCurrentIndex > 0
        GL_StopCurrent(glSwitchScripts, glSwitchCurrentIndex)

    glSwitchCurrentIndex += glSwitchStep
    if glSwitchCurrentIndex < 1
        glSwitchCurrentIndex := glSwitchScripts.Length
    if glSwitchCurrentIndex > glSwitchScripts.Length
        glSwitchCurrentIndex := 1

    Run glSwitchScripts[glSwitchCurrentIndex]
    Sleep 100
    GL_Refresh(glSwitchManagerGui, glSwitchScripts, glSwitchCurrentIndex)
}

GL_StartFirst(glStartScripts, &glStartCurrentIndex, glStartManagerGui) {
    if glStartScripts.Length = 0
        return

    glStartCurrentIndex := 1
    Run glStartScripts[glStartCurrentIndex]
    Sleep 100
    GL_Refresh(glStartManagerGui, glStartScripts, glStartCurrentIndex)
}

GL_StopCurrent(glStopScripts, glStopCurrentIndex) {
    SplitPath glStopScripts[glStopCurrentIndex], &glStopFileName, &glStopDir
    glStopHwndFile := glStopDir "\" glStopFileName ".txt"

    SendEvent "{F7}"
    Sleep 100

    if FileExist(glStopHwndFile) {
        glStopHwnd := Trim(FileRead(glStopHwndFile))
        if glStopHwnd
            SendExitMessage(glStopHwnd)

        Loop 20 {
            Sleep 100
            if !FileExist(glStopHwndFile)
                break
        }

        if FileExist(glStopHwndFile)
            FileDelete glStopHwndFile
    }
}

GL_Show() {
    return GLGui.Create("GL管理器", 300, 35)
}

GL_Refresh(glRefreshManagerGui, glRefreshScripts, glRefreshCurrentIndex) {
    if !glRefreshManagerGui
        return

    GLGui.UpdateList(glRefreshManagerGui, glRefreshScripts, glRefreshCurrentIndex)
}
