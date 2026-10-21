// Set a client's focus to an object and override these procs on that object to let it handle keypresses

/// Called when a key is pressed down initially
/datum/proc/key_down(key, client/user)
	return

/// Called when a key is released
/datum/proc/key_up(key, client/user)
	return

/// Called once every server tick
/datum/proc/keyLoop(client/user)
	set waitfor = FALSE
	return

/// Set mob's focus. TODO: Decide if required.
/mob/proc/set_focus(datum/new_focus)
	if(focus == new_focus)
		return
	focus = new_focus

/client/verb/fix_macros()
	set name = "Fix Keybindings"
	set desc = "Re-assert all your macros/keybindings."
	set category = "OOC.Misc"
	if(!SSinput.initialized)
		to_chat(src, span_warning("Input hasn't been initialized yet. Wait a while."))
		return
	to_chat(src, span_danger("Force-reasserting all macros."))
	set_macros()

/// Removes every element from a macro set, so keys that are no longer bound don't stay behind.
/client/proc/erase_macro_set(name)
	var/list/elements = params2list(winget(src, "[name].*", "command"))
	var/erase_output = ""
	for(var/k in 1 to length(elements))
		var/list/split_name = splittext(elements[k], ".")
		erase_output = "[erase_output];[split_name[1]].[split_name[2]].parent=null" // [3] is "command"
	if(erase_output)
		winset(src, null, erase_output)

/client/proc/apply_macro_set(name, list/macroset)
	ASSERT(name)
	ASSERT(islist(macroset))
	erase_macro_set(name)
	if(!winexists(src, name))
		winclone(src, "default", name)
	for(var/i in 1 to length(macroset))
		var/key = macroset[i]
		var/command = macroset[key]
		winset(src, "[name]-[REF(key)]", "parent=[name];name=[key];command=[command]")

/client/proc/ensure_keys_set(datum/preferences/prefs_override = prefs)
	if(SSinput.initialized)
		full_macro_assert(prefs_override)

/client/proc/full_macro_assert(datum/preferences/prefs_override = prefs)
	INVOKE_ASYNC(src, PROC_REF(set_macros), prefs_override)

/client/proc/set_macros(datum/preferences/prefs_override = prefs)
	set waitfor = FALSE

	// Remember the mode they are in now, as rebuilding the macros below can change what the window reports
	var/previous_macroset = winget(src, "mainwindow", "macro")

	// First, wipe
	keys_held.Cut()

	update_movement_keys(prefs_override)
	// Collect sets. Make sure to COPY, as we are modifying these!
	var/list/macrosets = list(
		SKIN_MACROSET_CLASSIC_INPUT = SSinput.macroset_classic_input.Copy(),
		SKIN_MACROSET_CLASSIC_HOTKEYS = SSinput.macroset_classic_hotkey.Copy()
	)
	// Collect special clientside keybinds
	var/list/clientside = update_special_keybinds(prefs_override)
	// The input-focused set only gets a keybind with Ctrl forced on, so typing isn't swallowed.
	// The hotkey-focused set gets the key as bound.
	for(var/keybind in clientside)
		var/command = clientside[keybind]
		var/alt = findtext(keybind, "Alt")
		if(alt)
			keybind = copytext(keybind, 1, alt) + copytext(keybind, alt + 3, 0)
		var/ctrl = findtext(keybind, "Ctrl")
		if(ctrl)
			keybind = copytext(keybind, 1, ctrl) + copytext(keybind, ctrl + 4, 0)
		var/shift = findtext(keybind, "Shift")
		if(shift)
			keybind = copytext(keybind, 1, shift) + copytext(keybind, shift + 5, 0)
		var/bound = "[alt ? "Alt+" : ""][ctrl ? "Ctrl+" : ""][shift ? "Shift+" : ""][keybind]"
		var/input_bound = (alt || ctrl) ? bound : "Ctrl+[bound]"
		macrosets[SKIN_MACROSET_CLASSIC_HOTKEYS][findtext(bound, "+") ? "\"[bound]\"" : bound] = command
		macrosets[SKIN_MACROSET_CLASSIC_INPUT][findtext(input_bound, "+") ? "\"[input_bound]\"" : input_bound] = command
		// Function keys never type anything, so they can run straight from the input-focused set too.
		if(bound == keybind && copytext(keybind, 1, 2) == "F" && isnum(text2num(copytext(keybind, 2))))
			macrosets[SKIN_MACROSET_CLASSIC_INPUT][keybind] = command

	apply_macro_set(SKIN_MACROSET_CLASSIC_INPUT, macrosets[SKIN_MACROSET_CLASSIC_INPUT])
	apply_macro_set(SKIN_MACROSET_CLASSIC_HOTKEYS, macrosets[SKIN_MACROSET_CLASSIC_HOTKEYS])

	// Pick up the new macros without kicking the player out of the mode they are in
	if(previous_macroset == SKIN_MACROSET_CLASSIC_INPUT || previous_macroset == SKIN_MACROSET_CLASSIC_HOTKEYS)
		winset(src, null, "mainwindow.macro=[previous_macroset] hotkey_toggle.is-checked=[previous_macroset == SKIN_MACROSET_CLASSIC_HOTKEYS ? "true" : "false"]")
	else
		set_hotkeys_macro()

/// Swaps between the input bar being focused and hotkeys being focused, the same as the hotkey toggle button.
/client/proc/toggle_hotkey_mode()
	set waitfor = FALSE
	// A Tab press can reach us more than once, and two swaps would cancel out
	if(world.time < last_hotkey_toggle + 2)
		return
	last_hotkey_toggle = world.time
	var/to_hotkeys = winget(src, "mainwindow", "macro") == SKIN_MACROSET_CLASSIC_INPUT
	if(to_hotkeys)
		winset(src, null, "mainwindow.macro=[SKIN_MACROSET_CLASSIC_HOTKEYS] hotkey_toggle.is-checked=true mapwindow.map.focus=true")
	else
		winset(src, null, "mainwindow.macro=[SKIN_MACROSET_CLASSIC_INPUT] hotkey_toggle.is-checked=false input.focus=true")

/**
  * Updates the keys that move the mob
  *
  * Arguments:
  * * direct_prefs - the preference we're going to get keybinds from
  */
/client/proc/update_movement_keys(datum/preferences/direct_prefs)
	var/datum/preferences/D = direct_prefs || prefs
	if(!D?.key_bindings)
		return
	movement_keys = list()
	for(var/key in D.key_bindings)
		for(var/kb_name in D.key_bindings[key])
			switch(kb_name)
				if("North")
					movement_keys[key] = NORTH
				if("East")
					movement_keys[key] = EAST
				if("West")
					movement_keys[key] = WEST
				if("South")
					movement_keys[key] = SOUTH

/**
  * Gets the keybinds that need a macro of their own
  *
  * At the time of writing this, the communication keybinds (Say, Me, Whisper, Subtle, OOC) require macros.
  * Arguments:
  * * direct_prefs - the preference we're going to get keybinds from
  *
  * Returns list of special keybind in key = clientside verb format, with the key in Mod1Mod2Mod3Key format, NOT Mod1+Mod2+Mod3+Key format.
  */
/client/proc/update_special_keybinds(datum/preferences/direct_prefs)
	var/datum/preferences/D = direct_prefs || prefs
	. = list()
	if(!D?.key_bindings)
		return
	for(var/key in D.key_bindings)
		for(var/kb_name in D.key_bindings[key])
			var/datum/keybinding/KB = GLOB.keybindings_by_name[kb_name]
			if(!KB?.clientside)
				continue
			.[key] = KB.clientside
