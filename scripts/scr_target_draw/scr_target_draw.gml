function scr_target_draw(){
var gS = GRIDSPACE;

var gClampX = obj_cursor.x;
var gClampY = obj_cursor.y;

var col = c_red;

draw_sprite_ext(
spr_grid_target,0,
gClampX,
gClampY,
1,1,0,col,1);
}
