var own = noone;
with obj_constant_reload {
	if team == other.team {
		own = self;	
	}
}
if !instance_exists(own) {
	instance_destroy();
	exit;
}
if own.ammo <= 0 {
	instance_destroy();	
}
timer += delta_time*DELTA_TO_SECONDS*global.level_speed;
var gunSpeed = .15;
if timer >= gunSpeed {
	var close = infinity,
	closest = noone;
	with obj_generic_piece {
		if team == other.team {
			continue;	
		}
		var dist = distance_to_object(own); 
		if dist < close {
			close = dist;
			closest = id;
		}
	}
	if instance_exists(closest) {
		hurt(closest.hp,25,DAMAGE.NORMAL,closest);
		own.ammo--;
		audio_play_from_array([snd_lonestar_gunshot_1,snd_lonestar_gunshot_2,snd_lonestar_gunshot_3]);
		timer -= gunSpeed;	
	} else if timer >= gunSpeed*6 {
		instance_destroy();
	}
}