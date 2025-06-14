
if global.debug {
	if instance_exists(obj_world_one) {
		with obj_world_one {
			timer += 100;	
		}
	}
	if instance_exists(obj_generic_piece) {
		with obj_generic_piece {
			if team != global.player_team && object_get_parent(object_index) != obj_generic_hero_OLD {
				instance_destroy();	
			}
		}
	}
	if instance_exists(obj_timer) {
		timer[MAIN] += global.timeruplength;
	}
}


/*
gS = GRIDSPACE;
var
gClampX = clamp(floor(mouse_x/gS)*gS,gD[0],gD[1]),
gClampY = clamp(floor(mouse_y/gS)*gS,gD[2],gD[3]);
instance_create_layer(gClampX,gClampY,"Instances",obj_jumper,{
	team: "enemy",
	identity: "jumper",
	ai_controlled: true
})