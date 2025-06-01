enum GROUNDTYPE {
	NORMAL = 0,
	WATER = 1,
}

if team != "friendly" && team != "enemy" {
	exit;	
}
var tM = (team == "friendly")?bbox_left:bbox_right -GRIDSPACE;
for (var g = 0; g <= floor((bbox_bottom -bbox_top -1)/GRIDSPACE); g++) {
	instance_create_layer(tM,bbox_top +g*GRIDSPACE,"Instances",obj_hero_wall, {			
		team: team,
	});
}
