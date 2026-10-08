Scriptname AutoMoveQuestScript extends Quest
{Owns PathToReference stack so marker can cancel via SetPlayerAIDriven(false).}

ReferenceAlias Property PlayerAlias Auto
ReferenceAlias Property DestAlias Auto

ObjectReference pendingDest = None
float pendingSpeed = 0.0
bool walking = false

Function RequestWalk(ObjectReference dest, float walkRunPercent)
	if !dest
		Debug.Notification("AutoMove: no dest")
		return
	endif

	pendingDest = dest
	pendingSpeed = walkRunPercent
	if DestAlias
		DestAlias.ForceRefTo(dest)
	endif
	if !IsRunning()
		Start()
	endif
	RegisterForSingleUpdate(0.05)
EndFunction

Function CancelWalk()
	pendingDest = None
	if walking
		Game.SetPlayerAIDriven(false)
	endif
	walking = false
	if DestAlias
		DestAlias.Clear()
	endif
EndFunction

bool Function IsWalking()
	return walking
EndFunction

Event OnUpdate()
	ObjectReference dest = pendingDest
	pendingDest = None
	if !dest
		return
	endif

	Actor player = Game.GetPlayer()
	if !player
		Debug.Notification("AutoMove: no player")
		return
	endif

	walking = true
	Game.SetPlayerAIDriven(true)
	Debug.Notification("AutoMove: walking")

	; 0.0 = walk, 1.0 = run. Latent; cancel by SetPlayerAIDriven(false) from marker.
	bool ok = player.PathToReference(dest, pendingSpeed)

	walking = false
	Game.SetPlayerAIDriven(false)
	if DestAlias
		DestAlias.Clear()
	endif

	if ok
		Debug.Notification("AutoMove: arrived")
	else
		Debug.Notification("AutoMove: stopped")
	endif
EndEvent
