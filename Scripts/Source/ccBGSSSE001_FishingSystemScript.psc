Scriptname ccBGSSSE001_FishingSystemScript extends Quest  
{ 
  The system that handles all fishing gameplay mechanics.
  Interacts with Fishing Supplies (ccBGSSSE001_FishingActScript), which maintain some local state.
}

Import Utility
Import TrueDirectionalMovement

;/ 
 / ==========================
 /  CONSTANTS
 / ==========================
 /;

;/ 
 / Biome Type Constants
 /;
int property BIOME_TYPE_STREAM = 0 AutoReadOnly
int property BIOME_TYPE_LAKE = 1 AutoReadOnly
int property BIOME_TYPE_ARCTIC = 2 AutoReadOnly
int property BIOME_TYPE_CAVE = 3 AutoReadOnly

;/ 
 / Animation Constants
 /;
string property RESET_ANIM = "Reset" AutoReadOnly
string property CAST_ANIM = "Cast" AutoReadOnly
string property LINETUG_ANIMVAR = "iFishBite" AutoReadOnly
string property POPULATION_ANIMVAR = "iFishPopulation" AutoReadOnly
string property LINETUG_FISH_ANIM = "BiteFish" AutoReadOnly
string property LINETUG_OBJECT_ANIM = "BiteObject" AutoReadOnly
string property POPULATION_EMPTY_ANIM = "IdleEmpty" AutoReadOnly
string property POPULATION_SPARSE_ANIM = "IdleSparse" AutoReadOnly
string property POPULATION_FULL_ANIM = "IdleFull" AutoReadOnly
string property EXIT_ANIM = "Exit" AutoReadOnly
string property FASTEXIT_ANIM = "FastExit" AutoReadOnly
string property NIBBLE_ANIM = "Nibble" AutoReadOnly
string property CATCH_SUCCESS_ANIM = "CatchSuccess" AutoReadOnly
string property CATCH_FAILURE_ANIM = "CatchFail" AutoReadOnly
string property TIMEOUT_ANIM = "Timeout" AutoReadOnly

float property LINETUG_TYPE_NONE = 1.0 AutoReadOnly
float property LINETUG_TYPE_NIBBLE = 2.0 AutoReadOnly
float property LINETUG_TYPE_TUGFISH = 3.0 AutoReadOnly
float property LINETUG_TYPE_TUGOBJECT = 4.0 AutoReadOnly

;/
 / Update Types
 /;
int property UPDATETYPE_START = 1 AutoReadOnly
int property UPDATETYPE_SEQUENCE = 2 AutoReadOnly
int property UPDATETYPE_CATCHTIMEOUT = 3 AutoReadOnly
int property UPDATETYPE_SETQUESTSTAGE = 4 AutoReadOnly

;/ 
 / Catch Type Constants
 /;
GlobalVariable property ccBGSSSE001_CatchTypeSmallFish auto ; constant
GlobalVariable property ccBGSSSE001_CatchTypeLargeFish auto ; constant
GlobalVariable property ccBGSSSE001_CatchTypeObject auto ; constant

;/
 / Duration Constants
 /;
float property DURATION_INITIAL_WAITING_PERIOD = 5.0 AutoReadOnly
float property DURATION_INITIAL_WAITING_PERIOD_VARIANCE = 2.0 AutoReadOnly
float property DURATION_SHOWPOPULATION = 3.0 AutoReadOnly
float property DURATION_SHEATHEWEAPON = 1.1 AutoReadOnly
float property DURATION_CAST = 3.0 AutoReadOnly
float property DURATION_NIBBLE = 0.5 AutoReadOnly
float property DURATION_EXIT = 1.5 AutoReadOnly
float property DURATION_FASTEXIT = 0.5 AutoReadOnly
float property DURATION_CATCH = 1.0 AutoReadOnly
float property DURATION_SUCCESSVIEW = 1.8 AutoReadOnly
float property DURATION_FADETOBLACKCROSSFADE = 0.3 AutoReadOnly
float property DURATION_JUNKITEMCATCHTIME = 3.5 AutoReadOnly
float property DURATION_CATCHTIMEOUT = 5.0 AutoReadOnly
float property DURATION_RODLOADTIME = 0.15 AutoReadOnly
float property DURATION_HOOKED_ANIM_WAIT = 0.35 AutoReadOnly

;/
 / Rumble Constants
 /;
float property RUMBLE_DURATION_CAST = 0.6 AutoReadOnly
float property RUMBLE_STRENGTH_CAST_LEFT = 0.09 AutoReadOnly
float property RUMBLE_STRENGTH_CAST_RIGHT = 0.0 AutoReadOnly

float property RUMBLE_DURATION_NIBBLE = 0.45 AutoReadOnly
float property RUMBLE_STRENGTH_NIBBLESMALL_LEFT = 0.5 AutoReadOnly
float property RUMBLE_STRENGTH_NIBBLESMALL_RIGHT = 0.0 AutoReadOnly
float property RUMBLE_STRENGTH_NIBBLELARGE_LEFT = 0.0 AutoReadOnly
float property RUMBLE_STRENGTH_NIBBLELARGE_RIGHT = 0.6 AutoReadOnly

float property RUMBLE_DURATION_HOOKED = 0.45 AutoReadOnly
float property RUMBLE_STRENGTH_HOOKEDLARGEFISH_LEFT = 0.2 AutoReadOnly
float property RUMBLE_STRENGTH_HOOKEDLARGEFISH_RIGHT = 0.65 AutoReadOnly
float property RUMBLE_STRENGTH_HOOKEDSMALLFISH_LEFT = 1.0 AutoReadOnly
float property RUMBLE_STRENGTH_HOOKEDSMALLFISH_RIGHT = 0.05 AutoReadOnly

float property RUMBLE_STRENGTH_HOOKEDOBJECT_LEFT = 0.5 AutoReadOnly
float property RUMBLE_STRENGTH_HOOKEDOBJECT_RIGHT = 0.0 AutoReadOnly

float property RUMBLE_DURATION_HOOKEDCONSTANT = 2.0 AutoReadOnly

float property RUMBLE_STRENGTH_HOOKED_LEFTCONSTANT = 0.6 AutoReadOnly
float property RUMBLE_STRENGTH_HOOKED_RIGHTCONSTANT = 0.0 AutoReadOnly

float property RUMBLE_STRENGTH_HOOKEDLARGEFISH_LEFTCONSTANT = 0.6 AutoReadOnly
float property RUMBLE_STRENGTH_HOOKEDLARGEFISH_RIGHTCONSTANT = 0.1 AutoReadOnly

float property RUMBLE_DURATION_SUCCESS = 0.4 AutoReadOnly
float property RUMBLE_STRENGTH_SUCCESSSMALLFISH_LEFT = 1.0 AutoReadOnly
float property RUMBLE_STRENGTH_SUCCESSSMALLFISH_RIGHT = 0.08 AutoReadOnly
float property RUMBLE_STRENGTH_SUCCESSLARGEFISH_LEFT = 0.1 AutoReadOnly
float property RUMBLE_STRENGTH_SUCCESSLARGEFISH_RIGHT = 1.0 AutoReadOnly
float property RUMBLE_STRENGTH_SUCCESSOBJECT_LEFT = 0.6 AutoReadOnly
float property RUMBLE_STRENGTH_SUCCESSOBJECT_RIGHT = 0.1 AutoReadOnly

float property RUMBLE_DURATION_FAILURE = 0.4 AutoReadOnly
float property RUMBLE_STRENGTH_FAILURE_LEFT = 1.0 AutoReadOnly
float property RUMBLE_STRENGTH_FAILURE_RIGHT = 0.0 AutoReadOnly

;/ 
 / Fish Population Constants
 /;
int property BASE_POPULATION = 4 AutoReadOnly
int property BASE_BONUS_MIN = 1 AutoReadOnly
int property BASE_BONUS_MAX = 2 AutoReadOnly
int property RAIN_BONUS_MIN = 1 AutoReadOnly
int property RAIN_BONUS_MAX = 3 AutoReadOnly
int property MORNINGEVENING_BONUS_MIN = 2 AutoReadOnly
int property MORNINGEVENING_BONUS_MAX = 3 AutoReadOnly
int property POPULATION_COUNT_FULL = 4 AutoReadOnly
float property POPULATION_TYPE_EMPTY = 1.0 AutoReadOnly
float property POPULATION_TYPE_SPARSE = 2.0 AutoReadOnly
float property POPULATION_TYPE_FULL = 3.0 AutoReadOnly

;/ 
 / Time
 /;
float property GAMETIME_MORNING = 6.0 AutoReadOnly
float property GAMETIME_LATEMORNING = 9.0 AutoReadOnly
float property GAMETIME_EVENING = 18.0 AutoReadOnly
float property GAMETIME_LATEEVENING = 21.0 AutoReadOnly

;/ 
 / Catch Chance Constants
 /;
