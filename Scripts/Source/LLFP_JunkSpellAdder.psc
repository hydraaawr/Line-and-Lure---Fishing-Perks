Scriptname LLFP_JunkSpellAdder extends activemagiceffect  


Actor Property PlayerRef auto
Spell Property _LLFP_JunkSpell auto
Spell Property _LLFP_JunkSpellAddAb auto

Event OnEffectStart(Actor akTarget, Actor akCaster)

    if(akTarget == PlayerRef)

        PlayerRef.AddSpell(_LLFP_JunkSpell)
        PlayerRef.DispelSpell(_LLFP_JunkSpellAddAb)

    endIf

EndEvent