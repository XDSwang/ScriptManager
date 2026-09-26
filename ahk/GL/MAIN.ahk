#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../Lib/Common/GUI.ahk
#Include ../Lib/Common/Message.ahk
#Include GL_Process.ahk
#Include GL_Action.ahk

GL_Main() {
    glMainScriptFolder := A_ScriptDir "\..\Business"
    glMainScripts := GL_LoadScripts(glMainScriptFolder)
    glMainCurrentIndex := 0
    glMainManagerGui := GL_Show()

    GL_StartFirst(glMainScripts, &glMainCurrentIndex, glMainManagerGui)

    Hotkey("^Up", (*) => GL_SwitchScript(1, glMainScripts, &glMainCurrentIndex, glMainManagerGui))
    Hotkey("^Down", (*) => GL_SwitchScript(-1, glMainScripts, &glMainCurrentIndex, glMainManagerGui))
}

GL_Main()
