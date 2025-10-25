// Load from save data
load_file(SAVEFILE);
load_file(PROFILE);
target_room = noone;
for (var i = 0; i < array_length(load); i++) {
	audio_group_load(load[i]);
}