var gS = GRIDSPACE;
var gD = global.grid_dimensions;

var sound_params = {
	sound: snd_final_bullet,
	pitch: random_range(0.9,1.1),
	};


audio_play_sound_ext(sound_params);
with obj_generic_hero_OLD {
	if team == global.player_team {
		var hX = x,
		hY = y;
	}
}
pe = part_emitter_create(global.part_sys);


pt = part_type_create();
var length = sqrt(sqr(hX -x) + sqr(hY -y))/2,
lengthX = sqrt(sqr(hX -x))*sign(hX -x),
lengthY = sqrt(sqr(hY -y))*sign(hY -y);
var breakIf = false;
for (var i = 0; i < length; ++i) {
	if position_meeting(hX -i*lengthX/length +sprite_width/2, hY -i*lengthY/length +sprite_height/2, obj_obstacle) {
		with instance_position(hX -i*lengthX/length +sprite_width/2,hY -i*lengthY/length +sprite_height/2,obj_obstacle) {
			if team != global.player_team {
				part_particles_burst(global.part_sys,hX -i*lengthX/length +sprite_width/2,hY -i*lengthY/length +sprite_height/2,part_explode);	
				if !intangible {
					hp -= 10;
				}
				breakIf = true;
			}
		}
	}
	if breakIf {
		break;	
	}
	/*	part_emitter_delay(global.part_sys, pe, i, i, time_source_units_frames);
		part_emitter_region(global.part_sys,pe,x +i*lengthX/length +sprite_width/2,x +i*lengthX/length +sprite_width/2,y +i*lengthY/length +sprite_height/2,y +i*lengthY/length +sprite_height/2,ps_shape_line,ps_distr_linear);
		part_emitter_burst(global.part_sys,pe,pt,1); */
		part_particles_burst(global.part_sys,hX -i*lengthX/length +sprite_width/2,hY -i*lengthY/length +sprite_height/2,part_bullet_trail);	
}
/*part_emitter_destroy(global.part_sys,pe);
part_type_destroy(pt);*/
instance_destroy()