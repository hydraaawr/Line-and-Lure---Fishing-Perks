Scriptname LLFP_SupplyActivation extends ObjectReference  

Actor Property PlayerRef auto
Keyword Property _LLFP_IsTemperateStream auto
Perk Property _LLFP_DetectBiome_Perk auto
Spell Property _LLFP_FishingSkillCDSpell auto
MagicEffect Property _LLFP_FishingSkillCDEffect auto


Event OnActivate(ObjectReference akActionRef) 

    if(akActionRef == PlayerRef)
        ; TODO antispam when no fishing rod activated
        Debug.Notification("Supplies activated")

        ;; Skill Up system ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        if(!PlayerRef.HasMagicEffect(_LLFP_FishingSkillCDEffect)) ; Antiexploit CD
            Utility.Wait(2)
            CustomSkills.IncrementSkill("fishing")
            PlayerRef.DoCombatSpellApply(_LLFP_FishingSkillCDSpell,PlayerRef) ; Antiexploit CD

        
        endif

        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
       
        if(PlayerRef.HasPerk(_LLFP_DetectBiome_Perk) && self.HasKeyword(_LLFP_IsTemperateStream))
            Utility.Wait(1)
            Debug.Notification("You are fishing in a temperate stream")

        endIf
        
        
    endIf

endEvent