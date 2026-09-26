#Requires AutoHotkey v2.0

; ManagerScript_Start - 启动指定脚本；参数：script_path=脚本完整路径。
ManagerScript_Start(script_path)
{
    Run(script_path)
}

; ManagerScript_ReadHwnd - 读取脚本对应的hwnd文件；参数：script_path=脚本路径。
ManagerScript_ReadHwnd(script_path)
{
    hwnd_file := script_path ".txt"

    if !FileExist(hwnd_file)
        return 0

    return Integer(FileRead(hwnd_file))
}

; ManagerScript_IsRunning - 检查指定窗口是否存在；参数：hwnd=窗口句柄。
ManagerScript_IsRunning(hwnd)
{
    return WinExist("ahk_id " hwnd) != 0
}

; ManagerScript_SendExit - 向指定脚本发送0xB001退出消息；参数：hwnd=目标窗口句柄。
ManagerScript_SendExit(hwnd)
{
    if ManagerScript_IsRunning(hwnd)
    {
        PostMessage(0xB001,,,,"ahk_id " hwnd)
    }
}