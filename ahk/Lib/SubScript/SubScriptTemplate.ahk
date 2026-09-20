#Requires AutoHotkey v2.0

SubScript_RegisterHwnd(gui_hwnd)
{
    hwnd_file := A_ScriptDir "\\" A_ScriptName ".txt"

    if FileExist(hwnd_file)
        FileDelete(hwnd_file)

    FileAppend(gui_hwnd, hwnd_file)

    return hwnd_file
}

SubScript_InitExit(pressed_keys, hwnd_file)
{
    OnMessage(0xB001, SubScript_Exit.Bind(pressed_keys, hwnd_file))
}

SubScript_Exit(pressed_keys, hwnd_file, *)
{
    Input_ReleaseKeys(pressed_keys)

    if FileExist(hwnd_file)
        FileDelete(hwnd_file)

    ExitApp
}
