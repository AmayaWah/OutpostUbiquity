/datum/keybinding/admin
	category = CATEGORY_ADMIN
	weight = WEIGHT_ADMIN

/datum/keybinding/admin/admin_ghost
	hotkey_keys = list()
	name = "admin_ghost"
	full_name = "Aghost"
	description = "Go ghost"

/datum/keybinding/admin/admin_ghost/down(client/user)
	if(!user.holder)
		return FALSE
	SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/admin_ghost)
	return TRUE

/datum/keybinding/admin/player_panel_new
	hotkey_keys = list("F6")
	name = "player_panel_new"
	full_name = "Player Panel New"
	description = "Opens up the new player panel"

/datum/keybinding/admin/player_panel_new/down(client/user)
	if(!user.holder)
		return FALSE
	SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/player_panel_new)
	return TRUE

// Outpost-specific from here on.

/// Admin chat verbs that take a message; prompts for it, then invokes the verb.
/datum/keybinding/admin/chat
	/// The /datum/admin_verb to send the message with
	var/admin_verb_type
	var/prompt_title

/datum/keybinding/admin/chat/down(client/user)
	if(!user.holder)
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(prompt_message), user)
	return TRUE

/datum/keybinding/admin/chat/proc/prompt_message(client/user)
	var/message = tgui_input_text(user, "Message:", prompt_title)
	if(message)
		SSadmin_verbs.dynamic_invoke_verb(user, admin_verb_type, message)

/datum/keybinding/admin/chat/admin_say
	hotkey_keys = list("F5")
	name = "admin_say"
	full_name = "Admin say"
	description = "Talk with other admins."
	admin_verb_type = /datum/admin_verb/cmd_admin_say
	prompt_title = "ASay"

/datum/keybinding/admin/chat/mod_say
	hotkey_keys = list("F9")
	name = "mod_say"
	full_name = "Mod say"
	description = "Talk with other mods."
	admin_verb_type = /datum/admin_verb/cmd_mod_say
	prompt_title = "Msay"

/datum/keybinding/admin/chat/event_say
	hotkey_keys = list("F10")
	name = "event_say"
	full_name = "Event say"
	description = "Talk with other event managers."
	admin_verb_type = /datum/admin_verb/cmd_event_say
	prompt_title = "Esay"

/datum/keybinding/admin/chat/mentor_say
	hotkey_keys = list("F11")
	name = "mentor_say"
	full_name = "Mentor say"
	description = "Talk with other mentors."
	admin_verb_type = /datum/admin_verb/cmd_mentor_say
	prompt_title = "Mentorsay"

/datum/keybinding/admin/admin_pm
	hotkey_keys = list("F7")
	name = "admin_pm"
	full_name = "Admin PM"
	description = "Directly message a player."

/datum/keybinding/admin/admin_pm/down(client/user)
	if(!user.holder)
		return FALSE
	SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/cmd_admin_pm_panel)
	return TRUE

/datum/keybinding/admin/invisimin
	hotkey_keys = list("F8")
	name = "invisimin"
	full_name = "Invisimin"
	description = "Toggles ghost-like invisibility on your mob."

/datum/keybinding/admin/invisimin/down(client/user)
	if(!user.holder)
		return FALSE
	SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/invisimin)
	return TRUE
