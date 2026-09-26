#Requires AutoHotkey v2.0

; Common_GUI_Create - 创建项目统一样式 GUI；参数：title=窗口标题，width=窗口宽度，height=窗口高度，x=可选横坐标，y=可选纵坐标。
Common_GUI_Create(commonGUICreateTitle := "", commonGUICreateWidth := 300, commonGUICreateHeight := 35, commonGUICreateX := unset, commonGUICreateY := unset) {
    commonGUICreateGuiObj := Gui("+AlwaysOnTop", commonGUICreateTitle)
    commonGUICreateGuiObj.BackColor := "000000"
    commonGUICreateGuiObj.SetFont("s9 cFFFFFF", "Microsoft YaHei")

    if IsSet(commonGUICreateX) && IsSet(commonGUICreateY)
        commonGUICreateGuiObj.Show("x" commonGUICreateX " y" commonGUICreateY " w" commonGUICreateWidth " h" commonGUICreateHeight " NA")
    else
        commonGUICreateGuiObj.Show("w" commonGUICreateWidth " h" commonGUICreateHeight " NA")

    WinSetTransparent(220, commonGUICreateGuiObj)
    return {gui: commonGUICreateGuiObj, controls: []}
}

; Common_GUI_UpdateList - 更新管理器脚本名称列表并突出当前项；参数：state=GUI 状态对象，scripts=脚本对象数组，currentIndex=当前脚本索引。
Common_GUI_UpdateList(commonGUIUpdateListState, commonGUIUpdateListScripts, commonGUIUpdateListCurrentIndex) {
    if !commonGUIUpdateListState
        return 0

    commonGUIUpdateListGuiObj := commonGUIUpdateListState.gui
    commonGUIUpdateListControls := commonGUIUpdateListState.controls
    commonGUIUpdateListX := 8
    commonGUIUpdateListY := 9

    for commonGUIUpdateListIndex, commonGUIUpdateListItem in commonGUIUpdateListScripts {
        commonGUIUpdateListName := commonGUIUpdateListItem.name

        if commonGUIUpdateListIndex > commonGUIUpdateListControls.Length {
            commonGUIUpdateListGuiObj.SetFont("s9 cFFFFFF", "Microsoft YaHei")
            commonGUIUpdateListControls.Push(commonGUIUpdateListGuiObj.AddText("x" commonGUIUpdateListX " y" commonGUIUpdateListY, commonGUIUpdateListName))
        }

        commonGUIUpdateListControl := commonGUIUpdateListControls[commonGUIUpdateListIndex]
        commonGUIUpdateListColor := commonGUIUpdateListIndex = commonGUIUpdateListCurrentIndex ? "FF0000" : "FFFFFF"

        commonGUIUpdateListControl.Text := commonGUIUpdateListName
        commonGUIUpdateListControl.SetFont("c" commonGUIUpdateListColor)
        commonGUIUpdateListControl.Move(commonGUIUpdateListX, commonGUIUpdateListY)
        commonGUIUpdateListControl.Visible := true

        commonGUIUpdateListControl.GetPos(&commonGUIUpdateListControlX, &commonGUIUpdateListControlY, &commonGUIUpdateListControlWidth, &commonGUIUpdateListControlHeight)
        commonGUIUpdateListX += commonGUIUpdateListControlWidth + 8
    }

    Loop commonGUIUpdateListControls.Length - commonGUIUpdateListScripts.Length {
        commonGUIUpdateListHiddenIndex := commonGUIUpdateListScripts.Length + A_Index
        commonGUIUpdateListControls[commonGUIUpdateListHiddenIndex].Visible := false
    }

    return commonGUIUpdateListState
}
