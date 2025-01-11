var gS = GRIDSPACE;
var gD = global.grid_dimensions;

draw_set_color(c_white);
grid_highlight_draw([[0,0]],on_grid,on_piece,exclude_barriers);
draw_sprite(spr_slot_select,image_index,orig_x,orig_y);
draw_self();
