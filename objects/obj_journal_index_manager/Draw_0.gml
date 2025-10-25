/*
draw_set_font(fnt_generic_dialogue);
draw_set_valign(fa_middle);
draw_set_halign(fa_left);
*/
var leng = array_length(display_list);
for (var i = 0; i < leng; i++) {
	with display_list[i].index_object {
		draw_slot(sprite_slot,class,c_white,cost);
	}
}
