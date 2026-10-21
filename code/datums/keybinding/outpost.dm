// Keybinds for actions that only exist in Outpost 21, with no equivalent in CC.

/datum/keybinding/mob/outpost
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/mob/outpost/intent_left
	hotkey_keys = list("F")
	name = "intent_left"
	full_name = "Cycle Intent Left"
	description = "Cycles your intent to the left."

/datum/keybinding/mob/outpost/intent_left/down(client/user)
	if(!isliving(user.mob))
		return FALSE
	user.mob.a_intent_change("left")
	return TRUE

/datum/keybinding/mob/outpost/intent_right
	hotkey_keys = list("G", "Insert")
	name = "intent_right"
	full_name = "Cycle Intent Right"
	description = "Cycles your intent to the right."

/datum/keybinding/mob/outpost/intent_right/down(client/user)
	if(!isliving(user.mob))
		return FALSE
	user.mob.a_intent_change("right")
	return TRUE

/datum/keybinding/mob/outpost/toggle_gun_mode
	hotkey_keys = list("J")
	name = "toggle_gun_mode"
	full_name = "Toggle Gun Mode"
	description = "Begin or stop aiming."

/datum/keybinding/mob/outpost/toggle_gun_mode/down(client/user)
	var/mob/M = user.mob
	if(!(/mob/verb/toggle_gun_mode in M.verbs))
		return FALSE
	M.toggle_gun_mode()
	return TRUE

/datum/keybinding/mob/outpost/stop_pulling
	hotkey_keys = list("Delete")
	name = "stop_pulling"
	full_name = "Stop pulling"
	description = ""

/datum/keybinding/mob/outpost/stop_pulling/down(client/user)
	var/mob/M = user.mob
	if(!M.pulling)
		to_chat(M, span_blue("You are not pulling anything."))
		return TRUE
	M.stop_pulling()
	return TRUE

/datum/keybinding/mob/outpost/quick_equip
	hotkey_keys = list("E")
	name = "quick_equip"
	full_name = "Quick Equip"
	description = "Quickly puts an item in the best slot available"

/datum/keybinding/mob/outpost/quick_equip/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	if(!istype(H))
		return FALSE
	H.quick_equip()
	return TRUE

/datum/keybinding/mob/outpost/holster
	hotkey_keys = list("H")
	name = "holster"
	full_name = "Holster"
	description = "Holster the held item, or draw from your holster."

/datum/keybinding/mob/outpost/holster/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	if(!istype(H) || !istype(H.w_uniform, /obj/item/clothing/under))
		return FALSE
	var/obj/item/clothing/under/uniform = H.w_uniform
	var/obj/item/clothing/accessory/holster/holster = locate() in uniform.accessories
	if(!holster)
		return FALSE
	holster.holster_verb()
	return TRUE

//****** Facing and pixel shifting ******

/datum/keybinding/mob/outpost/face_north_perm
	hotkey_keys = list("AltNorth")
	name = "face_north_perm"
	full_name = "Face North (Locked)"
	description = "Face north and keep facing that way while moving."

/datum/keybinding/mob/outpost/face_north_perm/down(client/user)
	user.mob.northfaceperm()
	return TRUE

/datum/keybinding/mob/outpost/face_east_perm
	hotkey_keys = list("AltEast")
	name = "face_east_perm"
	full_name = "Face East (Locked)"
	description = "Face east and keep facing that way while moving."

/datum/keybinding/mob/outpost/face_east_perm/down(client/user)
	user.mob.eastfaceperm()
	return TRUE

/datum/keybinding/mob/outpost/face_south_perm
	hotkey_keys = list("AltSouth")
	name = "face_south_perm"
	full_name = "Face South (Locked)"
	description = "Face south and keep facing that way while moving."

/datum/keybinding/mob/outpost/face_south_perm/down(client/user)
	user.mob.southfaceperm()
	return TRUE

/datum/keybinding/mob/outpost/face_west_perm
	hotkey_keys = list("AltWest")
	name = "face_west_perm"
	full_name = "Face West (Locked)"
	description = "Face west and keep facing that way while moving."

/datum/keybinding/mob/outpost/face_west_perm/down(client/user)
	user.mob.westfaceperm()
	return TRUE

/datum/keybinding/mob/outpost/pixel_shift_north
	hotkey_keys = list("CtrlShiftNorth")
	name = "pixel_shift_north"
	full_name = "Pixel-Shift North"
	description = ""

/datum/keybinding/mob/outpost/pixel_shift_north/down(client/user)
	user.mob.shiftnorth()
	return TRUE

