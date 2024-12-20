/// @desc Generic piece draw code
var tM = (team == "enemy")?-1:1,
gX = obj_cursor.x,
gY = obj_cursor.y,
colS = c_white,
col = c_white,
debugOn = false,
drawSpr = spr_grid_highlight;


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
if execute != "move" && global.debug && ai_controlled { debugOn = true; } 

// Draw highlighted squares on the grid.
if execute == "move" || debugOn {
	// Draw own square
	if debugOn {
		drawSpr = spr_grid_dotted; 
	}
	
	if position_meeting(gX,gY,self) && !debugOn {
		colS = c_red;
	}
		
	draw_sprite_ext(drawSpr,image_index,
		x,
		y,
		1,1,0,colS,1);
		
	var arrayLengthMovesList = array_length(valid_moves);
	// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
	for (var list = 0; list < arrayLengthMovesList; list++) {
		// Filter out dead arrays
		if valid_moves[list] != undefined && valid_moves[list] != 0 {
			switch list {
				case ONLY_MOVE:
					highlight_draw(display_mode,valid_moves[ONLY_MOVE],c_aqua,debugOn,PLACEABLEANY,PLACEABLENONE,false,false,debugOn);
				break;
				case ONLY_ATTACK:
					highlight_draw(display_mode,valid_moves[ONLY_ATTACK],c_red,debugOn,PLACEABLENONE,DIFFERENT,false,false,debugOn)
				break;
				case BOTH:
					highlight_draw(display_mode,valid_moves[BOTH],c_white,debugOn,PLACEABLEANY,DIFFERENT,false,false,debugOn)
				break;
			}
		}	
	}	
}


// Draw speed arrows
if spd > 0 {
	for (var i = 0; i < spd; ++i) {
		draw_sprite_ext(spr_boosted,0,x,y -i*7 +5,1,1,0,c_white,clamp(spd -i,0,1));		
	}
}
// Draw slow arrows
if slw > 0 {
	for (var i = 0; i < slw; ++i) {
		draw_sprite_ext(spr_slowed,0,x,y +i*7 +5,1,1,0,c_white,clamp(slw -i,0,1));		
	}
}

var
xFlip = (1 -toggle*2)*tM,
xScale = (1 +ai_timer/(timer_to_take*2))*xFlip,
yScale = (1 +ai_timer/(timer_to_take*2));

var hpMissing = (hp_start -hp)/hp_start;
/*
obj_shader_handler.piece_fx_id.SetEffectParameter(FX_EFFECT.VHS,PP_VHS_SCAN_SPEED,5*hpMissing);
obj_shader_handler.piece_fx_id.SetEffectParameter(FX_EFFECT.VHS,PP_VHS_SCAN_OFFSET,hpMissing);
obj_shader_handler.piece_fx_id.SetEffectParameter(FX_EFFECT.VHS,PP_VHS_HSCAN_OFFSET,.05*hpMissing);
obj_shader_handler.piece_fx_id.SetEffectParameter(FX_EFFECT.VHS,PP_VHS_WIGGLE_AMPLITUDE,.005*hpMissing);
shader_set(__ppf_sh_render_vhs);*/

// Draw the sprite at a shifted origin to make flipping easier
sprite_set_offset(sprite_index,sprite_width/2,sprite_height/2);
// Draw sprite
draw_sprite_ext(sprite_index,image_index,x +sprite_width/2,y +sprite_height/2,xScale,yScale,0,col,.5 +intangible_tick/2);
sprite_set_offset(sprite_index,0,0);

// Draw cooldown timer
scr_draw_circle_part(x +sprite_width/2, y +sprite_height/2,32,timer_color,false,180,true,move_cooldown_timer*(360/move_cooldown),360,.5);

// Create HP effect and reset variables
if hp_init != hp {
	damaged = true;
	instance_create_layer(x +sprite_width/2 +(random_range(-sprite_width/2,sprite_width/2)),y +sprite_height/2 +(random_range(-sprite_height/2,sprite_height/2)),"AboveBoard",obj_hit_fx,{
		hp: hp -hp_init
	});
}
hp_init = hp;
spd = 0;
image_speed = 1 +sprite_accel*9;

//draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,false);

//draw_text(x,y+64,string(x) +" : " +string(y));
//draw_text(x,y+80,ignore_pause);
//draw_text(x,y+96,identity);
// Old code for hero piece
/*
 else {
	col = c_white;
	tM = 1;
	draw_sprite_ext(sprite_index,image_index,x,y,(1 +ai_timer/(timer_to_take*2))*(1 -toggle*2)*tM,(1 +ai_timer/(timer_to_take*2)),0,col,.5 +intangible_tick/2);
}