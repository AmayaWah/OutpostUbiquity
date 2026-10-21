// Open the TGUI say window on the OOC and LOOC channels, the same way the Say and Me wrappers do in typing_indicator.dm.
// Falls back to the old prompt when the player has TGUI say turned off.

/client/verb/ooc_wrapper()
	set name = "OOC verb"
	set category = "IC.TGUI Say"

	if(prefs?.read_preference(/datum/preference/toggle/tgui_say))
		winset(src, null, "command=[tgui_say_create_open_command(OOC_CHANNEL)]")
		winset(src, "tgui_say.browser", "focus=true")
		return

	winset(src, null, "command=ooc")

/client/verb/looc_wrapper()
	set name = "LOOC verb"
	set category = "IC.TGUI Say"

	if(prefs?.read_preference(/datum/preference/toggle/tgui_say))
		winset(src, null, "command=[tgui_say_create_open_command(LOOC_CHANNEL)]")
		winset(src, "tgui_say.browser", "focus=true")
		return

	winset(src, null, "command=looc")
