function scan_for_enemy(detect_walls = true, limit = 100, piece_x = x,piece_y = y, piece_z = z -GRIDSPACE/2){
var 
gS = GRIDSPACE,
tm = (team == "friendly")?1:-1,
ex = false,
countLimit = 0,
x_scan = piece_x;

do {
	x_scan += gS*tm;
	countLimit++;
	var preScan = instance_position(x_scan,piece_y,obj_obstacle);
	if !instance_exists(preScan) {
		continue;	
	}
	if z < preScan.z -preScan.zidth || z > preScan.z +preScan.zidth {
		continue;
	}
	with instance_position(x_scan,piece_y,obj_obstacle) {
		if !detect_walls && object_get_parent(object_index) != obj_generic_piece {
			break;
		}
		if team != other.team && !invincible && hp > 0 {
			return true;
		}
	}
	if position_meeting(x_scan,piece_y,obj_boundary) { ex = true; };
} until ex || (countLimit >= limit)

}
