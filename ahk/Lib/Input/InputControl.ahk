#Requires AutoHotkey v2.0

; ★ 输入保护运行流程：
; ★ F6 → Input_InputControl_StartGuard
; ★ → 记录启动基线 → 每 20ms 检查 → 发现新物理按键 → 业务暂停
; ★ → 等干扰按键全部释放 → 调用恢复回调 → 业务重新启动。
; ★ 控制键（例如 F6/F7）必须在 ignoredKeys 中。

; Input_InputControl_CreateGuard - 创建输入保护状态并登记控制键；参数：controlKeys=本脚本控制键数组。
Input_InputControl_CreateGuard(inputInputControlCreateGuardControlKeys := []) {
    inputInputControlCreateGuardState := {
        monitoring: false,
        paused: false,
        baseline: Map(),
        interferenceKeys: Map(),
        ignoredKeys: Map(),
        timer: 0
    }

    for inputInputControlCreateGuardControlKey in inputInputControlCreateGuardControlKeys {
        inputInputControlCreateGuardControlKeyVk := GetKeyVK(inputInputControlCreateGuardControlKey)
        if inputInputControlCreateGuardControlKeyVk
            inputInputControlCreateGuardState.ignoredKeys["vk" Format("{:02X}", inputInputControlCreateGuardControlKeyVk)] := true
    }

    return inputInputControlCreateGuardState
}

; Input_InputControl_StartGuard - 启动输入保护并建立物理按键基线；参数：state=状态对象，interferenceCallback=干扰回调，resumeCallback=恢复回调。
Input_InputControl_StartGuard(inputInputControlStartGuardState, inputInputControlStartGuardInterferenceCallback, inputInputControlStartGuardResumeCallback) {
    Input_InputControl_StopGuard(inputInputControlStartGuardState)

    inputInputControlStartGuardState.baseline := Input_InputControl_CapturePhysicalKeys()
    inputInputControlStartGuardState.monitoring := true
    inputInputControlStartGuardState.paused := false
    inputInputControlStartGuardState.timer := (*) => Input_InputControl_CheckGuard(inputInputControlStartGuardState, inputInputControlStartGuardInterferenceCallback, inputInputControlStartGuardResumeCallback)
    SetTimer(inputInputControlStartGuardState.timer, 20)
    return true
}

; Input_InputControl_StopGuard - 停止输入保护并清空本次运行状态；参数：state=状态对象。
Input_InputControl_StopGuard(inputInputControlStopGuardState) {
    inputInputControlStopGuardState.monitoring := false
    inputInputControlStopGuardState.paused := false

    if inputInputControlStopGuardState.timer
        SetTimer(inputInputControlStopGuardState.timer, 0)

    inputInputControlStopGuardState.timer := 0
    inputInputControlStopGuardState.baseline := Map()
    inputInputControlStopGuardState.interferenceKeys := Map()
    return true
}

; Input_InputControl_CheckGuard - 执行一次输入保护检测；参数：state=状态对象，interferenceCallback=干扰回调，resumeCallback=恢复回调。
Input_InputControl_CheckGuard(inputInputControlCheckGuardState, inputInputControlCheckGuardInterferenceCallback, inputInputControlCheckGuardResumeCallback) {
    if !inputInputControlCheckGuardState.monitoring
        return false

    inputInputControlCheckGuardCurrent := Input_InputControl_CapturePhysicalKeys()

    if !inputInputControlCheckGuardState.paused {
        inputInputControlCheckGuardNewKeys := Input_InputControl_FindNewPhysicalKeys(inputInputControlCheckGuardState.baseline, inputInputControlCheckGuardCurrent, inputInputControlCheckGuardState.ignoredKeys)

        if inputInputControlCheckGuardNewKeys.Count {
            for inputInputControlCheckGuardKey in inputInputControlCheckGuardNewKeys
                inputInputControlCheckGuardState.interferenceKeys[inputInputControlCheckGuardKey] := true

            inputInputControlCheckGuardState.paused := true
            inputInputControlCheckGuardInterferenceCallback.Call()
            return true
        }

        return false
    }

    Input_InputControl_RemoveReleasedInterferenceKeys(inputInputControlCheckGuardState.interferenceKeys, inputInputControlCheckGuardCurrent)

    if !inputInputControlCheckGuardState.interferenceKeys.Count {
        inputInputControlCheckGuardState.paused := false
        inputInputControlCheckGuardResumeCallback.Call()
        return true
    }

    return false
}

