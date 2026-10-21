// Clients aren't datums so we have to define these procs indpendently.
// These verbs are called for all key press and release events
/client/verb/keyDown(_key as text)
	set instant = TRUE
	set hidden = TRUE

	client_keysend_amount += 1

	var/cache = client_keysend_amount

	if(keysend_tripped && next_keysend_trip_reset <= world.time)
		keysend_tripped = FALSE

	if(next_keysend_reset <= world.time)
		client_keysend_amount = 0
		next_keysend_reset = world.time + (1 SECONDS)

	//The "tripped" system is to confirm that flooding is still happening after one spike
	//not entirely sure how byond commands interact in relation to lag
	//don't want to kick people if a lag spike results in a huge flood of commands being sent
	if(cache >= MAX_KEYPRESS_AUTOKICK)
		if(!keysend_tripped)
			keysend_tripped = TRUE
			next_keysend_trip_reset = world.time + (2 SECONDS)
		else
			log_admin("Client [ckey] was just autokicked for flooding keysends; likely abuse but potentially lagspike.")
			message_admins("Client [ckey] was just autokicked for flooding keysends; likely abuse but potentially lagspike.")
			qdel(src)
			return

	///Check if the key is short enough to even be a real key
	if(LAZYLEN(_key) > MAX_KEYPRESS_COMMANDLENGTH)
		to_chat(src, span_danger("Invalid KeyDown detected! You have been disconnected from the server automatically."))
		log_admin("Client [ckey] just attempted to send an invalid keypress. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		message_admins("Client [ckey] just attempted to send an invalid keypress. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		qdel(src)
		return

	// Tab swaps between the input bar and hotkeys. The server does it so the input bar can't take focus back while the key is still being handled.
	if(_key == "Tab")
		toggle_hotkey_mode()
		return

	if(length(keys_held) > MAX_HELD_KEYS)
		keys_held.Cut(1,2)
	keys_held[_key] = TRUE
	var/movement = movement_keys[_key]
	if(movement && !(next_move_dir_sub & movement) && !keys_held["Ctrl"])
		DEBUG_INPUT("Saving [dirs2text(movement)] into next_move_dir_ADD")
		next_move_dir_add |= movement
		#ifdef CARDINAL_INPUT_ONLY
		last_move_dir_pressed = movement
		#endif

	// Client-level keybindings are ones anyone should be able to do at any time
	// Things like taking screenshots, hitting tab, and adminhelps.
	var/AltMod = keys_held["Alt"] ? "Alt" : ""
	var/CtrlMod = keys_held["Ctrl"] ? "Ctrl" : ""
	var/ShiftMod = keys_held["Shift"] ? "Shift" : ""
	var/full_key
	switch(_key)
		if("Alt", "Ctrl", "Shift")
			full_key = "[AltMod][CtrlMod][ShiftMod]"
		else
			full_key = "[AltMod][CtrlMod][ShiftMod][_key]"
	var/list/bound_keybinds = prefs?.key_bindings?[full_key]
	// The input-focused macro set only sends hotkeys as Ctrl+key, so a Ctrl+key with no binding of its own acts as the plain key.
	if(!length(bound_keybinds) && CtrlMod && !AltMod && !ShiftMod && full_key != "Ctrl")
		bound_keybinds = prefs?.key_bindings?[_key]
	var/keycount = 0
	for(var/kb_name in bound_keybinds)
		keycount++
		var/datum/keybinding/kb = GLOB.keybindings_by_name[kb_name]
		// Clientside keybinds already ran from their own macro; running them here as well would do them twice.
		if(kb && !kb.clientside)
			if(kb.down(src) && keycount >= MAX_COMMANDS_PER_KEY)
				break

	holder?.key_down(_key, src)
	mob.focus?.key_down(_key, src)

/client/verb/keyUp(_key as text)
	set instant = TRUE
	set hidden = TRUE

	client_keysend_amount += 1

	var/cache = client_keysend_amount

	if(keysend_tripped && next_keysend_trip_reset <= world.time)
		keysend_tripped = FALSE

	if(next_keysend_reset <= world.time)
		client_keysend_amount = 0
		next_keysend_reset = world.time + (1 SECONDS)

	//The "tripped" system is to confirm that flooding is still happening after one spike
	//not entirely sure how byond commands interact in relation to lag
	//don't want to kick people if a lag spike results in a huge flood of commands being sent
	if(cache >= MAX_KEYPRESS_AUTOKICK)
		if(!keysend_tripped)
			keysend_tripped = TRUE
			next_keysend_trip_reset = world.time + (2 SECONDS)
		else
			log_admin("Client [ckey] was just autokicked for flooding keyUps; likely abuse but potentially lagspike.")
			message_admins("Client [ckey] was just autokicked for flooding keyUp; likely abuse but potentially lagspike.")
			qdel(src)
			return

	///Check if the key is short enough to even be a real key
	if(LAZYLEN(_key) > MAX_KEYPRESS_COMMANDLENGTH)
		to_chat(src, span_userdanger("Invalid KeyUp detected! You have been disconnected from the server automatically."))
		log_admin("Client [ckey] just attempted to send an invalid keyUp - [_key]. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		message_admins("Client [ckey] just attempted to send an invalid keyUp - [_key]. Keymessage was over [MAX_KEYPRESS_COMMANDLENGTH] characters, autokicking due to likely abuse.")
		qdel(src)
		return

	keys_held -= _key
	var/movement = movement_keys[_key]
	if(movement && !(next_move_dir_add & movement))
		DEBUG_INPUT("Saving [dirs2text(movement)] into next_move_dir_SUB")
		next_move_dir_sub |= movement

	// We don't do full key for release, because for mod keys you
	// can hold different keys and releasing any should be handled by the key binding specifically
	for(var/kb_name in prefs?.key_bindings?[_key])
		var/datum/keybinding/kb = GLOB.keybindings_by_name[kb_name]
		if(kb)
			if(kb.up(src))
				break
	holder?.key_up(_key, src)
	mob.focus?.key_up(_key, src)

// Called every game tick
/client/keyLoop()
	mob.focus?.keyLoop(src)
