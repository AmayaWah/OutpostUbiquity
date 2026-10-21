// Outpost-specific; these open the say windows and prompts, so they are clientside verb triggers.
// Their macro runs the command directly, so they don't need a down().
/datum/keybinding/client/communication
	category = CATEGORY_COMMUNICATION

/datum/keybinding/client/communication/say
	hotkey_keys = list("T", "F3")
	name = "Say"
	full_name = "Say"
	description = "Opens the say window."
	clientside = "Say-verb"

/datum/keybinding/client/communication/me
	hotkey_keys = list("5", "F4")
	name = "Me"
	full_name = "Me (emote)"
	description = "Opens the emote window."
	clientside = "Me-verb"

/datum/keybinding/client/communication/whisper
	hotkey_keys = list("Y")
	name = "Whisper"
	full_name = "Whisper"
	description = "Opens the whisper window."
	clientside = "Whisper-verb"

/datum/keybinding/client/communication/subtle
	hotkey_keys = list("6")
	name = "Subtle"
	full_name = "Subtle (emote)"
	description = "Opens the subtle emote window."
	clientside = "Subtle-verb"

/datum/keybinding/client/communication/ooc
	hotkey_keys = list("F2")
	name = "OOC"
	full_name = "OOC"
	description = "Opens the OOC window."
	clientside = "OOC-verb"

/datum/keybinding/client/communication/looc
	hotkey_keys = list()
	name = "LOOC"
	full_name = "LOOC"
	description = "Opens the LOOC window."
	clientside = "LOOC-verb"