float property BASE_CATCH_THRESHOLD_IS_FISH = 0.1 AutoReadOnly
float property BASE_CATCH_THRESHOLD_SMALL = 0.5 AutoReadOnly
{ 50% chance of Small fish catch. Rods modify this by 25% up (Alik'ri) or down (Argonian, so, greater chance to catch Large fish).}

float property BASE_CATCH_THRESHOLD_COMMONFISH = 0.25 AutoReadOnly
float property BASE_CATCH_THRESHOLD_UNCOMMONFISH = 0.03 AutoReadOnly
float property BASE_CATCH_THRESHOLD_COMMONJUNK = 0.35 AutoReadOnly
float property BASE_CATCH_THRESHOLD_UNCOMMONJUNK = 0.03 AutoReadOnly

float property SPECIAL_FISH_RODS_COMMONFISH_THRESHOLD_ADJUST = 0.2 AutoReadOnly
float property SPECIAL_FISH_RODS_UNCOMMONFISH_THRESHOLD_ADJUST = 0.07 AutoReadOnly
float property MORNING_EVENING_COMMONFISH_THRESHOLD_ADJUST = 0.1 AutoReadOnly
float property MORNING_EVENING_UNCOMMONFISH_THRESHOLD_ADJUST = 0.05 AutoReadOnly

float property SPECIAL_JUNK_RODS_COMMONJUNK_THRESHOLD_ADJUST = 0.3 AutoReadOnly
float property SPECIAL_JUNK_RODS_UNCOMMONJUNK_THRESHOLD_ADJUST = 0.06 AutoReadOnly

float property SPECIAL_JUNK_RODS_COMMONJUNK_BONUS = 0.2 AutoReadOnly
float property SPECIAL_JUNK_RODS_UNCOMMONJUNK_BONUS = 0.07 AutoReadOnly

;/ 
 / Catch List Indexes
 /;

int property RARITY_LIST_COMMON_INDEX = 0 AutoReadOnly
int property RARITY_LIST_UNCOMMON_INDEX = 1 AutoReadOnly
int property RARITY_LIST_RARE_INDEX = 2 AutoReadOnly

int property SIZE_LIST_SMALLFISH_INDEX = 0 AutoReadOnly
int property SIZE_LIST_LARGEFISH_INDEX = 1 AutoReadOnly

;/ 
 / Rod Type Constants
 /;
int property RODTYPE_NONE = -1 AutoReadOnly
int property RODTYPE_STANDARD = 0 AutoReadOnly
int property RODTYPE_ALIKRI = 1 AutoReadOnly
int property RODTYPE_ARGONIAN = 2 AutoReadOnly
int property RODTYPE_DWARVEN = 3 AutoReadOnly

;/ 
 / System State
 /;
int property SYSTEMSTATE_IDLE = 0 AutoReadOnly
int property SYSTEMSTATE_SETTINGUP = 1 AutoReadOnly
int property SYSTEMSTATE_FISHING = 2 AutoReadOnly
int property SYSTEMSTATE_NIBBLE = 3 AutoReadOnly
int property SYSTEMSTATE_HOOKED = 4 AutoReadOnly
int property SYSTEMSTATE_CATCH_RESOLVE = 5 AutoReadOnly
int property SYSTEMSTATE_CLEANUP = 6 AutoReadOnly

;/ 
 / ==========================
 /  PROPERTIES
 / ==========================
 /;

;/ 
 / Catch Lists
 /;
FormList property ccBGSSSE001_FishCatchDataListTemperateStreamClear auto
{ The temperate stream (clear weather) fish list to draw from. }
FormList property ccBGSSSE001_FishCatchDataListTemperateStreamRain auto
{ The temperate stream (rain weather) fish list to draw from. }
FormList property ccBGSSSE001_FishCatchDataListTemperateLakeClear auto
{ The temperate lake (clear weather) fish list to draw from. }
FormList property ccBGSSSE001_FishCatchDataListTemperateLakeRain auto
{ The temperate lake (rain weather) fish list to draw from. }
FormList property ccBGSSSE001_FishCatchDataListArctic auto
{ The arctic fish list to draw from. }
FormList property ccBGSSSE001_FishCatchDataListCave auto
{ The cave fish list to draw from. }
FormList property ccBGSSSE001_JunkCatchDataListDefault auto
{ The junk list to draw from. }
FormList property ccBGSSSE001_OneTimeCaughtList auto
{ FormList of Catch Data that are flagged as one-time-only and have already been caught.}

;/ 
 / Fishing Rods and Equipment
 /;
FormList property ccBGSSSE001_FishingRodFXActivators auto
{ A formlist of all fishing rod FX activators. }
FormList property ccBGSSSE001_FishingRods auto
{ A formlist of all fishing rod weapons. }
Keyword property ccBGSSSE001_SummonsRain auto
{ The equipment keyword that will cause rainstorms when fishing if wearing that equipment. }
Light property Torch01 auto

;/ 
 / Messages
 /;
GlobalVariable property ccBGSSSE001_ShowedReelPromptThisSession auto
GlobalVariable property ccBGSSSE001_ShowedCatchPromptThisSession auto
GlobalVariable property ccBGSSSE001_FishingTutorialDisplayed auto
GlobalVariable property ccBGSSSE001_FishingDebugEnabled auto ; constant
Message property ccBGSSSE001_FishingTutorial auto
Message property ccBGSSSE001_ErrorNoFishCombat auto
Message property ccBGSSSE001_ErrorNoFishJumping auto
Message property ccBGSSSE001_ErrorNoFishMounted auto
Message property ccBGSSSE001_ErrorNoFishSitting auto
Message property ccBGSSSE001_ErrorRodRequired auto
Message property ccBGSSSE001_ReelLinePrompt auto
Message property ccBGSSSE001_CatchPrompt auto
Message property ccBGSSSE001_fishingEarlyReel auto
Message property ccBGSSSE001_fishingEarlyReelNibble auto
Message property ccBGSSSE001_fishingHooked auto
Message property ccBGSSSE001_fishingLostCatch auto

;/ 
 / Sounds
 /;
Sound property ccBGSSSE001_ITMFishUpSM auto
{ Item fanfare sound. }
Sound property ccBGSSSE001_RareCatchSM auto
{ Rare catch success sound. }
Sound property ccBGSSSE001_CatchSuccessSM auto
{ Catch success sound. }

;/ 
 / Imagespace Modifiers
 /;
ImagespaceModifier property ccBGSSSE001_CatchSuccessDOF auto
ImageSpaceModifier property ccBGSSSE001_FadeToBlackImod auto
ImageSpaceModifier property ccBGSSSE001_FadeToBlackHoldImod auto
ImageSpaceModifier property ccBGSSSE001_FadeToBlackBackImod auto

;/
 / Followers
 /;
Quest property ccBGSSSE001_FishingFollowerIdleQuest auto
{ The follower idle quest to help keep followers out of the way when the player is fishing. }
ReferenceAlias property FollowerAlias auto
{ The follower alias from the idle quest. }
ReferenceAlias property DogAlias auto
{ The dog alias from the idle quest. }

;/ 
 / Misc
 /;
Actor property PlayerRef auto
GlobalVariable property GameHour auto
Static property XMarker auto
ccBGSSSE001_DialogueDetectScript property DialogueQuest auto
{ The dialogue detection system quest. }
Quest property ccBGSSSE001_Start_MQ2 auto
{ The quest to start after the player has caught a fish at least once. }
GlobalVariable property ccBGSSSE001_HasCaughtFishAtLeastOnce auto
{ The global that tracks whether or not the player has caught a fish at least once. }
ObjectReference property ReelLineRef auto
{ A reference to ccBGSSSE001ReelLineAct in aaaMarkers cell. Trigger volume for player activation. }
ccBGSSSE001_MoveDetectScript property MoveDetectRef auto
{ A reference to ccBGSSSE001MoveDetectAct in aaaMarkers cell. Trigger volume for detecting player movement. }
ObjectReference property ccBGSSSE001_NavBlockerRef auto
{ A reference to ccBGSSSE001_NavBlockerRef in aaaMarkers cell. Collision navcut volume to help prevent NPCs pushing the player. }
Light property ccBGSSSE001_CatchSuccessLight auto
{ The light to display when an object is caught. }
Weather property SkyrimStormRain auto
{ The weather to force to when wearing equipment that summons rain. }

;;;;;;;;;; LLFP;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; More catch perk
Perk Property _LLFP_MoreCatch_Perk01 auto
LLFP_QuestScript Property QuestScript auto

;; MoreRarityFish perk
GlobalVariable Property _LLFP_CommonFishBonus auto ; Default: .03
GlobalVariable Property _LLFP_UnCommonFishBonus auto; Default: .01

Perk Property _LLFP_MoreRarityFish_Perk01 auto
;; Default values of the following globals related to MoreRarityFish 1 result in a global default of 62% chance of common, 34% uncommon, 4% rare
GlobalVariable Property _LLFP_FishBonusMult01 auto ;  default: 1

Perk Property _LLFP_MoreRarityFish_Perk02 auto
;; Default values of the following globals related to MoreRarityFish 2 result in a global default of 59% chance of common, 36% uncommon, 5% rare
GlobalVariable Property _LLFP_FishBonusMult02 auto ;  default: 2

Perk Property _LLFP_MoreRarityFish_Perk03 auto
;; Default values of the following globals related to MoreRarityFish 3 result in a global default of 56% chance of common, 38% uncommon, 6% rare
GlobalVariable Property _LLFP_FishBonusMult03 auto ;  default: 3

;; MoreRarityJunk perk
GlobalVariable Property _LLFP_CommonJunkBonus auto ; Default: .03
GlobalVariable Property _LLFP_UnCommonJunkBonus auto; Default: .01

Perk Property _LLFP_MoreRarityJunk_Perk01 auto
;; Default values of the following globals related to MoreRarityJunk 1 result in a global default of 62% chance of common, 34% uncommon, 4% rare
GlobalVariable Property _LLFP_JunkBonusMult01 auto ;  default: 1

Perk Property _LLFP_MoreRarityJunk_Perk02 auto
;; Default values of the following globals related to MoreRarityJunk 2 result in a global default of 59% chance of common, 36% uncommon, 5% rare
GlobalVariable Property _LLFP_JunkBonusMult02 auto ;  default: 2

Perk Property _LLFP_MoreRarityJunk_Perk03 auto
;; Default values of the following globals related to MoreRarityJunk 3 result in a global default of 56% chance of common, 38% uncommon, 6% rare
GlobalVariable Property _LLFP_JunkBonusMult03 auto ;  default: 3

;; Fishspell perk
Perk Property _LLFP_FishSpell_Perk01 auto
MagicEffect Property _LLFP_FishSpellEffect auto

;; JunkSpell Perk
Perk Property _LLFP_JunkSpell_Perk01 auto
MagicEffect Property _LLFP_JunkSpellEffect auto

;; Less casting time Perk
Perk Property _LLFP_LessCastingTime_Perk01 auto
GlobalVariable Property _LLFP_CastingTimeRed01 auto ; fishing time reduction. Default = .2
Perk Property _LLFP_LessCastingTime_Perk02 auto
GlobalVariable Property _LLFP_CastingTimeRed02 auto ; fishing time reduction. Default = .4
Perk Property _LLFP_LessCastingTime_Perk03 auto
GlobalVariable Property _LLFP_CastingTimeRed03 auto ; fishing time reduction. Default = .6
float property initTime auto ;; DEBUG


GlobalVariable Property _LLFP_SkillAdvanceMult auto
Bool Property FishCaught auto 

;; LLFP: SFO compat properties
Idle Property IdleStop_Loose  Auto  

Idle Property IdleSearchingChest Auto

Idle Property idlecowerexit Auto

idle property idlecoweringloose auto

GlobalVariable Property AnimatedFishing_Global Auto

GlobalVariable Property RodHeight Auto

GlobalVariable Property BaitReq Auto

GlobalVariable Property FishingCamera Auto

weapon weapon1

weapon weapon2

Message Property AnimatedFishing_NoBait Auto

Formlist Property AnimatedFishing_Bait Auto

Bool WasInThird
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;/ 
 / ==========================
 /  SYSTEM STATE
 / ==========================
 /;
int currentSystemState = 0 ;SYSTEMSTATE_IDLE
bool isQuestItemCatch = false
bool lastCatchWasRare = false
bool startedInFirstPerson = false
bool startedWithTorch = false
ccBGSSSE001_CatchData nextCatchData = None
FormList nextCatchDataSourceList = None
float currentGameHour = 0.0
int currentCatchSequenceIndex = 0
int currentFishingRodType = -1
int nextUpdateType = 0
ObjectReference fishingRodActivator = None
ccBGSSSE001_FishingActScript currentFishingSupplies
ccBGSSSE001_FishingActScript lastFishingSupplies
bool debugEnabled = false
bool forcedRainWeather = false
Weather previousWeather = None

;/ 
 / ==========================
 /  LOCKS
 / ==========================
 /;
bool handlingInputOrUpdate = false

;/
 / Radiant Quests
 /;

ccBGSSSE001_RadiantFishEventListener RadiantFishEventListener
; An event listener that can register with the Fishing System that will get updates when fish and items are caught.

;/ 
 / ==========================
 /  EVENTS
 / ==========================
 /;

Event OnInit()

	Debug.Notification("Line and Lure Initialized")


EndEvent



Event OnUpdate()
	; Player input and updates can both change system state, only allow one to run at a time.
	; In terms of UX, it is acceptable if we wait to process this update until the input handling is complete.
	while handlingInputOrUpdate
		Utility.Wait(0.25)
	endWhile
	handlingInputOrUpdate = true

	FishingDebug("Got update...")

	if !IsValidUpdateSystemState()
		FishingDebug("System state not valid for updating, exiting.")
		handlingInputOrUpdate = false
		return
	endif

	if nextUpdateType == UPDATETYPE_START
		FishingDebug("    ...start")
		; We've waited the initial waiting period after showing
		; the population count. Move on to the catch sequence.
		RegisterForNextUpdate(UPDATETYPE_SEQUENCE)

	elseif nextUpdateType == UPDATETYPE_SEQUENCE
		FishingDebug("    ...sequence")

		if !nextCatchData
			FishingDebug("    ...did not have catch data. Abort.")
			CatchFail(true)
		endif

		if IsFishCatchType(nextCatchData.getCatchType())
			float[] catchSequence = nextCatchData.getCatchSequence()
			if catchSequence
				if currentCatchSequenceIndex > (catchSequence.Length - 1) || catchSequence[currentCatchSequenceIndex] == 0.0
					currentSystemState = SYSTEMSTATE_HOOKED
					
					FishingDebug("    ...caught a fish!")
					
					PlayHookedFishAnimation()
					ShowCatchPrompt()
					RegisterForNextUpdate(UPDATETYPE_CATCHTIMEOUT)
				else
					currentSystemState = SYSTEMSTATE_NIBBLE
					
					FishingDebug("        ...nibble!")
					PlayNibbleAnimation()

					RegisterForNextUpdate(UPDATETYPE_SEQUENCE)
					currentCatchSequenceIndex += 1
				endif
			else
				FishingDebug("    ...failed to obtain a valid catch sequence. Abort.")
				CatchFail(true)
			endif
		else
			currentSystemState = SYSTEMSTATE_HOOKED
			FishingDebug("            ...caught an object!")
			
			ShowCatchPrompt()
			PlayHookedObjectAnimation()
			RegisterForNextUpdate(UPDATETYPE_CATCHTIMEOUT)
		endif

	elseif nextUpdateType == UPDATETYPE_CATCHTIMEOUT && IsInExitableSystemState()
		currentSystemState = SYSTEMSTATE_CATCH_RESOLVE
		FishingDebug("        ...catch timeout!")
		ccBGSSSE001_fishingLostCatch.Show()
		CatchFail(false, IsFishCatchType(nextCatchData.getCatchType()))
	endif

	handlingInputOrUpdate = false
endEvent

function OnPlayerHit()
	; Called externally by hit event on player alias.
	DoCleanupTasks()
endFunction

function OnPlayerMoveAway()
	; The player moved away from the last used fishing supplies (or was pushed). 
	DoCleanupTasks()
endFunction

function OnPlayerInDialogue()
	; Called on entering forced dialogue.
	DoCleanupTasks()
endFunction

function DoCleanupTasks()
	if currentSystemState != SYSTEMSTATE_IDLE && IsInExitableSystemState()
		CleanUp(true)
	elseif currentSystemState == SYSTEMSTATE_IDLE
		ReturnSurroundingVolumes()
		ResumeFollowerBehavior()
		RestoreWeather()
	endif
endFunction

function OnFishingTriggerActivated()
	FishingDebug("OnFishingTriggerActivated, currentSystemState " + currentSystemState)
	if currentSystemState == SYSTEMSTATE_FISHING || \
	   currentSystemState == SYSTEMSTATE_NIBBLE || \
	   currentSystemState == SYSTEMSTATE_HOOKED
		ReelLine()
	elseif currentSystemState == SYSTEMSTATE_IDLE
		StartPlayerInteraction(currentFishingSupplies, true)
	endif
endFunction


;/ 
 / ==========================
 /  EVENT REGISTRATION
 / ==========================
 /;

function RegisterForNextUpdate(int aiUpdateType)
	nextUpdateType = aiUpdateType
	FishingDebug("Registering for next update...")
	if aiUpdateType == UPDATETYPE_SETQUESTSTAGE
		FishingDebug("    ...set quest stage")
		RegisterForSingleUpdate(0.01)
	elseif aiUpdateType == UPDATETYPE_START
		FishingDebug("    ...start")
		RegisterForSingleUpdate(GetInitialWaitingPeriod())
	elseif aiUpdateType == UPDATETYPE_SEQUENCE
		FishingDebug("    ...sequence")
		if nextCatchData && IsFishCatchType(nextCatchData.getCatchType())
			RegisterForSingleUpdate(nextCatchData.getCatchSequence()[currentCatchSequenceIndex])
		else
			RegisterForSingleUpdate(DURATION_JUNKITEMCATCHTIME)
		endif
	elseif aiUpdateType == UPDATETYPE_CATCHTIMEOUT
		FishingDebug("    ...catch timeout")
		RegisterForSingleUpdate(DURATION_CATCHTIMEOUT)
	endif
endFunction

function RegisterForUpdateNextMorning()
	FishingDebug("Fishing Supplies " + self + " RegisterForUpdateNextMorning()")

	float hoursUntilMorning
	if currentGameHour <= GAMETIME_MORNING
		hoursUntilMorning = (GAMETIME_MORNING - currentGameHour)
	else
		hoursUntilMorning = (24.0 - currentGameHour) + GAMETIME_MORNING
	endif
	
	currentFishingSupplies.RegisterForPopulationUpdate(hoursUntilMorning)
endFunction


;/ 
 / ==========================
 /  FISHING SYSTEM
 / ==========================
 /;

;/ 
 / Start-Up and Interaction
 /;
function StartPlayerInteraction(ccBGSSSE001_FishingActScript akFishingSupplies, bool abContinueFishing = false)
	currentSystemState = SYSTEMSTATE_SETTINGUP
	CheckEnableDebug()
	currentFishingSupplies = akFishingSupplies
	ResetSystem()
	
	currentFishingRodType = GetCurrentFishingRodType()
	FishingDebug("Current fishing rod type: " + currentFishingRodType)

	;; LLFP: Taken from Fancy Fishing for SFO compat
	; SFO settings
    ; idea is to avoid touching this quest record in the Fancy Fishing + SFO patch itself
	AnimatedFishing_Global = Game.GetFormFromFile(0x800, "Simple Fishing Overhaul.esp") as GlobalVariable
    if AnimatedFishing_Global
        RodHeight = Game.GetFormFromFile(0x801, "Simple Fishing Overhaul.esp") as GlobalVariable
        BaitReq = Game.GetFormFromFile(0x819, "Simple Fishing Overhaul.esp") as GlobalVariable
        FishingCamera = Game.GetFormFromFile(0x86F, "Simple Fishing Overhaul.esp") as GlobalVariable
        AnimatedFishing_NoBait = Game.GetFormFromFile(0x818, "Simple Fishing Overhaul.esp") as Message
        AnimatedFishing_Bait = Game.GetFormFromFile(0x817, "Simple Fishing Overhaul.esp") as FormList
	endif

	; Is the player jumping, in combat, etc?
	if !IsFishingAllowed(currentFishingRodType)
		currentSystemState = SYSTEMSTATE_IDLE
		return
	endif

	; Retrieve the current game hour now for re-use.
	currentGameHour = GameHour.GetValue()

	; Check and recalculate the fish population, if necessary.
	RecalculateFishPopulation()

	TryToApplyRainWeather()

	Fish(abContinueFishing)
endFunction

function RecalculateFishPopulation()
	int basePopulation = 0
	int morningEveningBonus = 0
	bool shouldSetPopulation = false

	; If these fishing supplies haven't been used recently, recalculate the base population.
	if !currentFishingSupplies.GetCalculatedPopulationRecently()
		currentFishingSupplies.SetCalculatedPopulationRecently(true)
		RegisterForUpdateNextMorning()
		shouldSetPopulation = true
		basePopulation = GetFishBasePopulation()
	else
		basePopulation = currentFishingSupplies.GetCurrentFishPopulation()
	endif

	; If it wasn't morning or evening before, but it is morning or evening now, grant a population bonus.
	if !currentFishingSupplies.GetWasMorningEvening() && GetIsMorningEvening()
		currentFishingSupplies.SetWasMorningEvening(true)
		shouldSetPopulation = true
		morningEveningBonus = GetFishPopulationMorningEveningBonus()
	endif

	if shouldSetPopulation
		FishingDebug("Setting population with basePopulation " + basePopulation + " and morningEveningBonus " + morningEveningBonus)
		currentFishingSupplies.SetFishPopulation(basePopulation + morningEveningBonus)
	endif
endFunction

function Fish(bool abContinueFishing)
	ToggleDisableHeadtracking(False, True) ;; LLFP: Taken from SFO for its compatibility
	currentFishingSupplies.UpdateFish()
	DialogueQuest.StartUpdating()

	; Camera and Player Setup
	fishingRodActivator = PlaceFishingRodActivator(currentFishingRodType)
	FishingDebug("Placing fishing rod activator " + fishingRodActivator)
	SetupCameraAndPosition(abContinueFishing)

	; Set the fish population to show and show the reel line prompt.
	SetVisualPopulation()

	; Show the tutorial, if the player has never fished before.
	ShowFishingTutorial()
	
	ShowReelLinePrompt()

	; Determine what the player will catch
	nextCatchData = GetNextCatchData()

	FishingDebug("Catch data for next catch")
	FishingDebug("  === Catch: " + nextCatchData.getCaughtObject())
	FishingDebug("  === Catch Type: " + nextCatchData.getCatchType())

	; Begin Fishing
	;; LLFP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Begin Fishing
	PlayCastAnimation()
	initTime = Utility.GetCurrentRealTime()
	; Debug.Notification(initTime)
	if(PlayerRef.HasPerk(_LLFP_LessCastingTime_Perk03))
		Wait(DURATION_CAST - _LLFP_CastingTimeRed03.GetValue() * DURATION_CAST)
	elseif(PlayerRef.HasPerk(_LLFP_LessCastingTime_Perk02))
		Wait(DURATION_CAST - _LLFP_CastingTimeRed02.GetValue() * DURATION_CAST)
	elseif(PlayerRef.HasPerk(_LLFP_LessCastingTime_Perk01))
		Wait(DURATION_CAST - _LLFP_CastingTimeRed01.GetValue() * DURATION_CAST)
	else
		Wait(DURATION_CAST)
	endif
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Failsafe
	PlayVisualPopulationAnimation()

	RegisterForNextUpdate(UPDATETYPE_START)
	currentSystemState = SYSTEMSTATE_FISHING
endFunction

function SetVisualPopulation()
	int currentPopulation = currentFishingSupplies.GetCurrentFishPopulation()
	FishingDebug("Current population: " + currentPopulation)
	if currentPopulation >= POPULATION_COUNT_FULL
		FishingDebug("Setting full population animation var")
		fishingRodActivator.SetAnimationVariableFloat(POPULATION_ANIMVAR, POPULATION_TYPE_FULL)
	elseif currentPopulation > 0
		FishingDebug("Setting sparse population animation var")
		fishingRodActivator.SetAnimationVariableFloat(POPULATION_ANIMVAR, POPULATION_TYPE_SPARSE)
	else
		FishingDebug("Setting empty population animation var")
		fishingRodActivator.SetAnimationVariableFloat(POPULATION_ANIMVAR, POPULATION_TYPE_EMPTY)
	endif
endFunction

function ShowFishingTutorial()
	if ccBGSSSE001_FishingTutorialDisplayed.GetValueInt() == 0
		ccBGSSSE001_FishingTutorialDisplayed.SetValueInt(1)
		ccBGSSSE001_FishingTutorial.Show()
	endif
endFunction

function ShowReelLinePrompt()
	if ccBGSSSE001_ShowedReelPromptThisSession.GetValueInt() == 0
		ccBGSSSE001_ShowedReelPromptThisSession.SetValueInt(1)
		Message.ResetHelpMessage("Activate")
		ccBGSSSE001_ReelLinePrompt.ShowAsHelpMessage("Activate", 5, 30, 1)
	endif
endFunction

function ShowCatchPrompt()
	if ccBGSSSE001_ShowedCatchPromptThisSession.GetValueInt() == 0
		ccBGSSSE001_ShowedCatchPromptThisSession.SetValueInt(1)
		Message.ResetHelpMessage("Activate")
		ccBGSSSE001_CatchPrompt.ShowAsHelpMessage("Activate", 5, 30, 1)
	endif
endFunction

function ReturnSurroundingVolumes()

	objectreference returnRef = ReelLineRef.GetLinkedRef(none)
	ReelLineRef.MoveTo(returnRef, 0.000000, 0.000000, 0.000000, true)
	MoveDetectRef.MoveTo(returnRef, 0.000000, 0.000000, 0.000000, true)
	ccBGSSSE001_NavBlockerRef.MoveTo(returnRef, 0.000000, 0.000000, 0.000000, true)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ccBGSSSE001_CatchData function GetNextCatchData()
	FormList catchDataList
	ccBGSSSE001_CatchData catchData

	float catchChanceFish = BASE_CATCH_THRESHOLD_IS_FISH * GetFishCatchThresholdModifier() * GetFishPopulationJunkModifier()

;; LLFP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Modified which list searches depending on spells active (prioritary) and rolls results (secondary). This is og code modified
	; Quest results override normal catch results
	;; LLFP: Unless you have spells active
	if currentFishingSupplies.CanCatchQuestItem() && !PlayerRef.HasMagicEffect(_LLFP_FishSpellEffect) && !PlayerRef.HasMagicEffect(_LLFP_JunkSpellEffect)
		isQuestItemCatch = true

		; Roll for result
		FormList myQuestCatchDataList = currentFishingSupplies.myQuestCatchDataList
		int resultRoll = RandomInt(0, myQuestCatchDataList.GetSize() - 1)
		FishingDebug("Result roll " + resultRoll + " from myQuestCatchDataList " + myQuestCatchDataList)

		return myQuestCatchDataList.GetAt(resultRoll) as ccBGSSSE001_CatchData
	endif
	
	; Roll for fish or junk
	float catchTypeRoll = 1.0 - RandomFloat()
	FishingDebug("Catch Type Roll: " + catchTypeRoll)

	; If the player has never caught anything before, they always catch a fish first.
	if !PlayerHasCaughtFishBefore()
		catchTypeRoll = catchChanceFish
	endif

	if PlayerRef.HasMagicEffect(_LLFP_FishSpellEffect) ; FishSpell active
		int biomeType = currentFishingSupplies.BiomeType
		if biomeType == BIOME_TYPE_STREAM
			if GetInRain()
				catchDataList = ccBGSSSE001_FishCatchDataListTemperateStreamRain
			else
				catchDataList = ccBGSSSE001_FishCatchDataListTemperateStreamClear
			endif

		elseif biomeType == BIOME_TYPE_LAKE
			if GetInRain()
				catchDataList = ccBGSSSE001_FishCatchDataListTemperateLakeRain
			else
				catchDataList = ccBGSSSE001_FishCatchDataListTemperateLakeClear
			endif

		elseif biomeType == BIOME_TYPE_ARCTIC
			catchDataList = ccBGSSSE001_FishCatchDataListArctic

		elseif biomeType == BIOME_TYPE_CAVE
			catchDataList = ccBGSSSE001_FishCatchDataListCave
		endif

		catchData = GetNextFishCatchData(catchDataList)
		FishCaught = TRUE

	elseif PlayerRef.HasMagicEffect(_LLFP_JunkSpellEffect) ;; Junk spell active

		catchData = GetNextJunkCatchData(GetJunkCatchDataList())
		FishCaught = FALSE

	elseif catchTypeRoll >= catchChanceFish ; Vanilla fish roll  (repeat chunk, using a function causes issues)
		int biomeType = currentFishingSupplies.BiomeType
		if biomeType == BIOME_TYPE_STREAM
			if GetInRain()
				catchDataList = ccBGSSSE001_FishCatchDataListTemperateStreamRain
			else
				catchDataList = ccBGSSSE001_FishCatchDataListTemperateStreamClear
			endif

		elseif biomeType == BIOME_TYPE_LAKE
			if GetInRain()
				catchDataList = ccBGSSSE001_FishCatchDataListTemperateLakeRain
			else
				catchDataList = ccBGSSSE001_FishCatchDataListTemperateLakeClear
			endif

		elseif biomeType == BIOME_TYPE_ARCTIC
			catchDataList = ccBGSSSE001_FishCatchDataListArctic

		elseif biomeType == BIOME_TYPE_CAVE
			catchDataList = ccBGSSSE001_FishCatchDataListCave
		endif

		catchData = GetNextFishCatchData(catchDataList)
		FishCaught = TRUE

	elseif catchTypeRoll < catchChanceFish ; Vanilla junk roll

		catchData = GetNextJunkCatchData(GetJunkCatchDataList())
		FishCaught = FALSE
	endif
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; If this was a one-time-only catch, check to see if it is in the caught list.
	; If it has already been caught, search the list this CatchData came from
	; for a different item that isn't one-time-only or hasn't already been caught.
	if catchData.isOneTimeCatch && ccBGSSSE001_OneTimeCaughtList.Find(catchData) > -1
		catchData = FindAllowedCatchDataInList(nextCatchDataSourceList)
	endif

	return catchData
EndFunction

FormList function GetJunkCatchDataList()
	FormList overrideJunkList = currentFishingSupplies.myOverrideJunkCatchDataList
	if overrideJunkList
		return overrideJunkList
	else
		return ccBGSSSE001_JunkCatchDataListDefault
	endif
endFunction

ccBGSSSE001_CatchData function FindAllowedCatchDataInList(FormList akCatchDataList)
	; Search the list top-to-bottom for Catch Data that is either not-one-time-only,
	; or one-time-only but hasn't been caught yet. This will return a non-random result,
	; so this means we can weight the most desirable, one-time catches to the top,
	; and push the non-exclusive results to the bottom. This also has the side-effect
	; of increasing the likelihood that a one-time catch that you haven't caught yet
	; will be caught as more things in the list have been caught, which will trigger
	; this search.

	; The list is required to have at least one Catch Data that is not a one-time-only catch.

	int size = akCatchDataList.GetSize()
	int i = 0
	while i < size
		ccBGSSSE001_CatchData catchData = akCatchDataList.GetAt(i) as ccBGSSSE001_CatchData
		if !catchData.isOneTimeCatch || (catchData.isOneTimeCatch && ccBGSSSE001_OneTimeCaughtList.Find(catchData) == -1)
			return catchData
		endif

		i += 1
	endWhile

	; This should not happen.
	FishingDebug("There were no allowed CatchData in list " + akCatchDataList + ", a non-exclusive result should be added!")
	return None
endFunction

ccBGSSSE001_CatchData function GetNextFishCatchData(FormList akCatchDataList)
	ccBGSSSE001_CatchData catchData
	int rarityListIndex
	int sizeListIndex

	;/
	 / Fish Catch Data have sublists broken down by rarity, and then by size.
	 /;

	; 1 - RARITY
	; Roll for common, uncommon, or rare result
	float rarityRoll = RandomFloat()
	FishingDebug("Rarity Roll: " + rarityRoll)

	float catchThresholdCommonFish = BASE_CATCH_THRESHOLD_COMMONFISH
	float catchThresholdUncommonFish = BASE_CATCH_THRESHOLD_UNCOMMONFISH

	; If the player is using a special fishing rod for fish, grant a bonus to rarity.
	if currentFishingRodType == RODTYPE_ALIKRI || currentFishingRodType == RODTYPE_ARGONIAN
		catchThresholdCommonFish += SPECIAL_FISH_RODS_COMMONFISH_THRESHOLD_ADJUST
		catchThresholdUncommonFish += SPECIAL_FISH_RODS_UNCOMMONFISH_THRESHOLD_ADJUST
	endif

	; If it is morning or evening, grant a bonus to rarity.
	if GetIsMorningEvening()
		catchThresholdCommonFish += MORNING_EVENING_COMMONFISH_THRESHOLD_ADJUST
		catchThresholdUncommonFish += MORNING_EVENING_UNCOMMONFISH_THRESHOLD_ADJUST
	endif

	;; LLFP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; More Fish perk modifies the chances of getting rarer Fish .The idea is to lower common and increase uncommon and rare
	; Debug.Notification("catchThresholdCommonFish before perk = " + catchThresholdCommonFish)
	; Debug.Notification("catchThresholdUnCommonFish before perk = " + catchThresholdUnCommonFish)


	float CurrentFishBonusMult

	if PlayerRef.HasPerk(_LLFP_MoreRarityFish_Perk03)
		CurrentFishBonusMult =_LLFP_FishBonusMult03.GetValue()
	elseif PlayerRef.HasPerk(_LLFP_MoreRarityFish_Perk02)
		CurrentFishBonusMult =_LLFP_FishBonusMult02.GetValue()
	elseif PlayerRef.HasPerk(_LLFP_MoreRarityFish_Perk01)
		CurrentFishBonusMult =_LLFP_FishBonusMult01.GetValue()
	endIf

	;Debug.Notification("CurrentFishBonusMult =  " + CurrentFishBonusMult)
	;; Multiply bonus depending on perk
	
	float CurrentCommonFishBonus = _LLFP_CommonFishBonus.GetValue() * CurrentFishBonusMult
	float CurrentUnCommonFishBonus = _LLFP_UnCommonFishBonus.GetValue() * CurrentFishBonusMult

	; Sum it to vanilla base threshold
	catchThresholdCommonFish += CurrentCommonFishBonus
	catchThresholdUncommonFish += CurrentUnCommonFishBonus
	; Debug.Notification("catchThresholdCommonFish after perk = " + catchThresholdCommonFish)
	; Debug.Notification("catchThresholdUnCommonFish after perk = " + catchThresholdUnCommonFish)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	if rarityRoll >= catchThresholdCommonFish
		rarityListIndex = RARITY_LIST_COMMON_INDEX
	elseif rarityRoll >= catchThresholdUncommonFish
		rarityListIndex = RARITY_LIST_UNCOMMON_INDEX
	else
		rarityListIndex = RARITY_LIST_RARE_INDEX
	endif

	FormList raritySubList = akCatchDataList.GetAt(rarityListIndex) as FormList

	; 2 - SIZE
	; Roll for Small or Large catch. Rod affects results.
	float catchChanceSmallFish = BASE_CATCH_THRESHOLD_SMALL * GetSmallCatchThresholdModifier()

	float sizeRoll = RandomFloat()
	FishingDebug("Size Roll: " + sizeRoll)

	if sizeRoll >= catchChanceSmallFish
		sizeListIndex = SIZE_LIST_SMALLFISH_INDEX
	else
		sizeListIndex = SIZE_LIST_LARGEFISH_INDEX
	endif

	FormList sizeSubList = raritySubList.GetAt(sizeListIndex) as FormList

	; 3 - RESULT
	; Roll for final result
	; The result list for this size could be empty, so, check for that first.
	int sizeSubListSize = sizeSubList.GetSize()
	if sizeSubListSize > 0
		int resultRoll = RandomInt(0, sizeSubListSize - 1)
		FishingDebug("Result Roll: " + resultRoll)

		catchData = sizeSubList.GetAt(resultRoll) as ccBGSSSE001_CatchData
		FishingDebug("Catch Data: " + catchData)
	else
		; There weren't any fish in this size sublist, so, roll
		; on the junk list instead.

		return GetNextJunkCatchData(GetJunkCatchDataList())
	endif

	; Store if this was a rare catch, so we can play special fanfare later.
	if rarityListIndex == RARITY_LIST_RARE_INDEX
		lastCatchWasRare = true
	endif

	; Store the source list of this catch data, in case we need to remove it
	; from the list later (for one-time-only catches)
	nextCatchDataSourceList = sizeSubList

	return catchData
endFunction

ccBGSSSE001_CatchData function GetNextJunkCatchData(FormList akCatchDataList)
	ccBGSSSE001_CatchData catchData
	int rarityListIndex

	;/
	 / Junk Catch Data have sublists broken down by rarity.
	 /;

	 ; 1 - RARITY
	; Roll for common, uncommon, or rare result
	float rarityRoll = RandomFloat()
	FishingDebug("Rarity Roll: " + rarityRoll)

	float catchThresholdCommonJunk = BASE_CATCH_THRESHOLD_COMMONJUNK
	float catchThresholdUncommonJunk = BASE_CATCH_THRESHOLD_UNCOMMONJUNK

	; If the player is using a special fishing rod for junk, grant a bonus to rarity.
	if currentFishingRodType == RODTYPE_DWARVEN
		catchThresholdCommonJunk += SPECIAL_JUNK_RODS_COMMONJUNK_THRESHOLD_ADJUST
		catchThresholdUncommonJunk += SPECIAL_JUNK_RODS_UNCOMMONJUNK_THRESHOLD_ADJUST
	endif

	;; LLFP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; More junk perk modifies the chances of getting rarer junk .The idea is to lower common and increase uncommon and rare
	; Debug.Notification("catchThresholdCommonJunk before perk = " + catchThresholdCommonJunk)
	; Debug.Notification("catchThresholdUnCommonJunk before perk = " + catchThresholdUnCommonJunk)


	float CurrentJunkBonusMult

	if PlayerRef.HasPerk(_LLFP_MoreRarityJunk_Perk03)
		CurrentJunkBonusMult =_LLFP_JunkBonusMult03.GetValue()
	elseif PlayerRef.HasPerk(_LLFP_MoreRarityJunk_Perk02)
		CurrentJunkBonusMult =_LLFP_JunkBonusMult02.GetValue()
	elseif PlayerRef.HasPerk(_LLFP_MoreRarityJunk_Perk01)
		CurrentJunkBonusMult =_LLFP_JunkBonusMult01.GetValue()
	endIf

	; Debug.Notification("CurrentJunkBonusMult =  " + CurrentJunkBonusMult)
	;; Multiply bonus depending on perk
	
	float CurrentCommonJunkBonus = _LLFP_CommonJunkBonus.GetValue() * CurrentJunkBonusMult
	float CurrentUnCommonJunkBonus = _LLFP_UnCommonJunkBonus.GetValue() * CurrentJunkBonusMult

	; Sum it to vanilla base threshold
	catchThresholdCommonJunk += CurrentCommonJunkBonus
	catchThresholdUncommonJunk += CurrentUnCommonJunkBonus
	; Debug.Notification("catchThresholdCommonJunk after perk = " + catchThresholdCommonJunk)
	; Debug.Notification("catchThresholdUnCommonJunk after perk = " + catchThresholdUnCommonJunk)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	if rarityRoll >= catchThresholdCommonJunk
		rarityListIndex = RARITY_LIST_COMMON_INDEX
	elseif rarityRoll >= catchThresholdUncommonJunk
		rarityListIndex = RARITY_LIST_UNCOMMON_INDEX
	else
		rarityListIndex = RARITY_LIST_RARE_INDEX
	endif

	FormList raritySubList = akCatchDataList.GetAt(rarityListIndex) as FormList

	; 2 - RESULT
	; Roll for final result
	int raritySubListSize = raritySubList.GetSize()
	int resultRoll = RandomInt(0, raritySubListSize - 1)
	FishingDebug("Result Roll: " + resultRoll)

	catchData = raritySubList.GetAt(resultRoll) as ccBGSSSE001_CatchData
	FishingDebug("Catch Data: " + catchData)

	; Store if this was a rare catch, so we can play special fanfare later.
	if rarityListIndex == RARITY_LIST_RARE_INDEX
		lastCatchWasRare = true
	endif

	; Store the source list of this catch data, in case we need to reference it
	; (for use by one-time-only catches).
	nextCatchDataSourceList = akCatchDataList

	return catchData
endFunction

;; LLFP: Taken from SFO for compat with it
function SetupCameraAndPosition(Bool abContinueFishing)

	startedInFirstPerson = PlayerRef.GetAnimationVariableBool("IsFirstPerson")
	startedWithTorch = PlayerRef.GetEquippedItemType(0) == 11
	while self.IsPlayerDrawingWeapon()
		utility.Wait(0.250000)
	endWhile
	Bool hasWeaponDrawn = PlayerRef.IsWeaponDrawn()
	if AnimatedFishing_Global == NONE
		;Debug.Notification("Forcing first person")
		game.DisablePlayerControls(true, true, true, false, true, true, false, true, 0)
	Else
		;Debug.Notification("Cant force 1st person")
		game.DisablePlayerControls(true, true, false, false, true, true, false, true, 0)
	endif

	Bool resetViewAndPlayerState = true
	if abContinueFishing
		objectreference fishingmarker = currentFishingSupplies.GetFishingMarker()
		if PlayerRef.GetAngleX() == 0.000000 && PlayerRef.GetAngleZ() == fishingmarker.GetAngleZ() && math.Floor(PlayerRef.GetPositionX()) == math.Floor(fishingmarker.GetPositionX()) && math.Floor(PlayerRef.GetPositionY()) == math.Floor(fishingmarker.GetPositionY()) && startedInFirstPerson as Bool && !hasWeaponDrawn
			resetViewAndPlayerState = false
		endIf
	endIf


	if resetViewAndPlayerState
		ccBGSSSE001_FadeToBlackImod.ApplyCrossFade(self.DURATION_FADETOBLACKCROSSFADE)
		utility.Wait(self.DURATION_FADETOBLACKCROSSFADE - 0.100000)
		ccBGSSSE001_FadeToBlackImod.PopTo(ccBGSSSE001_FadeToBlackHoldImod, 1.00000)
		ccBGSSSE001_FishingFollowerIdleQuest.Start()
		if hasWeaponDrawn
			utility.Wait(self.DURATION_SHEATHEWEAPON)
		endIf
		if startedWithTorch
			PlayerRef.UnequipItem(Torch01 as form, false, true)
		endIf
;		if !startedInFirstPerson
;			game.ForceFirstPerson()
;		endIf
		self.MovePlayerToFishingMarker()
	endIf
	utility.Wait(self.DURATION_RODLOADTIME)
;	fishingRodActivator.TranslateToRef(currentFishingSupplies.GetFishingMarker(), 2000.00, 2000.00)
fishingmarker = currentFishingSupplies.GetFishingMarker()
fishingRodActivator.TranslateTo(fishingmarker.GetPositionX(), fishingmarker.GetPositionY(), fishingmarker.GetPositionZ(), fishingmarker.GetAngleX(), fishingmarker.GetAngleY(), fishingmarker.GetAngleZ(), 2000.00, 2000.00)

	MoveDetectRef.IgnoreTriggerEvents(true)
	objectreference fishingMarker = currentFishingSupplies.GetFishingMarker()
	ccBGSSSE001_NavBlockerRef.MoveTo(fishingMarker, 0.000000, 0.000000, 0.000000, true)
	ReelLineRef.MoveTo(fishingMarker, 0.000000, 0.000000, 0.000000, true)
	MoveDetectRef.MoveTo(fishingMarker, 0.000000, 0.000000, 0.000000, true)
	MoveDetectRef.IgnoreTriggerEvents(false)
	if resetViewAndPlayerState
		ccBGSSSE001_FadeToBlackHoldImod.PopTo(ccBGSSSE001_FadeToBlackBackImod, 1.00000)
		utility.Wait(self.DURATION_FADETOBLACKCROSSFADE - 0.100000)
	endIf
endFunction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function MovePlayerToFishingMarker()
	PlayerRef.MoveTo(currentFishingSupplies.GetFishingMarker())
endFunction

ObjectReference function PlaceFishingRodActivator(int aiRodType)
	ObjectReference fishingRodPlacementMarker = PlayerRef.PlaceAtMe(XMarker)
	fishingRodPlacementMarker.MoveTo(fishingRodPlacementMarker, afZOffset = -600.0)
	ObjectReference fishingRodRef = fishingRodPlacementMarker.PlaceAtMe(ccBGSSSE001_FishingRodFXActivators.GetAt(aiRodType))
	fishingRodPlacementMarker.Disable()
	fishingRodPlacementMarker.Delete()
	return fishingRodRef
endFunction

function ReelLine()
	; Player input and updates can both change system state, only allow one to run at a time.
	; In terms of UX, it is better to be immediately responsive or ignore the input entirely.
	; if we're already processing an input or update, throw this attempt away and don't queue it.
	if !handlingInputOrUpdate
		handlingInputOrUpdate = true

		if currentSystemState == SYSTEMSTATE_NIBBLE
			currentSystemState = SYSTEMSTATE_CATCH_RESOLVE
			ccBGSSSE001_fishingEarlyReelNibble.Show()
			CatchFail(true, true)
		elseif currentSystemState == SYSTEMSTATE_HOOKED
			currentSystemState = SYSTEMSTATE_CATCH_RESOLVE
			if IsCatchSuccessful()
				CatchSuccess()
			else
				; Fail, and reduce the fish population if we failed to catch a fish.
				ccBGSSSE001_fishingLostCatch.Show()
				CatchFail(false, IsFishCatchType(nextCatchData.getCatchType()))
			endif
		elseif currentSystemState == SYSTEMSTATE_CATCH_RESOLVE
			; Do nothing, we're in the process of catching something already.
		else
			currentSystemState = SYSTEMSTATE_CATCH_RESOLVE
			ccBGSSSE001_fishingEarlyReel.Show()
			CatchFail(true)
		endif

		handlingInputOrUpdate = false
	endif
endFunction

;/ 
 / Catch Results
 /;
bool function IsCatchSuccessful()
	if IsFishCatchType(nextCatchData.getCatchType())
		; Does this fish require a certain rod?
		Weapon requiredRod = nextCatchData.getRequiredRod()
		if requiredRod && currentFishingRodType != ccBGSSSE001_FishingRods.Find(requiredRod)
			return false
		endif
	endif

	return true
endFunction

function CatchSuccess()
	FishingDebug("Catch success!")
	UnregisterForUpdate()
	
	ccBGSSSE001_CatchSuccessSM.Play(PlayerRef)
	PlayCatchSuccessAnimation()
	Wait(DURATION_CATCH)

	Form caughtObject = nextCatchData.getCaughtObject()

	int catchType = nextCatchData.getCatchType()

	; Sound effects. If this was a rare catch, play a special sound.
	ccBGSSSE001_ITMFishUpSM.Play(PlayerRef)
	if lastCatchWasRare
		ccBGSSSE001_RareCatchSM.Play(PlayerRef)
	endif

	; If this was a one-time-only catch, add it to the caught list.
	if nextCatchData.isOneTimeCatch
		ccBGSSSE001_OneTimeCaughtList.AddForm(nextCatchData)
	endif
	ShowFanfareScreenAndAddCaughtItem(caughtObject) ;; LLFP: taken from SFO for its compatibility
	; Fish-specific actions
	if IsFishCatchType(catchType)
		TryToStartQuestAfterFirstCatch()

		currentFishingSupplies.UpdateFishCatchSuccess()

		; Reduce the fish population
		currentFishingSupplies.ReduceFishPopulation(1)
	endif

	;ShowFanfareScreenAndAddCaughtItem(caughtObject) ;; LLFP: taken from SFO for its compatibility
	
	if isQuestItemCatch && currentFishingSupplies.myQuestStageToSet != -1
		currentFishingSupplies.myQuest.SetStage(currentFishingSupplies.myQuestStageToSet)
	endif

	if RadiantFishEventListener && RadiantFishEventListener.FishingSpot.GetRef() == currentFishingSupplies
		RadiantFishEventListener.CatchEvent(caughtObject, catchType)
	endif

	
	CleanUp()
endFunction

;; LLFP: Taken from SFO for compat with it (and fishing preview)
function ShowFanfareScreenAndAddCaughtItem(form akCaughtObject)
    Form FishingPreviewQuest = Game.GetFormFromFile(0x800, "FishingPreview.esp")
    If FishingPreviewQuest
        if currentSystemState != self.SYSTEMSTATE_CATCH_RESOLVE
            game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)
        endIf
        (FishingPreviewQuest As FishingPreviewQuestScript).ShowPreview(akCaughtObject)
        Return
    EndIf

game.DisablePlayerControls(true, true, true, true, true, true, true, true, 0)

WasInThird = False

If !PlayerRef.GetAnimationVariableBool("IsFirstPerson") && FishingCamera.GetValue() < 2
		ccBGSSSE001_FadeToBlackImod.ApplyCrossFade(0.4)
		utility.Wait(0.2)
		ccBGSSSE001_FadeToBlackHoldImod.PopTo(ccBGSSSE001_FadeToBlackBackImod, 1.20000)
	WasInThird = True
	game.ForceFirstPerson()
endif

If FishingCamera.GetValue() < 2
PlayerRef.SetAngle(fishingRodActivator.GetAngleX(), fishingRodActivator.GetAngleY(), fishingRodActivator.GetAngleZ())
endif

ccBGSSSE001_CatchSuccessDOF.Apply(1.0)
	objectreference catchRef = currentFishingSupplies.PlaceAtMe(akCaughtObject, 1, false, false)
	while !catchRef.Is3DLoaded()
		utility.Wait(0.200000)
	endWhile
	catchRef.SetMotionType(catchRef.Motion_Keyframed, true)
	catchRef.Disable(false)
	objectreference fishingMarker = currentFishingSupplies.GetFishingMarker()
	objectreference fanfareLight = currentFishingSupplies.PlaceAtMe(ccBGSSSE001_CatchSuccessLight as form, 1, false, true)
	fanfareLight.MoveToNode(fishingMarker, "LightNode")
	catchRef.MoveToNode(fishingMarker, nextCatchData.successNodeName)
	fanfareLight.EnableNoWait(false)
	catchRef.EnableNoWait(true)
	PlayerRef.AddItem(catchRef.GetBaseObject(), 1, false)
	utility.Wait(self.DURATION_SUCCESSVIEW)
	fanfareLight.DisableNoWait(false)
	catchRef.DisableNoWait(false)
	fanfareLight.Delete()
	catchRef.Delete()
	ccBGSSSE001_CatchSuccessDOF.Remove()
	if currentSystemState != self.SYSTEMSTATE_CATCH_RESOLVE
		game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)
	endIf
	;;;; LLFP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Debug.Notification("Updating fish catch Success...")
	
	; Skill up system ;;;;;;;;;;;;;;;;;;;;;;
	if(FishCaught == TRUE) ; advance skill only when catching fish

		float SkillAdvanceMagnitude = ((10+(10 * CustomSkills.GetSkillLevel("fishing")))/2) * _LLFP_SkillAdvanceMult.GetValue()
		Utility.Wait(1)
		CustomSkills.AdvanceSkill("fishing", SkillAdvanceMagnitude)

	endif
	; DoubleCatch Perk
	if PlayerRef.hasPerk(_LLFP_MoreCatch_Perk01) && QuestScript.LastCaughtObject !=  NONE ;; second condition checks if its the right catch to apply the effect
		;; Random chance system
		int MoreCatchRoll = RandomInt(aiMin = 1, aiMax = 2)
		if(MoreCatchRoll == 1) ; 50% chance
	
			Debug.Notification("Double Catch!")

			PlayerRef.additem(QuestScript.LastCaughtObject) ; add extra catch

		; else
		; 	Debug.Notification("Bad Roll for doublecatch")
		endif

	; else
	; 		Debug.Notification("Have Doublecatch perk, but not right fish/no doublecatch active")
	endif

	QuestScript.LastCaughtObject = NONE ; Reset
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
endFunction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function CatchFail(bool abFastExit, bool abReduceFishPopulation = false)
	FishingDebug("Catch failure, exit!")
	if abFastExit
		PlayFastExitAnimation()
		Wait(DURATION_FASTEXIT)
	else
		PlayCatchFailureAnimation()
		Wait(DURATION_CATCH)
	endif

	if abReduceFishPopulation
		currentFishingSupplies.ReduceFishPopulation(1)
	endif
	
	CleanUp()
