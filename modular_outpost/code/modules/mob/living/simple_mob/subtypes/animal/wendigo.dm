/mob/living/simple_mob/creature/wendigo
	name = "???"                                    // what players see
	desc = "Something that should not be."                // examine text
	icon = 'modular_outpost/icons/mob/wendigo.dmi'      // your .dmi file, in single quotes
	icon_state = "wendigo"                               // the default sprite
	icon_living = "wendigo"                              // sprite while alive
	icon_dead = "wendigo_dead"                           // sprite when it dies
	pixel_x = -16
	default_pixel_x = -16
	maxHealth = 200                       // tougher; keep health equal to maxHealth
	health = 200
	melee_damage_lower = 15               // weaker bites
	melee_damage_upper = 30
	attacktext = list("slashed", "clawed")   // picks one at random each hit
	speak_emote = list("screeches")         // "The my horror hisses."
	movement_cooldown = 0                // higher = slower; lower = faster
	ai_holder_type = /datum/ai_holder/simple_mob/melee/wendigo


	// The wendigo's brain: a normal melee AI that screeches when it spots prey
/datum/ai_holder/simple_mob/melee/wendigo
	COOLDOWN_DECLARE(screech_cooldown)   // a timer so it doesn't scream nonstop

/datum/ai_holder/simple_mob/melee/wendigo/give_target(new_target, urgent = FALSE)
	. = ..()                             // do everything the normal AI does first
	if(. && COOLDOWN_FINISHED(src, screech_cooldown))
		playsound(holder, 'modular_outpost/sound/effects/wendigohowl.ogg', 100, TRUE)
		COOLDOWN_START(src, screech_cooldown, 10 SECONDS)
