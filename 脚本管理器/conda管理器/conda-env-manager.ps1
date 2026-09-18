# ============================================================
# Conda 环境管理器（独立命令行版）
#  - 不读写任何 VSCode / conda 配置文件，只执行真实 conda 指令
#  - 创建: conda create -n <名称> python=<版本> -y（显示完整输出/进度）
#  - 删除: conda env remove -n <名称> -y（显示完整输出）
#  双击运行，或在 PowerShell 中执行本脚本
# ============================================================

$ErrorActionPreference = "Stop"

# 异常捕获：显示错误并暂停，避免窗口闪退
trap {
    Write-Host ""
    Write-Host "  [运行异常] $($_.Exception.Message)" -ForegroundColor Red
    if ($_.InvocationInfo -and $_.InvocationInfo.PositionMessage) {
        Write-Host "  位置: $($_.InvocationInfo.PositionMessage)" -ForegroundColor Red
    }
    Write-Host ""
    Read-Host "  按回车返回菜单"
    continue
}

# 本次会话使用的 conda 可执行文件路径（不写入任何配置文件）
$script:CondaExe = $null

# ------------------------------------------------------------
# 查找 conda：优先环境变量 where.exe，其次常见安装位置
# ------------------------------------------------------------
function Find-Conda {
    # 1. where.exe conda
    try {
        $found = & where.exe conda 2>$null | Where-Object { $_ -match "conda(\.exe|\.bat|\.cmd)?$" } | Select-Object -First 1
        if ($found -and (Test-Path $found)) { return (Resolve-Path $found).Path }
    } catch { }

    # 2. 常见安装位置（只查找，不写配置）
    $candidates = @()
    foreach ($drive in @("C", "D", "E")) {
        if (Test-Path "${drive}:\") {
            $candidates += "${drive}:\Users\$env:USERNAME\miniconda3\Scripts\conda.exe"
            $candidates += "${drive}:\Users\$env:USERNAME\anaconda3\Scripts\conda.exe"
            $candidates += "${drive}:\ProgramData\miniconda3\Scripts\conda.exe"
            $candidates += "${drive}:\ProgramData\anaconda3\Scripts\conda.exe"
            $candidates += "${drive}:\miniconda3\Scripts\conda.exe"
            $candidates += "${drive}:\anaconda3\Scripts\conda.exe"
        }
    }
    foreach ($c in $candidates) {
        if (Test-Path $c) { return $c }
    }
    return $null
}

# ------------------------------------------------------------
# 确保已找到 conda（找不到让用户手动输入，仅本次会话有效）
# ------------------------------------------------------------
function Ensure-Conda {
    if ($script:CondaExe -and (Test-Path $script:CondaExe)) { return $true }
    $auto = Find-Conda
    if ($auto) {
        $script:CondaExe = $auto
        Write-Host "  [OK] conda: $script:CondaExe" -ForegroundColor Green
        return $true
    }

    Write-Host "  [提示] 环境变量 where.exe conda 未找到 conda" -ForegroundColor Yellow
    Write-Host "  请手动输入 conda.exe 的完整路径（含文件名）" -ForegroundColor Yellow
    Write-Host "  示例: D:\...\Scripts\conda.exe" -ForegroundColor DarkGray
    Write-Host "  查看方法: 命令行执行 where.exe conda" -ForegroundColor DarkGray
    while ($true) {
        $inp = Read-Host "  conda.exe 完整路径（输入后回车；直接回车=退出）"
        if ([string]::IsNullOrWhiteSpace($inp)) { return $false }
        $inp = $inp.Trim('"').Trim()
        if (Test-Path $inp) {
            $script:CondaExe = (Resolve-Path $inp).Path
            Write-Host "  [OK] 本次会话使用: $script:CondaExe" -ForegroundColor Green
            return $true
        }
        Write-Host "  输入无效：文件不存在，请重新输入" -ForegroundColor Red
    }
}

