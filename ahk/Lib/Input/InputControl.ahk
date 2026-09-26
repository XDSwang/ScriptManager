#Requires AutoHotkey v2.0

; ★ 输入保护运行流程：
; ★ F6 → Input_StartGuard
; ★ → 记录“启动这一刻已经按住”的物理按键作为 baseline
; ★ → 每 20ms 检查一次
; ★ → 发现 baseline 之外的新物理按键 → 记录干扰键 → 调用业务暂停回调
; ★ → 业务停止自动操作
; ★ → 持续等待已经记录的干扰键全部物理释放
; ★ → 全部释放后调用 resumeCallback
; ★ → 业务从 Start 流程重新开始。
;
; ★ 控制键（例如 F6/F7）必须在 ignoredKeys 中，否则控制键本身可能被当成用户输入。
; ★ 输入保护只负责“发现输入并管理状态”，具体暂停/恢复动作由业务 Process 回调决定。

; ★ 创建输入保护状态对象。
Input_CreateGuard(inputCreateGuardControlKeys := []) {
    inputCreateGuardState := {
        monitoring: false,
        paused: false,
        baseline: Map(),
        interferenceKeys: Map(),
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

; ★ F6 启动输入保护：先清理旧状态，再记录启动基线，然后开始 20ms 定时检测。
Input_StartGuard(inputStartGuardState, inputStartGuardInterferenceCallback, inputStartGuardResumeCallback) {
    Input_StopGuard(inputStartGuardState)

    inputStartGuardState.baseline := Input_CapturePhysicalKeys()
    inputStartGuardState.monitoring := true
    inputStartGuardState.paused := false
    inputStartGuardState.timer := (*) => Input_CheckGuard(inputStartGuardState, inputStartGuardInterferenceCallback, inputStartGuardResumeCallback)
    SetTimer(inputStartGuardState.timer, 20)
    return true
}

; ★ 停止输入保护并清空本次运行的基线/干扰键记录。
Input_StopGuard(inputStopGuardState) {
    inputStopGuardState.monitoring := false
    inputStopGuardState.paused := false

    if inputStopGuardState.timer
        SetTimer(inputStopGuardState.timer, 0)

    inputStopGuardState.timer := 0
    inputStopGuardState.baseline := Map()
    inputStopGuardState.interferenceKeys := Map()
    return true
}

; ★ 输入保护的核心检测流程。
Input_CheckGuard(inputCheckGuardState, inputCheckGuardInterferenceCallback, inputCheckGuardResumeCallback) {
    if !inputCheckGuardState.monitoring
        return false

    inputCheckGuardCurrent := Input_CapturePhysicalKeys()

    if !inputCheckGuardState.paused {
        inputCheckGuardNewKeys := Input_FindNewPhysicalKeys(inputCheckGuardState.baseline, inputCheckGuardCurrent, inputCheckGuardState.ignoredKeys)

        if inputCheckGuardNewKeys.Count {
            ; ★ 一旦发现用户新增输入，必须把实际干扰键记录下来，后面按“这些键全部释放”判断恢复时机。
            for inputCheckGuardKey in inputCheckGuardNewKeys
                inputCheckGuardState.interferenceKeys[inputCheckGuardKey] := true

            inputCheckGuardState.paused := true
            inputCheckGuardInterferenceCallback.Call()
            return true
        }

        return false
    }

    ; ★ 已暂停时不再继续发现新的干扰键，只负责等待已经记录的干扰键全部抬起。
    inputCheckGuardReleasedKeys := Input_RemoveReleasedInterferenceKeys(inputCheckGuardState.interferenceKeys, inputCheckGuardCurrent)

    if !inputCheckGuardState.interferenceKeys.Count {
        inputCheckGuardState.paused := false
        inputCheckGuardResumeCallback.Call()
        return true
    }

    return inputCheckGuardReleasedKeys.Count > 0
}

; ★ 读取当前所有物理按下的虚拟键；使用物理状态而不是逻辑状态，避免脚本自己的 SendEvent 被误判为用户输入。
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

; ★ 将当前按键与启动基线比较，只找“启动之后新增”的物理按键。
Input_FindNewPhysicalKeys(inputFindNewPhysicalKeysBaseline, inputFindNewPhysicalKeysCurrentKeys, inputFindNewPhysicalKeysIgnoredKeys) {
    inputFindNewPhysicalKeysResult := Map()

    if Input_IsImeOpen()
        return inputFindNewPhysicalKeysResult

    for inputFindNewPhysicalKeysKey in inputFindNewPhysicalKeysCurrentKeys {
        if inputFindNewPhysicalKeysIgnoredKeys.Has(inputFindNewPhysicalKeysKey)
            continue

        if !inputFindNewPhysicalKeysBaseline.Has(inputFindNewPhysicalKeysKey)
            inputFindNewPhysicalKeysResult[inputFindNewPhysicalKeysKey] := true
    }

    return inputFindNewPhysicalKeysResult
}

; ★ 从干扰键记录中删除已经物理释放的键。
Input_RemoveReleasedInterferenceKeys(inputRemoveReleasedInterferenceKeysMap, inputRemoveReleasedInterferenceKeysCurrentKeys) {
    inputRemoveReleasedInterferenceKeysReleased := Map()

    for inputRemoveReleasedInterferenceKeysKey in inputRemoveReleasedInterferenceKeysMap {
        if !inputRemoveReleasedInterferenceKeysCurrentKeys.Has(inputRemoveReleasedInterferenceKeysKey) {
            inputRemoveReleasedInterferenceKeysReleased[inputRemoveReleasedInterferenceKeysKey] := true
            inputRemoveReleasedInterferenceKeysMap.Delete(inputRemoveReleasedInterferenceKeysKey)
        }
    }

    return inputRemoveReleasedInterferenceKeysReleased
}

; ★ 如果当前活动窗口开启输入法，则暂时不把输入法相关状态当作用户干扰输入。
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

; ★ 通用键盘能力：真正发送指定键按下/释放。
Input_KeyDown(inputKeyDownKey) {
    SendEvent "{" inputKeyDownKey " down}"
    return true
}

Input_KeyUp(inputKeyUpKey) {
    SendEvent "{" inputKeyUpKey " up}"
    return true
}

Input_ReleaseKeys(inputReleaseKeysList) {
    for inputReleaseKeysKey in inputReleaseKeysList
        Input_KeyUp(inputReleaseKeysKey)

    return true
}
