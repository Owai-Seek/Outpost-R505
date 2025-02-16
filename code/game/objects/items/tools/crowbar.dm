/obj/item/crowbar
	name = "pocket crowbar"
	desc = "A small crowbar. This handy tool is useful for lots of things, such as prying floor tiles or opening unpowered doors."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	usesound = 'sound/items/crowbar.ogg'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=50)
	drop_sound = 'sound/items/handling/crowbar_drop.ogg'
	pickup_sound =  'sound/items/handling/crowbar_pickup.ogg'

	attack_verb_continuous = list("attacks", "bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("attack", "bash", "batter", "bludgeon", "whack")
	tool_behaviour = TOOL_CROWBAR
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)
	var/force_opens = FALSE

/obj/item/crowbar/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is beating [user.p_them()]self to death with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/crowbar/red
	icon_state = "crowbar_red"
	force = 8

/obj/item/crowbar/abductor //SKYRAT EDIT - ICON OVERRIDEN BY AESTHETICS - SEE MODULE
	name = "alien crowbar"
	desc = "A hard-light crowbar. It appears to pry by itself, without any effort required."
	icon = 'icons/obj/abductor.dmi'
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	icon_state = "crowbar"
	toolspeed = 0.1


/obj/item/crowbar/large
	name = "crowbar"
	desc = "It's a big crowbar. It doesn't fit in your pockets, because it's big."
	force = 12
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 3
	custom_materials = list(/datum/material/iron=70)
	icon_state = "crowbar_large"
	inhand_icon_state = "crowbar"
	worn_icon_state = "crowbar"
	toolspeed = 0.7

/obj/item/crowbar/large/heavy //from space ruin
	name = "heavy crowbar"
	desc = "It's a big crowbar. It doesn't fit in your pockets, because it's big. It feels oddly heavy.."
	force = 20
	icon_state = "crowbar_powergame"

/obj/item/crowbar/power
	name = "jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science."
	icon_state = "jaws" //SKYRAT EDIT CHANGE
	inhand_icon_state = "jawsoflife"
	worn_icon_state = "jawsoflife"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	custom_materials = list(/datum/material/iron=150,/datum/material/silver=50,/datum/material/titanium=25)
	usesound = 'sound/items/jaws_pry.ogg'
	force = 15
	toolspeed = 1	// SKYRAT EDIT
	force_opens = TRUE
//SKYRAT EDIT ADDITION BEGIN
	var/powered_toolspeed = 0.4
	var/powered = FALSE

/obj/item/crowbar/power/Initialize()
	. = ..()
	update_appearance()

/obj/item/crowbar/power/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/cell, null, CALLBACK(src, .proc/turn_off))

/obj/item/crowbar/power/CtrlClick(mob/user)
	. = ..()
	if(!powered)
		if(!(item_use_power(power_use_amount, user, TRUE) & COMPONENT_POWER_SUCCESS))
			return
	powered = !powered
	if(powered)
		to_chat(user, "<span class='notice'>You turn [src] on.</span>")
		turn_on()
	else
		to_chat(user, "<span class='notice'>You turn [src] off.</span>")
		turn_off()
	playsound(user, 'sound/weapons/empty.ogg', 100, TRUE)

/obj/item/crowbar/power/proc/turn_off()
	powered = FALSE
	toolspeed = initial(toolspeed)
	update_appearance()
	STOP_PROCESSING(SSobj, src)

/obj/item/crowbar/power/proc/turn_on()
	toolspeed = powered_toolspeed
	update_appearance()
	START_PROCESSING(SSobj, src)

/obj/item/crowbar/power/process(delta_time)
	if(!powered)
		turn_off()
		return
	if(!(item_use_power(power_use_amount) & COMPONENT_POWER_SUCCESS))
		turn_off()
		return

/obj/item/crowbar/power/update_overlays()
	. = ..()
	if(powered)
		. += mutable_appearance('modular_skyrat/modules/aesthetics/tools/tools.dmi', "jaws_on")
	. += "[initial(icon_state)]_[tool_behaviour == TOOL_WIRECUTTER ? "cutter": "pry"]"
//SKYRAT EDIT END

