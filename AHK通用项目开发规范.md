# AutoHotkey v2 通用项目开发规范

> 本规范从本项目已经验证的公共库、函数组织方式、变量规则、运行流程和实际问题中提炼。
> 目标不是规定某一个具体脚本的业务，而是形成可复用于后续 AutoHotkey v2 自动化项目的通用开发标准。
>
> 项目如果另有更高层级的特殊规范，应在此基础上扩展；不得无理由破坏本规范的作用域、模块职责和数据流原则。

---

## 1. 核心原则

整个项目遵循：

> **能力放公共库，动作放 Action，流程放 Process，入口放 MAIN；状态属于业务，数据通过参数和返回值流动；函数外变量最少，全局变量默认禁止。**

开发时优先回答四个问题：

1. 这是可复用的能力吗？→ 公共库。
2. 这是当前脚本要执行的具体动作吗？→ Action。
3. 这是多个动作组成的业务流程吗？→ Process。
4. 这是程序启动、热键或消息入口吗？→ MAIN。

不要为了“方便调用”把业务状态做成全局变量。

---

# 2. AutoHotkey v2 基础要求

每个 AHK 源文件：

```ahk
#Requires AutoHotkey v2.0
```

独立运行入口通常使用：

```ahk
#SingleInstance Force
```

需要可靠处理持续按键或修饰键影响时，根据实际需求使用：

```ahk
#UseHook
```

代码应直接运行于源码目录，不依赖中间生成文件。

---

# 3. 标准项目结构

推荐结构：

```text
Project/
├─ MAIN.ahk
├─ Config/
├─ Business/
│  └─ ScriptName/
│     ├─ MAIN.ahk
│     ├─ Task_Process.ahk
│     └─ Task_Action.ahk
│
├─ Lib/
│  ├─ Common/
│  ├─ Input/
│  ├─ File/
│  └─ Action/
│
└─ Docs/
```

大型项目也可以把管理器、业务脚本和公共库分开：

```text
Project/
├─Manager/
├─Business/
└─Lib/
```

目录名称可以按项目实际情况调整，但**模块职责不能因为目录变化而混淆**。

---

# 4. 四层架构

## 4.1 MAIN：入口层

MAIN 只负责入口相关工作：

- `#Include`。
- 创建入口所需对象。
- 准备入口局部状态。
- 注册热键。
- 注册消息。
- 调用 Process/业务函数。

示例：

```ahk
Script_Main() {
    scriptMainState := Script_CreateState()

    Hotkey("*F6", (*) => Script_Start(&scriptMainState))
    Hotkey("*F7", (*) => Script_Stop(&scriptMainState))
}
```

MAIN 不应堆积大量业务流程。

---

## 4.2 Process：业务流程层

Process 负责：

- 状态判断。
- 启动、暂停、停止。
- Timer 生命周期。
- 业务条件判断。
- 调用 Action。
- 处理 Action 返回值。
- 组织多个动作形成完整流程。

Process 关注的是：

> “接下来业务应该做什么？”

而不是：

> “Windows API 的具体调用细节是什么？”

---

## 4.3 Action：具体动作层

Action 负责当前脚本真正执行的动作，例如：

- 按键按下/释放。
- 发送具体输入。
- 更新状态文字。
- 操作当前脚本专用窗口。
- 当前业务特有的文件/窗口动作。

Action 不负责决定完整业务流程。

例如：

```ahk
GAME_Down() {
    SendEvent "{w down}"
    SendEvent "{q down}"
}
```

Process 决定什么时候调用 `GAME_Down()`。

---

## 4.4 公共库：Reusable Capability

公共库只提供可以被多个脚本复用的能力。

例如：

- GUI 创建。
- 消息定义。
- 日志。
- 文件操作。
- Timer。
- 输入状态检测。
- 窗口判断。
- 键盘基础动作。

公共库不得偷偷保存某个业务脚本的状态，也不得决定调用方的业务流程。

如果公共库缺少某个能力：

```text
公共库已有能力
    ↓
直接调用

公共库没有能力，但属于通用能力
    ↓
扩展公共库

公共库没有能力，而且只服务当前脚本
    ↓
写入当前脚本 Action
```

不要为了一个业务需求把业务规则塞进公共库。

---

# 5. 变量与作用域规范

## 5.1 函数内部变量

函数内部变量必须使用：

