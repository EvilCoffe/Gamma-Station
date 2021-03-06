/obj/item/robot_parts/attack(mob/living/carbon/human/M, mob/living/carbon/user, def_zone)

	if(!ishuman(M))
		return ..()

	if(!((locate(/obj/machinery/optable, M.loc) && M.resting) || (locate(/obj/structure/stool/bed/roller, M.loc) && (M.buckled || M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat)) && prob(75) || (locate(/obj/structure/table/, M.loc) && (M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat) && prob(66))))
		return ..()

	if(user.zone_sel.selecting != part)
		to_chat(user, "\red That doesn't fit there!")
		return ..()

	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/BP = H.get_bodypart(def_zone)
	if(BP.status & ORGAN_DESTROYED)
		if(!(BP.status & ORGAN_ATTACHABLE))
			to_chat(user, "\red The wound is not ready for a replacement!")
			return 0
		if(M != user)
			M.visible_message( \
				"\red [user] is beginning to attach \the [src] where [H]'s [BP.name] used to be.", \
				"\red [user] begins to attach \the [src] where your [BP.name] used to be.")
		else
			M.visible_message( \
				"\red [user] begins to attach a robotic limb where \his [BP.name] used to be with [src].", \
				"\red You begin to attach \the [src] where your [BP.name] used to be.")

		if(do_mob(user, H, 100))
			if(M != user)
				M.visible_message( \
					"\red [user] finishes attaching [H]'s new [BP.name].", \
					"\red [user] finishes attaching your new [BP.name].")
			else
				M.visible_message( \
					"\red [user] finishes attaching \his new [BP.name].", \
					"\red You finish attaching your new [BP.name].")

			if(H == user && prob(25))
				to_chat(user, "\red You mess up!")
				BP.take_damage(15)

			BP.status = ORGAN_ROBOT // in this situtation, we can simply set exact flag.
			H.update_body()
			M.updatehealth()
			M.UpdateDamageIcon(BP)
			qdel(src)

			return 1
		return 0
