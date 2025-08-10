function determine_to_draw_hp(pAA,APA) {
	// Check if contains self
	var arrayLengthIDFK = array_length(pAA),
	attackPower = 0,
	hasSelf = false;
	for (var i = 0; i < arrayLengthIDFK; i++) {
		if pAA[i] == id {
			hasSelf = true;
			break;	
		}
	}
	if hasSelf {
		attackPower = APA[i];
	}
	if global.healthbar_config == HEALTHBARCONFIG.SHOWALL || (last_damaged <= 8 && last_damaged > 0) || hasSelf || execute == "move" {
		draw_piece_hp(attackPower);	
	}
}