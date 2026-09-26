#Requires AutoHotkey v2.0

; ★ 输入保护运行流程：
; ★ F6 → Common_InputControl_StartGuard
; ★ → 记录启动基线 → 每 20ms 检查 → 发现新物理按键 → 业务暂停
; ★ → 等干扰按键全部释放 → 调用恢复回调 → 业务重新启动。
; ★ 控制键（例如 F6/F7）必须在 ignoredKeys 中。

; Common_InputControl_CreateGuard - 创建输入保护状态并登记控制键；参数：controlKeys=本脚本控制键数组。
Common_InputControl_CreateGuard(commonInputControlCreateGuardControlKeys := []) {
    commonInputControlCreateGuardState := {
        monitoring: false,
        paused: false,
        baseline: Map(),
        interferenceKeys: Map(),
        ignoredKeys: Map(),
        timer: 0
    }

    for commonInputControlCreateGuardControlKey in commonInputControlCreateGuardControlKeys {
        commonInputControlCreateGuardControlKeyVk := GetKeyVK(commonInputControlCreateGuardControlKey)
        if commonInputControlCreateGuardControlKeyVk
            commonInputControlCreateGuardState.ignoredKeys["vk" Format("{:02X}", commonInputControlCreateGuardControlKeyVk)] := true
    }

    return commonInputControlCreateGuardState
}

; Common_InputControl_StartGuard - 启动输入保护并建立物理按键基线；参数：state=状态对象，interferenceCallback=干扰回调，resumeCallback=恢复回调。
Common_InputControl_StartGuard(commonInputControlStartGuardState, commonInputControlStartGuardInterferenceCallback, commonInputControlStartGuardResumeCallback) {
    Common_InputControl_StopGuard(commonInputControlStartGuardState)

    commonInputControlStartGuardState.baseline := Common_InputControl_CapturePhysicalKeys()
    commonInputControlStartGuardState.monitoring := true
    commonInputControlStartGuardState.paused := false
    commonInputControlStartGuardState.timer := (*) => Common_InputControl_CheckGuard(commonInputControlStartGuardState, commonInputControlStartGuardInterferenceCallback, commonInputControlStartGuardResumeCallback)
    SetTimer(commonInputControlStartGuardState.timer, 20)
    return true
}

; Common_InputControl_StopGuard - 停止输入保护并清空本次运行状态；参数：state=状态对象。
Common_InputControl_StopGuard(commonInputControlStopGuardState) {
    commonInputControlStopGuardState.monitoring := false
    commonInputControlStopGuardState.paused := false

    if commonInputControlStopGuardState.timer
        SetTimer(commonInputControlStopGuardState.timer, 0)

    commonInputControlStopGuardState.timer := 0
    commonInputControlStopGuardState.baseline := Map()
    commonInputControlStopGuardState.interferenceKeys := Map()
    return true
}

; Common_InputControl_CheckGuard - 执行一次输入保护检测；参数：state=状态对象，interferenceCallback=干扰回调，resumeCallback=恢复回调。
Common_InputControl_CheckGuard(commonInputControlCheckGuardState, commonInputControlCheckGuardInterferenceCallback, commonInputControlCheckGuardResumeCallback) {
    if !commonInputControlCheckGuardState.monitoring
        return false

    commonInputControlCheckGuardCurrent := Common_InputControl_CapturePhysicalKeys()

    if !commonInputControlCheckGuardState.paused {
        commonInputControlCheckGuardNewKeys := Common_InputControl_FindNewPhysicalKeys(commonInputControlCheckGuardState.baseline, commonInputControlCheckGuardCurrent, commonInputControlCheckGuardState.ignoredKeys)

        if commonInputControlCheckGuardNewKeys.Count {
            for commonInputControlCheckGuardKey in commonInputControlCheckGuardNewKeys
                commonInputControlCheckGuardState.interferenceKeys[commonInputControlCheckGuardKey] := true

            commonInputControlCheckGuardState.paused := true
            commonInputControlCheckGuardInterferenceCallback.Call()
            return true
        }

        return false
    }

    Common_InputControl_RemoveReleasedInterferenceKeys(commonInputControlCheckGuardState.interferenceKeys, commonInputControlCheckGuardCurrent)

    if !commonInputControlCheckGuardState.interferenceKeys.Count {
        commonInputControlCheckGuardState.paused := false
        commonInputControlCheckGuardResumeCallback.Call()
        return true
    }

    return false
}

