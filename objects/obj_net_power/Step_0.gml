x = piece_link.x;
y = piece_link.y;

var gS = GRIDSPACE;
var tm = (team == "friendly")?1:-1;

var setsOfMoves = array_length(valid_moves),
clickedOn = false,
gX = obj_cursor.x,
gY = obj_cursor.y,
mosX = floor(gX/gS)*gS,
mosY = floor(gY/gS)*gS,
gcX = floor(x/gS)*gS,
gcY = floor(y/gS)*gS;

if global.pause {
	exit;	
}

// Deselect
if execute != "nothing" && input_check_pressed("action") {
	if execute = "move" {
		for (var set = 0; set < setsOfMoves; ++set)	{	
			var arLeng = array_length(valid_moves[set]);
			// For each move available (i)
			for (var i = 0; i < arLeng; ++i) {
				var xM = valid_moves[set][i][0]*gS +gcX;
				var yM = valid_moves[set][i][1]*gS +gcY;		
				if !position_meeting(mosX,mosY,obj_obstacle) {
					if (mosX == xM) && (mosY == yM) && (valid_moves[set][i][0] != 0 || valid_moves[set][i][1] != 0) {
						clickedOn = true;
					} 
				} else if (mosX == xM) && (mosY == yM) && (valid_moves[set][i][0] == 0 && valid_moves[set][i][1] == 0) {
					instance_destroy();
				}
			}
		}
	}
	
	if position_meeting(mosX,mosY,self) {
			clickedOn = true;
			audio_play_sound(snd_error,0,0);
	}
	
	if !clickedOn {
		execute = "nothing";
		audio_play_sound(snd_error,0,0);
	}
}

if execute != "move" {
	instance_destroy();
}

if piece_attack(other.valid_moves[ONLY_MOVE], ONLY_MOVE, 0, true) {
	with piece_link {
		repeat(45) {
			part_particles_burst(global.part_sys,x,y,part_slap);		
		}	
		x = other.x;
		y = other.y;
	}
	with link {
		usable = false;	
	}
	audio_play_sound(snd_oip,0,0);
	instance_destroy();		
}