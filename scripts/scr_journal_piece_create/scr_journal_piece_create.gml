function journal_piece_create(name){
	var lookupName = piece_database(name,"name");
	
	if lookupName != "debug" {
		var obj = piece_database(name,"object");
		instance_destroy(obj_generic_piece);
		instance_create_layer(384,192,"Instances",obj, {
		identity: name,
		team: global.player_team,
		place_sound: "nothing",
		destroy_sound: "nothing",
		display_mode: true,
		execute: "move"
		});	
	}
}