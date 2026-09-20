#Requires AutoHotkey v2.0

ManagerScript_Start(script_path)
{
    Run(script_path)
}

ManagerScript_ReadHwnd(script_path)
{
    hwnd_file := script_path ".txt"

    if !FileExist(hwnd_file)
        return 0

    return Integer(FileRead(hwnd_file))
}

ManagerScript_IsRunning(hwnd)
{
    return WinExist("ahk_id " hwnd) != 0
}

ManagerScript_SendExit(hwnd)
{
    if ManagerScript_IsRunning(hwnd)
    {
        PostMessage(0xB001,,,,"ahk_id " hwnd)
    }
}
