#Requires AutoHotkey v2.0

; ★ GL_SwitchScript：Ctrl+Up / Ctrl+Down 的完整运行链。
; ★ ① 停止当前子脚本
; ★ ② 等待当前子脚本退出并删除 .txt 句柄文件
; ★ ③ 修改当前索引并处理首尾循环
; ★ ④ 启动新的 MAIN.ahk
; ★ ⑤ 刷新 GL GUI
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

; ★ GL_StartFirst：GL 管理器启动后的第一条子脚本运行链。
; ★ ① 当前索引设为第 1 个
; ★ ② Run 第 1 个子脚本 MAIN.ahk
; ★ ③ 等待其完成基本初始化
; ★ ④ 刷新管理器 GUI
GL_StartFirst(glStartScripts, &glStartCurrentIndex, glStartManagerGuiState) {
    if glStartScripts.Length = 0
        return

    glStartCurrentIndex := 1
    Run(glStartScripts[glStartCurrentIndex].path)
    Sleep 100
    GL_Refresh(glStartManagerGuiState, glStartScripts, glStartCurrentIndex)
}

; ★ GL_StopCurrent：管理器停止子脚本的统一流程。
; ★ 切换和 F8 都必须经过这里，避免出现“一处退出方式”和另一处不一致。
; ★ 退出消息发出后，管理器不会立即启动下一个脚本，而是一直等到当前子脚本删除自己的 HWND 文件。
GL_StopCurrent(glStopScripts, glStopCurrentIndex, glStopCurrentReason) {
    if glStopCurrentIndex < 1 || glStopCurrentIndex > glStopScripts.Length
        return false

    SplitPath glStopScripts[glStopCurrentIndex].path, &glStopCurrentFileName, &glStopCurrentDir
    glStopCurrentHwndFile := glStopCurrentDir "\" glStopCurrentFileName ".txt"

    if !FileExist(glStopCurrentHwndFile)
        return false

    ; ★ 先发送退出消息，再等待子脚本自己完成清理。
    GL_RequestExitCurrent(glStopScripts, glStopCurrentIndex, glStopCurrentReason)

    Loop {
        Sleep 50
        if !FileExist(glStopCurrentHwndFile)
            return true
    }
}

; ★ GL_RequestExitCurrent：根据当前脚本的 .txt 文件取得 HWND，再发送 0xB001 退出消息。
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

; ★ GL_ReadHwndFile：处理子脚本刚启动时“文件存在但还没写完”的短暂状态。
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

; ★ F8 管理器退出完整链：
; ★ F8 → GL_ExitManager → 停止当前子脚本 → 等待 .txt 删除 → 记录日志 → ExitApp。
GL_ExitManager(glExitManagerScripts, glExitManagerCurrentIndex) {
    GL_StopCurrent(glExitManagerScripts, glExitManagerCurrentIndex, GLMessage.ExitReasonManager)
    GL_LogError("GL F8 退出", "管理器主动结束；已等待当前子脚本退出")
    ExitApp
}

GL_Show() {
    return GLGui.Create("GL管理器", 300, 35)
}

; ★ 每次启动/切换后刷新管理器 GUI；当前索引由 GUI 公共库显示为红色。
GL_Refresh(glRefreshManagerGuiState, glRefreshScripts, glRefreshCurrentIndex) {
    if !glRefreshManagerGuiState
        return

    GLGui.UpdateList(glRefreshManagerGuiState, glRefreshScripts, glRefreshCurrentIndex)
}