; Common_InputControl_CapturePhysicalKeys - 获取当前所有物理按下的虚拟键；参数：无。
Common_InputControl_CapturePhysicalKeys() {
    commonInputControlCapturePhysicalKeysMap := Map()

    Loop 254 {
        commonInputControlCapturePhysicalKeysVirtualKey := A_Index
        commonInputControlCapturePhysicalKeysName := "vk" Format("{:02X}", commonInputControlCapturePhysicalKeysVirtualKey)

        if GetKeyState(commonInputControlCapturePhysicalKeysName, "P")
            commonInputControlCapturePhysicalKeysMap[commonInputControlCapturePhysicalKeysName] := true
    }

    return commonInputControlCapturePhysicalKeysMap
}

; Common_InputControl_FindNewPhysicalKeys - 找出启动基线之后新增的物理按键；参数：baseline=启动基线，currentKeys=当前物理按键，ignoredKeys=忽略的控制键。
Common_InputControl_FindNewPhysicalKeys(commonInputControlFindNewPhysicalKeysBaseline, commonInputControlFindNewPhysicalKeysCurrentKeys, commonInputControlFindNewPhysicalKeysIgnoredKeys) {
    commonInputControlFindNewPhysicalKeysResult := Map()

    if Common_InputControl_IsImeOpen()
        return commonInputControlFindNewPhysicalKeysResult

    for commonInputControlFindNewPhysicalKeysKey in commonInputControlFindNewPhysicalKeysCurrentKeys {
        if commonInputControlFindNewPhysicalKeysIgnoredKeys.Has(commonInputControlFindNewPhysicalKeysKey)
            continue

        if !commonInputControlFindNewPhysicalKeysBaseline.Has(commonInputControlFindNewPhysicalKeysKey)
            commonInputControlFindNewPhysicalKeysResult[commonInputControlFindNewPhysicalKeysKey] := true
    }

    return commonInputControlFindNewPhysicalKeysResult
}

; Common_InputControl_RemoveReleasedInterferenceKeys - 删除已经物理释放的干扰键；参数：interferenceKeys=干扰键记录，currentKeys=当前物理按键。
Common_InputControl_RemoveReleasedInterferenceKeys(commonInputControlRemoveReleasedInterferenceKeysMap, commonInputControlRemoveReleasedInterferenceKeysCurrentKeys) {
    commonInputControlRemoveReleasedInterferenceKeysReleased := Map()

    for commonInputControlRemoveReleasedInterferenceKeysKey in commonInputControlRemoveReleasedInterferenceKeysMap {
        if !commonInputControlRemoveReleasedInterferenceKeysCurrentKeys.Has(commonInputControlRemoveReleasedInterferenceKeysKey) {
            commonInputControlRemoveReleasedInterferenceKeysReleased[commonInputControlRemoveReleasedInterferenceKeysKey] := true
            commonInputControlRemoveReleasedInterferenceKeysMap.Delete(commonInputControlRemoveReleasedInterferenceKeysKey)
        }
    }

    return commonInputControlRemoveReleasedInterferenceKeysReleased
}

; Common_InputControl_IsImeOpen - 判断当前活动窗口是否开启输入法；参数：无。
Common_InputControl_IsImeOpen() {
    commonInputControlIsImeOpenHwnd := WinExist("A")
    if !commonInputControlIsImeOpenHwnd
        return false

    commonInputControlIsImeOpenContext := DllCall("imm32\ImmGetContext", "Ptr", commonInputControlIsImeOpenHwnd, "Ptr")
    if !commonInputControlIsImeOpenContext
        return false

    commonInputControlIsImeOpenStatus := DllCall("imm32\ImmGetOpenStatus", "Ptr", commonInputControlIsImeOpenContext)
    DllCall("imm32\ImmReleaseContext", "Ptr", commonInputControlIsImeOpenHwnd, "Ptr", commonInputControlIsImeOpenContext)
    return commonInputControlIsImeOpenStatus != 0
}

; Common_InputControl_KeyDown - 使用 SendEvent 按下指定按键；参数：key=AHK 按键名称。
Common_InputControl_KeyDown(commonInputControlKeyDownKey) {
    SendEvent "{" commonInputControlKeyDownKey " down}"
    return true
}

; Common_InputControl_KeyUp - 使用 SendEvent 释放指定按键；参数：key=AHK 按键名称。
Common_InputControl_KeyUp(commonInputControlKeyUpKey) {
    SendEvent "{" commonInputControlKeyUpKey " up}"
    return true
}

; Common_InputControl_ReleaseKeys - 按顺序释放传入数组中的所有按键；参数：keys=需要释放的 AHK 按键名称数组。
Common_InputControl_ReleaseKeys(commonInputControlReleaseKeysList) {
    for commonInputControlReleaseKeysKey in commonInputControlReleaseKeysList
        Common_InputControl_KeyUp(commonInputControlReleaseKeysKey)

    return true
}
