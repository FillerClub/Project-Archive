var tm = (team == "friendly")?1:-1,
totalHP = total_health(hp),
imgIndex = clamp(ceil((totalHP/10)*3),0,3),
shadowSize = 1/(max(0,log2(z/64 +.5)) +1);
// Draw shadow
//draw_sprite_ext(spr_shadow,0,x +sprite_width/2,y +sprite_height -(z/2)*shadowSize, 1, shadowSize, 0, c_white, shadowSize);
sprite_set_offset(sprite_index,sprite_width/2,sprite_height/2);
draw_sprite_ext(spr_generic_wall,imgIndex,x +sprite_width/2,y +sprite_height/2 -z,tm,1,0,c_white,1);
sprite_set_offset(sprite_index,0,0);	


if totalHP <= 0 && !invincible {
	audio_play_sound(snd_critical_hit,0,0);	
	with obj_generic_hero {
		if team == other.team {
			hp -= 1;	
		}
	}
	invincible = true;
}
	
