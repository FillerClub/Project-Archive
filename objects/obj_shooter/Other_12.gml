timer -= timer_end;
timer_end = random_percent(1,5);
shooting = false;
if !scan_for_enemy() {
	exit;
}
var zOff = z;	
var gridOff = piece_on_grid;
if is_string(gridOff) {
	with obj_grid {
		if tag == gridOff {
			zOff += z;
			break;
		}
	}
} else if instance_exists(gridOff) { zOff += gridOff.z; }
instance_create_depth(x +sprite_width/2 +tm_dp(28,team,toggle) +random_range(-4,4),y +sprite_height/2 +9 +random_range(-4,4),depth -GRIDSPACE/2,obj_bullet_parent, {
	team: team,	
	x_vel: ((team == "friendly")?1:-1),
	z: zOff,
});