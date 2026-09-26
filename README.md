# 脚本管理器

一个统一管理自动化脚本和开发环境的工具集合。

## 通用开发规范

AutoHotkey v2 项目开发规范统一整理在：

**[AHK通用项目开发规范.md](./AHK通用项目开发规范.md)**

内容包括：

- 公共库能力划分
- 公共函数设计
- 变量与作用域规范
- MAIN / Process / Action 架构
- 参数与返回值数据流
- 输入保护
- GUI 与焦点
- Timer、文件、窗口、键盘能力
- 子脚本通信与安全退出
- 运行流程
- 开发检查清单

## 功能

### AHK管理器

用于管理 AutoHotkey 自动化脚本。

功能：

- 多脚本切换
- 自动关闭旧脚本
- 状态显示
- 统一窗口管理

### Conda管理器

用于管理 Conda 环境。

功能：

- 环境查看
- 环境切换
- Python项目管理

## 项目结构

AHK管理器：

负责 Windows 自动化脚本。

Conda管理器：

负责 Python 环境管理。

## AHK 项目内部规范

当前 ScriptManager 的 AHK 专用实现规范：

`ahk/AHK项目规范.md`

公共库具体函数文档：

`ahk/Lib/公共库函数使用文档.md`

GL 与子脚本通信协议：

`ScriptManager_Docs/副脚本通信规范.md`
