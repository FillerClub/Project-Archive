if obj_game.on_pause_menu {
	music_pause_fade = max(music_pause_fade -500*delta_time*DELTA_TO_FRAMES,500);
} else {
	music_pause_fade = min(music_pause_fade +500*delta_time*DELTA_TO_FRAMES,22000);
}
soundtrack_bus.effects[0].cutoff = music_pause_fade;

soundtrack_bus.gain = global.music_volume;