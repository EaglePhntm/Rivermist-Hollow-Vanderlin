/obj/item/clothing/ring/slave_control
	name = "Slave control ring"
	desc = "An ominous-looking ring with arcane engravings. \n Click with the middle mouse button to invoke a command."
	icon_state = "g_ring_ruby"
	sellprice = 100

	var/list/phrases_list = list()
	var/ring_bound = FALSE
	var/obj/item/clothing/neck/slave_collar/bound_collar

/obj/item/clothing/ring/slave_control/attackby(obj/item/I, mob/living/user)
	if(!ismob(user))
		return
	if(istype(I, /obj/item/clothing/neck/slave_collar))
		var/obj/item/clothing/neck/slave_collar/sc = I
		sc.bind_collar(I, src, user)
		return
	return ..()

/obj/item/clothing/ring/slave_control/MiddleClick(mob/user, params)
	if(ring_bound)
		var/command_input = browser_input_list(user, "SELECT THE DEMAND", "DECREES", GLOB.reverse_slave_phrases_translations, null)
		if(command_input)
			if(bound_collar.perform_command(normalize_slave_phrase(phrases_list[GLOB.reverse_slave_phrases_translations[command_input]])))
				to_chat(user, "<font size='1' color='grey'>The ring vibrates imperceptably - the command was a success.</font>")
			else
				to_chat(user, "<font size='1' color='red'>The ring lies still - command failed to perform.</font>")
		return
	. = ..()

/obj/item/clothing/ring/slave_control/examine(mob/user)
	. = ..()
	. += span_userdanger("You notice three engraved phrases on the ring:")
	for(var/el in phrases_list)
		. += "<br><b>[GLOB.slave_phrases_translations[el]]:</b> \"[phrases_list[el]]\""

/datum/anvil_recipe/slave_control
	name = "Slave control ring"
	recipe_name = "a slave control ring"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/gem/red)
	created_item = /obj/item/clothing/ring/slave_control
	craftdiff = 3
	i_type = "Valuables"
