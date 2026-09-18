#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook


;============================================================
; 脚本目录
;============================================================

scriptFolder := A_ScriptDir "\副脚本1"



;============================================================
; GL窗口模板
; 后期修改窗口只改这里
;============================================================

guiTitle := "GL管理器"

guiWidth := Floor(A_ScreenWidth / 2)

lineHeight := 25



;============================================================
; 读取脚本
;============================================================

scripts := []


Loop Files, scriptFolder "\*.ahk"
{
    if (A_LoopFileFullPath != A_ScriptFullPath)
    {
        scripts.Push(
            {
                name:A_LoopFileName,
                path:A_LoopFileFullPath
            }
        )
    }
}



if (scripts.Length = 0)
{
    MsgBox "没有找到脚本"
    ExitApp
}



SortScripts()



;============================================================
; 状态
;============================================================

current := 0

currentHwnd := 0



;============================================================
; 创建GL窗口
;============================================================

glGui := Gui(
    "+AlwaysOnTop",
    guiTitle
)


glGui.BackColor := "000000"


glGui.SetFont(
    "s9 cFFFFFF",
    "Microsoft YaHei"
)



statusText := glGui.AddText(
    "x10 y8 w" (guiWidth-20) " h20",
    "等待启动"
)



;============================================================
; 默认左上角
;============================================================

glGui.Show(
    "x0 y0 w" guiWidth " h35 NoActivate"
)



WinSetTransparent(
    220,
    glGui
)





;============================================================
; Ctrl + ↑ 上一个
;============================================================

*^Up::
{
    SwitchScript(-1)
}



;============================================================
; Ctrl + ↓ 下一个
;============================================================

*^Down::
{
    SwitchScript(1)
}







;============================================================
; 切换脚本
;============================================================

SwitchScript(direction)
{
    global current
    global scripts
    global currentHwnd
    global scriptFolder



    ;==========================
    ; 关闭当前脚本
    ;==========================

    if(current != 0)
    {

        hwndFile :=
            scriptFolder "\" scripts[current].name ".txt"



        if FileExist(hwndFile)
        {
            try
            {
                currentHwnd :=
                    Integer(FileRead(hwndFile))
            }
        }



        if(currentHwnd)
        {
            try
            {
                SendMessage(
                    0xB001,
                    0,
                    0,
                    ,
                    "ahk_id " currentHwnd
                )
            }
        }



        Sleep 300
    }




    ;==========================
    ; 计算目标
    ;==========================

    if(current=0)
    {
        current:=1
    }
    else
    {
        current += direction


        if(current > scripts.Length)
            current:=1


        if(current < 1)
            current:=scripts.Length
    }




    ;==========================
    ; 启动脚本
    ;==========================

    Run scripts[current].path



    Sleep 300



    UpdateDisplay()
}







;============================================================
; 显示列表
;============================================================

UpdateDisplay()
{
    global statusText
    global scripts
    global current
    global glGui
    global guiWidth
    global lineHeight



    maxChars := Floor(guiWidth / 10)



    text := ""

    line := ""

    lineCount := 1



    for index,item in scripts
    {

        if(index=current)
            name := "★" item.name
        else
            name := item.name



        addText := name "    "



        if(StrLen(line addText) > maxChars)
        {

            text .= line "`n"

            line := addText

            lineCount++

        }
        else
        {
            line .= addText
        }
    }



    text .= line



    statusText.Text := text



    newHeight := lineCount * lineHeight + 10



    glGui.Show(
        "w" guiWidth
        " h" newHeight
        " NoActivate"
    )
}







;============================================================
; 排序
;============================================================

SortScripts()
{
    global scripts


    text := ""


    for item in scripts
    {
        text .= item.name "|" item.path "`n"
    }



    text := Sort(text)



    scripts := []



    Loop Parse,text,"`n"
    {

        if(A_LoopField="")
            continue



        p := StrSplit(
            A_LoopField,
            "|"
        )



        scripts.Push(
            {
                name:p[1],
                path:p[2]
            }
        )
    }
}