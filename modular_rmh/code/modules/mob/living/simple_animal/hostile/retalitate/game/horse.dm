// ============================================================================
// BARDING / БАРДИНГИ
// ============================================================================

// --- Базовые параметры конских спрайтов ---
/obj/item/clothing/barding
	var/horse_barding_icon = 'modular_rmh/icons/mob/monster/horse_iron (1).dmi'
	var/horse_barding_state = "horse_iron_onmob"

// --- Кольчужный бардинг ---
/obj/item/clothing/barding/chain
	horse_barding_icon = 'modular_rmh/icons/mob/monster/hor_a (2).dmi'
	horse_barding_state = "h_a_i"

// --- Золотой бардинг ---
/obj/item/clothing/barding/gold
	item_weight = 8 KILOGRAMS
	name = "golden barding"
	desc = "A set of golden body armor fitted for a horse."
	icon_state = "armorkit"
	armor_type = /datum/armor/maille
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	smeltresult = /obj/item/ingot/gold
	melting_material = /datum/material/gold
	melt_amount = 100
	sewrepair = null
	salvage_result = null
	salvage_amount = 0
	fiber_salvage = FALSE
	horse_barding_icon = 'modular_rmh/icons/mob/monster/hor_a (2).dmi'
	horse_barding_state = "h_a_g"
	valid_animal_types = list(/mob/living/simple_animal/hostile/retaliate/saiga/horse)

// ============================================================================
// HORSE / ЛОШАДИ
// ============================================================================

/mob/living/simple_animal/hostile/retaliate/saiga/horse
	icon = 'modular_rmh/icons/mob/monster/horse.dmi'
	name = "horse"
	desc = "Proud beasts of burden, war mounts, and symbols of luxury alike."
	icon_state = "horsewhite"
	icon_living = "horsewhite"
	icon_dead = "horsewhite_dead"
	gender = FEMALE
	// horse.dmi ships a unisex saddle rather than saiga's split male/female pair.
	// У Horse единый спрайт седла для обоих полов.
	saddle_overlay_state = "saddle"
	SET_BASE_PIXEL(-8, 0)

/mob/living/simple_animal/hostile/retaliate/saiga/horse/random/Initialize()
	. = ..()
	var/horsecolor = pick("horsewhite","horseblack","horsebrown")
	icon_state = "[horsecolor]"
	icon_living = "[horsecolor]"
	icon_dead = "[horsecolor]_dead"
	gender = pick(MALE, FEMALE)

// --- Приручение и размножение ---
/mob/living/simple_animal/hostile/retaliate/saiga/horse/tamed(mob/user)
	. = ..()
	if(.)
		return
	deaggroprob = 30
	if(can_breed)
		AddComponent(\
			/datum/component/breed,\
			list(/mob/living/simple_animal/hostile/retaliate/saiga/horse, /mob/living/simple_animal/hostile/retaliate/saiga/horse/male),\
			3 MINUTES, \
			list(/mob/living/simple_animal/hostile/retaliate/saiga/horse/kid = 90, /mob/living/simple_animal/hostile/retaliate/saiga/horse/kid/boy = 10),\
			CALLBACK(src, PROC_REF(after_birth)),\
		)

/mob/living/simple_animal/hostile/retaliate/saiga/horse/kid
	icon = 'modular_rmh/icons/mob/monster/horse.dmi'
	name = "foal"
	icon_state = "foalwhite"
	icon_living = "foalwhite"
	icon_dead = "foalwhite_dead"
	icon_gib = "skele"
	gender = FEMALE
	health = CALF_HEALTH
	maxHealth = CALF_HEALTH
	// Matches saigakid: foals are too small to ride, and horse.dmi has no foal mounted overlay.
	// Жеребята слишком малы для езды; отдельного слоя с наездником для них нет.
	can_buckle = FALSE

	adult_growth = /mob/living/simple_animal/hostile/retaliate/saiga/horse

/mob/living/simple_animal/hostile/retaliate/saiga/horse/kid/raondom/Initialize()
	. = ..()
	var/foalcolor = pick("foalwhite","foalblack","foalbrown")
	icon_state = "[foalcolor]"
	icon_living = "[foalcolor]"
	icon_dead = "[foalcolor]_dead"
	gender = pick(MALE, FEMALE)


/mob/living/simple_animal/hostile/retaliate/saiga/horse/male // Делим на два пола, чтобы работал horse/tamed(mob/user)
	gender = MALE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/kid/boy // Делим на два пола, чтобы ничего не сломалось, на всякий случай.
	gender = MALE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/male/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/saiga/horse/male/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/saiga/horse/black
	icon_state = "horseblack"
	icon_living = "horseblack"
	icon_dead = "horseblack_dead"

/mob/living/simple_animal/hostile/retaliate/saiga/horse/black/male
	gender = MALE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/brown
	icon_state = "horsebrown"
	icon_living = "horsebrown"
	icon_dead = "horsebrown_dead"

/mob/living/simple_animal/hostile/retaliate/saiga/horse/brown/male
	gender = MALE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/kid/black
	icon_state = "foalblack"
	icon_living = "foalblack"
	icon_dead = "foalblack_dead"

/mob/living/simple_animal/hostile/retaliate/saiga/horse/kid/black/male
	gender = MALE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/kid/brown
	icon_state = "foalbrown"
	icon_living = "foalbrown"
	icon_dead = "foalbrown_dead"

/mob/living/simple_animal/hostile/retaliate/saiga/horse/kid/brown/male
	gender = MALE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/black/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/black/male/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/brown/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/brown/male/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/saiga/horse/black/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/saiga/horse/black/male/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/saiga/horse/brown/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/saiga/horse/brown/male/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)

