y += y_spd*delta_time*DELTA_TO_FRAMES;	

if y > y_init {
	y = y_init;
	y_spd_max = y_spd_max/1.5;
	y_spd = y_spd_max;
} else { y_spd += .05*delta_time*DELTA_TO_FRAMES; }

// If hp changes
if hp < hp_init {
	hp_init--;
	with obj_world_one {
		timer_mod = timer_mod*.85;	
	}
}

if hp <= 0 {
	instance_create_layer(x,y,"Instances",obj_death_hero,{
		sprite_index: sprite_index
	})
	room_goto(rm_gameover);
}