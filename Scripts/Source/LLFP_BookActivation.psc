Scriptname LLFP_BookActivation extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Message Property _LLFP_SkillMenuPrompt auto




Event OnActivate(ObjectReference akActionRef)


    if (akActionRef == PlayerRef)
        ;self.BlockActivation(TRUE)
        if(_LLFP_SkillMenuPrompt.Show() == 0)

            Game.DisablePlayerControls(False, False, False, False, False, True) ; prevents book from opening part1
            CustomSkills.OpenCustomSkillMenu("fishing")
            Game.EnablePlayerControls(False, False, False, False, False, True) ; prevents book from opening part2
            
        endif
    
    endif

EndEvent




