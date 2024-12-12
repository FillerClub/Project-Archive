draw_sprite(spr_grid_highlight,image_index,x,y);

var arrayLengthMovesList = array_length(valid_moves);
// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
for (var list = 0; list < arrayLengthMovesList; list++) {
	// Filter out dead arrays
	if valid_moves[list] != undefined && valid_moves[list] != 0 {
		if list == ONLY_MOVE { display_draw(valid_moves[ONLY_MOVE],c_aqua,true); }
		if list == ONLY_ATTACK { display_draw(valid_moves[ONLY_ATTACK],c_red,true); }
		if list == BOTH { display_draw(valid_moves[BOTH],c_white,true); }
	}	
}

sprite_set_offset(sprite_index,sprite_width/2,sprite_height/2);
draw_sprite_ext(sprite_index,image_index,x +sprite_width/2,y +sprite_height/2,1,1,0,c_white,1);
sprite_set_offset(sprite_index,0,0);