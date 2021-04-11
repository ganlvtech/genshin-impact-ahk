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

XButton1::w

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

MButton::
    Loop
    {
        Send, {LButton down}{LButton up}
        KeyWait, MButton, T0.1
        If Not ErrorLevel
        {
            Break
        }
    }
Return

LCtrl::MButton

~*Space::
    KeyWait, Space, T0.3
    If Not ErrorLevel
    {
        Return
    }
    Loop
    {
        Send, {Space}
        KeyWait, Space, T0.1
        If Not ErrorLevel
        {
            Break
        }
    }
Return

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

~s::
    If Not GetKeyState("w", "P")
    {
        Send {w up}
    }
Return