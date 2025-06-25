draw_self();
draw_text(x,y-16,string(name));
draw_text(x,y,string(port));
draw_text(x,y+16,string(hero));
draw_text(x,y+32,string(loadout));
var stringDraw = status_int_to_string(status);
draw_text(x,y+48,stringDraw);
