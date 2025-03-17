Scriptname LLFP_SupplyActivation extends ObjectReference  
; Author: Hydraaawr https://github.com/hydraaawr; https://www.nexusmods.com/users/83984133

Actor Property PlayerRef auto
Keyword Property _LLFP_IsTemperateStream auto
Keyword Property _LLFP_IsTemperateLake auto
Keyword Property _LLFP_IsArctic auto
Keyword Property _LLFP_IsCave auto
Perk Property _LLFP_DetectBiome_Perk01 auto


Event OnActivate(ObjectReference akActionRef)

    if(akActionRef == PlayerRef)

        ;Debug.Notification("Supplies activated")

        if(PlayerRef.HasPerk(_LLFP_DetectBiome_Perk01))

            Utility.Wait(2)

            if(self.HasKeyword(_LLFP_IsTemperateStream))

            
            Debug.Notification("You are fishing in a temperate stream biome")

            elseif(self.HasKeyword(_LLFP_IsTemperateLake))

            
                Debug.Notification("You are fishing in a temperate lake biome")

            

            elseif(self.HasKeyword(_LLFP_IsArctic))

                
                Debug.Notification("You are fishing in a freezing waters biome")

            

            elseif(self.HasKeyword(_LLFP_IsCave))

                
                Debug.Notification("You are fishing in an underground biome")
            endif
        endIf
    endif
endEvent