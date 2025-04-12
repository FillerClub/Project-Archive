function journal_piece_create(name){
	var lookupName = piece_database(name,PIECEDATA.NAME);
	
	if lookupName != "debug" {
		var obj = piece_database(name,PIECEDATA.OBJECT);
		instance_destroy(obj_generic_piece);
		instance_create_layer(384,192,"Instances",obj, {
		identity: name,
		team: global.team,
		place_sound: "nothing",
		destroy_sound: "nothing",
		display_mode: true,
		execute: "move"
		});	
	}
}