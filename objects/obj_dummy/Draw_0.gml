var gS = GRIDSPACE;
var gD = global.grid_dimensions,
gOffsetX = gD[0] mod gS,
gOffsetY = gD[2] mod gS;

draw_set_color(c_white);
surface_set_target(global.grid_highlight_surface);
grid_highlight_draw([[0,0]],on_grid,on_piece,exclude_barriers);
surface_reset_target();
draw_sprite(spr_slot_select,image_index,orig_x,orig_y);
surface_set_target(global.piece_surface);
draw_self();
surface_reset_target();
