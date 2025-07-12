function scale_grid(scale_factor,create_walls = true){
	var shiftAmt = 0,
	oY = 0,
	yDiff = 0;
	if scale_factor > 1 {
		var shiftAmt = -1;
	} else if scale_factor < 1 {
		var shiftAmt = 1;
	} else {
		exit;	
	}
	instance_destroy(obj_hero_wall);
	with obj_grid {
		var midCenter = (bbox_top +bbox_bottom)/2;
		oY = y;
		image_yscale = image_yscale*scale_factor;
		do {
			y += shiftAmt;
		} until round((bbox_top +bbox_bottom)/2) == round(midCenter);
		yDiff = oY -y;
		event_perform(ev_create,0);
	}
	with obj_marker {
		image_yscale = image_yscale*scale_factor;
		y += yDiff;
	}
}