> **函数名称 + 实际含义**

例如：

```ahk
GL_LoadScripts(glLoadScriptsFolder) {
    glLoadScriptsList := []
    glLoadScriptsMainFile := ""
    glLoadScriptsScriptName := ""
}
```

名称必须能够回答：

- 这个变量属于哪个函数？
- 它保存什么？

---

## 5.2 禁止模糊变量

除 AHK/API 固定名称外，不建议使用：

```text
data
temp
value
obj
state
list
gui
result
item
```

如果确实需要，应进一步表达实际含义。

例如：

```text
wqfffStartStatusText
glReadHwndValue
inputCapturePhysicalKeysMap
```

---

## 5.3 函数外变量

函数外变量不是默认方案。

能够放入函数局部变量，就不要放到脚本级。

确实无法避免时使用：

> **当前脚本名称 + 实际含义**

例如：

```text
GL_CurrentIndex
WQFFF_Running
```

---

## 5.4 全局变量

默认禁止业务全局变量。

推荐的数据流：

```text
MAIN 局部数据
    ↓
Process 参数
    ↓
Action / 公共库
    ↓
返回值
    ↓
Process 继续
```

不要通过隐藏的全局变量传递状态。

---

# 6. 函数设计规范

一个函数尽量只解决一个明确问题。

推荐：

```ahk
Process_Start(...) {
    Action_Down()
    Action_StartTimer(...)
    return true
}
```

不推荐把 GUI、输入、Timer、文件、业务判断全部塞进一个巨大函数。

---

## 6.1 参数

参数名称也应遵循：

> **函数名称 + 参数实际含义**

例如：

```ahk
Input_StartGuard(
    inputStartGuardState,
    inputStartGuardInterferenceCallback,
    inputStartGuardResumeCallback
)
```

参数应尽可能表达用途，而不是只写：

```text
state
callback
data
obj
```

---

## 6.2 返回值

函数之间优先使用：

- 参数传入数据。
- 返回值传出结果。

不要依赖修改隐藏的外部状态。

---

## 6.3 引用参数

只有确实需要修改调用方变量时使用 `&`。

例如：

```ahk
Process_Start(&processStartRunning)
```

不需要修改调用方变量时不要使用引用参数。

---

# 7. 公共函数注释规范

每个公共函数、公共静态方法必须紧邻定义前写**一条**说明注释。

必须包含：

- 函数作用。
- 每个参数的含义。
- 无参数时明确写“参数：无”。

标准：

```ahk
; FunctionName - 函数作用；参数：param1=参数说明，param2=参数说明。
FunctionName(functionNameParam1, functionNameParam2) {
}
```

源码注释不要写成长篇 API 文档。

详细说明统一放在：

```text
Lib/公共库函数使用文档.md
```

公共函数源码与文档必须保持一致。

---

# 8. 当前公共库能力模型

本项目已经形成的公共能力可以抽象为以下几类。

## 8.1 GUI

典型能力：

### GLGui.Create

用途：

- 创建统一样式 GUI。
- AlwaysOnTop。
- 黑色背景。
- Microsoft YaHei。
- s9。
- 透明度 220。
- 可选坐标。
- **NoActivate，不抢当前前台窗口输入焦点。**

返回：

```ahk
{
    gui: GUI对象,
    controls: []
}
```

重要原则：

> 状态显示 GUI 不应因为启动/显示而抢走用户当前输入焦点。

---

### GLGui.UpdateList

用途：

- 更新 GUI 中的名称列表。
- 当前项目使用红色。
- 其他项目使用白色。
- 创建、移动、更新、隐藏文本控件。

---

# 9. 消息通信能力

公共消息库用于统一定义进程/脚本之间的消息。

典型模型：

```ahk
class Message {
    static ExitMessage := 0xB001
}
```

发送能力：

```ahk
SendExitMessage(hwnd, reason)
```

公共消息库负责：

- 消息编号。
- 通信接口。

业务脚本负责：

- 收到消息后应该执行什么业务。

因此：

> 消息编号属于公共能力，退出流程属于业务。

---

# 10. 日志能力

统一日志函数：

```text
GL_LogError(reason, detail)
```

原则：

- 日志文件位于当前脚本目录。
- 文件名统一为 `Error.log`。
- 覆盖式写入。
- 默认只保存最近一次错误/异常信息。
- 运行时日志不提交 Git。

