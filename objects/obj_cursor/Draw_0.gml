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
gS = GRIDSPACE,
//shift = 10,
margin = 3,
movingSomething = noone;

with obj_generic_piece {
	if execute == "move" && team == global.player_team {
		movingSomething = id;	
	}
}

// Draw health as popups
with instance_position(x,y,obj_generic_piece) {
	stringDraw = string(hp) +" HP";
	descWidth = string_width(stringDraw);
	descHeight = string_height(stringDraw);
}
// Draw health as popups
with instance_position(x,y,obj_hero_wall) {
	stringDraw = string(hp) +" HP";
	descWidth = string_width(stringDraw);
	descHeight = string_height(stringDraw);
}

if !position_meeting(x,y,movingSomething) {
	with movingSomething {
		var 
		setsOfMoves = array_length(valid_moves),
		mouseOn = false,
		mosX = floor(other.x/gS)*gS,
		mosY = floor(other.y/gS)*gS,
		gcX = floor(x/gS)*gS,
		gcY = floor(y/gS)*gS;
				
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
				var xM = preValidX*gS +gcX;
				var yM = preValidY*gS +gcY;		
				if (mosX == xM) && (mosY == yM) && (valid_moves[set][i][0] != 0 || valid_moves[set][i][1] != 0) {
					mouseOn = true;
				} 	
			}
		}
		
		if mouseOn {
			var HPcheck = 0,
			invalid = false;
			if position_meeting(other.x,other.y,obj_generic_piece) || position_meeting(other.x,other.y,obj_hero_wall) {
				var check = instance_position(other.x,other.y,obj_obstacle);
				if check.team == team {
					invalid = true;	
				} else {
					HPcheck = check.hp;	
				}
			}
			if invalid {
				stringDraw = "ILLEGAL";	
			} else {
				var totalCost = cost;
				stringDraw = string(totalCost) +" COST";				
			}

			descWidth = string_width(stringDraw);
			descHeight = string_height(stringDraw);
		}
	}
}



// Draw pop up descriptions from slots
with instance_position(x,y,obj_piece_slot) {
	stringDraw = desc;
	descWidth = string_width(stringDraw);
	descHeight = string_height(stringDraw);
}
with instance_position(x,y,obj_loadout_slot) {
	stringDraw = desc;
	descWidth = string_width(stringDraw);
	descHeight = string_height(stringDraw);
}
with instance_position(x,y,obj_unlocked_slot) {
	stringDraw = desc;
	descWidth = string_width(stringDraw);
	descHeight = string_height(stringDraw);
}
// Draw power passive popup
with instance_position(x,y,obj_power_passive) {
	stringDraw = desc;
	descWidth = string_width(stringDraw);
	descHeight = string_height(stringDraw);
}

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

//draw_text(x,y,grid_pos);
//draw_text(x,y +16,on_grid);