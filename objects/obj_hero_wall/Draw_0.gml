var tm = (team == "friendly")?1:-1,
imgIndex = clamp(ceil((hp/10)*3),0,3),
shadowSize = 1/(max(0,log2(z/64 +.5)) +1);
// Draw shadow
//draw_sprite_ext(spr_shadow,0,x +sprite_width/2,y +sprite_height -(z/2)*shadowSize, 1, shadowSize, 0, c_white, shadowSize);
sprite_set_offset(sprite_index,sprite_width/2,sprite_height/2);
draw_sprite_ext(spr_generic_wall,imgIndex,x +sprite_width/2,y +sprite_height/2,tm,1,0,c_white,1);
sprite_set_offset(sprite_index,0,0);	


if hp_init != hp {
	instance_create_layer(x +sprite_width/2 +(random_range(-sprite_width/2,sprite_width/2)),y +sprite_height/2 +(random_range(-sprite_height/2,sprite_height/2)),"AboveBoard",obj_hit_fx,{
		hp: hp -hp_init
	});	
	if hp <= 0 {
		audio_play_sound(snd_critical_hit,0,0);	
		with obj_generic_hero {
			if team == other.team {
				hp -= 1;	
			}
		}
		invincible = true;
	}
}

hp_init = hp;