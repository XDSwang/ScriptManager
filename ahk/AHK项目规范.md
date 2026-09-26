# AHK 项目规范

## 1. 项目版本

- 使用 AutoHotkey v2.0。
- 脚本使用 `#Requires AutoHotkey v2.0`。
- 使用 `#SingleInstance Force`。
- 需要保证 F6/F7 在脚本自身按键保持期间仍可触发时，使用 `#UseHook` 与 `*F6` / `*F7`。

## 2. 项目目录

```
ahk/
├─GL/
│  ├─MAIN.ahk
│  ├─GL_Process.ahk
│  └─GL_Action.ahk
│
├─Business/
│  ├─SHIFT/
│  │  ├─MAIN.ahk
│  │  ├─Task_Process.ahk
│  │  └─Task_Action.ahk
│  │
│  └─WQFFF/
│     ├─MAIN.ahk
│     ├─Task_Process.ahk
│     └─Task_Action.ahk
│
└─Lib/
   ├─Action/
   └─Common/
```

## 3. 模块职责

### MAIN

负责脚本入口、状态初始化、GUI创建、热键入口和模块引用。

### Process

负责流程、状态、脚本扫描、启动/停止和状态管理。

### Action

负责具体按键或窗口动作。

### Lib/Common

存放跨脚本使用的公共功能。

### Lib/Action

存放公共动作函数。

## 4. GUI 规范

统一使用：

- 标题按脚本功能命名。
- 黑色背景。
- Microsoft YaHei。
- 字号 `s9`。
- AlwaysOnTop。
- 宽度 300。
- 高度 35。
- 透明度 220。

GL 管理器标题固定为：

```
GL管理器
```

GL 管理器显示所有被管理脚本名称。

当前脚本使用红色显示，其余脚本使用白色显示。

## 5. GL 管理器

GL 管理器扫描 Business 下的脚本入口 `MAIN.ahk`。

脚本按照文件路径名称顺序排列。

热键：

```
Ctrl+Up   → 下一个脚本
Ctrl+Down → 上一个脚本
```

切换流程：

```
当前脚本 F7 暂停
↓
读取当前脚本自己的 hwnd txt
↓
发送 0xB001 退出消息
↓
等待当前脚本退出
↓
启动目标脚本
↓
刷新 GL 显示
```

GL 管理器不绑定固定窗口，不使用固定目标窗口查找脚本。

## 6. 子脚本通信

每个子脚本启动后，在自己的目录写入：

```
A_ScriptName.txt
```

文件内容为：

```
myGui.Hwnd
```

GL 使用该 hwnd 精确定位当前脚本窗口。

退出消息：

```
0xB001
```

子脚本使用：

```
OnMessage(0xB001, GL_Exit)
```

收到退出消息后：

1. 释放正在按住的按键。
2. 删除自己的 hwnd txt 文件。
3. `ExitApp`。

## 7. SHIFT 脚本

F6：

```
LShift down
```

F7：

```
LShift up
```

退出时必须释放：

```
LShift up
```

状态显示：

```
● 待机 | F6 开启
```

运行状态：

```
运行-Shift按住中/释放-按F7暂停
```

## 8. WQFFF 脚本

F6：

```
W down
Q down
开始 F 定时循环
```

F7：

```
停止 F 定时循环
W up
Q up
```

F 循环间隔：

```
100 ms
```

F 使用：

```
F down
F up
```

状态显示：

```
● 待机 | F6 开启
```

运行状态：

```
运行-WQ按住中F循环中/释放-按F7暂停
```

退出时必须停止 Timer，并释放：

```
W
Q
F
```

## 9. 退出安全

所有会保持按键状态或运行 Timer 的脚本必须注册 `OnExit`。

退出时：

- 停止 Timer。
- 释放所有保持按下的按键。
- 删除自己的 hwnd txt 文件。
- 退出脚本。

## 10. 文件命名

入口：

```
MAIN.ahk
```

流程：

```
GL_Process.ahk
Task_Process.ahk
```

动作：

```
GL_Action.ahk
Task_Action.ahk
```

公共 GUI：

```
GUI.ahk
```

公共消息：

```
Message.ahk
```

公共释放：

```
Release.ahk
```