// --- Обработка смерти ---
/mob/living/simple_animal/hostile/retaliate/saiga/horse/death(gibbed)
	unbuckle_all_mobs(force = TRUE)
	. = ..()
	update_appearance(UPDATE_ICON)

// --- Отрисовка слоёв ---
/mob/living/simple_animal/hostile/retaliate/saiga/horse/update_overlays()
	var/obj/item/clothing/barding/armor = bbarding
	if(!armor)
		return ..()

	var/previous_icon = armor.barding_icon
	var/previous_state = armor.barding_state
	var/previous_female_state = armor.female_barding_state
	armor.barding_icon = armor.horse_barding_icon
	armor.barding_state = armor.horse_barding_state
	armor.female_barding_state = null
	. = ..()
	armor.barding_icon = previous_icon
	armor.barding_state = previous_state
	armor.female_barding_state = previous_female_state

// ============================================================================
// HONSE / ФОГБИСТЫ
// ============================================================================

/mob/living/simple_animal/hostile/retaliate/honse/update_icon(updates = ALL)
	. = ..()
	// Build one complete list instead of clearing overlays and recursively updating the icon.
	// Собираем полный список без очистки и рекурсивного обновления иконки.
	// The shared renderer supplies barding and caparison with their normal layer order.
	// Общий рендер добавляет броню и попону с обычным порядком слоёв.
	var/list/honse_overlays = update_overlays()
	if(stat != DEAD && ssaddle)
		for(var/saddle_state in list("saddle-above", "saddle"))
			var/mutable_appearance/saddle_overlay = mutable_appearance(icon, saddle_state, 4.3)
			if(saddle_state == "saddle")
				saddle_overlay.appearance_flags |= RESET_COLOR
			honse_overlays += saddle_overlay

	// Replace the old list, including the original default-colour mounted sprite.
	// Заменяем старый список, включая mounted-спрайт со стандартным цветом.
	managed_overlays = honse_overlays
	overlays = honse_overlays
	return . | UPDATE_OVERLAYS

// ============================================================================
// SAIGA / САЙГА
// ============================================================================

// --- Отрисовка слоёв ---
/mob/living/simple_animal/hostile/retaliate/saiga/update_overlays()
	. = ..()
	. += build_saiga_overlays(saddle_overlay_state)
	var/list/animal_overlays = .
	for(var/mutable_appearance/appearance in animal_overlays.Copy())
		if(appearance.icon == icon && appearance.icon_state == "[icon_state]_mounted")
			. -= appearance

/mob/living/simple_animal/hostile/retaliate/saigabuck/update_overlays()
	. = ..()
	. += build_saiga_overlays(saddle_overlay_state)
	var/list/animal_overlays = .
	for(var/mutable_appearance/appearance in animal_overlays.Copy())
		if(appearance.icon == icon && appearance.icon_state == "[icon_state]_mounted")
			. -= appearance

/mob/living/simple_animal/proc/build_saiga_overlays(saddle_state)
	// Parent update_overlays() already supplies barding and caparison layers.
	// Родительский метод уже добавил броню и попону.
	var/list/appearances = list()
	// Skip genetic regions for animals without genetics, such as Terror Bird.
	// Без генетики, как у Terror Bird, генетические слои окраса не нужны.
	if(istype(genetics))
		var/datum/animal_gene/coat_color/coat_gene = genetics.get_gene_by_exclusion_group(GENE_GROUP_COAT_COLOR)
		var/datum/animal_gene/undercoat/undercoat_gene = genetics.get_gene_by_exclusion_group(GENE_GROUP_UNDERCOAT)
		var/datum/animal_gene/glow_gene = genetics.get_gene_by_exclusion_group(GENE_GROUP_EMISSIVE)
		// Region states follow icon_state, including its death variant.
		// Имена областей следуют за текущим состоянием, включая мёртвый спрайт.
		var/mutable_appearance/body = mutable_appearance(icon, "[icon_state]_reg1")
		var/mutable_appearance/undercoat = mutable_appearance(icon, "[icon_state]_reg2")

		if(coat_gene)
			body.color = coat_gene.get_color()
			// Without a separate undercoat gene, both regions use the main coat colour.
			// Если отдельного гена подшёрстка нет, используем основной цвет.
			undercoat.color = undercoat_gene ? undercoat_gene.get_color() : coat_gene.get_color()
		// Emissive appearance makes the second region visible independently of lighting.
		// Emissive делает вторую область видимой независимо от освещения.
		if(glow_gene)
			appearances += emissive_appearance(icon, "[icon_state]_reg2")
		appearances += body
		appearances += undercoat

	// The body and rider layers handle occlusion without a default-colour mounted sprite.
	// Перекрытие задаётся слоями тела и наездника; стандартный mounted-спрайт не нужен.
	if(stat != DEAD && ssaddle)
		appearances += mutable_appearance(icon, "[saddle_state]-above", 4.3)
		appearances += mutable_appearance(icon, saddle_state)
	return appearances

// --- Слои и смещения наездника ---
/datum/component/riding/creature/saiga/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 8, 6.1),
		TEXT_SOUTH = list(0, 8, MOB_LAYER),
		TEXT_EAST = list(-2, 8, 6.1),
		TEXT_WEST = list(2, 8, 6.1),
	)

/datum/component/riding/creature/saiga/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, OBJ_LAYER),
		TEXT_SOUTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_EAST = list(0, 0, OBJ_LAYER),
		TEXT_WEST = list(0, 0, OBJ_LAYER),
	)

// --- Обновление при посадке ---
/datum/component/riding/creature/saiga/vehicle_mob_buckle(mob/living/ridden, mob/living/rider, force = FALSE)
	. = ..()
	ridden.update_appearance(UPDATE_ICON)
