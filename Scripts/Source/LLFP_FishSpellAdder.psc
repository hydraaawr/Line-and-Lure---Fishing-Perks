Scriptname LLFP_FishSpellAdder extends activemagiceffect  


Actor Property PlayerRef auto
Spell Property _LLFP_FishSpell auto
Spell Property _LLFP_FishSpellAddAb auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

    if(akTarget == PlayerRef)

        PlayerRef.AddSpell(_LLFP_FishSpell)
        PlayerRef.DispelSpell(_LLFP_FishSpellAddAb)

    endIf

EndEvent