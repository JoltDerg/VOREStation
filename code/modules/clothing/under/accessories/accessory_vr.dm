//
// Collars and such like that
//

/obj/item/clothing/accessory/choker //A colorable, tagless choker
	name = "plain choker"
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	desc = "A simple, plain choker. Or maybe it's a collar? Use in-hand to customize it."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "choker_cst"
	item_state = "choker_cst"
	overlay_state = "choker_cst"
	var/customized = 0
	var/icon_previous_override
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/accessory/mob_vr_teshari.dmi'
		)

//Forces different sprite sheet on equip
/obj/item/clothing/accessory/choker/New()
	..()
	icon_previous_override = icon_override

/obj/item/clothing/accessory/choker/equipped() //Solution for race-specific sprites for an accessory which is also a suit. Suit icons break if you don't use icon override which then also overrides race-specific sprites.
	..()
	setUniqueSpeciesSprite()

/obj/item/clothing/accessory/choker/proc/setUniqueSpeciesSprite()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) && istype(has_suit) && ishuman(has_suit.loc))
		H = has_suit.loc
	if(sprite_sheets && istype(H) && H.species.get_bodytype(H) && (H.species.get_bodytype(H) in sprite_sheets))
		icon_override = sprite_sheets[H.species.get_bodytype(H)]
		update_clothing_icon()

/obj/item/clothing/accessory/choker/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	setUniqueSpeciesSprite()
	..(S, user)

/obj/item/clothing/accessory/choker/dropped()
	icon_override = icon_previous_override

/obj/item/clothing/accessory/choker/attack_self(mob/user as mob)
	if(!customized)
		var/design = tgui_input_list(user,"Descriptor?","Pick descriptor","Descriptor", list("plain","simple","ornate","elegant","opulent"))
		var/material = tgui_input_list(user,"Material?","Pick material","Material", list("leather","velvet","lace","fabric","latex","plastic","metal","chain","silver","gold","platinum","steel","bead","ruby","sapphire","emerald","diamond"))
		var/type = tgui_input_list(user,"Type?","Pick type","Type", list("choker","collar","necklace"))
		name = "[design] [material] [type]"
		desc = "A [type], made of [material]. It's rather [design]."
		customized = 1
		to_chat(usr,"<span class='notice'>[src] has now been customized.</span>")
	else
		to_chat(usr,"<span class='notice'>[src] has already been customized!</span>")

/obj/item/clothing/accessory/collar
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "collar_blk"
	var/writtenon = 0
	var/icon_previous_override
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/accessory/mob_vr_teshari.dmi'
	)

//Forces different sprite sheet on equip
/obj/item/clothing/accessory/collar/New()
	..()
	icon_previous_override = icon_override

/obj/item/clothing/accessory/collar/equipped() //Solution for race-specific sprites for an accessory which is also a suit. Suit icons break if you don't use icon override which then also overrides race-specific sprites.
	..()
	setUniqueSpeciesSprite()

/obj/item/clothing/accessory/collar/proc/setUniqueSpeciesSprite()
	var/mob/living/carbon/human/H = loc
	if(!istype(H) && istype(has_suit) && ishuman(has_suit.loc))
		H = has_suit.loc
	if(sprite_sheets && istype(H) && H.species.get_bodytype(H) && (H.species.get_bodytype(H) in sprite_sheets))
		icon_override = sprite_sheets[H.species.get_bodytype(H)]
		update_clothing_icon()

/obj/item/clothing/accessory/collar/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	setUniqueSpeciesSprite()
	..(S, user)

/obj/item/clothing/accessory/collar/dropped()
	icon_override = icon_previous_override

/obj/item/clothing/accessory/collar/silver
	name = "Silver tag collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_blk"
	item_state = "collar_blk"
	overlay_state = "collar_blk"

/obj/item/clothing/accessory/collar/gold
	name = "Golden tag collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_gld"
	item_state = "collar_gld"
	overlay_state = "collar_gld"

/obj/item/clothing/accessory/collar/bell
	name = "Bell collar"
	desc = "A collar with a tiny bell hanging from it, purrfect furr kitties."
	icon_state = "collar_bell"
	item_state = "collar_bell"
	overlay_state = "collar_bell"
	var/jingled = 0

