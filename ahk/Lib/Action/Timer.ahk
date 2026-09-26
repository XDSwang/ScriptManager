#Requires AutoHotkey v2.0

; Timer_Start - 启动或重新设置指定回调的定时器；参数：callback=定时器回调函数或函数对象，interval=执行间隔毫秒数。
Timer_Start(timerStartCallback, timerStartInterval) {
    SetTimer(timerStartCallback, timerStartInterval)
    return true
}

; Timer_Stop - 停止指定回调的定时器；参数：callback=需要停止的定时器回调函数或函数对象。
Timer_Stop(timerStopCallback) {
    SetTimer(timerStopCallback, 0)
    return true
}
