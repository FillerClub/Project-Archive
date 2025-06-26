randomize();
initialize_variables(true);

load_file(SAVEFILE);
load_file(PROFILE);

if !global.first_boot {
	game_boot(INSTANT);
} else {
	instance_create_layer(room_width/2,room_height/2,"Instances",obj_disclaimer_text);
}