/obj/item/clothing/accessory/collar/bell/verb/jinglebell()
	set name = "Jingle Bell"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(!jingled)
		usr.audible_message("[usr] jingles the [src]'s bell.", runemessage = "jingle")
		playsound(src, 'sound/items/pickup/ring.ogg', 50, 1)
		jingled = 1
		addtimer(CALLBACK(src, .proc/jingledreset), 50)
	return

/obj/item/clothing/accessory/collar/bell/proc/jingledreset()
		jingled = 0

/obj/item/clothing/accessory/collar/shock
	name = "Shock collar"
	desc = "A collar used to ease hungry predators."
	icon_state = "collar_shk0"
	item_state = "collar_shk"
	overlay_state = "collar_shk"
	var/on = FALSE // 0 for off, 1 for on, starts off to encourage people to set non-default frequencies and codes.
	var/frequency = 1449
	var/code = 2
	var/datum/radio_frequency/radio_connection

/obj/item/clothing/accessory/collar/shock/Initialize()
	. = ..()
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT) // Makes it so you don't need to change the frequency off of default for it to work.

/obj/item/clothing/accessory/collar/shock/Destroy() //Clean up your toys when you're done.
	radio_controller.remove_object(src, frequency)
	radio_connection = null //Don't delete this, this is a shared object.
	return ..()

/obj/item/clothing/accessory/collar/shock/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/clothing/accessory/collar/shock/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if(((istype(usr, /mob/living/carbon/human) && ((!( ticker ) || (ticker && ticker.mode != "monkey")) && usr.contents.Find(src))) || (usr.contents.Find(master) || (in_range(src, usr) && istype(loc, /turf)))))
		usr.set_machine(src)
		if(href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			set_frequency(new_frequency)
		if(href_list["tag"])
			var/str = copytext(reject_bad_text(tgui_input_text(usr,"Tag text?","Set tag","",MAX_NAME_LEN)),1,MAX_NAME_LEN)
			if(!str || !length(str))
				to_chat(usr,"<span class='notice'>[name]'s tag set to be blank.</span>")
				name = initial(name)
				desc = initial(desc)
			else
				to_chat(usr,"<span class='notice'>You set the [name]'s tag to '[str]'.</span>")
				name = initial(name) + " ([str])"
				desc = initial(desc) + " The tag says \"[str]\"."
		else
			if(href_list["code"])
				code += text2num(href_list["code"])
				code = round(code)
				code = min(100, code)
				code = max(1, code)
			else
				if(href_list["power"])
					on = !( on )
					icon_state = "collar_shk[on]" // And apparently this works, too?!
		if(!( master ))
			if(istype(loc, /mob))
				attack_self(loc)
			else
				for(var/mob/M in viewers(1, src))
					if(M.client)
						attack_self(M)
		else
			if(istype(master.loc, /mob))
				attack_self(master.loc)
			else
				for(var/mob/M in viewers(1, master))
					if(M.client)
						attack_self(M)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/clothing/accessory/collar/shock/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption != code)
		return

	if(on)
		var/mob/M = null
		if(ismob(loc))
			M = loc
		if(ismob(loc.loc))
			M = loc.loc // This is about as terse as I can make my solution to the whole 'collar won't work when attached as accessory' thing.
		to_chat(M,"<span class='danger'>You feel a sharp shock!</span>")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, M)
		s.start()
		M.Weaken(10)
	return

/obj/item/clothing/accessory/collar/shock/attack_self(mob/user as mob, flag1)
	if(!istype(user, /mob/living/carbon/human))
		return
	user.set_machine(src)
	var/dat = {"<TT>
			<A href='?src=\ref[src];power=1'>Turn [on ? "Off" : "On"]</A><BR>
			<B>Frequency/Code</B> for collar:<BR>
			Frequency:
			<A href='byond://?src=\ref[src];freq=-10'>-</A>
			<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(frequency)]
			<A href='byond://?src=\ref[src];freq=2'>+</A>
			<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

			Code:
			<A href='byond://?src=\ref[src];code=-5'>-</A>
			<A href='byond://?src=\ref[src];code=-1'>-</A> [code]
			<A href='byond://?src=\ref[src];code=1'>+</A>
			<A href='byond://?src=\ref[src];code=5'>+</A><BR>

			Tag:
			<A href='?src=\ref[src];tag=1'>Set tag</A><BR>
			</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/clothing/accessory/collar/spike
	name = "Spiked collar"
	desc = "A collar with spikes that look as sharp as your teeth."
	icon_state = "collar_spik"
	item_state = "collar_spik"
	overlay_state = "collar_spik"

