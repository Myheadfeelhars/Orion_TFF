/mob/living/basic/spider/giant/pit
	name = "Terror"
	desc = "Furry and brown with an orange top, its massive jaws strike fear in you. This one has bright orange eyes."
	icon = 'modular_nova/modules/spider/icons/spider.dmi'
	icon_state = "pit"
	icon_living = "pit"
	icon_dead = "pit_dead"
	gender = MALE
	maxHealth = 900
	health = 900
	armour_penetration = 60
	melee_damage_lower = 40
	melee_damage_upper = 40
	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 25
	maximum_survivable_temperature = 1100
	unsuitable_cold_damage = 0
	wound_bonus = 25
	bare_wound_bonus = 50
	sharpness = SHARP_EDGED
	obj_damage = 150
	web_speed = 1
	limb_destroyer = 50
	damage_coeff = list(BRUTE = 0.75, BURN = 1, TOX = 0, STAMINA = 0, OXY = 0.25)
	speed = 6
	player_speed_modifier = -4
	gold_core_spawnable = NO_SPAWN
	sight = SEE_TURFS
	menu_description = "Has the ability to destroy walls and limbs, and to send warnings to the nest, that's he doesnt have..."
	innate_actions = list(
		/datum/action/cooldown/mob_cooldown/wrap,
		/datum/action/cooldown/mob_cooldown/command_spiders,
		/datum/action/cooldown/spell/wall_spider,
		/datum/action/cooldown/mob_cooldown/charge/basic_charge,
	)
/mob/living/basic/spider/giant/pit/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/mob_cooldown/lay_web/solid_web/web_solid = new(src)
	web_solid.Grant(src)

	AddElement(/datum/element/web_walker, /datum/movespeed_modifier/below_average_web)

/mob/living/basic/spider/giant/pit/melee_attack(mob/living/target, list/modifiers, ignore_cooldown)
	. = ..()
	if (!. || !isliving(target))
		return
	target.AdjustKnockdown(1 SECONDS)
	target.adjustStaminaLoss(10)

/mob/living/basic/spider/giant/pit/melee_attack(obj/vehicle/sealed/mecha/target, list/modifiers, ignore_cooldown)
	. = ..()
	if (!. || !ismecha(target))
		return
	target.take_damage(obj_damage, BRUTE, MELEE)

/mob/living/basic/spider/giant/pit/proc/try_eat(atom/movable/food)
	balloon_alert(src, "swallowing...")
	if (do_after(src, 3 SECONDS, target = food))
		if(isliving(food))
			eat(food)

/// Succeed in putting something inside us
/mob/living/basic/spider/giant/pit/proc/eat(mob/living/food)
	var/health_recovered = food.maxHealth * 0.75
	adjust_health(round(-health_recovered, 1))
	if (QDELETED(food) || food.loc == src)
		return FALSE
	playsound(src, 'sound/effects/magic/demon_attack1.ogg', 60, TRUE)
	visible_message(span_boldwarning("[src] swallows [food] whole!"))
	food.extinguish_mob() // It's wet in there, and our food is likely to be on fire. Let's be decent and not husk them.
	food.forceMove(src)
	return TRUE
