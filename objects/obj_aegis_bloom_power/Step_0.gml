if global.game_state != PAUSED{
	timer += delta_time*DELTA_TO_SECONDS*global.level_speed;
}

var spd = .10;
if timer >= spd {
	var tm = ((team == "friendly")?1:-1),
	gS = GRIDSPACE;
	audio_stop_sound(snd_shock);
	audio_play_sound(snd_shock,0,0);
	timer = 0;
	x += tm*gS;
	if !position_meeting(x,y,obj_grid) {
		instance_destroy();	
	} else {
		with instance_position(x +GRIDSPACE/2,y +GRIDSPACE/2,obj_generic_piece) {
			if team != other.team {
				hurt(hp,25,DAMAGE.ENERGY,self);
				audio_play_sound(snd_bullet_hit,0,0);
				var rand = (irandom_range(0,1)*2 -1)*GRIDSPACE;
				if !position_meeting(other.x,other.y +rand,obj_obstacle) && position_meeting(other.x,other.y +rand,obj_grid) {
					y += rand;
				} else if !position_meeting(other.x,other.y -rand,obj_obstacle) && position_meeting(other.x,other.y -rand,obj_grid) {
					y -= rand;
				}
				repeat(10){
					part_particles_burst(global.part_sys,x+GRIDSPACE/2,y+GRIDSPACE/2,part_explode);		
				}
			}	
		}	
		with instance_position(x +GRIDSPACE/2 -GRIDSPACE*tm,y +GRIDSPACE/2,obj_generic_piece) {
			if team != other.team {
				hurt(hp,25,DAMAGE.ENERGY,self);
				audio_play_sound(snd_bullet_hit,0,0);
				var rand = (irandom_range(0,1)*2 -1)*GRIDSPACE;
				if !position_meeting(other.x,other.y +rand,obj_obstacle) && position_meeting(other.x,other.y +rand,obj_grid) {
					y += rand;
				} else if !position_meeting(other.x,other.y -rand,obj_obstacle) && position_meeting(other.x,other.y -rand,obj_grid) {
					y -= rand;
				}
				repeat(10){
					part_particles_burst(global.part_sys,x+GRIDSPACE/2,y+GRIDSPACE/2,part_explode);		
				}
			}	
		}	
	}
}