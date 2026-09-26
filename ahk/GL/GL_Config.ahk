#Requires AutoHotkey v2.0

; ★ 这里是“配置入口”。
; ★ 如果以后管理脚本的根目录发生变化，优先修改这里，不要去改 GL_Process 的扫描逻辑。
; ★ GL_Process 只负责“怎么扫描”，GL_Config 负责“扫描哪里”。
GL_Config_GetManagedFolder() {
    return A_ScriptDir "\..\Business"
}
