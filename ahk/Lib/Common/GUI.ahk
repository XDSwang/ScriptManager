; ScriptManager AHK Common GUI Library
; AutoHotkey v2

class GLGui {
    static _controls := Map()

    ; Create - 创建统一的置顶、黑底、透明GUI；参数：title=标题，width=宽度，height=高度，x/y=可选位置。
    static Create(glGuiCreateTitle := "", glGuiCreateWidth := 300, glGuiCreateHeight := 35, glGuiCreateX := unset, glGuiCreateY := unset) {
        glGuiCreateGuiObj := Gui("+AlwaysOnTop", glGuiCreateTitle)
        glGuiCreateGuiObj.BackColor := "000000"
        glGuiCreateGuiObj.SetFont("s9 cFFFFFF", "Microsoft YaHei")

        if IsSet(glGuiCreateX) && IsSet(glGuiCreateY)
            glGuiCreateGuiObj.Show("x" glGuiCreateX " y" glGuiCreateY " w" glGuiCreateWidth " h" glGuiCreateHeight)
        else
            glGuiCreateGuiObj.Show("w" glGuiCreateWidth " h" glGuiCreateHeight)

        WinSetTransparent(220, glGuiCreateGuiObj)
        return glGuiCreateGuiObj
    }

    ; UpdateList - 更新脚本名称列表和当前项颜色；参数：guiObj=GUI对象，scripts=脚本路径数组，currentIndex=当前索引。
    static UpdateList(glGuiUpdateListGuiObj, glGuiUpdateListScripts, glGuiUpdateListCurrentIndex) {
        if !glGuiUpdateListGuiObj
            return 0

        if !GLGui._controls.Has(glGuiUpdateListGuiObj.Hwnd)
            GLGui._controls[glGuiUpdateListGuiObj.Hwnd] := []

        glGuiUpdateListControls := GLGui._controls[glGuiUpdateListGuiObj.Hwnd]
        glGuiUpdateListX := 8
        glGuiUpdateListY := 9

        for glGuiUpdateListIndex, glGuiUpdateListItem in glGuiUpdateListScripts {
            SplitPath glGuiUpdateListItem, &glGuiUpdateListName

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

        return glGuiUpdateListGuiObj
    }
}
