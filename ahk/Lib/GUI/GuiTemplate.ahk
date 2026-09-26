#Requires AutoHotkey v2.0

; GUI_Create - 创建基础透明置顶状态窗口；参数：title=标题，width=宽度，height=高度，text=初始文字。
GUI_Create(guiCreateTitle, guiCreateWidth, guiCreateHeight, guiCreateText) {
    guiCreateGuiObj := Gui("+AlwaysOnTop", guiCreateTitle)
    guiCreateGuiObj.SetFont("s9 cFFFFFF", "Microsoft YaHei")
    guiCreateStatus := guiCreateGuiObj.AddText(
        "x10 y7 w" (guiCreateWidth - 20) " h20 Center",
        guiCreateText
    )
    guiCreateGuiObj.BackColor := "000000"
    guiCreateGuiObj.Show("x0 y0 w" guiCreateWidth " h" guiCreateHeight)
    WinSetTransparent(220, guiCreateGuiObj)
    return {gui: guiCreateGuiObj, status: guiCreateStatus}
}

; GUI_SetText - 修改GUI显示文字；参数：gui_state=GUI_Create返回对象，text=新文字。
GUI_SetText(guiSetTextState, guiSetTextValue) {
    guiSetTextState.status.Text := guiSetTextValue
    return true
}