/obj/item/clothing/accessory/collar/pink
	name = "Pink collar"
	desc = "This collar will make your pets look FA-BU-LOUS."
	icon_state = "collar_pnk"
	item_state = "collar_pnk"
	overlay_state = "collar_pnk"

/obj/item/clothing/accessory/collar/cowbell
	name = "cowbell collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_cowbell"
	item_state = "collar_cowbell_overlay"
	overlay_state = "collar_cowbell_overlay"

/obj/item/clothing/accessory/collar/collarplanet_earth
	name = "planet collar"
	desc = "A collar featuring a surprisingly detailed replica of a earth-like planet surrounded by a weak battery powered force shield. There is a button to turn it off."
	icon_state = "collarplanet_earth"
	item_state = "collarplanet_earth"
	overlay_state = "collarplanet_earth"


/obj/item/clothing/accessory/collar/holo
	name = "Holo-collar"
	desc = "An expensive holo-collar for the modern day pet."
	icon_state = "collar_holo"
	item_state = "collar_holo"
	overlay_state = "collar_holo"
	matter = list(MAT_STEEL = 50)

/obj/item/clothing/accessory/collar/holo/indigestible
	desc = "A special variety of the holo-collar that seems to be made of a very durable fabric that fits around the neck."
//Make indigestible
/obj/item/clothing/accessory/collar/holo/indigestible/digest_act(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/clothing/accessory/collar/attack_self(mob/user as mob)
	if(istype(src,/obj/item/clothing/accessory/collar/holo))
		to_chat(user,"<span class='notice'>[name]'s interface is projected onto your hand.</span>")
	else
		if(writtenon)
			to_chat(user,"<span class='notice'>You need a pen or a screwdriver to edit the tag on this collar.</span>")
			return
		to_chat(user,"<span class='notice'>You adjust the [name]'s tag.</span>")

	var/str = copytext(reject_bad_text(tgui_input_text(user,"Tag text?","Set tag","",MAX_NAME_LEN)),1,MAX_NAME_LEN)

	if(!str || !length(str))
		to_chat(user,"<span class='notice'>[name]'s tag set to be blank.</span>")
		name = initial(name)
		desc = initial(desc)
	else
		to_chat(user,"<span class='notice'>You set the [name]'s tag to '[str]'.</span>")
		initialize_tag(str)

/obj/item/clothing/accessory/collar/proc/initialize_tag(var/tag)
		name = initial(name) + " ([tag])"
		desc = initial(desc) + " \"[tag]\" has been engraved on the tag."
		writtenon = 1

/obj/item/clothing/accessory/collar/holo/initialize_tag(var/tag)
		..()
		desc = initial(desc) + " The tag says \"[tag]\"."

/obj/item/clothing/accessory/collar/attackby(obj/item/I, mob/user)
	if(istype(src,/obj/item/clothing/accessory/collar/holo))
		return

	if(istype(I,/obj/item/weapon/tool/screwdriver))
		update_collartag(user, I, "scratched out", "scratch out", "engraved")
		return

	if(istype(I,/obj/item/weapon/pen))
		update_collartag(user, I, "crossed out", "cross out", "written")
		return

	to_chat(user,"<span class='notice'>You need a pen or a screwdriver to edit the tag on this collar.</span>")

/obj/item/clothing/accessory/collar/proc/update_collartag(mob/user, obj/item/I, var/erasemethod, var/erasing, var/writemethod)
	if(!(istype(user.get_active_hand(),I)) || !(istype(user.get_inactive_hand(),src)) || (user.stat))
		return

	var/str = copytext(reject_bad_text(tgui_input_text(user,"Tag text?","Set tag","",MAX_NAME_LEN)),1,MAX_NAME_LEN)

	if(!str || !length(str))
		if(!writtenon)
			to_chat(user,"<span class='notice'>You don't write anything.</span>")
		else
			to_chat(user,"<span class='notice'>You [erasing] the words with the [I].</span>")
			name = initial(name)
			desc = initial(desc) + " The tag has had the words [erasemethod]."
	else
		if(!writtenon)
			to_chat(user,"<span class='notice'>You write '[str]' on the tag with the [I].</span>")
			name = initial(name) + " ([str])"
			desc = initial(desc) + " \"[str]\" has been [writemethod] on the tag."
			writtenon = 1
		else
			to_chat(user,"<span class='notice'>You [erasing] the words on the tag with the [I], and write '[str]'.</span>")
			name = initial(name) + " ([str])"
			desc = initial(desc) + " Something has been [erasemethod] on the tag, and it now has \"[str]\" [writemethod] on it."

//Machete Holsters
/obj/item/clothing/accessory/holster/machete
	name = "machete sheath"
	desc = "A handsome synthetic leather sheath with matching belt."
	icon_state = "holster_machete"
	slot = ACCESSORY_SLOT_WEAPON
	concealed_holster = 0
	can_hold = list(/obj/item/weapon/material/knife/machete, /obj/item/weapon/kinetic_crusher/machete)
	//sound_in = 'sound/effects/holster/sheathin.ogg'
	//sound_out = 'sound/effects/holster/sheathout.ogg'

//Medals

/obj/item/clothing/accessory/medal/silver/unity
	name = "medal of unity"
	desc = "A silver medal awarded to a group which has demonstrated exceptional teamwork to achieve a notable feat."

/obj/item/clothing/accessory/medal/silver/unity/tabiranth
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "silverthree"
	item_state = "silverthree"
	overlay_state = "silverthree"
	desc = "A silver medal awarded to a group which has demonstrated exceptional teamwork to achieve a notable feat. This one has three bronze service stars, denoting that it has been awarded four times."

/obj/item/clothing/accessory/talon
	name = "Talon pin"
	desc = "A collectable enamel pin that resembles ITV Talon's ship logo."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "talon_pin"
	item_state = "talonpin"
	overlay_state = "talonpin"

//Casino Sentient Prize Collar

/obj/item/clothing/accessory/collar/casinosentientprize
	name = "disabled Sentient Prize Collar"
	desc = "A collar worn by sentient prizes registered to a SPASM. Although the red text on it shows its disconnected and nonfunctional."

	icon_state = "casinoslave"
	item_state = "casinoslave"
	overlay_state = "casinoslave"

	var/sentientprizename = null	//Name for system to put on collar description
	var/ownername = null	//Name for system to put on collar description
	var/sentientprizeckey = null	//Ckey for system to check who is the person and ensure no abuse of system or errors
	var/sentientprizeflavor = null	//Description to show on the SPASM
	var/sentientprizeooc = null		//OOC text to show on the SPASM

/obj/item/clothing/accessory/collar/casinosentientprize/attack_self(mob/user as mob)
	//keeping it blank so people don't tag and reset collar status

/obj/item/clothing/accessory/collar/casinosentientprize_fake
	name = "Sentient Prize Collar"
	desc = "A collar worn by sentient prizes registered to a SPASM. This one has been disconnected from the system and is now an accessory!"

	icon_state = "casinoslave_owned"
	item_state = "casinoslave_owned"
	overlay_state = "casinoslave_owned"

//The gold trim from one of the qipaos, separated to an accessory to preserve the color
/obj/item/clothing/accessory/qipaogold
	name = "gold trim"
	desc = "Gold trim belonging to a qipao. Why would you remove this?"
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "qipaogold"
	item_state = "qipaogold"
	overlay_state = "qipaogold"

//Antediluvian accessory set
/obj/item/clothing/accessory/antediluvian
	name = "antediluvian bracers"
	desc = "A pair of metal bracers with gold inlay. They're thin and light."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_override = 'icons/inventory/accessory/mob_vr.dmi'
	icon_state = "antediluvian"
	item_state = "antediluvian"
	overlay_state = "antediluvian"
	body_parts_covered = ARMS

/obj/item/clothing/accessory/antediluvian/loincloth
	name = "antediluvian loincloth"
	desc = "A lengthy loincloth that drapes over the loins, obviously. It's quite long."
	icon_state = "antediluvian_loin"
	item_state = "antediluvian_loin"
	overlay_state = "antediluvian_loin"
	body_parts_covered = LOWER_TORSO

//The cloaks below belong to this _vr file but their sprites are contained in non-_vr icon files due to
//the way the poncho/cloak equipped() proc works. Sorry for the inconvenience
/obj/item/clothing/accessory/poncho/roles/cloak/antediluvian
	name = "antediluvian cloak"
	desc = "A regal looking cloak of white with specks of gold woven into the fabric."
	icon_state = "antediluvian_cloak"
	item_state = "antediluvian_cloak"

//Other clothes that I'm too lazy to port to Polaris
/obj/item/clothing/accessory/poncho/roles/cloak/chapel
	name = "bishop's cloak"
	desc = "An elaborate white and gold cloak."
	icon_state = "bishopcloak"
	item_state = "bishopcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/chapel/alt
	name = "antibishop's cloak"
	desc = "An elaborate black and gold cloak. It looks just a little bit evil."
	icon_state = "blackbishopcloak"
	item_state = "blackbishopcloak"

/obj/item/clothing/accessory/poncho/roles/cloak/half
	name = "rough half cloak"
	desc = "The latest fashion innovations by the Nanotrasen Uniform & Fashion Department have provided the brilliant invention of slicing a regular cloak in half! All the ponce, half the cost!"
	icon_state = "roughcloak"
	item_state = "roughcloak"
	action_button_name = "Adjust Cloak"

/obj/item/clothing/accessory/poncho/roles/cloak/half/update_clothing_icon()
	. = ..()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

/obj/item/clothing/accessory/poncho/roles/cloak/half/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]_open"
		src.item_state = "[item_state]_open"
		flags_inv = HIDETIE|HIDEHOLSTER
		to_chat(user, "You flip the cloak over your shoulder.")
	else
		src.icon_state = initial(icon_state)
		src.item_state = initial(item_state)
		flags_inv = HIDEHOLSTER
		to_chat(user, "You pull the cloak over your shoulder.")
	update_clothing_icon()

