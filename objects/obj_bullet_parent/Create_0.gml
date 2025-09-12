x_init = x;
y_init = y;
z_init = z;
x_target = x;
y_target = y;
z_target = z;
bullet_on_grid = instance_position(x,y,obj_grid);
if instance_exists(target) {
	var zFinal = target.z;
	if object_get_parent(target.object_index) == obj_generic_piece {
		if is_string(target.piece_on_grid) {
			with obj_grid {
				if tag == target.piece_on_grid {
					zFinal += z;	
					break;
				}
			}	
		} else { zFinal += target.piece_on_grid.z;}
	}
	z_target = zFinal;
	x_target = target.x +GRIDSPACE/2;
	y_target = target.y +GRIDSPACE/2;
	if abs(y_init -y_target) > abs(x_init -x_target) {
		use_y_target = true;	
	}
	moving_z = true;
}