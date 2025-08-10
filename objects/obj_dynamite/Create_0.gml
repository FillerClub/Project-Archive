x_init = x;
y_init = y;
z_init = z;
image_angle = random(359);
rot_speed = 350*(irandom(1)*2-1) + random(200)*(irandom(1)*2-1);
bullet_on_grid = instance_position(x,y,obj_grid);
if instance_exists(target) {
	if abs(y_init -y_target) > abs(x_init -x_target) {
		use_y_target = true;	
	}
	moving_z = true;
}
aura =			[[0, 0], 
				[0, 1],
				[0, -1],
				[1, 0],
				[1, 1],
				[1, -1],
				[-1, 0],
				[-1, 1],
				[-1, -1]];