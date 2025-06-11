function scale_grid(scale_factor){
	var shiftAmt = (scale_factor -1)/2;
	with obj_grid {
		image_yscale = image_yscale*scale_factor;
		y -= GRIDSPACE*shiftAmt;
		global.grid_dimensions = [bbox_left,bbox_right -GRIDSPACE,bbox_top,bbox_bottom -GRIDSPACE];
	}
	with obj_marker {
		image_yscale = image_yscale*scale_factor;
		y -= GRIDSPACE*shiftAmt;
	}
	with obj_generic_piece {
		grid_pos[1] += shiftAmt;
	}
	with obj_hero_wall {
		grid_pos[1] += shiftAmt;
	}
}