endFunction

;/ 
 / Animations
 /;
function PlayResetAnimation()
	fishingRodActivator.PlayAnimation(RESET_ANIM)
endFunction

;; LLFP: Partially taken from Fancy Fishing for SFO compatibility
function PlayCastAnimation()
    if AnimatedFishing_Global
        Weapon1 = PlayerRef.GetEquippedWeapon()
        Weapon2 = PlayerRef.GetEquippedWeapon(True)


        PlayerRef.UnequipItem(Weapon1, false, true)
        PlayerRef.UnequipItem(Weapon2, false, true)


        AnimatedFishing_Global.SetValue(1)
        if !startedInFirstPerson
            Utility.Wait(0.1)
            PlayerRef.PlayIdle(IdleCoweringLoose)
            Utility.Wait(0.7)
        else
            PlayerRef.PlayIdle(IdleCoweringLoose)
        endif
        utility.wait(0.1)
    endif

    fishingRodActivator.PlayAnimation(CAST_ANIM)
    game.ShakeController(RUMBLE_STRENGTH_CAST_LEFT, RUMBLE_STRENGTH_CAST_RIGHT, RUMBLE_DURATION_CAST)

    if AnimatedFishing_Global
        Utility.wait(0.2)
        float height = PlayerRef.GetPositionZ()
        fishingRodActivator.TranslateTo(fishingRodActivator.GetPositionX(), fishingRodActivator.GetPositionY(), (height - RodHeight.GetValue()), fishingRodActivator.GetAngleX(), fishingRodActivator.GetAngleY(), fishingRodActivator.GetAngleZ(), 2000.00, 2000.00)
    endif
