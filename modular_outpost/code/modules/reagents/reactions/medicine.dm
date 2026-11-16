// Allow making burnpacks
/datum/reagent/dermaline/topical/touch_obj(obj/O)
	..()
	if(istype(O, /obj/item/stack/medical/bruise_pack) && round(volume) >= 1) // OutpostUbiquity edit - upstream now excludes standard gauze, we allow it
		var/obj/item/stack/medical/C = O

		var/packname = C.name
		var/to_produce = min(C.get_amount(), round(volume))
		var/obj/item/stack/medical/M = C.upgrade_stack(to_produce, /obj/item/stack/medical/advanced/ointment)

		if(M && M.get_amount())
			holder.my_atom.visible_message(span_infoplain(span_bold("\The [packname]") + " bubbles."))
			remove_self(to_produce)
