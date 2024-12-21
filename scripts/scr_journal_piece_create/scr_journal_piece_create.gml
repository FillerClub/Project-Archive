function journal_piece_create(name){
	var lookupName = refer_database(name,NAME);
	
	if lookupName != "debug" {
		audio_stop_sound(snd_put_down);
		var obj = refer_database(name,OBJECT);
		instance_destroy(obj_generic_piece);
		instance_create_layer(384,192,"Instances",obj, {
		identity: name,
		team: global.team,
		place_sound: "nothing",
		display_mode: true,
		execute: "move"
		});	
	}
}