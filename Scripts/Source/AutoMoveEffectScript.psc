Scriptname AutoMoveEffectScript extends ActiveMagicEffect
{Fallback: if effect hits an ObjectReference, path to it. Ground hits use explosion-placed marker instead.}

Event OnEffectStart(Actor akTarget, Actor akCaster)
	if akTarget && akCaster == Game.GetPlayer()
		Game.GetPlayer().PathToReference(akTarget, 1.0)
	endif
EndEvent