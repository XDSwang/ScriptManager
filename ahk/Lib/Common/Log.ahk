#Requires AutoHotkey v2.0

; GL_LogError - 记录异常/异常退出日志，每个脚本只保留最近一次记录。
GL_LogError(glLogErrorReason, glLogErrorDetail := "") {
    glLogErrorFile := A_ScriptDir "\Error.log"
    glLogErrorTime := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    glLogErrorLine := glLogErrorTime " | ERROR | " glLogErrorReason

    if glLogErrorDetail
        glLogErrorLine .= " | " glLogErrorDetail

    if FileExist(glLogErrorFile)
        FileDelete glLogErrorFile

    FileAppend(glLogErrorLine Chr(10), glLogErrorFile, "UTF-8")
    return true
}
