event_inherited();

// shoot
if !global.pause {
	var 
	gS = GRIDSPACE,
	tM = (team == "friendly")?1:-1;
	if (timer >= timer_end) {
		timer = 0;
		timer_end = random_percent(4,5);
		
		var decideShoot = scan_for_enemy(false);
		
		if decideShoot {
			for (var xPro = x; position_meeting(xPro,y,obj_grid); xPro += tM) {
				part_particles_burst(global.part_sys,xPro +sprite_width/2,y +sprite_height/2,part_bullet_trail);		
			}
			for (var xPro = x; position_meeting(xPro,y,obj_grid); xPro += tM*gS) {
				with instance_position(xPro,y,obj_generic_piece) {
					if team != other.team {
						if !intangible {
							effect_give(EFFECT.SLOW,other.timer_end,2);
							hp -= 1;
							repeat(30){ part_particles_burst(global.part_sys,xPro,y +sprite_height/2,part_bullet_impact); }
							audio_stop_sound(snd_bullet_hit);
							audio_play_sound(snd_bullet_hit,0,0);
						}
					}
				}
			}
		}
	}
}