endFunction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function PlayVisualPopulationAnimation()
	int currentPopulation = currentFishingSupplies.GetCurrentFishPopulation()
	if currentPopulation >= POPULATION_COUNT_FULL
		fishingRodActivator.PlayAnimation(POPULATION_FULL_ANIM)
	elseif currentPopulation > 0
		fishingRodActivator.PlayAnimation(POPULATION_SPARSE_ANIM)
	else
		fishingRodActivator.PlayAnimation(POPULATION_EMPTY_ANIM)
	endif
endFunction

function PlayNibbleAnimation()
	currentFishingSupplies.UpdateNibble()
	fishingRodActivator.PlayAnimation(NIBBLE_ANIM)

	int catchType = nextCatchData.getCatchType()

	if catchType == ccBGSSSE001_CatchTypeSmallFish.GetValueInt()
		Game.ShakeController(RUMBLE_STRENGTH_NIBBLESMALL_LEFT, RUMBLE_STRENGTH_NIBBLESMALL_RIGHT, RUMBLE_DURATION_NIBBLE)
	elseif catchType == ccBGSSSE001_CatchTypeLargeFish.GetValueInt()
		Game.ShakeController(RUMBLE_STRENGTH_NIBBLELARGE_LEFT, RUMBLE_STRENGTH_NIBBLELARGE_RIGHT, RUMBLE_DURATION_NIBBLE)
	endif
