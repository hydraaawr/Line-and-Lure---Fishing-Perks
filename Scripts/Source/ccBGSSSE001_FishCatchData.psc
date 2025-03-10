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

;; LLFP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LLFP_FishAliasScript Property FishAliasScript auto 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; LLFP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
Form function getCaughtObject()
	Debug.Notification("Getting caught object...")
	Form caughtObject = None
	
	if fishFood
		caughtObject = fishFood
	elseif fishIngredient
		caughtObject = fishIngredient
	elseif fishMiscObject
		caughtObject = fishMiscObject
	endif
	; Capture object for later use
	FishAliasScript.LastCaughtObject = caughtObject
	;;;;;;;;
	return caughtObject
endFunction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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