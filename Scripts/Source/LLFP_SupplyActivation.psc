Scriptname LLFP_SupplyActivation extends ObjectReference  

Actor Property PlayerRef auto
;GlobalVariable Property _LLFP_IsFishing auto
Keyword Property _LLFP_IsTemperateStream auto
Perk Property _LLFP_DetectBiome_Perk auto


Event OnActivate(ObjectReference akActionRef)

    if(akActionRef == PlayerRef)
        ; TODO antispam when no fishing rod activated
        Debug.Notification("Supplies activated")
        ;_LLFP_IsFishing.SetValue(1)
        Utility.Wait(5) ; at least x seconds to consider you are actually fishing (antiexploit)
        CustomSkills.IncrementSkill("fishing")
        Utility.Wait(1)
       
        if(PlayerRef.HasPerk(_LLFP_DetectBiome_Perk) && self.HasKeyword(_LLFP_IsTemperateStream))

            Debug.Notification("You are fishing in a temperate stream")

        endIf
        
        
    endIf

endEvent