endFunction

function PlayHookedFishAnimation()

	AnimatedFishing_Global.SetValue(2)
	Utility.Wait(0.1)
	
	If PlayerRef.GetAnimationVariableBool("IsFirstPerson")
	else
	playerref.playidle(idlesearchingchest)
	endif
		fishingRodActivator.SetAnimationVariableFloat(self.LINETUG_ANIMVAR, self.LINETUG_TYPE_TUGFISH)
		fishingRodActivator.PlayAnimation(self.NIBBLE_ANIM)
		utility.Wait(self.DURATION_HOOKED_ANIM_WAIT)
		Int catchType = nextCatchData.getCatchType()
		fishingRodActivator.PlayAnimation(self.LINETUG_FISH_ANIM)
		if catchType == ccBGSSSE001_CatchTypeSmallFish.GetValueInt()
			game.ShakeController(self.RUMBLE_STRENGTH_HOOKEDSMALLFISH_LEFT, self.RUMBLE_STRENGTH_HOOKEDSMALLFISH_RIGHT, self.RUMBLE_DURATION_HOOKED)
			utility.Wait(self.RUMBLE_DURATION_HOOKED - 0.100000)
			game.ShakeController(self.RUMBLE_STRENGTH_HOOKED_LEFTCONSTANT, self.RUMBLE_STRENGTH_HOOKED_RIGHTCONSTANT, self.RUMBLE_DURATION_HOOKEDCONSTANT)
		elseIf catchType == ccBGSSSE001_CatchTypeLargeFish.GetValueInt()
			game.ShakeController(self.RUMBLE_STRENGTH_HOOKEDLARGEFISH_LEFT, self.RUMBLE_STRENGTH_HOOKEDLARGEFISH_RIGHT, self.RUMBLE_DURATION_HOOKED)
			utility.Wait(self.RUMBLE_DURATION_HOOKED - 0.100000)
			game.ShakeController(self.RUMBLE_STRENGTH_HOOKEDLARGEFISH_LEFTCONSTANT, self.RUMBLE_STRENGTH_HOOKEDLARGEFISH_RIGHTCONSTANT, self.RUMBLE_DURATION_HOOKEDCONSTANT)
		endIf
	endFunction

