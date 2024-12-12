if global.team == "friendly" && !place_meeting(x,y,obj_territory_friendly) {
	exit;	
}

if global.team == "enemy" && !place_meeting(x,y,obj_territory_enemy) {
	exit;	
}
var spr_y = y;

for (var i = 0; i < sprite_height/64; ++i) {
	draw_sprite(sprite_index,0,x,spr_y);
	var spr_y = spr_y + 64;	
}
