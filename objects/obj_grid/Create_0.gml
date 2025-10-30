if (team != "friendly" && team != "enemy") || !generate_walls {
	exit;	
}
var tM = (team == "friendly")?bbox_left:bbox_right -GRIDSPACE,
gridVar = tag;
for (var g = 0; g <= floor((bbox_bottom -bbox_top -1)/GRIDSPACE); g++) {
	instance_create_layer(tM,bbox_top +g*GRIDSPACE,"Instances",obj_hero_wall, {			
		team: team,
		piece_on_grid: gridVar,
		grid_pos: [(tM -bbox_left)/GRIDSPACE,g],
		tag: string(other.tag) +"-" +string(g), 
	});
}