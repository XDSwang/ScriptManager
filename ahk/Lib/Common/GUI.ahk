; ScriptManager AHK Common GUI Library
; AutoHotkey v2

class GLGui {
    static _controls := Map()

    ; Create - 创建统一的置顶、黑底、透明GUI；参数：title=标题，width=宽度，height=高度，x/y=可选位置。
    static Create(title := "", width := 300, height := 35, x := unset, y := unset) {
        guiObj := Gui("+AlwaysOnTop", title)
        guiObj.BackColor := "000000"
        guiObj.SetFont("s9 cFFFFFF", "Microsoft YaHei")

        if IsSet(x) && IsSet(y)
            guiObj.Show("x" x " y" y " w" width " h" height)
        else
            guiObj.Show("w" width " h" height)

        WinSetTransparent(220, guiObj)
        return guiObj
    }

    ; UpdateList - 更新脚本名称列表和当前项颜色；参数：gui=GUI对象，scripts=脚本路径数组，currentIndex=当前索引。
    static UpdateList(gui, scripts, currentIndex) {
        if !gui
            return 0

        if !GLGui._controls.Has(gui.Hwnd)
            GLGui._controls[gui.Hwnd] := []

        controls := GLGui._controls[gui.Hwnd]
        x := 8
        y := 9

        for index, item in scripts {
            SplitPath item, &name

            if index > controls.Length {
                gui.SetFont("s9 cFFFFFF", "Microsoft YaHei")
                controls.Push(gui.AddText("x" x " y" y, name))
            }

            control := controls[index]
            color := index = currentIndex ? "FF0000" : "FFFFFF"

            control.Text := name
            control.SetFont("c" color)
            control.Move(x, y)
            control.Visible := true

            control.GetPos(&cx, &cy, &cw, &ch)
            x += cw + 8
        }

        Loop controls.Length - scripts.Length {
            index := scripts.Length + A_Index
            controls[index].Visible := false
        }

        return gui
    }
}
