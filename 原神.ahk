#Requires AutoHotkey v2.0

; https://www.autohotkey.com/docs/v2/lib/Run.htm#RunAs
full_command_line := DllCall("GetCommandLine", "str")
if (!(A_IsAdmin || RegExMatch(full_command_line, " /restart(?!\S)")))
{
    try
    {
        if (A_IsCompiled)
            Run('*RunAs "' . A_ScriptFullPath . '" /restart')
        else
            Run('*RunAs "' . A_AhkPath . '" /restart "' . A_ScriptFullPath . '"')
    }
    ExitApp
}

If (FileExist("klee.ico"))
{
    A_TrayMenu.SetIcon("klee.ico")
}

#HotIf WinActive("ahk_exe YuanShen.exe")

F1::l
F2::o
RCtrl::LCtrl
LCtrl::MButton

; 鼠标侧键 1 等于前进，连按两下等于按住 w
XButton1::
{
    Send("{w down}")
    If (KeyWait("XButton1", "T0.3"))
    {
        Send("{w up}")
        If (KeyWait("XButton1", "D T0.2"))
        {
            Send("{w down}")
        }
    }
    Else
    {
        KeyWait("XButton1")
        Send("{w up}")
    }
}

; 鼠标侧键 2 等于 F 键，按住等于按住 Alt 键显示鼠标
XButton2::
{
    If (!KeyWait("XButton2", "T0.2"))
    {
        Send("{LAlt down}")
        KeyWait("XButton2")
        Send("{LAlt up}")
    }
    else
    {
        Send("f")
    }
}

; 按住鼠标中键等于狂按左键（攻击或者跳过对话）
MButton::
{
    Loop
    {
        Click()
        If (KeyWait("MButton", "T0.1"))
        {
            Break
        }
    }
}

; 按住空格等于狂按空格（按住 1.3 秒之后才触发，因为离开浪船需要按住空格）
~*Space::
{
    
    If (KeyWait("Space", "T1.3"))
    {
        If (PixelGetColor(700, 1020) == 0xD8E5EC)
        {
            BlockInput("MouseMove")
            MouseMove(700, 1020)
            Click()
            BlockInput("MouseMoveOff")
        }
        If (PixelGetColor(1130, 880) == 0x66534A)
        {
            BlockInput("MouseMove")
            MouseGetPos(&xpos, &ypos)
            MouseMove(1130, 880)
            Click()
            MouseMove(xpos, ypos)
            BlockInput("MouseMoveOff")
        }
    }
    Else
    {
        Loop
        {
            Send("{Space}")
            If (KeyWait("Space", "T0.05"))
            {
                Break
            }
        }
    }
}

; 按住 f 等于狂按 f
*f::
{
    Loop
    {
        Send("{Blind}f")
        If (KeyWait("f", "T0.1"))
        {
            Break
        }
    }
}

; 点两下 w 按住 w
~w::
{
    If (KeyWait("w", "T0.3"))
    {
        If (KeyWait("w", "D T0.2"))
        {
            KeyWait("w")
            Send("{w down}")
        }
    }
}

; 释放按住的 w
~s::
{
    If (!GetKeyState("w", "P"))
    {
        Send("{w up}")
    }
}

; 队伍切换界面左右
~a::
{
    If (PixelGetColor(64, 538) == 0xD8E5EC)
    {
        BlockInput("MouseMove")
        MouseMove(64, 538)
        Click()
        BlockInput("MouseMoveOff")
    }
}

~d::
{
    If (PixelGetColor(1853, 538) == 0xD8E5EC)
    {
        BlockInput("MouseMove")
        MouseMove(1853, 538)
        Click()
        BlockInput("MouseMoveOff")
    }
}

; 对话选项
Selection(n) {
    xpos := 1298
    choices := 0
    Loop 8
    {
        ypos := 810 - 74 * choices
        If (PixelGetColor(xpos, ypos) != 0xFFFFFF)
        {
            Break
        }
        choices += 1
    }
    if (choices == 0)
    {
        Return False
    }
    ypos := 810 - 74 * choices + 74 * n
    BlockInput("MouseMove")
    MouseMove(xpos, ypos)
    Click()
    BlockInput("MouseMoveOff")
    Return True
}

