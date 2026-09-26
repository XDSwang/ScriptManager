#Requires AutoHotkey v2.0

; Manager_LoadScripts - 获取指定目录下的AHK脚本列表；参数：folder=脚本目录。
Manager_LoadScripts(managerLoadScriptsFolder) {
    managerLoadScriptsList := []

    Loop Files, managerLoadScriptsFolder "\*.ahk" {
        managerLoadScriptsList.Push({
            name: A_LoopFileName,
            path: A_LoopFileFullPath
        })
    }

    return managerLoadScriptsList
}

; Manager_GetScriptName - 获取脚本显示名称；参数：script=脚本对象。
Manager_GetScriptName(managerGetScriptNameScript) {
    return managerGetScriptNameScript.name
}
