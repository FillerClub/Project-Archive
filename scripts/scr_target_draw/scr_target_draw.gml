function scr_target_draw(){
var gS = global.grid_spacing;
var gD = global.grid_dimensions;

var gClampX = clamp(floor(obj_cursor.x/gS),gD[0]/gS,gD[1]/gS)*gS;
var gClampY = clamp(floor(obj_cursor.y/gS),gD[2]/gS,gD[3]/gS)*gS;

var col = c_red;

draw_sprite_ext(
spr_grid_target,0,
gClampX,
gClampY,
1,1,0,col,1);
}
