var col = can_place?c_white:c_red,
teamCol = team_colours(team),
teamFlip = tm_dp(-1,team);
var gridRef = piece_on_grid;
if is_string(gridRef) {
	with obj_grid {
		if tag == gridRef {
			gridRef = id;
			break;
		}
	}
} 
if instance_exists(gridRef) {
	draw_sprite_ext(spr_grid_highlight,image_index,gClampX,gClampY -gridRef.z,1,1,0,col,1);	
}
draw_sprite(spr_slot_highlight,image_index,orig_x,orig_y);
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale*teamFlip,image_yscale,image_angle,teamCol,image_alpha);
//draw_text(x,y,link);