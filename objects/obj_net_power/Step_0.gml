x = piece_link.x;
y = piece_link.y;

var tm = (team == "friendly")?1:-1;

var setsOfMoves = array_length(valid_moves),
clickedOn = false,
mosBX = obj_cursor.x,
mosBY = obj_cursor.y,
mosOnGrid = obj_cursor.on_grid,
mosPos = obj_cursor.grid_pos,
hasCommitted = -1;

if global.game_state == PAUSED {
	exit;	
}

// Deselect
if execute != "nothing" && input_check_pressed("action") {
	if execute = "move" && mosOnGrid != noone {
		var
		mosX = floor((mosBX -mosOnGrid.bbox_left)/GRIDSPACE)*GRIDSPACE +mosOnGrid.bbox_left +GRIDSPACE/2,
		mosY = floor((mosBY -mosOnGrid.bbox_top)/GRIDSPACE)*GRIDSPACE +mosOnGrid.bbox_top +GRIDSPACE/2;
		for (var set = 0; set < setsOfMoves; ++set)	{	
			var arLeng = array_length(valid_moves[set]);
			// For each move available (i)
			for (var i = 0; i < arLeng; ++i) {
				var 
				xM = valid_moves[set][i][0]*GRIDSPACE +piece_link.x +GRIDSPACE/2,
				yM = valid_moves[set][i][1]*GRIDSPACE +piece_link.y +GRIDSPACE/2,		
				moveOnGrid = instance_position(xM,yM,obj_grid);
				if moveOnGrid == noone {
					continue;
				}
				xM = floor((xM -moveOnGrid.bbox_left)/GRIDSPACE)*GRIDSPACE +moveOnGrid.bbox_left +GRIDSPACE/2;
				yM = floor((yM -moveOnGrid.bbox_top)/GRIDSPACE)*GRIDSPACE +moveOnGrid.bbox_top +GRIDSPACE/2;
				
				if (mosX == xM) && (mosY == yM) && (valid_moves[set][i][0] != 0 || valid_moves[set][i][1] != 0) {
					clickedOn = true;
				} else if (mosX == xM) && (mosY == yM) && (valid_moves[set][i][0] == 0 && valid_moves[set][i][1] == 0) {
					hasCommitted = false;
				}
			}
		}
	}	
	if !clickedOn {
		execute = "nothing";
		audio_stop_sound(snd_pick_up);
		audio_play_sound(snd_put_down,0,0);
	}
}

if execute != "move" {
	hasCommitted = false;
}
if input_check_pressed("action") {
	with piece_link {
		if piece_attack(other.valid_moves[ONLY_MOVE], ONLY_MOVE, other.cost, true) {
			repeat(45) {
				part_particles_burst(global.part_sys,x +GRIDSPACE/2,y +GRIDSPACE/2,part_slap);		
			}	
			audio_play_sound(snd_oip,0,0);
			hasCommitted = true;	
		}
	}
}

if hasCommitted != -1 {
	if !hasCommitted {
		with slot_linked {
			cooldown = 0;
		}
	} 
	with slot_linked {
		pause_cooldown = false;
	}
	instance_destroy();
}