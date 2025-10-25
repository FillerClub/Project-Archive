function highlight_draw(display_mode, valid_spots = [[0,0]], draw_color = c_white, show_lines = false, placeable_on_grid = PLACEABLEANY, placeable_on_piece = DIFFERENT, exclude_barriers = false, skip_grid_check = false, faux = spr_grid_highlight, ignore_color = false){
	if display_mode {
		display_draw(valid_spots,draw_color,show_lines); 
	} else {
		grid_highlight_draw(valid_spots,placeable_on_grid,placeable_on_piece,exclude_barriers,skip_grid_check,faux,show_lines,draw_color,ignore_color);	
	}
}