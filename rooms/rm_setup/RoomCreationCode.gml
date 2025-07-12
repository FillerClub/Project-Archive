randomize();
initialize_variables(true);
audio_group_load(sound_effects);
audio_group_load(standalone_soundtracks);
audio_group_load(track1);
audio_group_load(track2);
audio_group_load(track3);
audio_group_load(track4);
load_file(SAVEFILE);
load_file(PROFILE);

if !global.first_boot {
	game_boot(INSTANT);
} else {
	instance_create_layer(room_width/2,room_height/2,"Instances",obj_disclaimer_text);
}