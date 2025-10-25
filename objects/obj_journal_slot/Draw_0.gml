var col = c_white;
if mouse_over { draw_sprite(spr_slot_highlight,image_index,x,y);	col = #FFFDAA; }
mouse_over = false;
draw_set_font(fnt_generic_dialogue);
draw_set_valign(fa_bottom);
draw_set_halign(fa_left);
draw_set_color(col);
draw_text(x +sprite_width +4,y +sprite_height -2,name);