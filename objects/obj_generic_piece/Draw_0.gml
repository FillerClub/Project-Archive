/// @desc Generic piece draw code
var tM = (team == "enemy")?-1:1,
gX = obj_cursor.x,
gY = obj_cursor.y,
colS = c_white,
col = c_white,
debugOn = false,
drawSpr = spr_grid_highlight,
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
if execute != "move" && global.debug && ai_controlled { debugOn = true; } 


// Draw highlighted squares on the grid.
surface_set_target(global.grid_highlight_surface);
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
surface_reset_target();
surface_set_target(global.piece_surface);

var
xFlip = (1 -toggle*2)*tM,
xScale = (1 +ai_timer/(timer_to_take*2))*xFlip,
yScale = (1 +ai_timer/(timer_to_take*2));

var hpMissing = (hp_start -hp)/hp_start;

// Draw the sprite at a shifted origin to make flipping easier
sprite_set_offset(sprite_index,sprite_width/2,sprite_height/2);
// Draw sprite
draw_sprite_ext(sprite_index,image_index,x +sprite_width/2,y +sprite_height/2,xScale,yScale,0,col,intangible_tick);
sprite_set_offset(sprite_index,0,0);

// Draw cooldown timer
scr_draw_circle_part(x +sprite_width/2, y +sprite_height/2,32,timer_color,false,180,true,move_cooldown_timer*(360/move_cooldown),360,.5);

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
		draw_text(x,y,string(floor(sPD/5) +1) + "x ");
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
		draw_text(x,y,string(floor(sLW/5) +1) + "x ");
	}
}

surface_reset_target();

// Create HP effect and reset variables
if hp_init != hp {
	damaged = true;
	instance_create_layer(x +sprite_width/2 +(random_range(-sprite_width/2,sprite_width/2)),y +sprite_height/2 +(random_range(-sprite_height/2,sprite_height/2)),"AboveBoard",obj_hit_fx,{
		hp: hp -hp_init
	});
}
hp_init = hp;
image_speed = 1 +sprite_accel*9;

//draw_text(x,y,effects_management_array);
//draw_text(x,y+64,effects_array);