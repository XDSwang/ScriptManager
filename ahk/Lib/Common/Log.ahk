#Requires AutoHotkey v2.0

; GL_LogError - 覆盖式记录本脚本最近一次错误/异常退出信息；参数：reason=错误或退出原因，detail=附加说明，可省略。
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
