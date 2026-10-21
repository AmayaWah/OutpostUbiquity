/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/living/swap_hands
	hotkey_keys = list("X", "Northeast")
	name = "swap_hands"
	full_name = "Swap hands"
	description = ""

/datum/keybinding/living/swap_hands/down(client/user)
	if(!isliving(user.mob))
		return FALSE
	user.swap_hand()
	return TRUE

/datum/keybinding/living/activate_inhand
	hotkey_keys = list("Z", "Southeast")
	name = "activate_inhand"
	full_name = "Activate in-hand"
	description = "Uses whatever item you have inhand"

/datum/keybinding/living/activate_inhand/down(client/user)
	if(!isliving(user.mob))
		return FALSE
	user.attack_self()
	return TRUE

/datum/keybinding/living/drop_item
	hotkey_keys = list("Q", "Northwest")
	name = "drop_item"
	full_name = "Drop Item"
	description = ""

/datum/keybinding/living/drop_item/down(client/user)
	if(!isliving(user.mob))
		return FALSE
	user.drop_item()
	return TRUE

/datum/keybinding/living/resist
	hotkey_keys = list("B")
	name = "cancelresist"
	full_name = "Resist"
	description = "Spam this to resist against a grab."

/datum/keybinding/living/resist/down(client/user)
	var/mob/living/L = user.mob
	if(!istype(L))
		return FALSE
	L.resist()
	return TRUE

/datum/keybinding/living/restd
	hotkey_keys = list("U")
	name = "standrest"
	full_name = "Toggle Stand/Rest"
	description = "Toggle between standing and laying on the floor."

/datum/keybinding/living/restd/down(client/user)
	var/mob/living/L = user.mob
	if(!istype(L))
		return FALSE
	L.lay_down()
	return TRUE
