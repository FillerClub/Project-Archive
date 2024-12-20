if execute == "move" {
	grid_highlight_draw(valid_moves[BOTH],PLACEABLEANY,PLACEABLEANY);
} 

piece_draw();
// debug text
/*
draw_text(x +8,y +40,string(grid_pos[0]) + " x " + string(grid_pos[1]));
draw_text(x +8,y +64,timer);
