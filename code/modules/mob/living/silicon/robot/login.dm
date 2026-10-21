/mob/living/silicon/robot/Login()
	..()
	regenerate_icons()
	update_hud()

	show_laws(0)

	// OutpostUbiquity edit: borg hotkeys are keybindings now, so there is no separate borg macro to override with.
	repick_laws()

	// Forces synths to select an icon relevant to their module
	pick_module()

	plane_holder.set_vis(VIS_AUGMENTED, TRUE)
