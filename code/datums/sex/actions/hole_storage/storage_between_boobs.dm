
/datum/sex_action/hole_storage/boobs_store
	name = "Store items between boobs"
	hole_id = ORGAN_SLOT_BREASTS

/datum/sex_action/hole_storage/boobs_store/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_BREASTS))
		return FALSE
	if(!user.get_active_held_item())
		return FALSE
	return TRUE

/datum/sex_action/hole_storage/boobs_store/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(!user.get_active_held_item())
		return FALSE
	return TRUE

/datum/sex_action/hole_storage/boobs_store/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/obj/item/dildo = user.get_active_held_item()

	self = (user == target)

	if(self)
		to_chat(user, sex_session.spanify_force("I start inserting \the [dildo] between my boobs..."))
	else
		user.visible_message(span_warning("[user] starts inserting \the [dildo] between [target]'s boobs..."))

	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)


/datum/sex_action/hole_storage/boobs_store/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/pain_amt = 0 //base pain amt to use

	var/datum/sex_session/sex_session = get_sex_session(user, target)

	var/obj/item/dildo = user.get_active_held_item()
	if(!dildo)
		sex_session.stop_current_action()
		return
	var/success
	/*if(user == target)
		success = SEND_SIGNAL(user, COMSIG_HOLE_TRY_FIT, dildo, hole_id, target, TRUE, FALSE)
	else
		success = SEND_SIGNAL(target, COMSIG_HOLE_TRY_FIT, dildo, hole_id, target, TRUE, FALSE)*/
	if(success)
		user.update_inv_hands()
		user.update_a_intents()
		if(self)
			to_chat(user, sex_session.spanify_force("I stuff \the [dildo] between my boobs..."))
		else
			user.visible_message(sex_session.spanify_force("I stuff \the [dildo] between [target]'s boobs..."))

	else
		if(self)
			to_chat(user, sex_session.spanify_force("I fail to stuff \the [dildo] between my boobs."))
		else
			user.visible_message(sex_session.spanify_force("I fail to stuff \the [dildo] between [target]'s boobs."))
			sex_session.stop_current_action()
			return
	sex_session.perform_sex_action(user, target, 0.5, pain_amt, 0, src)
	sex_session.handle_passive_ejaculation()

/datum/sex_action/hole_storage/boobs_remove
	name = "Remove items from between boobs"
	hole_id = ORGAN_SLOT_BREASTS

/datum/sex_action/hole_storage/boobs_remove/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_BREASTS))
		return FALSE
	target_organ = user.getorganslot(hole_id)
	var/list/stored_items = SEND_SIGNAL(target_organ, COMSIG_BODYSTORAGE_RETURN_ITEM_LIST_SINGLE)
	if(!stored_items.len)
		return FALSE
	return TRUE

/datum/sex_action/hole_storage/boobs_remove/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user.get_active_held_item())
		return FALSE
	return TRUE

/datum/sex_action/hole_storage/boobs_remove/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	self = (user == target)

	if(self)
		to_chat(user, span_warning("I start removing items from between my boobs..."))
	else
		user.visible_message(span_warning("[user] starts removing items from between [target]'s boobs..."))

	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)


/datum/sex_action/hole_storage/boobs_remove/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/pain_amt = 0 //base pain amt to use

	var/datum/sex_session/sex_session = get_sex_session(user, target)

	var/obj/item/removed_item
	/*if(user == target)
		removed_item = SEND_SIGNAL(user, COMSIG_HOLE_REMOVE_RANDOM_ITEM, hole_id, target, TRUE)
	else
		removed_item = SEND_SIGNAL(target, COMSIG_HOLE_REMOVE_RANDOM_ITEM, hole_id, target, TRUE)*/
	if(!removed_item)
		to_chat(user, sex_session.spanify_force("I couldn't find anything inside..."))
		sex_session.stop_current_action()
		return
	if(user.get_active_held_item())
		user.visible_message(sex_session.spanify_force("The [removed_item] falls down on the floor..."))
		removed_item.doMove(get_turf(user))
	else
		if(self)
			to_chat(user, sex_session.spanify_force("I fish out the [removed_item] from between my boobs..."))
		else
			user.visible_message(sex_session.spanify_force("I fish out the [removed_item] from between [target]'s boobs..."))
		removed_item.doMove(get_turf(user))
		user.put_in_active_hand(removed_item)
	sex_session.perform_sex_action(user, target, 0.5, pain_amt, 0, src)
	sex_session.handle_passive_ejaculation()

