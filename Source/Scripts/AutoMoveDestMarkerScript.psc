Scriptname AutoMoveDestMarkerScript extends ObjectReference
{Aim-ground marker: AI-driven walk (real anim + works alt-tab with bAlwaysActive).}

Quest Property AutoMoveQuest Auto
int Property PlayerAliasID = 1 Auto
int Property DestAliasID = 2 Auto
float Property StopDistance = 96.0 Auto
float Property Lifetime = 120.0 Auto
float Property WalkRunPercent = 0.0 Auto
{0.0 = walk only, 1.0 = run.}

bool moving = false
float startTime = 0.0

Event OnLoad()
	Debug.Notification("AutoMove: marker ok")

	Actor player = Game.GetPlayer()
	if !player
		Debug.Notification("AutoMove: no player")
		RegisterForSingleUpdate(2.0)
		return
	endif

	AutoMoveQuestScript questScript = None
	if AutoMoveQuest
		if !AutoMoveQuest.IsRunning()
			AutoMoveQuest.Start()
		endif
		questScript = AutoMoveQuest as AutoMoveQuestScript
		ReferenceAlias destAlias = AutoMoveQuest.GetAlias(DestAliasID) as ReferenceAlias
		if destAlias
			destAlias.ForceRefTo(Self)
		endif
	endif

	player.SheatheWeapon()
	player.StopTranslation()

	moving = true
	startTime = Utility.GetCurrentRealTime()

	RegisterForControl("Back")
	RegisterForControl("Strafe Left")
	RegisterForControl("Strafe Right")
	RegisterForControl("Jump")
	RegisterForControl("Forward")

	if questScript
		questScript.RequestWalk(Self, WalkRunPercent)
	else
		; Fallback if quest script missing: same-stack path (cancel weaker).
		Game.SetPlayerAIDriven(true)
		player.PathToReference(Self, WalkRunPercent)
		Game.SetPlayerAIDriven(false)
		Cleanup()
		return
	endif

	RegisterForUpdate(0.5)
EndEvent

Event OnControlDown(string control)
	if !moving
		return
	endif
	Debug.Notification("AutoMove: cancelled")
	Cleanup()
EndEvent

Event OnUpdate()
	Actor player = Game.GetPlayer()
	if !moving || !player
		Cleanup()
		return
	endif

	if Utility.GetCurrentRealTime() - startTime > Lifetime
		Debug.Notification("AutoMove: timeout")
		Cleanup()
		return
	endif

	if player.GetDistance(Self) <= StopDistance
		; PathToReference may still be finishing; force clean stop.
		Cleanup()
		return
	endif
EndEvent

Function Cleanup()
	if !moving
		return
	endif
	moving = false
	UnregisterForUpdate()
	UnregisterForControl("Back")
	UnregisterForControl("Strafe Left")
	UnregisterForControl("Strafe Right")
	UnregisterForControl("Jump")
	UnregisterForControl("Forward")

	if AutoMoveQuest
		AutoMoveQuestScript questScript = AutoMoveQuest as AutoMoveQuestScript
		if questScript
			questScript.CancelWalk()
		endif
		ReferenceAlias destAlias = AutoMoveQuest.GetAlias(DestAliasID) as ReferenceAlias
		if destAlias
			destAlias.Clear()
		endif
	endif

	Game.SetPlayerAIDriven(false)

	Actor player = Game.GetPlayer()
	if player
		player.StopTranslation()
	endif

	Disable()
	Delete()
EndFunction
