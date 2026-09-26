#Requires AutoHotkey v2.0

; Action_Timer_Start - 启动或重新设置指定回调的定时器；参数：callback=定时器回调函数或函数对象，interval=执行间隔毫秒数。
Action_Timer_Start(actionTimerStartCallback, actionTimerStartInterval) {
    SetTimer(actionTimerStartCallback, actionTimerStartInterval)
    return true
}

; Action_Timer_Stop - 停止指定回调的定时器；参数：callback=需要停止的定时器回调函数或函数对象。
Action_Timer_Stop(actionTimerStopCallback) {
    SetTimer(actionTimerStopCallback, 0)
    return true
}
