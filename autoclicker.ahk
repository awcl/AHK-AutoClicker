#SingleInstance Force
#MaxThreadsPerHotkey 1

clickDelayInMs = 1 ; Required: should be >=1
mouseMoveToPause = true ; Required: False prevents mouse movement pausing AutoClicking after toggleClickKeys are used
; https://www.autohotkey.com/docs/v1/KeyList.htm
killProcessKey := "Esc" ; Required
toggleClickKey1 := "" ; Optional: both toggles must be pressed if not ""
toggleClickKey2 := "RAlt" ; Optional: both toggles must be pressed if not ""
holdClickKey := "\" ; Optional: Is not effected by mouseMoveToPause

Hotkey, %killProcessKey%, KillProcessHandler
if (toggleClickKey1 != "" and toggleClickKey2 != "") {
	Hotkey, %toggleClickKey1% & %toggleClickKey2%, ToggleClickLoopHandler
	Hotkey, %toggleClickKey2% & %toggleClickKey1%, ToggleClickLoopHandler
} else if (toggleClickKey1 != "" and toggleClickKey2 = "") {
	Hotkey, %toggleClickKey1%, ToggleClickLoopHandler
} else if (toggleClickKey2 != "" and toggleClickKey1 = "") {
	Hotkey, %toggleClickKey2%, ToggleClickLoopHandler
}
if (holdClickKey != "") {
    Hotkey, %holdClickKey%, HoldClickLoopHandler
    Hotkey, %holdClickKey% Up, HoldClickUpHandler
}
return

KillProcessHandler:
    ExitApp
return

ToggleClickLoopHandler:
    Toggle := !Toggle
    if (Toggle) {
        MouseGetPos, PrevX, PrevY
        SetTimer, ToggleClickLoop, %clickDelayInMs%
    } else {
        SetTimer, ToggleClickLoop, Off
    }
return

ToggleClickLoop:
    MouseGetPos, CurrX, CurrY
	if ((%mouseMoveToPause% and (PrevX != CurrX or PrevY != CurrY)) or GetKeyState(holdClickKey, "P")) {
		Toggle := false
		SetTimer, ToggleClickLoop, Off
	} else if (Toggle) {
		Click, Left
	}
return

HoldClickLoopHandler:
    if (GetKeyState(holdClickKey, "P")) {
        ToggleHold := true
        SetTimer, HoldClickLoop, %clickDelayInMs%
    }
return

HoldClickUpHandler:
    ToggleHold := false
    SetTimer, HoldClickLoop, Off
return

HoldClickLoop:
    if (ToggleHold) {
        Click, Left
    }
return
