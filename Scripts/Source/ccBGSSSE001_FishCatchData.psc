scriptname ccBGSSSE001_FishCatchData extends ccBGSSSE001_CatchData
{ Script for defining caught fish. }

Potion property fishFood auto
{ (FILL ONLY ONE FISH PROPERTY) Food fish. }

Ingredient property fishIngredient auto
{(FILL ONLY ONE FISH PROPERTY) Alchemy ingredient fish. }

MiscObject property fishMiscObject auto
{ (FILL ONLY ONE FISH PROPERTY) MiscItem fish. }

Float[] property catchSequence auto
{ Defines the sequence of nibbles before a catch. Positive values: Nibble, then wait (float) seconds. 0.0: End sequence and tug line }

bool property isSmallFish auto
{ Is this a small fish? (Otherwise, this is a large fish.) }

Weapon property requiredRod auto
{ The rod required to catch this fish. }

Actor Property PlayerRef auto
Perk Property _LLFP_MoreCatch_Perk01 auto

Int property _LLFP_CaughtCount = 0 auto ; getCaughtObject activates 2 times; this prevents from llfp system launching twice

Form function getCaughtObject()
	Debug.Notification("_LLFP_CaughtCount1 = " + _LLFP_CaughtCount)
	_LLFP_CaughtCount+=1
	if _LLFP_CaughtCount > 1 && PlayerRef.hasPerk(_LLFP_MoreCatch_Perk01) ; if catch detected (doesnt work with misc) and has perk
		Debug.Notification("Adding catch to inventory")
		_LLFP_CaughtCount = 0 ; Reset
	endif
	if fishFood
		;Debug.Notification("fishfood obtained")
		return fishFood
	elseif fishIngredient
		;Debug.Notification("fishingredient obtained")
		return fishIngredient
	elseif fishMiscObject
		;Debug.Notification("fishmisc obtained")
		return fishMiscObject
	else
		return None
	endif
	
endFunction

float[] function getCatchSequence()
	return catchSequence
endFunction

int function getCatchType()
	if isSmallFish
		return ccBGSSSE001_CatchTypeSmallFish.GetValueInt()
	else
		return ccBGSSSE001_CatchTypeLargeFish.GetValueInt()
	endif
endFunction

Weapon function getRequiredRod()
	return requiredRod
endFunction