;; LLFP: Taken from SFO for its compatibility
function PlayHookedObjectAnimation()
	AnimatedFishing_Global.SetValue(2)
	Utility.Wait(0.1)
	
	If PlayerRef.GetAnimationVariableBool("IsFirstPerson")
	;Debug.SendanimationEvent(PlayerRef, "Idleboundkneesenterinstant")
	else
	playerref.playidle(idlesearchingchest)
	endif
		fishingRodActivator.SetAnimationVariableFloat(self.LINETUG_ANIMVAR, self.LINETUG_TYPE_TUGOBJECT)
		fishingRodActivator.PlayAnimation(self.NIBBLE_ANIM)
		utility.Wait(self.DURATION_HOOKED_ANIM_WAIT)
		fishingRodActivator.PlayAnimation(self.LINETUG_OBJECT_ANIM)
		game.ShakeController(self.RUMBLE_STRENGTH_HOOKEDOBJECT_LEFT, self.RUMBLE_STRENGTH_HOOKEDOBJECT_RIGHT, self.RUMBLE_DURATION_HOOKED)
		utility.Wait(self.RUMBLE_DURATION_HOOKED - 0.100000)
		game.ShakeController(self.RUMBLE_STRENGTH_HOOKED_LEFTCONSTANT, self.RUMBLE_STRENGTH_HOOKED_RIGHTCONSTANT, self.RUMBLE_DURATION_HOOKEDCONSTANT)
	endFunction


