#Requires AutoHotkey v2.0

; GL_LogError - 记录异常/异常退出日志。
GL_LogError(glLogErrorReason, glLogErrorDetail := "") {
    glLogErrorFile := A_ScriptDir "\Error.log"
    glLogErrorTime := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    glLogErrorLine := glLogErrorTime " | ERROR | " glLogErrorReason

    if glLogErrorDetail
        glLogErrorLine .= " | " glLogErrorDetail

    FileAppend(glLogErrorLine Chr(10), glLogErrorFile, "UTF-8")
    return true
}
