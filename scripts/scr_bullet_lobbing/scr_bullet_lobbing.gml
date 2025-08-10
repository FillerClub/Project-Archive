function bullet_lobbing(active,x_target,y_target,z_target,x_init,y_init,z_init,lob_height,use_y_target = false) {
	if active {
		var track_pos, track_tar, track_init;
		if use_y_target {
			track_pos = y; track_tar = y_target; track_init = y_init;
		} else {
			track_pos = x; track_tar = x_target; track_init = x_init;
		}
		var lerp_val = abs((track_pos -track_init)/(track_tar -track_init)),
		lob_add = -4*lob_height*(lerp_val - 0.5)*(lerp_val - 0.5) +lob_height;
		z = lerp(z_init,z_target,lerp_val) +lob_add;
	}
}