Scriptname LLFP_QuestScript extends Quest
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Form property LastCaughtObject Auto

Event OnInit()

    Debug.Notification("Line and Lure Initialized")
    RegisterForUpdate(5)
    
EndEvent


Event OnUpdate()
    Debug.Notification(LastCaughtObject.GetFormID())

EndEvent