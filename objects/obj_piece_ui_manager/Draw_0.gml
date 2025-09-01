var showHealth = global.healthbar_config != HEALTHBARCONFIG.HIDEALL; 
// This runs after all pieces have collected their data
gpu_push_state();

// Render all shadows in one batch
render_shadow_batch();

// Render all effects in one batch  
render_effect_batch();

// Render all timers with shader
render_timer_batch();

gpu_pop_state();

if !showHealth {
	exit;	
}
with obj_generic_piece {
	determine_to_draw_hp(other.piece_attacking_array,other.attack_power_array);
}
with obj_hero_wall {
	determine_to_draw_hp(other.piece_attacking_array,other.attack_power_array);
}
