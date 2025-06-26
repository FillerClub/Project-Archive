draw_self();
draw_text(x,y-16,string(player.name));
draw_text(x,y,string(player.port));
draw_text(x,y+16,string(player.hero));
draw_text(x,y+32,string(player.loadout));
var stringDraw = status_int_to_string(player.status);
draw_text(x,y+48,stringDraw);
