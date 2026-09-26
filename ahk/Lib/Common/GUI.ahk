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
}
