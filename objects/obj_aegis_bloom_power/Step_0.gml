if global.game_state != PAUSED{
	timer += delta_time*DELTA_TO_SECONDS*global.level_speed;
}


if timer >= .10 {
	var tm = ((team == "friendly")?1:-1),
	gS = GRIDSPACE;
	audio_stop_sound(snd_shock);
	audio_play_sound(snd_shock,0,0);
	timer = 0;
	x += tm*gS;
	if !position_meeting(x,y,obj_grid) {
		instance_destroy();	
	} else {
		with instance_position(x,y,obj_generic_piece) {
			if team != other.team {
				hurt(hp,25,DAMAGE.ENERGY,self);
				audio_play_sound(snd_bullet_hit,0,0);
				var rand = (irandom_range(0,1)*2 -1)*gS;
				if !position_meeting(other.x,other.y +rand,obj_obstacle) && position_meeting(other.x,other.y +rand,obj_grid) {
					y += rand;
				} else if !position_meeting(other.x,other.y -rand,obj_obstacle) && position_meeting(other.x,other.y -rand,obj_grid) {
					y -= rand;
				}
				repeat(10){
					part_particles_burst(global.part_sys,x+gS/2,y+gS/2,part_explode);		
				}
			}
		}	
	}
}