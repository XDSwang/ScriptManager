#Requires AutoHotkey v2.0

; Timer helper functions

Timer_Start(callback, interval) {
    SetTimer(callback, interval)
}

Timer_Stop(callback) {
    SetTimer(callback, 0)
}
