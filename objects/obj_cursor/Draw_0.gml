if !using_mk && !instance_exists(obj_menu) {
	window_set_cursor(cr_none);
	draw_self();	
} else {
	window_set_cursor(cr_default);	
}

draw_set_color(c_white);
draw_set_font(fnt_bit);
draw_set_valign(fa_middle);

if global.mode = "delete" {
	draw_sprite(spr_remove_x,image_index,x-sprite_width/2,y-sprite_height/2);
}

var 
stringDraw = -1,
descWidth = 0,
descHeight = 0,
check = noone,
checkZOff = 0,
margin = 3,
movingSomething = noone;
with obj_hero_wall {
	checkZOff = z;
	if instance_exists(piece_on_grid) {
		checkZOff += piece_on_grid.z;	
	}
	if collision_rectangle(bbox_left,bbox_top -checkZOff,bbox_right,bbox_bottom -checkZOff,obj_cursor,false,false) {
		check = id;
		stringDraw = string(ceil(total_health(hp))) +" HP";
	}
}
with obj_generic_piece {
	checkZOff = z;
	if instance_exists(piece_on_grid) {
		checkZOff += piece_on_grid.z;	
	}
	if execute == "move" && team == global.player_team {
		movingSomething = id;	
	} else {
		// Check if on the piece's hitbox
		if collision_rectangle(bbox_left,bbox_top -checkZOff,bbox_right,bbox_bottom -checkZOff,obj_cursor,false,false) {
			stringDraw = string(ceil(total_health(hp))) +" HP";
		} 
		// Check if on the piece's position
		checkZOff -= z;
		if collision_rectangle(bbox_left,bbox_top -checkZOff,bbox_right,bbox_bottom -checkZOff,obj_cursor,false,false) {
			check = id;	
		}
	}
}
if instance_exists(movingSomething) {
	var zOff = movingSomething.z;
	if instance_exists(movingSomething.piece_on_grid) {
		zOff += movingSomething.piece_on_grid.z;
	}
	if !collision_rectangle(movingSomething.bbox_left,movingSomething.bbox_top -zOff,movingSomething.bbox_right,movingSomething.bbox_bottom -zOff,obj_cursor,false,true) {
		var invalid = false;
		if instance_exists(check) {
			if check.team == movingSomething.team {
				invalid = true;	
			}			
		}
		with movingSomething {
			var 
			setsOfMoves = array_length(valid_moves),
			mouseOn = false,
			mouseOnCantAttack = false,
			gcX = x,
			gcY = y,
			brk = false;
			if instance_exists(piece_on_grid) {
				gcX = grid_pos[0]*GRIDSPACE +piece_on_grid.bbox_left;
				gcY = grid_pos[1]*GRIDSPACE +piece_on_grid.bbox_top;	
			}
			for (var set = 0; set < setsOfMoves; ++set)	{	
				var arLeng = array_length(valid_moves[set]);
				// For each move available (i)
				for (var i = 0; i < arLeng; ++i)	{
					var preValidX = valid_moves[set][i][0],
					preValidY = valid_moves[set][i][1];
					// Check if affected by team & toggle
					if is_string(preValidX) {
						preValidX = tm_dp(real(preValidX),team,toggle);
					}
					if is_string(preValidY) {
						preValidY = tm_dp(real(preValidY),team,toggle);
					}
					var xM = preValidX*GRIDSPACE +gcX,
					yM = preValidY*GRIDSPACE +gcY,
					onGrid = instance_position(xM +GRIDSPACE/2,yM +GRIDSPACE/2,obj_grid),
					zOff2 = 0;
					if instance_exists(onGrid) {
						zOff2 = onGrid.z
					}
					if collision_rectangle(xM,yM -zOff2,xM +GRIDSPACE,yM +GRIDSPACE -zOff2,obj_cursor,false,true) && (valid_moves[set][i][0] != 0 || valid_moves[set][i][1] != 0) {
						mouseOn = true;
						if set != BOTH && set != ONLY_ATTACK {
							mouseOnCantAttack = true;	
						}
						brk = true;
						break;
					} 	
				}
				if brk { break; }
			}
			if mouseOn {
				if invalid {
					stringDraw = "ILLEGAL";	
				} else {
					if mouseOnCantAttack {
						stringDraw = "MOVE";
					} else {
						stringDraw = string(attack_power) +" ATTACK";
					}				
				}
				descWidth = string_width(stringDraw);
				descHeight = string_height(stringDraw);
			}
		}
	}
}


// Draw pop up descriptions from slots
with instance_position(x,y,obj_piece_slot) {
	if identity != "Empty" {
		stringDraw = desc;
	}
}
with instance_position(x,y,obj_loadout_slot) {
	if identity != "Empty" {
		stringDraw = desc;
	}
}
with instance_position(x,y,obj_unlocked_slot) {
	if identity != "Empty" {
		stringDraw = desc;
	}
}
// Draw power passive popup
with instance_position(x,y,obj_power_passive) {
	stringDraw = desc;
}
descWidth = string_width(stringDraw);
descHeight = string_height(stringDraw);
var flip = (x <= room_width/2)?1:-1;
if flip {
	draw_set_halign(fa_left);
} else {
	draw_set_halign(fa_right);
}

if stringDraw != -1 && global.game_state != PAUSED && global.tooltips_enabled {
	draw_set_alpha(0.8);
	draw_set_color(c_black);
	draw_rectangle(x,y,x +(descWidth +margin*2)*flip,y -descHeight -margin,false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_text_scribble(x +margin*flip,y -margin -4,stringDraw);	
}
/*
draw_text(x,y,grid_pos);
draw_text(x,y +16,on_grid);