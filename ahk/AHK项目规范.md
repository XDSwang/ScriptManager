# AHK 项目规范

> 本文件是 ScriptManager AHK 项目的唯一权威开发规范。
> 其他文档不得重新定义架构、变量作用域、命名规则或模块职责；如有冲突，以本文件为准。
>
> 通用、可迁移到其他 AutoHotkey v2 项目的规则，另见项目根目录的 `AHK通用项目开发规范.md`。

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
GL_Process_LoadScripts(glLoadScriptsFolder) {
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

### 3.5 ★ 全项目函数命名原则
**函数命名必须同时解决两个问题：同级脚本之间的归属清晰，以及跨目录引用时的唯一归属清晰。**

命名层级不是简单由“文件放在哪里”决定，而要结合函数的**使用范围**确定。

#### ★ 3.5.1 同级目录内调用：脚本名称 + 功能
当多个 `.ahk` 文件处于同一业务/模块目录，并且函数只在该目录内部相互调用时，采用：

具体脚本名称_具体功能

例如：
- Business/SHIFT/MAIN.ahk → MAIN()
- Business/SHIFT/Task_Process.ahk → Task_Process_Start()
- Business/SHIFT/Task_Action.ahk → Task_Action_Down()
- Business/WQFFF/Task_Process.ahk → Task_Process_Start()
- Business/WQFFF/Task_Action.ahk → Task_Action_Down()
- GL/GL_Config.ahk → GL_Config_GetManagedFolder()
- GL/GL_Process.ahk → GL_Process_LoadScripts()
- GL/GL_Action.ahk → GL_Action_SwitchScript()

这里的“脚本名称”就是当前目录下实际 `.ahk` 文件的脚本名（不含扩展名）。例如 `Task_Process.ahk` 的函数使用 `Task_Process_*`，不能因为它位于 `SHIFT` 目录就改成 `SHIFT_*`。

重点是：**同级目录内部调用，不需要把上级业务目录名再次塞进函数名；同级目录本身已经提供了第一层命名空间。**

#### ★ 3.5.2 跨目录引用：提升为公共可引用模块命名
当某个脚本中的函数需要被**其他目录、其他业务模块或其他独立脚本引用**时，该脚本已经具有“公共可引用模块”的性质。

此时不能继续只使用简单的：

具体脚本名称_具体功能

因为调用方可能来自多个目录，容易出现同名函数、归属不明确或后续扩展冲突。

应提升为：

分类_具体脚本名称_具体功能

其中“分类”必须明确表示该模块所属的公共能力类别。

例如 Lib 下的公共能力：
- Lib/Common/GUI.ahk → Common_GUI_Create()
- Lib/Common/Message.ahk → Common_Message_SendExit()
- Lib/Common/Log.ahk → Common_Log_Error()
- Lib/Action/Keyboard.ahk → Action_Keyboard_KeyDown()
- Lib/Action/Timer.ahk → Action_Timer_Start()
- Lib/Action/Window.ahk → Action_Window_Activate()
- Lib/Input/InputControl.ahk → Input_InputControl_StartGuard()
- Lib/File/FileControl.ahk → File_FileControl_Read()

**Common、Action、Input、File 是公共能力分类；具体文件名才是实际脚本名称。**

#### ★ 3.5.3 “公共库性质”与“公共库目录”不是同一个概念
必须区分：

- **公共库目录**：物理上位于 Lib 下的可复用模块。
- **公共库性质**：函数虽然可能位于业务目录，但已经需要被其他目录/业务模块引用，因此必须具有明确、稳定、不可混淆的跨目录名称。

因此，不能简单规定“只有 Lib 里的函数才需要明确归属”。

真正的判断标准是：

1. 只在同级目录内部使用 → 使用“脚本名称_功能”。
2. 被其他目录/独立模块引用 → 提升为“分类_脚本名称_功能”。
3. 跨目录引用的模块必须有稳定的归属前缀，避免调用方根据文件路径猜测来源。

#### ★ 3.5.4 目录名与实际脚本名
必须严格区分：

目录 = 能力分类
文件 = 实际脚本/模块名称
函数 = 来源 + 功能

例如：

Lib/Input/InputControl.ahk

- Input = 公共能力分类。
- InputControl = 实际脚本名称。
- Input_InputControl_StartGuard() = 完整公共函数名称。

因此禁止：
- Common_InputControl_StartGuard()
- Input_StartGuard()
- StartGuard()

同理：

Lib/Action/Keyboard.ahk
→ Action_Keyboard_KeyDown()

Lib/File/FileControl.ahk
→ File_FileControl_Read()

#### ★ 3.5.5 核心原则
函数名必须让人不查看调用代码，也能判断函数属于哪个实际脚本/模块。

命名优先级：
1. 先判断函数是否只在同级目录内部使用。
2. 如果是同级内部使用，采用“脚本名称_功能”。
3. 如果需要跨目录引用，采用“分类_脚本名称_功能”。
4. 分类必须稳定，不能根据调用方临时改变。
5. 实际脚本名称不能省略或人为拆分。
6. 禁止使用无法判断归属的裸函数名。

#### ★ 3.5.6 多级分类必须完整表达真实归属

项目允许存在多级分类。

当一个公共可引用模块存在多级真实归属时，函数名称必须按照**实际归属层级从上到下完整表达**，不能只保留其中某一级。

统一原则：

`上级分类_下级分类_具体脚本名称_具体功能`

例如，假设某模块实际归属为：

`Lib/XXX/YYY/Keyboard.ahk`

则应根据真实模块归属定义为：

`XXX_YYY_Keyboard_KeyDown()`

而不能写成：

`YYY_Keyboard_KeyDown()`

也不能写成：

`Keyboard_KeyDown()`

因为后两种写法会丢失真实归属，跨目录引用后无法准确判断函数属于哪个模块。

**命名层级必须与项目真实分类层级一致。**

判断原则：

1. 先确定函数实际属于哪个具体脚本。
2. 再向上追溯该脚本的真实分类。
3. 如果存在上级分类，则继续向上追溯。
4. 所有会影响模块唯一归属的分类层级，都必须进入函数名称。
5. 最后才追加具体功能。
6. 不允许为了缩短名称而省略真实归属层级。
7. 不允许人为增加不存在的分类层级。
8. 不允许根据“当前调用方”决定命名；命名必须依据被调用模块自身的真实归属。

因此，函数名称本质上是：

`完整真实归属路径 + 具体脚本名称 + 具体功能`

但函数名**不是简单机械复制完整文件系统路径**；只纳入有实际模块语义、能够确定归属的分类层级。

例如：

`Business/SHIFT/Task_Process.ahk`

在 `SHIFT` 目录内部使用时，应保持：

`Task_Process_Start()`

如果以后这个脚本中的能力真的需要被其他目录公开引用，则应把可复用能力抽到公共库，或者在项目明确存在真实公共分类时，按：

`分类_具体脚本名称_具体功能`

进行提升。

例如某个真实公共模块位于：

`Lib/Automation/Task_Process.ahk`

则跨目录公开函数可定义为：

`Automation_Task_Process_Start()`

如果再存在真实且有模块语义的上级分类：

`Lib/System/Automation/Task_Process.ahk`

则：

`System_Automation_Task_Process_Start()`

注意：**不能因为原来脚本位于 `Business/SHIFT`，就把 `SHIFT` 人为加入所有同级函数名；也不能把调用方目录名称当成公共分类。**

核心要求只有一个：

> **看到函数名，就必须能够明确判断“这个函数具体是谁的”。**

#### ★ 3.5.6 新增模块命名
新增函数时必须先确定其使用范围：

- 同级内部函数：脚本名称_功能。
- 跨目录可复用函数：分类_脚本名称_功能。

如果一个原本只在同级内部使用的函数后来开始被其他目录引用，应在扩展范围时同步提升其命名层级，并检查所有调用点。

### 3.6 变量与函数命名的共同原则

函数命名和变量命名遵循同一个基本思想：

```text
先表达真实归属
+
再表达实际含义
```

例如：

```text
业务函数：
Task_Process_Start()

公共库函数：
Input_InputControl_StartGuard()

函数参数：
wqfffStartRunning
```

目标是让代码在脱离定义位置后，单看调用、变量或数据，也能够判断其所属范围和实际用途。

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
- 使用 NoActivate，显示状态窗口时不抢当前前台窗口的键盘输入焦点。

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
2. 等待当前子脚本完成统一退出清理并删除 hwnd 文件。
3. GL 记录一次退出日志。
4. GL 自身执行 `ExitApp`。

这样可以保证管理器退出后，不遗留仍在运行的子脚本。

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

输入检测使用 `GetKeyState(..., "P")`。

### 11.1 控制键声明

输入保护不再写死 F6/F7。

每个使用输入保护的业务脚本应在 MAIN 中声明自己的控制键，例如：

```ahk
shiftMainControlKeys := ["F6", "F7"]
shiftMainInputGuard := Input_InputControl_CreateGuard(shiftMainControlKeys)
```

这里的控制键是本脚本用于启动、暂停、退出等控制功能的按键。控制键会被输入保护忽略，因此：

- 用户按住控制键不松时，不会被误判为新的用户干扰。
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

**同级目录内，文件名就是函数的第一层脚本归属。**

例如：

`Task_Process.ahk` → `Task_Process_*`
`Task_Action.ahk` → `Task_Action_*`

`MAIN.ahk` 作为单独入口脚本，可以使用 `MAIN()` 作为入口函数。

不能因为业务目录名已经明确，就把业务目录名重复加入同级函数，例如不要把 `SHIFT/Task_Process.ahk` 写成 `SHIFT_Start()`。

## 14. 日志规范

每个脚本的日志文件：

```text
A_ScriptDir\Error.log
```

公共库函数的命名必须遵守“分类_具体脚本名称_具体功能”的最高优先级规则。具体分类取决于公共库实际所在能力目录：

```text
Common_具体脚本名称_具体功能
Action_具体脚本名称_具体功能
Input_具体脚本名称_具体功能
File_具体脚本名称_具体功能
```

例如 `Lib/Common/Log.ahk` 中的错误记录能力使用：

```text
Common_Log_Error()
```

例如 `Lib/Common/Log.ahk` 中的错误记录能力应使用：

```text
Common_Log_Error()
```

`Error.log` 使用覆盖式写入：

- 每个脚本只保留最近一次错误/异常退出日志。
- 不持续追加历史错误。
- `Error.log` 属于运行时文件，不提交 Git。

## 15. 开发检查顺序

新增或修改功能时：

1. **先确定真实具体脚本名称。**
2. **如果属于同级目录内部使用，直接使用 `具体脚本名称_具体功能`；例如 `Task_Process_Start()`、`Task_Action_Down()`。`MAIN.ahk` 的入口函数可使用 `MAIN()`。**
3. **如果属于公共库或真正需要跨目录公开复用，必须按照真实能力分类套用 `分类_具体脚本名称_具体功能`；例如 `Common_`、`Action_`、`Input_`、`File_`。**
4. 不允许因为业务目录名而人为增加 `SHIFT_`、`WQFFF_` 等前缀；业务目录是目录级命名空间，不是同级脚本函数名前缀。
4. 先判断公共库是否已有能力。
5. 有则直接调用。
6. 没有且属于当前脚本专用动作，则写入当前脚本 Action。
7. 由 Process 负责流程组合。
8. MAIN 负责入口。
9. 状态优先保持在函数局部。
10. 优先使用参数和返回值传递数据。
11. 优先让函数名表达“真实脚本 + 功能”。
12. 禁止为了省字使用 `Start()`、`Stop()`、`Exit()`、`Gui()`、`Message()` 等无归属通用名称。
13. 不为了调用方便制造全局变量。
14. 公共函数增加“一条作用 + 参数”源码注释。
15. 在公共库函数总文档中同步真实函数说明。
16. 新增扩展时，先确定真实脚本名称，再开始写函数。

