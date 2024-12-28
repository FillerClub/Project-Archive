function scale_grid(scale_factor){
	var gS = GRIDSPACE;
	with obj_grid {
		var shiftAmt = (scale_factor -1)/2
		image_yscale = image_yscale*scale_factor;
		y -= gS*shiftAmt;
		global.grid_dimensions = [bbox_left,bbox_right -gS,bbox_top,bbox_bottom -gS];
	}
	with obj_marker {
		image_yscale = image_yscale*scale_factor;
		y -= gS*shiftAmt;
	}
	
}