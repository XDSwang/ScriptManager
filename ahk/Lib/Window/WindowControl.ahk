#Requires AutoHotkey v2.0

Window_GetActive()
{
    return WinExist("A")
}

Window_SetTop(hwnd)
{
    WinSetAlwaysOnTop true,, "ahk_id " hwnd
}
