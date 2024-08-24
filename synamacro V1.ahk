#MaxThreadsPerHotkey 2

ConfigFile := "config.txt"
SavedHotkey := ""
DebounceTime := 10
MacroVersion := "FirstPerson"

if FileExist(ConfigFile) {
    FileRead, ConfigContent, %ConfigFile%
    Loop, Parse, ConfigContent, `n, `r
    {
        IfInString, A_LoopField, hotkey=
            StringTrimLeft, SavedHotkey, A_LoopField, 7
        Else IfInString, A_LoopField, debounce=
            StringTrimLeft, DebounceTime, A_LoopField, 9
        Else IfInString, A_LoopField, version=
            StringTrimLeft, MacroVersion, A_LoopField, 8
    }
    if (SavedHotkey = "") {
        SavedHotkey := "None Set"
    }
    if (DebounceTime = "") {
        DebounceTime := 10
    }
    if (MacroVersion = "") {
        MacroVersion := "FirstPerson"
    }

    MsgBox, Loaded configuration:`nHotkey: %SavedHotkey%`nDebounce Time: %DebounceTime% ms`nMacro Version: %MacroVersion%

    if (SavedHotkey != "None Set") {
        Hotkey, %SavedHotkey%, ToggleMacro
    }
}

Gui, Font, s14 Bold, Consolas
Gui, Color, Black

Gui, Add, Text, x10 y10 w680 h20 cPurple vHeaderText, ░██████╗██╗░░░██╗███╗░░██╗░█████╗░
Gui, Add, Text, x10 y40 w680 h20 cPurple, ██╔════╝╚██╗░██╔╝████╗░██║██╔══██╗
Gui, Add, Text, x10 y70 w680 h20 cPurple, ╚█████╗░░╚████╔╝░██╔██╗██║███████║
Gui, Add, Text, x10 y100 w680 h20 cPurple, ░╚═══██╗░░╚██╔╝░░██║╚████║██╔══██║
Gui, Add, Text, x10 y130 w680 h20 cPurple, ██████╔╝░░░██║░░░██║░╚███║██║░░██║
Gui, Add, Text, x10 y160 w680 h20 cPurple, ╚═════╝░░░░╚═╝░░░╚═╝░░╚══╝╚═╝░░╚═╝

Gui, Add, Text, x10 y200 w680 h20 cWhite vCurrentHotkeyText, % "Current Hotkey: " (SavedHotkey != "" ? SavedHotkey : "None Set")
Gui, Add, Text, x10 y230 w680 h20 cWhite vCurrentDebounceText, % "Debounce Time: " DebounceTime " ms"
Gui, Add, Text, x10 y260 w680 h20 cWhite vCurrentVersionText, % "Macro Version: " MacroVersion

Gui, Add, Button, x10 y290 w680 h50 gSetHotkey vSetHotkeyButton, Set Macro Hotkey
Gui, Add, Button, x10 y350 w680 h50 gSetDebounce vSetDebounceButton, Set Debounce Time
Gui, Add, Button, x10 y410 w680 h50 gSwitchVersion vSwitchVersionButton, Switch Macro Version

GuiControl, +BackgroundTrans, SetHotkeyButton
GuiControl, +Border, SetHotkeyButton
GuiControl, +cPurple, SetHotkeyButton

GuiControl, +BackgroundTrans, SetDebounceButton
GuiControl, +Border, SetDebounceButton
GuiControl, +cPurple, SetDebounceButton

GuiControl, +BackgroundTrans, SwitchVersionButton
GuiControl, +Border, SwitchVersionButton
GuiControl, +cPurple, SwitchVersionButton

Gui, Add, Text, x10 y470 w680 h20 cBlue gOpenLink, Click here for support: https://discord.gg/hBW2P7GET2

Gui, Show, w700 h500, Syna's Macro V1.00 / #1 Roblox DH Macro
return

OpenLink:
    Run, https://discord.gg/hBW2P7GET2
return

SetHotkey:
    InputBox, NewHotkey, Set Hotkey, Please enter your new hotkey (e.g., ^!s for Ctrl+Alt+S)
    if (NewHotkey != "") {
        FileDelete, %ConfigFile%
        FileAppend, hotkey=%NewHotkey%`n, %ConfigFile%
        FileAppend, debounce=%DebounceTime%`n, %ConfigFile%
        FileAppend, version=%MacroVersion%`n, %ConfigFile%
        MsgBox, Hotkey set to: %NewHotkey%

        GuiControl,, CurrentHotkeyText, % "Current Hotkey: " NewHotkey
        
        if (SavedHotkey != "None Set") {
            Hotkey, %SavedHotkey%, Off
        }
        
        SavedHotkey := NewHotkey
        Hotkey, %NewHotkey%, ToggleMacro
    }
return

SetDebounce:
    InputBox, NewDebounce, Set Debounce Time, Please enter the new debounce time in milliseconds (default is 10)
    if (NewDebounce != "" && NewDebounce >= 1) {
        FileDelete, %ConfigFile%
        FileAppend, hotkey=%SavedHotkey%`n, %ConfigFile%
        FileAppend, debounce=%NewDebounce%`n, %ConfigFile%
        FileAppend, version=%MacroVersion%`n, %ConfigFile%
        MsgBox, Debounce time set to: %NewDebounce% ms

        GuiControl,, CurrentDebounceText, % "Debounce Time: " NewDebounce " ms"

        DebounceTime := NewDebounce
    }
return

SwitchVersion:
    if (MacroVersion = "FirstPerson") {
        MacroVersion := "ThirdPerson"
        MsgBox, Switched to Third Person Macro
    } else {
        MacroVersion := "FirstPerson"
        MsgBox, Switched to First Person Macro
    }
    FileDelete, %ConfigFile%
    FileAppend, hotkey=%SavedHotkey%`n, %ConfigFile%
    FileAppend, debounce=%DebounceTime%`n, %ConfigFile%
    FileAppend, version=%MacroVersion%`n, %ConfigFile%
    GuiControl,, CurrentVersionText, % "Macro Version: " MacroVersion
return

Toggle := false

ToggleMacro:
    Toggle := !Toggle
    if (Toggle)
        SetTimer, MacroLoop, %DebounceTime%
    else
        SetTimer, MacroLoop, Off
return

MacroLoop:
    if (MacroVersion = "FirstPerson") {
        Send, {Blind}{WheelUp}
        Sleep, 10
        Send, {Blind}{WheelDown}
    } else if (MacroVersion = "ThirdPerson") {
        Send, {Blind}i
        Sleep, %DebounceTime%
        Send, {Blind}o
    }
return

GuiClose:
ExitApp
