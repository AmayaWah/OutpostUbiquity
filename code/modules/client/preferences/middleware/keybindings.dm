/// Lets players view and change their keybindings.
/datum/preference_middleware/keybindings

/datum/preference_middleware/keybindings/get_ui_static_data(mob/user)
	var/is_admin = !!user?.client?.holder
	var/list/categories = list()
	for(var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		if(kb.category == CATEGORY_ADMIN && !is_admin)
			continue
		LAZYADD(categories[kb.category], list(list(
			"name" = kb.name,
			"full_name" = kb.full_name,
			"description" = kb.description,
			"group" = kb.conflict_group(),
			"default_keys" = kb.hotkey_keys || list(),
			"weight" = kb.weight,
		)))
	return list(
		"keybindings" = categories,
		"max_keys_per_keybind" = MAX_KEYS_PER_KEYBIND,
	)

/datum/preference_middleware/keybindings/get_ui_data(mob/user)
	var/list/keys_by_name = list()
	for(var/key in preferences.key_bindings)
		for(var/kb_name in preferences.key_bindings[key])
			LAZYADD(keys_by_name[kb_name], key)
	return list("keybindings_by_name" = keys_by_name)

/datum/preference_middleware/keybindings/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_keybind")
			return set_keybind(params, ui.user)
		if("clear_keybind")
			return clear_keybind(params, ui.user)
		if("reset_keybind")
			return reset_keybind(params, ui.user)
		if("reset_all_keybinds")
			preferences.key_bindings = get_default_keybindings()
			apply_changes()
			return TRUE
	return FALSE

/// Gets the keybinding datum a request is about, if this user is allowed to change it.
/datum/preference_middleware/keybindings/proc/get_requested_keybinding(list/params, mob/user)
	var/datum/keybinding/kb = GLOB.keybindings_by_name[params["keybinding"]]
	if(!kb)
		return null
	if(kb.category == CATEGORY_ADMIN && !user?.client?.holder)
		return null
	return kb

/// Names of the other keybindings that would stop working if kb was bound to key.
/datum/preference_middleware/keybindings/proc/get_conflicts(datum/keybinding/kb, key)
	var/list/conflicts = list()
	for(var/other_name in preferences.key_bindings[key])
		var/datum/keybinding/other = GLOB.keybindings_by_name[other_name]
		if(other && other != kb && other.conflict_group() == kb.conflict_group())
			conflicts += other_name
	return conflicts

/datum/preference_middleware/keybindings/proc/unbind(key, kb_name)
	if(!preferences.key_bindings[key])
		return
	preferences.key_bindings[key] -= kb_name
	if(!length(preferences.key_bindings[key]))
		preferences.key_bindings -= key

/// Binds kb to key, replacing whatever else is bound to that key.
/datum/preference_middleware/keybindings/proc/bind(datum/keybinding/kb, key)
	for(var/other_name in get_conflicts(kb, key))
		unbind(key, other_name)
	if(!(kb.name in preferences.key_bindings[key]))
		preferences.key_bindings[key] += list(kb.name)

/datum/preference_middleware/keybindings/proc/set_keybind(list/params, mob/user)
	var/datum/keybinding/kb = get_requested_keybinding(params, user)
	var/new_key = normalize_keybind_key(params["key"])
	if(!kb || !new_key)
		return FALSE

	var/old_key = params["old_key"]
	var/list/current_keys = list()
	for(var/key in preferences.key_bindings)
		if(kb.name in preferences.key_bindings[key])
			current_keys += key

	// Changing a key needs the old one to be one of ours, adding one needs room for it
	if(old_key)
		if(!(old_key in current_keys))
			return FALSE
	else if(length(current_keys) >= MAX_KEYS_PER_KEYBIND && !(new_key in current_keys))
		return FALSE

	// Only one action per key, so the UI has to confirm replacing before we do
	if(length(get_conflicts(kb, new_key)) && !params["replace"])
		return FALSE

	if(old_key)
		unbind(old_key, kb.name)
	bind(kb, new_key)
	apply_changes()
	return TRUE

/datum/preference_middleware/keybindings/proc/clear_keybind(list/params, mob/user)
	var/datum/keybinding/kb = get_requested_keybinding(params, user)
	if(!kb)
		return FALSE
	unbind(params["key"], kb.name)
	apply_changes()
	return TRUE

/datum/preference_middleware/keybindings/proc/reset_keybind(list/params, mob/user)
	var/datum/keybinding/kb = get_requested_keybinding(params, user)
	if(!kb)
		return FALSE
	for(var/key in preferences.key_bindings.Copy())
		unbind(key, kb.name)
	for(var/default_key in kb.hotkey_keys)
		bind(kb, default_key)
	apply_changes()
	return TRUE

/// Saves the keybindings and makes them take effect without a reconnect.
/datum/preference_middleware/keybindings/proc/apply_changes()
	preferences.save_preferences()
	var/client/C = preferences.client
	if(C)
		C.update_movement_keys()
		C.ensure_keys_set()
