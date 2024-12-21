var gS = global.grid_spacing
if phase > 4 {
	if phase > 4.25 && global.level == [1,2] {
		instance_create_layer(1024,384 +gS*(irandom_range(-1,1)),"Instances",obj_drooper, {
			ai_controlled: true,	
			team: "enemy",
			identity: "drooper"
		});
	} else {
		instance_create_layer(1024,384 +gS*(irandom_range(-1,1)),"Instances",obj_crawler, {
			ai_controlled: true,	
			team: "enemy",
			identity: "crawler"
		});
	}
}