#Requires AutoHotkey v2.0

; ReleaseShift - 释放Shift键；参数：无。
ReleaseShift(*) {
    Send "{Shift up}"
}

; ReleaseWQ - 释放W和Q键；参数：无。
ReleaseWQ(*) {
    Send "{w up}"
    Send "{q up}"
}

; ReleaseAll - 释放Shift、W、Q键；参数：无。
ReleaseAll(*) {
    Send "{Shift up}"
    Send "{w up}"
    Send "{q up}"
}