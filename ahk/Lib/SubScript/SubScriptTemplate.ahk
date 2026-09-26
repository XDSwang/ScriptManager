#Requires AutoHotkey v2.0

; SubScript_RegisterHwnd - 注册子脚本自己的窗口句柄文件；参数：gui_hwnd=GUI窗口句柄。
SubScript_RegisterHwnd(subScriptRegisterHwndGuiHwnd) {
    subScriptRegisterHwndFile := A_ScriptDir "\" A_ScriptName ".txt"

    if FileExist(subScriptRegisterHwndFile)
        FileDelete(subScriptRegisterHwndFile)

    FileAppend(subScriptRegisterHwndGuiHwnd, subScriptRegisterHwndFile)
    return subScriptRegisterHwndFile
}

; SubScript_InitExit - 初始化GL退出消息和退出清理；参数：pressed_keys=已注册按键数组，hwnd_file=句柄文件路径。
SubScript_InitExit(subScriptInitExitPressedKeys, subScriptInitExitHwndFile) {
    OnMessage(0xB001, SubScript_Exit.Bind(subScriptInitExitPressedKeys, subScriptInitExitHwndFile))
    OnExit(SubScript_Cleanup.Bind(subScriptInitExitPressedKeys, subScriptInitExitHwndFile))
    return true
}

; SubScript_Exit - 接收GL退出请求并关闭子脚本；参数：pressed_keys=已注册按键数组，hwnd_file=句柄文件路径。
SubScript_Exit(subScriptExitPressedKeys, subScriptExitHwndFile, *) {
    SubScript_Cleanup(subScriptExitPressedKeys, subScriptExitHwndFile)
    ExitApp
}

; SubScript_Cleanup - 清理按键和句柄文件；参数：pressed_keys=已注册按键数组，hwnd_file=句柄文件路径。
SubScript_Cleanup(subScriptCleanupPressedKeys, subScriptCleanupHwndFile, *) {
    Input_ReleaseKeys(subScriptCleanupPressedKeys)

    if FileExist(subScriptCleanupHwndFile)
        FileDelete(subScriptCleanupHwndFile)

    return true
}
