# AHK 项目规范

> 本文件是 ScriptManager AHK 项目的唯一权威开发规范。
> 其他文档不得重新定义架构、变量作用域、命名规则或模块职责；如有冲突，以本文件为准。

## 1. 基础规则

- 使用 AutoHotkey v2.0。
- 每个 AHK 源文件使用 `#Requires AutoHotkey v2.0`。
- 独立运行入口使用 `#SingleInstance Force`。
- 需要在持续按键期间仍可靠接收 F6/F7 时，使用 `#UseHook` 与 `*F6` / `*F7`。
- 项目源码直接运行，不依赖中间生成目录。

## 2. 当前目录结构

```text
ahk/
├─GL/
│  ├─MAIN.ahk
│  ├─GL_Config.ahk
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
   ├─Common/
   ├─File/
   └─Input/
```

公共库函数的详细说明统一放在：

```text
ahk/Lib/公共库函数使用文档.md
```

## 3. 架构原则

### 3.1 函数优先

代码逻辑优先使用函数组织。

函数外默认只保留：

- `#Include`
- 必要的常量或配置
- 脚本入口
- 必要的热键注册

业务状态、流程数据和临时数据默认放入入口函数或业务函数的局部变量。

### 3.2 局部变量命名

函数内部局部变量必须使用：

```text
函数名称 + 实际含义
```

例如：

```ahk
GL_LoadScripts(glLoadScriptsFolder) {
    glLoadScriptsList := []
}
```

变量名必须明确表达：

1. 属于哪个函数。
2. 保存什么数据。

禁止为了省事使用模糊名称：

```text
data
temp
value
obj
state
list
gui
```

除非名称属于 AHK/API 固定对象或在极小范围内具有明确语义。

### 3.3 函数外变量

函数外变量不是默认方案。

确实无法避免时，必须使用：

```text
当前脚本名称 + 实际含义
```

例如：

```text
WQFFF_Running
GL_CurrentIndex
```

能放进函数局部变量，就不要提升到函数外。

### 3.4 全局变量

默认禁止使用全局业务状态。

优先采用：

```text
MAIN 局部数据
↓
业务函数参数
↓
Action / 公共库
↓
返回值
↓
业务函数继续处理
```

不要通过隐藏的全局变量或共享脚本变量传递状态。

## 4. 模块职责

### MAIN

MAIN 是入口层，负责：

- Include 模块。
- 创建入口所需对象。
- 准备入口局部状态。
- 注册热键或消息入口。
- 调用 Process/业务函数。

MAIN 不承载大量业务流程。

### Process

Process 负责业务流程：

- 状态判断。
- 启动/暂停/停止流程。
- Timer 生命周期。
- 数据处理。
- 调用 Action。
- 接收返回值并继续流程。

### Action

当前脚本的 Action 负责具体业务动作：

- 按键按下/释放。
- 发送具体输入。
- GUI 状态更新。
- 当前脚本专用的具体执行动作。

### 公共库

公共库只提供可复用能力：

- 不保存某个业务脚本的隐藏状态。
- 不决定调用方的业务流程。
- 通过参数接收数据。
- 通过返回值提供结果。

公共库没有当前业务需要的特殊能力时，不应为了单个业务强塞业务逻辑进去；应在当前脚本 Action 中封装。

> **能力放库，动作放 Action，流程放 Process，入口放 MAIN；状态属于业务，数据通过参数和返回值流动；函数外变量最少，全局变量默认禁止。**

## 5. 公共库代码注释规范

每一个公共函数必须在函数定义前只有一条函数说明注释，并且这一条注释同时包含：

- 函数作用。
- 每一个参数的含义。
- 无参数函数明确写“参数：无”。

标准格式：

```ahk
; FunctionName - 函数作用；参数：param1=参数说明，param2=参数说明。
FunctionName(functionNameParam1, functionNameParam2) {
}
```

要求：

- 一条函数注释完成“作用 + 参数”说明。
- 不在源码里写重复的函数长篇说明。
- 参数名称必须与源码实际参数一致。
- 返回值说明放到公共库函数文档，不堆在源码注释中。
- 类中的公共静态方法同样遵守此规则。

## 6. 公共库函数文档规范

公共库的详细文档统一维护在：

```text
ahk/Lib/公共库函数使用文档.md
```

每个公共函数至少记录：

- 函数名/调用形式。
- 具体作用。
- 参数说明。
- 返回值。
- 重要副作用或依赖。

文档必须以当前源码为准：

- 不允许出现不存在的函数。
- 不允许保留已经删除的函数。
- 不允许描述已经改变的行为。
- 不再为每个小库单独维护重复的函数说明文档。

## 7. GUI 规范

公共 GUI 默认样式：

- AlwaysOnTop。
- 黑色背景。
- Microsoft YaHei。
- s9。
- 300 × 35。
- 透明度 220。

公共 GUI 函数可以提供可选位置，但不得强制所有调用方固定位置。

业务脚本自己决定状态文本和具体内容。

## 8. GL 管理器

入口：

```text
ahk/GL/MAIN.ahk
```

当前由 `GL_Config.ahk` 指定被管理根目录；当前配置为：

```text
ahk/Business
```

GL 扫描根目录的直接子目录，只要存在：

```text
子目录/MAIN.ahk
```

就加入管理列表。

内部对象：

```ahk
{
    name: 子目录名称,
    path: MAIN.ahk 完整路径
}
```

GUI 只显示 `name`，不显示 `MAIN.ahk` 和绝对路径。

排序按脚本目录名称进行字符串排序。

热键：

```text
Ctrl+Up   → 下一个脚本
Ctrl+Down → 上一个脚本
F8        → 退出 GL 管理器
```

