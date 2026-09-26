#Requires AutoHotkey v2.0

; Timer_Start - 启动定时器；参数：callback=回调函数，interval=执行间隔毫秒数。
Timer_Start(timerStartCallback, timerStartInterval) {
    SetTimer(timerStartCallback, timerStartInterval)
}

; Timer_Stop - 停止定时器；参数：callback=要停止的回调函数。
Timer_Stop(timerStopCallback) {
    SetTimer(timerStopCallback, 0)
}