# ------------------------------------------------------------
# 获取环境列表：返回 @( @{Name=..; Path=..; IsBase=$true/$false} )
# ------------------------------------------------------------
function Get-CondaEnvList {
    $raw = & $script:CondaExe env list 2>$null
    $list = @()
    foreach ($line in $raw) {
        if ($line -match '^\s*#') { continue }
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        # 形如:  name   *  D:\path\envs\name  或 base * D:\miniconda3
        $parts = ($line.Trim() -split '\s+') | Where-Object { $_ -and $_ -ne '*' }
        if ($parts.Count -ge 2) {
            $envPath = $parts[-1]
            # 读取该环境 Python 版本（用 -c 输出 stdout，禁用 --version 2>&1：Py2 版本走 stderr 会误报）
            $ver = ""
            $pyExe = Join-Path $envPath "python.exe"
            if (Test-Path $pyExe) {
                try {
                    $v = & $pyExe -c "import sys; print(sys.version.split()[0])" 2>$null | Select-Object -First 1
                    if ($v -and "$v".Trim() -match '^\d') { $ver = "$v".Trim() }
                } catch { $ver = "" }
            }
            $list += [PSCustomObject]@{ Name = $parts[0]; Path = $envPath; IsBase = ($parts[0] -eq 'base'); Version = $ver }
        }
    }
    return $list
}

# 严格 y/n 确认：默认动作由 $Default 指定（y/n/空=无默认必须明确输入）
function Confirm-YN($Prompt, $Default) {
    while ($true) {
        $hint = switch ($Default) { 'y' { '(Y/n)' } 'n' { '(y/N)' } default { '(y/n)' } }
        $a = Read-Host "$Prompt $hint"
        if ([string]::IsNullOrWhiteSpace($a) -and $Default -ne 'empty') {
            if ($Default -eq 'y') { return $true }
            if ($Default -eq 'n') { return $false }
        }
        if ($a -match '^[Yy]$') { return $true }
        if ($a -match '^[Nn]$') { return $false }
        Write-Host "  输入无效，请输入 y 或 n" -ForegroundColor Red
    }
}

# ------------------------------------------------------------
# 1. 查看环境
# ------------------------------------------------------------
function Show-Envs {
    Write-Host ""
    Write-Host "  ===== Conda 环境列表 =====" -ForegroundColor Cyan
    Write-Host "  正在读取各环境 Python 版本..." -ForegroundColor DarkGray
    $envs = @(Get-CondaEnvList)
    foreach ($e in $envs) {
        $v = if ($e.Version) { "($($e.Version))" } else { "(未知)" }
        Write-Host ("    {0,-20} {1,-10} {2}" -f $e.Name, $v, $e.Path)
    }
    Write-Host "  ===========================" -ForegroundColor Cyan
}

