event_inherited();
if sprite_accel > 0 { sprite_accel -= delta_time*DELTA_TO_SECONDS/10; }
if global.game_state == PAUSED {
	exit;	
}

if resource_timer >= time_to_produce {
	image_index = min(image_index +1, 3);
	var checkNoExcess = ((team == "friendly")? (global.turns < global.max_turns):(global.enemy_turns < global.max_turns));
	if input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self) && checkNoExcess {
		execute = "nothing";
		audio_stop_sound(snd_pick_up);
		timer_tick(1);
		resource_timer = 0;
		time_to_produce = random_percent(24,10);
	}
} else {
	image_index = max(image_index -1, 0);
	resource_timer += delta_time*DELTA_TO_SECONDS;	
}

// Old accelerator code
//var ar_leng = array_length(aura),
//gS = GRIDSPACE;
// For each move available (i)
/*
for (var i = 0; i < ar_leng; ++i)	{
	if aura[i][0] == 0 && aura[i][1] == 0 {
		continue;	
	}
	var xM = aura[i][0]*gS +x;
	var yM = aura[i][1]*gS +y;		
	// If coords within move array are on the grid; 0 = x, 1 = y
	if place_meeting(xM,yM,obj_grid) {
		
		// And if coords collide with obstacle/piece, draw RED. Else...
		if place_meeting(xM,yM,obj_generic_piece) && !place_meeting(xM,yM,obj_accelerator) {
			with instance_position(xM,yM,obj_generic_piece) {
				if team == other.team {
					spd += 1;
					//part_particles_burst(global.part_sys,x +8,y +8,part_debug);		
				}
			}
		} 	
	}			
}
*/
