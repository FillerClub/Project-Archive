event_inherited();

// shoot
if global.game_state != PAUSED{
	var 
	gS = GRIDSPACE,
	tM = (team == "friendly")?1:-1;
	if (timer >= timer_end) {		
		var decideShoot = scan_for_enemy(false),
		playSound = false;
		
		if decideShoot {
			for (var xPro = x; position_meeting(xPro,y,obj_grid); xPro += tM) {
				part_particles_burst(global.part_sys,xPro +sprite_width/2,y +sprite_height/2,part_bullet_trail);		
			}
			for (var xPro = x; position_meeting(xPro,y,obj_grid); xPro += tM*gS) {
				var victimInst = instance_position(xPro,y,obj_generic_piece);
				if victimInst != noone {
					if team != victimInst.team && !victimInst.invincible {
						effect_set(victimInst,"piercer_slow",-1,EFFECT.SLOW,8,2);
						hurt(victimInst.hp,1,victimInst);
						repeat(30){ part_particles_burst(global.part_sys,xPro,y +sprite_height/2,part_bullet_impact); }
						playSound = true;
					}					
				}
			}
			if playSound { audio_play_sound(snd_bullet_hit,0,0); }
			timer = 0;
			timer_end = random_percent(4,5);
		}
	}
}