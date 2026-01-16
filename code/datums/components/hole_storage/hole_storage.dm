#define STORAGE_LAYER_OUTER "layer_outer"
#define STORAGE_LAYER_INNER "layer_inner"
#define STORAGE_LAYER_DEEP "layer_deep"



/datum/component/body_storage
	var/obj/item/organ/storing_organ
	var/mob/living/owner

	var/list/available_layers = list(
		STORAGE_LAYER_OUTER = FALSE,
		STORAGE_LAYER_INNER = FALSE,
		STORAGE_LAYER_DEEP = FALSE,
	)

	var/list/layer_storage_max_num = list(
		STORAGE_LAYER_OUTER = 1,
		STORAGE_LAYER_INNER = 15,
		STORAGE_LAYER_DEEP = 25,
	)

	var/list/layer_storage_max_bulk = list(
		STORAGE_LAYER_OUTER = 10,
		STORAGE_LAYER_INNER = 30,
		STORAGE_LAYER_DEEP = 50,
	)

	var/list/layer_storage_cur_bulk = list(
		STORAGE_LAYER_OUTER = 0,
		STORAGE_LAYER_INNER = 0,
		STORAGE_LAYER_DEEP = 0,
	)

	var/list/outer_layer_contents = list()
	var/list/inner_layer_contents = list()
	var/list/deep_layer_contents = list()

	//A linker of index to item list
	var/list/all_layers = list(
		STORAGE_LAYER_OUTER = null,
		STORAGE_LAYER_INNER = null,
		STORAGE_LAYER_DEEP = null,
	)
	var/max_insert_size = WEIGHT_CLASS_NORMAL


/datum/component/body_storage/Initialize(obj/item/organ/org, location = null, mob/living/organ_owner)
	. = ..()
	storing_organ = org
	owner = organ_owner
	all_layers[STORAGE_LAYER_OUTER] = outer_layer_contents // assembling the linker list
	all_layers[STORAGE_LAYER_INNER] = inner_layer_contents
	all_layers[STORAGE_LAYER_DEEP] = deep_layer_contents


/datum/component/body_storage/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_BODYSTORAGE_TRY_INSERT, PROC_REF(handle_insertion))
	RegisterSignal(parent, COMSIG_BODYSTORAGE_FORCE_INSERT, PROC_REF(insert_in_storage))
	RegisterSignal(parent, COMSIG_BODYSTORAGE_CHECK_FIT, PROC_REF(check_fit))
	RegisterSignal(parent, COMSIG_BODYSTORAGE_TRY_REMOVE, PROC_REF(handle_removal))
	RegisterSignal(parent, COMSIG_BODYSTORAGE_FORCE_REMOVE, PROC_REF(remove_from_storage))
	RegisterSignal(parent, COMSIG_BODYSTORAGE_GET_LISTS, PROC_REF(return_contents_lists))
	RegisterSignal(parent, COMSIG_BODYSTORAGE_GET_RAND_ITEM, PROC_REF(return_random_item_from_layer))
	RegisterSignal(parent, COMSIG_BODYSTORAGE_IS_ITEM_IN, PROC_REF(check_item_in_layer))
	RegisterSignal(parent, COMSIG_BODYSTORAGE_IS_ITEM_TYPE_IN, PROC_REF(check_item_type_in_layer))
	RegisterSignal(parent, COMSIG_BODYSTORAGE_RETURN_ITEM_LIST_SINGLE, PROC_REF(return_2d_list))

/datum/component/body_storage/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_TRY_INSERT)
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_FORCE_INSERT)
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_CHECK_FIT)
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_TRY_REMOVE)
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_FORCE_REMOVE)
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_GET_LISTS)
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_GET_RAND_ITEM)
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_IS_ITEM_IN)
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_IS_ITEM_TYPE_IN)
	UnregisterSignal(parent, COMSIG_BODYSTORAGE_RETURN_ITEM_LIST_SINGLE)

/datum/component/body_storage/Destroy()
	. = ..()

/datum/component/body_storage/proc/handle_insertion(datum/source, obj/item/incoming_item, target_layer, force = FALSE)
	if(!available_layers[target_layer])
		return FALSE
	if(check_fit(source, incoming_item, target_layer, force))
		insert_in_storage(source, incoming_item, target_layer)
		var/diff = layer_storage_cur_bulk[target_layer] + (layer_storage_cur_bulk[target_layer]-1)/2
		if(force && (diff >= layer_storage_max_bulk[target_layer]))
			handle_stretch(source, diff)
		return TRUE
	return FALSE

