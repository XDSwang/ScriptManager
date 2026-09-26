#Requires AutoHotkey v2.0

; ★ GL_LoadScripts：启动阶段扫描所有可管理的子脚本。
; ★ 规则：每个直接子目录只要存在 MAIN.ahk，就视为一个可管理业务。
; ★ 返回的数据同时保存“显示名称”和“启动路径”：
; ★ name = GUI 上显示的业务目录名；
; ★ path = 真正运行的 MAIN.ahk 完整路径。
GL_LoadScripts(glLoadScriptsFolder) {
    glLoadScriptsList := []

    if !DirExist(glLoadScriptsFolder)
        return glLoadScriptsList

    Loop Files glLoadScriptsFolder "\*", "D" {
        glLoadScriptsMainFile := A_LoopFileFullPath "\MAIN.ahk"

        if FileExist(glLoadScriptsMainFile) {
            glLoadScriptsScriptName := A_LoopFileName
            glLoadScriptsList.Push({
                name: glLoadScriptsScriptName,
                path: glLoadScriptsMainFile
            })
        }
    }

    return GL_SortScripts(glLoadScriptsList)
}

; ★ GL_SortScripts：只负责排序，不负责启动、不负责 GUI。
; ★ 以后新增脚本时不需要在这里登记名称；只要目录中有 MAIN.ahk，管理器就会自动发现。
GL_SortScripts(glSortScriptsList) {
    Loop glSortScriptsList.Length {
        Loop glSortScriptsList.Length - 1 {
            if (StrCompare(glSortScriptsList[A_Index].name, glSortScriptsList[A_Index + 1].name) > 0) {
                glSortScriptsTemp := glSortScriptsList[A_Index]
                glSortScriptsList[A_Index] := glSortScriptsList[A_Index + 1]
                glSortScriptsList[A_Index + 1] := glSortScriptsTemp
            }
        }
    }

    return glSortScriptsList
}
