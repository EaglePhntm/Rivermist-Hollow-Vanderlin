/obj/item/organ/genitals
    abstract_type = /obj/item/organ/genitals
    var/organ_size = 1
    var/list/altnames = null
    var/can_change_size = FALSE

/obj/item/organ/genitals/Initialize()
	. = ..()
	body_storage_bulk *= organ_size
