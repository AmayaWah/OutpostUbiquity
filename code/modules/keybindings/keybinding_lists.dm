GLOBAL_LIST_EMPTY_TYPED(classic_keybinding_list_by_key, /list)
GLOBAL_LIST_EMPTY_TYPED(hotkey_keybinding_list_by_key, /list)
GLOBAL_LIST_EMPTY(keybindings_by_name)

// This is a mapping from JS keys to Byond - ref: https://keycode.info/
GLOBAL_LIST_INIT(_kbMap, list(
	"UP" = "North",
	"RIGHT" = "East",
	"DOWN" = "South",
	"LEFT" = "West",
	"INSERT" = "Insert",
	"HOME" = "Northwest",
	"PAGEUP" = "Northeast",
	"DEL" = "Delete",
	"END" = "Southwest",
	"PAGEDOWN" = "Southeast",
	" " = "Space",
	"ALT" = "Alt",
	"SHIFT" = "Shift",
	"CONTROL" = "Ctrl"
	))

/// A fresh copy of the default keybindings. deepCopyList() doesn't copy the lists inside an associative list, so players would share them.
/proc/get_default_keybindings()
	. = list()
	for(var/key in GLOB.hotkey_keybinding_list_by_key)
		var/list/default_binds = GLOB.hotkey_keybinding_list_by_key[key]
		.[key] = default_binds.Copy()

/// Turns a key sent by the keybindings UI into the format keyDown() builds (Alt, Ctrl, Shift, then the key), or null if it isn't a bindable key.
/proc/normalize_keybind_key(raw_key)
	var/static/list/valid_keys
	if(!valid_keys)
		valid_keys = list("North", "South", "East", "West", "Northeast", "Southeast", "Northwest", "Southwest", "Insert", "Delete", "Space", "Add", "Subtract", "Multiply", "Divide", "Decimal", "`", "-", "=", "\[", "\]", "\\", ";", "'", ",", ".", "/")
		for(var/i in 0 to 9)
			valid_keys += "[i]"
			valid_keys += "Numpad[i]"
		for(var/i in 1 to 12)
			valid_keys += "F[i]"
		for(var/i in 65 to 90)
			valid_keys += ascii2text(i)
	if(!istext(raw_key) || length(raw_key) > MAX_KEYPRESS_COMMANDLENGTH)
		return null
	var/key = raw_key
	var/modifiers = ""
	for(var/modifier in list("Alt", "Ctrl", "Shift"))
		if(copytext(key, 1, length(modifier) + 1) == modifier)
			modifiers += modifier
			key = copytext(key, length(modifier) + 1)
	if(!(key in valid_keys))
		return null
	return "[modifiers][key]"

/// Creates and sorts all the keybinding datums
/proc/init_keybindings()
	for(var/KB in subtypesof(/datum/keybinding))
		var/datum/keybinding/keybinding = KB
		// Abstract category parents have no name
		if(!initial(keybinding.name))
			continue
		add_keybinding(new keybinding)
	init_emote_keybinds()

/// Makes a keybinding for every emote key. Reads the keys off the emote types, so no emote has to be created.
/proc/init_emote_keybinds()
	for(var/emote_type in subtypesof(/datum/decl/emote))
		var/datum/decl/emote/faketype = emote_type
		var/key = initial(faketype.key)
		// Abstract emotes have no key, and several types can share one
		if(!key || GLOB.keybindings_by_name["emote_[key]"])
			continue
		var/datum/keybinding/emote/emote_kb = new
		emote_kb.link_to_emote(key)
		add_keybinding(emote_kb)

/// Adds an instanced keybinding to the global tracker
/proc/add_keybinding(datum/keybinding/instance)
	GLOB.keybindings_by_name[instance.name] = instance

	// Classic
	if(LAZYLEN(instance.classic_keys))
		for(var/bound_key in instance.classic_keys)
			LAZYADD(GLOB.classic_keybinding_list_by_key[bound_key], list(instance.name))

	// Hotkey
	if(LAZYLEN(instance.hotkey_keys))
		for(var/bound_key in instance.hotkey_keys)
			LAZYADD(GLOB.hotkey_keybinding_list_by_key[bound_key], list(instance.name))