/datum/keybinding/mob/outpost/pixel_shift_south
	hotkey_keys = list("CtrlShiftSouth")
	name = "pixel_shift_south"
	full_name = "Pixel-Shift South"
	description = ""

/datum/keybinding/mob/outpost/pixel_shift_south/down(client/user)
	user.mob.shiftsouth()
	return TRUE

/datum/keybinding/mob/outpost/pixel_shift_west
	hotkey_keys = list("CtrlShiftWest")
	name = "pixel_shift_west"
	full_name = "Pixel-Shift West"
	description = ""

/datum/keybinding/mob/outpost/pixel_shift_west/down(client/user)
	user.mob.shiftwest()
	return TRUE

/datum/keybinding/mob/outpost/pixel_shift_east
	hotkey_keys = list("CtrlShiftEast")
	name = "pixel_shift_east"
	full_name = "Pixel-Shift East"
	description = ""

/datum/keybinding/mob/outpost/pixel_shift_east/down(client/user)
	user.mob.shifteast()
	return TRUE

/datum/keybinding/mob/outpost/tilt_clockwise
	hotkey_keys = list("ShiftEast")
	name = "tilt_clockwise"
	full_name = "Tilt Clockwise"
	description = ""

/datum/keybinding/mob/outpost/tilt_clockwise/down(client/user)
	user.mob.tiltclock()
	return TRUE

/datum/keybinding/mob/outpost/tilt_counterclockwise
	hotkey_keys = list("ShiftWest")
	name = "tilt_counterclockwise"
	full_name = "Tilt Counter-Clockwise"
	description = ""

/datum/keybinding/mob/outpost/tilt_counterclockwise/down(client/user)
	user.mob.tiltcounterclock()
	return TRUE

/datum/keybinding/mob/outpost/plane_up
	hotkey_keys = list("CtrlShiftAdd")
	name = "plane_up"
	full_name = "Plane Up"
	description = "Draw yourself above other mobs."

/datum/keybinding/mob/outpost/plane_up/down(client/user)
	user.mob.planeup()
	return TRUE

/datum/keybinding/mob/outpost/plane_down
	hotkey_keys = list("CtrlShiftSubtract")
	name = "plane_down"
	full_name = "Plane Down"
	description = "Draw yourself below other mobs."

/datum/keybinding/mob/outpost/plane_down/down(client/user)
	user.mob.planedown()
	return TRUE

//****** Cyborg ******

/datum/keybinding/robot
	category = CATEGORY_ROBOT
	weight = WEIGHT_ROBOT

/datum/keybinding/robot/module_one
	hotkey_keys = list("1")
	name = "module_one"
	full_name = "Toggle module 1"
	description = "Equips or unequips the first module"

/datum/keybinding/robot/module_one/down(client/user)
	if(!isrobot(user.mob))
		return FALSE
	var/mob/living/silicon/robot/R = user.mob
	R.toggle_module(1)
	return TRUE

/datum/keybinding/robot/module_two
	hotkey_keys = list("2")
	name = "module_two"
	full_name = "Toggle module 2"
	description = "Equips or unequips the second module"

/datum/keybinding/robot/module_two/down(client/user)
	if(!isrobot(user.mob))
		return FALSE
	var/mob/living/silicon/robot/R = user.mob
	R.toggle_module(2)
	return TRUE

/datum/keybinding/robot/module_three
	hotkey_keys = list("3")
	name = "module_three"
	full_name = "Toggle module 3"
	description = "Equips or unequips the third module"

/datum/keybinding/robot/module_three/down(client/user)
	if(!isrobot(user.mob))
		return FALSE
	var/mob/living/silicon/robot/R = user.mob
	R.toggle_module(3)
	return TRUE

/datum/keybinding/robot/cycle_intent
	hotkey_keys = list("4")
	name = "cycle_intent"
	full_name = "Cycle intent left"
	description = "Cycles the intent left"

/datum/keybinding/robot/cycle_intent/down(client/user)
	if(!isrobot(user.mob))
		return FALSE
	user.mob.a_intent_change("left")
	return TRUE

/datum/keybinding/robot/unequip_module
	hotkey_keys = list("Q")
	name = "unequip_module"
	full_name = "Unequip module"
	description = "Unequips the active module"

/datum/keybinding/robot/unequip_module/down(client/user)
	if(!isrobot(user.mob))
		return FALSE
	var/mob/living/silicon/robot/R = user.mob
	R.uneq_active()
	return TRUE
