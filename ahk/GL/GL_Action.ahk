#Requires AutoHotkey v2.0

GL_SwitchScript(glSwitchStep, glSwitchScripts, &glSwitchCurrentIndex, glSwitchManagerGuiState) {
    if glSwitchScripts.Length = 0
        return

    if glSwitchCurrentIndex > 0
        GL_StopCurrent(glSwitchScripts, glSwitchCurrentIndex, GLMessage.ExitReasonSwitch)

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

GL_StopCurrent(glStopScripts, glStopCurrentIndex, glStopCurrentReason) {
    if glStopCurrentIndex < 1 || glStopCurrentIndex > glStopScripts.Length
        return false

    SplitPath glStopScripts[glStopCurrentIndex].path, &glStopCurrentFileName, &glStopCurrentDir
    glStopCurrentHwndFile := glStopCurrentDir "\" glStopCurrentFileName ".txt"

    if !FileExist(glStopCurrentHwndFile)
        return false

    GL_RequestExitCurrent(glStopScripts, glStopCurrentIndex, glStopCurrentReason)

    Loop {
        Sleep 50
        if !FileExist(glStopCurrentHwndFile)
            return true
    }
}

GL_RequestExitCurrent(glRequestExitScripts, glRequestExitCurrentIndex, glRequestExitReason) {
    if glRequestExitCurrentIndex < 1 || glRequestExitCurrentIndex > glRequestExitScripts.Length
        return

    SplitPath glRequestExitScripts[glRequestExitCurrentIndex].path, &glRequestExitFileName, &glRequestExitDir
    glRequestExitHwndFile := glRequestExitDir "\" glRequestExitFileName ".txt"

    if !FileExist(glRequestExitHwndFile)
        return

    glRequestExitHwnd := GL_ReadHwndFile(glRequestExitHwndFile)
    if glRequestExitHwnd
        SendExitMessage(glRequestExitHwnd, glRequestExitReason)
}

GL_ReadHwndFile(glReadHwndFile) {
    Loop 10 {
        try {
            glReadHwndValue := Trim(FileRead(glReadHwndFile))
            if glReadHwndValue
                return glReadHwndValue
        } catch {
            ; 子脚本可能正在创建、写入或删除句柄文件；文件存在并不代表此刻可读。
        }

        Sleep 20

        if !FileExist(glReadHwndFile)
            return ""
    }

    return ""
}

GL_ExitManager(glExitManagerScripts, glExitManagerCurrentIndex) {
    GL_StopCurrent(glExitManagerScripts, glExitManagerCurrentIndex, GLMessage.ExitReasonManager)
    GL_LogError("GL F8 退出", "管理器主动结束；已等待当前子脚本退出")
    ExitApp
}

GL_Show() {
    return GLGui.Create("GL管理器", 300, 35)
}

GL_Refresh(glRefreshManagerGuiState, glRefreshScripts, glRefreshCurrentIndex) {
    if !glRefreshManagerGuiState
        return

    GLGui.UpdateList(glRefreshManagerGuiState, glRefreshScripts, glRefreshCurrentIndex)
}
