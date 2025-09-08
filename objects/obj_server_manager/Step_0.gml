if running_matches <= 0 {
	match_index = 0;	
}
x = match_index*1280 -1280 +oX;
if keyboard_check(vk_escape) {
	exit_timer += delta_time*DELTA_TO_SECONDS;
} else {
	exit_timer = 0;
}	

if exit_timer >= 2 {
	game_end();	
}
var arPlay = array_length(players);