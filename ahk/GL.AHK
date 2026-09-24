#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

scriptFolder := A_ScriptDir "\副脚本1"

guiTitle := "GL管理器"
guiWidth := Floor(A_ScreenWidth / 2)

scripts := []

Loop Files, scriptFolder "\*.ahk"
{
    if (A_LoopFileFullPath != A_ScriptFullPath)
        scripts.Push({name:A_LoopFileName, path:A_LoopFileFullPath})
}

if (scripts.Length = 0)
{
    MsgBox "没有找到脚本"
    ExitApp
}

SortScripts()

global current := 0
global currentHwnd := 0

glGui := Gui("+AlwaysOnTop", guiTitle)
glGui.BackColor := "000000"
glGui.SetFont("s9 cFFFFFF", "Microsoft YaHei")
statusText := glGui.AddText("x10 y8 w" (guiWidth-20) " h20", "等待启动")
glGui.Show("x0 y0 w" guiWidth " h35 NoActivate")
WinSetTransparent(220, glGui)

*^Up::SwitchScript(-1)
*^Down::SwitchScript(1)

SwitchScript(direction)
{
    global current, currentHwnd, scripts, scriptFolder

    if (current != 0)
        ExitCurrent()

    if (current = 0)
        current := 1
    else
    {
        current += direction
        if (current > scripts.Length)
            current := 1
        if (current < 1)
            current := scripts.Length
    }

    StartCurrent()
    UpdateDisplay()
}

ExitCurrent()
{
    global currentHwnd, scripts, current, scriptFolder

    hwndFile := scriptFolder "\" scripts[current].name ".txt"

    if FileExist(hwndFile)
    {
        try currentHwnd := Integer(FileRead(hwndFile))
    }

    if currentHwnd
    {
        try SendMessage(0xB001,0,0,,"ahk_id " currentHwnd)
    }

    Loop 20
    {
        Sleep 100
        if !FileExist(hwndFile)
            break
    }

    currentHwnd := 0
}

StartCurrent()
{
    global scripts, current, currentHwnd, scriptFolder

    hwndFile := scriptFolder "\" scripts[current].name ".txt"

    if FileExist(hwndFile)
        FileDelete(hwndFile)

    Run scripts[current].path

    Loop 50
    {
        Sleep 100
        if FileExist(hwndFile)
        {
            currentHwnd := Integer(FileRead(hwndFile))
            break
        }
    }
}

UpdateDisplay()
{
    global statusText, scripts, current

    text := ""
    for index,item in scripts
    {
        if index = current
            text .= "★" item.name "    "
        else
            text .= item.name "    "
    }

    statusText.Text := text
}

SortScripts()
{
    global scripts

    text := ""
    for item in scripts
        text .= item.name "|" item.path "`n"

    text := Sort(text)
    scripts := []

    Loop Parse,text,"`n"
    {
        if A_LoopField = ""
            continue

        p := StrSplit(A_LoopField,"|")
        scripts.Push({name:p[1], path:p[2]})
    }
}
