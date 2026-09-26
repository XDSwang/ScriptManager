#Requires AutoHotkey v2.0

; ManagerScript_Start - 启动指定脚本；参数：script_path=脚本完整路径。
ManagerScript_Start(managerScriptStartPath) {
    Run(managerScriptStartPath)
}

; ManagerScript_ReadHwnd - 读取脚本对应的hwnd文件；参数：script_path=脚本路径。
ManagerScript_ReadHwnd(managerScriptReadHwndScriptPath) {
    managerScriptReadHwndFile := managerScriptReadHwndScriptPath ".txt"

    if !FileExist(managerScriptReadHwndFile)
        return 0

    return Integer(FileRead(managerScriptReadHwndFile))
}

; ManagerScript_IsRunning - 检查指定窗口是否存在；参数：hwnd=窗口句柄。
ManagerScript_IsRunning(managerScriptIsRunningHwnd) {
    return WinExist("ahk_id " managerScriptIsRunningHwnd) != 0
}

; ManagerScript_SendExit - 向指定脚本发送0xB001退出消息；参数：hwnd=目标窗口句柄。
ManagerScript_SendExit(managerScriptSendExitHwnd) {
    if ManagerScript_IsRunning(managerScriptSendExitHwnd)
        PostMessage(0xB001, 0, 0, , "ahk_id " managerScriptSendExitHwnd)
}