推荐格式：

```text
yyyy-MM-dd HH:mm:ss | ERROR | reason | detail
```

---

# 11. 文件公共能力

标准文件能力：

```text
File_Exists(path)
File_Read(path)
File_Write(path, data)
File_Delete(path)
```

职责：

- 文件存在判断。
- 文件读取。
- 覆盖写入。
- 安全删除。

业务文件命名和文件用途属于业务层，不应该写死在公共文件库。

---

# 12. Timer 公共能力

标准能力：

```text
Timer_Start(callback, interval)
Timer_Stop(callback)
```

Process 决定：

- 什么时候启动。
- 什么时候停止。
- Timer 代表什么业务。

公共 Timer 库只负责调用 AHK 的 Timer 能力。

---

# 13. Window 公共能力

标准能力：

```text
GL_WindowActivate(hwnd)
GL_WindowExists(hwnd)
```

公共窗口库负责窗口能力。

具体“什么时候激活哪个窗口”属于业务流程。

特别注意：

> 状态显示窗口默认不应该抢焦点；只有业务明确需要时才主动激活窗口。

---

# 14. Keyboard 公共能力

基础能力：

```text
KeyDown(key)
KeyUp(key)
```

公共键盘库只负责基础输入动作。

具体业务动作，例如：

```ahk
Game_Down() {
    SendEvent "{w down}"
    SendEvent "{q down}"
}
```

应该放当前业务 Action。

这样公共库不会知道“W+Q”代表什么业务。

---

# 15. 输入干扰保护

需要避免：

> 脚本自动持键 + 用户同时输入

的业务，可以使用输入保护。

核心模型：

```text
启动
 ↓
记录当前物理按键基线
 ↓
持续检测物理新增按键
 ↓
发现新增用户按键
 ↓
记录实际干扰按键
 ↓
暂停业务并释放脚本按键
 ↓
持续等待记录的干扰按键全部物理释放
 ↓
恢复业务
```

必须使用物理状态：

```ahk
GetKeyState(key, "P")
```

这样脚本自身的模拟输入不会被当成用户物理输入。

---

## 15.1 控制键必须由业务声明

输入保护不能硬编码 F6/F7。

业务脚本自己声明：

```ahk
mainControlKeys := ["F6", "F7"]
inputGuard := Input_CreateGuard(mainControlKeys)
```

控制键会被输入保护忽略。

因此：

- 启动/暂停/退出热键变化时必须同步修改控制键列表。
- 不要把游戏技能键、业务键加入控制键。
- 控制键由用户/热键机制管理，输入保护不得主动抬起它们。

---

## 15.2 输入保护的恢复条件

“检测到按键”不是结束条件。

正确模型是：

> **按下开始干扰，全部记录的干扰键释放才结束干扰。**

例如：

```text
用户按住 A
 ↓
暂停

用户又按住 B
 ↓
记录 A+B

用户释放 A
 ↓
仍然暂停

用户释放 B
 ↓
恢复
```

---

# 16. GUI、输入法与焦点

自动化项目特别容易出现一个问题：

> 创建新的 GUI 窗口导致当前输入焦点发生变化。

因此状态 GUI 推荐使用 NoActivate。

原则：

```text
显示状态 ≠ 获取输入焦点
```

如果业务需要输入框，则该输入框必须由业务明确控制焦点。

不要通过：

- 发送 Shift 强制切换输入法。
- 随意激活窗口。
- 猜测用户原来的窗口。

来解决普通 GUI 焦点问题。

优先从窗口创建方式解决。

---

# 17. 子脚本安全退出

凡是存在以下任一情况：

- 按键持续按住。
- Timer 持续运行。
- Hook 持续运行。
- 文件句柄/状态文件存在。

都必须有统一清理路径。

退出流程：

```text
收到退出请求
 ↓
停止业务
 ↓
停止 Timer
 ↓
释放脚本持有的按键
 ↓
删除运行时状态文件
 ↓
退出进程
```

同时建议注册：

```ahk
OnExit(...)
```

作为最终安全兜底。

---

# 18. 运行流程标准

一个标准自动化脚本可以抽象为：