# ------------------------------------------------------------
# 2. 创建环境（执行真实 conda create，显示完整进度）
# ------------------------------------------------------------
function New-Env {
    Write-Host ""
    Write-Host "  ===== 创建 Conda 环境 =====" -ForegroundColor Cyan

    $envs = Get-CondaEnvList
    $existNames = @($envs | ForEach-Object { $_.Name })

    # 环境名（非空 + 不重名）
    $name = $null
    while ($true) {
        $name = Read-Host "  环境名称（直接回车=取消）"
        if ([string]::IsNullOrWhiteSpace($name)) { Write-Host "  已取消" -ForegroundColor Yellow; return }
        $name = $name.Trim()
        if ($name -notmatch '^[A-Za-z0-9_.\-]+$') {
            Write-Host "  输入无效：名称只能含字母/数字/下划线/中划线/点" -ForegroundColor Red; continue
        }
        if ($existNames -contains $name) {
            Write-Host "  输入无效：环境 '$name' 已存在，请换名" -ForegroundColor Red; continue
        }
        break
    }

    # Python 版本：minor 菜单（conda 自动取该系列最新补丁版），可手动精确指定，可不指定
    Write-Host ""
    Write-Host "  选择 Python 版本（选 minor 系列，conda 自动安装该系列最新版）:"
    $pyMenu = @('3.6','3.7','3.8','3.9','3.10','3.11','3.12','3.13','3.14')
    for ($i = 0; $i -lt $pyMenu.Count; $i++) {
        Write-Host ("    {0}. Python {1}.x（最新补丁版）" -f ($i+1), $pyMenu[$i])
    }
    Write-Host ("    {0}. 手动输入完整版本（如 3.11.9）" -f ($pyMenu.Count+1))
    Write-Host ("    {0}. 不指定 Python（创建空环境）" -f ($pyMenu.Count+2))
    $pyVer = $null
    $maxChoice = $pyMenu.Count + 2
    while ($true) {
        $sel = Read-Host "  选择编号"
        if ($sel -notmatch '^\d+$') { Write-Host "  输入无效，请输入数字编号" -ForegroundColor Red; continue }
        $n = [int]$sel
        if ($n -lt 1 -or $n -gt $maxChoice) { Write-Host "  输入无效：编号超出范围" -ForegroundColor Red; continue }
        if ($n -le $pyMenu.Count) { $pyVer = $pyMenu[$n-1] }
        elseif ($n -eq $pyMenu.Count+1) {
            while ($true) {
                $manual = Read-Host "  完整版本号（如 3.11.9，直接回车=返回）"
                if ([string]::IsNullOrWhiteSpace($manual)) { break }
                if ($manual -match '^\d+\.\d+(\.\d+)?$') { $pyVer = $manual.Trim(); break }
                Write-Host "  输入无效：版本格式应为 如 3.11 或 3.11.9" -ForegroundColor Red
            }
            if (-not $pyVer) { continue }
        }
        else { $pyVer = $null }
        break
    }

    # 确认（显示将要执行的真实命令）
    Write-Host ""
    Write-Host "  ===== 创建确认 =====" -ForegroundColor Yellow
    Write-Host "  环境名称: $name"
    if ($pyVer) { Write-Host "  Python:   $pyVer（conda 自动解析为该系列最新可用版）" }
    else { Write-Host "  Python:   不指定（空环境）" }
    if ($pyVer) {
        $cmdDesc = "conda create -n $name python=$pyVer -y"
    } else {
        $cmdDesc = "conda create -n $name -y"
    }
    Write-Host "  执行指令: $cmdDesc" -ForegroundColor Cyan
    Write-Host "  ====================" -ForegroundColor Yellow
    $ok = Confirm-YN "  确认创建?" 'n'
    if (-not $ok) { Write-Host "  已取消，返回菜单" -ForegroundColor Yellow; return }

    # 执行真实 conda 指令（输出/进度直接显示在控制台）
    Write-Host ""
    Write-Host "  >>> $cmdDesc" -ForegroundColor Cyan
    if ($pyVer) {
        & $script:CondaExe create -n $name "python=$pyVer" -y
    } else {
        & $script:CondaExe create -n $name -y
    }
    $code = $LASTEXITCODE
    Write-Host ""
    if ($code -eq 0) {
        Write-Host "  [OK] 环境 '$name' 创建成功" -ForegroundColor Green
    } else {
        Write-Host "  [失败] conda 退出码: $code（请看上方 conda 输出）" -ForegroundColor Red
    }
    Write-Host ""
    Read-Host "  按回车返回菜单"
}

