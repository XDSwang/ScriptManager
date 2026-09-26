#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../../Lib/Common/GUI.ahk
#Include ../../Lib/Common/Message.ahk
#Include ../../Lib/Common/Log.ahk
#Include ../../Lib/Input/InputControl.ahk
#Include Task_Action.ahk
#Include Task_Process.ahk

; ★ SHIFT 子脚本运行流程：
; ★ GL 启动 SHIFT\MAIN.ahk
; ★ → SHIFT_Main 初始化 GUI、运行状态、HWND 文件、输入保护
; ★ → 注册 *F6 / *F7
; ★ → 注册 GL 的 0xB001 退出消息
; ★ → 注册 OnExit，保证异常结束时也释放 Shift
;
; ★ F6：*F6 → SHIFT_Start → Input_InputControl_StartGuard → SHIFT_Down → 标记运行 → 更新状态。
; ★ F7：*F7 → SHIFT_Stop → 停止输入保护 → SHIFT_ReleaseKeys → Shift 抬起 → 回到待机。
; ★ 用户操作：InputGuard 检测到新的物理按键 → SHIFT_PauseForInput → Shift 抬起 → 等记录的干扰键全部释放 → 自动再次 SHIFT_Start。
; ★ GL 切换 / F8：GL 发 0xB001 → SHIFT_Exit → SHIFT_Stop → 删除 HWND 文件 → ExitApp。
;
; ★ *F6 / *F7 的 * 表示：即使脚本正在持有其他修饰键，也允许控制键继续触发。

SHIFT_Main() {
    ; ★ MAIN 只负责初始化和接线，不直接写“按住 Shift 多久”等业务流程。
    shiftMainGuiState := Common_GUI_Create("Shift 控制", 300, 35, 0, 0)
    shiftMainGui := shiftMainGuiState.gui
    shiftMainStatusText := shiftMainGui.AddText("x10 y7 w280 h20 Center", "● 待机 | F6 开启")
    shiftMainHeld := false
    shiftMainHwndFile := A_ScriptDir "\" A_ScriptName ".txt"

    ; ★ 控制键必须加入忽略列表，否则输入保护可能把 F6/F7 自己当成用户干扰。
    shiftMainControlKeys := ["F6", "F7"]
    shiftMainInputGuard := Input_InputControl_CreateGuard(shiftMainControlKeys)

    ; ★ 写入本脚本 GUI 的 HWND，供 GL 管理器通过 .txt 找到本脚本并发送退出消息。
    SHIFT_WriteHwnd(shiftMainHwndFile, shiftMainGui)

    ; ★ F6 → Process：启动业务流程。
    Hotkey("*F6", (*) => SHIFT_Start(&shiftMainHeld, shiftMainStatusText, shiftMainInputGuard))

    ; ★ F7 → Process：停止业务流程。
    Hotkey("*F7", (*) => SHIFT_Stop(&shiftMainHeld, shiftMainStatusText, shiftMainInputGuard))

    ; ★ GL 管理器发送 0xB001 后进入这里；wParam 是 GL 提供的退出原因。
    OnMessage(0xB001, (wParam, lParam, msg, hwnd) => SHIFT_Exit(wParam, shiftMainHwndFile, &shiftMainHeld, shiftMainInputGuard, shiftMainStatusText))

    ; ★ 无论正常退出还是异常退出，都最终释放 Shift，避免按键卡住。
    OnExit((*) => SHIFT_ReleaseKeys(&shiftMainHeld, shiftMainInputGuard))
}

SHIFT_Main()
