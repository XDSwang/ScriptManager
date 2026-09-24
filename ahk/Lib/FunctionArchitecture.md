# ScriptManager 函数架构规范

## 分层

公共库：提供原子动作函数。

业务脚本：组合公共库动作，实现具体需求。

入口函数：调用业务函数启动完整功能。

## 原则

- 函数内部管理变量，避免无意义全局变量。
- 函数名称使用模块前缀，避免 AutoHotkey 全局命名冲突。
- 数据通过函数返回值传递给下一步动作。
- 主脚本只保留 Include、入口函数调用和必要热键绑定。

## 命名示例

GL:
- GL_LoadScripts()
- GL_StartScript()
- GL_StopScript()

Shift:
- Shift_Run()
- Shift_Start()
- Shift_Stop()

WQF:
- WQF_Run()
- WQF_Start()
- WQF_Stop()

公共库:
- GUI_Create()
- Input_KeyDown()
- File_Read()
- SubScript_Register()