/*/datum/component/body_storage/proc/handle_bulk_insertion(list/incoming_items, target_layer, force = FALSE)
	if(!available_layers[target_layer])
		return FALSE
	if(check_fit(incoming_item, target_layer, force))
		insert_in_storage(incoming_item, target_layer)
		var/diff = layer_storage_cur_bulk[target_layer] + (layer_storage_cur_bulk[target_layer]-1)/2
		if(force && (diff >= layer_storage_max_bulk[target_layer]))
			handle_stretch(diff)
	return FALSE*/

/datum/component/body_storage/proc/insert_in_storage(datum/source, obj/item/incoming_item, target_layer)
	if(iscarbon(incoming_item.loc))
		var/mob/living/carbon/M = incoming_item.loc
		M.dropItemToGround(incoming_item, FALSE, TRUE)
	storing_organ.contents += incoming_item
	incoming_item.forceMove(storing_organ)
	var/list/t_layer = all_layers[target_layer]
	t_layer += incoming_item
	layer_storage_cur_bulk[target_layer] += incoming_item.w_class

/datum/component/body_storage/proc/check_fit(datum/source, obj/item/incoming_item, target_layer, force = FALSE)
	if(!available_layers[target_layer])
		return FALSE
	if(incoming_item.w_class > max_insert_size)
		return FALSE

	var/list/t_layer = all_layers[target_layer]

	if(LAZYLEN(t_layer) >= layer_storage_max_num[target_layer]) //hard cap
		return FALSE
	if(layer_storage_cur_bulk[target_layer] >= layer_storage_max_bulk[target_layer] || (force && (layer_storage_cur_bulk[target_layer] + (layer_storage_cur_bulk[target_layer]-1)/2 >= layer_storage_max_bulk[target_layer])))
		return FALSE
	else
		return TRUE


/datum/component/body_storage/proc/handle_removal(datum/source, obj/item/removed_item, target_layer, force = FALSE)
	if(!target_layer)
		target_layer = find_item_layer(removed_item)
	if(check_item_in_layer(removed_item, target_layer))
		remove_from_storage(source, removed_item, target_layer)
		return TRUE
	return FALSE

/datum/component/body_storage/proc/remove_from_storage(datum/source, obj/item/removed_item, target_layer)
	storing_organ.contents -= removed_item
	var/list/t_layer = all_layers[target_layer]
	t_layer -= removed_item
	layer_storage_cur_bulk[target_layer] -= removed_item.w_class

/datum/component/body_storage/proc/handle_stretch(datum/source, size_diff)
	if(istype(storing_organ, /obj/item/organ/genitals/filling_organ) || storing_organ.stretchable)
		SEND_SIGNAL(storing_organ, COMSIG_ORGAN_STRETCHED, size_diff)
	return FALSE

/datum/component/body_storage/proc/return_contents_lists(datum/source)
	return all_layers

/datum/component/body_storage/proc/return_2d_list(datum/source)
	var/list/return_list = list()
	for(var/list in all_layers)
		for(var/el in list)
			return_list += el
	return return_list

/datum/component/body_storage/proc/return_random_item_from_layer(datum/source, target_layer)
	var/list/t_layer = all_layers[target_layer]

	return pick(t_layer)

/datum/component/body_storage/proc/return_available_layers(datum/source)
	return available_layers

/datum/component/body_storage/proc/check_item_in_layer(datum/source, obj/item/t_item, target_layer)
	if(t_item in all_layers[target_layer])
		return TRUE
	else
		return FALSE

/datum/component/body_storage/proc/check_item_type_in_layer(datum/source, type, target_layer)
	for(var/el in all_layers[target_layer])
		if(istype(el, type))
			return TRUE
	return FALSE

/datum/component/body_storage/proc/find_item_layer(datum/source, obj/item/t_item)
	for(var/list/l in all_layers)
		for(var/el in all_layers[l])
			if(el == t_item)
				return TRUE
	return null

/datum/component/body_storage/proc/return_layer_list_by_index(datum/source, index)
	switch(index)
		if(STORAGE_LAYER_OUTER)
			return outer_layer_contents

		if(STORAGE_LAYER_INNER)
			return inner_layer_contents

		if(STORAGE_LAYER_DEEP)
			return deep_layer_contents

/obj/item/organ/proc/add_bodystorage(mob/living/the_mob, location = null, hole_type)
	if(!GetComponent(hole_type))
		AddComponent(hole_type, src, location, the_mob)


