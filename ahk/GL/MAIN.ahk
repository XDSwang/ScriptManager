#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../Lib/Common/GUI.ahk
#Include ../Lib/Common/Message.ahk
#Include ../Lib/Common/Log.ahk
#Include GL_Config.ahk
#Include GL_Process.ahk
#Include GL_Action.ahk

GL_Main(glMainScriptFolder) {
    glMainScripts := GL_LoadScripts(glMainScriptFolder)
    glMainCurrentIndex := 0
    glMainManagerGuiState := GL_Show()

    GL_StartFirst(glMainScripts, &glMainCurrentIndex, glMainManagerGuiState)

    ; GL 切换热键必须使用 *^：子脚本可能持续物理/模拟按住 Shift、Ctrl、Alt 或 Win，* 可确保 Ctrl+方向键不因额外修饰键而失效。
    Hotkey("*^Up", (*) => GL_SwitchScript(1, glMainScripts, &glMainCurrentIndex, glMainManagerGuiState))
    Hotkey("*^Down", (*) => GL_SwitchScript(-1, glMainScripts, &glMainCurrentIndex, glMainManagerGuiState))
    ; GL 退出热键使用 *：即使子脚本持续按住 Shift、Ctrl、Alt 或 Win，也必须能够触发管理器退出流程。
    Hotkey("*F8", (*) => GL_ExitManager(glMainScripts, glMainCurrentIndex))
}

GL_Main(GL_GetManagedFolder())
