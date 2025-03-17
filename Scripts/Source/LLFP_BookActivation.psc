Scriptname LLFP_BookActivation extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Message Property _LLFP_SkillMenuPrompt auto



;; Reading directly from floor

Event OnActivate(ObjectReference akActionRef)


    if (akActionRef == PlayerRef)

        if(_LLFP_SkillMenuPrompt.Show() == 0)

            Game.DisablePlayerControls(False, False, False, False, False, True) ; prevents book from opening part1
            CustomSkills.OpenCustomSkillMenu("fishing")
            Game.EnablePlayerControls(False, False, False, False, False, True) ; prevents book from opening part2
            
        endif
    
    endif

EndEvent


;; Opening from inventory

Event OnEquipped(Actor aKActor)


    if (aKActor == PlayerRef)

        if(_LLFP_SkillMenuPrompt.Show() == 0)
            Game.FadeOutGame(false, true, 2.0, 1.0) ; prevents showing ugly open-close animation
            Game.DisablePlayerControls(False, False, False, False, False, True) ; prevents book from opening part1
            CustomSkills.OpenCustomSkillMenu("fishing")
            Game.EnablePlayerControls(False, False, False, False, False, True) ; prevents book from opening part2
            
        endif
    
    endif

EndEvent
