#Requires AutoHotkey v2.0

; Common_Log_Error - 覆盖式记录本脚本最近一次错误/异常退出信息；参数：reason=错误或退出原因，detail=附加说明，可省略。
Common_Log_Error(commonLogErrorReason, commonLogErrorDetail := "") {
    commonLogErrorFile := A_ScriptDir "\Error.log"
    commonLogErrorTime := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    commonLogErrorLine := commonLogErrorTime " | ERROR | " commonLogErrorReason

    if commonLogErrorDetail
        commonLogErrorLine .= " | " commonLogErrorDetail

    if FileExist(commonLogErrorFile)
        FileDelete commonLogErrorFile

    FileAppend(commonLogErrorLine Chr(10), commonLogErrorFile, "UTF-8")
    return true
}