/obj/item/crowbar/power/syndicate
	name = "tactical jaws of life" //SKYRAT EDIT: Black and red is the new tactical
	desc = "A set of jaws of life, compressed through the magic of science. This one has a tactical black and red paintjob and more robust hydraulics." //Skyrat Edit, was "A re-engineered copy of Nanotrasen's standard jaws of life. Can be used to force open airlocks in its crowbar configuration."
	icon_state = "jaws_syndicate" //SKYRAT EDIT CHANGE
	toolspeed = 0.25	// SKYRAT EDIT: Keeps this relevant, buffs to oldbase speed - Original value (0.5)
	force_opens = TRUE
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE // Skyrat edit
	special_desc = "A re-engineered copy of Nanotrasen's standard jaws of life. This one has a tesla relay and is more powerful." // Skyrat edit

/obj/item/crowbar/power/examine()
	. = ..()
	. += " It's fitted with a [tool_behaviour == TOOL_CROWBAR ? "prying" : "cutting"] head."
	. += "[src] is currently [powered ? "powered" : "unpowered"]." //SKYRAT EDIT ADDITION

/obj/item/crowbar/power/suicide_act(mob/user)
	if(tool_behaviour == TOOL_CROWBAR)
		user.visible_message(span_suicide("[user] is putting [user.p_their()] head in [src], it looks like [user.p_theyre()] trying to commit suicide!"))
		playsound(loc, 'sound/items/jaws_pry.ogg', 50, TRUE, -1)
	else
		user.visible_message(span_suicide("[user] is wrapping \the [src] around [user.p_their()] neck. It looks like [user.p_theyre()] trying to rip [user.p_their()] head off!"))
		playsound(loc, 'sound/items/jaws_cut.ogg', 50, TRUE, -1)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			var/obj/item/bodypart/BP = C.get_bodypart(BODY_ZONE_HEAD)
			if(BP)
				BP.drop_limb()
				playsound(loc, "desecration", 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/crowbar/power/attack_self(mob/user)
	playsound(get_turf(user), 'sound/items/change_jaws.ogg', 50, TRUE)
	if(tool_behaviour == TOOL_CROWBAR)
		tool_behaviour = TOOL_WIRECUTTER
		balloon_alert(user, "attached cutting jaws")
		usesound = 'sound/items/jaws_cut.ogg'
		update_appearance()

	else
		tool_behaviour = TOOL_CROWBAR
		balloon_alert(user, "attached prying jaws")
		usesound = 'sound/items/jaws_pry.ogg'
		update_appearance()

/* SKYRAT EDIT REMOVAL
/obj/item/crowbar/power/update_icon_state()
	if(tool_behaviour == TOOL_WIRECUTTER)
		icon_state = "jaws_cutter"
	else
		icon_state = "jaws_pry"
	return ..()

/obj/item/crowbar/power/syndicate/update_icon_state()
	if(tool_behaviour == TOOL_WIRECUTTER)
		icon_state = "jaws_cutter_syndie"
	else
		icon_state = "jaws_pry_syndie"
	return ..()
*/

/obj/item/crowbar/power/attack(mob/living/carbon/C, mob/user)
	if(istype(C) && C.handcuffed && tool_behaviour == TOOL_WIRECUTTER)
		user.visible_message(span_notice("[user] cuts [C]'s restraints with [src]!"))
		qdel(C.handcuffed)
		return
	else if(istype(C) && C.has_status_effect(STATUS_EFFECT_CHOKINGSTRAND) && tool_behaviour == TOOL_WIRECUTTER)
		user.visible_message(span_notice("[user] attempts to cut the durathread strand from around [C]'s neck."))
		if(do_after(user, 1.5 SECONDS, C))
			user.visible_message(span_notice("[user] succesfully cuts the durathread strand from around [C]'s neck."))
			C.remove_status_effect(STATUS_EFFECT_CHOKINGSTRAND)
			playsound(loc, usesound, 50, TRUE, -1)
		return
	else
		..()

/obj/item/crowbar/cyborg//SKYRAT EDIT - ICON OVERRIDEN BY AESTHETICS - SEE MODULE
	name = "hydraulic crowbar"
	desc = "A hydraulic prying tool, simple but powerful."
	icon = 'modular_skyrat/modules/fixing_missing_icons/items_cyborg.dmi' //skyrat edit
	icon_state = "crowbar_cyborg"
	worn_icon_state = "crowbar"
	usesound = 'sound/items/jaws_pry.ogg'
	force = 10
	toolspeed = 0.5
