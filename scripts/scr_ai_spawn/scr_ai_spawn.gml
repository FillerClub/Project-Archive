function ai_spawn(spawn_x_offset,spawn_y_offset,spawn_actual){
var 
gD = global.grid_dimensions,
gS = GRIDSPACE,
obj = piece_database(spawn_actual,PIECEDATA.OBJECT),
cost = piece_database(spawn_actual,PIECEDATA.PLACECOST);
instance_create_layer(gD[1] -abs(spawn_x_offset*gS),gD[2] +spawn_y_offset*gS,"Instances",obj,{
	identity: spawn_actual,
	team: "enemy",
	ai_controlled: true
});
global.opponent_turns -= cost;
}