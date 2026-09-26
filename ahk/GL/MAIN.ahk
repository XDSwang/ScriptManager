#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook

#Include ../Lib/Common/GUI.ahk
#Include ../Lib/Common/Message.ahk
#Include ../Lib/Common/Log.ahk
#Include GL_Config.ahk
#Include GL_Process.ahk
#Include GL_Action.ahk

; ★ GL 管理器运行流程：
; ★ GL MAIN 启动
; ★ → 读取受管理的 Business 目录
; ★ → 扫描所有包含 MAIN.ahk 的子目录并按名称排序
; ★ → 创建 GL 管理器 GUI
; ★ → 启动第 1 个子脚本
; ★ → 注册 Ctrl+Up / Ctrl+Down 切换
; ★ → 注册 F8 退出管理器
; ★ → 之后进入等待状态，真正的业务运行由各子脚本自己的 F6/F7 控制。
;
; ★ Ctrl+Up / Ctrl+Down：
; ★ 当前子脚本退出 → 等待当前子脚本句柄文件删除 → 计算下一个/上一个 → 启动新的 MAIN.ahk → 刷新管理器 GUI。
;
; ★ F8：
; ★ 当前子脚本退出 → 等待句柄文件删除 → 写入退出日志 → GL 管理器 ExitApp。
;
; ★ 热键中的 * 表示“允许额外修饰键存在时仍触发”。
; ★ 例如子脚本正在模拟按住 Shift/Ctrl/Alt/Win 时，*^Up / *^Down 仍应能执行切换，*F8 仍应能执行退出。

GL_Main(glMainScriptFolder) {
    ; 入口只负责“接线”：加载脚本、初始化状态、创建 GUI、启动第一个脚本、注册管理器热键。
    glMainScripts := GL_LoadScripts(glMainScriptFolder)
    glMainCurrentIndex := 0
    glMainManagerGuiState := GL_Show()

    ; ★ 管理器启动后的第一条实际运行链：GL_StartFirst → Run(第一个子脚本 MAIN.ahk)。
    GL_StartFirst(glMainScripts, &glMainCurrentIndex, glMainManagerGuiState)

    ; ★ Ctrl+Up：切换到下一个子脚本。
    Hotkey("*^Up", (*) => GL_SwitchScript(1, glMainScripts, &glMainCurrentIndex, glMainManagerGuiState))

    ; ★ Ctrl+Down：切换到上一个子脚本。
    Hotkey("*^Down", (*) => GL_SwitchScript(-1, glMainScripts, &glMainCurrentIndex, glMainManagerGuiState))

    ; ★ F8：退出管理器。先让当前子脚本完整退出，再退出 GL。
    Hotkey("*F8", (*) => GL_ExitManager(glMainScripts, glMainCurrentIndex))
}

GL_Main(GL_GetManagedFolder())
