// Outpost-specific. One keybinding for every emote you can do by typing "*emote" in the say bar.
// They are made from the emote definitions by init_emote_keybinds(), and are unbound by default.
/datum/keybinding/emote
	category = CATEGORY_EMOTE
	weight = WEIGHT_EMOTE
	/// The emote's key, as typed after the "*"
	var/emote_key

/datum/keybinding/emote/proc/link_to_emote(key)
	emote_key = key
	name = "emote_[key]"
	full_name = capitalize(key)
	description = "Do the emote '*[key]'."
	hotkey_keys = list()

/datum/keybinding/emote/down(client/user)
	if(!user.mob)
		return FALSE
	// emote() does its own checks, and tells the player if they can't use this emote right now
	user.mob.emote(emote_key)
	return TRUE
