#Requires AutoHotkey v2.0

; Input_CreateGuard - 创建输入干扰检测状态对象；参数：controlKeys=本脚本用于启动、暂停、退出等控制功能的按键名称数组，可省略。
Input_CreateGuard(inputCreateGuardControlKeys := []) {
    inputCreateGuardState := {
        monitoring: false,
        paused: false,
        baseline: Map(),
        ignoredKeys: Map(),
        timer: 0
    }

    for inputCreateGuardControlKey in inputCreateGuardControlKeys {
        inputCreateGuardControlKeyVk := GetKeyVK(inputCreateGuardControlKey)
        if inputCreateGuardControlKeyVk
            inputCreateGuardState.ignoredKeys["vk" Format("{:02X}", inputCreateGuardControlKeyVk)] := true
    }

    return inputCreateGuardState
}

; Input_StartGuard - 记录启动瞬间的物理按键并开始检测新增用户输入；参数：state=输入检测状态对象，interferenceCallback=检测到新增物理输入时调用的回调，resumeCallback=新增输入消失后调用的恢复回调。
Input_StartGuard(inputStartGuardState, inputStartGuardInterferenceCallback, inputStartGuardResumeCallback) {
    Input_StopGuard(inputStartGuardState)

    inputStartGuardState.baseline := Input_CapturePhysicalKeys()
    inputStartGuardState.monitoring := true
    inputStartGuardState.paused := false
    inputStartGuardState.timer := (*) => Input_CheckGuard(inputStartGuardState, inputStartGuardInterferenceCallback, inputStartGuardResumeCallback)
    SetTimer(inputStartGuardState.timer, 20)
    return true
}

; Input_StopGuard - 停止输入干扰检测并清空检测状态；参数：state=输入检测状态对象。
Input_StopGuard(inputStopGuardState) {
    inputStopGuardState.monitoring := false
    inputStopGuardState.paused := false

    if inputStopGuardState.timer
        SetTimer(inputStopGuardState.timer, 0)

    inputStopGuardState.timer := 0
    inputStopGuardState.baseline := Map()
    return true
}

; Input_CheckGuard - 按当前状态检查是否出现新的物理输入，并触发暂停或恢复回调；参数：state=输入检测状态对象，interferenceCallback=检测到新增输入时的回调，resumeCallback=新增输入消失后的恢复回调。
Input_CheckGuard(inputCheckGuardState, inputCheckGuardInterferenceCallback, inputCheckGuardResumeCallback) {
    if !inputCheckGuardState.monitoring
        return false

    inputCheckGuardNewInput := Input_FindNewPhysicalInput(inputCheckGuardState.baseline, inputCheckGuardState.ignoredKeys)

    if !inputCheckGuardState.paused {
        if inputCheckGuardNewInput {
            inputCheckGuardState.paused := true
            inputCheckGuardInterferenceCallback.Call()
        }
        return inputCheckGuardNewInput
    }

    if !inputCheckGuardNewInput {
        inputCheckGuardState.paused := false
        inputCheckGuardResumeCallback.Call()
        return true
    }

    return false
}

; Input_CapturePhysicalKeys - 获取当前所有处于物理按下状态的虚拟键；参数：无。
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

; Input_FindNewPhysicalInput - 根据启动基线查找新增物理输入，并忽略调用方声明的控制键；参数：baseline=启动时的物理按键基线，ignoredKeys=需要忽略的虚拟键名称 Map，可省略。
Input_FindNewPhysicalInput(inputFindNewPhysicalInputBaseline, inputFindNewPhysicalInputIgnoredKeys := unset) {
    if Input_IsImeOpen()
        return false

    inputFindNewPhysicalInputCurrent := Input_CapturePhysicalKeys()
    inputFindNewPhysicalInputReleasedKeys := []

    for inputFindNewPhysicalInputKey in inputFindNewPhysicalInputBaseline {
        if !inputFindNewPhysicalInputCurrent.Has(inputFindNewPhysicalInputKey)
            inputFindNewPhysicalInputReleasedKeys.Push(inputFindNewPhysicalInputKey)
    }

    for inputFindNewPhysicalInputKey in inputFindNewPhysicalInputReleasedKeys
        inputFindNewPhysicalInputBaseline.Delete(inputFindNewPhysicalInputKey)

    if !IsSet(inputFindNewPhysicalInputIgnoredKeys)
        inputFindNewPhysicalInputIgnoredKeys := Map()

    for inputFindNewPhysicalInputKey in inputFindNewPhysicalInputCurrent {
        if inputFindNewPhysicalInputIgnoredKeys.Has(inputFindNewPhysicalInputKey)
            continue

        if !inputFindNewPhysicalInputBaseline.Has(inputFindNewPhysicalInputKey)
            return true
    }

    return false
}

; Input_IsImeOpen - 判断当前活动窗口是否处于开启输入法状态；参数：无。
Input_IsImeOpen() {
    inputIsImeOpenHwnd := WinExist("A")
    if !inputIsImeOpenHwnd
        return false

    inputIsImeOpenContext := DllCall("imm32\ImmGetContext", "Ptr", inputIsImeOpenHwnd, "Ptr")
    if !inputIsImeOpenContext
        return false

    inputIsImeOpenStatus := DllCall("imm32\ImmGetOpenStatus", "Ptr", inputIsImeOpenContext)
    DllCall("imm32\ImmReleaseContext", "Ptr", inputIsImeOpenHwnd, "Ptr", inputIsImeOpenContext)
    return inputIsImeOpenStatus != 0
}

; Input_KeyDown - 通过 SendEvent 按下指定按键；参数：key=AHK 按键名称。
Input_KeyDown(inputKeyDownKey) {
    SendEvent "{" inputKeyDownKey " down}"
    return true
}

; Input_KeyUp - 通过 SendEvent 释放指定按键；参数：key=AHK 按键名称。
Input_KeyUp(inputKeyUpKey) {
    SendEvent "{" inputKeyUpKey " up}"
    return true
}

; Input_ReleaseKeys - 按顺序释放传入按键数组中的所有按键；参数：keys=需要释放的 AHK 按键名称数组。
Input_ReleaseKeys(inputReleaseKeysList) {
    for inputReleaseKeysKey in inputReleaseKeysList
        Input_KeyUp(inputReleaseKeysKey)

    return true
}
