function scan_for_enemy(detect_walls = true, limit = 100, piece_x = x,piece_y = y){
var 
gS = GRIDSPACE,
tm = (team == "friendly")?1:-1,
ex = false,
countLimit = 0,
x_scan = piece_x;

do {
	x_scan += gS*tm;
	countLimit++;
	if position_meeting(x_scan,piece_y,obj_obstacle) {
		with instance_position(x_scan,piece_y,obj_obstacle) {
			if !detect_walls && object_index == obj_hero_wall {
				break;
			}
			if team != other.team && !intangible && hp > 0 {
				return true;
			}
		}
	} 
	
	if !position_meeting(x_scan,piece_y,obj_grid) { ex = true; };
} until ex || (countLimit >= limit)

}
