function scan_for_hero_wall(limit = 999,piece_x = x,piece_y = y){
var 
gS = GRIDSPACE,
tm = (team == "friendly")?1:-1,
ex = false,
countLimit = -1,
x_scan = piece_x;

do {
	
	countLimit++;
	if position_meeting(x_scan,piece_y,obj_obstacle) {
		with instance_position(x_scan,piece_y,obj_obstacle) {
			if object_index == obj_hero_wall && total_health(hp) > 0 && team != other.team {
				return true;
			}
		}
	} 
	x_scan += gS*tm;
	
	if !position_meeting(x_scan,piece_y,obj_grid) { ex = true; };
} until ex || (countLimit >= limit)

}
