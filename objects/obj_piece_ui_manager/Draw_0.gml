with obj_generic_piece	{
	// Check if contains self
	var arrayLengthIDFK = array_length(other.piece_attacking_array),
	attackPower = 0,
	hasSelf = false;
	for (var i = 0; i < arrayLengthIDFK; i++) {
		if other.piece_attacking_array[i] == id {
			hasSelf = true;
			break;	
		}
	}
	if hasSelf {
		attackPower = other.attack_power_array[i];
	}
	if global.healthbar_config != HEALTHBARCONFIG.HIDEALL && (global.healthbar_config == HEALTHBARCONFIG.SHOWALL || (last_damaged <= 8 && last_damaged > 0) || hasSelf) {
		draw_piece_hp(attackPower);	
	}
}
