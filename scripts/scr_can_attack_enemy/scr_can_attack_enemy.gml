function scr_can_attack_enemy() {
// Set up variables

var 
gS = global.grid_spacing,
arLeng = array_length(valid_attacks),
index = 0;
movelist[index] = pointer_null;
	
// Check where to move
for (var i = 0; i < arLeng; ++i) {
	var 
	validX = (valid_attacks[i][0])*gS +x,
	validY = (valid_attacks[i][1])*gS +y;
	
	if (position_meeting(validX,validY,obj_obstacle)) {
		var tM = "noone",
		hP = 0;
		with instance_position(validX,validY,obj_obstacle) {
			tM = team;
			hP = hp;
		}
		if team != tM && hP > 0 {
			movelist[index] = [validX,validY];	
			index += 1;
		}
	}
}
return movelist;		
}