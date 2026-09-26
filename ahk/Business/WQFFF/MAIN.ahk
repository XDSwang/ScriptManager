#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include ../../Lib/Common/Log.ahk
#Include ../../Lib/Input/InputControl.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

; ★ WQFFF 子脚本运行流程：
; ★ GL 启动 WQFFF\MAIN.ahk
; ★ → WQFFF_Main 初始化 GUI、运行状态、F 间隔、定时器、HWND 文件、输入保护
; ★ → 注册 *F6 / *F7
; ★ → 注册 GL 的 0xB001 退出消息
; ★ → 注册 OnExit，保证 W/Q/F 和 Timer 最终被清理
;
; ★ F6：*F6 → WQFFF_Start → Common_InputControl_StartGuard → WQFFF_Down → 启动 F 定时器 → 更新状态。
; ★ F7：*F7 → WQFFF_Stop → 停止输入保护/Timer → WQFFF_ReleaseKeys → W/Q/F 全部释放 → 待机。
; ★ 用户操作：InputGuard 检测到新增物理输入 → WQFFF_PauseForInput → 停止 Timer、释放 W/Q/F → 所有记录干扰键释放后自动 WQFFF_Start。
; ★ GL 切换 / F8：GL 发 0xB001 → WQFFF_Exit → WQFFF_Stop → 删除 HWND 文件 → ExitApp。
;
; ★ *F6 / *F7 的 * 表示：即使脚本正在持有其他修饰键，也允许控制键继续触发。

WQFFF_Main() {
    ; ★ MAIN 负责初始化和接线；W/Q/F 的实际动作与运行流程分别放在 Action / Process。
    wqfffMainGuiState := Common_GUI_Create("W Q F 控制", 300, 35, 0, 0)
    wqfffMainGui := wqfffMainGuiState.gui
    wqfffMainStatusText := wqfffMainGui.AddText("x10 y7 w280 h20 Center", "● 待机 | F6 开启")
    wqfffMainRunning := false
    wqfffMainFInterval := 100
    wqfffMainHwndFile := A_ScriptDir "\" A_ScriptName ".txt"
    wqfffMainPressTimer := (*) => WQFFF_PressFTimer(&wqfffMainRunning)

    ; ★ 控制键必须加入忽略列表，避免 F6/F7 被输入保护误判成用户干扰。
    wqfffMainControlKeys := ["F6", "F7"]
    wqfffMainInputGuard := Common_InputControl_CreateGuard(wqfffMainControlKeys)

    ; ★ 写入本脚本 GUI HWND，供 GL 管理器发送退出消息。
    WQFFF_WriteHwnd(wqfffMainHwndFile, wqfffMainGui)

    ; ★ F6 → Process：启动 W/Q 按住和 F 循环。
    Hotkey("*F6", (*) => WQFFF_Start(&wqfffMainRunning, wqfffMainFInterval, wqfffMainPressTimer, wqfffMainStatusText, wqfffMainInputGuard))

    ; ★ F7 → Process：停止 W/Q 按住和 F 循环。
    Hotkey("*F7", (*) => WQFFF_Stop(&wqfffMainRunning, wqfffMainPressTimer, wqfffMainStatusText, wqfffMainInputGuard))

    ; ★ GL 管理器发送 0xB001 后进入这里；wParam 是退出原因。
    OnMessage(0xB001, (wParam, lParam, msg, hwnd) => WQFFF_Exit(wParam, wqfffMainHwndFile, &wqfffMainRunning, wqfffMainPressTimer, wqfffMainInputGuard, wqfffMainStatusText))

    ; ★ 无论正常还是异常退出，都停止 Timer 并释放 W/Q/F。
    OnExit((*) => WQFFF_ReleaseKeys(&wqfffMainRunning, wqfffMainPressTimer, wqfffMainInputGuard))
}

WQFFF_Main()