```text
MAIN
 ↓
创建 GUI / 状态 / 控制对象
 ↓
注册热键、消息、退出处理
 ↓
用户触发启动
 ↓
Process_Start
 ↓
启动输入保护（如需要）
 ↓
Action 执行具体动作
 ↓
Timer/业务循环
 ↓
检测用户干扰
 ├─ 无干扰 → 继续
 └─ 有干扰 → Pause → 等待物理释放 → Resume
 ↓
用户停止 / 外部退出
 ↓
Process_Stop
 ↓
Action 清理
 ↓
释放按键
 ↓
停止 Timer
 ↓
删除运行时状态
 ↓
ExitApp
```

---

# 19. 管理器与被管理脚本的通用通信模型

如果一个管理器需要控制多个独立 AHK 子脚本，可以采用：

```text
管理器
 ↓
获取子脚本通信标识
 ↓
发送统一退出消息
 ↓
子脚本执行自己的 Stop/Cleanup
 ↓
子脚本删除运行时状态
 ↓
子脚本退出
 ↓
管理器确认旧脚本已经结束
 ↓
启动新脚本
```

管理器不应该直接操作子脚本内部的业务按键。

例如管理器不应该知道：

```text
这个脚本按住 Shift
那个脚本按住 W/Q
另一个脚本运行 F Timer
```

管理器只知道：

> “请求这个脚本安全退出。”

这样才能保持管理器通用。

---

# 20. 运行时文件规范

运行时生成的文件，例如：

```text
*.ahk.txt
Error.log
```

不属于源代码。

应加入：

```text
.gitignore
```

原则：

> 源码进入 Git，运行时状态不进入 Git。

---

# 21. 文件命名规范

入口统一：

```text
MAIN.ahk
```

流程：

```text
*_Process.ahk
```

动作：

```text
*_Action.ahk
```

公共库：

按能力命名，例如：

```text
GUI.ahk
Message.ahk
Log.ahk
InputControl.ahk
FileControl.ahk
Keyboard.ahk
Timer.ahk
Window.ahk
```

文件名应该表达职责，不应该表达临时用途。

---

# 22. 开发检查清单

新增功能前：

- [ ] 是否已经有公共库能力？
- [ ] 如果没有，是通用能力还是业务专用动作？
- [ ] 是否应该放 Action？
- [ ] 流程是否应该放 Process？
- [ ] MAIN 是否只负责入口？
- [ ] 是否产生了不必要的全局变量？
- [ ] 函数内变量是否符合“函数名 + 实际含义”？
- [ ] 是否需要引用参数 `&`？
- [ ] 是否正确返回结果？

公共库修改后：

- [ ] 公共函数是否只有一条作用 + 参数注释？
- [ ] 参数注释是否和真实参数一致？
- [ ] 公共函数文档是否同步？
- [ ] 是否把业务逻辑错误地放进公共库？
- [ ] 是否产生新的隐藏状态？

输入相关修改后：

- [ ] 是否区分物理输入和模拟输入？
- [ ] 是否使用 `GetKeyState(..., "P")`？
- [ ] 控制键是否由业务明确声明？
- [ ] 是否等待所有记录的干扰键释放？
- [ ] 是否会错误释放用户控制键？

GUI 修改后：

- [ ] 是否会抢前台焦点？
- [ ] 状态窗口是否应该使用 NoActivate？
- [ ] 是否意外改变用户当前输入目标？
- [ ] 是否影响 IME/输入法上下文？

退出流程修改后：

- [ ] Timer 是否停止？
- [ ] 模拟按键是否释放？
- [ ] 运行时文件是否删除？
- [ ] 是否有 OnExit 兜底？
- [ ] 管理器是否确认子脚本已经退出？

---

# 23. 最终设计准则

当代码越来越复杂时，不要继续向 MAIN 或全局变量堆功能。

始终回到：

```text
                    ┌──────────────┐
                    │     MAIN     │
                    │     入口     │
                    └──────┬───────┘
                           ↓
                    ┌──────────────┐
                    │   Process    │
                    │     流程     │
                    └──────┬───────┘
                           ↓
                    ┌──────────────┐
                    │    Action    │
                    │     动作     │
                    └──────┬───────┘
                           ↓
                    ┌──────────────┐
                    │ Public Lib   │
                    │     能力     │
                    └──────────────┘

状态：属于业务
数据：参数 → 函数 → 返回值
全局：默认禁止
GUI：显示不等于抢焦点
输入：物理状态优先
退出：必须完整清理
