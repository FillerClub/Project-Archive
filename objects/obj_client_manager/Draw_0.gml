/*
if steam_lobby_get_lobby_id() == 0 || room == rm_lobby {
	exit;	
}
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_font(fnt_generic_dialogue);
var datLeng = array_length(lobby_data);
var i = 0;
for (i = 0; i < datLeng; i++) {
	var typ = lobby_data[i].type,
	dat = lobby_data[i].data,
	sup = lobby_data[i].update;
	draw_text(256,256 +i*24,string(typ) +": "+string(dat) +"  -"+string(sup))
}
i++;