/obj/item/clothing/accessory/poncho/roles/cloak/shoulder
	name = "shoulder cloak"
	desc = "A small cape that primarily covers the left shoulder. Might help you stand out more, not necessarily for the right reasons."
	icon_state = "cape_left"
	item_state = "cape_left"

/obj/item/clothing/accessory/poncho/roles/cloak/shoulder/right
	desc = "A small cape that primarily covers the right shoulder. It might look a tad cooler if it was longer."
	icon_state = "cape_right"
	item_state = "cape_right"

//Mantles
/obj/item/clothing/accessory/poncho/roles/cloak/mantle
	name = "shoulder mantle"
	desc = "Not a cloak and not really a cape either, but a silky fabric that rests on the neck and shoulders alone."
	icon_state = "mantle"
	item_state = "mantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/cargo
	name = "cargo mantle"
	desc = "A shoulder mantle bearing the colors of the Supply department, with a gold lapel emblazoned upon the front."
	icon_state = "qmmantle"
	item_state = "qmmantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/security
	name = "security mantle"
	desc = "A shoulder mantle bearing the colors of the Security department, featuring rugged molding around the collar."
	icon_state = "hosmantle"
	item_state = "hosmantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/engineering
	name = "engineering mantle"
	desc = "A shoulder mantle bearing the colors of the Engineering department, accenting the pristine white fabric."
	icon_state = "cemantle"
	item_state = "cemantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/research
	name = "research mantle"
	desc = "A shoulder mantle bearing the colors of the Research department, the material slick and hydrophobic."
	icon_state = "rdmantle"
	item_state = "rdmantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/medical
	name = "medical mantle"
	desc = "A shoulder mantle bearing the general colors of the Medical department, dyed a sterile nitrile cyan."
	icon_state = "cmomantle"
	item_state = "cmomantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/hop
	name = "head of personnel mantle"
	desc = "A shoulder mantle bearing the colors of the Head of Personnel's uniform, featuring the typical royal blue contrasted by authoritative red."
	icon_state = "hopmantle"
	item_state = "hopmantle"

/obj/item/clothing/accessory/poncho/roles/cloak/mantle/cap
	name = "site manager mantle"
	desc = "A shoulder mantle bearing the colors usually found on a Site Manager, a commanding blue with regal gold inlay."
	icon_state = "capmantle"
	item_state = "capmantle"