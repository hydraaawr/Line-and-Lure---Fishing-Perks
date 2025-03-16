Scriptname LLFP_SupplyActivation extends ObjectReference  

Actor Property PlayerRef auto
Keyword Property _LLFP_IsTemperateStream auto
Perk Property _LLFP_DetectBiome_Perk01 auto


Event OnActivate(ObjectReference akActionRef)

    if(akActionRef == PlayerRef)

        Debug.Notification("Supplies activated")

        if(PlayerRef.HasPerk(_LLFP_DetectBiome_Perk01) && self.HasKeyword(_LLFP_IsTemperateStream))

            Utility.Wait(1)
            Debug.Notification("You are fishing in a temperate stream")

        endIf
        
        
    endIf

endEvent