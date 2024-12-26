event_inherited();

// shoot
if !global.pause {
	var 
	gS = global.grid_spacing,
	tM = (team == "friendly")?1:-1;
	if (timer >= timer_end) {
		timer = 0;
		timer_end = random_percent(3,4);
		
		var decideShoot = scan_for_enemy();
		
		if decideShoot {
			for (var xPro = x; position_meeting(xPro,y,obj_grid); xPro += tM) {
				part_particles_burst(global.part_sys,xPro +sprite_width/2,y +sprite_height/2,part_bullet_trail);		
			}
			for (var xPro = x; position_meeting(xPro,y,obj_grid); xPro += tM*gS) {
				with instance_position(xPro,y,obj_generic_piece) {
					if team != other.team {
						if slw <= 2 {
							slw = 2;	
						}
						if !intangible {
							hp -= 1;
							repeat(30){ part_particles_burst(global.part_sys,xPro,y +sprite_height/2,part_bullet_impact); }
							audio_play_sound(snd_bullet_hit,0,0);
						}
					}
				}
			}
		}
	}
}