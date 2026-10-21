/datum/keybinding/carbon
	category = CATEGORY_CARBON
	weight = WEIGHT_MOB

/datum/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R", "Southwest")
	name = "toggle_throw_mode"
	full_name = "Toggle throw mode"
	description = "Toggle throwing the current item or not."

/datum/keybinding/carbon/toggle_throw_mode/down(client/user)
	if(!iscarbon(user.mob))
		return FALSE
	user.toggle_throw_mode()
	return TRUE

//****** Intents ******

/datum/keybinding/carbon/intent_one
	hotkey_keys = list("1")
	name = "intent_one"
	full_name = "Select Help Intent"
	description = "Switches to the help intent."

/datum/keybinding/carbon/intent_one/down(client/user)
	if(!iscarbon(user.mob))
		return FALSE
	user.mob.a_intent_change(I_HELP)
	return TRUE

/datum/keybinding/carbon/intent_two
	hotkey_keys = list("2")
	name = "intent_two"
	full_name = "Select Disarm Intent"
	description = "Switches to the disarm intent."

/datum/keybinding/carbon/intent_two/down(client/user)
	if(!iscarbon(user.mob))
		return FALSE
	user.mob.a_intent_change(I_DISARM)
	return TRUE

/datum/keybinding/carbon/intent_three
	hotkey_keys = list("3")
	name = "intent_three"
	full_name = "Select Grab Intent"
	description = "Switches to the grab intent."

/datum/keybinding/carbon/intent_three/down(client/user)
	if(!iscarbon(user.mob))
		return FALSE
	user.mob.a_intent_change(I_GRAB)
	return TRUE

/datum/keybinding/carbon/intent_four
	hotkey_keys = list("4")
	name = "intent_four"
	full_name = "Select Harm Intent"
	description = "Switches to the harm intent."

/datum/keybinding/carbon/intent_four/down(client/user)
	if(!iscarbon(user.mob))
		return FALSE
	user.mob.a_intent_change(I_HURT)
	return TRUE
