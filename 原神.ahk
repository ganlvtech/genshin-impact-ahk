; https://stackoverflow.com/questions/43298908/how-to-add-administrator-privileges-to-autohotkey-script
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try ; leads to having the script re-launching itself as administrator
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
I_Icon = klee.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

#IfWinActive ahk_exe YuanShen.exe

F1::l
F2::o
RCtrl::LCtrl
LCtrl::MButton
XButton1::
    Send {w down}
    KeyWait, XButton1, T0.3
    If Not ErrorLevel
    {
        Send {w up}
        KeyWait, XButton1, D T0.2
        If Not ErrorLevel
        {
            Send {w down}
        }
    }
    Else
    {
        KeyWait, XButton1
        Send {w up}
    }
Return

XButton2::
    KeyWait, XButton2, T0.2
    If ErrorLevel
    {
        Send, {LAlt down}
        KeyWait, XButton2
        Send, {LAlt up}
    }
    else
    {
        Send f
    }
Return

; 按住鼠标中键等于狂按左键（攻击或者跳过对话）
MButton::
    Loop
    {
        Click
        KeyWait, MButton, T0.1
        If Not ErrorLevel
        {
            Break
        }
    }
Return

; 按住空格等于狂按空格（按住 1.3 秒之后才触发，因为离开浪船需要按住空格）
~*Space::
    KeyWait, Space, T1.3
    If Not ErrorLevel
    {
        Return
    }
    Loop
    {
        Send, {Space}
        KeyWait, Space, T0.05
        If Not ErrorLevel
        {
            Break
        }
    }
Return

; 按住 f 等于狂按 f
*f::
    Loop
    {
        Send, {Blind}f
        KeyWait, f, T0.1
        If Not ErrorLevel
        {
            Break
        }
    }
Return

; 点两下 w 按住 w
~w::
    KeyWait, w, T0.3
    If Not ErrorLevel
    {
        KeyWait, w, D T0.2
        If Not ErrorLevel
        {
            KeyWait, w
            Send {w down}
        }
    }
Return

; 释放按住的 w
~s::
    If Not GetKeyState("w", "P")
    {
        Send {w up}
    }
Return

; 队伍切换界面左右
~a::
    PixelGetColor, color, 64, 538
    If (color == 0xD8E5EC)
    {
        BlockInput, MouseMove
        MouseMove, 64, 538
        Click
        BlockInput, MouseMoveOff
    }
Return

~d::
    PixelGetColor, color, 1853, 538
    If (color == 0xD8E5EC)
    {
        BlockInput, MouseMove
        MouseMove, 1853, 538
        Click
        BlockInput, MouseMoveOff
    }
Return

; 替换圣遗物、领取任务奖励
`::
    BlockInput, MouseMove
    MouseGetPos, xpos, ypos
    MouseMove, 1600, 1000
    Click
    Sleep 100
    MouseMove, 1200, 760
    Click
    Sleep 100
    MouseMove, %xpos%, %ypos%
    BlockInput, MouseMoveOff
Return

; 强化圣遗物、领取任务奖励
F8::
    BlockInput, MouseMove
    MouseGetPos, xpos, ypos
    xpos2 := xpos
    ypos2 := ypos
    Loop, 6
    {
        Click
        xpos2 += 142
        If (xpos2 > 1142)
        {
            xpos2 -= 8 * 142
            ypos2 += 168
        }
        MouseMove %xpos2%, %ypos2%
    }
    Send {Esc}
    Sleep 100
    MouseMove, 1600, 1000
    Click
    MouseMove, 130, 150
    Click
    MouseMove, 130, 225
    Click
    MouseMove, 1250, 870
    Click
    MouseMove, %xpos%, %ypos%
    BlockInput, MouseMoveOff
Return

; 点击右下角的确定
Tab::
    KeyWait, Tab, T0.3
    If ErrorLevel
    {
        Loop
        {
            Click
            KeyWait, Tab, T0.6
            If Not ErrorLevel
            {
                Break
            }
        }
    }
    else
    {
        BlockInput, MouseMove
        MouseGetPos, xpos, ypos
        MouseMove, 1650, 1000
        Click
        MouseMove, %xpos%, %ypos%
        BlockInput, MouseMoveOff
    }
Return

; CapsLock::
;     BlockInput, MouseMove
;     MouseGetPos, xpos, ypos
;     MouseMove, 960, 540
;     Click
;     MouseMove, 1650, 1000
;     MouseMove, 1200, 760
;     Click
;     MouseMove, %xpos%, %ypos%
;     BlockInput, MouseMoveOff
; Return

; 5个探索派遣
Expedition(x1, y1, x2, y2, x3, y3) {
    BlockInput, MouseMove
    MouseMove, x1, y1
    Sleep 50
    Click
    MouseMove, x2, y2
    Sleep 50
    Click
    MouseMove, 1650, 1000
    Click
    Sleep 250
    Click
    Sleep 250
    Click
    MouseMove, x3, y3
    Sleep 50
    Click
    BlockInput, MouseMoveOff
}

F9::
    ; 蒙德
    Expedition(150, 165, 1063, 333, 300, 150)
    Expedition(150, 165, 1176, 659, 300, 300)
    ; 璃月
    Expedition(150, 230, 724, 333, 300, 150)
    Expedition(150, 230, 961, 454, 300, 300)
    ; 稻妻
    Expedition(150, 300, 1101, 283, 300, 150)
Return
