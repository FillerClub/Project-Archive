/// @desc Generic piece draw code
var tM = (team == "enemy")?-1:1,
colS = c_white,
col = c_white,
sPD = effects_array[EFFECT.SPEED],
sLW = effects_array[EFFECT.SLOW];


switch team {
	case "friendly":
		col = #7FFFFF;
	break;
	case "enemy":
		col = #EE2F36;
	break;
	default:
		col = c_white;	
	break;
}

var
xFlip = (1 -toggle*2)*tM,
xScale = (1 +ai_timer/(TIMETOTAKE*2))*xFlip,
yScale = (1 +ai_timer/(TIMETOTAKE*2));

var hpMissing = (hp_max -hp)/hp_max;

var origXoffset = sprite_xoffset,
origYoffset = sprite_yoffset;
// Draw the sprite at a shifted origin to make flipping easier
sprite_set_offset(sprite_index,sprite_width/2 +sprite_xoffset,sprite_height/2 +sprite_yoffset);
// Draw sprite
draw_sprite_ext(sprite_index,image_index,x +sprite_width/2,y +sprite_height/2,xScale,yScale,0,col,intangible_tick);
// Draw cooldown timer
if move_cooldown_timer > 0 {
	scr_draw_circle_part(x +sprite_width/2 -origXoffset, y +sprite_height/2 -origYoffset,32,timer_color,false,180,false,0,(360*move_cooldown_timer)/move_cooldown,.5);
}
// Draw health
sprite_set_offset(sprite_index,origXoffset,origYoffset);

draw_set_font(fnt_bit);
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
// Draw speed arrows
if sPD > 0 {
	if sPD < 5 {
		for (var i = 0; i < sPD; ++i) {
			draw_sprite_ext(spr_boosted,0,x,y -i*7 +5,1,1,0,c_white,clamp(sPD -i,0,1));		
		}
	} else {
		draw_sprite_ext(spr_boosted,0,x,y,1,1,0,c_white,1);
		draw_text_scribble(x,y,string(floor(sPD/5) +1) + "x ");
	}
}
// Draw slow arrows
if sLW > 0 {
	if sLW < 5 {
		for (var i = 0; i < sLW; ++i) {
			draw_sprite_ext(spr_slowed,0,x,y +i*7 +5,1,1,0,c_white,clamp(sLW -i,0,1));			
		}
	} else {
		draw_sprite_ext(spr_slowed,0,x,y,1,1,0,c_white,1);
		draw_text_scribble(x,y,string(floor(sLW/5) +1) + "x ");
	}
}

// Create HP effect and reset variables
if hp_init != hp {
	damaged = true;
	last_damaged = 0;
	instance_create_layer(x +sprite_width/2 +(random_range(-sprite_width/2,sprite_width/2)),y +sprite_height/2 +(random_range(-sprite_height/2,sprite_height/2)),"AboveBoard",obj_hit_fx,{
		hp: hp -hp_init
	});
}

image_speed = 1 +sprite_accel*9;

if global.game_state != PAUSED {
	if damaged {
		if hp < hp_max {
			last_damaged += delta_time*DELTA_TO_SECONDS*global.level_speed;	
		} else {
			last_damaged = 0;
			damaged = false;
		}	
	}
	moved = false;
	hp_init = hp;
	skip_click = false;
}
//draw_text_scribble(x,y -8,grid_pos);
//draw_text_scribble(x,y -16,piece_on_grid);
/*
draw_text(x,y+64,string(effects_array));
draw_text(x,y+80,string(effects_timer));
for (var temp = 0; temp < array_length(effects_management_array); temp++) {
	draw_text(x,y+96 +16*temp,string(effects_management_array[temp]));
}
