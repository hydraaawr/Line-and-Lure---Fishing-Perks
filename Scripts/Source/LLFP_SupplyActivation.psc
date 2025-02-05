Scriptname LLFP_SupplyActivation extends ObjectReference  


Actor Property PlayerRef auto
GlobalVariable Property _LLFP_IsFishing auto

Event OnActivate(ObjectReference akActionRef)

    if(akActionRef == PlayerRef)

        Debug.Notification("Supplies activated")
        _LLFP_IsFishing.SetValue(1)
        Utility.Wait(10) ; at least x seconds to consider you are actually fishing (antiexploit)
        CustomSkills.IncrementSkill("fishing")
        
    endIf

endEvent