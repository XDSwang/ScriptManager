#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../Lib/Common/GUI.ahk
#Include ../Lib/Common/Message.ahk
#Include GL_Process.ahk
#Include GL_Action.ahk

scriptFolder := A_ScriptDir "\..\Business"
scripts := []
current := 0
managerGui := 0

GL_LoadScripts()
GL_Show()

^Up::GL_SwitchScript(1)
^Down::GL_SwitchScript(-1)
