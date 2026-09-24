#Requires AutoHotkey v2.0

;================================
; GUI_Create
; 创建基础透明置顶状态窗口
;
; 参数:
; title  窗口标题
; width  窗口宽度
; height 窗口高度
; text   初始显示文字
;
; 返回:
; {gui,status} GUI对象和文本控件
;================================
GUI_Create(title, width, height, text)
{
    gui_obj := Gui("+AlwaysOnTop", title)

    gui_obj.SetFont("s9 cFFFFFF", "Microsoft YaHei")

    status := gui_obj.AddText(
        "x10 y7 w" (width - 20) " h20 Center",
        text
    )

    gui_obj.BackColor := "000000"
    gui_obj.Show("x0 y0 w" width " h" height)

    WinSetTransparent(220, gui_obj)

    return {gui: gui_obj, status: status}
}


;================================
; GUI_SetText
; 修改GUI显示文字
;
; 参数:
; gui_state  GUI_Create返回对象
; text       新文字
;
; 返回:
; true 修改成功
;================================
GUI_SetText(gui_state, text)
{
    gui_state.status.Text := text

    return true
}