; Input_InputControl_CapturePhysicalKeys - 获取当前所有物理按下的虚拟键；参数：无。
Input_InputControl_CapturePhysicalKeys() {
    inputInputControlCapturePhysicalKeysMap := Map()

    Loop 254 {
        inputInputControlCapturePhysicalKeysVirtualKey := A_Index
        inputInputControlCapturePhysicalKeysName := "vk" Format("{:02X}", inputInputControlCapturePhysicalKeysVirtualKey)

        if GetKeyState(inputInputControlCapturePhysicalKeysName, "P")
            inputInputControlCapturePhysicalKeysMap[inputInputControlCapturePhysicalKeysName] := true
    }

    return inputInputControlCapturePhysicalKeysMap
}

; Input_InputControl_FindNewPhysicalKeys - 找出启动基线之后新增的物理按键；参数：baseline=启动基线，currentKeys=当前物理按键，ignoredKeys=忽略的控制键。
Input_InputControl_FindNewPhysicalKeys(inputInputControlFindNewPhysicalKeysBaseline, inputInputControlFindNewPhysicalKeysCurrentKeys, inputInputControlFindNewPhysicalKeysIgnoredKeys) {
    inputInputControlFindNewPhysicalKeysResult := Map()

    if Input_InputControl_IsImeOpen()
        return inputInputControlFindNewPhysicalKeysResult

    for inputInputControlFindNewPhysicalKeysKey in inputInputControlFindNewPhysicalKeysCurrentKeys {
        if inputInputControlFindNewPhysicalKeysIgnoredKeys.Has(inputInputControlFindNewPhysicalKeysKey)
            continue

        if !inputInputControlFindNewPhysicalKeysBaseline.Has(inputInputControlFindNewPhysicalKeysKey)
            inputInputControlFindNewPhysicalKeysResult[inputInputControlFindNewPhysicalKeysKey] := true
    }

    return inputInputControlFindNewPhysicalKeysResult
}

; Input_InputControl_RemoveReleasedInterferenceKeys - 删除已经物理释放的干扰键；参数：interferenceKeys=干扰键记录，currentKeys=当前物理按键。
Input_InputControl_RemoveReleasedInterferenceKeys(inputInputControlRemoveReleasedInterferenceKeysMap, inputInputControlRemoveReleasedInterferenceKeysCurrentKeys) {
    inputInputControlRemoveReleasedInterferenceKeysReleased := Map()

    for inputInputControlRemoveReleasedInterferenceKeysKey in inputInputControlRemoveReleasedInterferenceKeysMap {
        if !inputInputControlRemoveReleasedInterferenceKeysCurrentKeys.Has(inputInputControlRemoveReleasedInterferenceKeysKey) {
            inputInputControlRemoveReleasedInterferenceKeysReleased[inputInputControlRemoveReleasedInterferenceKeysKey] := true
            inputInputControlRemoveReleasedInterferenceKeysMap.Delete(inputInputControlRemoveReleasedInterferenceKeysKey)
        }
    }

    return inputInputControlRemoveReleasedInterferenceKeysReleased
}

; Input_InputControl_IsImeOpen - 判断当前活动窗口是否开启输入法；参数：无。
Input_InputControl_IsImeOpen() {
    inputInputControlIsImeOpenHwnd := WinExist("A")
    if !inputInputControlIsImeOpenHwnd
        return false

    inputInputControlIsImeOpenContext := DllCall("imm32ImmGetContext", "Ptr", inputInputControlIsImeOpenHwnd, "Ptr")
    if !inputInputControlIsImeOpenContext
        return false

    inputInputControlIsImeOpenStatus := DllCall("imm32ImmGetOpenStatus", "Ptr", inputInputControlIsImeOpenContext)
    DllCall("imm32ImmReleaseContext", "Ptr", inputInputControlIsImeOpenHwnd, "Ptr", inputInputControlIsImeOpenContext)
    return inputInputControlIsImeOpenStatus != 0
}

; Input_InputControl_KeyDown - 使用 SendEvent 按下指定按键；参数：key=AHK 按键名称。
Input_InputControl_KeyDown(inputInputControlKeyDownKey) {
    SendEvent "{" inputInputControlKeyDownKey " down}"
    return true
}

; Input_InputControl_KeyUp - 使用 SendEvent 释放指定按键；参数：key=AHK 按键名称。
Input_InputControl_KeyUp(inputInputControlKeyUpKey) {
    SendEvent "{" inputInputControlKeyUpKey " up}"
    return true
}

; Input_InputControl_ReleaseKeys - 按顺序释放传入数组中的所有按键；参数：keys=需要释放的 AHK 按键名称数组。
Input_InputControl_ReleaseKeys(inputInputControlReleaseKeysList) {
    for inputInputControlReleaseKeysKey in inputInputControlReleaseKeysList
        Input_InputControl_KeyUp(inputInputControlReleaseKeysKey)

    return true
}
