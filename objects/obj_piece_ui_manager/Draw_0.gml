var showHealth = global.healthbar_config != HEALTHBARCONFIG.HIDEALL; 

if !showHealth {
	exit;	
}
with obj_generic_piece {
	determine_to_draw_hp(other.piece_attacking_array,other.attack_power_array);
}
with obj_hero_wall {
	determine_to_draw_hp(other.piece_attacking_array,other.attack_power_array);
}
