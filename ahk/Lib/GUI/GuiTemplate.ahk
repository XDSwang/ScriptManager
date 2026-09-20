#Requires AutoHotkey v2.0

Gui_Create(title,width,height,text)
{
    gui_obj := Gui("+AlwaysOnTop", title)

    gui_obj.SetFont("s9 cFFFFFF","Microsoft YaHei")

    status := gui_obj.AddText(
        "x10 y7 w" (width-20) " h20 Center",
        text
    )

    gui_obj.BackColor := "000000"
    gui_obj.Show("x0 y0 w" width " h" height)

    WinSetTransparent(220, gui_obj)

    return {gui:gui_obj,status:status}
}
