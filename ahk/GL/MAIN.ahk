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

    Hotkey("^Up", (*) => GL_SwitchScript(1, glMainScripts, &glMainCurrentIndex, glMainManagerGuiState))
    Hotkey("^Down", (*) => GL_SwitchScript(-1, glMainScripts, &glMainCurrentIndex, glMainManagerGuiState))
    Hotkey("F8", (*) => GL_ExitManager(glMainScripts, glMainCurrentIndex))
}

GL_Main(GL_GetManagedFolder())
