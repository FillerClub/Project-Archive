timer -= timer_end;
timer_end = random_percent(1.4,4);
if scan_for_enemy() {
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
	instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -GRIDSPACE/2,obj_bullet_parent, {
	team: team,	
	x_vel: ((team == "friendly")?1:-1),
	z: zOff,
	dmg: 2,
	image_xscale: 1.4,
	image_yscale: 1.4,
	});

}