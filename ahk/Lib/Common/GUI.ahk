#Requires AutoHotkey v2.0

class GLGui {
    ; GLGui.Create - 创建统一的置顶、黑底、透明 GUI；参数：title=窗口标题，width=窗口宽度，height=窗口高度，x=可选横坐标，y=可选纵坐标。
    static Create(glGuiCreateTitle := "", glGuiCreateWidth := 300, glGuiCreateHeight := 35, glGuiCreateX := unset, glGuiCreateY := unset) {
        glGuiCreateGuiObj := Gui("+AlwaysOnTop", glGuiCreateTitle)
        glGuiCreateGuiObj.BackColor := "000000"
        glGuiCreateGuiObj.SetFont("s9 cFFFFFF", "Microsoft YaHei")

        if IsSet(glGuiCreateX) && IsSet(glGuiCreateY)
            glGuiCreateGuiObj.Show("x" glGuiCreateX " y" glGuiCreateY " w" glGuiCreateWidth " h" glGuiCreateHeight)
        else
            glGuiCreateGuiObj.Show("w" glGuiCreateWidth " h" glGuiCreateHeight)

        WinSetTransparent(220, glGuiCreateGuiObj)
        return {gui: glGuiCreateGuiObj, controls: []}
    }

    ; GLGui.UpdateList - 更新 GUI 中的脚本名称列表并设置当前项颜色；参数：state=GLGui.Create() 返回状态对象，scripts=脚本对象数组，currentIndex=当前脚本索引。
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