# ------------------------------------------------------------
# 3. 删除环境（执行真实 conda env remove，显示完整输出）
# ------------------------------------------------------------
function Remove-Env {
    Write-Host ""
    Write-Host "  ===== 删除 Conda 环境 =====" -ForegroundColor Cyan
    Write-Host "  （仅删除 conda 环境，项目文件不受影响）" -ForegroundColor DarkGray

    Write-Host "  正在读取各环境 Python 版本..." -ForegroundColor DarkGray
    $envs = @(Get-CondaEnvList)
    if ($envs.Count -eq 0) {
        Write-Host "  [提示] 没有可删除的环境" -ForegroundColor Yellow
        Read-Host "  按回车返回菜单"; return
    }

    for ($i = 0; $i -lt $envs.Count; $i++) {
        $v = if ($envs[$i].Version) { "($($envs[$i].Version))" } else { "(未知)" }
        $tag = if ($envs[$i].IsBase) { "（base 不可删除）" } else { "" }
        Write-Host ("    {0}. {1,-18} {2,-10} {3} {4}" -f ($i+1), $envs[$i].Name, $v, $envs[$i].Path, $tag)
    }
    Write-Host ("    {0}. 取消返回" -f ($envs.Count+1))

    $target = $null
    while ($true) {
        $sel = Read-Host "  选择要删除的环境编号"
        if ($sel -notmatch '^\d+$') { Write-Host "  输入无效，请输入数字编号" -ForegroundColor Red; continue }
        $n = [int]$sel
        if ($n -eq $envs.Count+1) { Write-Host "  已取消" -ForegroundColor Yellow; return }
        if ($n -lt 1 -or $n -gt $envs.Count) { Write-Host "  输入无效：编号超出范围" -ForegroundColor Red; continue }
        $target = $envs[$n-1]
        if ($target.IsBase) { Write-Host "  base 是根环境，禁止删除，请重选" -ForegroundColor Red; continue }
        break
    }

    # 二次确认（名称+路径）
    Write-Host ""
    Write-Host "  ===== 删除确认 =====" -ForegroundColor Yellow
    $tv = if ($target.Version) { "($($target.Version))" } else { "(未知)" }
    Write-Host ("  {0,-18} {1,-10} {2}" -f $target.Name, $tv, $target.Path)
    Write-Host "  执行指令: conda env remove -n $($target.Name) -y" -ForegroundColor Cyan
    Write-Host "  ====================" -ForegroundColor Yellow
    $ok = Confirm-YN "  确认删除? 删除后不可恢复" 'n'
    if (-not $ok) { Write-Host "  已取消，返回菜单" -ForegroundColor Yellow; return }

    Write-Host ""
    Write-Host "  >>> conda env remove -n $($target.Name) -y" -ForegroundColor Cyan
    & $script:CondaExe env remove -n $target.Name -y
    $code = $LASTEXITCODE
    Write-Host ""
    if ($code -eq 0) {
        Write-Host "  [OK] 环境 '$($target.Name)' 已删除" -ForegroundColor Green
    } else {
        Write-Host "  [失败] conda 退出码: $code（请看上方 conda 输出）" -ForegroundColor Red
    }
    Write-Host ""
    Read-Host "  按回车返回菜单"
}

# ------------------------------------------------------------
# 主循环
# ------------------------------------------------------------
Clear-Host
Write-Host ""
Write-Host "  ================================" -ForegroundColor Cyan
Write-Host "    Conda 环境管理器（独立命令行）" -ForegroundColor Cyan
Write-Host "  ================================" -ForegroundColor Cyan

if (-not (Ensure-Conda)) {
    Write-Host "  未配置 conda，退出" -ForegroundColor Yellow
    Read-Host "  按回车退出"; exit 1
}

while ($true) {
    Write-Host ""
    Write-Host "  -------- 菜单 --------" -ForegroundColor Cyan
    Write-Host "   1. 查看所有环境（conda env list）"
    Write-Host "   2. 创建环境（conda create）"
    Write-Host "   3. 删除环境（conda env remove）"
    Write-Host "   4. 退出"
    $choice = Read-Host "  选择编号"
    switch ($choice) {
        '1' { Show-Envs }
        '2' { New-Env }
        '3' { Remove-Env }
        '4' { exit 0 }
        default { Write-Host "  输入无效，请输入 1-4" -ForegroundColor Red }
    }
}
