#Requires AutoHotkey v2.0

class GLGui {
    ; ★ GLGui.Create：所有管理器/子脚本 GUI 的统一模板。
    ; ★ AlwaysOnTop = 始终置顶。
    ; ★ 黑底 + 透明 = 统一外观。
    ; ★ NA = ★显示窗口但不激活它，避免切换子脚本后键盘焦点跑到 AHK GUI。
    ; ★ 以后新增子脚本时，通常只改标题和业务状态文字，不要重复实现 GUI 样式。
    static Create(glGuiCreateTitle := "", glGuiCreateWidth := 300, glGuiCreateHeight := 35, glGuiCreateX := unset, glGuiCreateY := unset) {
        glGuiCreateGuiObj := Gui("+AlwaysOnTop", glGuiCreateTitle)
        glGuiCreateGuiObj.BackColor := "000000"
        glGuiCreateGuiObj.SetFont("s9 cFFFFFF", "Microsoft YaHei")

        if IsSet(glGuiCreateX) && IsSet(glGuiCreateY)
            glGuiCreateGuiObj.Show("x" glGuiCreateX " y" glGuiCreateY " w" glGuiCreateWidth " h" glGuiCreateHeight " NA")
        else
            glGuiCreateGuiObj.Show("w" glGuiCreateWidth " h" glGuiCreateHeight " NA")

        WinSetTransparent(220, glGuiCreateGuiObj)
        return {gui: glGuiCreateGuiObj, controls: []}
    }

    ; ★ GLGui.UpdateList：管理器专用显示逻辑。
    ; ★ 当前索引显示红色，其余脚本显示白色。
    ; ★ 这里只负责“怎么显示”，不决定当前脚本是谁。
    static UpdateList(glGuiUpdateListState, glGuiUpdateListScripts, glGuiUpdateListCurrentIndex) {
        if !glGuiUpdateListState
            return 0

        glGuiUpdateListGuiObj := glGuiUpdateListState.gui
        glGuiUpdateListControls := glGuiUpdateListState.controls
        glGuiUpdateListX := 8
        glGuiUpdateListY := 9

        for glGuiUpdateListIndex, glGuiUpdateListItem in glGuiUpdateListScripts {
            glGuiUpdateListName := glGuiUpdateListItem.name

            if glGuiUpdateListIndex > glGuiUpdateListControls.Length {
                glGuiUpdateListGuiObj.SetFont("s9 cFFFFFF", "Microsoft YaHei")
                glGuiUpdateListControls.Push(glGuiUpdateListGuiObj.AddText("x" glGuiUpdateListX " y" glGuiUpdateListY, glGuiUpdateListName))
            }

            glGuiUpdateListControl := glGuiUpdateListControls[glGuiUpdateListIndex]
            glGuiUpdateListColor := glGuiUpdateListIndex = glGuiUpdateListCurrentIndex ? "FF0000" : "FFFFFF"

            glGuiUpdateListControl.Text := glGuiUpdateListName
            glGuiUpdateListControl.SetFont("c" glGuiUpdateListColor)
            glGuiUpdateListControl.Move(glGuiUpdateListX, glGuiUpdateListY)
            glGuiUpdateListControl.Visible := true

            glGuiUpdateListControl.GetPos(&glGuiUpdateListControlX, &glGuiUpdateListControlY, &glGuiUpdateListControlWidth, &glGuiUpdateListControlHeight)
            glGuiUpdateListX += glGuiUpdateListControlWidth + 8
        }

        Loop glGuiUpdateListControls.Length - glGuiUpdateListScripts.Length {
            glGuiUpdateListHiddenIndex := glGuiUpdateListScripts.Length + A_Index
            glGuiUpdateListControls[glGuiUpdateListHiddenIndex].Visible := false
        }

        return glGuiUpdateListState
    }
}
