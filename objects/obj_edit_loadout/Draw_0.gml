draw_set_font(fnt_basic);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
//x = mouse_x;
//y = mouse_y;
var alpha = 1;
if obj_ready.ready {
	alpha = .25;
	
}
draw_set_alpha(alpha);
draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,alpha);
draw_text_transformed(x,y,"Edit",.75,.75,0);
draw_set_alpha(1);