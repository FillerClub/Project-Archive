if global.game_state == PAUSED exit;	

var brk = false;
//Convert velocity to something useable
var baseBulletSpd = 3000,
realXVel = round(baseBulletSpd*x_vel*delta_time*DELTA_TO_SECONDS*global.level_speed),
realYVel = round(baseBulletSpd*y_vel*delta_time*DELTA_TO_SECONDS*global.level_speed);

// Calculate steps needed to take
var trailCover = ceil(distance_to_point(x +realXVel,y +realYVel));

for (var trail = 0; trail < trailCover; trail++) {
	//Draw trail of bullet
	var trailX = lerp(x,x +realXVel,trail/trailCover),
	trailY = lerp(y,y +realYVel,trail/trailCover);
	part_particles_burst(global.part_sys,trailX,trailY,part_bullet_trail);
	
	with collision_point(trailX,trailY,obj_obstacle,false,true) {
		var oth = other;
		if team != oth.team && !intangible {
			var sound_params = {
			sound: snd_bullet_hit,
			pitch: random_range(0.7,1.3),
			};
	
			audio_play_sound_ext(sound_params);
			hp -= oth.dmg;			
			repeat(30){ part_particles_burst(global.part_sys,trailX,trailY,part_bullet_impact); }	
			instance_destroy(oth);
			brk = true;
		}
	}
	if brk { break; }
}

if brk { exit; }
x += realXVel;
y += realYVel;

dmg = dmg/(max(distance_to_point(x_init,y_init)/falloff_dist,1));





