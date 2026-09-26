; ScriptManager AHK Common GUI Library
; AutoHotkey v2

class GLGui {
    static Create(title := "", width := 300, height := 35) {
        gui := Gui("+AlwaysOnTop", title)
        gui.BackColor := "000000"
        gui.SetFont("s9 cFFFFFF", "Microsoft YaHei")
        gui.Show("w" width " h" height)
        WinSetTransparent(220, gui)
        return gui
    }

    static UpdateList(gui, scripts, currentIndex) {
        if gui
            gui.Destroy()

        gui := Gui("+AlwaysOnTop", "GL管理器")
        gui.BackColor := "000000"

        x := 8
        y := 9

        for index, item in scripts {
            color := index = currentIndex ? "FF0000" : "FFFFFF"
            gui.SetFont("s9 c" color, "Microsoft YaHei")
            control := gui.AddText("x" x " y" y, item.name)
            control.GetPos(&cx, &cy, &cw, &ch)
            x += cw + 8
        }

        gui.Show("w300 h35")
        WinSetTransparent(220, gui)
        return gui
    }
}
