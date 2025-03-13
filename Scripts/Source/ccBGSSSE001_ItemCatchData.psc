scriptname ccBGSSSE001_ItemCatchData extends ccBGSSSE001_CatchData
{ Script for defining caught items. }

LeveledItem property item auto
{ The LeveledItem list to draw items from. }

;; LLFP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LLFP_QuestScript Property QuestScript auto 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; LLFP ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Form function getCaughtObject()
	Debug.Notification("Getting caught item...")
	Form caughtObject = item
	; Capture object for later use
	QuestScript.LastCaughtObject = caughtObject
	;;;;;;;;
	return caughtObject
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
int function getCatchType()
	return ccBGSSSE001_CatchTypeObject.GetValueInt()
endFunction
