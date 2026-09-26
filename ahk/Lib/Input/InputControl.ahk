#Requires AutoHotkey v2.0

; Input_CreateGuard - 创建输入干扰检测状态。
Input_CreateGuard() {
    inputCreateGuardState := {
        monitoring: false,
        paused: false,
        baseline: Map(),
        timer: 0
    }
    return inputCreateGuardState
}

; Input_StartGuard - 记录启动时已按下的物理按键，并开始检测新的用户输入。
Input_StartGuard(inputStartGuardState, inputStartGuardInterferenceCallback, inputStartGuardResumeCallback) {
    Input_StopGuard(inputStartGuardState)

    inputStartGuardState.baseline := Input_CapturePhysicalKeys()
    inputStartGuardState.monitoring := true
    inputStartGuardState.paused := false
    inputStartGuardState.timer := (*) => Input_CheckGuard(inputStartGuardState, inputStartGuardInterferenceCallback, inputStartGuardResumeCallback)
    SetTimer(inputStartGuardState.timer, 20)
    return true
}

; Input_StopGuard - 停止输入干扰检测。
Input_StopGuard(inputStopGuardState) {
    inputStopGuardState.monitoring := false
    inputStopGuardState.paused := false

    if inputStopGuardState.timer
        SetTimer(inputStopGuardState.timer, 0)

    inputStopGuardState.timer := 0
    inputStopGuardState.baseline := Map()
    return true
}

; Input_CheckGuard - 检测启动快照之外的新物理输入；脚本 SendEvent 不会被物理状态检测误判。
Input_CheckGuard(inputCheckGuardState, inputCheckGuardInterferenceCallback, inputCheckGuardResumeCallback) {
    if !inputCheckGuardState.monitoring
        return

    inputCheckGuardNewInput := Input_FindNewPhysicalInput(inputCheckGuardState.baseline)

    if !inputCheckGuardState.paused {
        if inputCheckGuardNewInput {
            inputCheckGuardState.paused := true
            inputCheckGuardInterferenceCallback.Call()
        }
        return
    }

    if !inputCheckGuardNewInput {
        inputCheckGuardState.paused := false
        inputCheckGuardResumeCallback.Call()
    }
}

; Input_CapturePhysicalKeys - 获取当前所有处于物理按下状态的虚拟键。
Input_CapturePhysicalKeys() {
    inputCapturePhysicalKeysMap := Map()

    Loop 254 {
        inputCapturePhysicalKeysVirtualKey := A_Index
        inputCapturePhysicalKeysName := "vk" Format("{:02X}", inputCapturePhysicalKeysVirtualKey)

        if GetKeyState(inputCapturePhysicalKeysName, "P")
            inputCapturePhysicalKeysMap[inputCapturePhysicalKeysName] := true
    }

    return inputCapturePhysicalKeysMap
}

; Input_FindNewPhysicalInput - 找出启动快照之后新增的物理输入。
Input_FindNewPhysicalInput(inputFindNewPhysicalInputBaseline) {
    inputFindNewPhysicalInputCurrent := Input_CapturePhysicalKeys()
    inputFindNewPhysicalInputReleasedKeys := []

    for inputFindNewPhysicalInputKey in inputFindNewPhysicalInputBaseline {
        if !inputFindNewPhysicalInputCurrent.Has(inputFindNewPhysicalInputKey)
            inputFindNewPhysicalInputReleasedKeys.Push(inputFindNewPhysicalInputKey)
    }

    for inputFindNewPhysicalInputKey in inputFindNewPhysicalInputReleasedKeys
        inputFindNewPhysicalInputBaseline.Delete(inputFindNewPhysicalInputKey)

    for inputFindNewPhysicalInputKey in inputFindNewPhysicalInputCurrent {
        if !inputFindNewPhysicalInputBaseline.Has(inputFindNewPhysicalInputKey)
            return true
    }

    return false
}

; Input_KeyDown - 按下指定按键；参数：key=按键名称。
Input_KeyDown(inputKeyDownKey) {
    SendEvent "{" inputKeyDownKey " down}"
    return true
}

; Input_KeyUp - 释放指定按键；参数：key=按键名称。
Input_KeyUp(inputKeyUpKey) {
    SendEvent "{" inputKeyUpKey " up}"
    return true
}

; Input_ReleaseKeys - 释放按键数组中的所有按键；参数：keys=按键数组。
Input_ReleaseKeys(inputReleaseKeysList) {
    for inputReleaseKeysKey in inputReleaseKeysList
        Input_KeyUp(inputReleaseKeysKey)

    return true
}
