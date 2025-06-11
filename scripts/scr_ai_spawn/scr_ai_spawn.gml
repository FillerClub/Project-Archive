function ai_spawn(spawn_x_offset,spawn_y_offset,spawn_actual){
var
gridRef = noone;
with obj_grid {
	if team == "enemy" {
		gridRef = self;
	}
}
var
obj = piece_database(spawn_actual,PIECEDATA.OBJECT),
cost = piece_database(spawn_actual,PIECEDATA.PLACECOST);
instance_create_layer(gridRef.bbox_right -abs(spawn_x_offset*GRIDSPACE) -GRIDSPACE,gridRef.bbox_top +spawn_y_offset*GRIDSPACE,"Instances",obj,{
	identity: spawn_actual,
	team: "enemy",
	ai_controlled: true
});
global.opponent_turns -= cost;
}