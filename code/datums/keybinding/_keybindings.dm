/datum/keybinding
	var/list/hotkey_keys
	var/list/classic_keys
	var/name
	var/full_name
	var/description = ""
	var/category = CATEGORY_MISC
	var/weight = WEIGHT_LOWEST
	var/keybind_signal
	/// Is this a clientside verb trigger? If so, this should be set to the name of the verb.
	var/clientside

/datum/keybinding/New()
	// Default keys to the master "hotkey_keys"
	if(LAZYLEN(hotkey_keys) && !LAZYLEN(classic_keys))
		classic_keys = hotkey_keys.Copy()

/// Keybindings only conflict with others in the same group, so cyborg and human binds can share keys.
/datum/keybinding/proc/conflict_group()
	return category == CATEGORY_ROBOT ? "robot" : "main"

/datum/keybinding/proc/down(client/user)
	return FALSE

/datum/keybinding/proc/up(client/user)
	return FALSE