列表到边界后循环。

### 8.1 GL 切换协议

```text
Ctrl+Up / Ctrl+Down
↓
读取当前脚本 hwnd 文件
↓
发送 0xB001 退出消息
↓
子脚本收到消息后执行自己的 Stop/清理
↓
删除自己的 hwnd 文件
↓
ExitApp
↓
GL 等待 hwnd 文件消失
↓
启动目标 MAIN.ahk
↓
刷新 GL GUI
```

GL 不直接知道子脚本保持哪些按键，也不直接执行 F7。

### 8.2 GL F8 退出

F8：

1. 向当前子脚本发送 `0xB001`，退出原因为 `ExitReasonManager`。
2. GL 记录一次退出日志。
3. GL 自身直接 `ExitApp`。

F8 不等待子脚本退出。

## 9. 子脚本通信规范

每个受管理子脚本使用：

```text
A_ScriptDir "\\" A_ScriptName ".txt"
```

例如入口为：

```text
MAIN.ahk
```

对应句柄文件：

```text
MAIN.ahk.txt
```

内容为 GUI 的真实 `Hwnd`。

统一退出消息：

```text
0xB001
```

退出原因：

```text
1 = GL 切换脚本
2 = GL 管理器 F8 退出
```

详细协议见：

```text
ScriptManager_Docs/副脚本通信规范.md
```

## 10. 子脚本退出安全

所有会保持按键或运行 Timer 的脚本必须有退出清理。

退出清理至少包括：

- 停止自身 Timer。
- 释放自身保持的按键。
- 删除自身 hwnd 文件。
- 最终 `ExitApp`。

`F7` 是业务暂停/停止入口；GL 的退出消息最终由子脚本自己的退出处理流程复用业务 Stop/清理逻辑。

## 11. 输入干扰保护

需要自动避免“脚本持键 + 用户新输入”叠加的业务脚本，应使用：

```text
ahk/Lib/Input/InputControl.ahk
```

启动时：

1. 捕获当前物理按键作为基线。
2. 启动物理输入监测。
3. 后续新增物理按键视为用户干扰。
4. 记录本次新增的实际物理按键，并触发当前业务的暂停回调。
5. 持续检查已记录的干扰按键是否仍处于物理按下状态。
6. 只有本次干扰记录中的按键全部抬起后，才触发恢复回调。
6. 脚本自身通过 `SendEvent` 产生的输入不按物理状态重复识别。

输入检测使用 `GetKeyState(..., "P")`。

### 11.1 控制键声明

输入保护不再写死 F6/F7。

每个使用输入保护的业务脚本应在 MAIN 中声明自己的控制键，例如：

```ahk
shiftMainControlKeys := ["F6", "F7"]
shiftMainInputGuard := Input_CreateGuard(shiftMainControlKeys)
```

这里的控制键是本脚本用于启动、暂停、退出等控制功能的按键。控制键会被输入保护忽略，因此：

- 用户按住控制键不松时，不会被误判为新的用户干扰；普通用户按键即使长按，也会保持在干扰状态，直到该次记录的干扰按键全部抬起。
- 程序不会为了输入保护主动抬起控制键。
- 如果将启动、暂停或退出改成其他按键，应同步修改控制键数组。
- 不要把同时承担游戏技能、业务输入或其他需要被检测功能的按键作为控制键，因为一旦声明为控制键，它就会被输入保护忽略。

例如以后改成：

```ahk
myMainControlKeys := ["F9", "F10", "F11"]
```

即可分别把 F9/F10/F11 作为该脚本自己的控制键，公共库无需修改。

当前 IME 处理规则：活动窗口处于开启输入法状态时，不将当前输入判定为新的物理干扰。

## 12. 当前业务脚本规则

### SHIFT

F6：

```text
LShift down
开始输入干扰保护
```

F7：

```text
停止输入干扰保护
LShift up
```

退出时释放 LShift，并删除 hwnd 文件。

### WQFFF

F6：

```text
W down
Q down
启动 F 定时循环
开始输入干扰保护
```

F7：

```text
停止 F 定时循环
W up
Q up
F up
```

F 循环间隔：

```text
100 ms
```

退出时停止 Timer、释放 W/Q/F，并删除 hwnd 文件。

## 13. 文件命名

入口：

```text
MAIN.ahk
```

业务流程：

```text
Task_Process.ahk
GL_Process.ahk
```

业务动作：

```text
Task_Action.ahk
GL_Action.ahk
```

公共库按能力分类，例如：

```text
Lib/Common/GUI.ahk
Lib/Common/Message.ahk
Lib/Common/Log.ahk
Lib/Input/InputControl.ahk
Lib/Action/Keyboard.ahk
Lib/Action/Timer.ahk
Lib/Action/Window.ahk
Lib/File/FileControl.ahk
```

## 14. 日志规范

每个脚本的日志文件：

```text
A_ScriptDir\Error.log
```

`GL_LogError()` 使用覆盖式写入：

- 每个脚本只保留最近一次错误/异常退出日志。
- 不持续追加历史错误。
- `Error.log` 属于运行时文件，不提交 Git。

## 15. 开发检查顺序

新增或修改功能时：

1. 先判断公共库是否已有能力。
2. 有则直接调用。
3. 没有且属于当前脚本专用动作，则写入当前脚本 Action。
4. 由 Process 负责流程组合。
5. MAIN 负责入口。
6. 状态优先保持在函数局部。
7. 优先使用参数和返回值传递数据。
8. 不为了调用方便制造全局变量。
9. 公共函数增加“一条作用 + 参数”源码注释。
10. 在公共库函数总文档中同步真实函数说明。