function PlayCatchSuccessAnimation()
	fishingRodActivator.PlayAnimation(CATCH_SUCCESS_ANIM)

	int catchType = nextCatchData.getCatchType()

	if catchType == ccBGSSSE001_CatchTypeSmallFish.GetValueInt()
		Game.ShakeController(RUMBLE_STRENGTH_SUCCESSSMALLFISH_LEFT, RUMBLE_STRENGTH_SUCCESSSMALLFISH_RIGHT, RUMBLE_DURATION_SUCCESS)
	elseif catchType == ccBGSSSE001_CatchTypeLargeFish.GetValueInt()
		Game.ShakeController(RUMBLE_STRENGTH_SUCCESSLARGEFISH_LEFT, RUMBLE_STRENGTH_SUCCESSLARGEFISH_RIGHT, RUMBLE_DURATION_SUCCESS)
	else
		Game.ShakeController(RUMBLE_STRENGTH_SUCCESSLARGEFISH_LEFT, RUMBLE_STRENGTH_SUCCESSLARGEFISH_RIGHT, RUMBLE_DURATION_SUCCESS)
	endif
endFunction

function PlayCatchFailureAnimation()
	fishingRodActivator.PlayAnimation(CATCH_FAILURE_ANIM)

	Game.ShakeController(RUMBLE_STRENGTH_FAILURE_LEFT, RUMBLE_STRENGTH_FAILURE_RIGHT, RUMBLE_DURATION_FAILURE)
endFunction

function PlayFastExitAnimation()
	fishingRodActivator.PlayAnimation(FASTEXIT_ANIM)
endFunction

function TryToApplyRainWeather()
	; If the player is wearing equipment that summons rain, and this is
	; a Temperate fishing spot, force the weather to rain.

	int biomeType = currentFishingSupplies.BiomeType
	if PlayerRef.WornHasKeyword(ccBGSSSE001_SummonsRain) && (biomeType == BIOME_TYPE_STREAM || biomeType == BIOME_TYPE_LAKE)
		; Override the weather check for fishing purposes.
		forcedRainWeather = true

		; Change the weather visuals if necessary.
		Weather currentWeather = Weather.GetCurrentWeather()
		if currentWeather.GetClassification() != 2 ; Rain
			previousWeather = currentWeather
			SkyrimStormRain.SetActive(true, true)
		endif
	endif
endFunction