~1::
{
    If (PixelGetColor(64, 538) == 0xD8E5EC)
    {
        BlockInput("MouseMove")
        MouseMove(350, 490)
        Click()
        BlockInput("MouseMoveOff")
        Return
    }
    If (Selection(1))
    {
        Return
    }
}

~2::
{
    If (PixelGetColor(64, 538) == 0xD8E5EC)
    {
        BlockInput("MouseMove")
        MouseMove(760, 490)
        Click()
        BlockInput("MouseMoveOff")
        Return
    }
    If (Selection(2))
    {
        Return
    }
}

~3::
{
    If (PixelGetColor(64, 538) == 0xD8E5EC)
    {
        BlockInput("MouseMove")
        MouseMove(1170, 490)
        Click()
        BlockInput("MouseMoveOff")
        Return
    }
    If (Selection(3))
    {
        Return
    }
}

~4::
{
    If (PixelGetColor(64, 538) == 0xD8E5EC)
    {
        BlockInput("MouseMove")
        MouseMove(1590, 490)
        Click()
        BlockInput("MouseMoveOff")
        Return
    }
    If (Selection(3))
    {
        Return
    }
}

~5::
{
    If (Selection(5))
    {
        Return
    }
}

~6::
{
    If (Selection(6))
    {
        Return
    }
}

~7::
{
    If (Selection(7))
    {
        Return
    }
}

; 替换圣遗物、领取任务奖励
`::
{
    BlockInput("MouseMove")
    MouseGetPos(&xpos, &ypos)
    MouseMove(1600, 1000)
    Click()
    Sleep(100)
    MouseMove(1200, 760)
    Click()
    Sleep(100)
    MouseMove(xpos, ypos)
    BlockInput("MouseMoveOff")
}

; 强化圣遗物、领取任务奖励
F8::
{
    BlockInput("MouseMove")
    MouseGetPos(&xpos, &ypos)
    xpos2 := xpos
    ypos2 := ypos
    Loop 6
    {
        Click
        xpos2 += 142
        If (xpos2 > 1142)
        {
            xpos2 -= 8 * 142
            ypos2 += 168
        }
        MouseMove(xpos2, ypos2)
    }
    Send("{Esc}")
    Sleep(100)
    MouseMove(1600, 1000)
    Click()
    MouseMove(130, 150)
    Click()
    MouseMove(130, 225)
    Click()
    MouseMove(1250, 870)
    Click()
    MouseMove(xpos, ypos)
    BlockInput("MouseMoveOff")
}

; 按 Tab 等于按右下角的确定。按住 Tab 等于每 0.3 秒按鼠标左键。
Tab::
{
    If (!KeyWait("Tab", "T0.3"))
    {
        Loop
        {
            Click()
            If (KeyWait("Tab", "T0.3"))
            {
                Break
            }
        }
    }
    else
    {
        BlockInput("MouseMove")
        MouseGetPos(&xpos, &ypos)
        MouseMove(1650, 1000)
        Click()
        MouseMove(xpos, ypos)
        BlockInput("MouseMoveOff")
    }
}

; 5个探索派遣
Expedition(x1, y1, x2, y2, x3, y3) {
    BlockInput("MouseMove")
    MouseMove(x1, y1)
    Sleep(50)
    Click()
    MouseMove(x2, y2)
    Sleep(50)
    Click()
    MouseMove(1650, 1000)
    Click()
    Sleep(250)
    Click()
    Sleep(250)
    Click()
    MouseMove(x3, y3)
    Sleep(50)
    Click()
    BlockInput("MouseMoveOff")
}

F9::
{
    ; 蒙德
    Expedition(150, 165, 1063, 333, 300, 150)
    Expedition(150, 165, 1176, 659, 300, 300)
    ; 须弥
    Expedition(150, 230, 724, 333, 300, 150)
    Expedition(150, 230, 961, 454, 300, 300)
    Expedition(150, 300, 1101, 283, 300, 150)
}