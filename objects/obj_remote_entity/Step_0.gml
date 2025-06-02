if create != noone && room == rm_test {
	instance_create_layer(x,y,"Instances",obj_shooter, {
		dragging: false,
		fresh: false,
		moveable: false,		
		team: (global.player_team == "friendly")?"enemy":"friendly",		
	});
}
instance_destroy();