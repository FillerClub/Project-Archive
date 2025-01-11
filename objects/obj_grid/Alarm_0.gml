var gD = global.grid_dimensions;

with obj_generic_hero {
	var tM = (team == "friendly")?0:1;
	for (var g = 0; g <= (gD[3]-gD[2])/GRIDSPACE; g++) {
		instance_create_layer(gD[tM],gD[2] +g*GRIDSPACE,"Instances",obj_hero_wall, {			
			team: team,
		});
	}
	var teaM = team;
}