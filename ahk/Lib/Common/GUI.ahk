; ScriptManager AHK Common GUI Library
; AutoHotkey v2

class GLGui {
    static _controls := Map()

    static Create(title := "", width := 300, height := 35) {
        gui := Gui("+AlwaysOnTop", title)
        gui.BackColor := "000000"
        gui.SetFont("s9 cFFFFFF", "Microsoft YaHei")
        gui.Show("w" width " h" height)
        WinSetTransparent(220, gui)
        return gui
    }

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
