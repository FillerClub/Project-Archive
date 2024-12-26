surface_set_target(global.gui_surface);
var col = class;

draw_sprite_ext(spr_slot_bg,image_index,x,y,1,1,0,col,1);

draw_sprite(sprite_slot,0,x,y);

draw_sprite_ext(sprite_index,image_index,x,y,1,1,0,col,1);

draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(c_white) draw_set_font(fnt_bit);
draw_text_transformed(x +41,y +58 ,string(cost),1,1,0);
draw_set_color(c_white) draw_set_font(fnt_fancy);

//draw_text_transformed(x + sprite_width/2,y + sprite_height*1.2 +x,string(identity[PIECEDATA.NAME]),.25,.25,0);

if position_meeting(obj_cursor.x,obj_cursor.y,self) { draw_sprite(spr_slot_select,image_index,x,y);	}
surface_reset_target();