/mob/living/simple_mob/creature/wendigo
	name = "???"
	desc = "Something that should not be."
	icon = 'modular_outpost/icons/mob/wendigo.dmi'
	icon_state = "wendigo"
	icon_living = "wendigo"
	icon_dead = "wendigo_dead"
	pixel_x = -16
	default_pixel_x = -16
	maxHealth = 200
	health = 200
	melee_damage_lower = 15
	melee_damage_upper = 30
	attacktext = list("slashed", "clawed")
	speak_emote = list("screeches")
	movement_cooldown = 1
	ai_holder_type = /datum/ai_holder/simple_mob/melee/wendigo
	movement_sound = "heavystep" // heavy1/heavy2, see get_sfx

/mob/living/simple_mob/creature/wendigo/Initialize(mapload)
	. = ..()
	RemoveElement(/datum/element/footstep, FOOTSTEP_MOB_SHOE, 1, -6) // drop the generic shoe steps, we make our own

	// The wendigo's brain: a normal melee AI that screeches when it spots prey
/datum/ai_holder/simple_mob/melee/wendigo
	COOLDOWN_DECLARE(screech_cooldown)   // a timer so it doesn't scream nonstop

/datum/ai_holder/simple_mob/melee/wendigo/give_target(new_target, urgent = FALSE)
	. = ..()                             // do everything the normal AI does first
	if(. && COOLDOWN_FINISHED(src, screech_cooldown))
		playsound(holder, 'modular_outpost/sound/effects/wendigohowl.ogg', 100, TRUE)
		COOLDOWN_START(src, screech_cooldown, 10 SECONDS)