;/ 
 / System Tear-Down
 /;

 ;; Taken from SFO for its compatibility
 function RestoreCameraAndControls(Bool abFastExit)

	PlayerRef.PlayIdle(idlestop_loose)
	
	game.EnablePlayerControls(true, true, true, true, true, true, true, true, 0)
	
	If FishingCamera.GetValue() == 1 && WasInThird == True
		;game.ForceThirdPerson()
		Input.TapKey(Input.GetMappedKey("Toggle POV"))
		WasInThird = False
	endIf
	
	AnimatedFishing_Global.SetValue(0)
	Utility.wait(0.25)
	PlayerRef.EquipItemEx(Weapon1, 1, false, false)
	PlayerRef.EquipItemEx(Weapon2, 1, false, false)
	ToggleDisableHeadtracking(False, False)
	endFunction
	
	Bool function PlayerHasCaughtFishBefore()
	
		return ccBGSSSE001_HasCaughtFishAtLeastOnce.GetValueInt() != 0
	endFunction
	

function ResetSystem()
	ClearFishingSessionVariables()
	ClearFishingAttemptVariables()
endFunction

function ClearFishingSessionVariables()
	startedInFirstPerson = false
	startedWithTorch = false
	fishingRodActivator = None
	nextUpdateType = 0
	currentFishingRodType = -1
endFunction

function ClearFishingAttemptVariables()
	nextCatchData = None
	currentCatchSequenceIndex = 0
	lastCatchWasRare = false
	isQuestItemCatch = false
	forcedRainWeather = false
endFunction


function CleanUp(bool abFastExit = false)
	FishingDebug("Cleaning up...")
	currentSystemState = SYSTEMSTATE_CLEANUP
	UnregisterForUpdate()
	DialogueQuest.StopUpdating()
	CleanUpFishingRodActivator(abFastExit)

	if abFastExit
		ReturnSurroundingVolumes()
		ResumeFollowerBehavior()
		RestoreWeather()
	endif

	lastFishingSupplies = currentFishingSupplies
	if startedWithTorch
		PlayerRef.EquipItem(Torch01, abSilent = true)
	endif
	RestoreCameraAndControls(abFastExit)
	ClearFishingAttemptVariables()
	currentSystemState = SYSTEMSTATE_IDLE
	FishingDebug("Done!")
endFunction

function CleanUpFishingRodActivator(bool abFastExit)
	if fishingRodActivator
		if abFastExit
			fishingRodActivator.PlayAnimation(FASTEXIT_ANIM)
			Wait(DURATION_FASTEXIT)
		endif

		fishingRodActivator.Disable()
		fishingRodActivator.Delete()
		fishingRodActivator = None
	endif
endFunction

;/ 
 / Radiant Fish Event Listener
 /;
function RegisterRadiantFishEventListener(ccBGSSSE001_RadiantFishEventListener listener)
	RadiantFishEventListener = listener
endFunction

function UnregisterRadiantFishEventListener()
	RadiantFishEventListener = None
endFunction

;/ 
 / Utility
 /;

bool function IsFishingAllowed(int aiFishingRodType)
	; Check if fishing is allowed right now.
	; If not, also handle displaying an appropriate error message.

	if aiFishingRodType == RODTYPE_NONE
		ccBGSSSE001_ErrorRodRequired.Show()
		return false
	endif

	; Is the player jumping?
	if PlayerRef.GetAnimationVariableBool("bInJumpState")
		ccBGSSSE001_ErrorNoFishJumping.Show()
		return false
	endif

	; Is the player mounted?
	if PlayerRef.IsOnMount()
		ccBGSSSE001_ErrorNoFishMounted.Show()
		return false
	endif

	; Is the player using another object?
	if PlayerRef.GetSitState() != 0
		ccBGSSSE001_ErrorNoFishSitting.Show()
		return false
	endif

	; Is the player in combat?
	if PlayerRef.GetCombatState() != 0
		ccBGSSSE001_ErrorNoFishCombat.Show()
		return false
	endif

;; LLFP: Taken from SFO for its compat
;;;;;;;;;;;;;;;; This is the bit for the bait stuff ;;;;;;;;;;;;;;;;;;;;

	if BaitReq.GetValue() == 1 && !PlayerRef.HasMagicEffect(_LLFP_JunkSpellEffect) ; With Junkspell theres no need for bait even if its activated
		if PlayerRef.GetItemCount(AnimatedFishing_Bait) == 0
			AnimatedFishing_NoBait.Show()
			return false
		else

			int ListSize = AnimatedFishing_Bait.GetSize()
			int CurrentItems = 0
			int ItemsLeft = 1

			while CurrentItems <= ListSize && ItemsLeft > 0
					Form CurrentItem1 = AnimatedFishing_Bait.GetAt(CurrentItems)
					int ItemCount = PlayerREF.GetItemCount(CurrentItem1)

					PlayerREF.RemoveItem(CurrentItem1, ItemsLeft)
					ItemsLeft -= ItemCount
					CurrentItems += 1
			endwhile
		endif
	endif
;;;;;;;;;;;;;;;;;; This is where the bit for the bait stuff ends ;;;;;;;;;;;;;;;

	return true
endFunction

bool function IsFishCatchType(int aiCatchType)
	return aiCatchType <= ccBGSSSE001_CatchTypeLargeFish.GetValueInt()
endFunction

bool function IsItemCatchType(int aiCatchType)
	return aiCatchType == ccBGSSSE001_CatchTypeObject.GetValueInt()
endFunction

;; LLFP: Taken Out for SFO compatibility

; bool function PlayerHasCaughtFishBefore()
; 	return ccBGSSSE001_HasCaughtFishAtLeastOnce.GetValueInt() != 0
; endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function TryToStartQuestAfterFirstCatch()
	if !PlayerHasCaughtFishBefore()
		ccBGSSSE001_HasCaughtFishAtLeastOnce.SetValueInt(1)
		ccBGSSSE001_Start_MQ2.Start()
	endif
endFunction

int function GetCurrentFishingRodType()
	Weapon equippedWeaponRightHand = PlayerRef.GetEquippedWeapon()
	if equippedWeaponRightHand
		int rodType = ccBGSSSE001_FishingRods.Find(equippedWeaponRightHand)
		if rodType > -1
			return rodType
		endif
	endif

	Weapon equippedWeaponLeftHand = PlayerRef.GetEquippedWeapon(abLeftHand = true)
	if equippedWeaponLeftHand
		int rodType = ccBGSSSE001_FishingRods.Find(equippedWeaponLeftHand)
		if rodType > -1
			return rodType
		endif
	endif

	return RODTYPE_NONE
endFunction

float function GetFishCatchThresholdModifier()
	; Dwarven fishing rods greatly increase the chances
	; of catching junk.

	if currentFishingRodType == RODTYPE_DWARVEN
		return 4.0
	else
		return 1.0
	endif
endFunction

float function GetFishPopulationJunkModifier()
	int currentPopulation = currentFishingSupplies.GetCurrentFishPopulation()
	if currentPopulation >= POPULATION_COUNT_FULL
		return 1.0
	elseif currentPopulation < POPULATION_COUNT_FULL && currentPopulation > 0
		return 2.0
	else
		return 100.0
	endif
endFunction

float function GetSmallCatchThresholdModifier()
	;/
	 / Imperial and Dwarven fishing rods have a nominal
	 / chance of catching small and large fish. Alik'ri
	 / rods have a higher chance of catching small fish.
	 / Argonian rods have a higher chance of catching
	 / large fish.
	 /;
	if currentFishingRodType == 0 || currentFishingRodType == RODTYPE_DWARVEN
		return 1.0
	elseif currentFishingRodType == RODTYPE_ALIKRI
		return 0.4
	elseif currentFishingRodType == RODTYPE_ARGONIAN
		return 1.6
	endif
endFunction

float function GetInitialWaitingPeriod()
	return DURATION_INITIAL_WAITING_PERIOD + (RandomFloat(-DURATION_INITIAL_WAITING_PERIOD_VARIANCE, DURATION_INITIAL_WAITING_PERIOD_VARIANCE))
	;return (2) ;; LLFP DEBUG VALUE
endFunction

int function GetFishBasePopulation()
	return BASE_POPULATION + RandomInt(BASE_BONUS_MIN, BASE_BONUS_MAX)
endFunction

int function GetFishPopulationMorningEveningBonus()
	return RandomInt(MORNINGEVENING_BONUS_MIN, MORNINGEVENING_BONUS_MAX)
endFunction

bool function GetInRain()
	Weather theWeather

	; If using equipment that summons rain, we are always in rainy weather.
	if forcedRainWeather
		return true
	endif

	; Wait for weather to mostly transition in before counting it.
	; Otherwise, use the previous weather.
	if Weather.GetCurrentWeatherTransition() >= 0.50
		theWeather = Weather.GetCurrentWeather()
	else
		theWeather = Weather.GetOutgoingWeather()
	endif

	return theWeather.GetClassification() == 2 ; Rain
endFunction

bool function GetIsMorningEvening()
	return (currentGameHour >= GAMETIME_MORNING && currentGameHour < GAMETIME_LATEMORNING) || (currentGameHour >= GAMETIME_EVENING && currentGameHour < GAMETIME_LATEEVENING)
endFunction

ccBGSSSE001_FishingActScript function GetCurrentFishingSupplies()
	return currentFishingSupplies
endFunction

bool function IsPlayerDrawingWeapon()
	return PlayerRef.GetAnimationVariableBool("IsEquipping")
endFunction

bool function IsValidUpdateSystemState()
	return currentSystemState >= SYSTEMSTATE_FISHING && currentSystemState <= SYSTEMSTATE_HOOKED
endFunction

function ResumeFollowerBehavior()
	Actor follower = FollowerAlias.GetActorRef()
	Actor dog = DogAlias.GetActorRef()
	ccBGSSSE001_FishingFollowerIdleQuest.Stop()
	if follower
		follower.EvaluatePackage()
	endif
	if dog
		dog.EvaluatePackage()
	endif
endFunction

function RestoreWeather()
	if forcedRainWeather
		Weather.ReleaseOverride()
		if previousWeather
			previousWeather.SetActive(false, true)
			previousWeather = None
		endif
	endif
endFunction

bool function IsInExitableSystemState()
	return currentSystemState != SYSTEMSTATE_CATCH_RESOLVE && currentSystemState != SYSTEMSTATE_CLEANUP
endFunction

;/ 
 / Debugging
 /;

function CheckEnableDebug()
	if ccBGSSSE001_FishingDebugEnabled.GetValueInt() == 1
		debugEnabled = true
	else
		debugEnabled = false
	endif
endFunction

function FishingDebug(string asMessage)
	if debugEnabled
		debug.trace(asMessage)
	endif
endFunction
