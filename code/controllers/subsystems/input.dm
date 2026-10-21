SUBSYSTEM_DEF(input)
	name = "Input"
	wait = 1 // SS_TICKER means this runs every tick
	init_stage = INITSTAGE_EARLY
	flags = SS_TICKER
	priority = FIRE_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	/// Input focused macro set. Manually set because we can't define ANY or ANY+UP for it.
	var/static/list/macroset_classic_input
	/// Map focused macro set. Everything goes to KeyDown/KeyUp; Tab swaps back to macroset_classic_input.
	var/static/list/macroset_classic_hotkey

/datum/controller/subsystem/input/Initialize()
	setup_macrosets()
	refresh_client_macro_sets()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/input/proc/setup_macrosets()
	// First, let's do the snowflake keyset!
	macroset_classic_input = list(
		"Tab" = "\"KeyDown Tab\"",
		)
	var/list/classic_mode_keys = list(
		"North", "East", "South", "West",
		"Northeast", "Southeast", "Northwest", "Southwest",
		"Insert", "Delete", "Ctrl", "Alt", "Shift",
		"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
		)
	for(var/key in classic_mode_keys)
		macroset_classic_input[key] = "\"KeyDown [key]\""
		macroset_classic_input["[key]+UP"] = "\"KeyUp [key]\""
	// LET'S PLAY THE BIND EVERY KEY GAME!
	// oh except for Backspace and Enter; if you want to use those you shouldn't have used oldmode!
	var/list/classic_ctrl_override_keys = list(
		"\[", "\]", "\\\\", ";", "'", ",", ".", "/", "-", "=", "`", "Add", "Subtract"
		)
	// i'm lazy let's play the list iteration game of numbers
	for(var/i in 0 to 9)
		classic_ctrl_override_keys += "[i]"
		classic_ctrl_override_keys += "Numpad[i]"
	// let's play the ascii game of A to Z (UPPERCASE)
	for(var/i in 65 to 90)
		classic_ctrl_override_keys += ascii2text(i)
	// let's play the list iteration game x2
	for(var/key in classic_ctrl_override_keys)
		// make sure to double double quote to ensure things are treated as a key combo instead of addition/semicolon logic.
		macroset_classic_input["\"Ctrl+[key]\""] = "\"KeyDown [key]\""
		macroset_classic_input["\"Ctrl+[key]+UP\""] = "\"KeyUp [key]\""

	// FINALLY, WE CAN DO SOMETHING MORE NORMAL FOR THE SNOWFLAKE-BUT-LESS KEYSET.
	macroset_classic_hotkey = list(
		// No Tab of its own: "Any" sends it, and a key with its own macro would be sent twice
		"Any" = "\"KeyDown \[\[*\]\]\"",
		"Any+UP" = "\"KeyUp \[\[*\]\]\"",
		)

	// Keys that stay as fixed macros in both sets
	var/list/fixed_macros = list(
		"F12" = "F12",
		"\"F2+REP\"" = "\".screenshot auto\"",
		"\"Shift+F2+REP\"" = "\".screenshot\"",
		"\"Ctrl+Shift+F1+REP\"" = "\".options\"",
		)
	for(var/key in fixed_macros)
		macroset_classic_input[key] = fixed_macros[key]
		macroset_classic_hotkey[key] = fixed_macros[key]

// Badmins just wanna have fun ♪
/datum/controller/subsystem/input/proc/refresh_client_macro_sets()
	var/list/clients = GLOB.clients
	for(var/i in 1 to length(clients))
		var/client/user = clients[i]
		user.set_macros()

/datum/controller/subsystem/input/fire()
	var/list/clients = GLOB.clients // Let's sing the list cache song
	for(var/i in 1 to length(clients))
		var/client/C = clients[i]
		C?.keyLoop()
